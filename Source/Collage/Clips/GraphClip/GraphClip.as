package Collage.Clips.GraphClip
{
	import Collage.Clip.*;
	import mx.events.PropertyChangeEvent;
	
	public class GraphClip extends Clip
	{
		public function GraphClip()
		{
			super(GraphClipSkin, GraphClipEditor);
			type = "graph";
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
