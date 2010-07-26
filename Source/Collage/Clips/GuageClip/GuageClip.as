package Collage.Clips.GuageClip
{
	import Collage.Clip.*;
	import Collage.DataEngine.*;
	import Collage.Utilities.Logger.*;
	import mx.events.PropertyChangeEvent;
	
	public class GuageClip extends DataClip
	{
		[Savable][Bindable] public var guageBackgroundColor:Number = 0x327bc2;
		[Savable][Bindable] public var bezelColor:Number = 0xAAAAAA;
		[Savable][Bindable] public var measureMarksColor:Number = 0xFFFFFF;
		[Savable][Bindable] public var measureMarksAlpha:Number = 1;
		[Savable][Bindable] public var startAngle:Number = 45;
		[Savable][Bindable] public var endAngle:Number = 315;
		[Savable][Bindable] public var indicatorColor:Number = 0xFC5976;
		[Savable][Bindable] public var indicatorCrownColor:Number = 0xAAAAAA;
		
		[Savable][Bindable] public var minimum:Number = 0;
		[Savable][Bindable] public var maximum:Number = 100;
		[Savable][Bindable] public var value:Number = 75;
		[Savable][Bindable] public var valueField:String = null;

		public function GuageClip()
		{
			super(GuageClipSkin, GuageClipEditor);
			type = "guage";
			rotatable = false;
			
			_QueryDefinition.queryTitle = "Guage";
			_QueryDefinition.queryDescription = "Data setup for the Guage";
			_QueryDefinition.minRowsReturned = 1;
			_QueryDefinition.maxRowsReturned = 1;
			var newQFD:QueryFieldDefinition = new QueryFieldDefinition(_QueryDefinition);
			newQFD.internalName = "valueField";
			newQFD.title = "Value";
			newQFD.groupable = true;
			newQFD.description = "This field defines the value of the Guage.";
			newQFD.AddAllowedType("numeric");
			_QueryDefinition.AddFieldDefinition(newQFD);
		}
	}
}