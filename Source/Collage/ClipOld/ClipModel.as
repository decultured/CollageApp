package Collage.Clips
{
	import com.roguedevelopment.objecthandles.IMoveable;
	import com.roguedevelopment.objecthandles.IResizeable;
	import mx.utils.*;
	
	public class ClipModel implements IResizeable, IMoveable
	{
		private var _UID:String;
		
		public var view:Clip = new Clip();

		public var clipData:Object = new Object();
		
		public var zIndex:Number = 0;
		public var selected:Boolean = false;
		[Bindable] public var x:Number = 10;
		[Bindable] public var y:Number  = 10;
		[Bindable] public var height:Number = 350;
		[Bindable] public var width:Number = 150;
		[Bindable] public var rotation:Number = 0;
		[Bindable] public var isLocked:Boolean = false;
		
		public var verticalSizable:Boolean = true;
		public var horizontalSizable:Boolean = true;
		public var moveFromCenter:Boolean = false;
		public var rotatable:Boolean = false;
		
		private var _ClipName:String = null;
		
		public function get clipName():String {return _ClipName;}
		public function set clipName(name:String):void
		{
			_ClipName = name;
			view.Load(_ClipName);
		}
		
		public function get uid():String
		{
			if (!_UID)
				_UID = UIDUtil.createUID();
			return _UID;
		}
		
		public function ClipModel():void
		{
			view.model = this;
		}
		
		public function Resized():void {if (view) view.Resized(); }
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