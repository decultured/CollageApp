package Collage.Document
{
	import Collage.Utilities.Logger.*;
	import mx.core.*;  
	import spark.components.Group;
	import Collage.Clip.*;
	
	public class Page extends Group
	{
		public static var DEFAULT_WIDTH:Number = 1024;
		public static var DEFAULT_HEIGHT:Number = 768;
		
		public var backgroundURL:String = null;
		public var backgroundColor:Number = 0xFFFFFF;
		
		private var _Clips:Object = new Object();

		public function Page():void
		{
			setStyle("dropShadowVisible", true);
			New();
		}

		public function New():void
		{
			width = DEFAULT_WIDTH;
			height = DEFAULT_HEIGHT;
//			backgroundURL = null;
//			backgroundColor = 0x555555;
//			setStyle("backgroundColor", backgroundColor);

			// TODO : Properly unload clips from memory
			_Clips = new Object();
		}

		public function ViewResized():void
		{
			// TODO : Reposition all objects to fit in new size
		}

		public function AddClip(clip:Clip):Clip
		{
			if (clip && !_Clips[clip.uid]) {
				_Clips[clip.uid] = clip;
				addElement(clip.view);
				Logger.LogDebug("Clip Added", clip);
				return clip;
			}
			Logger.LogWarning("Problem Adding Clip", clip);
			return null;
		}
		
		public function DeleteClip(clip:Clip):void
		{
			
		}
		
		public function LoadFromObject(pageObject:Object):void
		{
			
		}
		
		public function SaveToObject():Object
		{
			return null;
		}
	} 
}