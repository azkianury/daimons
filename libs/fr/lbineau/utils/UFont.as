package fr.lbineau.utils
{
	import flash.text.Font;

	/**
	 * @author lbineau
	 */
	public class UFont
	{
		public static function traceEmbedFonts() : void
		{
			var fontsList : Array = Font.enumerateFonts(false);
			var i : uint;
			var l : uint = fontsList.length;

			while (i < l)
			{
				var f : Font = fontsList[i];
				trace(f.fontName);
				i++;
			}
		}
	}
}
