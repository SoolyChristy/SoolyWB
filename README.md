# SoolyWB
Swift编写的一款微博第三方客户端（目前实现：微博主页、发布微博、个人主页、表情键盘）
 - 遵循MVVM模式
 - 封装Alamofire利用微博开放平台，请求微博数据
 - 使用HandyJSON反序列化、序列化，使用Kingfisher加载网络图片
 - 主要使用xib开发界面

### 细节
 - 封装WBLabel 使用TextKit接管UILabel，满足微博 "@用户" "#话题#" "链接"的高亮以及交互
 - 使用CoreGraphics裁剪圆形图片、拉伸图片
