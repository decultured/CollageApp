package Collage.Clips
{
	import Collage.Clip.*;
	import Collage.Clips.Skins.*;
	import Collage.Clips.Editors.*;
	import mx.events.PropertyChangeEvent;
	
	public class ColumnChartClip extends Clip
	{
		public function ColumnChartClip()
		{
			super(LabelClipSkin, LabelClipEditor);
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
