package Desktop.Application
{
	import Collage.Document.*;
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
			
			var newClip:ClipModel = new ClipModel();
			newClip.clipName = "./Clips/TextBoxClip.swf";
			newClip.x = 150;
			newClip.y = 150;
			document.AddClip(newClip);

			var newClip2:ClipModel = new ClipModel();
			newClip2.clipName = "./Clips/LabelClip.swf";
			newClip2.x = 250;
			newClip2.y = 350;
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
