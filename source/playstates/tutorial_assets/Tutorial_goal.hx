package playstates.tutorial_assets;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Tutorial_goal extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);
		makeGraphic(16, 16, FlxColor.TRANSPARENT);
	}
}