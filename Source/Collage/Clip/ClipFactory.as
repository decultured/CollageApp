package Collage.Clip
{
	import Collage.Clips.*;
	
	public class ClipFactory
	{
		public static function CreateByType(clipType:String):Clip
		{
			if (clipType == "image")
				return new ImageClip();
			else if (clipType == "label")
				return new LabelClip();
			else if (clipType == "textbox")
				return new TextBoxClip();
			return null;
		}
	}
}