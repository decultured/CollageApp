package Collage.Clips.MultiseriesClip.Components.VAxis
{
	import Collage.Clip.*;
	import Collage.DataEngine.*;
	import Collage.Utilities.Logger.*;
	import mx.events.PropertyChangeEvent;
	import mx.charts.LinearAxis;
	
	public class VAxisPart extends Clip
	{
        // Line Options
		[Bindable][Savable] public var vAxisVisible:Boolean = true;
		[Bindable][Savable] public var vAxisColor:Number = 0xAAAAAA;
		[Bindable][Savable] public var vAxisAlpha:Number = 1.0;
		[Bindable][Savable] public var vAxisWeight:Number = 2;
		
		[Bindable][Savable] public var vAxisLabelVisible:Boolean = true;
		[Bindable][Savable] public var vAxisLabelSize:Number = 10;
		[Bindable][Savable] public var vAxisLabelColor:Number = 0x333333;
		[Bindable][Savable] public var vAxisLabelAlpha:Number = 1;
        [Bindable][Savable] public var vAxisLabelGap:Number = 10;
		
		[Bindable]public var axis:LinearAxis = new LinearAxis();
		public var axisRenderer:VAxisPartRenderer = new VAxisPartRenderer();
		
		public function VAxisPart()
		{
			super(null, VAxisPartEditor);
			type = "linechart";
			rotatable = false;
			
			axis.baseAtZero = false;
			axisRenderer.model = this;
		}
	}
}
