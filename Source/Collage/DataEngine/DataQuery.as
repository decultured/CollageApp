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
		[Savable][Bindable]public var fields:Object = new Object();
		
		[Savable][Bindable]public var updatable:Boolean = true;
		[Savable][Bindable]public var updateTime:Number = 360; // In Seconds for now?
		[Savable][Bindable]public var lastUpdate:Number = 0;
		
		[Savable][Bindable]public var resultRows:ArrayList = new ArrayList();
		[Savable][Bindable]public var resultColumns:ArrayList = new ArrayList();

		[Savable][Bindable]public var parseTime:Number = 0;
		[Savable][Bindable]public var executeTime:Number = 0;
		[Savable][Bindable]public var total:Number = 0;
		[Savable][Bindable]public var parsedTime:Number = 0;
		
		public function DataQuery():void
		{
			
		}
		
		public function ResetFields():void
		{
			fields = new Object();
			dispatchEvent(new Event(FIELDS_CHANGED));
		}
		
		public function AddField(lookupName:String, name:String, sort:String = null,  modifier:String = null, group:String = null, alias:String = null):void
		{
			var newDataQueryField:DataQueryField = new DataQueryField(name, sort,  modifier, group, alias);
			
			fields[lookupName] = newDataQueryField;
			dispatchEvent(new Event(FIELDS_CHANGED));
		}
		
		public function BuildQueryString():String
		{
			var query:Object = new Object();
			
			query["limit"] = limit;
			query["dataset"] = dataset;
			query["fields"] = new Array();
			
			for (var key:String in fields)
			{
				var field:DataQueryField = fields[key] as DataQueryField;
				
				var fieldQuery:Object = new Object();

				if (field.sort)
					fieldQuery["sort"] = field.sort;
				if (field.modifier)
					fieldQuery["modifier"] = field.modifier;
				if (field.group)
					fieldQuery["group"] = field.group;
				if (field.alias)
					fieldQuery["alias"] = field.alias;
				fieldQuery["name"] = field.name;
				
				Logger.Log("Query Flielded : " + field.name);
				
				query["fields"].push(fieldQuery);
			}
			
			queryString = JSON.encode(query);
			return queryString;
		}
		
		public function LoadQueryResults():void
		{
			loading = true;

			if (!fields || fields.length < 1 || !dataset || dataset.length < 5 || !limit)
				return;

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
						// The "type" paramter can be: string, numeric, datetime, boolean, or url
						if (resultColumns[columnKey]["datatype"] == "numeric") {
							resultRows[rowKey][rowFieldKey] = parseFloat(resultRows[rowKey][rowFieldKey]);
						} else if (resultColumns[columnKey]["datatype"] == "datetime" && resultRows[rowKey][rowFieldKey] is String) {
							resultRows[rowKey][rowFieldKey] = Math.random();//new Date(resultRows[rowKey][rowFieldKey]);
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
					newObject[metadata.parent()["@name"]] = this[metadata.parent()["@name"]];
				}
			}

			return newObject;
		}

		public function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject) return false;
			for(var obj_k:String in dataObject) {
				try {
					if(this.hasOwnProperty(obj_k))
						this[obj_k] = dataObject[obj_k];
				} catch(e:Error) { }
			}
			return true;
		}
	}
}