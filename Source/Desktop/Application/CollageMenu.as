package Desktop.Application
{
	import flash.system.*;
	import flash.ui.*;
	import mx.events.*;
	import mx.controls.Alert;
	import mx.controls.FlexNativeMenu;
	import Collage.Utilities.Logger.*;
	import Collage.DataEngine.*;
	
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
					<menuitem label="Open from Cloud..." command="cloudstorage_opendashboard" key="o" />
	                <menuitem label="Open Local File..." command="open" />
	                <menuitem type="separator"/>
					<menuitem label="Save to Cloud..." command="cloudstorage_savedashboard" key="s" />
	                <menuitem label="Save Local File..." command="save" />
	                <menuitem type="separator"/>
	                <menuitem label="Save Debug Log File..." command="savelog" key="l" />
					<menuitem type="separator"/>
					<menuitem label="Export">
		                <menuitem label="PNG Image" command="saveImage"/>
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
					<menuitem label="Paste" command="paste" />
					<menuitem label="Delete" command="delete" />
	                <menuitem type="separator"/>
					<menuitem label="Refresh datasets" command="refreshDatasets" key="r"/>
	                <menuitem type="separator"/>
					<menuitem label="Select All" command="selectAll" key="a"/>
					<menuitem label="Deselect All" command="deselectAll"/>
	                <menuitem type="separator"/>
					<menuitem label="Move Selected Forward" command="moveForward"/>
					<menuitem label="Move Selected Backward" command="moveBackward"/>
					<menuitem label="Move Selected To Front" command="moveToFront"/>
					<menuitem label="Move Selected To Back" command="moveToBack"/>
	            </menuitem>
	            <menuitem label="Insert">
	                <menuitem label="Label" command="insertLabel" key="1"/>
	                <menuitem label="Text Box" command="insertTextBox" key="2"/>
	                <menuitem label="Image" command="insertImage" key="3"/>
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
                	<menuitem label="Viewer Window" type="check" command="viewer" key="0"/>
	                <menuitem label="Status Bar" type="check" command="statusbar" toggled="false" key="/"/>
	                <menuitem label="Grid" type="check" command="showgrid" toggled="false"/>
	                <menuitem type="separator" />
	                <menuitem label="Zoom In" command="zoomin" key="=" />
	                <menuitem label="Zoom Out" command="zoomout" key="-" />
	                <menuitem label="Fit To Screen" type="check" command="fittoscreen" toggled="false"/>
		            <menuitem label="Zoom">
	            		<menuitem label="25%"  amount="0.25" command="zoom" />
	            		<menuitem label="50%"  amount="0.50" command="zoom" />
	            		<menuitem label="75%"  amount="0.75" command="zoom" />
	            		<menuitem label="100%" amount="1.0" command="zoom" />
	            		<menuitem label="150%" amount="1.5" command="zoom" />
	            		<menuitem label="200%" amount="2.0" command="zoom" />
	            		<menuitem label="400%" amount="4.0" command="zoom" />
		            </menuitem>
	                <menuitem type="separator" />
					<menuitem label="Debug Log Window" command="debugger" />
	            </menuitem>
	        </root>;

//		public var collageMain:WindowedApplication = null;
		public var collageApp:AppMain = null;
		
		public function CollageMenu():void
		{
			dataProvider = menuData;
			keyEquivalentModifiersFunction = StandardOSModifier;
			addEventListener(FlexNativeMenuEvent.ITEM_CLICK, menuItemClicked);
			addEventListener(FlexNativeMenuEvent.MENU_SHOW, menuShow);
		}
		
		private function menuShow(menuEvent:FlexNativeMenuEvent):void
		{
//			if (!_EditDocumentView.IsObjectSelected()) {
//			}
		}

		private function StandardOSModifier(item:Object):Array{
			var modifiers:Array = new Array();
			if((Capabilities.os.indexOf("Windows") >= 0)){
				modifiers.push(Keyboard.CONTROL);
			} else if (Capabilities.os.indexOf("Mac OS") >= 0){
				modifiers.push(Keyboard.COMMAND);
			}
			return modifiers;
		}


		private function menuItemClicked(menuEvent:FlexNativeMenuEvent):void
		{
			if (!collageApp) {
				return;
			}

			var command:String = menuEvent.item.@command;
			switch(command){
				case "cut":			collageApp.Cut(null); break;
				case "copy": 		collageApp.Copy(null); break;
				case "paste":		collageApp.Paste(null); break;
				case "delete":		collageApp.document.DeleteSelected();	break;
				case "quit":		collageApp.Quit(); break;
				case "about":		break;
				case "open":		collageApp.OpenFile();	break;
				case "save":		collageApp.SaveFile();	break;
				case "savelog":		collageApp.SaveLogFile();	break;
				case "cloudstorage_opendashboard": collageApp.OpenFromCloud(); break;
				case "cloudstorage_savedashboard": collageApp.SaveToCloud(); break;
				case "saveImage": 	collageApp.SaveImage(); break;
				case "savePDF":		collageApp.SavePDF(); break;
				case "uploadData":	collageApp.UploadDataFile(); break;
				case "print":		break;
				case "undo":		break;
				case "redo":		break;
				case "new": 		collageApp.New(); break;
				case "moveForward":		collageApp.editPage.MoveSelectedForward(); break;
				case "moveBackward": 	collageApp.editPage.MoveSelectedBackward(); break;
				case "moveToFront":		collageApp.editPage.MoveSelectedToFront(); break;
				case "moveToBack":		collageApp.editPage.MoveSelectedToBack();	break;
				case "insertImage":		collageApp.editPage.AddClipByType('image');	break;
				case "insertLabel":		collageApp.editPage.AddClipByType('label'); break;
				case "insertTextBox": 	collageApp.editPage.AddClipByType('textbox'); break;
				case "selectAll": 		collageApp.editPage.SelectAll(); break;
				case "deselectAll": 	collageApp.editPage.DeselectAll(); break;
/*				case "insertDataLabel":	_EditDocumentView.AddClipByType('datalabel', new Rectangle(150, 150, 300, 300)); break;
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
*/
				case "refreshDatasets":
					DataEngine.LoadAllDataSets();
					break;
				case "logout": Session.Logout(); break;
				case "zoomin": 	collageApp.ZoomIn(); break;
				case "zoomout": collageApp.ZoomOut(); break;
				case "viewer": collageApp.OpenViewer(); break;
				case "fittoscreen":
					collageApp.fitToScreen = !collageApp.fitToScreen;
					menuEvent.item.@toggled = collageApp.fitToScreen;
					break;
				case "zoom": collageApp.Zoom(menuEvent.item.@amount); break;
				case "statusbar":
					collageApp.statusBarVisible = !collageApp.statusBarVisible;
					menuEvent.item.@toggled = collageApp.statusBarVisible;
					break;
				case "showgrid":
					collageApp.appGrid.visible = !collageApp.appGrid.visible;
					menuEvent.item.@toggled = collageApp.appGrid.visible;
					break;
				case "fullscreen":
					collageApp.Fullscreen();
					menuEvent.item.@toggled = !menuEvent.item.@toggled;
					break;
				case "debugger":
//					var newLoggerWindow:LoggerWindow = new LoggerWindow();
//					newLoggerWindow.open();
					break;
				default:
					Logger.LogWarning("Unrecognized Menu Command: " + command + "  " + menuEvent.item.@label);
			}
		}		
	}
}