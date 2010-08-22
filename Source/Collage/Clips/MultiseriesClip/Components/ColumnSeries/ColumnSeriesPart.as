package Collage.Clips.MultiseriesClip.Components.ColumnSeries
{
	import Collage.Clip.*;
	import Collage.DataEngine.*;
	import mx.events.PropertyChangeEvent;
	
	public class ColumnSeriesPart extends DataClip
	{
		[Bindable][Savable] public var barAlpha:Number = 1.0;
		[Bindable][Savable] public var barColor:Number = 0x00AA00;
		
		[Bindable][Savable] public var group:String = "";
		[Bindable][Savable] public var data:String = "";
		
		[Bindable][Savable] public var xAxisType:String = "numeric";
		[Bindable][Saveable] public var yAxisName:String = "";

		public var series:ColumnSeriesPartView = new ColumnSeriesPartView();

		public function ColumnSeriesPart()
		{
			super(null, ColumnSeriesPartEditor);
			type = "columnchart";
			rotatable = false;

			series.model = this;

			_QueryDefinition.queryTitle = "Column Chart";
			_QueryDefinition.queryDescription = "Data setup for the Column Chart";
			_QueryDefinition.minRowsReturned = 2;
			_QueryDefinition.maxRowsReturned = 500;
			var newQFD:QueryFieldDefinition = new QueryFieldDefinition(_QueryDefinition);
			newQFD.internalName = "group";
			newQFD.title = "Group";
			newQFD.description = "This field defines the bar segments";
			newQFD.groupable = true;
			newQFD.grouped = true;
			newQFD.AddAllowedType("datetime");
			_QueryDefinition.AddFieldDefinition(newQFD);
			newQFD = new QueryFieldDefinition(_QueryDefinition);
			newQFD.internalName = "data";
			newQFD.title = "Data";
			newQFD.description = "This field defines the size of the bars based on their value and a modifier.";
			newQFD.AddAllowedType("numeric");
			_QueryDefinition.AddFieldDefinition(newQFD);
		}
	}
}
