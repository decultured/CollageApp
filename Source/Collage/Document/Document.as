package Collage.Document
{
	import mx.core.*;  
	import mx.containers.Canvas;
	
	public class Document extends Canvas
	{
		public var documentModel:DocumentModel;
		
		public function Document():void
		{
			documentModel = new DocumentModel();
			
		}

		public function NewDocument():void
		{
			documentModel.NewDocument();
		}
	} 
}