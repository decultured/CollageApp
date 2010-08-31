package Collage.Clips.MultiseriesClip.Components
{
	import Collage.Clip.*;
	import Collage.DataEngine.*;
	import Collage.Utilities.Logger.*;
	import Collage.Clips.MultiseriesClip.Components.VAxis.*;
	import Collage.Clips.MultiseriesClip.*;
	import mx.events.PropertyChangeEvent;
	
	public class SeriesPart extends DataClip
	{
		public var parentClip:MultiseriesClip;
		
		[Bindable][Saveable] public var axisUID:String = "";
		[Bindable] public var axis:VAxisPart;
		 
		public function SeriesPart(_clipViewSkin:Class, _clipEditorSkin:Class, _smallClipEditorSkin:Class = null)
		{
			super(_clipViewSkin, _clipEditorSkin, _smallClipEditorSkin);
		}
		
		protected override function QueryCompleteHandler(event:Event):void
		{
		 	if (parentClip) {
				parentClip.dispatchEvent(PropertyChangeEvent.createUpdateEvent(parentClip, "redrawTrigger", false, true));
				Logger.Log("Query done, Redraw axis?");
			}
		}
		
		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
		 	if (parentClip)
				parentClip.dispatchEvent(PropertyChangeEvent.createUpdateEvent(parentClip, "redrawTrigger", false, true));

			if (event && event.property == "axisUID" && parentClip) {
				parentClip.SetSeriesVAxisByUID(this);
				return;
			} else if (event && event.property == "axis" && axis) {
				this["axisUID"] = axis.UID;
				return;
			}
			
			super.ModelChanged(event);
		}
	}
}
