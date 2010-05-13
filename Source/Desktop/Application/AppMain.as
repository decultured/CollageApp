package Desktop.Application
{
	import Collage.Document.*;
	import Collage.Clip.*;
	import Collage.Clips.*;
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

			document.InitializeForEdit();

			var newClip:LabelClip = new LabelClip();
			newClip.x = 150;
			newClip.y = 150;
			document.AddClip(newClip);
			
			var newClip2:TextBoxClip = new TextBoxClip();
			newClip2.x = 150;
			newClip2.y = 150;
			document.AddClip(newClip2);
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
