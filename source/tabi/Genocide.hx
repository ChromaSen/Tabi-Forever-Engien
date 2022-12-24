package tabi;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import meta.state.PlayState;
import gameObjects.Character;
import gameObjects.userInterface.notes.Note;
import tabi.utils.Perlin;

class Genocide extends SongEvents
{
	var lastHealthX:Float = 0;
	var lastHealthY:Float = 0;

	var perlinNoise:Perlin;
	var darkSpr:FlxSprite;

	override public function create(post:Bool)
	{
		if (post)
		{
			perlinNoise = new Perlin();

			PlayState.health = 2;

			PlayState.instance.isGenocide = true;
			@:privateAccess
			{
				lastHealthX = PlayState.uiHUD.healthBar.x;
				lastHealthY = PlayState.uiHUD.healthBar.y;
			}
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
}
