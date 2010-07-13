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
		
		public static var DEFAULT_LABEL_TEXT:String = "<HTML><BODY><P ALIGN=\"left\"><FONT FACE=\"Arial\" SIZE=\"12\" COLOR=\"#000000\" LETTERSPACING=\"0\" KERNING=\"1\">Do<FONT COLOR=\"#003b59\">uble-click to editDouble-c</FONT><FONT COLOR=\"#003b59\"><B>lick to editDouble</B></FONT><FONT COLOR=\"#003b59\">-click to editDouble-click to editasdfasdf</FONT></FONT></P><P ALIGN=\"left\"><FONT FACE=\"Arial\" SIZE=\"12\" COLOR=\"#000000\" LETTERSPACING=\"0\" KERNING=\"1\"><FONT COLOR=\"#003b59\">asdfasdf</FONT></FONT></P><P ALIGN=\"left\"><FONT FACE=\"Arial\" SIZE=\"12\" COLOR=\"#000000\" LETTERSPACING=\"0\" KERNING=\"1\"><FONT COLOR=\"#003b59\">asdfasdf</FONT></FONT></P><P ALIGN=\"left\"><FONT FACE=\"Arial\" SIZE=\"12\" COLOR=\"#000000\" LETTERSPACING=\"0\" KERNING=\"1\"><FONT COLOR=\"#003b59\">asd</FONT>fasdf</FONT></P><P ALIGN=\"left\"><FONT FACE=\"Arial\" SIZE=\"12\" COLOR=\"#000000\" LETTERSPACING=\"0\" KERNING=\"1\">asdfasdf</FONT></P><P ALIGN=\"left\"><FONT FACE=\"Arial\" SIZE=\"12\" COLOR=\"#000000\" LETTERSPACING=\"0\" KERNING=\"1\">sadf</FONT></P></BODY></HTML>";

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
