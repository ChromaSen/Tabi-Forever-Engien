package tabi;

import flixel.math.FlxMath;
import meta.state.PlayState;

class Genocide extends SongEvents
{
	var lastHealthX:Float = 0;

	override public function create(post:Bool)
	{
		if (post)
		{
			PlayState.health = 2;

			PlayState.instance.isGenocide = true;
			@:privateAccess
			lastHealthX = PlayState.uiHUD.healthBar.x;
		}
	}

	override public function update(elapsed:Float, post:Bool)
	{
		if (post)
		{
			@:privateAccess
			{
				var healthBar = PlayState.uiHUD.healthBar;
				healthBar.x = FlxMath.remapToRange(PlayState.health, 2, 4, lastHealthX, healthBar.x);

				PlayState.uiHUD.healthBarBG.x = healthBar.x - 4;
			}
		}
	}
}
