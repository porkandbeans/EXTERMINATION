package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxBar;

class HUD extends FlxTypedGroup<FlxSprite>{
    var _floatyBar:FlxBar;
    var _floatPower:Float;

    public function new(){
        super();

        _floatyBar = new FlxBar(10, 5, LEFT_TO_RIGHT, (FlxG.width - 20), 20, null, "_floatPower", 0, 100, true);
        add(_floatyBar);
        forEach(function(sprite) { // ???????
            sprite.scrollFactor.set(0,0);
		}); // ¯\_(ツ)_/¯ if it works, it works.
    }

    public function updateBar(x:Float){
        _floatPower = x;
    }

    override public function update(elapsed:Float){
		_floatyBar.value = _floatPower;
        super.update(elapsed);
    }
}