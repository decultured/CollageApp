package Collage.Clips.TableClip
{
	import Collage.Clip.*;
	import mx.events.PropertyChangeEvent;
	
	public class TableClip extends DataClip
	{
		public function TableClip()
		{
			super(TableClipSkin, TableClipEditor);
			rotatable = false;
			type = "table";
		}
		
		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{ }

			super.ModelChanged(event);
		}
	}
}
