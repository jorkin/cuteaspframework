经过 3 天的全天奋战，把 Cute ASP Framework v3.9 完成了，这次算是一次比较完善的升级，不论是性能、还是易用性，以及文档的完整性，特别还为 CuteASP 制作了相应的 Dreamweaver 扩展，让开发速度更上了一个台阶。

框架主要的更新：

  * Tpub 更名为 Casp

  * 优化 Casp.String.RegExpReplace 并更名为 Casp.String.Replace

  * 删除 Casp.BasicEncode 类

  * 添加 Casp.String.Test 方法

  * 为了与Session统一，Casp.Cache.Expires 更名为 Casp.Cache.Timeout

  * 添加了 Casp.Session.Compare 和 Casp.Cookie.Compare 方法

  * 添加了 Casp.WebConfig 节点，用于配置站点参数

  * 添加三个默认站点参数：

> Casp.WebConfig(“CodePage”) —— 站点编码

> Casp.WebConfig(“Charset”) —— 站点字符集

> Casp.WebConfig(“FilterWord”) —— 过滤字符

  * 添加了 interface.asp 接口文件，方便调用 Ajax 接口。

  * 修复部分 Bug

预告一下 v4.0 吧，预计主要的更新：

  * 添加模板类

  * 完善 Helper 的类库

代码下载：http://code.google.com/p/cuteaspframework/downloads/list

DW扩展下载：[CuteASP.For.Dreamweaver.zip](http://cuteaspframework.googlecode.com/files/CuteASP.V0.1.For.Dreamweaver.zip)

文档：http://code.google.com/p/cuteaspframework/wiki/Documents


PS:感谢 Samasra(http://www.wings26.com) 设计的logo

![http://terran.cc/cuteaspframework/help/resource/images/logo.jpg](http://terran.cc/cuteaspframework/help/resource/images/logo.jpg)