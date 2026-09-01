# 云构建（CI）指南

本地不需要安装 Android SDK / JDK 也能构建和上架。仓库已包含两套 CI 配置：

- `codemagic.yaml`（推荐，Android + iOS）
- `.github/workflows/build-android.yml` / `build-ios.yml`（GitHub Actions 备选）

## 方案 A：Codemagic（推荐）

1. 把仓库推到 GitHub / GitLab / Bitbucket。
2. 在 [codemagic.io](https://codemagic.io) 添加项目（免费额度每月 500 分钟）。
3. 在 Codemagic 的 Environment variables 里新建两个组：
   - **android_signing**：
     - `ANDROID_KEYSTORE_BASE64`（keystore 文件 base64 后的内容）
     - `ANDROID_KEYSTORE_PASSWORD`
     - `ANDROID_KEY_ALIAS`
     - `ANDROID_KEY_PASSWORD`
     - `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS`（Play Console 服务账号 JSON，用于自动发布到内部测试轨道，可选）
   - **appstore_credentials**（iOS 用）：
     - `APP_STORE_CONNECT_PRIVATE_KEY`、`APP_STORE_CONNECT_KEY_IDENTIFIER`、`APP_STORE_CONNECT_ISSUER_ID`
4. 运行 `android-build` 工作流 → 产出 AAB + APK（可下载发朋友）。
5. 运行 `ios-build` 工作流 → 自动上传 TestFlight。

## 方案 B：GitHub Actions

1. 把仓库推到 GitHub。
2. 在 Settings → Secrets and variables → Actions 添加：
   - Android：`ANDROID_KEYSTORE_BASE64`、`ANDROID_KEYSTORE_PASSWORD`、`ANDROID_KEY_ALIAS`、`ANDROID_KEY_PASSWORD`
   - iOS：`APPLE_ID`、`APPLE_APP_SPECIFIC_PASSWORD`（以及 App Store Connect API Key 文件 `appstore_api_key.json`）
3. 手动触发 `Build Android` / `Build iOS (TestFlight)` 工作流。

## Android 签名密钥（keystore）生成

首次需要生成一次上传密钥（一次性，之后一直用）：

```bash
keytool -genkeypair -v \
  -keystore keystore.jks -alias insurance \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -storepass <密码> -keypass <密码>
```

- 本地：把 `keystore.jks` 放到 `app/`，并创建 `app/key.properties`：
  ```
  storeFile=keystore.jks
  storePassword=你的密码
  keyAlias=insurance
  keyPassword=你的密码
  ```
- CI：把 keystore 转成 base64 填进 `ANDROID_KEYSTORE_BASE64`：
  ```bash
  base64 -w0 keystore.jks   # Linux/macOS
  ```
  （Windows 可用 PowerShell：`[Convert]::ToBase64String([IO.File]::ReadAllBytes("keystore.jks"))`）

> keystore 丢失将无法更新已上架的应用，务必备份到安全位置。

## iOS 上传凭证

1. [App Store Connect](https://appstoreconnect.apple.com) → Users and Access → Integrations → App Store Connect API。
2. 生成 API Key（App Manager 权限），下载 `.p8` 私钥。
3. 记录 Key ID 和 Issuer ID，连同私钥内容填入 CI 密钥。

## 常见问题

- 未配置密钥时，CI 仍会构建，但 APK 用 debug 签名，不能上架 Play（只能装到手机测试）。
- iOS 构建必须用 macOS 机器（Codemagic 提供；GitHub Actions 用 macos-15）。
- 每次改代码后推送，CI 重新构建即可；商店审核流程见 [PUBLISHING.md](PUBLISHING.md)。
