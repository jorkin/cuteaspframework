_使用方法：Casp.Json._

  * **[toResponse](toResponse.md)** _(bool)是否在转换后输出对象_

  * **[escape(val)](escape.md)** 

  * **[toJSON(Name, Val, nested)](toJSON.md)** _把对象转成JSON对象_

```
  'str = {
  '  "a":1,
  '  "b":{
  '    "b1":2
  '  }
  '}

  Casp.Json.toJSON(null,str,false) 
  'output:{"a": 1,"b": {"b1": 2}}'

  Casp.Json.toJSON("root",str,false) 
  'output:{"root": {"a": 1,"b": {"b1": 2}}}'

```