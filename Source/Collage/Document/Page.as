package Collage.Document
{
	import Collage.Utilities.Logger.*;
	import mx.core.*;  
	import spark.components.Group;
	import Collage.Clip.*;
	import flash.utils.*;
	
	public class Page extends Group
	{
		public static var DEFAULT_WIDTH:Number = 1024;
		public static var DEFAULT_HEIGHT:Number = 768;
		
		[Bindable][Savable]public var backgroundURL:String = null;
		[Bindable][Savable]public var backgroundColor:Number = 0xFFFFFF;
		
		private var _Clips:Object = new Object();

		public function Page():void
		{
			setStyle("dropShadowVisible", true);
			New();
		}

		public function New():void
		{
			width = DEFAULT_WIDTH;
			height = DEFAULT_HEIGHT;
			backgroundURL = null;
			backgroundColor = 0x555555;
//			setStyle("backgroundColor", backgroundColor);

			// TODO : Properly unload clips from memory

			Logger.LogDebug("Page Reset", this);
			_Clips = new Object();
		}

		public function ViewResized():void
		{
			// TODO : Reposition all objects to fit in new size
		}

		public function AddClip(clip:Clip):Clip
		{
			if (clip && !_Clips[clip.uid]) {
				_Clips[clip.uid] = clip;
				addElement(clip.view);
				Logger.LogDebug("Clip Added", clip);
				return clip;
			}
			Logger.LogWarning("Problem Adding Clip", clip);
			return null;
		}

		public function AddClipByType(type:String):Clip
		{
			return AddClip(ClipFactory.CreateByType(type));
		}
		
		public function DeleteClip(clip:Clip):void
		{
			
		}
		
		public function SaveToObject():Object
		{
			var typeDef:XML = describeType(this);
			var newObject:Object = new Object();
			for each (var metadata:XML in typeDef..metadata) {
				if (metadata["@name"] != "Savable") continue;
				if (this.hasOwnProperty(metadata.parent()["@name"]))
					newObject[metadata.parent()["@name"]] = this[metadata.parent()["@name"]];
			}

			newObject["clips"] = new Array();

			for (var i:int = 0; i < numElements; i++) {
				if (getElementAt(i) is ClipView) {
					var clipView:ClipView = getElementAt(i) as ClipView;
					newObject["clips"].push(clipView.model.SaveToObject());
				}
			}

			return newObject;
		}

		public function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject) return false;

			New();
			
			Logger.LogDebug("PageLoading", this);
			for (var key:String in dataObject)
			{
				Logger.LogDebug("KeyDump " + key, this);
				if (key == "clips") {
					if (!dataObject[key] is Array)
						continue;
					var clipArray:Array = dataObject[key] as Array;
					for (var i:uint = 0; i < clipArray.length; i++) {
						var clipDataObject:Object = clipArray[i] as Object;
						Logger.LogDebug("Clip KeyDump " + i + " " + clipDataObject["type"], this);
						if (!clipDataObject["type"])
							continue;
						var newClip:Clip = AddClipByType(clipDataObject["type"]);
						newClip.LoadFromObject(clipDataObject);
					}
				} else {
					try {
						if(this.hasOwnProperty(key))
							this[key] = dataObject[key];
					} catch(e:Error) { }
				}
			}
			return true;
		}
	} 
}