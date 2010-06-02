package Collage.Clips
{
	import Collage.Clip.*;
	import Collage.Clips.Skins.*;
	import Collage.Clips.Editors.*;
	import mx.events.PropertyChangeEvent;
	import flash.events.KeyboardEvent;
	import Collage.Utilities.KeyCodes;
	
	public class LabelClip extends Clip
	{             
		[Bindable]public var text:String = "";
		[Bindable]public var displayText:String = "Double-click to edit";
		[Bindable]public var color:Number = 0x444444;
		[Bindable]public var alpha:Number = 1.0;
		[Bindable]public var backgroundAlpha:Number = 1.0;
		[Bindable]public var backgroundColor:Number = 0xFFFFFF;
                  
		[Bindable]public var fontSize:Number = 18;

		public function LabelClip()
		{
			super(LabelClipSkin, LabelClipEditor);
			height = fontSize;
			verticalSizable = false;
		}
		
		public override function Reposition():void
		{
			height = fontSize;
			super.Reposition();
		}
		
		protected override function OnKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == KeyCodes.ENTER && view.skin && view.skin.currentState == "editing")
				SetEditMode(false);
		}

		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{
				case "text":
					if (!text.length)
						displayText = "Double Click to Edit";
					else
						displayText = text;
					return;
			}

			super.ModelChanged(event);
		}
	}
}
