package Collage.DataEngine
{
	public class QueryFieldDefinition
	{
		public var owner:QueryDefinition;
		[Bindable]public var internalName:String = "";
		[Bindable]public var title:String = "";
		[Bindable]public var description:String = "";
		[Bindable]public var grouped:Boolean = false;
		[Bindable]public var groupable:Boolean = false;
		[Bindable]public var sortable:Boolean = false;
		[Bindable]public var sortDirection:String = null;
		[Bindable]public var allowModifiers:Boolean = false;
		[Bindable]public var modifier:String = null;
               
		public var allowedTypes:Array = new Array();
		
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