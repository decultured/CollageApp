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
		
		[Bindable][Savable] public var textColumnType:String = "string";
		[Bindable][Savable] public var textColumn:String = null;
		
		private static var DEFAULT_LABEL_TEXT:String = "No Data Loaded.";
		[Bindable][Savable] public var displayText:String = DEFAULT_LABEL_TEXT;
		
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
		

		protected override function QueryFieldsChangedHandler(event:Event):void
		{
			super.QueryFieldsChangedHandler(event);
			
			var dataSet:DataSet = DataEngine.GetDataSetByID(query.dataset);
			if (dataSet && textColumn && dataSet.GetColumnByID(textColumn)) {
				var dataColumn:DataSetColumn = dataSet.GetColumnByID(textColumn);
				textColumnType = dataColumn.datatype;
			} else {
				textColumnType = "string"
			}
		}

		private function QueryFinished(event:Event):void
		{
			if (!query || !query.resultRows is Array || query.resultRows.length < 1)
				return;
			
			if (query.resultRows.getItemAt(0)[textColumn] is Number) {
				textColumnType = "number";
				text = query.resultRows.getItemAt(0)[textColumn];
			} else if (query.resultRows.getItemAt(0)[textColumn] is String) {
				textColumnType = "datetime";
				text = query.resultRows.getItemAt(0)[textColumn];
			} else if (query.resultRows.getItemAt(0)[textColumn] is Date) {
				textColumnType = "string";
				text = (query.resultRows.getItemAt(0)[textColumn] as Date).toString();
			}
			
			if (!text || text.length < 1) {
				textColumnType = "string";
				text = "No Data Loaded.";
			}
		}
	}
}
