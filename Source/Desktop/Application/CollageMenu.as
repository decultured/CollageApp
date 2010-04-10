package Application
{
	class CollageMenu
	{
		public var collageMain:WindowedApplication = null;
		public var collageApp:AppMain = null;
		
		public function CollageMenu():void
		{
			
		}
		
		private function menuShow(menuEvent:FlexNativeMenuEvent):void
		{
			if (!_EditDocumentView.IsObjectSelected()) {
			}
		}

		private function menuItemClicked(menuEvent:FlexNativeMenuEvent):void
		{
/*			var command:String = menuEvent.item.@command;
			switch(command){
				case "cut":			collageApp.HandleCut(null); break;
				case "copy": 		collageApp.HandleCopy(null); break;
				case "paste":		collageApp.HandlePaste(null); break;
				case "delete":		_EditDocumentView.deleteSelected();	break;
				case "quit":		NativeApplication.nativeApplication.exit();	break;
				case "about":		break;
				case "open":		OpenFile();	break;
				case "save":		SaveFile();	break;
				case "cloudstorage_opendashboard": CloudFile_OpenDashboard(); break;
				case "cloudstorage_savedashboard": CloudFile_SaveDashboard(); break;
				case "saveImage": 	SaveImage(); break;
				case "savePDF":		SavePDF(); break;
				case "uploadData":	UploadDataFile(); break;
				case "print":		break;
				case "undo":		break;
				case "redo":		break;
				case "new":
					_EditDocumentView.NewDocument();
					_Dashboard = null;
					_DashboardImages = null;
					_DashboardImages = new Array();
					break;
				case "moveForward":		_EditDocumentView.MoveSelectedForward(); break;
				case "moveBackward": 	_EditDocumentView.MoveSelectedBackward(); break;
				case "moveToFront":		_EditDocumentView.MoveSelectedToFront(); break;
				case "moveToBack":		_EditDocumentView.MoveSelectedToBack();	break;
				case "insertImage":		addImageClip();	break;
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
				case "fullscreen":
					Fullscreen();
					menuEvent.item.@toggled = !menuEvent.item.@toggled;
					break;
				case "refreshDatasets":	DataEngine.LoadAllDataSets();
					break;
				case "logout": Session.Logout(); break;
				case "debugger":
					var newLoggerWindow:LoggerWindow = new LoggerWindow();
					newLoggerWindow.open();
					break;
				case "hideInspector":
					inspectorCanvas.visible = !inspectorCanvas.visible;

					if (!inspectorCanvas.visible) {
						menuEvent.item.@label = "Show Inspector";
						inspectorCanvas.width = 0;
						editCanvas.setStyle("right","0");
					} else {
						menuEvent.item.@label = "Hide Inspector";
						inspectorCanvas.width = 255;
						editCanvas.setStyle("right","255");
					}

					break;
				default:
					Alert.show("Unrecognized Menu Command: " + command + "  " + menuEvent.item.@label);
*/
			}
		}		
	}
}