package meta.state.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import meta.MusicBeat.MusicBeatState;
import meta.state.menus.MainMenuState;

class DisclaimerState extends MusicBeatState
{
	override function create()
	{
		super.create();

		var preload:FlxSprite = new FlxSprite().loadGraphic(Paths.image('preload'));
		add(preload);

		var text:FlxText = new FlxText(0, 0, FlxG.width * 0.8,
			"DISCLAIMER:\nThe following content portrays themes of\nabuse, mental health, and other types that players may find disturbing. \n\nProceed with caution.\n\nPress SPACE to Continue.");
		text.alignment = CENTER;
		text.setFormat(Paths.font("lato_bold.ttf"), 24, OUTLINE, 0xFF000000);
		text.screenCenter();
		add(text);
	}

	private var fade:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));

			if (!fade)
			{
				fade = true;

				FlxG.camera.fade(0x00000000, 2.5, true, function()
				{
					Main.switchState(this, new MainMenuState());
				});
			}
		}

		super.update(elapsed);
	}
}