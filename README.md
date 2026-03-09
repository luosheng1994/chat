# Flutter Chat App Scaffold (OpenIM)

该仓库已完成首版脚手架：

- 复刻目标的整体信息架构（留言墙 / 联系人 / 聊天 / 发现 / 我的）
- 预置登录页（用户名、密码、图片验证码）与注册页（手机号、短信验证码、邀请码）
- 支持白天/夜间主题切换
- 预留免密体验流程（默认直接进入主界面）
- 集成 OpenIM SDK 初始化服务占位
- 预置通用 GET/POST 网络请求工具（Dio）

## 后续对接

你提供接口 URL 后，直接替换：

- `lib/src/core/network/http_client.dart` 的 `baseUrl`
- `lib/src/core/im/openim_service.dart` 的 `apiAddr/wsAddr`

然后逐步把页面中的静态示例数据替换为接口和 IM 实时数据。
