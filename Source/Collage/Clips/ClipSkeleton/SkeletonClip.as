package Collage.Clips.LabelClip
{
	import Collage.Clip.*;
	import mx.events.PropertyChangeEvent;
	
	public class SkeletonClip extends Clip
	{
		public function SkeletonClip()
		{
			super(SkeletonClipSkin, SkeletonClipEditor);
			type = "Skeletonclip";
		}
		
		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{
				case "text":
					return;
			}

			super.ModelChanged(event);
		}
	}
}
