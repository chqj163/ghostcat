这是一个GhostCat的衍生品，可以导入下面的SWC独立使用。
http://code.google.com/p/ghostcat/source/browse/trunk/GhostCatMVC/bin/GhostCatMVC.swc

GhostCatMVC的使用成本非常低，它基本上只完成了通信方面的辅助，并没有任何强制性的措施。
使用方法很简单：首先，你需要为Model,Command,View分别建立不同的类（起码的……）
然后，在他们Class定义的上面标记上元标签，诸如Model就标上[M(name="test")]，Command就标记上[C(name="test")]，View就标记上[V(name="test")]
最后，在文档类（或者任何一个地方）用GhostCatMVC.instance.load(ClassName1,ClassName2,ClassName3,ClassName4...)将所有需要关心的类一次性注册，至此配置即告完成。

之后，你可以在任何地方用下面的方法进行通信：

getM(target:**):**
获得一个Model的实例。

send(e:Event, target:**= null, type:String = null):void
发送事件e**

receive(e:String, handler:Function, target:**= null, type:String = null):void
添加接收事件监听e**

call(target:**,type:String,metrod:String,...param):**
调用其他实例的方法metrod

bindProperty(site:Object,prop:String,target:Object,type:String,chain:Object):ChangeWatcher
当目标的chain属性变化时候，自动同步site[prop](prop.md)属性

bindSetter(setter:Function,target:Object,type:String,chain:Object):ChangeWatcher
当目标的chain属性变化时候，自动执行setter方法（参数是变化的值）

这里的target属性可以是定义的名称（如"test"），也可以是定义的类，或者一个类的实例（诸如this），而type属性则在必要时用来区分三者（值分别为："m","v","c"）。
有趣的时，同一组的M,V,C是可以重名的，你可以将相关的M,V,C都定义成同一个名字。于是，当你执行call(this,"c","metrod")时，执行的就是和当前view同名的Command的metrod方法，当你执行getM(this)时，得到的也是和自己View同名的Module。当M,V,C大部分时候处于一对一关系的时候，这样会获得很大的便利。


默认情况下，Model会被当做单例处理，而Command的每次调用都会重新创建一个实例，View则只是记录name。如果你不手动执行register(this)将View注册，它是无法被外部访问的，这三种情况分别对应single,create,none模式。模式也可以通过元标签定义修改。诸如[C(name="test",mode="single")]即可将这个Command当做单例处理。

View默认是none模式，因此如果希望外部能够访问到它，就一定要先执行一次register方法（并在销毁的时候执行unregister方法）。当然，你也可以选择不让外界访问到它（就像烟水晶），用bindProperty将它和一个M的属性绑定，一样可以达到通信的目的。


下面是一个示例文件：创建了两个文本框，用两种不同的方法让Command将当前值+1并回馈到View上。
http://ghostcat.googlecode.com/files/GhostCatMVCExample.rar


GhostCat项目地址：http://ghostcat.googlecode.com/