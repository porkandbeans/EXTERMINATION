package;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
    var _playButton:FlxButton;
    var _menuMusic:FlxSound;

	override public function create()
	{
        _playButton = new FlxButton(0,0,"poo poo", clickPlay);
        add(_playButton);
        _playButton.screenCenter();

        _menuMusic = FlxG.sound.load("assets/music/menu.mp3");
        

		super.create();
        _menuMusic.play();
	}

    function clickPlay(){
        FlxG.switchState(new PlayState());
    }
}