package Collage.Document
{
	public class Document
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