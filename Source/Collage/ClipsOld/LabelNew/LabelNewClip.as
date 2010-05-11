package Collage.Clips.LabelNew
{
	import mx.controls.Alert;
	import Collage.Clip.*;
	import flash.events.MouseEvent;
	
	public class LabelNewClip extends Clip
	{             
		[Bindable]public var text:String = "Default Text";
		[Bindable]public var color:Number = 0xff0000;
		[Bindable]public var backgroundAlpha:Number = 1.0;
		[Bindable]public var backgroundColor:Number = 0xFFFFFF;
                  
		[Bindable]public var textWidth:Number = 200;
		[Bindable]public var textHeight:Number = 24;
		[Bindable]public var fontSize:Number = 18;
		
		public function LabelNewClip()
		{
			super();
			setStyle("skinClass", LabelNewClipSkin);
			addEventListener(MouseEvent.DOUBLE_CLICK, OnDoubleClick);
		}
		
		public function OnDoubleClick(event:MouseEvent):void {
			if (skin)
				skin.currentState = "editing";
		}
		
	}
}