package meta.state.menus;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.MusicBeat.MusicBeatState;
import meta.data.dependency.Discord;

class NewMainMenuState extends MusicBeatState
{
	public static final menuPath:String = 'menus/main/';

	public var board:FlxSprite;

	public var camFollow:FlxObject;

	override function create()
	{
		super.create();

		FlxG.mouse.visible = true;

		camFollow = new FlxObject(0, 0, 1, 1);

		board = new FlxSprite().loadGraphic(Paths.image(menuPath + 'board'));
		board.screenCenter();
		board.y += 120;
		add(board);

		camFollow.screenCenter();
        
		FlxG.camera.follow(camFollow, LOCKON, 1.0);
		FlxG.camera.zoom = 0.6;
	}

	public override function update(elapsed:Float)
	{
		camFollow.setPosition(FlxMath.remapToRange(FlxG.mouse.screenX, 0, FlxG.width, (FlxG.width / 2) + 16, (FlxG.width / 2) - 16), 
			FlxMath.remapToRange(FlxG.mouse.screenY, 0, FlxG.height, (FlxG.height / 2) + 16, (FlxG.height / 2) - 16));

		super.update(elapsed);
	}
}
