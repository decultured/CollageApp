package Collage.Clips
{
	class ClipModel
	{
		public var clipData:Object = new Object();
		
		public var selected:Boolean = false;
		public var x:Number = 10;
		public var y:Number  = 10;
		public var height:Number = 150;
		public var width:Number = 150;
		public var rotation:Number = 0;
		
		public var verticalSizable:Boolean = true;
		public var horizontalSizable:Boolean = true;
		public var moveFromCenter:Boolean = false;
		public var rotatable:Boolean = false;
		
		public function ClipModel():void
		{
			
		}
		
		public function Resized():void { }
		public function Moved():void { }
 		public function Rotated():void { }
		public function LoadFromData(data:Object):Boolean { return false; }
		public function LoadFromXML():Boolean {	return false; }
		
		public function SaveToObject():Object
		{
			var typeDef:XML = describeType(this);
			
			var newObject:Object = new Object();

			for each (var metadata:XML in typeDef..metadata)
			{
				Logger.Log(metadata["@name"], LogEntry.DEBUG, this);
				if (metadata["@name"] != "Savable")
					continue;

				if (this.hasOwnProperty(metadata.parent()["@name"]))
					newObject[metadata.parent()["@name"]] = this[metadata.parent()["@name"]];
			}

			return newObject;
		}

		public function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject)
				return false;

			for(var obj_k:String in dataObject) {
				try {
					if(this.hasOwnProperty(obj_k))
						this[obj_k] = dataObject[obj_k];
				} catch(e:Error) {
					
				}
			}

			return true;
		}
		
	}
}