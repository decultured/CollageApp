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
		public function ImageClip()
		{
			super(ImageClipSkin, ImageClipEditor);
		}
	}
}
