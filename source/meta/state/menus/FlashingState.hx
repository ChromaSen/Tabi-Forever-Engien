package meta.state.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		// PLEASE DONT HAVE CRLF IN YOUR IDE IN THIS FILE, CHANGE IT TO LF SINCE THAT FIXES THE HUGE LINEBREAKS
		warnText = new FlxText(0, 0, FlxG.width, "WARNING:\n
			VS TABI may potentially trigger seizures for people with\n
			photosensitive epilepsy.\n
			Press ENTER to disable them now or go to Options Menu.\n
			Press ESCAPE to ignore this message.\n
			You've been warned!", 32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if (!leftState)
		{
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back)
			{
				leftState = true;
				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;
				if (!back)
				{
                    /*
					Init.photoSensitiveMode = true;
					Init.saveSettings();
                    will do later
                    */
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker)
					{
						new FlxTimer().start(0.5, function(tmr:FlxTimer)
						{
							Main.switchState(this, new MainMenuState());
						});
					});
				}
				else
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function(twn:FlxTween)
						{
							Main.switchState(this, new TitleState());
						}
					});
				}
			}
		}
		super.update(elapsed);
	}
}