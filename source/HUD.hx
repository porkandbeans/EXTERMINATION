package;

/*import flixel.util.FlxColor;
import flixel.tweens.misc.ColorTween;
import flixel.ui.FlxBar;*/
import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;

class HUD extends FlxTypedGroup<FlxSprite>{
    //var _floatyBar:FlxBar;
    //var _floatPower:Float;
    var _pistolAmmo:Int;
    var _current_wep:Int;

    var _ammoText:FlxText;
    var _gun:FlxText;

    var _pauseTxt:FlxText;
    var _pauseSound:FlxSound;

    public function new(){
		super();

        _current_wep = 0;
        _gun = new FlxText(0,2,0, "0", 8);
        add(_gun);
        
        _ammoText = new FlxText(FlxG.width - 20, 0, 20, "0", 8);
        add(_ammoText);

        _pauseTxt = new FlxText(FlxG.width / 2, FlxG.height / 2, 0, "PAUSE", 20);
        _pauseTxt.screenCenter();
        add(_pauseTxt);
        _pauseTxt.visible = false;

        _pauseSound = FlxG.sound.load("assets/sounds/sound_effects/ui/pause.wav");
        
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

        super.update(elapsed);
    }

    public function updateGun(gun:Int, ammo:Int){
        _current_wep = gun;
        switch(_current_wep){
            case 0:
                _gun.text = "Knife";
                _ammoText.visible = false;
                return;
            case 1:
                _gun.text = "Pistol";
                _ammoText.visible = true;
                _ammoText.text = Std.string(ammo);
                return;
            case 2:
                _gun.text = "Rifle";
                _ammoText.visible = true;
                _ammoText.text = Std.string(ammo);
                return;
        }
    }

    public function pauseGame(){
        _pauseTxt.visible = !_pauseTxt.visible;
        _pauseSound.play(true);
    }
}