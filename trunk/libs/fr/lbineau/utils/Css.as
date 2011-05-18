package fr.lbineau.utils
{
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Css
	{
		public static function apply(txt : TextField, fontName : String) : void
		{
			var format : TextFormat = txt.getTextFormat();
			format.font = fontName;
			txt.embedFonts = true;

			// si c'est une typo pixel, je force la taille a celle definie par la typo
			if (fontName.indexOf("pt_st") != -1)
			{
				var split : Array = fontName.split("_");
				var tailleSt : String = split[split.length - 2];
				var taille : uint = uint(tailleSt.slice(0, tailleSt.length - 2));
				format.size = taille;
			}

			txt.defaultTextFormat = format;
			txt.setTextFormat(format);
		}
	}
}