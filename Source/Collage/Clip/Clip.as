package Collage.Clip
{
	import com.roguedevelopment.objecthandles.IMoveable;
	import com.roguedevelopment.objecthandles.IResizeable;
	import mx.events.PropertyChangeEvent;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import mx.utils.*;
	import Collage.Utilities.KeyCodes;
	import Collage.Utilities.Logger.*;
	
	public class Clip implements IResizeable, IMoveable
	{
		private var _UID:String;
		
		[Bindable] public var selected:Boolean = false;
		[Bindable] public var x:Number = 10;
		[Bindable] public var y:Number  = 10;
		[Bindable] public var height:Number = 200;
		[Bindable] public var width:Number = 200;
		[Bindable] public var rotation:Number = 0;
		[Bindable] public var isLocked:Boolean = false;
		
		private var _ClipEditorSkin:Class = null;
		
		public var verticalSizable:Boolean = true;
		public var horizontalSizable:Boolean = true;
		public var rotatable:Boolean = true;
		
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
			view.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
		}
		
		public function CreateEditor():ClipEditor
		{
			return new ClipEditor(this, _ClipEditorSkin);
		}
		
		protected function ModelChanged(event:PropertyChangeEvent):void
		{
			// Possible performance increase, check bound item, only change that
			switch( event.property )
			{
				case "selected":
					if (!selected)
						SetEditMode(false);
					return;
			}
			
			Reposition();
		}

		protected function OnDoubleClick(event:MouseEvent):void {
			SetEditMode(true);
		}
		
		protected function OnKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == KeyCodes.ESCAPE && view.skin && view.skin.currentState == "editing")
				SetEditMode(false);
		}
		
		public function Refresh():void
		{
			Logger.LogCritical("Refresh, it works!", this);
		}

		public function SetEditMode(isEditing:Boolean):void
		{
			if (!isEditing && view.skin && view.skin.currentState == "editing") {
				isLocked = false;
				view.skin.currentState = "normal";
			} else if (isEditing && view.skin && view.skin.currentState == "normal") { 
				isLocked = true;
				view.skin.currentState = "editing";
			}
		}

		public function ToggleEditMode():void
		{
			if (view.skin && view.skin.currentState == "editing") {
				isLocked = false;
				view.skin.currentState = "normal";
			} else if (view.skin && view.skin.currentState == "normal") {
				isLocked = true;
				view.skin.currentState = "editing";
			}
		}
		
		public function ToggleLocked():void
		{
			if (isLocked) {
				isLocked = false;
				Logger.Log("Un-Locked!");
			} else {
				isLocked = true;
				Logger.Log("Locked!");
			}
		}

		public function Reposition():void
		{
			view.x = x;
			view.y = y;
			view.width = width;
			view.height = height;
			view.rotation = rotation;
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