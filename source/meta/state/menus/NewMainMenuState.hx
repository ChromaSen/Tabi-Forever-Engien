package meta.state.menus;

import flixel.FlxCamera;
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
	public static var camHUD:FlxCamera;

	public static final menuPath:String = 'menus/main/';

	public var vignette:FlxSprite;

	public var board:FlxSprite;
	public var strings:FlxSprite;
	public var menuItem:FlxSprite;

	private var menuItems:Array<FlxSprite> = [];
	private var menuItemsSprite:Array<String> = ["OPTIONS", "CHAP1", "FREEPLAY", "EASY", "NORMAL", "HARD", "LoveWeek", "newknife"];

	public var camFollow:FlxObject;

	override function create()
	{
		FlxG.camera.zoom = 0.6;

		super.create();

		ForeverTools.resetMenuMusic();

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.add(camHUD, false);

		FlxG.mouse.visible = true;

		camFollow = new FlxObject(0, 0, 1, 1);

		vignette = new FlxSprite().loadGraphic(Paths.image("backgrounds/genocide/vignette"));
		vignette.screenCenter();
		vignette.cameras = [camHUD];
		vignette.alpha = 0.7;
		add(vignette);

		board = new FlxSprite().loadGraphic(Paths.image(menuPath + 'board'));
		board.screenCenter();
		board.x = -451;
		board.y = -275;
		add(board);

		for (i in 0...menuItemsSprite.length)
		{
			menuItem = new FlxSprite().loadGraphic(Paths.image('menus/main/menu/' + menuItemsSprite[i]));
			menuItem.screenCenter();
			switch (menuItemsSprite[i])
			{
				case "OPTIONS":
					menuItem.setPosition(-326, 130);
				case "CHAP1":
					menuItem.setPosition(-440.5, -268.5);
				case "FREEPLAY":
					menuItem.setPosition(18.5, 427.5);
				case "EASY":
					menuItem.setPosition(99.5, -187);
				case "NORMAL":
					menuItem.setPosition(376.5, -194);
				case "HARD":
					menuItem.setPosition(609, -170);
				case "LoveWeek":
					menuItem.setPosition(920, 444);
				case "newknife":
					menuItem.setPosition(996.5, 11.5);
			}
			menuItems.push(menuItem);
		}

		for (menu in menuItems)
			add(menu);

		strings = new FlxSprite().loadGraphic(Paths.image(menuPath + 'strings'));
		strings.screenCenter();
		strings.x = -451;
		strings.y = -275;
		add(strings);

		camFollow.screenCenter();

		FlxG.camera.follow(camFollow, LOCKON, 1.0);
	}

	private var _total:Float = 0.0;

	public override function update(elapsed:Float)
	{
		#if debug
		var positions:Array<Array<Float>> = [];

		for (shit in menuItems)
		{
			positions.push([shit.x, shit.y]);
		}

		for (i in 0...menuItemsSprite.length)
		{
			FlxG.watch.addQuick(menuItemsSprite[i] + " x and y", positions[i]);
		}
		#end

		camFollow.setPosition(FlxMath.lerp(camFollow.x, FlxMath.remapToRange(FlxG.mouse.screenX, 0, FlxG.width, (FlxG.width / 2) + 16, (FlxG.width / 2) - 16),
			3.5 * elapsed),
			FlxMath.lerp(camFollow.y, FlxMath.remapToRange(FlxG.mouse.screenY, 0, FlxG.height, (FlxG.height / 2) + 16, (FlxG.height / 2) - 16),
				3.5 * elapsed));

		// using modulo for choppy easing
		_total += elapsed;

		if (Math.floor(_total / 200) % 300 == 0)
			vignette.alpha = Math.sin(_total) * 0.7;

		if (FlxG.keys.justPressed.SEVEN)
			Main.switchState(this, new meta.state.menus.MainMenuState());

		super.update(elapsed);
	}
}
