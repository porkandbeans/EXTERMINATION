package playstates.tutorial_assets;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Tutorial_target extends FlxSprite
{
	var _nextPoint:FlxPoint;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		loadGraphic("assets/images/misc/target.png");
	}

	public function advanceTutorial()
	{
		return _nextPoint;
	}

	public function setPoint(point:FlxPoint)
	{
		_nextPoint = point;
	}
}