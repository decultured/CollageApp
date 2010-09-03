package Desktop.Application
{
	import Collage.Utilities.WindowManager.*;
	import Collage.Utilities.Logger.*;
	import spark.components.TitleWindow;
	import mx.core.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.desktop.*;
	import flash.display.*;
	
	public class AirWindowManager extends WindowManager
	{
		public static var instance:WindowManager;

		public function AirWindowManager():void
		{
			super();
		}

        override protected function _OpenPopup(contents:UIComponent, title:String, name:String, modal:Boolean = true, size:Point = null):void {
			if (!contents)
				return;

 			var newWindow:CollagePopupWindow = null;
			if (!size)
				size = new Point(500, 350);
				
			contents.setStyle("top", "0");
			contents.setStyle("bottom", "0");
			contents.setStyle("left", "0");
			contents.setStyle("right", "0");
				
			if (_PopupWindows[name] && _PopupWindows[name] is CollagePopupWindow) {
				newWindow = _PopupWindows[name] as CollagePopupWindow;
				newWindow.removeAllElements();
				newWindow.addElement(contents);
			} 
			else if (_PopupWindows[name] && _PopupWindows[name] is TitleWindow) {
				super._OpenPopup(contents, title, name, modal, size);
				return;
			} else {
				newWindow = new CollagePopupWindow();
				newWindow.systemChrome = "none";
				newWindow.type = NativeWindowType.NORMAL;
				newWindow.resizable = false;
				newWindow.width = size.x;
	            newWindow.height = size.y;
				newWindow.transparent = true;
				newWindow.removeAllElements();
				newWindow.setStyle("skinClass", CollagePopupWindowSkin);
				newWindow.addElement(contents);
				newWindow.addEventListener(Event.CLOSE, _HandlePopUpClose);
				_PopupWindows[name] = newWindow;
			}

            try {
                newWindow.open(true);
            } catch (err:Error) {
                Logger.LogError("Problem Opening Popup Window: " + err, this);
            }
        }
		
		protected function _HandlePopUpClose(event:Event):void
		{
			for (var key:String in _PopupWindows) {
				if (_PopupWindows[key] == event.target)
					_PopupWindows[key] = null;
			}
		}
		
        override protected function _ClosePopup(name:String):void {
 			var newWindow:CollagePopupWindow = null;
			if (_PopupWindows[name] && _PopupWindows[name] is CollagePopupWindow) {
				newWindow = _PopupWindows[name] as CollagePopupWindow;
				newWindow.close();
			} 
			else if (_PopupWindows[name] && _PopupWindows[name] is TitleWindow) {
				super._ClosePopup(name);
				return;
			}
        }
	}
}
