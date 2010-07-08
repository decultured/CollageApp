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
		[Bindable][Savable(theme="true")]public var color:Number = 0x222299;
		[Bindable][Savable(theme="true")]public var textWidth:Number = 200;
		[Bindable][Savable(theme="true")]public var textHeight:Number = 24;
		[Bindable][Savable(theme="true")]public var fontSize:Number = 18;
		
		private static var DEFAULT_LABEL_TEXT:String = "Double-click to edit";
		[Bindable][Savable] public var displayText:String = DEFAULT_LABEL_TEXT;

		public function TextBoxClip()
		{
			view = new TextBoxClipView(this, TextBoxClipSkin);
			super(null, TextBoxClipEditor, TextBoxClipEditorSmall);
			type = "textbox";
			editable = true;
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
