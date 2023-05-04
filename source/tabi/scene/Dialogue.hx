package tabi.scene;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import meta.state.PlayState;
import sys.FileSystem;

using StringTools;

#if ("flixel" >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end

class Dialogue extends FlxTypedGroup<FlxSprite>
{
	public var song:String = '';
	public var dialogueList:Array<DialogueInfo> = [];

	public var backframe:FlxSprite;
    public var overlay:FlxSprite;

	public var characters:Map<String, Map<String, FlxSprite>> = [];
	public var speech:FlxTypeText;

    public var currentSpeech:FlxSound;

	public var finishCallback:Void->Void;

	override public function new(?song:String = '', opaque:Bool = false)
	{
		super();

		this.song = song;

		this.camera = PlayState.dialogueHUD;

		switch (song) 
		{

		}
	}

	private var finishedSpeech:Bool = false;
	private var canControl:Bool = false;

	override public function update(elapsed:Float)
	{
		if (canControl && FlxG.keys.anyJustPressed([SPACE, ENTER]))
		{
			if (finishedSpeech)
			{
				dialogueList.shift();

				if (dialogueList.length < 0) {}
			}
            else
            {
                
            }
		}

		super.update(elapsed);
	}

	private function addCharToList(char:String)
	{
		var path:String = Paths.getPath("images/dialogue/tabi/chars/", IMAGE);

		// how many times have i used this goddamn FileSystem
		for (expression in FileSystem.readDirectory(path + char)) 
        {

        }
	}
}

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
}
