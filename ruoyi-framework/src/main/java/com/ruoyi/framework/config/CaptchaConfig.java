package com.ruoyi.framework.config;

import java.util.Properties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import com.google.code.kaptcha.impl.DefaultKaptcha;
import com.google.code.kaptcha.util.Config;
import static com.google.code.kaptcha.Constants.*;

/**
 * Captcha configuration
 * 
 * @author ruoyi
 */
@Configuration
public class CaptchaConfig
{
    @Bean(name = "captchaProducer")
    public DefaultKaptcha getKaptchaBean()
    {
        DefaultKaptcha defaultKaptcha = new DefaultKaptcha();
        Properties properties = new Properties();
        // Whether to have border, default is true, we can set yes or no
        properties.setProperty(KAPTCHA_BORDER, "yes");
        // Captcha text character color, default is Color.BLACK
        properties.setProperty(KAPTCHA_TEXTPRODUCER_FONT_COLOR, "black");
        // Captcha image width, default is 200
        properties.setProperty(KAPTCHA_IMAGE_WIDTH, "160");
        // Captcha image height, default is 50
        properties.setProperty(KAPTCHA_IMAGE_HEIGHT, "60");
        // Captcha text character size, default is 40
        properties.setProperty(KAPTCHA_TEXTPRODUCER_FONT_SIZE, "38");
        // KAPTCHA_SESSION_KEY
        properties.setProperty(KAPTCHA_SESSION_CONFIG_KEY, "kaptchaCode");
        // Captcha text character length, default is 5
        properties.setProperty(KAPTCHA_TEXTPRODUCER_CHAR_LENGTH, "4");
        // Captcha text font style, default is new Font("Arial", 1, fontSize), new Font("Courier", 1, fontSize)
        properties.setProperty(KAPTCHA_TEXTPRODUCER_FONT_NAMES, "Arial,Courier");
        // Image style: WaterRipple com.google.code.kaptcha.impl.WaterRipple, FishEye com.google.code.kaptcha.impl.FishEyeGimpy, Shadow com.google.code.kaptcha.impl.ShadowGimpy
        properties.setProperty(KAPTCHA_OBSCURIFICATOR_IMPL, "com.google.code.kaptcha.impl.ShadowGimpy");
        Config config = new Config(properties);
        defaultKaptcha.setConfig(config);
        return defaultKaptcha;
    }

    @Bean(name = "captchaProducerMath")
    public DefaultKaptcha getKaptchaBeanMath()
    {
        DefaultKaptcha defaultKaptcha = new DefaultKaptcha();
        Properties properties = new Properties();
        // Whether to have border, default is true, we can set yes or no
        properties.setProperty(KAPTCHA_BORDER, "yes");
        // Border color, default is Color.BLACK
        properties.setProperty(KAPTCHA_BORDER_COLOR, "105,179,90");
        // Captcha text character color, default is Color.BLACK
        properties.setProperty(KAPTCHA_TEXTPRODUCER_FONT_COLOR, "blue");
        // Captcha image width, default is 200
        properties.setProperty(KAPTCHA_IMAGE_WIDTH, "160");
        // Captcha image height, default is 50
        properties.setProperty(KAPTCHA_IMAGE_HEIGHT, "60");
        // Captcha text character size, default is 40
        properties.setProperty(KAPTCHA_TEXTPRODUCER_FONT_SIZE, "35");
        // KAPTCHA_SESSION_KEY
        properties.setProperty(KAPTCHA_SESSION_CONFIG_KEY, "kaptchaCodeMath");
        // Captcha text generator
        properties.setProperty(KAPTCHA_TEXTPRODUCER_IMPL, "com.ruoyi.framework.config.KaptchaTextCreator");
        // Captcha text character spacing, default is 2
        properties.setProperty(KAPTCHA_TEXTPRODUCER_CHAR_SPACE, "3");
        // Captcha text character length, default is 5
        properties.setProperty(KAPTCHA_TEXTPRODUCER_CHAR_LENGTH, "6");
        // Captcha text font style, default is new Font("Arial", 1, fontSize), new Font("Courier", 1, fontSize)
        properties.setProperty(KAPTCHA_TEXTPRODUCER_FONT_NAMES, "Arial,Courier");
        // Captcha noise color, default is Color.BLACK
        properties.setProperty(KAPTCHA_NOISE_COLOR, "white");
        // Noise implementation class
        properties.setProperty(KAPTCHA_NOISE_IMPL, "com.google.code.kaptcha.impl.NoNoise");
        // Image style: WaterRipple com.google.code.kaptcha.impl.WaterRipple, FishEye com.google.code.kaptcha.impl.FishEyeGimpy, Shadow com.google.code.kaptcha.impl.ShadowGimpy
        properties.setProperty(KAPTCHA_OBSCURIFICATOR_IMPL, "com.google.code.kaptcha.impl.ShadowGimpy");
        Config config = new Config(properties);
        defaultKaptcha.setConfig(config);
        return defaultKaptcha;
    }
}
