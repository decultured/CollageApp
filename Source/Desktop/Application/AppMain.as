package Desktop.Application
{
	import Collage.Application.*;
	import Collage.Document.*;
	import Collage.Clip.*;
	import Collage.Clips.*;
	import mx.core.*;
	import flash.events.*;
	import flash.desktop.*;
	
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
	}	
}
