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
        if(_canShoot){ // if the gun is not on cooldown 
            _canShoot = false;
            _timer.start(0.4, doneShooting, 1);  
            if(ammo > 0){ // if gun has ammo
            // determines the direction the bullet travels
                f?_bullets.recycle(Bullet.new).shoot(x, y, -240):_bullets.recycle(Bullet.new).shoot(x, y, 240);
            }
        }
        
    }

    function doneShooting(timer:FlxTimer){
        _canShoot = true;
    }

    public function initBullets(bulls:Int){
        _bullets = new FlxTypedGroup<Bullet>(bulls);
    }
}