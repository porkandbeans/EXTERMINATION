package pickups.guns;

import pickups.ammo.RifleAmmo;

class RiflePickup extends RifleAmmo{
    override public function new(x:Float = 0, y:Float = 0){
        super(x,y);
        loadGraphic("assets/images/pickups/rifle.png", false, 32, 16);
        setSize(16, 16);
    }

    override public function get(player:Player){
        super.get(player);
        if(!player.hasRifle){
            player.pickupRifle();
        }
            
        if(player.rifle.ammo < player.rifle.getMaxAmmo()){
            player.rifle.addAmmo(12);
            kill();
        }
    }
}