package Desktop.Application
{
	import mx.graphics.ImageSnapshot;
	import Collage.Utilities.Logger.*;
	import Collage.Utilities.json.*;
	import Collage.Application.*;
	import Collage.DataEngine.*;
	import Collage.Document.*;
	import Collage.Clips.*;
	import Collage.Clip.*;
	import spark.components.TitleWindow;
	import flash.display.StageDisplayState;
	import flash.filesystem.*;
	import flash.desktop.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	import mx.core.*;
	
	public class AppMain extends CollageApp
	{
		public function AppMain():void
		{
			super();

			// load the auth token
			Session.AuthToken = AIRSecureStorage.getItem('apiAuthToken');
//			welcomeScreen.loginForm.email_address.text = AIRSecureStorage.getItem('stored_email');

			Session.events.addEventListener(Session.LOGIN_SUCCESS, HandleLoginSuccess);
			Session.events.addEventListener(Session.TOKEN_EXPIRED, HandleTokenExpired);
			Session.CheckToken();
		}
		
		public function HandleLoginSuccess(event:Event):void {
			AIRSecureStorage.setItem('apiAuthToken', Session.AuthToken);
			DataEngine.LoadAllDataSets();
			
			if (welcomeScreen)
				welcomeScreen.visible = false;
		}

		public function HandleLoginFailure(event:Event):void {
			Session.AuthToken = null;
			AIRSecureStorage.removeItem('apiAuthToken');
			
			if (welcomeScreen)
				welcomeScreen.visible = true;
		}

        public override function OpenPopup(contents:UIComponent, name:String, modal:Boolean = true, size:Point = null):void {
 			var newWindow:CollagePopupWindow = null;

			if (!size)
				size = new Point(500, 350);
				
			if (_PopupWindows[name] && _PopupWindows[name] is CollagePopupWindow) {
				newWindow = _PopupWindows[name] as CollagePopupWindow;
				newWindow.removeAllElements();
				newWindow.addElement(contents);
			} 
			else if (_PopupWindows[name] && _PopupWindows[name] is TitleWindow) {
				super.OpenPopup(contents, name, modal);
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
				newWindow.addEventListener(Event.CLOSE, HandlePopUpClose);
				_PopupWindows[name] = newWindow;
				Logger.LogDebug("Added Popup Window: " + name, this);
			}

            try {
                newWindow.open(true);
            } catch (err:Error) {
                Logger.LogError("Problem Opening Popup Window: " + err, this);
            }
        }
		
		public function HandlePopUpClose(event:Event):void
		{
			for (var key:String in _PopupWindows) {
				if (_PopupWindows[key] == event.target)
					_PopupWindows[key] = null;
			}
		}
		
        public override function ClosePopup(name:String):void {
 			var newWindow:CollagePopupWindow = null;
			if (_PopupWindows[name] && _PopupWindows[name] is CollagePopupWindow) {
				newWindow = _PopupWindows[name] as CollagePopupWindow;
				newWindow.close();
				Logger.LogDebug("Closed Popup Window: " + name, this);
			} 
			else if (_PopupWindows[name] && _PopupWindows[name] is TitleWindow) {
				super.ClosePopup(name);
				return;
			}
        }
		
		public function HandleTokenExpired(event:Event):void {
			Session.AuthToken = null;
			AIRSecureStorage.removeItem('apiAuthToken');
			
			if (welcomeScreen)
				welcomeScreen.visible = true;
		}

		public override function Quit():void
		{
			NativeApplication.nativeApplication.exit();	
		}
		
		public override function Fullscreen():void
		{
			if (stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
				stage.displayState = StageDisplayState.NORMAL;
			else
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		
		public override function SaveFile():void
		{
			var file:File = File.desktopDirectory.resolvePath("file.clg");
			file.addEventListener(Event.SELECT, SaveFileEvent);
			file.browseForSave("Save As");
		}

		protected function SaveFileEvent(event:Event):void
		{
			var jsonFile:String = JSON.encode(SaveToObject());
			var newFile:File = event.target as File;
			var fs:FileStream = new FileStream();
			try{
				fs.open(newFile,FileMode.WRITE);
				jsonFile = jsonFile.replace(/\n/g, File.lineEnding);
				fs.writeUTFBytes(jsonFile);
				fs.close();
				Logger.Log("File Saved: " + newFile.url, this);
			} catch(e:Error){
				Logger.Log(e.message, this);
			}
		}
		
		public function SaveLogFile():void
		{
			var file:File = File.desktopDirectory.resolvePath("file.txt");
			file.addEventListener(Event.SELECT, SaveLogFileEvent);
			file.browseForSave("Save Log As");
		}

		protected function SaveLogFileEvent(event:Event):void
		{
			var newFile:File = event.target as File;
			var fs:FileStream = new FileStream();
			try{
				fs.open(newFile,FileMode.WRITE);
				fs.writeUTFBytes(Logger.toString());
				fs.close();
				Logger.Log("File Saved: " + newFile.url, this);
			} catch(e:Error){
				Logger.Log(e.message, this);
			}
		}
		
		public override function OpenFile():void
		{
			var file:File = File.desktopDirectory;
			file.addEventListener(Event.SELECT, OpenFileEvent);
			file.browseForOpen("Open");
		}

		protected function OpenFileEvent(event:Event):void
		{
			OpenFileObject(event.target as File);
		}

		public function OpenFileObject(file:File):void
		{
			if (!file)
				return;

			var stream:FileStream = new FileStream();
			try{
			    stream.open(file, FileMode.READ);
				Logger.Log("File Opened: " + file.url, this);
			    var fileData:Object = JSON.decode(stream.readUTFBytes(stream.bytesAvailable));
			    LoadFromObject(fileData);
			} catch(e:Error){
				Logger.LogError("File Open Error: " + file.url, this);
			}
		}
		
		public override function Copy(event:Event):void
		{
			var copyClip:Clip = editPage.GetSelectedClip();
			if (!copyClip)
				return;
				
			var copyObject:Object = copyClip.SaveToObject();
			Clipboard.generalClipboard.clear();
			Clipboard.generalClipboard.setData("epaths:clipObject", JSON.encode(copyObject));

			if (copyClip is LabelClip)
				Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, (copyClip as LabelClip).text);
			else if (copyClip is TextBoxClip)
				Clipboard.generalClipboard.setData(ClipboardFormats.HTML_FORMAT, (copyClip as TextBoxClip).text);
			editPage.DeselectAll();
			var scaleMat:Matrix = new Matrix();
			scaleMat.scale(3,3);
			Clipboard.generalClipboard.setData(ClipboardFormats.BITMAP_FORMAT, ImageSnapshot.captureBitmapData(copyClip.view, scaleMat, null, null, null, true));
			editPage.SelectClip(copyClip);
		}

		public override function Cut(event:Event):void
		{
			var copyClip:Clip = editPage.GetSelectedClip();
			if (!copyClip)
				return;

			Copy(null);
			editPage.DeleteClip(copyClip);
		}

		public override function Paste(event:Event):void
		{
			if (Clipboard.generalClipboard.hasFormat("epaths:clipObject")) {
				var clipDataObject:Object = JSON.decode(Clipboard.generalClipboard.getData("epaths:clipObject") as String);
				if (!clipDataObject || !clipDataObject["type"])
					return;
					
				var newClip:Clip = editPage.AddClipByType(clipDataObject["type"]);
				if (newClip) {
					newClip.LoadFromObject(clipDataObject);
					newClip.x = 17;
					newClip.y = 17;
				}
			} else if (Clipboard.generalClipboard.hasFormat(ClipboardFormats.BITMAP_FORMAT)) {
				/*var clip:PictureClip = editPage.AddClipFromData(Clipboard.generalClipboard.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData) as PictureClip;*/
/*				var clip:PictureClip = editPage.AddClipByType('image', new Rectangle(150, 150, 300, 300)) as PictureClip;
				clip.addEventListener(PictureClip.IMAGE_LOADED, PictureClip_ImageLoaded);

				clip.LoadFromData( Clipboard.generalClipboard.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData );

				Logger.Log("Bitmap Pasted", LogEntry.INFO, this);
*/			} 
			else if (Clipboard.generalClipboard.hasFormat(ClipboardFormats.HTML_FORMAT)) {
				var newTextBoxClip:TextBoxClip = editPage.AddClipByType("textbox") as TextBoxClip;
				newTextBoxClip.text = Clipboard.generalClipboard.getData(ClipboardFormats.HTML_FORMAT) as String;
				Logger.Log("HTML Pasted " + newTextBoxClip.text, this);
			} else if (Clipboard.generalClipboard.hasFormat(ClipboardFormats.TEXT_FORMAT)) {
				newTextBoxClip = editPage.AddClipByType("textbox") as TextBoxClip;
				newTextBoxClip.text = Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT) as String;
				Logger.Log("Text Pasted " + newTextBoxClip.text, this);
			}
		}
	}	
}
