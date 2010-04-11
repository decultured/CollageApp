package Desktop.Application
{
	import Collage.Document.*;
	
	public class AppMain
	{
		public var clgClipboard:AppClipboard;
		public var document:EditDocument;

		public function AppMain():void
		{
			clgClipboard = new AppClipboard(this);
			document = new EditDocument();
		}
		
		public function Quit():void
		{
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
