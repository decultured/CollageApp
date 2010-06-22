package Collage.DataEngine
{
	public class QueryFieldDefinition
	{
		public var owner:QueryDefinition;
		public var internalName:String = "";
		public var title:String = "";
		public var description:String = "";
		public var grouped:Boolean = false;
		public var sortable:Boolean = false;
		public var allowModifiers:Boolean = false;
               
		public var allowedTypes:Array = new Array();

		public var sortDirection:String;
		public var selectedColumn:String;
		public var selectedModifier:String;
		
		public function QueryFieldDefinition(_owner:QueryDefinition):void
		{
			owner = _owner;
		}
		
		public function AddAllowedType(_type:String):void
		{
			allowedTypes.push(_type);
		}
	}
}