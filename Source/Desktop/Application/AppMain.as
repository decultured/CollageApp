package Desktop.Application
{
	import Collage.Document.*;
	import mx.core.*;
	import flash.events.*;
	import flash.desktop.*;
	
	public class AppMain extends EventDispatcher
	{
		public var clgClipboard:AppClipboard;
		public var document:EditDocument;
		
		public function AppMain(editDoc:EditDocument):void
		{
			clgClipboard = new AppClipboard(this);
			document = editDoc;
		}
		
		public function Quit():void
		{
			NativeApplication.nativeApplication.exit();	
		}
		
		public function Fullscreen():void
		{
		}
		
		public function SaveFile():void
		{
		}
		
		public function OpenFile():void
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
	}	
}
