package Collage.DataEngine
{
	import mx.collections.ArrayList;

	public class QueryDefinition
	{
		public var queryTitle:String = "";
		public var queryDescription:String = "";
		
		[Bindable]public var fieldDefinitions:ArrayList = new ArrayList();

		public var whereClauseAllowed:Boolean;
		
		public var minRowsReturned:Number = 1;
		public var maxRowsReturned:Number = 1000;

		public function QueryDefinition():void
		{
			
		}
		
		public function AddFieldDefinition(_fieldDefinition:QueryFieldDefinition):void
		{
			fieldDefinitions.addItem(_fieldDefinition);
		}
	}
}