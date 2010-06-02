package Collage.Application
{
	import spark.components.SkinnableContainer;
	import spark.components.Group;
	import mx.events.FlexEvent;
	import mx.controls.Alert;
	import Collage.Document.*;
	import Collage.Clip.*;
	import Collage.Clips.*;
	import mx.core.*;
	import flash.events.*;
	import flash.desktop.*;
	import flash.utils.*;
	import Collage.Utilities.Logger.*;
	
	public class CollageApp extends SkinnableContainer
	{
		public var clgClipboard:CollageClipboard;

		[SkinPart(required="true")]
		public var toolbar:Group;

		[SkinPart(required="true")]
		public var optionsBox:Group;

		[SkinPart(required="true")]
		public var appStatusBar:CollageStatusBar;

		[SkinPart(required="true")]
		public var editPage:EditPage;

		[Savable]public var TestVar:String="This is a test!"

		public var pageManager:PageManager = new PageManager();

		public function CollageApp():void
		{
			Logger.LogDebug("App Created", this);
			clgClipboard = new CollageClipboard(this);
		}

		public function Quit():void
		{
		}

		public function Fullscreen():void
		{
		}

		public function SaveImage():void
		{
		}

		public function SavePDF():void
		{
		}

		public function UploadDataFile():void
		{
		}

		public function SaveToObject():Object
		{
			// Load App Stuff
			var typeDef:XML = describeType(this);
			var newObject:Object = new Object();
			for each (var metadata:XML in typeDef..metadata) {
				if (metadata["@name"] != "Savable") continue;
				if (this.hasOwnProperty(metadata.parent()["@name"]))
					newObject[metadata.parent()["@name"]] = this[metadata.parent()["@name"]];
			}

			pageManager.currentPage = editPage.SaveToObject();

			// Load Pages
			newObject["pages"] = pageManager.pageArray;

			return newObject;
		}


		public function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject) return false;

			pageManager.New(false);
			editPage.New();
			
			Logger.Log("Document Loading", this);
			
			for (var key:String in dataObject)
			{
				if (key == "document") {
					for(var obj_k:String in dataObject[key]) {
						try {
							if(this.hasOwnProperty(obj_k))
								this[obj_k] = dataObject[obj_k];
						} catch(e:Error) { }
					}
				} else if (key == "pages") {
					if (!dataObject[key] is Array)
						continue;

					pageManager.pageArray = dataObject[key];
				}
			}
			
			editPage.LoadFromObject(pageManager.currentPage);
			
			return true;
		}
	}	
}
