package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
    var poopooPlayButton:FlxButton;

	override public function create()
	{
        poopooPlayButton = new FlxButton(0,0,"fuck", clickPlay);
        add(poopooPlayButton);
        poopooPlayButton.screenCenter();

		super.create();
	}

    function clickPlay(){
        FlxG.switchState(new PlayState());
    }
}