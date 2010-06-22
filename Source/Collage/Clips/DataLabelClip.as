package Collage.Clips
{
	import Collage.Clip.*;
	import Collage.Clips.Skins.*;
	import Collage.Clips.Editors.*;
	import Collage.DataEngine.*;
	import mx.events.PropertyChangeEvent;
	
	public class DataLabelClip extends DataClip
	{
		[Bindable][Savable]public var text:String = "No Data";
		[Bindable][Savable(theme="true")]public var color:Number = 0x444444;
		[Bindable][Savable(theme="true")]public var alpha:Number = 1.0;
		[Bindable][Savable(theme="true")]public var fontSize:Number = 18;
		[Bindable][Savable]public var precision:int = 2;
		
		[Bindable] public var textColumn:String = null;
		
		private static var DEFAULT_LABEL_TEXT:String = "Double-click to edit";
		[Bindable]public var displayText:String = DEFAULT_LABEL_TEXT;
		
		public function DataLabelClip()
		{
			super(DataLabelClipSkin, DataLabelClipEditor);
			type = "datalabel";
			height = fontSize;
			verticalSizable = false;

			_QueryDefinition.queryTitle = "Data Label";
			_QueryDefinition.queryDescription = "Data setup for the Data Label";
			_QueryDefinition.minRowsReturned = 1;
			_QueryDefinition.maxRowsReturned = 1;
			var newQFD:QueryFieldDefinition = new QueryFieldDefinition(_QueryDefinition);
			newQFD.internalName = "textColumn";
			newQFD.title = "Text Column";
			newQFD.description = "This field defines the data for the label";
			newQFD.allowModifiers = true;
			_QueryDefinition.AddFieldDefinition(newQFD);
			
			query.addEventListener(DataQuery.COMPLETE, QueryFinished);
		}
		
		public override function Reposition():void
		{
			height = fontSize;
			super.Reposition();
		}
		
		private function QueryFinished(event:Event):void
		{
			if (!query || !query.resultRows is Array || query.resultRows.length < 1)
				return;

			text = query.resultRows.getItemAt(0)[textColumn];
		}

		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{ 
			}
			super.ModelChanged(event);
		}
	}
}
