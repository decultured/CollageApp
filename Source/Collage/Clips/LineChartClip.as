package Collage.Clips
{
	import Collage.Clip.*;
	import Collage.Clips.Skins.*;
	import Collage.Clips.Editors.*;
	import mx.events.PropertyChangeEvent;
	
	public class LineChartClip extends Clip
	{
		public function LineChartClip()
		{
			super(LineChartClipSkin, LineChartClipEditor);
			type = "linechart";
		}
		
		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{ }

			super.ModelChanged(event);
		}
	}
}
