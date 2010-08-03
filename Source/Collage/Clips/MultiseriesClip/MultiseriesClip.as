package Collage.Clips.LineChartClip
{
	import Collage.Clip.*;
	import Collage.DataEngine.*;
	import Collage.Utilities.Logger.*;
	import mx.events.PropertyChangeEvent;
	
	public class MultiseriesClip
	{
		public function MultiseriesClip()
		{
			super(MultiseriesClipSkin, MultiseriesClipEditor);
			type = "multiseries";
			rotatable = false;
		}
	}
}
