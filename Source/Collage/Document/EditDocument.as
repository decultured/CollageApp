package Collage.Document
{
	import mx.controls.Alert;
	import Collage.Clip.*;
	import Collage.Clips.*;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import com.roguedevelopment.objecthandles.*;
	import com.roguedevelopment.objecthandles.decorators.AlignmentDecorator;
	import com.roguedevelopment.objecthandles.decorators.DecoratorManager;
	import mx.managers.PopUpManager;

	public class EditDocument extends Document
	{
		public var objectHandles:ObjectHandles;
		protected var decoratorManager:DecoratorManager;
		public var toolbar:Group;
		
		public function EditDocument():void
		{
			super();
		}
		
		public function InitializeForEdit():void
		{
			InitObjectHandles();

			var newClip:LabelClip = new LabelClip();
			newClip.x = 150;
			newClip.y = 150;
			AddClip(newClip);

			var newClip2:TextBoxClip = new TextBoxClip();
			newClip2.x = 150;
			newClip2.y = 150;
			AddClip(newClip2);
		}

		public override function NewDocument():void
		{
/*
			var childArray:Array = getChildren();
			for (var i:uint = 0; i < childArray.length; i++) {
				if (childArray[i] && childArray[i] is ClipView)
					objectHandles.unregisterComponent(childArray[i]);
			}
*/
			//DrawGrid();
			super.NewDocument();
		}

		public function InitObjectHandles():void
		{
			objectHandles = new ObjectHandles(this, null, new Flex4HandleFactory(), new Flex4ChildManager());
			objectHandles.selectionManager.addEventListener(SelectionEvent.ADDED_TO_SELECTION, ObjectSelected);
			objectHandles.selectionManager.addEventListener(SelectionEvent.REMOVED_FROM_SELECTION, ObjectDeselected);
			objectHandles.selectionManager.addEventListener(SelectionEvent.SELECTION_CLEARED, ObjectDeselected);

//			decoratorManager = new DecoratorManager( objectHandles, this );
//			decoratorManager.addDecorator( new AlignmentDecorator() );
		}

		public function AddObjectHandles(_newClip:Clip):void
		{
		}
		
		private function SetToolbar():void
		{
			if (!toolbar)
				return;
				
			toolbar.removeAllElements();

		 	if (objectHandles.selectionManager.currentlySelected.length == 1) {
				var selectedClip:Clip = objectHandles.selectionManager.currentlySelected[0] as Clip;
				toolbar.addElement(selectedClip.CreateEditor());
			} else if (objectHandles.selectionManager.currentlySelected.length > 1) {
				
			} else {
				toolbar.addElement(new EditDocumentToolbar(this));
			}
		}

		public override function AddClip(_clip:Clip):Clip
		{
			var newClip:Clip = super.AddClip(_clip);
			if (!newClip) {
				return null;
			}
			
			objectHandles.selectionManager.clearSelection();
			objectHandles.registerComponent(newClip, newClip.view);
			objectHandles.selectionManager.addToSelected(newClip);
			return newClip;
		}
		
		public override function DeleteClip(_clip:Clip):void
		{
			objectHandles.unregisterComponent(_clip);
			SetToolbar();
			super.DeleteClip(_clip);
		}
		
		public function DeselectAll():void
		{
			if (!objectHandles)
				return;
				
			objectHandles.selectionManager.clearSelection();
		}
		
		protected function ObjectSelected(event:SelectionEvent):void {
			for each (var clip:Clip in event.targets) {
				clip.selected = true;
			}
			SetToolbar();
		}

		protected function ObjectDeselected(event:SelectionEvent):void {
			if (toolbar)
				toolbar.removeAllElements();

			for each (var clip:Clip in event.targets) {
				clip.selected = false;
			}
			SetToolbar();
		}

		public function DeleteSelected():void
		{
			
		}
		
		public function MoveSelectedForward():void
		{
		}
		
		public function MoveSelectedBackward():void
		{
		}
		
		public function MoveSelectedToFront():void
		{
		}
		
		public function MoveSelectedToBack():void
		{
		}
	} 
}