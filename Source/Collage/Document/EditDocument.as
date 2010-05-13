package Collage.Document
{
	import mx.controls.Alert;
	import Collage.Clip.*;
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
		public var toolbar:SkinnableContainer;
		
		public function EditDocument():void
		{
			super();
		}
		
		public function InitializeForEdit():void
		{
			InitObjectHandles();
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

		public override function AddClip(_clip:Clip):Clip
		{
			var newClip:Clip = super.AddClip(_clip);
			if (!newClip) {
				return null;
			}
			
			objectHandles.registerComponent(newClip, newClip.view);
			objectHandles.selectionManager.addToSelected(newClip);
			return newClip;
		}
		
		public override function DeleteClip(_clip:Clip):void
		{
			if (toolbar)
				toolbar.removeAllElements();

			objectHandles.unregisterComponent(_clip);
			super.DeleteClip(_clip);
		}
		
		public function DeselectAll():void
		{
			objectHandles.selectionManager.clearSelection();
			if (toolbar)
				toolbar.removeAllElements();
		}
		
		protected function ObjectSelected(event:SelectionEvent):void {
			if (!toolbar) {
				objectHandles.selectionManager.clearSelection();
				return;
			}
			
			toolbar.removeAllElements();
			if (event.targets && event.targets.length == 1) {
				var selectedClip:Clip = event.targets[0] as Clip;
				toolbar.addElement(selectedClip.CreateEditor());
			}
			
			for each (var clip:Clip in event.targets) {
				clip.selected = true;
			}
		}

		protected function ObjectDeselected(event:SelectionEvent):void {
			if (toolbar)
				toolbar.removeAllElements();

			for each (var clip:Clip in event.targets) {
				clip.selected = false;
			}
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