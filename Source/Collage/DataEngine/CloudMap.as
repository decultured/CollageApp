package Collage.DataEngine
{
	import Collage.Utilities.json.*;
	import mx.graphics.ImageSnapshot;
	import Collage.Application.*;
	import Collage.DataEngine.*;
	import Collage.DataEngine.Storage.*;
	import Collage.Clips.Map.*;
	import Collage.Utilities.Logger.*;
	import flash.events.*;
	import flash.geom.*;
	
	public class CloudMap
	{
		public static var SAVE_TO_CLOUD_WINDOW:String = "saveMapToCloud";
		public static var OPEN_FROM_CLOUD_WINDOW:String = "openMapFromCloud";
		
		private var _SaveWindow:MapSaveUI;
		private var _OpenWindow:MapListUI;

		// cloud map file
		private var _Map:MapFile;

		private var _AppClass:CollageBaseApp;
		private var _MapClip:MapClip;


		public function CloudMap(appClass:CollageBaseApp, mapClip:MapClip)
		{
			_AppClass = appClass;
			_MapClip = mapClip;
		}

		public function Save():void {
			_SaveWindow = new MapSaveUI();
			_AppClass.OpenPopup(_SaveWindow, SAVE_TO_CLOUD_WINDOW, true, new Point(300, 150));
			_SaveWindow.addEventListener(MapSaveUI.CLOSED, SaveWindowClosed);
			_SaveWindow.addEventListener(MapSaveUI.COMPLETE, SaveWindowComplete);
	
			if(_Map != null) {
				if(_Map.Title != null) {
					_Map.Title = _Map.Title;
				}
				if(_Map.ID != null) {
					_SaveWindow.dispatchEvent(new Event(MapSaveUI.COMPLETE));
					_SaveWindow.dispatchEvent(new Event(MapSaveUI.CLOSED));
				}
			}
		}

		public function SaveWindowClosed(e:Event):void {
			_AppClass.ClosePopup(SAVE_TO_CLOUD_WINDOW);
		}

		public function SaveWindowComplete(e:Event):void
		{
			var jsonFile:String = JSON.encode(_MapClip.SaveMapToObject());

			if(_Map == null) {
				_Map = new MapFile();
				_Map.addEventListener(CloudFile.SAVE_SUCCESS, HandleSaveSuccess)
				_Map.addEventListener(CloudFile.SAVE_FAILURE, HandleSaveFailure)
			}

			_Map.Title = _SaveWindow.Title;
			_Map.Content = jsonFile;

			if (_MapClip.view) {
				var snapshot:ImageSnapshot = ImageSnapshot.captureImage(_MapClip.view);
				_Map.Filedata = snapshot.data;
			}

			try{
				Logger.Log("Saving to cloud", this);
				_Map.Save();
			} catch(e:Error){
				Logger.LogError(e.message, this);
			}
			
			_AppClass.ClosePopup(SAVE_TO_CLOUD_WINDOW);
		}

		public function HandleSaveSuccess(event:Event):void {
			Logger.Log("Saved to cloud", this);
		}

		public function HandleSaveFailure(event:Event):void {
			Logger.LogError("Failure saving to cloud", this);
			if (_Map)
				_Map.ID = null;
		}
		
		public function Open():void {
			_OpenWindow = new MapListUI();
			_AppClass.OpenPopup(_OpenWindow, OPEN_FROM_CLOUD_WINDOW, true, new Point(450, 350));
			_OpenWindow.addEventListener(MapSaveUI.CLOSED, OpenWindowClosed);
			_OpenWindow.addEventListener(MapSaveUI.COMPLETE, OpenWindowComplete);
		}

		public function OpenWindowClosed(e:Event):void {
			_AppClass.ClosePopup( OPEN_FROM_CLOUD_WINDOW );
			_OpenWindow = null;
		}

		public function OpenWindowComplete(e:Event):void
		{
			_Map = null;
			_Map = new MapFile();
			_Map.addEventListener(CloudFile.OPEN_SUCCESS, HandleOpenSuccess)
			_Map.addEventListener(CloudFile.OPEN_FAILURE, HandleOpenFailure)

			try{
				Logger.Log("Opening from cloud - id: " + _OpenWindow.MapID, this);
				_Map.Open( _OpenWindow.MapID );
			} catch(e:Error){
				Logger.LogError(e.message, this);
			}
		}

		public function OpenMapByID(id:String):void
		{
			_Map = null;
			_Map = new MapFile();
			_Map.addEventListener(CloudFile.OPEN_SUCCESS, HandleOpenSuccess)
			_Map.addEventListener(CloudFile.OPEN_FAILURE, HandleOpenFailure)

			try{
				Logger.Log("Opening from cloud - id: " + id, this);
				_Map.Open(id);
			} catch(e:Error){
				Logger.LogError(e.message, this);
			}
		}

		public function HandleOpenSuccess(event:Event):void {
			Logger.Log("Opened from cloud", this);

			var fileData:Object = JSON.decode( _Map.Content );
		    _MapClip.LoadMapFromObject(fileData);
		}

		public function HandleOpenFailure(event:Event):void {
			Logger.LogError("Failure opening from cloud", this);
			if (_Map)
				_Map.ID = null;
		}
		
	}
}