package Collage.Clip
{
	import Collage.Clips.*;
	import Collage.Utilities.Logger.*;
	
	public class ClipFactory
	{
		public static function CreateByType(clipType:String):Clip
		{
			Logger.LogDebug("Attempting to create clip of type " + clipType); 
			if (clipType == "image")
				return new ImageClip();
			else if (clipType == "label")
				return new LabelClip();
			else if (clipType == "textbox")
				return new TextBoxClip();
			else if (clipType == "linechart")
				return new LineChartClip();
			else if (clipType == "piechart")
				return new PieChartClip();
			else if (clipType == "scatterplot")
				return new ScatterPlotClip();
			else if (clipType == "table")
				return new TableClip();
			else if (clipType == "columnchart")
				return new ColumnChartClip();
			else if (clipType == "rssfeed")
				return new RssFeedClip();
			else if (clipType == "datalabel")
				return new DataLabelClip();
			else
				Logger.LogError("Clip type not found: " + clipType); 
			return null;
		}
	}
}