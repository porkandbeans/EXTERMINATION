package guns;

import flixel.util.FlxTimer;
import flixel.group.FlxGroup;

class Pistol extends Gun{
    var _bullets:FlxTypedGroup<Bullet>;
    var _canShoot:Bool;

    public function new(bullets:FlxTypedGroup<Bullet>){
        MAX_AMMO = 36;
        ammo = 12;
        _bullets = bullets;
        _canShoot = true;
    }

    override public function shoot(x:Float, y:Float, f:Bool){
        if(_canShoot){
            _canShoot = false;
            new FlxTimer().start(0.4, doneShooting, 1);
            if(f){
                _bullets.recycle(Bullet.new).shoot(x, y, -240);
            }else{
                _bullets.recycle(Bullet.new).shoot(x, y, 240);
            }
        }
    }

    function doneShooting(timer:FlxTimer){
        _canShoot = true;
    }
}