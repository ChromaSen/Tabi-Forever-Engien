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
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gameObjects.userInterface.menu.MainMenuItem;
import meta.MusicBeat.MusicBeatState;
import meta.data.Song;
import meta.data.dependency.Discord;
import meta.subState.FreeplaySubstate;

using StringTools;

class NewMainMenuState extends MusicBeatState
{
	public static var camHUD:FlxCamera;
	public static var freeplayHUD:FlxCamera;

	public static var freeplayMenu:FreeplaySubstate;

	public static final menuPath:String = 'menus/main/';
	public static final itemPath:String = 'menus/main/menu/';

	public var vignette:FlxSprite;

	public var board:FlxSprite;
	public var strings:FlxSprite;

	private var menuItems:Array<MainMenuItem> = [];
	private var menuItemsSprite:Array<String> = ["chap1", "freeplay", "easy", "normal", "hard"];

	private var diffItems:Array<MainMenuItem> = [];

	private var curSelected:Int = -1;
	private var curDiff:Int = 2;

	public var camFollow:FlxObject;

	override function create()
	{
		FlxG.camera.zoom = 0.6;

		super.create();

		ForeverTools.resetMenuMusic();

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		freeplayHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(freeplayHUD, false);

		FlxG.mouse.visible = true;

		// preload
		freeplayMenu = new FreeplaySubstate();
		freeplayMenu.camera = freeplayHUD;
		openSubState(freeplayMenu);
		freeplayMenu.exists = false;

		persistentUpdate = true;

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
			var menuItem:MainMenuItem = new MainMenuItem();
			menuItem.frames = Paths.getSparrowAtlas(itemPath + menuItemsSprite[i]);
			menuItem.ID = i;

			menuItem.animation.addByPrefix("idle", "idle", 1, false);
			menuItem.animation.addByPrefix("hover", "hover", 1, false);
			menuItem.animation.addByPrefix("select", "select", 1, false);

			menuItem.animation.play("idle");

			menuItem.screenCenter();

			menuItem.onAway = function()
			{
				if (menuItem.animation.curAnim.name != 'select')
					menuItem.animation.play("idle");
			};

			menuItem.onClick = function()
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				menuItem.animation.play("select");
			};

			menuItem.onOverlap = function()
			{
				if (menuItem.animation.curAnim.name != 'select')
					menuItem.animation.play("hover");
			}

			switch (menuItemsSprite[i])
			{
				case "options":
					menuItem.setPosition(-326, 130);
				case "chap1":
					menuItem.setPosition(-440.5, -268.5);
					menuItem.animation.play("idle");
					menuItem.onClick = function()
					{
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
						clickSpriteWithOffset(menuItem);

						persistentUpdate = false;

						FlxG.sound.music.fadeOut(0.5, 0);

						// silently skipping args here
						FlxG.camera.fade(0xFF000000, 4.0, false, function()
						{
							// fuck off
							PlayState.storyPlaylist = ['my-battle', 'last-chance', 'genocide'];
							PlayState.isStoryMode = true;

							var diffic:String = '-' + CoolUtil.difficultyFromNumber(curDiff).toLowerCase();
							diffic = diffic.replace('-normal', '');

							PlayState.storyDifficulty = curDiff;

							PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
							PlayState.storyWeek = 0;
							PlayState.campaignScore = 0;
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								Main.switchState(this, new PlayState());
							});
						});
					}
				case "freeplay":
					menuItem.setPosition(18.5, 427.5);
					menuItem.onClick = function()
					{
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
						clickSpriteWithOffset(menuItem);

						persistentUpdate = false;

						freeplayMenu.exists = true;
					}
				case "easy":
					menuItem.setPosition(99.5, -187);
					menuItem.ID = 0;
					menuItem.onClick = selectDiff.bind(0);
					diffItems.push(menuItem);
				case "normal":
					menuItem.setPosition(376.5, -194);
					menuItem.ID = 1;
					menuItem.onClick = selectDiff.bind(1);
					diffItems.push(menuItem);
				case "hard":
					menuItem.setPosition(609, -170);
					menuItem.ID = 2;
					menuItem.onClick = selectDiff.bind(2);
					diffItems.push(menuItem);

					menuItem.animation.play("select");
				case "LoveWeek":
					menuItem.setPosition(920, 444);
				case "newknife":
					menuItem.setPosition(996.5, 11.5);
			}
			add(menuItem);

			menuItem.hitbox = shrinkToCenter(menuItem.x, menuItem.y, menuItem.width, menuItem.height, 0.75);

			switch (menuItemsSprite[i])
			{
				case "chap1":
					menuItem.hitbox.setPosition(menuItem.x + 90, menuItem.y + 90);
				case "freeplay":
					menuItem.hitbox.y -= 50;
			}

			menuItems.push(menuItem);
		}

		strings = new FlxSprite().loadGraphic(Paths.image(menuPath + 'strings'));
		strings.screenCenter();
		strings.x = -451;
		strings.y = -275;
		add(strings);

		camFollow.screenCenter();

		FlxG.camera.follow(camFollow, LOCKON, 1.0);
	}

	private var interactable:Bool = true;

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

		if (interactable)
		{
			for (i in 0...menuItems.length)
			{
				var overlapCheck:Bool = (FlxG.mouse.x >= menuItems[i].hitbox.x
					&& FlxG.mouse.x <= menuItems[i].hitbox.x + menuItems[i].hitbox.width);
				overlapCheck = overlapCheck
					&& (FlxG.mouse.y >= menuItems[i].hitbox.y && FlxG.mouse.y <= menuItems[i].hitbox.y + menuItems[i].hitbox.height);

				if (curSelected != i)
				{
					if (overlapCheck)
					{
						#if ("haxe" >= "4.3.0")
						if (curSelected != i && menuItems[curSelected]?.onAway != null)
							menuItems[curSelected].onAway();
						#else
						if (curSelected != i && menuItems[curSelected] != null && menuItems[curSelected].onAway != null)
							menuItems[curSelected].onAway();
						#end

						if (menuItems[i].onOverlap != null)
						{
							curSelected = i;
							menuItems[i].onOverlap();

							break;
						}
					}
				}
				else if (curSelected != -1 && !overlapCheck)
				{
					menuItems[i].onAway();
					curSelected = -1;
				}
				else if (!overlapCheck)
				{
					trace((FlxG.mouse.x >= menuItems[i].hitbox.x && FlxG.mouse.x <= menuItems[i].hitbox.x + menuItems[i].hitbox.width));
					trace((FlxG.mouse.y >= menuItems[i].hitbox.y && FlxG.mouse.y <= menuItems[i].hitbox.y + menuItems[i].hitbox.height));
				}
			}

			if (FlxG.mouse.justPressed && menuItems[curSelected]?.onClick != null)
				menuItems[curSelected].onClick();
		}

		if (FlxG.keys.justPressed.SEVEN)
			Main.switchState(this, new meta.state.menus.MainMenuState());

		super.update(elapsed);
	}

	private function shrinkToCenter(x:Float, y:Float, width:Float, height:Float, scale:Float):FlxRect
	{
		var newWidth:Float = Math.round(width * scale);
		var newHeight:Float = Math.round(height * scale);

		var newX:Float = x + (width - newWidth) / 2;
		var newY:Float = y + (height - newHeight) / 2;

		return FlxRect.get(newX, newY, newWidth, newHeight);
	}

	private function selectDiff(diff:Int = -1)
	{
		curDiff = diff;

		for (i in 0...diffItems.length)
		{
			if (i == diff)
				diffItems[i].animation.play("select");
			else
				diffItems[i].animation.play("idle");
		}

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	}

	private function clickSpriteWithOffset(spr:MainMenuItem)
	{
		spr.offset.set(3, 3);
		new FlxTimer().start(0.04, function(tmr)
		{
			spr.offset.set();
		});
	}
}
