package org.ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	
	import org.ghostcat.util.ClassFactory;
	
	/**
	 * 纵向滚动条
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class GVScrollBar extends GScrollBar
	{
		[Embed(skinClass="org.ghostcat.skin.VScrollBarSkin")]
		private static const CursorGroupClass:Class;//这里不直接导入CursorGroup而用Embed中转只是为了正常生成ASDoc
		public static var defaultSkin:ClassFactory = new ClassFactory(CursorGroupClass);
		
		public function GVScrollBar(skin:DisplayObject=null, replace:Boolean=true)
		{
			if (!skin)
				skin = defaultSkin.newInstance();
			
			super(skin, replace);
		}
	}
}