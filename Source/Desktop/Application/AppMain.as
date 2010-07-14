package Desktop.Application
{
	import mx.graphics.ImageSnapshot;
	import mx.events.AIREvent;
	import mx.core.*;
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
	import flash.net.*;
	
	public class AppMain extends CollageApp
	{
 		private var _ViewerWindow:CollageViewerWindow;

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

		public override function OpenViewer():void {
			_ViewerWindow = new CollageViewerWindow();
			_ViewerWindow.width = 800;
            _ViewerWindow.height = 600;
			_ViewerWindow.addEventListener(AIREvent.WINDOW_COMPLETE, HandleViewerComplete);
			Logger.LogDebug("Opened Viewer Window: " + name, this);

            try {
                _ViewerWindow.open(true);
            } catch (err:Error) {
                Logger.LogError("Problem Opening Viewer Window: " + err, this);
            }
			
		}
		public function HandleViewerComplete(event:AIREvent):void
		{
			_ViewerWindow.clgViewer.LoadFromObject(SaveToObject());
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
			
			var filters:Array = new Array();
			filters.push( new FileFilter( "Collage Files", "*.clg" ) );
			file.browseForOpen("Open", filters);
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
			var formatsString:String = "Formats: ";
			for each (var format:String in Clipboard.generalClipboard.formats) {
				formatsString += format + ", ";
			}
			Logger.Log("Formats Pasted: " + formatsString, this);
			
			
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
				newClip = editPage.AddClipByType("image");
				newClip.LoadFromData(Clipboard.generalClipboard.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData);
				Logger.Log("Bitmap Pasted", this);
			} 
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
		
		public override function SaveImage():void
		{
			var file:File = File.desktopDirectory.resolvePath("snapshot.png");
			file.addEventListener(Event.SELECT, SaveImageEvent);
			editPage.DeselectAll();
			file.browseForSave("Save As");
		}

		protected function SaveImageEvent(event:Event):void
		{
			var gridOn:Boolean = appGrid.visible;
			appGrid.visible = false;
			appGrid.validateNow();
			var snapshot:ImageSnapshot = ImageSnapshot.captureImage(editPageContainer, 300);
			if (gridOn)
				appGrid.visible = true;
			var newFile:File = event.target as File;
			var fs:FileStream = new FileStream();
			try{
				fs.open(newFile,FileMode.WRITE);
				fs.writeBytes(snapshot.data, 0, snapshot.data.length);
				fs.close();
				Logger.Log("Image Saved: " + newFile.url, this);
			} catch(e:Error){
				trace(e.message);
			}
		}
		
		public override function UploadDataFile():void
		{
			var file:File = File.desktopDirectory;
			file.addEventListener(Event.SELECT, UploadDataFileEvent);

			var filters:Array = new Array();
			filters.push( new FileFilter( "Allowed Data Files", "*.csv;*.tsv,*.txt" ));
			file.browseForOpen("Open", filters);
		}

		private function UploadDataFileEvent(event:Event):void
		{
			if (!event.target || !event.target is File)
				return;

			var file:File = event.target as File;
			Logger.Log("Uploading CSV: " + file.url, this);
			UploadCSV(file);
		}

		public static function UploadCSV(file:File):void {
			var request:URLRequest = new URLRequest(DataEngine.getUrl("/api/v1/dataset/upload"));
			var loader:URLLoader = new URLLoader();
			var header:URLRequestHeader = new URLRequestHeader("X-Requested-With", "XMLHttpRequest");
			request.method = URLRequestMethod.POST;
            request.requestHeaders.push(header);
			
			var params:URLVariables = new URLVariables();
			params.aT = Session.AuthToken;
			request.data = params;

			file.addEventListener(Event.COMPLETE, FileUploadCompleteHandler);
            file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, FileUploadSecurityErrorHandler);
            file.addEventListener(IOErrorEvent.IO_ERROR, FileUploadIOErrorHandler);
            file.addEventListener(HTTPStatusEvent.HTTP_STATUS, FileUploadHttpStatusHandler);
			file.upload(request,"datafile");
		}
		
        private static function FileUploadHttpStatusHandler(event:HTTPStatusEvent):void {
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, FileUploadHttpStatusHandler);
			Logger.Log("Data Engine File Upload HTTP Status: " + event, LogEntry.DEBUG);
        }

		private static function FileUploadIOErrorHandler(event:IOErrorEvent):void
		{
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, FileUploadIOErrorHandler);
			Logger.Log("Data Engine File Upload IO Error: " + event, LogEntry.ERROR);
		}

        private static function FileUploadSecurityErrorHandler(event:SecurityErrorEvent):void
		{
            event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, FileUploadSecurityErrorHandler);
			Logger.Log("Data Engine File Upload Security Error: " + event, LogEntry.ERROR);
        }

		private static function FileUploadCompleteHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, FileUploadCompleteHandler);
            DataEngine.LoadAllDataSets();
			Logger.Log("File Upload Complete!", LogEntry.INFO);
		}

		public function onDragIn(event:NativeDragEvent):void{
			if (event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT) || 
				event.clipboard.hasFormat(ClipboardFormats.BITMAP_FORMAT) || 
				event.clipboard.hasFormat(ClipboardFormats.HTML_FORMAT) ||
				event.clipboard.hasFormat(ClipboardFormats.TEXT_FORMAT)) {
				NativeDragManager.acceptDragDrop(this);
			}
		}

		public function onDrop(event:NativeDragEvent):void{
			var newClip:Clip = null;
			var formatsString:String = "Formats: ";
			
			for each (var format:String in event.clipboard.formats) {
				formatsString += format + ", ";
			}
			if (event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT)) {
				var dropfiles:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
				for each (var file:File in dropfiles){
					var ext:String = file.extension.toLowerCase();
					if (ext == "png" || ext == "jpg" || ext == "jpeg" || ext == "gif") {
						newClip = editPage.AddClipByType("image");
						if (newClip is ImageClip)
							(newClip as ImageClip).URL = file.url;
						Logger.Log("Image Dropped: " + file.url, this);
					} else if (ext == "clg") {
						OpenFileObject(file);
					} else if (ext == "csv" || ext == "tsv") {
						Logger.Log("Uploading Dropped CSV: " + file.url, this);
						UploadCSV(file);
					}
					else {
						Logger.LogError("File Dropped with Unmapped Extention: " + file.url, this);
					}
				}
				Logger.Log("Filelist Dropped", this);
			} else if (event.clipboard.hasFormat(ClipboardFormats.BITMAP_FORMAT)) {
				newClip = editPage.AddClipByType("image");
				newClip.LoadFromData(event.clipboard.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData);
				Logger.Log("Bitmap Dropped", this);
			} else if (event.clipboard.hasFormat(ClipboardFormats.HTML_FORMAT)) {
				var newTextBoxClip:TextBoxClip = editPage.AddClipByType("textbox") as TextBoxClip;
				newTextBoxClip.text = event.clipboard.getData(ClipboardFormats.HTML_FORMAT) as String;
				Logger.Log("HTML Dropped " + newTextBoxClip.text, this);
			} else if (event.clipboard.hasFormat(ClipboardFormats.TEXT_FORMAT)) {
				newTextBoxClip = editPage.AddClipByType("textbox") as TextBoxClip;
				newTextBoxClip.text = event.clipboard.getData(ClipboardFormats.TEXT_FORMAT) as String;
				Logger.Log("Text Dropped " + newTextBoxClip.text, this);
			} else if (event.clipboard.hasFormat(ClipboardFormats.URL_FORMAT)) {
				Logger.Log("URL Dropped : " + event.clipboard.getData(ClipboardFormats.URL_FORMAT) as String, this);
			} else {
				Logger.LogWarning("Unknown Format Dropped", this);
			}
			Logger.Log("Formats Dropped: " + formatsString, this);
		}
/*
		public override function SavePDF():void
		{
			var file:File = File.desktopDirectory.resolvePath("report.pdf");
			file.addEventListener(Event.SELECT, SavePDFEvent);
			_EditDocumentView.ClearSelection();
			file.browseForSave("Save As");
		}

		protected function SavePDFEvent(event:Event):void
		{
			var snapshot:ImageSnapshot = ImageSnapshot.captureImage(_EditDocumentView, 0, new JPEGEncoder());
			var snapshotBitmap:BitmapData = ImageSnapshot.captureBitmapData(_EditDocumentView);

			var newPDF:PDF = new PDF(Orientation.LANDSCAPE, Unit.MM, Size.LETTER);
			newPDF.setDisplayMode(Display.FULL_WIDTH);

			newPDF.addPage();
//			newPDF.addImageStream(snapshot.data, ColorSpace.DEVICE_RGB, new Resize ( Mode.FIT_TO_PAGE, Position.CENTERED ));
			newPDF.addImage(new Bitmap(snapshotBitmap), new Resize ( Mode.FIT_TO_PAGE, Position.CENTERED ));
/*
			newPDF.setFont(FontFamily.ARIAL , Style.NORMAL, 12);
			newPDF.addText("Claimant Name: " + this.firstName.text + " " + lastName.text,10,40);
			newPDF.addText("Date: " + this.date.text,10,50);
			newPDF.addTextNote(48,45,100,2,"Claim Filed on: " + this.date.text + " today's date: " + new Date());
			newPDF.addText("Policy #: " + this.policyNum.text,10,60);
			newPDF.addText("Contact #: " + this.contact.text,10,70);
			newPDF.addText(this.claimNum.text,10,80);
			newPDF.addText("Claim Description:",10,90);
			newPDF.setXY(10,95);
			newPDF.addMultiCell(200,5,desc.text);
*/
/*
			var newFile:File = event.target as File;
			var fs:FileStream = new FileStream();
			try{
				fs.open(newFile,FileMode.WRITE);
				var pdfBytes:ByteArray = newPDF.save(Method.LOCAL);
				fs.writeBytes(pdfBytes);
				fs.close();
				Logger.Log("PDF Saved: " + newFile.url, LogEntry.INFO, this);
			} catch(e:Error){
				trace(e.message);
			}
		}
*/		
	}	
}
