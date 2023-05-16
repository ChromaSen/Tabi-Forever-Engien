package meta.subState;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import meta.MusicBeat.MusicBeatSubState;

class FreeplaySubstate extends MusicBeatSubState
{
    public static var curSelected:Int = 0;

    private var bg:FlxSprite;

    override function create()
    {
        super.create();

        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0.6;
        add(bg);
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

        if (camera != null && camera.x > 0)
        {
            camera.x -= 3000 * elapsed;
        }
        else
            camera.x = 0;
            

        super.update(elapsed);
    }
}