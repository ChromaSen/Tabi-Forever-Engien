package tabi.display;

import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import haxe.io.Path;
import openfl.display.BitmapData;
import sys.FileSystem;

using StringTools;

// an overhaul of a earlier class i did in the past
class AnimatedSprite extends FlxSprite
{
	public var animationList:Array<SpriteFrame> = [];
	public var fps:Int = 0;
	public var paused:Bool = false;

	private var __frameIndex:Float = 0;
	private var _frameTimer:Float = 0.0;
	private var __curAnimation:String = '';

	public override function new(x:Float = 0, y:Float = 0, folder:String)
	{
		super(x, y);

		var actualFolder = "assets/images/" + folder;

		if (FileSystem.exists(actualFolder))
		{
			if (FileSystem.isDirectory(actualFolder))
			{
				animationList = [];

				for (image in FileSystem.readDirectory(actualFolder))
				{
					animationList.push({name: image.replace(".png", ""), bitmap: Paths.image(folder).bitmap});
				}

				trace(animationList.length);
			}
		}
	}

	@:keep
	override public function update(elapsed:Float)
	{
		if (animationList.length > 0 && __curAnimation.length > 0 && !paused)
		{
			_frameTimer += elapsed;
			while (_frameTimer > 1 / fps)
			{
				_frameTimer -= 1 / fps;
				{
					if (__frameIndex == numFrames - 1)
						__frameIndex = 0;
					else
						__frameIndex += 1 / 24;
				}
			}
		}

		super.update(elapsed);
	}

	@:keep
	public function playAnimation(anim:String)
	{
		var index:Int = findAnimThruName(anim);
        if (index == -1)
            return;
		loadGraphic(animationList[index].bitmap);
	}

	private function findAnimThruName(name:String):Int
	{
		for (i in 0...animationList.length)
		{
			if (animationList[i].name == name)
				return i;
		}

		return -1;
	}
}

typedef SpriteFrame =
{
	var name:String;
	var bitmap:BitmapData;
}
