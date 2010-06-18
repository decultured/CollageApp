package Collage.DataEngine
{
	public class QueryFieldDefinition
	{
		public var title:String = "";
		public var description:String = "";
		public var grouped:Boolean = false;
		public var allowModifiers:Boolean = false;
               
		public var allowedTypes:Array = new Array();
		
		public function QueryFieldDefinition():void
		{
		}
		
		public function AddAllowedType(_type:String):void
		{
			allowedTypes.push(_type);
		}
	}
}