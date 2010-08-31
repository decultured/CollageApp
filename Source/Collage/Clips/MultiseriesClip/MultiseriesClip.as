package Collage.Clips.MultiseriesClip
{
	import mx.collections.ArrayList;
	import Collage.Clip.*;
	import Collage.DataEngine.*;
	import Collage.Utilities.Logger.*;
	import mx.events.PropertyChangeEvent;
	import Collage.Clips.MultiseriesClip.Components.LineSeries.*;
	import Collage.Clips.MultiseriesClip.Components.ColumnSeries.*;
	import Collage.Clips.MultiseriesClip.Components.PlotSeries.*;
	import Collage.Clips.MultiseriesClip.Components.VAxis.*;
	import Collage.Clips.MultiseriesClip.Components.*;
	
	public class MultiseriesClip extends Clip
	{
		[Bindable]public var redrawTrigger:Boolean = false;
		
		[Bindable]public var seriesSelectedItem:SeriesPart = null;
		[Bindable]public var series:ArrayList = new ArrayList();
		[Bindable]public var seriesViews:ArrayList = new ArrayList();
		[Bindable]public var vAxis:ArrayList = new ArrayList();
		
		// Grid Options
		[Bindable][Savable] public var gridVisible:Boolean = true;
		[Bindable][Savable] public var gridDirection:String = "both";
		[Bindable][Savable] public var gridColor:Number = 0xDDDDDD;
		[Bindable][Savable] public var gridAlpha:Number = 1.0;
		[Bindable][Savable] public var gridWeight:Number = 1;

		// Grid Origins
		[Bindable][Savable] public var gridHOriginVisible:Boolean = false;
		[Bindable][Savable] public var gridHOriginColor:Number = 0x559955;
		[Bindable][Savable] public var gridHOriginAlpha:Number = 0.5;
		[Bindable][Savable] public var gridHOriginWeight:Number = 1;
		[Bindable][Savable] public var gridVOriginVisible:Boolean = false;
		[Bindable][Savable] public var gridVOriginColor:Number = 0x559955;
		[Bindable][Savable] public var gridVOriginAlpha:Number = 0.5;
		[Bindable][Savable] public var gridVOriginWeight:Number = 1;
				
		// Vertical Axis 
		[Bindable][Savable] public var vAxisVisible:Boolean = true;
		[Bindable][Savable] public var vAxisColor:Number = 0xAAAAAA;
		[Bindable][Savable] public var vAxisAlpha:Number = 1.0;
		[Bindable][Savable] public var vAxisWeight:Number = 2;
		
		[Bindable][Savable] public var vAxisLabelVisible:Boolean = true;
		[Bindable][Savable] public var vAxisLabelSize:Number = 10;
		[Bindable][Savable] public var vAxisLabelColor:Number = 0x333333;
		[Bindable][Savable] public var vAxisLabelAlpha:Number = 1;
        [Bindable][Savable] public var vAxisLabelGap:Number = 10;

		// Horizontal Axis
		[Bindable][Savable] public var hAxisVisible:Boolean = true;
		[Bindable][Savable] public var hAxisColor:Number = 0xAAAAAA;
		[Bindable][Savable] public var hAxisAlpha:Number = 1.0;
		[Bindable][Savable] public var hAxisWeight:Number = 2;
		
		[Bindable][Savable] public var hAxisLabelVisible:Boolean = true;
		[Bindable][Savable] public var hAxisLabelSize:Number = 10;
		[Bindable][Savable] public var hAxisLabelColor:Number = 0x333333;
		[Bindable][Savable] public var hAxisLabelAlpha:Number = 1;
        [Bindable][Savable] public var hAxisLabelGap:Number = 10;

		[Bindable][Savable] public var xAxisType:String = "numeric";

		public function MultiseriesClip()
		{
			super(MultiseriesClipSkin, MultiseriesClipEditor);
			type = "multiseries";
			rotatable = false;
			
			var vAxisPart:VAxisPart = new VAxisPart();
			vAxis.addItem(vAxisPart);
		}

		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{
				case "series":
					return;
			}

			super.ModelChanged(event);
		}

		public function addSeries(newSeries:SeriesPart):void
		{
			if (!newSeries)
				return;
				
			series.addItem(newSeries);
			newSeries.parentClip = this;
			SetSeriesVAxisByUID(newSeries);
		}

		public function SetAllAxis():void
		{
			for (var idx:uint = 0; idx < series.length; idx++)
			{
				if (series.getItemAt(idx) is SeriesPart)
					SetSeriesVAxisByUID(series.getItemAt(idx) as SeriesPart);
			}
		}
		
		public function SetSeriesVAxisByUID(seriesPart:SeriesPart):void
		{
			if (!seriesPart || !vAxis || !vAxis.length) {
				return;
			}

			if (!seriesPart.axisUID) {
				seriesPart.axisUID = (vAxis.getItemAt(0) as VAxisPart).UID;
			} 
			
			for (var idx:uint = 0; idx < vAxis.length; idx++)
			{
				if (seriesPart.axisUID == (vAxis.getItemAt(idx) as VAxisPart).UID) {
					seriesPart.axis = vAxis.getItemAt(idx) as VAxisPart;
					Logger.Log("Axis UID Found!" + seriesPart.axisUID, this);
					return;
				}
			}
			
			seriesPart.axisUID = (vAxis.getItemAt(0) as VAxisPart).UID;
			seriesPart.axis = vAxis.getItemAt(idx) as VAxisPart;
			Logger.LogError("No Axis with that UID Found! Changing to : " + seriesPart.axisUID, this);
		}
	}
}
