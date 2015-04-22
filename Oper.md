Oper

加载队列是一个非常普遍的需求，普遍到让人怀疑Adobe不内置加载队列是不是脑残了。而且这同时还涉及到浏览器的5连接上限BUG，很多时候，这都是必须解决的一个问题。
解决方案没什么难度，无非就是一个完成后继续加载下一个，只要单纯地做一次简单封装就好。但考虑到加载操作往往会和其他操作合并在一起，而且队列不仅仅是加载需要，比如Alert队列，所以就做了一次逻辑抽离。

队列无非需要4个方法
commit	推入队列
execute	开始执行
result	完成
fault	失败

然后配合Queue对象，将加载请求存入数组并按照execute-result-execute的方式排序执行，这样就形成了一个队列系统。

commit方法是推入队列的方法，参数是queue对象，如果不写的话，将会使用默认的全局queue，所以，顺序加载一组数据只需要像这样写就可以

new LoadOper("1.swf").commit();
new LoadOper("2.swf").commit();
new LoadOper("3.swf").commit();
new LoadOper("4.swf").commit();
new LoadOper("5.swf").commit();

全部加载完成可以监听最后一个的operation\_complete事件，也可以监听默认queue，也就是Queue.defaultQueue的operation\_complete，或者换一种方法，把加载完成执行的方法也当做一个Oper，也就是在上面的语句再加上一条
new FunctionOper(completeHandler).commit()
它就会在加载完全部资源之后自动执行completeHandler方法

除了LoadOper和FunctionOper，这样的Oper还有很多，比如捆绑加载的GroupOper,播放动画的MovieTween，延时的DelayOper，执行缓动的TweenOper，等待并监听事件的WaitOper。除了具体执行某个操作外，也有进行分支选择的IfOper,循环的RepeatOper，通过不同的Oper使用不同参数可以处理各种各样的功能，而这些功能都可以被放在同一个队列里。而除了LoadOper这种逻辑比较多的，其他的Oper代码都非常少（只有几十行），所以再加入新的Oper是非常容易的事情。

而作为队列管理的Queue对象，其实也是一个Oper，它同样也可以被加到另一个Queue里。因此，整个队列可以不是单线的，而是一个互相触发转向的关系。如果使用GMXML通过XML创建Oper序列的化，可以做出很复杂的自定义内容。

可能说得复杂了点。但像一般的队列加载，只要像上面那样写就可以了。想做的事情创建一个对应的Oper，然后用commit方法推入队列，之后就可以当他们是个独立线程那样处理，而不用再去麻烦地进行各种事件监听。这样处理起来会很简单。而如果队列有冲突的话，重新创建一个queue对象（而不是用默认Queue），然后推入队列的时候写在commit的参数里就可以。多队列的扩展很简单。

GhostCat广泛地使用了Queue体系，但凡和队列和执行操作有关的基本都在这里。

总之，这个东西只要new出来然后commit就好了。是一个很简单的东西。


Queue除了用Oper的commit被动执行，也可以通过传入数组临时生成，诸如下面这样的写法：
new Queue([TweenOper(xxx),new FunctionOper(xxx),new TweenOper(xxx)](new.md)).execute()