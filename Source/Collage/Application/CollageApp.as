package Collage.Application
{
	import spark.components.SkinnableContainer;
	import spark.components.Group;
	import mx.controls.Alert;
	import Collage.Document.*;
	import Collage.Clip.*;
	import Collage.Clips.*;
	import mx.core.*;
	import flash.events.*;
	import flash.desktop.*;
	
	public class CollageApp extends SkinnableContainer
	{
		public var clgClipboard:CollageClipboard;

		[SkinPart(required="true")]
		public var toolbar:Group;

		[SkinPart(required="true")]
		public var appStatusBar:SkinnableContainer;

		[SkinPart(required="true")]
		public var editDoc:EditDocument;

		public function CollageApp():void
		{
			clgClipboard = new CollageClipboard(this);

		}

		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			
			if (instance == editDoc) {
				editDoc.InitializeForEdit();
				Alert.show("asdfasdf");
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void {
			super.partRemoved(partName, instance);
			
			if (instance == editDoc) {
				// TODO: Maybe something goes here.
			}
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
