package Collage.DataEngine
{
	import Collage.Utilities.Logger.*;
	import mx.collections.ArrayList;
	import flash.utils.*;

	public class DataQueryField
	{
		[Savable] public var internalName:String = null;
		[Savable] public var sort:String = null;
		[Savable] public var modifier:String = null;
		[Savable] public var group:String = null;
		[Savable] public var columnName:String = null;
		[Savable] public var alias:String = null;
		
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
		
		public function SaveToObject():Object
		{
			var typeDef:XML = describeType(this);
			var newObject:Object = new Object();
			for each (var metadata:XML in typeDef..metadata) {
				if (metadata["@name"] != "Savable")
					continue;
				if (this.hasOwnProperty(metadata.parent()["@name"])) {
					newObject[metadata.parent()["@name"]] = this[metadata.parent()["@name"]];
				}
			}

			return newObject;
		}

		public function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject) return false;
			for(var obj_k:String in dataObject) {
				try {
					if(this.hasOwnProperty(obj_k)) {
						this[obj_k] = dataObject[obj_k];
					}
				} catch(e:Error) { }
			}
			return true;
		}
	}
}