package pickups.guns;

import pickups.ammo.PistolAmmo;

class PistolPickup extends PistolAmmo{
    override public function new(x:Float = 0, y:Float = 0){
        super(x,y);
        loadGraphic("assets/images/pickups/pistol.png", false, 16, 16);
        setSize(16, 16);
    }

    override public function get(player:Player){
        super.get(player);
        if(!player.hasPistol){
            player.pickupPistol();
        }
            
        if(player.pistol.ammo < player.pistol.getMaxAmmo()){
            player.pistol.addAmmo(12);
            kill();
        }
    }
}