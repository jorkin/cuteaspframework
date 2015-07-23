# Functions #

_使用方法：(直接使用)_

**[echo(string)](echo.md)** _输出文本_

**[die(string)](die.md)** _输出文本后结束_

**[isset(object)](isset.md)** _判断对象是否为空_

**[isNumber(object)](isNumber.md)** _判断对象是否为数字_

**[locationHref(url)](locationHref.md)** _跳转页面_

**[locationReferer()](locationReferer.md)** _返回来源页_

**[alertRedirect(string,url)](alertRedirect.md)** _弹出信息后跳转_

**[alertBack(string)](alertBack.md)** _弹出信息后返回_

**[alertClose(string)](alertClose.md)** _弹出信息后关闭_

**[IIf(flag,return1,return2)](IIf.md)** _三元表达式_



# Common #

_使用方法：Cas._

  * **[ShowErr(string)](ShowErr.md)** _显示错误信息_

  * **[ShowException()](ShowException.md)** _显示异常_

  * **[CheckPostSource()](CheckPostSource.md)** _检验来源地址_

  * **[GetSystem()](GetSystem.md)** _获取客户端操作系统版本_

  * **[IsInstall(object)](IsInstall.md)** _检查组件是否已经安装_

  * **[NoBuffer()](NoBuffer.md)** _禁用页面缓存_

  * **[Rand(min,max)](Rand.md)** _取随机数_

  * **[RandStr(length)](RandStr.md)** _取随机字符串_

  * **[rq(RequestType,Name,dataType,Default)](rq.md)** _安全获取参数_

  * **[Form(element)](Form.md)** 

  * **[Safe(string)](Safe.md)** _过滤非法字符_

  * **[CurrentURL()](CurrentURL.md)** _获取当前URL_

  * **[RefererURL()](RefererURL.md)** _获取来源URL_

  * **[GetIP()](GetIP.md)** _获取IP_

  * **[GetSelfName()](GetSelfName.md)** _获取当前访问文件名_

  * **[ReturnObj()](ReturnObj.md)** _返回空对象_

  * **[EncodeJP(string)](EncodeJP.md)** _转换日文字符_

  * **[HtmlEncode(string)](HtmlEncode.md)** _HTML编码_

  * **[HtmlDecode(string)](HtmlDecode.md)** _HTML解码_

  * **[UrlDecode(url)](UrlDecode.md)** _URL解码_

  * **[SetQueryString(string:RequestQueryString, ParamName, Value)](SetQueryString.md)** _重置URL参数_

  * **[GetGUID()](GetGUID.md)** _生成GUID_


# Library #

_使用方法：Cas.类名_

**[Arrays](Arrays.md)** _数组类_

  * **[Max(arr)](Max.md)** _取最大值_

  * **[Min(arr)](Min.md)** _取最小值_

  * **[UnShift(arr,var)](UnShift.md)** _从前压入元素_

  * **[Shift(arr)](Shift.md)** _从前删除元素_

  * **[Push(arr,var)](Push.md)** _从后压入元素_

  * **[Pop(arr)](Pop.md)** _从后删除元素_

  * **[Strip(str)](Strip.md)** _去除多余逗号后转成数组_

  * **[Walk(arr,callback)](Walk.md)** _对数组内元素执行函数后返回新数组_

  * **[Splice(arr,start,final)](Splice.md)** _从一个数组中移除一个或多个元素_

  * **[Fill(arr,index,value)](Fill.md)** _在指定位置插入元素_

  * **[Unique(arr)](Unique.md)** _移除重复的元素_

  * **[Reverse(arr)](Reverse.md)** _数组反向_

  * **[Search(arr,value)](Search.md)** _搜索元素_

  * **[Rand(arr,num)](Rand.md)** _随机取元素_

  * **[Sort(arr)](Sort.md)** _顺序排序_

  * **[rSort(arr)](rSort.md)** _倒序排序_

  * **[Shuffle(arr)](Shuffle.md)** _随机排序_

  * **[ConvComma(string)](ConvComma.md)** _编码元素中的逗号_

  * **[ToString(arr)](ToString.md)** _数组转字符串_

  * **[ToArray(string)](ToArray.md)** _字符串转数组_

**[Cache](Cache.md)** _缓存类_

  * _[Constructor(name)](Constructor.md)_ _等同于Get_

  * **[Mark](Mark.md)** _设置前缀_

  * **[Timeout](Timeout.md)** _设置超时时间_

  * **[Lock()](Lock.md)** 

  * **[UnLock()](UnLock.md)** 

  * **[Set(Key,Value,Expire)](Set.md)** _存缓存_

  * **[Get(Key)](Get.md)** _取缓存_

  * **[Remove(Key)](Remove.md)** _删除指定缓存_

  * **[RemoveAll()](RemoveAll.md)** _清空所有缓存_

  * **[Compare(Key1, Key2)](Compare.md)** _比较指定缓存_

**[Cookie](Cookie.md)** _Cookie类_

  * _[Constructor(name)](Constructor.md)_ _等同于Get_

  * **[Mark](Mark.md)** _设置前缀_

  * **[Set(Key,Value,array:options)](set.md)** _存Cookie_

  * **[Get(Key)](get.md)** _取Cookie_

  * **[Remove(Key)](Remove.md)** _删除指定Cookie_

  * **[RemoveAll()](RemoveAll.md)** _清空所有Cookie_

  * **[Compare(Key1, Key2)](Compare.md)** _比较指定Cookie_

**[Session](Session.md)** _Session类_

  * _[Constructor(name)](Constructor.md)_ _等同于Get_

  * **[Mark](Mark.md)** _设置前缀_

  * **[Timeout](Timeout.md)** _设置超时时间_

  * **[Set(Key,Value)](Set.md)** _存Session_

  * **[Get(Key)](Get.md)** _取Session_

  * **[Remove(Key)](Remove.md)** _删除指定Session_

  * **[RemoveAll()](RemoveAll.md)** _清空所有Session_

  * **[Compare(Key1,Key2)](Compare.md)** _比较指定Session_

**[Date](Date.md)** _时间类_

  * **[TimeZone](TimeZone.md)** _设置时区_

  * **[ToGMTdate(date)](ToGMTdate.md)** _本地时间转GMT时间_

  * **[ToUnixEpoch(date)](ToUnixEpoch.md)** _获取时间戳_

  * **[FromUnixEpoch(date)](FromUnixEpoch.md)** _时间戳转本地时间_

  * **[Format(date,format)](Format.md)** _格式化时间_

  * **[Zodiac(date)](Zodiac.md)** _获取生肖_

  * **[Constellation(date)](Constellation.md)** _获取星座_

**[Debug](Debug.md)** _Debug类_

  * **[Open()](Open.md)** _打开Debug_

  * **[Close()](Close.md)** _关闭Debug_

  * **[Add(var)](Add.md)** _添加监听_

  * **[Show()](Show.md)** _显示监听_

**[String](String.md)** _字符串操作类_

  * **[Length(string)](Length.md)** _计算字符串长度_

  * **[Cut(string,length,isEnd)](Cut.md)** _截断字符串_

  * **[KeyWordLight(string, regex)](KeyWordLight.md)** _高亮字符串_

  * **[Validate(string,type)](Validate.md)** _正则验证字符串格式_

  * **[TextToHtml(string)](TextToHtml.md)** _文本转HTML_

  * **[HtmlToJs(string)](HtmlToJs.md)** _HTML格式化成JS_

  * **[StripHTML(string)](StripHTML.md)** _过滤HTML_

  * **[RegexpReplace(string,regex,replacestring,isCase)](RegexpReplace.md)** _正则替换_

  * **[Test(string,regex,isCase)](Test.md)** _正则匹配_

  * **[Trim(string)](Trim.md)** _去除前后空白_

  * **[LTrim(string)](LTrim.md)** _去除前置空白_

  * **[RTrim(string)](RTrim.md)** _去除后置空白_

**[Params](Params.md)** _字典类_

  * _[Constructor(object)](Constructor.md)_ _实例化一个新的字典对象_

  * **[Close()](Close.md)** _释放对象_

**[Page](Page.md)** _分页类_

  * **[PageProcedure](PageProcedure.md)** _设置分页存储过程_

  * **[Conn](Conn.md)** _设置数据库连接_

  * **[Size](Size.md)** _设置每页显示条数_

  * **[PageID](PageID.md)** _设置当前页码_

  * **[PageCount](PageCount.md)** _获取总页数_

  * **[RecordCount](RecordCount.md)** _获取总条数_

  * **[GetSqlString](GetSqlString.md)** _显示最终查询Sql_

  * **[Header\_a(Recordset,Table,Fields,Where,Group,Sort)](Header_a.md)** _简单分页函数_

  * **[Header\_b(Recordset,Table,Fields,Where,Group,Sort)](Header_b.md)** _sql2000分页函数_

  * **[Header\_c(Recordset,Table,Fields,Where,Group,Sort)](Header_c.md)** _sql2005分页函数_

  * **[Footer\_a(string,string type)](Footer_a.md)** _分页标准页脚_

  * **[Footer\_b(string,string type)](Footer_b.md)** _分页数字页脚_

**[Db](Db.md)** _数据库操作类_

  * **[Conn](Conn.md)** _数据库连接对象_

  * **[ServerIp](ServerIp.md)** _设置数据库IP_

  * **[ConnectionType](ConnectionType.md)** _设置数据库类型(MSSQL|ACCESS)_

  * **[Username](Username.md)** _设置连接用户名_

  * **[Password](Password.md)** _设置连接密码_

  * **[Open()](Open.md)** _连接数据库_

  * **[Close()](Close.md)** _释放连接_

  * **[CloseRs(Recordset)](CloseRs.md)** _释放指定数据集_

  * **[SetRs(Recordset, sql, CursorAndLockType)](SetRs.md)** _生成数据集(可设置可写)_

  * **[Exec(Recordset, sql)](Exec.md)** _执行Sql并生成数据集(只读)_

  * **[BeginTrans()](BeginTrans.md)** _打开事务_

  * **[RollBackTrans()](RollBackTrans.md)** _回滚事务_

  * **[CommitTrans()](CommitTrans.md)** _提交事务_

  * **[GetRowObject(Dictionary,Recordset|string)](GetRowObject.md)** _获取数据集并转成字典对象_

  * **[Insert(Table,Params)](Insert.md)** _插入数据_

  * **[Update(Table,(#)](Update.md)** _Params,Where) -- 更新数据(参数名前有#表示累加)_

  * **[ExecuteRecordSet(commandName,params)](ExecuteRecordSet.md)** _执行存储过程并返回数据集_

  * **[ExecuteScalar(commandName,params)](ExecuteScalar.md)** _执行存储过程并返回单行数据_

  * **[ExecuteReturnValue(commandName,params)](ExecuteReturnValue.md)** _执行存储过程并返回值_

  * **[ExecuteNonQuery(commandName,params)](ExecuteNonQuery.md)** _执行存储过程不返回内容_

  * **[ExecuteRecordsetAndValue(commandName,params)](ExecuteRecordsetAndValue.md)** _执行存储过程返回值并返回数据集_

**[File](File.md)** _文件类_

  * **[FSO](FSO.md)** _设置FSO组件名称_

  * **[Stream](Stream.md)** _设置Stream组件名称_

  * **[Charset](Charset.md)** _设置字符集_

  * **[GetFileTypeName(filename)](GetFileTypeName.md)** _获取文件类型_

  * **[CheckFileExt(file,ext)](CheckFileExt.md)** _检验文件类型_

  * **[FormatFileSize(size,point)](FormatFileSize.md)** _格式化文件大小_

  * **[GetFileSize(size)](GetFileSize.md)** _获取文件大小_

  * **[GetFolderSize(size)](GetFolderSize.md)** _获取文件夹大小_

  * **[IsFolderExists(folderpath)](IsFolderExists.md)** _检验文件夹是否存在_

  * **[IsFileExists(filepath)](IsFileExists.md)** _检验文件是否存在_

  * **[CreatePath(folderpat)](CreatePath.md)** _创建文件夹_

  * **[DelFolder(folderpath)](DelFolder.md)** _删除文件夹_

  * **[DelFile(filepath)](DelFile.md)** _删除文件_

  * **[LoadFile(filepath)](LoadFile.md)** _读取文件_

  * **[SaveFile(filepath,content)](SaveFile.md)** _保存文件_

  * **[CopyFolder(filepath1,filepath2)](CopyFolder.md)** _复制文件夹_

  * **[CopyFile(filepath1,filepath2)](CopyFile.md)** _复制文件_

  * **[LoadIncludeFiles(path,extlist[string](LoadIncludeFiles.md))]** _读取文件目录_

  * **[RemoveUtf8bom(filepath)](RemoveUtf8bom.md)** _删除UTF-8签名_

**[Upload](Upload.md)** _上传类_

  * **[MaxSize](MaxSize.md)** _设置单个文件最大上传大小_

  * **[TotalSize](TotalSize.md)** _设置最大总上传大小_

  * **[Mode](Mode.md)** _设置上传方式(1.aspupload;2.fso)_

  * **[SavePath](SavePath.md)** _设置上传路径_

  * **[Charset](Charset.md)** _设置字符集_

  * **[AutoSave](AutoSave.md)** _设置保存模式(0.自动取名并保存;1.取源文件名自动保存;2.Open之后用Save/GetData方法手动保存)_

  * **[UpCount)](UpCount.md)** _查看需要上传几个文件_

  * **[FormItem](FormItem.md)** _保存Post表单中文本域名称的数组(下标从1开始)_

  * **[FileItem](FileItem.md)** _保存Post表单中文件域名称的数组(下标从1开始)_

  * **[Close()](Close.md)** _释放对象_

  * **[Open()](Open.md)** _打开对象，开始上传_

  * **[Save(Item, filepath)](Save.md)** _保存表单中 file 域上传的文件(0.自动取名;1.取源文件名;string.自定义文件名)_

  * **[GetData()](GetData.md)** _返回表单中 file 域上传的文件数据流_

  * **[Form(Item)](Form.md)** _返回表单中各类域提交(上传)的文本(文件)信息_


# Helper #

_使用方法：Cas.类名_

**[Md5](Md5.md)** _MD5加密_

**[Json](Json.md)** _Json操作类_

**[Xml](Xml.md)** _XML操作类_

**[ValidCode](ValidCode.md)** _验证码_

**[InterFace](InterFace.md)** _接口调用类_

**[SHA1](SHA1.md)** _SHA1加密_

**[Des](Des.md)** _Des加解密_

**[Export](Export.md)** _Excel导出_

**[Email](Email.md)** _邮件发送_