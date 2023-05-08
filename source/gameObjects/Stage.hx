package gameObjects;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import gameObjects.background.*;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;

using StringTools;
#if ("flixel" >= "4.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end

/**
	This is the stage class. It sets up everything you need for stages in a more organised and clean manner than the
	base game. It's not too bad, just very crowded. I'll be adding stages as a separate
	thing to the weeks, making them not hardcoded to the songs.
**/
class Stage extends FlxTypedGroup<FlxBasic>
{
	var halloweenBG:FNFSprite;
	var phillyCityLights:FlxTypedGroup<FNFSprite>;
	var phillyTrain:FNFSprite;
	var trainSound:FlxSound;

	var sumtable:FNFSprite;
	var bars:FlxSprite;

	public var limo:FNFSprite;

	public var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;

	var fastCar:FNFSprite;

	var upperBoppers:FNFSprite;
	var bottomBoppers:FNFSprite;
	var santa:FNFSprite;

	var bgGirls:BackgroundGirls;

	public var curStage:String;

	var daPixelZoom = PlayState.daPixelZoom;

	public var foreground:FlxTypedGroup<FlxBasic>;

	//
	public var main_overlay:FlxSprite;
	public var main_bg:FlxSprite;

	//
	public var broken_door:FlxSprite;
	public var eye:FlxSprite;


	//date
	public var city:FlxSprite;
	public var restaurant:FlxSprite;
	public var lamp:FlxSprite;
	public var fg:FlxSprite;

	//alley
	public var alley:FlxSprite;
	public var fgalley:FlxSprite;
	public var overlay:FlxSprite;

	//beach
	public var beach_sea:FlxSprite;
	public var sea:FlxSprite;

	public function new(curStage)
	{
		super();
		this.curStage = curStage;

		/// get hardcoded stage type if chart is fnf style
		if (PlayState.determinedChartType == "FNF")
		{
			// this is because I want to avoid editing the fnf chart type
			// custom stage stuffs will come with forever charts
			switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()))
			{
				case 'my-battle' | 'last-chance':
					curStage = 'tabi';
				case 'genocide':
					curStage = 'genocide';
				default:
					curStage = 'stage';
			}

			PlayState.curStage = curStage;
		}

		// to apply to foreground use foreground.add(); instead of add();
		foreground = new FlxTypedGroup<FlxBasic>();

		bars = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/bars'));
		bars.antialiasing = false;
		bars.updateHitbox();
		bars.screenCenter();
		bars.visible=false;
		bars.cameras = [PlayState.barHUD];
		add(bars);

		//
		switch (curStage)
		{

			case 'beach':
				PlayState.defaultCamZoom=1.15;
				bars.visible=true;
				sea=new FlxSprite().loadGraphic(Paths.image("backgrounds/BEACH/anpther/sea"));
				sea.antialiasing=false;
				sea.screenCenter();
				add(sea);

			case 'alley':

				PlayState.defaultCamZoom=0.78;

				alley=new FlxSprite().loadGraphic(Paths.image("backgrounds/alley/Alley"));
				alley.antialiasing=false;
				alley.screenCenter();
				alley.scale.set(0.77,0.77);
				add(alley);

				fgalley = new FlxSprite().loadGraphic(Paths.image("backgrounds/alley/alley forground"));
				fgalley.antialiasing = false;
				fgalley.screenCenter();
				fgalley.scale.set(0.77, 0.77);
				add(fgalley);
				
			case 'date':
				PlayState.defaultCamZoom=0.6;
				city=new FlxSprite().loadGraphic(Paths.image("backgrounds/RESTAURANT/restruant city"));
				city.antialiasing=false;
				city.screenCenter();
				add(city);

				restaurant=new FlxSprite().loadGraphic(Paths.image("backgrounds/RESTAURANT/restruant stage"));
				restaurant.antialiasing=false;
				restaurant.screenCenter();
				add(restaurant);

				lamp=new FlxSprite().loadGraphic(Paths.image("backgrounds/RESTAURANT/restruant lamp"));

				lamp.antialiasing=false;
				lamp.screenCenter();
				add(lamp);

				fg=new FlxSprite().loadGraphic(Paths.image("backgrounds/RESTAURANT/restruant forground"));
				fg.antialiasing=false;
				fg.screenCenter();
				foreground.add(fg);

			case 'idfk':
				PlayState.defaultCamZoom=1.1;


				/*
				main_overlay = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/idfk/MAIN_overlay'));
				main_overlay.antialiasing=false;
				main_overlay.updateHitbox();
				main_overlay.screenCenter();
				main_overlay.cameras=[PlayState.camHUD];
					add(main_overlay);
				It's not transparent, fuck
				*/
			
				main_bg=new FlxSprite(0,0);
				main_bg.frames=Paths.getSparrowAtlas('backgrounds/idfk/Main_BG');
				main_bg.animation.addByPrefix('idle', 'MAIN BG образец', 24);
				main_bg.animation.play('idle',true);

				add(main_bg);
			case 'genocide':
				PlayState.defaultCamZoom = 0.8;
				bars.visible=true;

				var genocideBG:FNFSprite = new FNFSprite(-600, 300).loadGraphic(Paths.image('backgrounds/' + curStage + '/youhavebeendestroyed'));
				genocideBG.scale.set(0.95, 0.95);
				add(genocideBG);

				var genocideBoard:FNFSprite = new FNFSprite(-600, 300).loadGraphic(Paths.image('backgrounds/' + curStage + '/glowyfurniture'));
				genocideBoard.scale.set(0.975, 0.975);

				var sumtable:FNFSprite = new FNFSprite(-600, 300).loadGraphic(Paths.image('backgrounds/' + curStage + '/overlayingsticks'));
				sumtable.scale.set(0.975, 0.975);
				foreground.add(sumtable);

				add(genocideBG);

				var fire1:FNFSprite = new FNFSprite(-600, 400);
				fire1.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/newfireglow');
				fire1.animation.addByPrefix('idle', "FireStage", 24);
				fire1.animation.play('idle');
				fire1.scrollFactor.set(0.9, 0.9);
				fire1.scale.set(1.5, 1.5);
				fire1.updateHitbox();

				add(fire1);

				var fire2:FNFSprite = new FNFSprite(fire1.x + fire1.width - 80, 400);
				fire2.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/newfireglow');
				fire2.animation.addByPrefix('idle', "FireStage", 24);
				fire2.animation.play('idle');
				fire2.scrollFactor.set(0.9, 0.9);
				fire2.scale.set(1.5, 1.5);
				fire2.updateHitbox();
				fire2.flipX = true;
				add(fire2);

				add(genocideBoard);

				var boombox:FNFSprite = new FNFSprite(-600, 200).loadGraphic(Paths.image('backgrounds/' + curStage + '/Destroyed_boombox'));
				boombox.scale.set(0.9, 0.9);
				add(boombox);
			case 'tabi':
				PlayState.defaultCamZoom = 0.6;
				bars.visible=true;

				var normal_stage:FNFSprite = new FNFSprite(-510, 230).loadGraphic(Paths.image('backgrounds/' + curStage + '/normal_stage'));
				add(normal_stage);

				sumtable = new FNFSprite(-510, 230).loadGraphic(Paths.image('backgrounds/' + curStage + '/sumtable'));
				foreground.add(sumtable);
			default:
				PlayState.defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FNFSprite = new FNFSprite(-600, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;

				// add to the final array
				add(bg);

				var stageFront:FNFSprite = new FNFSprite(-650, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;

				// add to the final array
				add(stageFront);

				var stageCurtains:FNFSprite = new FNFSprite(-500, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				// add to the final array
				add(stageCurtains);
		}
	}

	// return the girlfriend's type
	public function returnGFtype(curStage)
	{
		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'tabi':
				gfVersion = 'gf-tabi';
			case 'genocide':
				gfVersion = 'gf-exp';
		}

		return gfVersion;
	}

	// get the dad's position
	public function dadPosition(curStage, boyfriend:Character, dad:Character, gf:Character, camPos:FlxPoint):Void
	{
		var characterArray:Array<Character> = [dad, boyfriend];
		for (char in characterArray)
		{
			switch (char.curCharacter)
			{
				case 'gf':
					char.setPosition(gf.x, gf.y);
					gf.visible = false;
				/*
					if (isStoryMode)
					{
						camPos.x += 600;
						tweenCamIn();
				}*/
				/*
					case 'spirit':
						var evilTrail = new FlxTrail(char, null, 4, 24, 0.3, 0.069);
						evilTrail.changeValuesEnabled(false, false, false, false);
						add(evilTrail);
				 */

				case 'tabi':
					boyfriend.x = 1000;
					boyfriend.y = 870;
					gf.x = 430;
					gf.y = 500;
					dad.setPosition(0,450);
				case 'tabi-crazy':
					boyfriend.x = 950;
					boyfriend.y = 900;
					gf.x = 750;
					gf.y = 840;
					dad.x = 0;
					dad.y = 600;
				case 'dd':
					gf.visible=false;
					boyfriend.x=120;
					boyfriend.y=315;
					dad.x=700;
					dad.y=237;
				case 'tabidate':
					gf.visible=false;
					boyfriend.setPosition(140,188);
					dad.setPosition(665,278.2);
				case 'tabi-skelet':
					gf.visible=false;
					dad.visible=false;
					boyfriend.setPosition(180,95);
					boyfriend.scale.set(0.9, 0.9);
				case 'tabi-gf-beach':
					dad.visible=false;
					gf.visible=false;
					boyfriend.setPosition(250,170);
					
			}
		}
	}

	public function repositionPlayers(curStage, boyfriend:Character, dad:Character, gf:Character):Void
	{
		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'highway':
				boyfriend.y -= 220;
				boyfriend.x += 260;

			case 'mall':
				boyfriend.x += 200;
				dad.x -= 400;
				dad.y += 20;

			case 'mallEvil':
				boyfriend.x += 320;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				dad.x += 200;
				dad.y += 580;
				gf.x += 200;
				gf.y += 320;
			case 'schoolEvil':
				dad.x -= 150;
				dad.y += 50;
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
		}
	}

	var curLight:Int = 0;
	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var startedMoving:Bool = false;

	public function stageUpdate(curBeat:Int, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		// trace('update backgrounds');
		switch (PlayState.curStage)
		{
			case 'highway':
				// trace('highway update');
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});
			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'school':
				bgGirls.dance();

			case 'philly':
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					var lastLight:FlxSprite = phillyCityLights.members[0];

					phillyCityLights.forEach(function(light:FNFSprite)
					{
						// Take note of the previous light
						if (light.visible == true)
							lastLight = light;

						light.visible = false;
					});

					// To prevent duplicate lights, iterate until you get a matching light
					while (lastLight == phillyCityLights.members[curLight])
					{
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
					}

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;

					FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, Conductor.stepCrochet * .016);
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}
	}

	public function stageUpdateConstant(elapsed:Float, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		switch (PlayState.curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos(gf);
						trainFrameTiming = 0;
					}
				}
		}
	}

	// PHILLY STUFFS!
	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	function updateTrainPos(gf:Character):Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset(gf);
		}
	}

	function trainReset(gf:Character):Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Init.trueSettings.get('Disable Antialiasing') && Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = false;
		return super.add(Object);
	}
}
