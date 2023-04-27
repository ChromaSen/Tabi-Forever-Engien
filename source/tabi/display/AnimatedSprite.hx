package tabi.display;

import flixel.FlxSprite;
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

	override function new(x:Float = 0, y:Float = 0, folder:String)
	{
		super(x, y);

		if (FileSystem.exists(folder))
		{
			animationList = [];
			for (image in FileSystem.readDirectory(folder))
			{
				var finalPath:String = image.replace(".png", "");
				animationList.push({name: finalPath, bitmap: BitmapData.fromFile(Path.join([folder, image]))});
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
	override public function draw():Void
	{
		if (animationList.length > 0)
			super.draw();
		else
		{
			if (isSimpleRender(camera))
			{
				if (isPixelPerfectRender(camera))
					_point.floor();

				_point.copyToFlash(_flashPoint);
				camera.copyPixels(null, animationList[Math.floor(__frameIndex)].bitmap, _flashRect, _flashPoint, colorTransform, blend, antialiasing);
			}
			else
			{
				_matrix.translate(-origin.x, -origin.y);
				_matrix.scale(scale.x, scale.y);

				if (bakedRotationAngle <= 0)
				{
					updateTrig();

					if (angle != 0)
						_matrix.rotateWithTrig(_cosAngle, _sinAngle);
				}

				_point.add(origin.x, origin.y);
				_matrix.translate(_point.x, _point.y);

				if (isPixelPerfectRender(camera))
				{
					_matrix.tx = Math.floor(_matrix.tx);
					_matrix.ty = Math.floor(_matrix.ty);
				}

				camera.drawPixels(null, animationList[Math.floor(__frameIndex)].bitmap, _matrix, colorTransform, blend, antialiasing, shader);
			}
		}
	}

    @:keep
    public function playAnimation(anim:String, force:Bool)
    {
        if (anim == __curAnimation && force)
        {
            __frameIndex = 0;
            _frameTimer = 0;
        }
        else if (!force)
        {
            __frameIndex = 0;
            _frameTimer = 0;

            __curAnimation = anim;
        }
    }
}

typedef SpriteFrame =
{
	var name:String;
	var bitmap:BitmapData;
}
