package meta.state.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import meta.MusicBeat.MusicBeatState;
import meta.state.menus.MainMenuState;

class DisclaimerState extends MusicBeatState
{
	override function create()
	{
		FlxG.camera.bgColor = 0xFF2B2B2B;

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.T)
			Main.switchState(this, new MainMenuState());

		super.update(elapsed);
	}
}
