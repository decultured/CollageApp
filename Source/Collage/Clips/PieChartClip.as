package Collage.Clips
{
	import Collage.Clip.*;
	import Collage.Clips.Skins.*;
	import Collage.Clips.Editors.*;
	import Collage.DataEngine.*;
	import mx.events.PropertyChangeEvent;
	
	public class PieChartClip extends DataClip
	{
		public function PieChartClip()
		{
			super(PieChartClipSkin, PieChartClipEditor);
			type = "piechart";
			
			_QueryDefinition.queryTitle = "PieChart";
			_QueryDefinition.queryDescription = "Data setup for the Pie Chart";
			_QueryDefinition.maxRowsReturned = 50;
			var newQFD:QueryFieldDefinition = new QueryFieldDefinition();
			newQFD.title = "Group";
			newQFD.description = "This field defines the segments of the pie";
			newQFD.grouped = true;
			newQFD.AddAllowedType("numeric");
			_QueryDefinition.AddFieldDefinition(newQFD);
			newQFD = new QueryFieldDefinition();
			newQFD.title = "Data";
			newQFD.description = "This field defines the size of the segments of the pie based on their value and a modifier.";
			newQFD.allowModifiers = true;
			newQFD.AddAllowedType("numeric");
			_QueryDefinition.AddFieldDefinition(newQFD);
		}
		
		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{ }

			super.ModelChanged(event);
		}
	}
}
