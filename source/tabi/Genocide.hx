package tabi;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.effects.FlxTrail;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import gameObjects.Character;
import gameObjects.userInterface.notes.Note;
import meta.state.PlayState;
import tabi.utils.Perlin;

class Genocide extends SongEvents
{
	var lastHealthX:Float = 0;
	var lastHealthY:Float = 0;

	var perlinNoise:Perlin;
	var vignette:FlxSprite;

	override public function create(post:Bool)
	{
		if (post)
		{
			perlinNoise = new Perlin();

			var tabiTrail = new FlxTrail(PlayState.dadOpponent, null, 2, 16, 0.6, 0.9);
			PlayState.instance.add(tabiTrail);
			PlayState.health = 2;

			PlayState.instance.isGenocide = true;
			@:privateAccess
			{
				lastHealthX = PlayState.uiHUD.healthBar.x;
				lastHealthY = PlayState.uiHUD.healthBar.y;
			}
		}

		if (post)
		{
			vignette = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + PlayState.curStage + '/vignette'));
			vignette.antialiasing = false;
			vignette.updateHitbox();
			vignette.screenCenter();
			vignette.cameras = [PlayState.camHUD];
			vignette.alpha = 0;
			PlayState.instance.add(vignette);
		}
	}

	override public function update(elapsed:Float, post:Bool)
	{
		if (post)
		{
			if (PlayState.health >= 2)
				PlayState.health -= elapsed / 6;

			@:privateAccess
			{
				PlayState.uiHUD.healthBar.x = FlxMath.remapToRange(Math.max(PlayState.health, 2), 2, 4, lastHealthX, 40);
				PlayState.uiHUD.healthBar.y = lastHealthY;

				if (PlayState.health >= 2)
				{
					var shakeAggression:Float = FlxMath.remapToRange(PlayState.health, 2, 4, 0, 5);

					PlayState.uiHUD.healthBar.x += FlxG.random.float(shakeAggression, shakeAggression * (4 * Math.random())) * FlxG.random.sign();
					PlayState.uiHUD.healthBar.y += FlxG.random.float(shakeAggression, shakeAggression * (4 * Math.random())) * FlxG.random.sign();
				}

				PlayState.uiHUD.healthBar.x += FlxG.random.float(5, 20);

				PlayState.uiHUD.healthBarBG.setPosition(PlayState.uiHUD.healthBar.x - 4, PlayState.uiHUD.healthBar.y - 4);

				vignette.alpha = FlxMath.remapToRange(PlayState.health, 0, 4, 1, 0);
			}
		}
	}

	override public function opponentNoteHit(note:Note, char:Character)
	{
		if (!note.isSustainNote)
		{
			if (PlayState.health * 100 >= 2.5)
			{
				PlayState.health -= 6.5 / 100;
				if (PlayState.health <= 0)
					PlayState.health = 2.5;
			}
		}
	}

	override public function beatHit(curBeat:Int){
		switch (curBeat)
		{
			case 416:FlxTween.tween(FlxG.camera, {zoom: 1.4}, 2);
			case 424:PlayState.zoomHit=true;
			case 456:FlxTween.tween(FlxG.camera, {zoom: 1.1}, 4.2);	
			case 488:PlayState.zoomHit=false; FlxTween.tween(FlxG.camera, {zoom: 1.6}, 4.5);	
		}
	}
}
