package Collage.Clips
{
	import Collage.Clip.*;
	import Collage.Clips.Skins.*;
	import Collage.Clips.Editors.*;
	import mx.events.PropertyChangeEvent;
	
	public class PieChartClip extends Clip
	{
		public function PieChartClip()
		{
			super(PieChartClipSkin, PieChartClipEditor);
			type = "piechart";
		}
		
		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{ }

			super.ModelChanged(event);
		}
	}
}
