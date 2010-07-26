package Collage.Clips.YouTubeClip
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	import Collage.Clip.*;
	import Collage.Utilities.Logger.*;
	import mx.events.PropertyChangeEvent;
	import mx.collections.ArrayList;
	
	public class YouTubeClip extends Clip
	{
		[Bindable][Savable]public var videoId:String = "";
		
		public function YouTubeClip()
		{
			super(YouTubeClipSkin, YouTubeClipEditor);
			type = "youtube";
		}
		
		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{
				case "feedURL":
					return;
			}
			super.ModelChanged(event);
		}
	}
}


