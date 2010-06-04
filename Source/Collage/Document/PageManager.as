package Collage.Document
{
	import Collage.Utilities.Logger.*;
	import flash.utils.*;
	import mx.collections.*;
	import flash.events.EventDispatcher;
	
	public class PageManager extends EventDispatcher
	{
		[Bindable]public var pages:ArrayList = new ArrayList();
		private var _CurrentPage:uint = 0;
		private var pagesAdded:uint = 0;
		
		public function get currentPage():Object { return GetPageAt(_CurrentPage);	}
		public function set currentPage(pageData:Object):void
		{ 
			SetPageAt(pageData, currentPageIndex);
		}

		public function get numPages():uint { return pages.length; }

		[Bindable]
		public function get currentPageIndex():uint { return _CurrentPage;	}
		public function set currentPageIndex(newPage:uint):void
		{
			if (newPage >= pages.length)
				newPage = pages.length - 1;
			
//			dispatchEvent(new PageChangeEvent(PageChangeEvent.PAGE_INDEX_CHANGED, _CurrentPage, newPage));
			_CurrentPage = newPage;
		}

		public function PageManager()
		{
			New();
		}
		
		public function LoadFromArray(newArray:Array):void
		{
			New(false);
			pages = new ArrayList(newArray);
		}
		
		public function New(addPage:Boolean = true):void
		{
			Logger.LogDebug("PageManager Reset", this);
			currentPageIndex = 0;
			pagesAdded = 0;
			pages = new ArrayList();
			if (addPage)
				NewPage();
		}
		
		public function NextPage():void
		{
			if (currentPageIndex < pages.length - 1)
				currentPageIndex++;
		}
		
		public function PrevPage():void
		{
			if (currentPageIndex > 0)
				currentPageIndex--;
		}

		public function GetPageAt(index:uint):Object
		{
			if (index >= pages.length)
				return null;
				
			return pages.getItemAt(index);
		}

		public function SetPageAt(pageObject:Object, index:uint):void
		{
			if (index >= pages.length)
				return;
				
			pages.setItemAt(pageObject, index);
		}

		public function GetPageIndexByUID(uid:String):int
		{
			var foundPageIndex:int = -1;
			for (var pageIndex:uint = 0; pageIndex < pages.length; pageIndex++) {
				var pageObject:Object = pages.getItemAt(pageIndex) as Object;
				if (pageObject["UID"] == uid) {
					foundPageIndex = pageIndex;
					break;
				}
			}
			return foundPageIndex;
		}

		public function SetPageByUID(pageObject:Object, uid:String, preserveName:Boolean = true):void
		{
			var pageIndex:int = GetPageIndexByUID(uid);
			if (pageIndex > -1) {
				if (preserveName)
					pageObject["displayName"] = GetPageAt(pageIndex)["displayName"];
				pages.setItemAt(pageObject, pageIndex);
				Logger.Log("UID FOUND!: " + uid, this);
			} else
				Logger.LogCritical("UID NOT FOUND: " + uid, this);
			
		}

		public function AddPage(dataObject:Object):void
		{
			AddPageAt(dataObject, currentPageIndex + 1);
		}

		public function NewPage():void
		{
			NewPageAt(currentPageIndex + 1);
		}

		public function RemovePage():void
		{
			RemovePageAt(currentPageIndex);
		}

		public function CopyPage():void
		{
			CopyPageAt(currentPageIndex);
		}
		
		public function GetUniqueName(currentName:String = null):String
		{
			if (!currentName)
				currentName = "Untitled";
			
			var testName:String = currentName;
			var found:Boolean = true;
			var increment:uint = 1;
			while (found) {
				found = false;
				for (var pageIndex:uint = 0; pageIndex < pages.length; pageIndex++) {
					var pageObject:Object = pages.getItemAt(pageIndex) as Object;
					if (pageObject["displayName"] == testName) {
						found = true;
						break;
					}
				}
				if (!found)
					return testName;
				testName = currentName + " (" + increment + ")";
				increment++;
			}
			return "NEW PAGE NAME???";
		}

		public function AddPageAt(dataObject:Object, index:uint):void
		{
			if (!dataObject)
				return NewPageAt(index);
			if (index >= pages.length) {
				pages.addItem(dataObject);
				currentPageIndex = pages.length - 1;
			} else {
				pages.addItemAt(dataObject, index);
				currentPageIndex = index;
			}
			Logger.LogDebug("Page Added", this);
		}

		public function NewPageAt(index:uint):void
		{
			var newObject:Object = (new Page()).SaveToObject();

			while (GetPageIndexByUID(newObject["UID"]) > -1) {
				newObject = (new Page()).SaveToObject();
			}
			
			pagesAdded++;
			newObject["displayName"] = GetUniqueName();
			if (index >= pages.length) {
				pages.addItem(newObject);
				currentPageIndex = pages.length - 1;
			} else {
				pages.addItemAt(newObject, index);
				currentPageIndex = index;
			}
			Logger.LogDebug("Page Added", this);
		}

		public function RemovePageAt(index:uint):void
		{
			if (index >= pages.length || pages.length < 2) {
				return;
			}
			pages.removeItemAt(index);
			currentPageIndex = index;

			Logger.LogDebug("Page Removed", this);
		}

		public function CopyPageAt(index:uint):void
		{
			if (index >= pages.length)
				return;
				
			var newObject:Page = new Page();
			newObject.LoadFromObject(GetPageAt(index));
			newObject.NewUID();
			newObject.displayName = GetUniqueName(newObject.displayName);
			
			pages.addItemAt(newObject.SaveToObject(), index);
			currentPageIndex = index;
			Logger.LogDebug("Page Copied", this);
		}

		public function SwapPages(firstIndex:uint, secondIndex:uint):void
		{
			if (firstIndex >= pages.length || secondIndex >= pages.length)
				return;

			var firstObject:Object = GetPageAt(firstIndex);
			var secondObject:Object = GetPageAt(secondIndex);
			
			pages.setItemAt(secondObject, firstIndex);
			pages.setItemAt(firstObject, secondIndex);
		}
	} 
}