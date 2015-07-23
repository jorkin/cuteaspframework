_使用方法：Casp.Xml._

  * **[XmlDom](XmlDom.md)** _XML对象_

  * **[Open(xmlSourceFile)](Open.md)** _开打一个已经存在的XML文件,返回打开状态_

  * **[Close()](Close.md)** _关闭对象_

  * **[XmlSource](XmlSource.md)** _获取XML内容_

  * **[ChildNode(ElementOBJ,ChildNodeObj,IsAttributeNode)](ChildNode.md)** _返回一个子节点对象,ElementOBJ为父节点,ChildNodeObj要查找的节点,IsAttributeNode指出是否为属性对象_

  * **[Create(RootElementName,XslUrl)](Create.md)** _建立一个XML文件，RootElementName：根结点名。XSLURL：使用XSL样式地址，返回根结点_

  * **[InsertElement(BefelementOBJ,ElementName,ElementText,IsFirst,IsCDATA)](InsertElement.md)** _插入在BefelementOBJ下面一个名为ElementName，Value为ElementText的子节点。_

> _IsFirst：是否插在第一个位置；IsCDATA：说明节点的值是否属于CDATA类型_
> _插入成功就返回新插入这个节点_
> _BefelementOBJ可以是对象也可以是节点名，为空就取当前默认对象_

  * **[SetAttributeNode(ElementOBJ,AttributeName,AttributeText)](SetAttributeNode.md)** _在ElementOBJ节点上插入或修改名为AttributeName，值为：AttributeText的属性_

> _如果已经存在名为AttributeName的属性对象，就进行修改。_
> _返回插入或修改属性的Node_
> _ElementOBJ可以是Element对象或名，为空就取当前默认对象_

  * **[UpdateNodeText(ElementOBJ,NewElementText,IsCDATA)](UpdateNodeText.md)** _修改ElementOBJ节点的Text值，并返回这个节点_

  * **[GetNodeText(NodeOBJ)](GetNodeText.md)** _读取一个NodeOBJ的节点Text的值_

  * **[GetElementNode(ElementName,testValue)](GetElementNode.md)** _返回符合testValue条件的第一个ElementNode，为空就取当前默认对象_

  * **[RemoveChild(ElementOBJ)](RemoveChild.md)** _删除一个子节点_

  * **[ClearNode(ElementOBJ)](ClearNode.md)** _清空一个节点所有子节点_

  * **[RemoveAttributeNode(ElementOBJ,AttributeOBJ)](RemoveAttributeNode.md)** _删除子节点的一个属性_

  * **[Save()](Save.md)** _保存打开过的文件，只要保证FileName不为空就可以实现保存_

  * **[SaveAs(SaveFileName)](SaveAs.md)** _另存为XML文件，只要保证FileName不为空就可以实现保存_

  * **[ErrInfo](ErrInfo.md)** _读取最后的错误信息_