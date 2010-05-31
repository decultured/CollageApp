package Collage.Clips
{
	import Collage.Clip.*;
	import Collage.Clips.Skins.*;
	import Collage.Clips.Editors.*;
	import mx.events.PropertyChangeEvent;
	import flash.events.KeyboardEvent;
	import Collage.Utilities.KeyCodes;
	
	public class TextBoxClip extends Clip
	{            
		[Bindable]public var text:String = "";
		[Bindable]public var displayText:String = "Double Click to Edit";
		[Bindable]public var color:Number = 0x222299;
		[Bindable]public var backgroundAlpha:Number = 1.0;
		[Bindable]public var backgroundColor:Number = 0xFFFFFF;
                  
		[Bindable]public var textWidth:Number = 200;
		[Bindable]public var textHeight:Number = 24;
		[Bindable]public var fontSize:Number = 18;

		public function TextBoxClip()
		{
			super(TextBoxClipSkin, TextBoxClipEditor);
			height=50;
		}

		protected override function OnKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == KeyCodes.ESCAPE && view.skin && view.skin.currentState == "editing")
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
