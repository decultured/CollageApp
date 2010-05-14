package Collage.Application
{
	import spark.components.SkinnableContainer;
	
	public class CollageStatusBar extends SkinnableContainer
	{
		[Bindable]public var message:String = "Status Bar!";
		[Bindable]public var messageColor:Number = 0x999999;
		
		public function CollageStatusBar()
		{
			super();
		}
	}
}