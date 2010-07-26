package Collage.Components {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.Security;
	import spark.components.Group;
	import mx.controls.SWFLoader;
	import Collage.Utilities.Logger.*;

	public class YouTubePlayer extends Group {
		public var videoId:String = "uLTIowBF0kE";

		private var isWidescreen:Boolean = false;
		private var player:Object;
		private var playerLoader:SWFLoader;
		private var youtubeApiLoader:URLLoader;
	
		// CONSTANTS.
		private static const DEFAULT_VIDEO_ID:String = "0QRO3gKj3qw";
		private static const PLAYER_URL:String = "http://www.youtube.com/apiplayer?version=3";
		private static const SECURITY_DOMAIN:String = "http://www.youtube.com";
		private static const YOUTUBE_API_PREFIX:String = "http://gdata.youtube.com/feeds/api/videos/";
		private static const YOUTUBE_API_VERSION:String = "2";
		private static const YOUTUBE_API_FORMAT:String = "5";
		private static const WIDESCREEN_ASPECT_RATIO:String = "widescreen";
		private static const QUALITY_TO_PLAYER_WIDTH:Object = {
			small: 320,
			medium: 640,
			large: 854,
			hd720: 1280
		};
		private static const STATE_ENDED:Number = 0;
		private static const STATE_PLAYING:Number = 1;
		private static const STATE_PAUSED:Number = 2;
		private static const STATE_CUED:Number = 5;

		public function YouTubePlayer():void {
			// Specifically allow the chromless player .swf access to our .swf.
			//Security.allowDomain(SECURITY_DOMAIN);
			setupPlayerLoader();
			setupYouTubeApiLoader();
		}

		private function setupPlayerLoader():void {
			playerLoader = new SWFLoader();
			playerLoader.addEventListener(Event.INIT, playerLoaderInitHandler);
			playerLoader.load(PLAYER_URL);
			Logger.LogDebug("Player Setup", this);
		}

		private function playerLoaderInitHandler(event:Event):void {
			addElement(playerLoader);
			playerLoader.content.addEventListener("onReady", onPlayerReady);
			playerLoader.content.addEventListener("onError", onPlayerError);
			playerLoader.content.addEventListener("onStateChange", onPlayerStateChange);
			playerLoader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
			Logger.LogDebug("Player Init", this);
		}

		private function setupYouTubeApiLoader():void {
			youtubeApiLoader = new URLLoader();
			youtubeApiLoader.addEventListener(IOErrorEvent.IO_ERROR, youtubeApiLoaderErrorHandler);
			youtubeApiLoader.addEventListener(Event.COMPLETE, youtubeApiLoaderCompleteHandler);
		}

		private function youtubeApiLoaderCompleteHandler(event:Event):void {
			var atomData:String = youtubeApiLoader.data;

			// Parse the YouTube API XML response and get the value of the
			// aspectRatio element.
			var atomXml:XML = new XML(atomData);
			var aspectRatios:XMLList = atomXml..*::aspectRatio;

			isWidescreen = aspectRatios.toString() == WIDESCREEN_ASPECT_RATIO;

			// Cue up the video once we know whether it's widescreen.
			// Alternatively, you could start playing instead of cueing with
			// player.loadVideoById(videoIdTextInput.text);
			player.loadVideoById(videoId);
		}

		private function youtubeApiLoaderErrorHandler(event:IOErrorEvent):void {
			Logger.LogDebug("Error making YouTube API request:" + event, this);
		}

		private function onPlayerReady(event:Event):void {
			Logger.LogDebug("Player Ready", this);
			player = playerLoader.content;
			player.playVideo();
			player.visible = true;
		}

		private function onPlayerError(event:Event):void {
			Logger.LogDebug("Player error: " + Object(event).data, this);
		}

		private function onPlayerStateChange(event:Event):void {
			Logger.LogDebug("State is: " + Object(event).data, this);

			switch (Object(event).data) {
				case STATE_ENDED:
					break;
				case STATE_PLAYING:
					break;
				case STATE_PAUSED:
					break;
				case STATE_CUED:
					resizePlayer("medium");
					break;
			}
		}

		private function onVideoPlaybackQualityChange(event:Event):void {
			Logger.LogDebug("Current video quality:" + Object(event).data, this);
			resizePlayer(Object(event).data);
		}

		private function resizePlayer(qualityLevel:String):void {
			var newWidth:Number = QUALITY_TO_PLAYER_WIDTH[qualityLevel] || 640;
			var newHeight:Number;

			if (isWidescreen) {
				// Widescreen videos (usually) fit into a 16:9 player.
				newHeight = newWidth * 9 / 16;
			} else {
				// Non-widescreen videos fit into a 4:3 player.
				newHeight = newWidth * 3 / 4;
			}

			Logger.LogDebug("isWidescreen is: " + isWidescreen.toString() + ". Size: " + newWidth + " " + newHeight, this);
			player.setSize(newWidth, newHeight);

			// Center the resized player on the stage.
			player.x = (stage.stageWidth - newWidth) / 2;
			player.y = (stage.stageHeight - newHeight) / 2;

			player.visible = true;
		}
	}
}