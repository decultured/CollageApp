package Collage.Clips.MultiseriesClip.Components.LineSeries
{
	import Collage.Clip.*;
	import Collage.DataEngine.*;
	import Collage.Utilities.Logger.*;
	import mx.events.PropertyChangeEvent;
	
	public class LineSeriesPart extends DataClip
	{
        // Line Options
		[Bindable][Savable] public var form:String = "segment";
		[Bindable][Savable] public var lineWeight:Number = 2;
		[Bindable][Savable] public var lineAlpha:Number = 1;
		[Bindable][Savable] public var lineColor:Number = 0xff0000;
		
		[Bindable][Savable] public var xAxisType:String = "numeric";
		[Bindable][Savable] public var xAxis:String = "";
		[Bindable][Savable] public var yAxis:String = "";
		
		[Bindable][Saveable] public var yAxisName:String = "";
		//[Bindable] public var Axis:MultiAxisPart;
		
		public var series:LineSeriesPartView = new LineSeriesPartView();
		
		public function LineSeriesPart()
		{
			super(null, LineSeriesPartEditor);
			type = "linechart";
			rotatable = false;
			
			series.model = this;
			
			_QueryDefinition.queryTitle = "Line Chart";
			_QueryDefinition.queryDescription = "Data setup for the Line Chart";
			_QueryDefinition.minRowsReturned = 2;
			_QueryDefinition.maxRowsReturned = 500;
			var newQFD:QueryFieldDefinition = new QueryFieldDefinition(_QueryDefinition);
			newQFD.internalName = "xAxis";
			newQFD.title = "X Axis";
			newQFD.groupable = true;
			newQFD.grouped = true;
			newQFD.description = "This field defines the x axis of the chart.";
			newQFD.AddAllowedType("datetime");
			_QueryDefinition.AddFieldDefinition(newQFD);
			newQFD = new QueryFieldDefinition(_QueryDefinition);
			newQFD.internalName = "yAxis";
			newQFD.title = "Y Axis";
			newQFD.description = "This field defines the y axis of the chart.";
			newQFD.AddAllowedType("numeric");
			_QueryDefinition.AddFieldDefinition(newQFD);
			query.postSortInternalName = "xAxis";
		}
		
		protected override function QueryFieldsChangedHandler(event:Event):void
		{
			super.QueryFieldsChangedHandler(event);
			
			var dataSet:DataSet = DataEngine.GetDataSetByID(query.dataset);
			if (dataSet && xAxis) {
				var dataColumn:DataSetColumn = dataSet.GetColumnByID(xAxis);
				if (dataColumn)
					xAxisType = dataColumn.datatype;
				Logger.Log(xAxisType, this);
			}
		}
	}
}
