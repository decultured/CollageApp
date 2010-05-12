package Collage.Clips
{
	import Collage.Clip.*;
	import Collage.Clips.Skins.*;
	import Collage.Clips.Editors.*;
	
	public class LabelClip extends Clip
	{             
		[Bindable]public var text:String = "Defaulting Text";
		[Bindable]public var color:Number = 0xFF0000;
		[Bindable]public var backgroundAlpha:Number = 1.0;
		[Bindable]public var backgroundColor:Number = 0xFFFFFF;
                  
		[Bindable]public var textWidth:Number = 200;
		[Bindable]public var textHeight:Number = 24;
		[Bindable]public var fontSize:Number = 18;

		public function LabelClip()
		{
			verticalSizable = false;
			super(LabelClipSkin, LabelClipEditor);
		}
		
		public override function Reposition():void
		{
			height = textHeight;
			super.Reposition();
		}
	}
}
