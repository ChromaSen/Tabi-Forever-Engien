package tabi.scene;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import meta.state.PlayState;
import openfl.Assets;
import sys.FileSystem;

using StringTools;

#if ("flixel" >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end

typedef DialogueInfo =
{
	var char:String;
	var expression:String;
	var frame:Int;
	var text:String;
	var speechRef:String;
}

enum abstract CharacterEffects(Int)
{
	var MINOR_SHAKE:CharacterEffects = 0;

	@:from
	static public function fromString(s:String)
	{
		return switch (s)
		{
			case "minor_shake":
				MINOR_SHAKE;
			case _:
				null;
		};
	}
}

class Dialogue extends FlxTypedGroup<FlxSprite>
{
	public var song:String = '';
	public var dialogueList:Array<DialogueInfo> = [];

	public var backframe:FlxSprite;
	public var bubble:FlxSprite;

	public var characters:Map<String, FlxSprite> = [];
	public var speech:FlxTypeText;

	public var currentSpeech:FlxSound;

	public var finishCallback:Void->Void;

	override public function new(?song:String = '')
	{
		super();

		this.song = song;
		this.camera = PlayState.dialogueHUD;

		backframe = new FlxSprite();

		trace('dialogue $song');

		switch (song)
		{
			case 'my-battle':
				addCharToList("bf");
				addCharToList("gf");
				addCharToList("tabi");

				camera.fade(FlxColor.BLACK, 1.5, true, function()
				{
					canControl = true;
					startDialogue();
				});
			default:
				trace(song);
		}
	}

	private var finishedSpeech:Bool = false;
	private var canControl:Bool = false;

	override public function update(elapsed:Float)
	{
		if (canControl && FlxG.keys.anyJustPressed([SPACE, ENTER]))
			nextDialogue();

		super.update(elapsed);
	}

	private function startDialogue():Void
	{
		nextDialogue();
	}

	private function nextDialogue():Void
	{
		if (finishedSpeech)
		{
			dialogueList.shift();

			if (dialogueList.length == 0)
				finishDialogue();
		}
		else {}
	}

	private function finishDialogue():Void
	{
		FlxTween.tween(camera, {alpha: 0.0}, 2.5, {
			ease: FlxEase.quadOut,
			onComplete: function(twn:FlxTween)
			{
				new FlxTimer().start(1.0, function(tmr:FlxTimer)
				{
					if (finishCallback != null)
						finishCallback();
				});
			}
		});
	}

	private function addCharToList(char:String)
	{
		var newChar:FlxSprite = new FlxSprite();
		newChar.frames = Paths.getSparrowAtlas('tabi/dialogue/portraits/$char/$char');
		newChar.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		newChar.active = newChar.visible = false;

		var exprList:Array<String> = Assets.getText(Paths.getPath('images/tabi/dialogue/portraits/$char/expr.txt', TEXT)).split('\n');

		for (expr in exprList)
		{
			newChar.animation.addByPrefix(expr, expr, 1);
		}

		add(newChar);
		characters.set(char, newChar);
	}
}
