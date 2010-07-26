package Collage.Clips.TextBoxClip
{
	import Collage.Clip.*;
	import spark.components.TextArea;
	
	public class TextBoxClipView extends ClipView
	{
		[SkinPart(required="true")]
		[Bindable]public var editorLabel:TextArea;
		
		public function TextBoxClipView(_model:Clip, _clipViewSkin:Class)
		{
			super(_model, _clipViewSkin);
		}
	}
}