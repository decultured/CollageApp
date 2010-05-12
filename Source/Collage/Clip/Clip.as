package Collage.Clip
{
	import com.roguedevelopment.objecthandles.IMoveable;
	import com.roguedevelopment.objecthandles.IResizeable;
	import mx.events.PropertyChangeEvent;
	import flash.events.MouseEvent;
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
		
		private var _ClipEditorSkin:Class = null;
		
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
		
		public function Clip(_clipViewSkin:Class, _clipEditorSkin:Class):void
		{
			view = new ClipView(this, _clipViewSkin);
			_ClipEditorSkin = _clipEditorSkin;
			addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, ModelChanged );
			view.addEventListener(MouseEvent.DOUBLE_CLICK, OnDoubleClick);
		}
		
		public function CreateEditor():ClipEditor
		{
			return new ClipEditor(this, _ClipEditorSkin);
		}
		
		protected function ModelChanged(event:PropertyChangeEvent):void
		{
			removeEventListener( PropertyChangeEvent.PROPERTY_CHANGE, ModelChanged );
			addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, ModelChanged );
			
			// Possible performance increase, check bound item, only change that
			switch( event.property )
			{
				case "selected":
					if (view.skin && !selected && view.skin.currentState == "editing")
						view.skin.currentState = "normal";
					return;
			}
			
			Reposition();
		}

		public function OnDoubleClick(event:MouseEvent):void {
			if (view.skin)
				view.skin.currentState = "editing";
		}

		public function Reposition():void
		{
			view.x = x;
			view.y = y;
			view.width = width;
			view.height = height;
		}

		public function Resized():void { }
		public function Moved():void { }
 		public function Rotated():void { }
		
		public function SaveToObject():Object
		{
			return new Object();
		}

		public function LoadFromObject(dataObject:Object):Boolean
		{
			return true;
		}
		
		public function LoadFromData(data:Object):Boolean
		{
			return false;
		}
		
		public function LoadFromXML():Boolean
		{
			return false;
		}

	}
}