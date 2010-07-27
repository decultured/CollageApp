package Collage.Clips.TextBoxClip
{
	import Collage.Clip.*;
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
		
		public static var DEFAULT_LABEL_TEXT:String = "Double Click to Edit";

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
	}
}
