package Desktop.Application
{
	import mx.events.*;
	import mx.controls.Alert;
	import mx.controls.FlexNativeMenu;
	
	public class CollageMenu extends FlexNativeMenu
	{
		public var menuData:XML = <root>
	            <menuitem label="Collage">
	                <menuitem label="About" command="about" enabled="false"/>
					<menuitem type="separator"/>
					<menuitem label="Logout" command="logout" />
	                <menuitem label="Quit" command="quit" key="q"/>
	            </menuitem>
	            <menuitem label="File">
	                <menuitem label="New" command="new" key="n"/>
	                <menuitem label="Open..." command="open" key="o" />
					<menuitem label="Open from Cloud..." command="cloudstorage_opendashboard" />
	                <menuitem type="separator"/>
	                <menuitem label="Save..." command="save" key="s" />
					<menuitem label="Save to Cloud..." command="cloudstorage_savedashboard" />
					<menuitem type="separator"/>
					<menuitem label="Export">
		                <menuitem label="PNG Image" command="saveImage"/>
		                <menuitem label="Adobe PDF" command="savePDF" />
					</menuitem>
	                <menuitem type="separator"/>
	                <menuitem label="Upload Dataset..." command="uploadData"/>
	                <menuitem type="separator"/>
	                <menuitem label="Print..." key="p" command="print" enabled="false"/>
	            </menuitem>
	            <menuitem label="Edit">
	                <menuitem label="Undo" key="z" command="undo" enabled="false"/>
	                <menuitem label="Redo" command="redo" enabled="false"/>
	                <menuitem type="separator"/>
					<menuitem label="Cut" command="cut" key="x"/>
					<menuitem label="Copy" command="copy" key="c"/>
					<menuitem label="Paste" command="paste" key="v"/>
					<menuitem label="Delete" command="delete" />
	                <menuitem type="separator"/>
					<menuitem label="Refresh datasets" command="refreshDatasets" key="r"/>
	                <menuitem type="separator"/>
					<menuitem label="Move Selected Forward" command="moveForward"/>
					<menuitem label="Move Selected Backward" command="moveBackward"/>
					<menuitem label="Move Selected To Front" command="moveToFront"/>
					<menuitem label="Move Selected To Back" command="moveToBack"/>
	            </menuitem>
	            <menuitem label="Insert">
	                <menuitem label="Image" command="insertImage"/>
	                <menuitem label="Label" command="insertLabel"/>
	                <menuitem label="Text Box" command="insertTextBox"/>
	                <menuitem type="separator" />
	                <menuitem label="Data Label" command="insertDataLabel"/>
	                <menuitem label="Table" command="insertTable"/>
	                <menuitem label="Line" command="insertLineChart"/>
	                <menuitem label="Scatter Chart" command="insertScatterChart"/>
	                <menuitem label="Bar Chart" command="insertBarChart"/>
	                <menuitem label="Pie Chart" command="insertPieChart"/>
	                <menuitem label="Guage" command="insertGuage"/>
	                <menuitem type="separator" />
	                <menuitem label="Web Embed" command="insertWebEmbed"/>
	                <menuitem label="Google Maps" command="insertGoogleMaps"/>
	            </menuitem>
	            <menuitem label="View">
	                <menuitem label="Fullscreen" type="check" command="fullscreen" toggled="false" key="f"/>
	                <menuitem type="separator" />
					<menuitem label="Debug Log Window" command="debugger" />
	            </menuitem>
	        </root>;

//		public var collageMain:WindowedApplication = null;
		public var collageApp:AppMain = null;
		
		public function CollageMenu():void
		{
			dataProvider = menuData;
			addEventListener(FlexNativeMenuEvent.ITEM_CLICK, menuItemClicked);
			addEventListener(FlexNativeMenuEvent.MENU_SHOW, menuShow);
		}
		
		private function menuShow(menuEvent:FlexNativeMenuEvent):void
		{
//			if (!_EditDocumentView.IsObjectSelected()) {
//			}
		}

		private function menuItemClicked(menuEvent:FlexNativeMenuEvent):void
		{
			if (!collageApp) {
				return;
			}

			var command:String = menuEvent.item.@command;
			switch(command){
				case "cut":			collageApp.clgClipboard.HandleCut(null); break;
				case "copy": 		collageApp.clgClipboard.HandleCopy(null); break;
				case "paste":		collageApp.clgClipboard.HandlePaste(null); break;
				case "delete":		collageApp.document.DeleteSelected();	break;
				case "quit":		collageApp.Quit(); break;
				case "about":		break;
				case "open":		collageApp.OpenFile();	break;
				case "save":		collageApp.SaveFile();	break;
//				case "cloudstorage_opendashboard": CloudFile_OpenDashboard(); break;
//				case "cloudstorage_savedashboard": CloudFile_SaveDashboard(); break;
				case "saveImage": 	collageApp.SaveImage(); break;
				case "savePDF":		collageApp.SavePDF(); break;
				case "uploadData":	collageApp.UploadDataFile(); break;
				case "print":		break;
				case "undo":		break;
				case "redo":		break;
				case "new": 		collageApp.document.NewDocument(); break;
				case "moveForward":		collageApp.document.MoveSelectedForward(); break;
				case "moveBackward": 	collageApp.document.MoveSelectedBackward(); break;
				case "moveToFront":		collageApp.document.MoveSelectedToFront(); break;
				case "moveToBack":		collageApp.document.MoveSelectedToBack();	break;
/*				case "insertImage":		addImageClip();	break;
				case "insertLabel":		_EditDocumentView.AddClipByType('label', new Rectangle(150, 150, 300, 300)); break;
				case "insertTextBox": 	_EditDocumentView.AddClipByType('textbox', new Rectangle(150, 150, 300, 300)); break;
				case "insertDataLabel":	_EditDocumentView.AddClipByType('datalabel', new Rectangle(150, 150, 300, 300)); break;
				case "insertTable":		_EditDocumentView.AddClipByType('table', new Rectangle(150, 150, 300, 300)); break;
				case "insertLineChart":	_EditDocumentView.AddClipByType('linechart', new Rectangle(150, 150, 300, 300)); break;
				case "insertScatterChart":	_EditDocumentView.AddClipByType('scatterchart', new Rectangle(150, 150, 300, 300));	break;
				case "insertBarChart":	_EditDocumentView.AddClipByType('barchart', new Rectangle(150, 150, 300, 300)); break;
				case "insertPieChart":	_EditDocumentView.AddClipByType('piechart', new Rectangle(150, 150, 300, 300));	break;
				case "insertGuage":		_EditDocumentView.AddClipByType('guage', new Rectangle(150, 150, 300, 300)); break;
				case "insertWebEmbed":	_EditDocumentView.AddClipByType('webembed', new Rectangle(150, 150, 300, 300));	break;
				case "insertGoogleMaps":_EditDocumentView.AddClipByType('googlemaps', new Rectangle(150, 150, 300, 300)); break;
				case "refreshDatasets":	DataEngine.LoadAllDataSets();
					break;
				case "logout": Session.Logout(); break;
*/
				case "fullscreen":
					collageApp.Fullscreen();
					menuEvent.item.@toggled = !menuEvent.item.@toggled;
					break;
				case "debugger":
//					var newLoggerWindow:LoggerWindow = new LoggerWindow();
//					newLoggerWindow.open();
					break;
				default:
					Alert.show("Unrecognized Menu Command: " + command + "  " + menuEvent.item.@label);

			}
		}		
	}
}