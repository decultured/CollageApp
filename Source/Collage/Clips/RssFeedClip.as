package Collage.Clips
{
	import Collage.Clip.*;
	import Collage.Clips.Skins.*;
	import Collage.Clips.Editors.*;
	import mx.events.PropertyChangeEvent;
	import flash.events.KeyboardEvent;
	import Collage.Utilities.KeyCodes;
	
	public class RssFeedClip extends Clip
	{
		[Bindable][Savable]public var text:String = "";
		[Bindable][Savable(theme="true")]public var color:Number = 0x444444;
		[Bindable][Savable(theme="true")]public var alpha:Number = 1.0;
		[Bindable][Savable(theme="true")]public var fontSize:Number = 18;
		
		public function RssFeedClip()
		{
			super(RssFeedClipSkin, RssFeedClipEditor);
			type = "rssfeed";
		}
		
		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{
			}
			super.ModelChanged(event);
		}
	}
}
