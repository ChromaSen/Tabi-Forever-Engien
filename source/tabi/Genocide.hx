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
				PlayState.uiHUD.healthBar.x = FlxMath.remapToRange(PlayState.health, 2, 4, lastHealthX, 40);

				PlayState.uiHUD.healthBarBG.x = PlayState.uiHUD.healthBar.x - 4;
			}
		}
	}
}
