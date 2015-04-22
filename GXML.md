GXML

系统提供了一个XML解析器，用来通过XML实例化对象，就和FLEX的MXML相仿。
使用上用GXMLManager.instance.create(xmlString,spec)即可，spec是解析器实例，通常非显示对象使用ItemSpec，显示对象用DisplaySpec。它初始化时可以传入this来作为反射依据。xmlString就是XML对象。
使用上很明确，下面说的是转换方式。

和MXML一样，需要在XML里注册命名空间。比如要实例化
ghostcat.skin.ScrollUpButtonSkin这个类，就需要先定义xmlns:skin="ghostcat.skin"这个命名空间，然后就可以用

&lt;skin:ScrollUpButtonSkin&gt;

表示出来。属性值直接在XML里写好就可以，也可以写成XML的子项，以下是例子：
<skin:ScrollUpButtonSkin xmlns:skin="ghostcat.skin" xmlns:fi="flash.filters"
> id="button" x="50" y="50">
> 

&lt;filters&gt;


> > 

&lt;fi:BlurFilter blurX="4" blurY="4"/&gt;


> > 

&lt;fi:DropShadowFilter color="0x0000FF"/&gt;



> 

&lt;/filters&gt;




&lt;/skin:ScrollUpButtonSkin&gt;


数组类型属性必须像这样写成子项才能表示，如果数据内有简单类型，则用回车或者逗号分割


&lt;arr&gt;

1,2,3,4,5

&lt;/arr&gt;


但XML内无法区分简单类型，所以最后都会被当作字符串处理。

如果需要设置构造函数参数，则需要用constructor当成属性来表示


&lt;b:BlurFilter&gt;


> 

&lt;constructor&gt;

0,0

&lt;/constructor&gt;




&lt;/b:BlurFilter&gt;



如果使用的是DisplaySpec,显示对象里再写显示对象会被addChild。

高级部分：

ItemSpec之后的解析器都要求在构造中传入this，它的作用是什么呢？它是为了将XML的内部和调用解析器代码的外部联系起来。

比如，在XML里写上id="obj"属性，就会将实例化的结果转存到ths.obj上，就可以执行一次解析器便返回多个结果。

同样的，在属性中使用{}，诸如text="{t}"，text的值就会从this.t属性里寻找。当然也可以不用从this寻找，text="{RootManager.stage}"这样从静态类走也是可以的。但一定要注意{}应当在""内，否则走的是XML导入数据的方式，并不会是这样的结果。

写上on\_事件名，便会自动注册事件，依然是在this中查找对应属性名的函数。

基本上，这个和MXML只有一些写法上的不同。你也可以继承DisplaySpec重新增加功能，ItemSpec和DisplaySpec实际上代码都很少，重写时可以参考下。重写解析器的时候，只需要修改三个方法：

createObject（创建对象）
applyProperties（从父对象中获得初值，目前为止这个方法是空的）
addChild（添加到父对象中）

这样完成整个创建对象的流程即可。