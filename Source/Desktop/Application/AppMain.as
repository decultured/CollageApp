package Desktop.Application
{
	import Collage.Application.*;
	
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
