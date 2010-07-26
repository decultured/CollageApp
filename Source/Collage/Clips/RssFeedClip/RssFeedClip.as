package Collage.Clips.RssFeedClip
{
	import com.adobe.utils.XMLUtil;
	import com.adobe.xml.syndication.generic.*;
	import com.adobe.xml.syndication.rss.*;

	import flash.utils.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	import Collage.Clip.*;
	import Collage.Utilities.Logger.*;
	import mx.events.PropertyChangeEvent;
	import flash.events.KeyboardEvent;
	import Collage.Utilities.KeyCodes;
	import mx.collections.ArrayList;
	
	public class RssFeedClip extends Clip
	{
		[Bindable][Savable]public var feedURL:String = null;
		[Bindable][Savable]public var contentWidth:Number = 100;

		[Bindable][Savable]public var titleSize:uint = 14;
		[Bindable][Savable]public var titleLines:uint = 2;
		[Bindable][Savable]public var titleColor:Number = 0x222222;
		[Bindable][Savable]public var titleAlpha:Number = 1;

		[Bindable][Savable]public var contentSize:uint = 12;
		[Bindable][Savable]public var contentLines:uint = 3;
		[Bindable][Savable]public var contentColor:Number = 0x656565;
		[Bindable][Savable]public var contentAlpha:Number = 1;
		
		private var loader:URLLoader;
		
		[Bindable][Savable]public var itemList:ArrayList = new ArrayList();
		[Bindable][Savable]public var loaded:Boolean = false;

		public function RssFeedClip()
		{
			super(RssFeedClipSkin, RssFeedClipEditor, RssFeedClipEditorSmall);
			type = "rssfeed";
			LoadRss();
			Resized();
		}
		
		public override function Resized():void
		{
			contentWidth = width;
		}
		
		protected function CheckLoaded():void {
			if (itemList && itemList.length > 0)
				loaded = true;
			else
				loaded = false;
		}
		
		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{
				case "feedURL":
					this["feedURL"] = feedURL.replace("feed://", "http://");
					LoadRss();
					return;
				case "itemList":
					CheckLoaded();
					return;
			}
			super.ModelChanged(event);
		}
		
		//called when user presses the button to load feed
		private function LoadRss():void
		{
			if (!feedURL) return;

			loader = new URLLoader();
			var request:URLRequest = new URLRequest(feedURL);
			request.method = URLRequestMethod.GET;
			loader.addEventListener(Event.COMPLETE, onDataLoad);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);

			loader.load(request);
		}

		//called once the data has loaded from the feed
		private function onDataLoad(e:Event):void
		{
			loader.removeEventListener(Event.COMPLETE, onDataLoad);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
						
			//get the raw string data from the feed
			var rawRSS:String = URLLoader(e.target).data;

			//parse it as RSS
			parseRSS(rawRSS);

		}

		//parses RSS 2.0 feed and prints out the feed titles into
		//the text area
		private function parseRSS(data:String):void
		{
			if(!XMLUtil.isValidXML(data)) {
				Logger.LogError("Feed does not contain valid XML.", this);
				return;
			}	

			//var rss:RSS20 = new RSS20();
			//rss.parse(data);
			//var items:Array = rss.items;
			
			var feed:IFeed = FeedFactory.getFeedByString(data);
			var items:Array = feed.items;
			itemList.removeAll();

			var removeHTML:RegExp = /<[^>]*>/gi;
			var removeNewLines:RegExp = /[\n\r]/gi;
			var removeExtraWhitespace:RegExp = /[\s]+/gi;

			for each(var item:Object in items)
			{
				var newItem:Object = new Object();

				if (item.hasOwnProperty('title')) {
					newItem.title = item['title'];
					newItem.title = newItem.title.replace(removeHTML, "");
					newItem.title = newItem.title.replace(removeExtraWhitespace, " ");
				}
				
				if (item.hasOwnProperty('link'))
					newItem.link = item['link'];
				else if (item.hasOwnProperty('links') && item['links'] is Array && item['links'].length > 0)
					newItem.link = item['links'][0];

				var content:String = "";
				if (item.hasOwnProperty('excerpt') && item['excerpt'].value) content = item['excerpt'].value;
				else if (item.hasOwnProperty('summary')) content = item['summary'];
				else if (item.hasOwnProperty('content')) content = item['content'];
				else if (item.hasOwnProperty('description')) content = item['description'];

				newItem.description = content.replace(removeHTML, "");
				newItem.description = newItem.description.replace(removeNewLines, "");
				newItem.description = newItem.description.replace(removeExtraWhitespace, " ");
				/*newItem.author = item['author;
				if (item['pubDate)
					newItem.date = item['pubDate.toString();*/
				itemList.addItem(newItem);
				//Logger.Log(newItem.title, this);
			}
			CheckLoaded();
		}

		private function onIOError(e:IOErrorEvent):void
		{
			loader.removeEventListener(Event.COMPLETE, onDataLoad);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
						
			Logger.LogError("IOError : " + e.text, this);
			CheckLoaded();
		}

		private function onSecurityError(e:SecurityErrorEvent):void
		{
			loader.removeEventListener(Event.COMPLETE, onDataLoad);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
						
			Logger.LogError("SecurityError : " + e.text, this);
			CheckLoaded();
		}
		
		public override function SaveToObject(onlyTheme:Boolean = false):Object
		{
			var typeDef:XML = describeType(this);
			var newObject:Object = new Object();
			for each (var metadata:XML in typeDef..metadata) {
				if (metadata["@name"] != "Savable")
					continue;
				if (this.hasOwnProperty(metadata.parent()["@name"])) {
					if (this[metadata.parent()["@name"]] is ArrayList) {
						newObject[metadata.parent()["@name"]] = (this[metadata.parent()["@name"]] as ArrayList).toArray();
					} else
						newObject[metadata.parent()["@name"]] = this[metadata.parent()["@name"]];
				}
			}

			return newObject;
		}

		public override function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject) return false;
			for(var obj_k:String in dataObject) {
				try {
					if(this.hasOwnProperty(obj_k)) {
						if (this[obj_k] is ArrayList && dataObject[obj_k] is Array)
							this[obj_k] = new ArrayList(dataObject[obj_k] as Array);
						else
							this[obj_k] = dataObject[obj_k];
					}
				} catch(e:Error) { }
			}
			return true;
		}
	}
}


