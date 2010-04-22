package Collage.Document
{
	import mx.core.*;  
	import spark.components.Group;
	import spark.components.BorderContainer;
	import Collage.Clips.*;
	
	public class Document extends Group
	{
		public static var DEFAULT_WIDTH:Number = 1024;
		public static var DEFAULT_HEIGHT:Number = 768;
		
		public var snap:Boolean = false;
		public var grid:Boolean = false;
		public var gridSize:Number = 10;
		public var gridColor:Number = 0xeeeeee;

		public var backgroundURL:String = null;
		public var backgroundColor:Number = 0xFFFFFF;
		
		private var _Clips:Object = new Object();

		public function Document():void
		{
			setStyle("dropShadowVisible", true);
			NewDocument();
		}

		public function NewDocument():void
		{
			width = DEFAULT_WIDTH;
			height = DEFAULT_HEIGHT;
//			backgroundURL = null;
//			backgroundColor = 0x555555;
//			setStyle("backgroundColor", backgroundColor);

			// TODO : Properly unload clips from memory
			_Clips = new Object();
		}

		public function AddClip(clipModel:ClipModel):ClipModel
		{
			if (clipModel && !_Clips[clipModel.uid]) {
				_Clips[clipModel.uid] = clipModel;
				addElement(clipModel.view);
				return clipModel;
			}
			return null;
		}

		public function AddClipByType(clipType:String):ClipModel
		{
/*			var newClip:Clip = ClipFactory.CreateByType(clipType, dataObject);
			if (!newClip || !AddClip(newClip))
				return null;
			if (position)
				PositionClip(newClip, position);
			
			return newClip;
*/
			return new ClipModel();
		}

	} 
}