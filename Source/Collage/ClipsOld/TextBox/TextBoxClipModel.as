package
{
	import Clip.*;
	
	public class TextBoxClip extends ClipModel
	{
		[Bindable]public var text:String = "Default Text.";
		[Bindable]public var backgroundAlpha:Number = 1.0;
		[Bindable]public var backgroundColor:Number = 0xFFFFFF;

		public function TextBoxClip()
		{
			super();
		}
	}
}