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

		camFollow = new FlxObject(0, 0, 1, 1);

		board = new FlxSprite().loadGraphic(Paths.image(menuPath + 'board'));
		board.screenCenter();
		add(board);

		camFollow.screenCenter();
        
		FlxG.camera.follow(camFollow, LOCKON, 1.0);
	}

	public override function update(elapsed:Float)
	{
		var lerp:Float = FlxMath.bound(elapsed, 0, 1);
        
		camFollow.setPosition(FlxMath.lerp(camFollow.x, FlxMath.remapToRange(FlxG.mouse.screenX, 0, FlxG.width, board.x, board.width), lerp),
			FlxMath.lerp(camFollow.y, FlxMath.remapToRange(FlxG.mouse.screenY, 0, FlxG.height, board.y, board.height), lerp));

		super.update(elapsed);
	}
}
