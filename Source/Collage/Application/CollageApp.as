package Collage.Application
{
	import spark.components.SkinnableContainer;
	import mx.events.PropertyChangeEvent;
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
		[Savable]public var FileFormatVersion:String="1.0";

		[SkinPart(required="true")]
		public var toolbar:Group;

		[SkinPart(required="true")]
		[Bindable]public var appGrid:Grid;

		[SkinPart(required="true")]
		public var appStatusBar:CollageStatusBar;

		[SkinPart(required="true")]
		[Bindable]public var editPage:EditPage;

		[Bindable]public var pageManager:PageManager = new PageManager();

		[Bindable]public var statusBarVisible:Boolean = false;

		public var clgClipboard:CollageClipboard;

		public function CollageApp():void
		{
			Logger.LogDebug("App Created", this);
			clgClipboard = new CollageClipboard(this);
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, PropertyChangeHandler);
			pageManager.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, PageManagerChanged);
		}
		
		protected function PropertyChangeHandler(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{
				case "editPage":
					Logger.Log("Edit Page Added");
					editPage.LoadFromObject(pageManager.currentPage);
					return;
			}
		}

		protected function PageManagerChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{
				case "currentPageIndex":
					Logger.Log("Page Index Changed");
					SaveCurrentPage();
					editPage.LoadFromObject(pageManager.currentPage);
					return;
			}
		}

		public function SaveCurrentPage():void
		{
			pageManager.SetPageByUID(editPage.SaveToObject(), editPage.UID);
		}

		public function New():void
		{
			pageManager.New(true);
			editPage.LoadFromObject(pageManager.currentPage);
		}
		
		public function Quit():void { }

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
			newObject["pages"] = pageManager.pages.toArray();

			return newObject;
		}


		public function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject) return false;

			New();
			
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

					pageManager.LoadFromArray(dataObject[key]);
				}
			}
			
			editPage.LoadFromObject(pageManager.currentPage);
			
			return true;
		}

		public function OpenFile():void
		{
		}
		
		public function SaveFile():void
		{
		}
	}	
}
