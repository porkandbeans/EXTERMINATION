package guns;

import flixel.util.FlxTimer;
import flixel.group.FlxGroup;

class Pistol extends Gun{
    var _bullets:FlxTypedGroup<Bullet>;

    public function new(bullets:FlxTypedGroup<Bullet>){
        super();
        _MAX_AMMO = 36;
        ammo = 12;
        _bullets = bullets;
        _canShoot = true;
    }

    override public function shoot(x:Float, y:Float, f:Bool){
        super.shoot(x, y, f);
        if(_canShoot && !_empty){
            _canShoot = false;
            ammo--;
            _timer.start(0.4, doneShooting, 1);
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