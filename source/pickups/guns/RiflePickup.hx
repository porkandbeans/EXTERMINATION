package pickups.guns;

import pickups.ammo.RifleAmmo;

class RiflePickup extends RifleAmmo{
    override public function new(x:Float = 0, y:Float = 0){
        super(x,y);
        loadGraphic("assets/images/pickups/rifle.png", false, 32, 16);
        setSize(16, 16);
    }

    override public function get(player:Player){
        if(!player.hasRifle){
            player.pickupRifle();
        }
        super.get(player);
        kill();
    }
}