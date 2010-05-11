package
{
	import Clip.*;
	
	public class LabelClip extends ClipModel
	{             
		[Bindable]public var text:String = "Default Text";
		[Bindable]public var color:Number = 0x000000;
		[Bindable]public var backgroundAlpha:Number = 1.0;
		[Bindable]public var backgroundColor:Number = 0xFFFFFF;
                  
		[Bindable]public var textWidth:Number = 200;
		[Bindable]public var textHeight:Number = 24;
		[Bindable]public var fontSize:Number = 18;

		public function LabelClip()
		{
			
		}
	}
}