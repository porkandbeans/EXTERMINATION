package guns;

import flixel.util.FlxTimer;
import flixel.group.FlxGroup.FlxTypedGroup;

class Rifle extends Gun{
    var _bullets:FlxTypedGroup<Bullet>;

    public function new(bullets:FlxTypedGroup<Bullet>){
        super();
        _MAX_AMMO = 12;
        ammo = 6;
        _bullets = bullets;
        _canShoot = true;
        _timer = new FlxTimer();
    }

    override public function shoot(x:Float, y:Float, f:Bool){
        super.shoot(x,y,f);
        if(_canShoot && !_empty){
            _canShoot = false;
            ammo--;
            _timer.start(2, doneShooting, 1);
            if(f){
                _bullets.recycle(Bullet.new).shoot(x,y, -960);
            }else{
                _bullets.recycle(Bullet.new).shoot(x,y, 960);
            }
        }
    }

    function doneShooting(timer:FlxTimer){
        _canShoot = true;
    }
}