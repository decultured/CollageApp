package Collage.Clip
{
	import com.roguedevelopment.objecthandles.IMoveable;
	import com.roguedevelopment.objecthandles.IResizeable;
	import mx.utils.*;
	
	public class Clip implements IResizeable, IMoveable
	{
		private var _UID:String;
		
		[Bindable] public var selected:Boolean = false;
		[Bindable] public var x:Number = 10;
		[Bindable] public var y:Number  = 10;
		[Bindable] public var height:Number = 350;
		[Bindable] public var width:Number = 150;
		[Bindable] public var isLocked:Boolean = false;
		
		public var verticalSizable:Boolean = true;
		public var horizontalSizable:Boolean = true;
		public var moveFromCenter:Boolean = false;
		
		public var view:ClipView;
		
		public function get uid():String
		{
			if (!_UID)
				_UID = UIDUtil.createUID();
			return _UID;
		}
		
		public function Clip(_clipViewSkin:Class):void
		{
			view = new ClipView(this, _clipViewSkin);
		}
		
		public function Resized():void { }
		public function Moved():void { }
 		public function Rotated():void { }
		public function LoadFromData(data:Object):Boolean { return false; }
		public function LoadFromXML():Boolean {	return false; }
		
		public function SaveToObject():Object
		{
			return new Object();
		}

		public function LoadFromObject(dataObject:Object):Boolean
		{
			return true;
		}
		
	}
}