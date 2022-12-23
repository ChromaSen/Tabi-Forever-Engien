package tabi;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import meta.state.PlayState;

class LastChance extends SongEvents
{
	var vignette:FlxSprite;

	override public function create(post:Bool)
	{
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

	override public function beatHit(beat:Int)
	{
		switch (beat)
		{
			case 1:
				FlxTween.tween(FlxG.camera, {zoom: 0.8}, 10);
			case 96:
				FlxG.camera.flash(FlxColor.WHITE, 0.5, false);
				PlayState.defaultCamZoom = 0.7;
				PlayState.uiHUD.iconBeat = 2;
			case 160:
				FlxG.camera.flash(FlxColor.WHITE, 0.5, false);
				PlayState.defaultCamZoom = 0.6;
			case 224:
				FlxTween.tween(FlxG.camera, {zoom: 0.8}, 10);
				FlxG.camera.flash(FlxColor.WHITE, 0.5, false);
				PlayState.uiHUD.iconBeat = 1;
			case 256:
				FlxG.camera.flash(FlxColor.WHITE, 0.5, false);
			case 321:
				FlxTween.tween(vignette, {alpha: 0.5}, 20, {ease: FlxEase.circOut});
		}
	}
}
