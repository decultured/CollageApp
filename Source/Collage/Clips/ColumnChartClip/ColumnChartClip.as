package Collage.Clips.ColumnChartClip
{
	import Collage.Clip.*;
	import Collage.DataEngine.*;
	import mx.events.PropertyChangeEvent;
	
	public class ColumnChartClip extends DataClip
	{
		[Bindable][Savable] public var barAlpha:Number = 1.0;
		[Bindable][Savable] public var barColor:Number = 0x00AA00;
		
		// Grid Options
		[Bindable][Savable] public var gridVisible:Boolean = true;
		[Bindable][Savable] public var gridDirection:String = "horizontal";
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
		[Bindable][Savable] public var hAxisLabelAlpha:Number = 0x333333;
        [Bindable][Savable] public var hAxisLabelGap:Number = 10;
        [Bindable][Savable] public var hAxisLabelRotation:Number = 0;
		
		[Bindable][Savable] public var group:String = "";
		[Bindable][Savable] public var data:String = "";

		public function ColumnChartClip()
		{
			super(ColumnChartClipSkin, ColumnChartClipEditor);
			type = "columnchart";
			rotatable = false;
			_QueryDefinition.queryTitle = "Column Chart";
			_QueryDefinition.queryDescription = "Data setup for the Column Chart";
			_QueryDefinition.minRowsReturned = 2;
			_QueryDefinition.maxRowsReturned = 30;
			var newQFD:QueryFieldDefinition = new QueryFieldDefinition(_QueryDefinition);
			newQFD.internalName = "group";
			newQFD.title = "Group";
			newQFD.groupable = true;
			newQFD.description = "This field defines the bar segments";
			newQFD.grouped = true;
			_QueryDefinition.AddFieldDefinition(newQFD);
			newQFD = new QueryFieldDefinition(_QueryDefinition);
			newQFD.internalName = "data";
			newQFD.title = "Data";
			newQFD.description = "This field defines the size of the bars based on their value and a modifier.";
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
