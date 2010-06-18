package Collage.Clips
{
	import Collage.Clip.*;
	import Collage.Clips.Skins.*;
	import Collage.Clips.Editors.*;
	import mx.events.PropertyChangeEvent;
	
	public class ScatterPlotClip extends DataClip
	{
		public function ScatterPlotClip()
		{
			super(ScatterPlotClipSkin, ScatterPlotClipEditor);
			type = "scatterplot";
		}
		
		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{ }

			super.ModelChanged(event);
		}
	}
}
