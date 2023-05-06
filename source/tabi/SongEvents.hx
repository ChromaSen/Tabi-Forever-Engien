package tabi;

import gameObjects.Character;
import gameObjects.userInterface.notes.Note;

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

	@:keep
	public function goodNoteHit(note:Note, char:Character):Void {}

	@:keep
	public function opponentNoteHit(note:Note, char:Character):Void {}

	@:keep
	public function new() {}
}
