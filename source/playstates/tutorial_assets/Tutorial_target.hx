package playstates.tutorial_assets;

import flixel.FlxSprite;

class Tutorial_target extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		loadGraphic("assets/images/misc/target.png");
	}
}