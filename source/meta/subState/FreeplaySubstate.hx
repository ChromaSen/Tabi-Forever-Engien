package meta.subState;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import meta.MusicBeat.MusicBeatSubState;

class FreeplaySubstate extends MusicBeatSubState
{
	public static var curSelected:Int = 0;

	private var bg:FlxSprite;

	public var arrowLeft:Arrow;
	public var arrowRight:Arrow;

	public var songList:Array<FlxSprite> = [];

	override function create()
	{
		super.create();

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		add(bg);

		arrowLeft = new Arrow("left");
		arrowLeft.screenCenter();
		arrowLeft.x = 8;
		arrowLeft.selectIncrement = -1;
		add(arrowLeft);

		arrowRight = new Arrow("right");
		arrowRight.screenCenter();
		arrowRight.x = FlxG.width - arrowRight.width - 8;
		arrowRight.selectIncrement = 1;
		add(arrowRight);

		for (week in 0...Main.gameWeeks.length)
		{
			for (song in cast(Main.gameWeeks[week][0], Array<Dynamic>)) 
            {
                var spr:FlxSprite = new FlxSprite();
                spr.loadGraphic(Paths.image('menus/main/freeplay/songs/$song'));
                spr.screenCenter();
                add(spr);
                spr.kill();
                songList.push(spr);
            }
		}

        changeSelection();
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			exists = false;
			this._parentState.persistentUpdate = true;
			camera.visible = false;

			return;
		}

		if (FlxG.mouse.pressed)
		{
			for (arr in [arrowLeft, arrowRight])
			{
				if (overlapHelper(arr))
					arr.playAnim("push");
				else
					arr.playAnim("idle");
			}
		}

		if (FlxG.mouse.justPressed || controls.LEFT_P || controls.RIGHT_P) 
        {
            var increment:Int = 0;

            if (controls.LEFT)
                increment = -1;
            else if (controls.RIGHT)
                increment = 1;
            else if (FlxG.mouse.justPressed)
            {
                for (spr in [arrowLeft, arrowRight])
                {
                    if (overlapHelper(spr))
                    {
                        increment = spr.selectIncrement;
                        break;
                    }
                }
            }

            if (increment != 0)
                changeSelection(Math.floor(FlxMath.bound(increment, -1, 1)));
        }

		for (arr in [arrowLeft, arrowRight])
		{
			if (!overlapHelper(arr))
				arr.playAnim("idle");
		}

		if (camera != null && camera.x > 0)
		{
			camera.x -= 8000 * elapsed;
		}
		if (camera.x < 0)
			camera.x = 0;

		super.update(elapsed);
	}

    public function changeSelection(change:Int = 0)
    {
        if (change != 0)
        {  
            if (songList[curSelected + change] == null || !FlxMath.inBounds(curSelected + change, 0, songList.length))
                return;

            curSelected += change;

            songList[curSelected - change].kill();
            songList[curSelected].revive();

			FlxG.sound.play(Paths.sound("turnPage"));
        }
        else
			songList[curSelected].revive();
    }

	private function overlapHelper(spr:FlxSprite):Bool
	{
		var screenPosition:FlxPoint = spr.getScreenPosition();
		var mousePosition:FlxPoint = FlxG.mouse.getScreenPosition(camera);

		return (mousePosition.x >= screenPosition.x && mousePosition.x <= screenPosition.x + spr.width)
			&& (mousePosition.y >= screenPosition.y && mousePosition.y <= screenPosition.y + spr.height);
	}
}

class Arrow extends FlxSprite
{
	public var selectIncrement:Int = 0;

	override public function new(name:String)
	{
		super();

		frames = Paths.getSparrowAtlas('menus/main/freeplay/freeplay_buttons');

		animation.addByIndices("idle", name, [0], "", 1, false);
		animation.addByIndices("push", name, [1], "", 1, false);

		animation.play("idle");
	}

	private var holdTime:Float = 0.0;

	override function update(elapsed:Float)
	{
        if (animation.curAnim.name == "push" && holdTime <= 0.0)
        {
            animation.play("idle");

			centerOffsets();
        }
        else
            holdTime -= elapsed;

		super.update(elapsed);
	}

    public function playAnim(name:String)
    {
        if (name == "push")
            holdTime = 0.06;

        animation.play(name);
		centerOffsets();
    }
}
