package Collage.Clips
{
	import Collage.Clip.*;
	import Collage.Clips.Skins.*;
	import Collage.Clips.Editors.*;
	import mx.events.PropertyChangeEvent;
	
	public class DataLabelClip extends Clip
	{
		public function DataLabelClip()
		{
			super(DataLabelClipSkin, DataLabelClipEditor);
			type = "datalabel";
		}
		
		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{ }

			super.ModelChanged(event);
		}
	}
}
