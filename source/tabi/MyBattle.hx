package tabi;
import flixel.FlxG;
import flixel.util.FlxColor;
import meta.state.PlayState;
class MyBattle extends SongEvents
{
	override public function beatHit(beat:Int)
    {
		switch (beat)
		{
			case 32:
				FlxG.camera.flash(FlxColor.WHITE, 0.5, false);
			case 96:
				FlxG.camera.flash(FlxColor.WHITE,0.5,false);
				PlayState.defaultCamZoom=0.7;
			case 160:
				FlxG.camera.flash(FlxColor.WHITE, 0.5, false);
				PlayState.defaultCamZoom=0.6;
			case 224:
				FlxG.camera.flash(FlxColor.WHITE, 0.5, false);
		}
    }
}
