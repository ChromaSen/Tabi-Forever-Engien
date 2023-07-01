package meta;

import flixel.FlxG;
import flixel.util.FlxColor;
import lime.utils.Assets;
import meta.state.PlayState;
import openfl.display.BitmapData;

using StringTools;

#if sys
import sys.FileSystem;
#end

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];
	public static var difficultyLength = difficultyArray.length;

	public static function difficultyFromNumber(number:Int):String
	{
		return difficultyArray[number];
	}

	public static function dashToSpace(string:String):String
	{
		return string.replace("-", " ");
	}

	public static function spaceToDash(string:String):String
	{
		return string.replace(" ", "-");
	}

	public static function swapSpaceDash(string:String):String
	{
		return StringTools.contains(string, '-') ? dashToSpace(string) : spaceToDash(string);
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function getOffsetsFromTxt(path:String):Array<Array<String>>
	{
		var fullText:String = Assets.getText(path);

		var firstArray:Array<String> = fullText.split('\n');
		var swagOffsets:Array<Array<String>> = [];

		for (i in firstArray)
			swagOffsets.push(i.split(' '));

		return swagOffsets;
	}

	public static function returnAssetsLibrary(library:String, ?subDir:String = 'assets/images'):Array<String>
	{
		var libraryArray:Array<String> = [];

		#if sys
		var unfilteredLibrary = FileSystem.readDirectory('$subDir/$library');

		for (folder in unfilteredLibrary)
		{
			if (!folder.contains('.'))
				libraryArray.push(folder);
		}
		trace(libraryArray);
		#end

		return libraryArray;
	}

	public static function getAnimsFromTxt(path:String):Array<Array<String>>
	{
		var fullText:String = Assets.getText(path);

		var firstArray:Array<String> = fullText.split('\n');
		var swagOffsets:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagOffsets.push(i.split('--'));
		}

		return swagOffsets;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}
	public static function getDominantIconColor(char:String)
	{

		var iconBitmapData:BitmapData = BitmapData.fromFile('assets/images/icons/icon-$char.png');
		var colorDict:Map<Int, Int> = new Map<Int, Int>();
		for (x in 0...iconBitmapData.width)
		{
			for (y in 0...iconBitmapData.height)
			{
				var pixelColour:Int = iconBitmapData.getPixel32(x, y);
				if (pixelColour != 0 && pixelColour != 0xFF000000)
				{
					if (colorDict.exists(pixelColour))
					{
						colorDict.set(pixelColour, colorDict.get(pixelColour) + 1);
					}
					else
					{
						colorDict.set(pixelColour, 1);
					}
				}
			}
		}
		var mostFrequentColour:Int = 0;
		var mostFrequentColourFrequency:Int = 0;
		for (color in colorDict.keys())
		{
			if (colorDict.get(color) > mostFrequentColourFrequency)
			{
				mostFrequentColour = color;
				mostFrequentColourFrequency = colorDict.get(color);
			}
		}
		var dominantColour:FlxColor = FlxColor.fromInt(mostFrequentColour);
		return dominantColour;
	}

	public static function formatAccuracy(value:Float, dec:Int = 2):String
	{
		var str = Std.string(value), ind;
		if ((ind = str.indexOf('.')) == -1)
			return str + ('.').rpad('0', dec + 1);
		return '${str.substr(0, ind)}.${str.substr(ind + 1, dec)}';
	}

	public static function browserLoad(site:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}
}
