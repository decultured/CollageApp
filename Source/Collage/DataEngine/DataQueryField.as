package Collage.DataEngine
{
	import Collage.Utilities.Logger.*;
	import mx.collections.ArrayList;

	public class DataQueryField
	{
		public var internalName:String = null;
		public var sort:String = null;
		public var modifier:String = null;
		public var group:String = null;
		public var columnName:String = null;
		public var alias:String = null;
		
		public function get isGrouped():Boolean {return (group != null)};
		public function set isGrouped(_group:Boolean):void
		{
			if (_group)
				group = "val"
			else
				group = null;
		}

		public function get resultName():String
		{
			if (alias)
				return alias;
			else
				return columnName;
		}

		public function DataQueryField(_internalName:String = "", _columnName:String = "", _sort:String = null,  _modifier:String = null, _group:String = null, _alias:String = null):void
		{
			internalName = _internalName;
			columnName = _columnName;
			sort = _sort;
			modifier = _modifier;
			group =	_group;
			alias =	_alias;
		}
	}
}