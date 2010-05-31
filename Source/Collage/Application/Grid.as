package Collage.Application
{
	import spark.components.Group;

	public class Grid extends Group
	{
		[Bindable]public var xDensity:Number = 10;
		[Bindable]public var yDensity:Number = 10;
		[Bindable]public var xOffset:Number = 0;
		[Bindable]public var yOffset:Number = 0;

		public function Grid(app:CollageApp):void
		{

		}
		
	}	
}
