package playstates.tutorial_assets;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Tutorial_target extends FlxSprite
{
	var _nextPoint:FlxPoint;
	var _target_num:Int;

	public function new(x:Float, y:Float, num:Int)
	{
		super(x, y);
		loadGraphic("assets/images/misc/target.png");
		_target_num = num;
	}

	public function advanceTutorial()
	{
		return _nextPoint;
	}

	public function setPoint(point:FlxPoint)
	{
		_nextPoint = point;
	}
	public function getNum():Int
	{
		return _target_num;
	}
}