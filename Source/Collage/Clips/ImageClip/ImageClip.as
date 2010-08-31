package Collage.Clips.ImageClip
{
	import Collage.Clip.*;
	import mx.events.PropertyChangeEvent;
	import flash.events.KeyboardEvent;
	import flash.display.BitmapData;
	import Collage.Utilities.KeyCodes;
	
	public class ImageClip extends Clip
	{             
		[Bindable][Savable] public var URL:String = null;
		[Bindable][Savable] public var fileID:String = null;
		[Bindable][Savable] public var fillMode:String = "scale";

		[Bindable] public var bitData:BitmapData = null;
		
		public function ImageClip()
		{
			super(ImageClipSkin, ImageClipEditor, ImageClipEditorSmall);
			aspectLocked = true;
			type="image";
		}
		
		public override function LoadFromData(data:Object):Boolean
		{
			if (data is BitmapData && view)
			{
				bitData = data as BitmapData;
				return true;
			}
			return false;
		}
	}
}
