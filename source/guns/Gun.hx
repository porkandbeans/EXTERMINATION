package guns;

import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;

class Gun{
    public var ammo:Int;
    var _MAX_AMMO:Int;
    var _canShoot:Bool;
    var _empty:Bool;
    var _timer:FlxTimer;
    var _shot:FlxSound;

    public function new(){
        _canShoot = true;
        _timer = new FlxTimer();
    }

    public function shoot(x:Float, y:Float, f:Bool){
        // declares _empty.
        // the actual can/can't shoot logic is done in the child classes.
        if(ammo <= 0){
            _empty = true;
            return;
        }
    }

    public function addAmmo(i:Int){
        ammo += i;
        _empty = false;
    }

    public function getMaxAmmo():Int{
        return _MAX_AMMO;
    }

    // called by child classes to save importing FlxG all over the place, which I'm assuming is probably bad right?
    function loadSound(file:String){
        _shot = FlxG.sound.load(file);
    }
}
