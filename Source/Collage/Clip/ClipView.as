package Collage.Clip
{
	import spark.components.BorderContainer;
	import spark.components.SkinnableContainer;
	
	public class ClipView extends SkinnableContainer
	{
		[Bindable]public var model:Object;
		
//		[SkinPart(required="true")]
//		public var borderContiner:BorderContainer;

		public function ClipView(_model:Clip, _clipViewSkin:Class)
		{
			super();
			model = _model;
			doubleClickEnabled = true;
			setStyle("skinClass", _clipViewSkin);
		}
	}
}