package tabi.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class ClickableButton extends FlxSprite
{
	public var textButton:FlxText;

	public var currentColor:FlxColor;
	public var inactiveColor:FlxColor;
	public var activeColor:FlxColor;

	public var onPress:Void->Void;

	override public function new(X:Float = 0, Y:Float = 0, Width:Float = 140, Height:Float = 90, Color:FlxColor, ?Text:String, Size:Int = 8,
			EmbeddedFont:Bool = true)
	{
		super(X, Y);

		makeGraphic(Std.int(Width), Std.int(Height), Color);

		textButton = new FlxText(X, Y, Width, Text, Size, EmbeddedFont);
	}

	@:isVar
	public var text(get, set):String;

	function get_text():String
	{
		return textButton.text;
	}

	function set_text(text:String):String
	{
		textButton.text = text;

		return (this.text = text);
	}
}
