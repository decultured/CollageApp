package Collage.Utilities.WindowManager
{
	import Collage.Utilities.Logger.*;
	import flash.geom.*;
	import flash.desktop.*;
	import flash.display.*;
	import mx.core.*;
	
	public class WindowManager
	{
		public static var instance:WindowManager;

		protected var _PopupWindows:Object = new Object();
		protected var _PopupWindowContents:Object = new Object();

		public function WindowManager():void {}
		
		public static function Open(contents:UIComponent, title:String, name:String, modal:Boolean = true, size:Point = null):void
		{
			if (WindowManager.instance)
				instance._OpenPopup(contents, name, title, modal, size);
			else
				Logger.LogError("Please instantiate the WindowManager instance before using");
		}		

		public static function Close(name:String):void
		{
			if (WindowManager.instance)
				instance._ClosePopup(name);
			else
				Logger.LogError("Please instantiate the WindowManager instance before using");
		}		

		public static function StartProgress(message:String, name:String):void
		{
			if (WindowManager.instance)
				instance._StartProgress(message, name);
			else
				Logger.LogError("Please instantiate the WindowManager instance before using");
		}		

		public static function StopProgress(name:String):void
		{
			if (WindowManager.instance)
				instance._StopProgress(name);
			else
				Logger.LogError("Please instantiate the WindowManager instance before using");
		}		

		public static function CloseProgress(name:String, delay:Number = 0):void {
			if (WindowManager.instance)
				instance._CloseProgress(name, delay);
			else
				Logger.LogError("Please instantiate the WindowManager instance before using");
		}		

		protected function _OpenPopup(contents:UIComponent, title:String, name:String, modal:Boolean = true, size:Point = null):void	{
			if (!size)
				size = new Point(500, 350);

			if (_PopupWindows['name']) {
				
			} else {
				
			}
		}

        protected function _ClosePopup(name:String):void {
	
		}

		protected function _StartProgress(message:String, name:String):void	{
			var newProgWin:ProgressOverlayWindow = new ProgressOverlayWindow();
			newProgWin.message = message;
			_OpenPopup(newProgWin, null, name, true, new Point(300, 200));
		}

        protected function _StopProgress(name:String):void {
		}

        protected function _CloseProgress(name:String, delay:Number = 0):void {
			_ClosePopup(name);
		}
	}
}
