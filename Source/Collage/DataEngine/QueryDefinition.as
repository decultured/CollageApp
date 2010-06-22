package Collage.DataEngine
{
	import Collage.Clip.*;
	import mx.collections.ArrayList;

	public class QueryDefinition
	{
		[Bindable]public var owner:DataClip = null;
		public var queryTitle:String = "";
		public var queryDescription:String = "";
		
		[Bindable]public var fieldDefinitions:ArrayList = new ArrayList();

		public var whereClauseAllowed:Boolean;
		
		[Bindable]public var minRowsReturned:Number = 1;
		[Bindable]public var maxRowsReturned:Number = 1000;

		[Bindable]public var selectedDataSetID:String;

		public function QueryDefinition(_owner:DataClip):void
		{
			owner = _owner;
		}
		
		public function AddFieldDefinition(_fieldDefinition:QueryFieldDefinition):void
		{
			fieldDefinitions.addItem(_fieldDefinition);
		}
	}
}