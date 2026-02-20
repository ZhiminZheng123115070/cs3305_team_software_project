'use strict'
const path = require('path')

function resolve(dir) {
  return path.join(__dirname, dir)
}

const CompressionPlugin = require('compression-webpack-plugin')

const name = process.env.VUE_APP_TITLE || 'RuoYi Management System' // Web page title

const baseUrl = 'http://localhost:8080' // Backend API

const port = process.env.port || process.env.npm_config_port || 80 // Port

// vue.config.js configuration instructions
// Official vue.config.js reference documentation https://cli.vuejs.org/zh/config/#css-loaderoptions
// Only part of the configuration is listed here, refer to the documentation for specific configuration
module.exports = {
  // URL for production and development environments.
  // By default, Vue CLI assumes your application is deployed at the root path of a domain
  // For example https://www.ruoyi.vip/. If the application is deployed in a subpath, you need to specify this subpath with this option. For example, if your application is deployed at https://www.ruoyi.vip/admin/, set baseUrl to /admin/.
  publicPath: process.env.NODE_ENV === "production" ? "/" : "/",
  // Directory name for generated files when running npm run build or yarn build (must match the production environment path of baseUrl) (default: dist)
  outputDir: 'dist',
  // Directory for generated static resources (js, css, img, fonts); (after project packaging, static resources will be placed in this folder)
  assetsDir: 'static',
  // If you don't need production source maps, you can set this to false to speed up production builds.
  productionSourceMap: false,
  transpileDependencies: ['quill'],
  // webpack-dev-server related configuration
  devServer: {
    host: '0.0.0.0',
    port: port,
    open: true,
    proxy: {
      // detail: https://cli.vuejs.org/config/#devserver-proxy
      [process.env.VUE_APP_BASE_API]: {
        target: baseUrl,
        changeOrigin: true,
        pathRewrite: {
          ['^' + process.env.VUE_APP_BASE_API]: ''
        }
      },
      // springdoc proxy
      '^/v3/api-docs/(.*)': {
        target: baseUrl,
        changeOrigin: true
      }
    },
    disableHostCheck: true
  },
  css: {
    loaderOptions: {
      sass: {
        sassOptions: { outputStyle: "expanded" }
      }
    }
  },
  configureWebpack: {
    name: name,
    resolve: {
      alias: {
        '@': resolve('src')
      }
    },
    plugins: [
      // http://doc.ruoyi.vip/ruoyi-vue/other/faq.html#using-gzip-to-decompress-static-files (Using gzip to decompress static files)
      new CompressionPlugin({
        cache: false,                                  // Do not enable file cache
        test: /\.(js|css|html|jpe?g|png|gif|svg)?$/i,  // Compressed file format
        filename: '[path][base].gz[query]',            // Compressed file name
        algorithm: 'gzip',                             // Use gzip compression
        minRatio: 0.8,                                 // Compression ratio, files smaller than 80% will not be compressed
        deleteOriginalAssets: false                    // Delete original files after compression
      })
    ],
  },
  chainWebpack(config) {
    config.plugins.delete('preload') // TODO: need test
    config.plugins.delete('prefetch') // TODO: need test

    // set svg-sprite-loader
    config.module
      .rule('svg')
      .exclude.add(resolve('src/assets/icons'))
      .end()
    config.module
      .rule('icons')
      .test(/\.svg$/)
      .include.add(resolve('src/assets/icons'))
      .end()
      .use('svg-sprite-loader')
      .loader('svg-sprite-loader')
      .options({
        symbolId: 'icon-[name]'
      })
      .end()

    config.when(process.env.NODE_ENV !== 'development', config => {
          config
            .plugin('ScriptExtHtmlWebpackPlugin')
            .after('html')
            .use('script-ext-html-webpack-plugin', [{
            // `runtime` must same as runtimeChunk name. default is `runtime`
              inline: /runtime\..*\.js$/
            }])
            .end()

          config.optimization.splitChunks({
            chunks: 'all',
            cacheGroups: {
              libs: {
                name: 'chunk-libs',
                test: /[\\/]node_modules[\\/]/,
                priority: 10,
                chunks: 'initial' // only package third parties that are initially dependent
              },
              elementUI: {
                name: 'chunk-elementUI', // split elementUI into a single package
                test: /[\\/]node_modules[\\/]_?element-ui(.*)/, // in order to adapt to cnpm
                priority: 20 // the weight needs to be larger than libs and app or it will be packaged into libs or app
              },
              commons: {
                name: 'chunk-commons',
                test: resolve('src/components'), // can customize your rules
                minChunks: 3, //  minimum common number
                priority: 5,
                reuseExistingChunk: true
              }
            }
          })
          config.optimization.runtimeChunk('single')
    })
  }
}
