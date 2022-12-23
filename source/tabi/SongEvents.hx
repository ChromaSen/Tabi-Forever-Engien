package tabi;

// internal structure for song events
abstract class SongEvents
{
	@:keep
	public function create(post:Bool):Void {}

	@:keep
	public function update(elapsed:Float, post:Bool):Void {}

	@:keep
	public function beatHit(beat:Int):Void {}

	@:keep
	public function stepHit(step:Int):Void {}

	// internal constructor

	@:keep
	public function new() {}
}
