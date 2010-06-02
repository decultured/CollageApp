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
		[Bindable][Savable]public var text:String = "";
		[Bindable][Savable]public var color:Number = 0x222299;
		[Bindable][Savable]public var backgroundAlpha:Number = 1.0;
		[Bindable][Savable]public var backgroundColor:Number = 0xFFFFFF;

		[Bindable][Savable]public var textWidth:Number = 200;
		[Bindable][Savable]public var textHeight:Number = 24;
		[Bindable][Savable]public var fontSize:Number = 18;
		
		private static var DEFAULT_LABEL_TEXT:String = "Double-click to edit";
		[Bindable]public var displayText:String = DEFAULT_LABEL_TEXT;

		public function TextBoxClip()
		{
			super(TextBoxClipSkin, TextBoxClipEditor);
			type = "textbox";
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
						displayText = DEFAULT_LABEL_TEXT;
					else
						displayText = text;
					return;
			}

			super.ModelChanged(event);
		}

	}
}
