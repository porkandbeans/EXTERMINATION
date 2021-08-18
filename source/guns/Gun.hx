package guns;

import flixel.util.FlxTimer;

class Gun{
    public var ammo:Int;
    var _MAX_AMMO:Int;
    var _canShoot:Bool;
    var _empty:Bool;
    var _timer:FlxTimer;

    public function new(){
        _canShoot = true;
        _timer = new FlxTimer();
    }

    public function shoot(x:Float, y:Float, f:Bool){
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
}
