package Collage.Clip
{
	import mx.events.PropertyChangeEvent;
	
	public class MultiDataClip extends DataClip
	{
		
		public function MultiDataClip(_clipViewSkin:Class, _clipEditorSkin:Class, _smallClipEditorSkin:Class = null):void
		{
			super(_clipViewSkin, _clipEditorSkin, _smallClipEditorSkin);
		}
		
		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{
				case "":
					return;
			}

			super.ModelChanged(event);
		}
	}
}
