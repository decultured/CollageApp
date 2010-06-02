package Desktop.Application
{
	import flash.filesystem.*;
	import Collage.Utilities.json.*;
	import Collage.Application.*;
	import Collage.Document.*;
	import Collage.Clip.*;
	import Collage.Clips.*;
	import Collage.Utilities.Logger.*;
	import mx.core.*;
	import flash.events.*;
	import flash.desktop.*;
	import flash.utils.*;
	
	public class AppMain extends CollageApp
	{
		public function AppMain():void
		{
			super();
		}
		
		public override function Quit():void
		{
			NativeApplication.nativeApplication.exit();	
		}
		
		public override function Fullscreen():void
		{
		}
		
		public function SaveFile():void
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
		
		public function OpenFile(file:File = null):void
		{
			if (file) {
				OpenFileObject(file);
				return;
			}
			file = File.desktopDirectory;
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
//			try{
			    stream.open(file, FileMode.READ);
				Logger.Log("File Opened: " + file.url, this);
			    var fileData:Object = JSON.decode(stream.readUTFBytes(stream.bytesAvailable));
			    LoadFromObject(fileData);
//			} catch(e:Error){
//				Logger.LogError("File Open Error: " + file.url, this);
//			}
		}
	}	
}
