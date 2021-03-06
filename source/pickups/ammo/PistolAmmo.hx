package pickups.ammo;

import flixel.util.FlxColor;

class PistolAmmo extends Pickup{
    override public function new(x:Float = 0,y:Float = 0){
        super(x,y);
        loadGraphic("assets/images/pickups/pistolammo.png", false, 16, 16);
        //makeGraphic(8, 8, FlxColor.YELLOW);
    }

    override public function get(player:Player){
        super.get(player); // updates the HUD
        if(player.pistol.ammo >= player.pistol.getMaxAmmo()){
            return;
        }
        player.pistolRestock(12);
        kill();
    }
}