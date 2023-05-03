package gameObjects.userInterface.menu;

import flixel.FlxSprite;
import flixel.math.FlxRect;

class MainMenuItem extends FlxSprite
{
    public var onOverlap:Void->Void;
    public var onClick:Void->Void;
    public var onAway:Void->Void;

    public var hitbox:FlxRect;
}