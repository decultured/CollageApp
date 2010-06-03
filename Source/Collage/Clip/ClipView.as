package Collage.Clip
{
	import spark.components.BorderContainer;
	
	public class ClipView extends BorderContainer
	{
		[Bindable]public var model:Object;
		
		public function ClipView(_model:Clip, _clipViewSkin:Class)
		{
			super();
			model = _model;
			doubleClickEnabled = true;
			setStyle("skinClass", _clipViewSkin);
		}
	}
}