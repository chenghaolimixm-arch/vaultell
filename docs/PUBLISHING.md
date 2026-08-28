# 上架发布指南

## 1. 开发者账号

| 平台 | 账号 | 费用 |
|---|---|---|
| Apple Developer Program | [developer.apple.com](https://developer.apple.com) | 约 A$149/年 |
| Google Play Console | [play.google.com/console](https://play.google.com/console) | 一次性 US$25 |

## 2. 朋友测试

### iOS（TestFlight）

1. 在 Xcode 中用开发者账号签名 App。
2. 上传到 App Store Connect → TestFlight。
3. 内部测试：最多 100 人，无需审核，加 Apple ID 即可。
4. 外部测试：需要 Beta 审核，可发公开链接。

### Android（封闭测试）

1. Google Play Console → 创建应用 → 设置 → 正式版/测试版。
2. 建立"封闭测试"轨道，添加测试者邮箱。
3. 上传 AAB 包，审核通过后测试者可安装。

## 3. 正式发布

- App Store 审核：需隐私政策、截图、App 图标。
- Google Play：需隐私政策、数据安全表单（MVP 填"不收集数据"）。
- 纯本地 App 无账号、无服务器，不触发额外权限说明（除本地通知/生物识别需说明用途）。

## 4. 注意事项

- Mock 报价必须全界面标注"示例数据，非真实保险公司报价"，避免误导用户（商店审核红线）。
- 未来加入云端 AI / 备份后，必须先更新隐私标签与用户授权流程，再发版。
- iOS 构建只能在 macOS 上完成；Android 在 Windows 上即可。
