package gameObjects.userInterface.menu;

import flixel.FlxG;
import tabi.display.AnimatedSprite;

class MainMenuItem extends AnimatedSprite
{
    public var onOverlap:Void->Void;
    public var onClick:Void->Void;
    public var onAway:Void->Void;
}