package Collage.Clip
{
	import Collage.Clips.ColumnChartClip.*;
	import Collage.Clips.DataLabelClip.*;
	import Collage.Clips.GuageClip.*;
	import Collage.Clips.ImageClip.*;
	import Collage.Clips.LabelClip.*;
	import Collage.Clips.LineChartClip.*;
	import Collage.Clips.PieChartClip.*;
	import Collage.Clips.RssFeedClip.*;
	import Collage.Clips.YouTubeClip.*;
	import Collage.Clips.BubbleChartClip.*;
	import Collage.Clips.ScatterPlotClip.*;
	import Collage.Clips.TableClip.*;
	import Collage.Clips.TextBoxClip.*;
	import Collage.Clips.WordCloudClip.*;
	import Collage.Clips.GraphClip.*;
	import Collage.Clips.MultiseriesClip.*;
	import Collage.Clips.Map.*;
	import Collage.Utilities.Logger.*;
	
	public class ClipFactory
	{
		public static function CreateByType(clipType:String):Clip
		{
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
			else if (clipType == "bubblechart")
				return new BubbleChartClip();
			else if (clipType == "scatterplot")
				return new ScatterPlotClip();
			else if (clipType == "table")
				return new TableClip();
			else if (clipType == "columnchart")
				return new ColumnChartClip();
			else if (clipType == "rssfeed")
				return new RssFeedClip();
			else if (clipType == "youtube")
				return new YouTubeClip();
			else if (clipType == "datalabel")
				return new DataLabelClip();
			else if (clipType == "wordcloud")
				return new WordCloudClip();
			else if (clipType == "graph")
				return new GraphClip();
			else if (clipType == "multiseries")
				return new MultiseriesClip();
			else if (clipType == "map")
				return new MapClip();
			else
				Logger.LogError("Clip type not found: " + clipType); 
			return null;
		}
	}
}