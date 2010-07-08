package Collage.Clips
{
	import Collage.Clip.*;
	import Collage.Clips.Skins.*;
	import Collage.Clips.Editors.*;
	import mx.events.PropertyChangeEvent;
	import flash.events.KeyboardEvent;
	import Collage.Utilities.KeyCodes;
	
	public class LabelClip extends Clip
	{
		[Bindable][Savable]public var text:String = "";
		[Bindable][Savable(theme="true")]public var color:Number = 0x444444;
		[Bindable][Savable(theme="true")]public var alpha:Number = 1.0;
		[Bindable][Savable(theme="true")]public var fontSize:Number = 18;
		
		private static var DEFAULT_LABEL_TEXT:String = "Double-click to edit";
		[Bindable]public var displayText:String = DEFAULT_LABEL_TEXT;
		
		public function LabelClip()
		{
			super(LabelClipSkin, LabelClipEditor);
			type = "label";
			height = fontSize;
			verticalSizable = false;
			editable = true;
		}
		
		public override function Reposition():void
		{
			height = fontSize;
			super.Reposition();
		}
		
		protected override function OnKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == KeyCodes.ENTER && view.skin && view.skin.currentState == "editing")
				SetEditMode(false);
		}

		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{
				case "text":
					if (!text.length)
						displayText = DEFAULT_LABEL_TEXT;
					else
						displayText = text;
					return;
			}

			super.ModelChanged(event);
		}
	}
}
