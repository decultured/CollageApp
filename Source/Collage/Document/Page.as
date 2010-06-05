package Collage.Document
{
	import Collage.Utilities.Logger.*;
	import mx.core.*;  
	import spark.components.Group;
	import Collage.Clip.*;
	import flash.utils.*;
	import mx.utils.*;
	
	public class Page extends Group
	{
		[Savable]public var UID:String;

		public static var DEFAULT_WIDTH:Number = 1024;
		public static var DEFAULT_HEIGHT:Number = 768;
		
		[Bindable][Savable]public var displayName:String = "Untitled";
		[Bindable][Savable]public var backgroundURL:String = null;
		[Bindable][Savable]public var backgroundColor:Number = 0xFFFFFF;
		
		private var _Loading:Boolean = false;
		
		private var _Clips:Object = new Object();
		
		public function Page():void
		{
			setStyle("dropShadowVisible", true);
			New();
		}

		public function NewUID():void
		{
			UID = UIDUtil.createUID();
		}

		public function New():void
		{
			NewUID();
			width = DEFAULT_WIDTH;
			height = DEFAULT_HEIGHT;
			backgroundURL = null;
			backgroundColor = 0x555555;
			DeleteAllClips();
			_Clips = new Object();
			Logger.LogDebug("Page Reset", this);
		}

		public function ViewResized():void
		{
			// TODO : Reposition all objects to fit in new size
		}

		public function AddClip(clip:Clip):Clip
		{
			if (clip && !_Clips[clip.UID]) {
				_Clips[clip.UID] = clip;
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
			if (clip) {
				Logger.LogDebug("Clip Deleted", clip);
				_Clips[clip.UID] = null;
				removeElement(clip.view);
			}
		}
		
		public function DeleteAllClips():void
		{
			for (var i:int = numElements - 1; i > -1; i--) {
				if (getElementAt(i) is ClipView) {
					var clipView:ClipView = getElementAt(i) as ClipView;
					DeleteClip(clipView.model as Clip);
				}
			}
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
					clipView.model.zindex = i;
					newObject["clips"].push(clipView.model.SaveToObject());
				}
			}

			return newObject;
		}

		public function LoadFromObject(dataObject:Object):Boolean
		{
			New();

			Logger.LogDebug("PageLoading", this);
			
			if (!dataObject) {
				Logger.LogWarning("PageLoading - dataObject was NULL", this);
				return false;
			}

			for (var key:String in dataObject)
			{
				if (key == "clips") {
					if (!dataObject[key] is Array)
						continue;
					var clipArray:Array = dataObject[key] as Array;
					for (var i:uint = 0; i < clipArray.length; i++) {
						var clipDataObject:Object = clipArray[i] as Object;
						if (!clipDataObject["type"])
							continue;
						var newClip:Clip = AddClipByType(clipDataObject["type"]);
						if (newClip)
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