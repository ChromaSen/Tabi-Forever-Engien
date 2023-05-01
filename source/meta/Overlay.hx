package meta;

import flixel.FlxG;
import haxe.Timer;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
	Overlay that displays FPS and memory usage.

	Based on this tutorial:
	https://keyreal-code.github.io/haxecoder-tutorials/17_displaying_fps_and_memory_usage_using_openfl.html
**/
class Overlay extends TextField
{
	private var outlines:Array<TextField> = [];

	var times:Array<Float> = [];
	var memPeak:UInt = 0;

	// display info
	static var displayFps = true;
	static var displayMemory = true;
	static var displayExtra = true;

	public function new(x:Float, y:Float, borderSize:Float = 0)
	{
		super();

		this.x = x;
		this.y = x;

		autoSize = LEFT;
		selectable = false;

		defaultTextFormat = new TextFormat(Paths.font("lato_med.ttf"), 12, 0xD6E1E9);
		text = "";

		if (borderSize > 0)
		{
			var iterations:Int = Std.int(borderSize);
			var delta:Float = borderSize / iterations;

			for (i in 0...iterations)
			{
				var offset:Float = -delta * i;
				for (dx in [-delta, 0, delta])
				{
					for (dy in [-delta, 0, delta])
					{
						if (dx != 0 || dy != 0)
							addOutline(offset + dx, offset + dy);
					}
				}
			}
		}


		var timer:Timer = new Timer(1000);
		timer.run = update;
	}

	static final intervalArray:Array<String> = ['B', 'KB', 'MB', 'GB', 'TB'];

	public static function getInterval(num:UInt):String
	{
		var size:Float = num;
		var data = 0;
		while (size > 1024 && data < intervalArray.length - 1)
		{
			data++;
			size = size / 1024;
		}

		size = Math.round(size * 100) / 100;
		return size + " " + intervalArray[data];
	}

	private var _lastTime:Float = 0; 

	private function update()
	{
		var mem = System.totalMemory;
		if (mem > memPeak)
			memPeak = mem;

		if (visible)
		{
			text = '' // set up the text itself
				+ (displayFps ? "FPS: " + Math.floor(1 / (Timer.stamp() - _lastTime)) + "\n" : '') // Framerate
				+ (displayMemory ? 'MEM: ${getInterval(mem)} / ${getInterval(memPeak)}\n' : '') // Current and Total Memory Usage
			#if !neko + (displayExtra ? Main.mainClassState + "\n" : ''); #end // Current Game State

			_lastTime = Timer.stamp();

			for (textOutline in outlines)
			{
				if (textOutline != null)
					textOutline.text = this.text;
			}

			if (displayFps || displayMemory)
			{
				setTextFormat(new TextFormat(Paths.font("lato_bold.ttf"), 12, 0xA4ADB4, true), text.indexOf("FPS:"), text.indexOf("FPS:") + 4);
				setTextFormat(new TextFormat(Paths.font("lato_bold.ttf"), 12, 0xA4ADB4, true), text.indexOf("MEM:"), text.indexOf("MEM:") + 4);

				for (textOutline in outlines)
				{
					if (textOutline != null)
					{
						textOutline.setTextFormat(new TextFormat(Paths.font("lato_bold.ttf"), 12, 0x000000, true), text.indexOf("FPS:"),
							text.indexOf("FPS:") + 4);
						textOutline.setTextFormat(new TextFormat(Paths.font("lato_bold.ttf"), 12, 0x000000, true), text.indexOf("MEM:"),
							text.indexOf("MEM:") + 4);
					}
				}
			}
		}
	}

	public static function updateDisplayInfo(shouldDisplayFps:Bool, shouldDisplayExtra:Bool, shouldDisplayMemory:Bool)
	{
		displayFps = shouldDisplayFps;
		displayExtra = shouldDisplayExtra;
		displayMemory = shouldDisplayMemory;
	}

	function addOutline(dx:Float, dy:Float):Void
	{
		var textOutline:TextField = new TextField();
		textOutline.x = this.x + dx;
		textOutline.y = this.y + dy;
		textOutline.autoSize = LEFT;
		textOutline.selectable = false;
		textOutline.mouseEnabled = false;
		textOutline.defaultTextFormat = new TextFormat(Paths.font("lato_med.ttf"), 10, 0xFF000000);
		textOutline.text = '';

		outlines.push(textOutline);
		Main.instance.addChild(textOutline);
	}
}