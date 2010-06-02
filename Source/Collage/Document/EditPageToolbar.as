package Collage.Document
{
	import spark.components.SkinnableContainer;
	import Collage.Document.Skins.*;
	
	public class EditPageToolbar extends SkinnableContainer
	{
		[Bindable]public var model:Object;
		
		public function EditPageToolbar(_model:EditPage)
		{
			super();
			model = _model;
			setStyle("skinClass", EditPageToolbarSkin);
		}
	}
}