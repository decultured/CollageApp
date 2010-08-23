package Collage.Clips.Map
{
	import flash.events.Event;

	public class MapEvent extends Event
	{
		public static var OBJECT_CLICKED:String = "map_object_clicked";
		
		public var targets:Array = [];
		public var object:MapPolygon;
		
		public function MapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}