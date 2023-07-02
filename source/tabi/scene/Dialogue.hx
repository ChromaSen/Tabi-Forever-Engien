package tabi.scene;

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
import openfl.media.Sound;
import tjson.TJSON;

using StringTools;

#if ("flixel" >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end

typedef DialogueInfo =
{
	var char:String;
	var frame:Int;
	var text:String;
	var speechRef:String;
}

class Dialogue extends FlxTypedGroup<FlxSprite>
{
	private static var __soundCache:Map<String, Sound> = [];

	public var song:String = '';
	public var dialogueList:Array<DialogueInfo> = [
		{
			char: 'bf',
			frame: 0,
			text: 'haha ass shit error missing file',
			speechRef: 'speak-0'
		}
	];

	public var backframe:FlxSprite;
	public var dialogueFrame:FlxSprite;

	public var characters:Map<String, FlxSprite> = [];
	public var speech:FlxTypeText;

	public var currentSpeech:FlxSound;

	public var finishCallback:Void->Void;

	override public function new(?song:String = '')
	{
		super();

		this.song = song;
		this.camera = PlayState.dialogueHUD;

		currentSpeech = new FlxSound();
		FlxG.sound.list.add(currentSpeech);

		backframe = new FlxSprite();
		backframe.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		backframe.makeGraphic(FlxG.width, FlxG.height, FlxColor.PURPLE);
		add(backframe);

		dialogueFrame = new FlxSprite().makeGraphic(FlxG.width, Std.int(FlxG.height * 0.07), FlxColor.BLACK);
		dialogueFrame.y = FlxG.height - dialogueFrame.height;
		dialogueFrame.alpha = 0.6;
		add(dialogueFrame);

		speech = new FlxTypeText(0, 0, Math.floor(FlxG.width * 0.85), "", 16);
		speech.screenCenter(X);
		speech.y = dialogueFrame.y + (dialogueFrame.height / 2) - (speech.height / 2);
		speech.setFormat(Paths.font("lato_bold.ttf"), 22);
		speech.alignment = CENTER;
		add(speech);
		
		if (Assets.exists(Paths.file('data/dialogue/$song.json'))) 
			dialogueList = TJSON.parse(sys.io.File.getContent((Paths.file('data/dialogue/$song.json'))));
		else
			trace(song);

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

		for (list in dialogueList)
		{
			if (!__soundCache.exists(list.speechRef))
			{
				if (Assets.exists(Paths.getPath('sounds/dialogue/$song/${list.speechRef}', SOUND)))
					__soundCache.set(list.speechRef, Paths.sound('dialogue/$song/${list.speechRef}'));
			}
		}
	}

	private var finishedSpeech:Bool = false;
	private var canControl:Bool = false;

	override public function update(elapsed:Float)
	{
		if (canControl && FlxG.keys.anyJustPressed([SPACE, ENTER]))
			nextDialogue();

		speech.size = 22;

		while (speech.height > dialogueFrame.height)
			speech.size--;

		super.update(elapsed);
	}

	private var currentFrame:Int = 0;

	private function startDialogue():Void
	{
		speech.resetText(dialogueList[0].text);
		speech.start(0.04, true);

		if (__soundCache.exists(dialogueList[0].speechRef))
		{
			currentSpeech.loadEmbedded(__soundCache.get(dialogueList[0].speechRef));
			currentSpeech.play();
		}
	}

	private function nextDialogue():Void
	{
		if (finishedSpeech)
		{
			dialogueList.shift();
			
			if (dialogueList.length == 0)
				finishDialogue();
			else
			{
				trace('${dialogueList[0].speechRef}');

				speech.resetText(dialogueList[0].text);
				speech.start(0.04, true);

				if (__soundCache.exists(dialogueList[0].speechRef))
				{
					currentSpeech.loadEmbedded(__soundCache.get(dialogueList[0].speechRef));
					currentSpeech.play();
				}

				if (dialogueList[0].frame != currentFrame)
				{
					switch (dialogueList[0].frame)
					{
						case -1:
							FlxTween.color(backframe, 0.5, 0xFFFFFFFF, 0xFF000000);
					}
					currentFrame = dialogueList[0].frame;
				}
			}
		}
		else
		{
			if (currentSpeech?.playing)
				currentSpeech.stop();

			speech.skip();

			finishedSpeech = true;
		}
	}

	private function finishDialogue():Void
	{
		FlxTween.tween(camera, {alpha: 0.0}, 2.5, {
			ease: FlxEase.quadOut,
			onComplete: function(twn:FlxTween)
			{
				new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					kill();

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

		trace('char $char');
		characters.set(char, newChar);
	}
}
