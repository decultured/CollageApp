package Collage.Document
{
	import Collage.Utilities.Logger.*;
	import flash.utils.*;

	public class PageManager
	{
		private var _Pages:Array = new Array();
		private var _CurrentPage:int = 0;
		
		public function get pageArray():Array {	return _Pages; }
		public function set pageArray(pagesArray:Array):void
		{
			if (!pagesArray || !pagesArray.length) {
				New();
				return;
			}
			_Pages = pagesArray;
			_CurrentPage = 0;
		}

		public function get currentPage():Object { return GetPage(_CurrentPage);	}
		public function set currentPage(pageData:Object):void { SetPage(_CurrentPage, pageData); }

		public function PageManager()
		{
			New();
		}
		
		public function New(addPage:Boolean = true):void
		{
			Logger.LogDebug("PageManager Reset", this);
			_Pages = new Array();
			if (addPage)
				_Pages[0] = new Object();
			_CurrentPage = 0;
		}
		
		public function GetPage(index:int):Object
		{
			return _Pages[index];
		}

		public function SetPage(index:int, pageObject:Object):void
		{
			_Pages[index] = pageObject;
		}

		public function AddPage(dataObject:Object):void
		{
			var newObject:Object = new Object();
			if (dataObject)
				newObject = dataObject;
			_Pages.push(newObject);
			Logger.LogDebug("Page Added", this);
		}
		
		public function RemovePage(index:int):void
		{
			
		}
		
		public function SwapPages(firstIndex:int, secondIndex:int):void
		{
			
		}
	} 
}