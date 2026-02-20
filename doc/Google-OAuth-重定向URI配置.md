# Google OAuth 重定向 URI 配置（解决 redirect_uri_mismatch）

## 只需在 Google Console 里添加一条 URI

在 [Google Cloud Console](https://console.cloud.google.com/) → **API 和凭据** → 打开你的 **OAuth 2.0 客户端 ID**（类型必须是 **“Web 应用”**）。

在 **“已获授权的重定向 URI”** 里添加**这一条**（可复制）：

```
http://localhost:8080/oauth2/google/callback
```

- iOS / 本机浏览器：直接用，无需额外配置。  
- **Android 模拟器**：需要先做一次端口转发，否则模拟器里的浏览器访问不到你电脑上的 8080。

## Android 模拟器必做：端口转发

每次启动模拟器后，在**电脑**上打开终端（PowerShell 或 CMD）执行**一次**：

```bash
adb reverse tcp:8080 tcp:8080
```

这样模拟器里的 `localhost:8080` 会指向你电脑上的后端，Google 登录回调才能打开。**不执行这一步会出现 “This site can't be reached / localhost refused to connect / ERR_CONNECTION_REFUSED”。**

**检查是否生效**：执行后，在模拟器里打开浏览器访问 `http://localhost:8080`，应能打开你后端的页面；若仍打不开，请确认 (1) 后端已启动并监听 8080，(2) 再执行一次 `adb reverse tcp:8080 tcp:8080`。

## 若出现 “localhost refused to connect”

1. **确认后端已启动**：在电脑浏览器打开 `http://localhost:8080`，能访问说明后端正常。  
2. **执行端口转发**：在电脑终端执行 `adb reverse tcp:8080 tcp:8080`（模拟器已启动）。  
3. 再在模拟器里重试 Google 登录。

## 注意

1. URI 不要多空格、不要改端口、不要加结尾的 `/`，必须是 **http**，端口 **8080**。  
2. 若仍报 redirect_uri_mismatch：看后端控制台日志里的 `redirect_uri=`，把那一整串原样加到 Google Console。  
3. 保存后等 1～2 分钟再重试登录。
