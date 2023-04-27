package meta.state;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import meta.MusicBeat.MusicBeatState;
import meta.data.*;
import meta.data.dependency.Discord;
import meta.data.font.Alphabet;
import meta.state.menus.*;
import openfl.Assets;

using StringTools;

/**
	I hate this state so much that I gave up after trying to rewrite it 3 times and just copy pasted the original code
	with like minor edits so it actually runs in forever engine. I'll redo this later, I've said that like 12 times now

	I genuinely fucking hate this code no offense ninjamuffin I just dont like it and I don't know why or how I should rewrite it
**/
class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	public static var nameList:Array<String> = ['Cougar MacDowall presents', 'A Friday Night Funkin\' Mod'];

	public var textDisplay:FlxText;
	public var title:FlxSprite;

	override public function create():Void
	{
		controls.setKeyboardScheme(None, false);

		if (!initialized)
		{
			///*
			#if DISCORD_RPC
			Discord.changePresence('TITLE SCREEN', 'Main Menu');
			#end

			ForeverTools.resetMenuMusic(false);
			initialized = true;
		}

		super.create();

		textDisplay = new FlxText(0, 0, 0, "", 24);
		textDisplay.alignment = CENTER;
		textDisplay.setFormat(Paths.font("lato_bold.ttf"), 24, OUTLINE, 0xFF000000);
		textDisplay.alpha = 0;
		textDisplay.screenCenter();
		add(textDisplay);

		title = new FlxSprite();
		title.frames = Paths.getSparrowAtlas('menus/base/title/logoBumpin');
		title.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		title.alpha = 0;
		title.active = false;
		title.animation.play('bump');
		title.scale.set(0.7, 0.7);
		title.updateHitbox();
		title.screenCenter();
		add(title);

		Conductor.changeBPM(50);

		new FlxTimer().start(2, appearText);
	}

	public var proceed:Bool = false;
	public var repetition:Int = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (controls.ACCEPT)
		{
			if (proceed)
			{
				proceed = false;

				FlxG.sound.play(Paths.sound('scrollMenu'));

				new FlxTimer().start(1.5, function(tmr:FlxTimer)
				{
					Main.switchState(this, new NewMainMenuState());
				});
			}
			else if (++repetition > 3)
			{
				proceed = true;
				FlxG.sound.music.time = 9000;

				nameList = [];

				FlxTween.cancelTweensOf(textDisplay);
				appearText(null);
			}
		}

		super.update(elapsed);
	}

	public function appearText(tmr:FlxTimer):Void
	{
		if (textDisplay.text.length > 0)
		{
			FlxTween.tween(textDisplay, {alpha: 0.0}, 1.0, {
				ease: FlxEase.quartOut,
				onComplete: function(twn:FlxTween)
				{
					textDisplay.text = "";
					appearText(null);
				}
			});
		}
		else if (nameList.length <= 0)
		{
			title.active = true;
			proceed = true;
			FlxTween.tween(title, {alpha: 1.0}, 3.5);
		}
		else
		{
			var list:String = nameList.shift();

			textDisplay.text = list;

			FlxTween.tween(textDisplay, {alpha: 1.0}, 1.5, {
				ease: FlxEase.quartInOut,
				onComplete: function(twn:FlxTween)
				{
					new FlxTimer().start(3.5, appearText);
				}
			});
		}

		textDisplay.screenCenter();
	}

	override function beatHit()
	{
		title.animation.play('bump', true);

		super.beatHit();
	}
}
