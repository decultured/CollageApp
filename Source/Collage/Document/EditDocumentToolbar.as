package Collage.Document
{
	import spark.components.SkinnableContainer;
	import Collage.Document.Skins.*;
	
	public class EditDocumentToolbar extends SkinnableContainer
	{
		[Bindable]public var model:Object;
		
		public function EditDocumentToolbar(_model:EditDocument)
		{
			super();
			model = _model;
			setStyle("skinClass", EditDocumentToolbarSkin);
		}
	}
}