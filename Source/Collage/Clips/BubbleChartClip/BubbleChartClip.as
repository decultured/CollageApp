package Collage.Clips.BubbleChartClip
{
	import Collage.Clip.*;
	import Collage.DataEngine.*;
	import Collage.Utilities.Logger.*;
	import mx.events.PropertyChangeEvent;
	
	public class BubbleChartClip extends DataClip
	{
        // Plot Options
		[Bindable][Savable] public var plotShapeID:Number = 0;
		[Bindable][Savable] public var plotShape:String = "circle";
		[Bindable][Savable] public var plotRadius:Number = 2;
		[Bindable][Savable] public var plotAlpha:Number = 0.6;
		[Bindable][Savable] public var plotColor:Number = 0xff0000;

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
		[Bindable][Savable] public var vAxisLabelSize:Number = 10;
		[Bindable][Savable] public var vAxisLabelColor:Number = 0x333333;
		[Bindable][Savable] public var vAxisLabelAlpha:Number = 1;
        [Bindable][Savable] public var vAxisLabelGap:Number = 10;

		// Horizontal Axis
		[Bindable][Savable] public var hAxisVisible:Boolean = true;
		[Bindable][Savable] public var hAxisColor:Number = 0xAAAAAA;
		[Bindable][Savable] public var hAxisAlpha:Number = 1.0;
		[Bindable][Savable] public var hAxisWeight:Number = 2;
		
		[Bindable][Savable] public var vAxisLabelVisible:Boolean = true;
		[Bindable][Savable] public var hAxisLabelSize:Number = 10;
		[Bindable][Savable] public var hAxisLabelColor:Number = 0x333333;
		[Bindable][Savable] public var hAxisLabelAlpha:Number = 1;
        [Bindable][Savable] public var hAxisLabelGap:Number = 10;

		[Bindable][Savable] public var xAxisType:String = "numeric";
		[Bindable][Savable] public var xAxis:String = "";
		[Bindable][Savable] public var yAxis:String = "";
		[Bindable][Savable] public var bubbleRadius:String = "";

		public function BubbleChartClip()
		{
			super(BubbleChartClipSkin, BubbleChartClipEditor);
			type = "scatterplot";
			rotatable = false;

			_QueryDefinition.queryTitle = "Bubble Chart";
			_QueryDefinition.queryDescription = "Data setup for the Bubble Chart";
			_QueryDefinition.minRowsReturned = 2;
			_QueryDefinition.maxRowsReturned = 500;
			var newQFD:QueryFieldDefinition = new QueryFieldDefinition(_QueryDefinition);
			newQFD.internalName = "xAxis";
			newQFD.title = "X Axis";
			newQFD.groupable = true;
			newQFD.description = "This field defines the x axis of the chart.";
			newQFD.AddAllowedType("numeric");
			newQFD.AddAllowedType("datetime");
			_QueryDefinition.AddFieldDefinition(newQFD);
			
			newQFD = new QueryFieldDefinition(_QueryDefinition);
			newQFD.internalName = "yAxis";
			newQFD.title = "Y Axis";
			newQFD.description = "This field defines the y axis of the chart.";
			newQFD.AddAllowedType("numeric");
			newQFD.AddAllowedType("datetime");
			_QueryDefinition.AddFieldDefinition(newQFD);
			query.postSortInternalName = "xAxis";
			
			newQFD = new QueryFieldDefinition(_QueryDefinition);
			newQFD.internalName = "bubbleRadius";
			newQFD.title = "Bubble Radius";
			newQFD.description = "This field defines the radius of a bubble on the chart.";
			newQFD.AddAllowedType("numeric");
			_QueryDefinition.AddFieldDefinition(newQFD);
		}
		
		protected override function QueryFieldsChangedHandler(event:Event):void
		{
			super.QueryFieldsChangedHandler(event);
			
			var dataSet:DataSet = DataEngine.GetDataSetByID(query.dataset);
			if (dataSet && xAxis) {
				var dataColumn:DataSetColumn = dataSet.GetColumnByID(xAxis);
				if (dataColumn)
					xAxisType = dataColumn.datatype;
			}
		}
	}
}
