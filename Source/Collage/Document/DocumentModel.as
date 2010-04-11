package Collage.Document
{
	public class DocumentModel
	{
		public var height:Number = 768;
		public var width:Number = 1024;
		
		public var snap:Boolean = false;
		public var grid:Boolean = false;
		public var gridSize:Number = 10;
		public var gridColor:Number = 0xeeeeee;

		public var backgroundURL:String = null;
		public var backgroundColor:Number = 0xFFFFFF;
		
		public var clips:Object = new Object;
		
		public function Document()
		{
		}
		
		public function NewDocument():void
		{
			width = 1024;
			height = 768;
			backgroundURL = null;
			backgroundColor = 0xFFFFFF;

			// TODO : Properly unload clips from memory
			clips = new Object();
		}
	}
}