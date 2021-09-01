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
        loadSound("assets/sounds/sound_effects/guns/pistol.wav");
    }

    override public function shoot(x:Float, y:Float, f:Bool){
        super.shoot(x, y, f);
        if(_canShoot && !_empty){ // if the gun is NOT on cooldown and HAS ammo 
            _canShoot = false;
            ammo--;
            _timer.start(0.4, doneShooting, 1);
            if(f){ // determines the bullet's direction
                _bullets.recycle(Bullet.new).shoot(x, y, -240);
            }else{
                _bullets.recycle(Bullet.new).shoot(x, y, 240);
            }
            _shot.play(true);
        }
    }

    function doneShooting(timer:FlxTimer){
        _canShoot = true;
    }
}