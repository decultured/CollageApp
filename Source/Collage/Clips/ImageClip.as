package Collage.Clips
{
	import Collage.Clip.*;
	import Collage.Clips.Skins.*;
	import Collage.Clips.Editors.*;
	import mx.events.PropertyChangeEvent;
	import flash.events.KeyboardEvent;
	import Collage.Utilities.KeyCodes;
	
	public class ImageClip extends Clip
	{             
		[Bindable][Savable]public var URL:String = "http://www.google.com/intl/en_ALL/images/srpr/logo1w.png";
		
		public function ImageClip()
		{
			super(ImageClipSkin, ImageClipEditor, ImageClipEditorSmall);
			type="image";
		}
	}
}
