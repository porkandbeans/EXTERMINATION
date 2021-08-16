package;

/*import flixel.util.FlxColor;
import flixel.tweens.misc.ColorTween;
import flixel.ui.FlxBar;*/
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;

class HUD extends FlxTypedGroup<FlxSprite>{
    //var _floatyBar:FlxBar;
    //var _floatPower:Float;
    var _gun:FlxText;
    var _current_wep:Int;

    public function new(){
		super();

        _current_wep = 0;
        _gun = new FlxText(0,2,0, "0", 8);
        add(_gun);
        /*_floatyBar = new FlxBar(10, 5, LEFT_TO_RIGHT, (FlxG.width - 20), 20, null, "_floatPower", 0, 100, true);
        _floatyBar.createFilledBar(null, FlxColor.WHITE, true, FlxColor.BLACK);
		_floatyBar.alpha = 0;
        add(_floatyBar);
        */
        forEach(function(sprite) { // ???????
            sprite.scrollFactor.set(0,0);
		}); // ¯\_(ツ)_/¯ if it works, it works.*/
    }

    /*public function updateBar(x:Float){
        _floatPower = x;
    }*/

    override public function update(elapsed:Float){
		/*_floatyBar.value = _floatPower;
		if (_floatPower < 100)
		{
            if (_floatyBar.alpha < 1){
                _floatyBar.alpha += 0.1;
			}
		}
		else
		{
			if (_floatyBar.alpha > 0){
                _floatyBar.alpha -= 0.1;
            }
		}*/

        _gun.text = _current_wep + "";

        super.update(elapsed);
    }

    public function updateGun(gun:Int){
        _current_wep = gun;
    }
}