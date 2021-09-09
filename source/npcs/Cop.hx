package npcs;

class Cop extends NPC{
    override public function new(x:Float = 0, y:Float = 0){
        super(x,y);

        loadGraphic("assets/images/NPCs/cop.png", true, 32, 32);
        
        init();
    }
}