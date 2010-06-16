package Collage.Clip
{
	import com.roguedevelopment.objecthandles.IMoveable;
	import com.roguedevelopment.objecthandles.IResizeable;
	import mx.events.PropertyChangeEvent;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import mx.utils.*;
	import flash.utils.*;
	import Collage.Utilities.KeyCodes;
	import Collage.Utilities.Logger.*;
	
	public class Clip implements IResizeable, IMoveable
	{
		[Savable]public var UID:String;
		
		[Bindable][Savable] public var type:String = "unknown:define_in_clip_constructor";
		[Bindable][Savable] public var zindex:uint = 0;

		[Bindable] public var selected:Boolean = false;
		[Bindable] public var isLocked:Boolean = false;

		[Bindable][Savable] public var x:Number = 10;
		[Bindable][Savable] public var y:Number  = 10;
		[Bindable][Savable] public var height:Number = 200;
		[Bindable][Savable] public var width:Number = 200;
		[Bindable][Savable] public var rotation:Number = 0;

		[Bindable][Savable]public var backgroundAlpha:Number = 0.0;
		[Bindable][Savable]public var backgroundColor:Number = 0xffffff;
		[Bindable][Savable]public var borderColor:Number = 0x000000;
		[Bindable][Savable]public var borderAlpha:Number = 1.0;
		[Bindable][Savable]public var borderWeight:Number = 0;
		[Bindable][Savable]public var borderRadius:Number = 0;
		[Bindable][Savable]public var dropShadowVisible:Boolean = true;
		
		private var _ClipEditorSkin:Class = null;
		private var _SmallClipEditorSkin:Class = null;
		
		public var verticalSizable:Boolean = true;
		public var horizontalSizable:Boolean = true;
		public var rotatable:Boolean = true;
		
		public var view:ClipView;
		
		public function Clip(_clipViewSkin:Class, _clipEditorSkin:Class, _smallClipEditorSkin:Class = null):void
		{
			if (_clipViewSkin)
				view = new ClipView(this, _clipViewSkin);
			UID = UIDUtil.createUID();
			_ClipEditorSkin = _clipEditorSkin;
			_SmallClipEditorSkin = _smallClipEditorSkin;
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, ModelChanged, false, 0, true);
			view.addEventListener(MouseEvent.DOUBLE_CLICK, OnDoubleClick, false, 0, true);
			view.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown, false, 0, true);
		}
		
		public function CreateEditor():ClipEditor
		{
			return new ClipEditor(this, _ClipEditorSkin);
		}
		
		public function CreateSmallEditor():ClipEditor
		{
			if (_SmallClipEditorSkin)
				return new ClipEditor(this, _SmallClipEditorSkin);
			else
				return null;
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
			var typeDef:XML = describeType(this);
			var newObject:Object = new Object();
			for each (var metadata:XML in typeDef..metadata) {
				if (metadata["@name"] != "Savable") continue;
				if (this.hasOwnProperty(metadata.parent()["@name"])) {
					newObject[metadata.parent()["@name"]] = this[metadata.parent()["@name"]];
				}
			}

			return newObject;
		}

		public function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject) return false;

			for(var obj_k:String in dataObject) {
				try {
					if(this.hasOwnProperty(obj_k))
						this[obj_k] = dataObject[obj_k];
				} catch(e:Error) { }
			}
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