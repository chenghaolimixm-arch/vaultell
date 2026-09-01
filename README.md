# Insurance Profile App

一个**纯本地优先（local-first）**的澳洲个人保险管理 App。用户把车辆、房产、宠物、健康保险信息录入一次，App 在本地记住，并在续保（renewal）前提醒，帮助用户对比报价、看懂保单变化。

## 核心原则

- **数据只存在用户手机上**（SQLite + 本地加密），不上传服务器。
- 覆盖 5 类保险：**车险 / 房屋险 / 房东险 / 健康险 / 宠物险**。
- 除健康险外，每个险种支持**多份保单**（多辆车、多套房产、多只宠物）。
- 内置 **18 家澳洲保险公司目录**（CBA、Allianz、RSPCA、AAMI、Medibank 等），
  保单可归属到具体公司，详情页一键 **Make a Claim** 跳转官方理赔页面。
- **保单文件导入**：上传 PDF/图片，设备端自动识别保险公司、保费、excess、
  保额、续保日期并预填表单（本机处理，不上传）。
- **到期提醒**：保单到期前 30/15/7/3 天各提醒一次，续保更新后自动按新日期重排。
- **去年 vs 今年**：保费涨跌（金额 + 百分比）、车险 roadside/windscreen/车辆价值、
  房屋/房东险 building/contents/额外保额逐项对比。
- **App 锁**：生物识别/设备密码锁屏，开关持久化，重启后依然生效。
- **隐私与免责声明页**：本地存储说明、非保险建议声明、mock 报价声明。
- **文档管理 + 本地备份**：保单文件可打开/删除；一键导出 JSON 备份、导入恢复。
- MVP 阶段报价全部为 **mock 数据**，界面明确标注"示例数据，非真实保险公司报价"。
- 产品定位是"信息整理与比较"，不提供受监管的个人保险建议。

## 目录结构

```text
.
├── docs/                 # 规格、架构、隐私、路线图、上架指南
└── app/                  # Flutter 客户端（纯本地）
    ├── pubspec.yaml
    └── lib/
        ├── main.dart
        ├── app.dart
        ├── core/         # 数据库、主题、工具
        └── features/     # 钱包、保单、对比、设置
```

## 如何运行

本机已安装 Flutter 3.47.1（`C:\Users\david\flutter\flutter`）。

1. 安装 [Flutter SDK](https://docs.flutter.dev/get-started/install/windows)（3.47+）并加入 PATH（新机器）。
2. 进入 `app/`，安装依赖：

   ```powershell
   cd app
   flutter pub get
   ```

3. 运行：

   ```powershell
   flutter run
   ```

> 生成 iOS 构建需要 macOS/Xcode；Android 构建需要 Android Studio / Android SDK。
> Android/iOS 平台目录已生成；数据库代码（`*.g.dart`）已提交，日常开发无需重跑 build_runner。

### ⚠️ OneDrive 中文路径的已知问题

项目路径中的「文档」是非 ASCII 字符，会导致 Dart 的 AOT 代码生成（`build_runner`）和
`flutter analyze` 在部分场景失败。解决办法：把 `app/` 复制到英文临时目录（如
`C:\Users\david\AppData\Local\Temp\ipa_codegen`）生成代码后拷回，或直接使用已提交的
`*.g.dart` 文件。

## 文档索引

- [产品规格](docs/SPEC.md)
- [架构设计](docs/ARCHITECTURE.md)
- [隐私与安全](docs/PRIVACY.md)
- [完整隐私政策（英文，商店用）](docs/PRIVACY_POLICY.md)
- [路线图](docs/ROADMAP.md)
- [上架发布指南](docs/PUBLISHING.md)
