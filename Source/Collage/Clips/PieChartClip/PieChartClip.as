package Collage.Clips.PieChartClip
{
	import Collage.Clip.*;
	import Collage.DataEngine.*;
	import mx.events.PropertyChangeEvent;
	
	public class PieChartClip extends DataClip
	{
		[Savable][Bindable] public var pieBorderColor:Number = 0x000000;
		[Savable][Bindable] public var pieBorderAlpha:Number = 0.5;
		[Savable][Bindable] public var pieBorderWeight:Number = 2;
		
		[Savable][Bindable] public var radialColor:Number = 0x000000;
		[Savable][Bindable] public var radialAlpha:Number = 0.0;
		[Savable][Bindable] public var radialWeight:Number = 0;
		
		[Savable][Bindable] public var calloutColor:Number = 0x000000;
		[Savable][Bindable] public var calloutAlpha:Number = 0.0;
		[Savable][Bindable] public var calloutWeight:Number = 0;
		
		[Savable][Bindable] public var labelPosition:String = "inside";
		[Savable][Bindable] public var labelColor:Number = 0x333333;
		[Savable][Bindable] public var labelSize:Number = 12;
		[Savable][Bindable] public var innerRadius:Number = 0;
		[Savable][Bindable] public var explodeRadius:Number = 0;

		[Bindable][Savable] public var group:String = "";
		[Bindable][Savable] public var data:String = "";

		public function PieChartClip()
		{
			super(PieChartClipSkin, PieChartClipEditor);
			type = "piechart";
			rotatable = false;
			
			_QueryDefinition.queryTitle = "PieChart";
			_QueryDefinition.queryDescription = "Data setup for the Pie Chart";
			_QueryDefinition.minRowsReturned = 2;
			_QueryDefinition.maxRowsReturned = 30;
			var newQFD:QueryFieldDefinition = new QueryFieldDefinition(_QueryDefinition);
			newQFD.internalName = "group";
			newQFD.title = "Group";
			newQFD.groupable = true;
			newQFD.description = "This field defines the pie segments";
			newQFD.grouped = true;
			_QueryDefinition.AddFieldDefinition(newQFD);
			newQFD = new QueryFieldDefinition(_QueryDefinition);
			newQFD.internalName = "data";
			newQFD.title = "Data";
			newQFD.description = "This field defines the size of the segments of the pie based on their value and a modifier.";
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
