package Collage.Clip
{
	import spark.components.SkinnableContainer;
	import flash.events.MouseEvent;
	import mx.events.PropertyChangeEvent;
	import mx.managers.PopUpManager;
	
	public class ClipView extends SkinnableContainer
	{
		[Bindable]public var model:Object;
		
		public function ClipView(_model:Clip, _clipViewSkin:Class)
		{
			super();
			model = _model;
			doubleClickEnabled = true;
			setStyle("skinClass", _clipViewSkin);
			if (model)
				model.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, ModelChanged );
			addEventListener(MouseEvent.DOUBLE_CLICK, OnDoubleClick);
			Reposition();
		}

		public function OnDoubleClick(event:MouseEvent):void {
			if (skin)
				skin.currentState = "editing";
				
			mx.managers.PopUpManager.addPopUp(this, parent, true);
		}

		protected function ModelChanged(event:PropertyChangeEvent):void
		{
			model.removeEventListener( PropertyChangeEvent.PROPERTY_CHANGE, ModelChanged );
			model.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, ModelChanged );
			
			// Possible performance increase, check bound item, only change that
			switch( event.property )
			{
				case "selected":
					if (skin && !model.selected && skin.currentState == "editing")
						skin.currentState = "normal";
					return;
			}
			
			Reposition();
		}

		public function Reposition():void
		{
			x = model.x;
			y = model.y;
			width = model.width;
			height = model.height;
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