package tabi;

// internal structure for song events
class SongEvents
{
	@:keep
	function create(post:Bool):Void {}

	@:keep
	function update(elapsed:Float, post:Bool):Void {}

	@:keep
	function beatHit(beat:Int):Void {}

	@:keep
	function stepHit(step:Int):Void {}
}
