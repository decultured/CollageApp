package Collage.Application
{
	import flash.events.*;
	import Collage.Utilities.Logger.*;
	import spark.components.SkinnableContainer;
	
	public class CollageStatusBar extends SkinnableContainer
	{
		[Bindable]public var message:String = "Status Bar!";
		[Bindable]public var messageColor:Number = 0x999999;
		
		public var lowestLogLevel:int = 0;
		
		public function CollageStatusBar()
		{
			super();
			Logger.events.addEventListener(Logger.NEW_LOG_EVENT, SetStatusFromLog);
		}
		
		public function SetStatusFromLog(event:Event):void
		{
			var lastLog:LogEntry = Logger.LastLog();

			if (lastLog.level < lowestLogLevel)
				return;

			message = lastLog.text;
			
			switch (lastLog.level)
			{
				case LogEntry.DEBUG:
					messageColor = 0x777777;
					break;
				case LogEntry.INFO:
					messageColor = 0x999999;
					break;
				case LogEntry.WARNING:
					messageColor = 0xffff00;
					break;
				case LogEntry.ERROR:
					messageColor = 0xff9900;
					break;
				case LogEntry.CRITICAL:
					messageColor = 0xff0000;
					break;
				default:
					messageColor = 0x999999;
			}
		}
	}
}