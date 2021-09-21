package npcs;

class Cop extends NPC{
    override public function new(x:Float = 0, y:Float = 0){
        super(x,y);

        loadGraphic("assets/images/NPCs/cop.png", true, 32, 32);
        
        init();
    }

    override public function triggered(){
        // stand still and shoot at the player's direction
        super.triggered();
    }
}