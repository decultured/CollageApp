package Collage.Application
{
	import spark.components.SkinnableContainer;
	import spark.components.BorderContainer;
	import mx.events.PropertyChangeEvent;
	import spark.components.Group;
	import mx.events.FlexEvent;
	import mx.controls.Alert;
	import Collage.Document.*;
	import Collage.Clip.*;
	import Collage.Clips.*;
	import flash.geom.*;
	import mx.core.*;
	import mx.graphics.*;
	import flash.events.*;
	import flash.desktop.*;
	import flash.display.*;
	import flash.utils.*;
	import Collage.Utilities.Logger.*;
	import mx.events.ResizeEvent;
	
	public class CollageApp extends SkinnableContainer
	{
		[Savable]public var FileFormatVersion:String="1.0";

		[Bindable]public static var instance:CollageApp = null;

		[SkinPart(required="true")]
		public var toolbar:Group;

		[SkinPart(required="true")]
		[Bindable]public var appGrid:Grid;

		[SkinPart(required="true")]
		public var appStatusBar:CollageStatusBar;

		[SkinPart(required="true")]
		public var popupOverlay:SkinnableContainer;

		[SkinPart(required="true")]
		public var welcomeScreen:SkinnableContainer;

		[SkinPart(required="true")]
		[Bindable]public var docContainer:BorderContainer;

		[SkinPart(required="true")]
		[Bindable]public var editPage:EditPage;
		
		[Bindable]public var zoom:Number = 1.0;
		[Bindable]public var fitToScreen:Boolean = false;

		[Bindable]public var pageManager:PageManager = new PageManager();

		[Bindable]public var statusBarVisible:Boolean = false;

		[Bindable]public var tempPageImage:BitmapData = new BitmapData(32, 32, false, 0xffffff);;

		protected var _PopupWindows:Object = new Object();
		protected var _PopupWindowContents:Object = new Object();

		public var clgClipboard:CollageClipboard;

		public function CollageApp():void
		{
			instance = this;
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
				case "docContainer":
					docContainer.removeEventListener(ResizeEvent.RESIZE, DocContainerResized);
					docContainer.addEventListener(ResizeEvent.RESIZE, DocContainerResized);
					return;
				case "fitToScreen":
					if (fitToScreen && docContainer)
						ZoomToSize(docContainer.width, docContainer.height);
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

		protected function DocContainerResized(event:ResizeEvent):void
		{
			if (!fitToScreen)
				return;
				
			ZoomToSize(docContainer.width, docContainer.height);
		}

		public function SaveCurrentPage():void
		{
			//var tempBitmapData:Bitmapdata = ImageSnapshot.captureBitmapData(editPage);

			tempPageImage.fillRect(new Rectangle(0, 0, 32, 32), 0xffffff);
			
			var mat:Matrix = new Matrix();
			if (editPage.width > editPage.height)
				mat.scale(32.0/editPage.width, 32.0/editPage.width);
			else
				mat.scale(32.0/editPage.height, 32.0/editPage.height);

			tempPageImage.draw(editPage, mat);

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

		public function Copy():void
		{
		}

		public function Paste():void
		{
		}

		public function OpenPopup(contents:UIComponent, name:String, modal:Boolean = true):void
		{
			if (_PopupWindows['name']) {
				
			} else {
				
			}
		}

        public function ClosePopup(name:String):void {
	
		}

		public function ZoomOut():void
		{
			if (zoom > 0.1)
				zoom = zoom / 2.0;
			fitToScreen = false;
		}

		public function ZoomIn():void
		{
			if (zoom < 4.0)
				zoom = zoom * 2.0;
			fitToScreen = false;
		}

		public function ZoomToSize(newWidth:Number, newHeight:Number):void
		{
			if (!editPage || !editPage.height || !newHeight)
				return;
			
			var docAspectRatio:Number = editPage.width/editPage.height;
			var containerAspectRatio:Number = newWidth/newHeight;
			
			if (containerAspectRatio >= docAspectRatio) {
				// zoom by height
				zoom = newHeight / editPage.height;
			} else {
				// zoom by width
				zoom = newWidth / editPage.width;
			}
		}

		public function Zoom(amount:Number):void
		{
			zoom = amount;
			fitToScreen = false;
		}

		public function ResetZoom():void
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
