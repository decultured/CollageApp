package Collage.DataEngine
{
	import mx.collections.ArrayList;
	import flash.net.*;
	import flash.events.*;
	import com.adobe.serialization.json.JSON;
	import Collage.Utilities.Logger.*;
	import flash.utils.*;
	
	public class DataQuery extends EventDispatcher
	{
		public static var COMPLETE:String = "complete";
		public static var FIELDS_CHANGED:String = "fields_changed";

		public var loaded:Boolean = false;
		public var loading:Boolean = false;
	
		public var queryString:String = "";

		[Savable][Bindable]public var limit:Number = 100;
		[Savable][Bindable]public var dataset:String = "";
		[Bindable]public var fields:ArrayList = new ArrayList();

		[Savable][Bindable]public var updatable:Boolean = true;
		[Savable][Bindable]private var _UpdateInterval:Number = 5000; // In Microseconds, -1 = no updates
		[Savable][Bindable]public var lastUpdate:Date = new Date();
		private var _UpdateTimer:Timer;

		[Savable][Bindable]public var resultRows:ArrayList = new ArrayList();
		[Savable][Bindable]public var resultColumns:ArrayList = new ArrayList();

		[Savable][Bindable]public var parseTime:Number = 0;
		[Savable][Bindable]public var executeTime:Number = 0;
		[Savable][Bindable]public var total:Number = 0;
		[Savable][Bindable]public var parsedTime:Number = 0;
		
		public function get updateInterval():Number {return _UpdateInterval;}
		public function set updateInterval(newInterval:Number):void
		{
			_UpdateInterval = newInterval;
			Logger.Log("Timer changed, refreshes every: " + _UpdateInterval / 1000 + " seconds.", this);
			StartTimer();
		}
		
		public function DataQuery():void
		{
			StartTimer();
		}
		
		public function StartTimer():void
		{
			if (_UpdateTimer) {
				_UpdateTimer.stop();
				_UpdateTimer.removeEventListener("timer", TimerUpdateQuery);
			}
			if (_UpdateInterval < 1)
				return;
			if (_UpdateInterval < 5000)
				_UpdateInterval = 5000;
			_UpdateTimer = new Timer(_UpdateInterval, 0);
			_UpdateTimer.addEventListener("timer", TimerUpdateQuery, false, 0, true);
			_UpdateTimer.start();
			
			Logger.Log("Timer started, refreshes every: " + _UpdateInterval / 1000 + " seconds.", this);
		}

		public function TimerUpdateQuery(event:TimerEvent):void
		{
			Logger.Log("Timer (" + _UpdateInterval / 1000 + " seconds) updated, last update was at: " + lastUpdate.toString(), this);
			LoadQueryResults();
		}

		public function ResetFields():void
		{
			fields.removeAll();
			dispatchEvent(new Event(FIELDS_CHANGED));
		}
		
		public function AddNewField(internalName:String, columnName:String, sort:String = null,  modifier:String = null, group:String = null, alias:String = null):void
		{
			var newDataQueryField:DataQueryField = null;

			newDataQueryField = FindFieldByInternalName(internalName);
			if (newDataQueryField)
				fields.removeItem(newDataQueryField);

			newDataQueryField = FindFieldByColumnName(columnName);
			if (newDataQueryField)
				fields.removeItem(newDataQueryField);

			newDataQueryField = new DataQueryField(internalName, columnName, sort,  modifier, group, alias);
			fields.addItem(newDataQueryField);

			Logger.LogDebug("Field Added: " + internalName + " ColumnName: " + columnName, this);

			dispatchEvent(new Event(FIELDS_CHANGED));
		}
		
		public function AddField(_qField:DataQueryField):void
		{
			var newDataQueryField:DataQueryField = null;
			newDataQueryField = FindFieldByInternalName(_qField.internalName);
			if (newDataQueryField)
				fields.removeItem(newDataQueryField);

			newDataQueryField = FindFieldByColumnName(_qField.columnName);
			if (newDataQueryField)
				fields.removeItem(newDataQueryField);

			fields.addItem(_qField);

			Logger.LogDebug("Field Class Added: " + _qField.internalName + " ColumnName: " + _qField.columnName, this);

			dispatchEvent(new Event(FIELDS_CHANGED));
		}
		
		public function GetColumnSelectionsArrayList(allowedTypes:Array = null, internalName:String = null):ArrayList
		{
			var columnSelections:ArrayList = new ArrayList();
			var currentDataSet:DataSet = DataEngine.GetDataSetByID(dataset);
			if (!currentDataSet) {
				Logger.LogWarning("No Dataset - Column Selections", this);
				return columnSelections;
			}
			
			for (var i:int = 0; i < currentDataSet.columns.length; i++) {
				var typeFound:Boolean = true;
				var currentColumn:DataSetColumn = currentDataSet.columns.getItemAt(i) as DataSetColumn;
				if (allowedTypes && allowedTypes.length > 0) {
					typeFound = false;
					for each (var type:String in allowedTypes) {
						if (type == currentColumn.datatype) {
							typeFound = true;
							break;
						}
					}
				}
				
				var newObject:Object = new Object;
				newObject["columnName"] = currentColumn.label;
				newObject["dataType"] = currentColumn.datatype;
				newObject["dataTypeAllowed"] = typeFound;
				
				var newDataQueryField:DataQueryField = FindFieldByColumnName(currentColumn.label);
				if (newDataQueryField) {
					if (newDataQueryField.internalName && internalName && newDataQueryField.internalName == internalName)
						newObject["used"] = false;
					else
						newObject["used"] = true;
				} else
					newObject["used"] = false;
				
				columnSelections.addItem(newObject);
			}
			return columnSelections;
		}

		public function FindFieldByInternalName(internalName:String):DataQueryField
		{
			if (internalName == null)
				return null;

			for (var i:int = 0; i < fields.length; i++)
			{
				var field:DataQueryField = fields.getItemAt(i) as DataQueryField;
				if (field.internalName == internalName)
					return field;
			} 
			return null;
		}

		public function FindFieldByColumnName(columnName:String):DataQueryField
		{
			if (columnName == null)
				return null;
			
			for (var i:int = 0; i < fields.length; i++)
			{
				var field:DataQueryField = fields.getItemAt(i) as DataQueryField;
				if (field.columnName == columnName)
					return field;
			} 
			return null;
		}

		public function FindFieldByResultName(resultName:String):DataQueryField
		{
			if (resultName == null)
				return null;

			for (var i:int = 0; i < fields.length; i++)
			{
				var field:DataQueryField = fields.getItemAt(i) as DataQueryField;
				if (field.resultName == resultName)
					return field;
			} 
			return null;
		}

		public function BuildQueryString():String
		{
			var query:Object = new Object();
			
			query["limit"] = limit;
			query["dataset"] = dataset;
			query["fields"] = new Array();
			
			for (var i:int = 0; i < fields.length; i++)
			{
				var field:DataQueryField = fields.getItemAt(i) as DataQueryField;

				if (!field.columnName)
					continue;

				var fieldQuery:Object = new Object();

				if (field.sort)
					fieldQuery["sort"] = field.sort;
				if (field.modifier)
					fieldQuery["modifier"] = field.modifier;
				if (field.group)
					fieldQuery["group"] = field.group;
				if (field.alias)
					fieldQuery["alias"] = field.alias;
				fieldQuery["name"] = field.columnName;
				
				Logger.Log("Column Set: " + field.columnName + " internalName: " + field.internalName + " Modifier: " + field.modifier + " Sort: " + field.sort + " Grouped: " + field.group, this);

				query["fields"].push(fieldQuery);
			}

			dispatchEvent(new Event(FIELDS_CHANGED));
			
			queryString = JSON.encode(query);
			return queryString;
		}
		
		public function LoadQueryResults():void
		{
			loading = true;

			if (!fields || fields.length < 1 || !dataset || dataset.length < 5 || limit < 1)
				return;

 			lastUpdate = new Date();

			var request:URLRequest = new URLRequest(DataEngine.getUrl("/api/v1/dataset/" + dataset + "/query?rand=" + (Math.random() * 100000).toString()));
			var loader:URLLoader = new URLLoader();
			request.method = URLRequestMethod.POST;
			var header:URLRequestHeader = new URLRequestHeader("X-Requested-With", "XMLHttpRequest");
            request.requestHeaders.push(header);
			var params:URLVariables = new URLVariables();
			params.aT = Session.AuthToken;
			params['q'] = BuildQueryString();
			request.data = params;
			loader.addEventListener(Event.COMPLETE, CompleteHandler);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
            loader.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, HttpStatusHandler);

			Logger.LogDebug("New query: " + params['q'], this);
			
			loader.load(request);
		}
		
        private function HttpStatusHandler(event:HTTPStatusEvent):void {
			event.target.removeEventListener(HTTPStatusEvent.HTTP_STATUS, HttpStatusHandler);
			Logger.LogDebug("Query Status: " + event, this);
        }

		private function IOErrorHandler(event:IOErrorEvent):void
		{
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			Logger.LogError("Query IO Error: " + event, this);
		}
		
        private function SecurityErrorHandler(event:SecurityErrorEvent):void
		{
            event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
			Logger.LogError("Query Security Error: " + event, this);
        }

		private function CompleteHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, CompleteHandler);

			var results:Object = JSON.decode(event.target.data);

			for (var key:String in results)
			{
				if (key == "parse_time") {
					parseTime == parseInt(results[key]);
				} else if (key == "execute_time") {
					executeTime == parseInt(results[key]);
				} else if (key == "total") {
					total == parseInt(results[key]);
				} else if (key == "total_rows") {
					parsedTime == parseInt(results[key]);
				} else if (key == "rows") {
					resultRows = new ArrayList();
					for (var rowKey:String in results[key]) {
						var newRow:Object = new Object();
						for (var fieldKey:String in results[key][rowKey]){
							newRow[fieldKey] = results[key][rowKey][fieldKey];
						}
						resultRows.addItem(newRow);
					}
				} else if (key == "columns") {
					resultColumns.removeAll();
					for (var columnKey:String in results[key]) {
						var newColumn:Object = new Object();
						for (var columnFieldKey:String in results[key][columnKey]){
							newColumn[columnFieldKey] = results[key][columnKey][columnFieldKey];
						}
						resultColumns.addItem(newColumn);
					}
				}
			}

			AdjustRowValueTypes();
			Logger.Log("Data Query Loaded Successfully. #Rows: " + resultRows.length + " #Columns: " +  resultColumns.length, this);
			dispatchEvent(new Event(COMPLETE));
			loading = false;
			loaded = true;
		}

		// TODO: cleanup this nastiness???
		public function AdjustRowValueTypes():void
		{
			for (var rowKey:String in resultRows) {
				for (var rowFieldKey:String in resultRows[rowKey]) {
					for (var columnKey:String in resultColumns) {
						if (!resultColumns[columnKey]["datatype"] || resultColumns[columnKey]["label"] != rowFieldKey)
							continue;
						Logger.Log("Type: " + resultColumns[columnKey]["datatype"] + " Field: " + resultRows[rowKey][rowFieldKey], this);
						// The "type" paramter can be: string, numeric, datetime, boolean, or url
						if (resultColumns[columnKey]["datatype"] == "numeric") {
							resultRows[rowKey][rowFieldKey] = parseFloat(resultRows[rowKey][rowFieldKey]);
						} else if (resultColumns[columnKey]["datatype"] == "datetime" && resultRows[rowKey][rowFieldKey] is String) {
							resultRows[rowKey][rowFieldKey] = new Date(resultRows[rowKey][rowFieldKey]);
							Logger.Log("DateField: " + resultRows[rowKey][rowFieldKey].toString(), this);
						} else if (resultColumns[columnKey]["datatype"] == "boolean") {
							if (resultRows[rowKey][rowFieldKey] == "true")
								resultRows[rowKey][rowFieldKey] = true;
							else
								resultRows[rowKey][rowFieldKey] = false;
						}
					} 
				}
			} 
		}

		public function SaveToObject():Object
		{
			var typeDef:XML = describeType(this);
			var newObject:Object = new Object();
			for each (var metadata:XML in typeDef..metadata) {
				if (metadata["@name"] != "Savable")
					continue;
				if (this.hasOwnProperty(metadata.parent()["@name"])) {
					if (this[metadata.parent()["@name"]] is ArrayList)
						newObject[metadata.parent()["@name"]] = (this[metadata.parent()["@name"]] as ArrayList).toArray();
					else
						newObject[metadata.parent()["@name"]] = this[metadata.parent()["@name"]];
				}
			}

			newObject["fields"] = new Array();
			for (var i:int = 0; i < fields.length; i++) {
				newObject["fields"].push((fields.getItemAt(i) as DataQueryField).SaveToObject);
			}

			return newObject;
		}

		public function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject) return false;
			for(var obj_k:String in dataObject) {
				if (obj_k == "fields") {
					if (!dataObject[obj_k] is Array)
						continue;
					var fieldsArray:Array = dataObject[obj_k] as Array;
					for (var i:uint = 0; i < fieldsArray.length; i++) {
						var fieldDataObject:Object = fieldsArray[i] as Object;
						var newField:DataQueryField = new DataQueryField();
						newField.LoadFromObject(fieldDataObject);
					}
				} else {
					try {
						if(this.hasOwnProperty(obj_k)) {
							if (this[obj_k] is ArrayList && dataObject[obj_k] is Array)
								this[obj_k] = new ArrayList(dataObject[obj_k] as Array);
							else
								this[obj_k] = dataObject[obj_k];
						}
					} catch(e:Error) { }
				}
			}
			return true;
		}
	}
}