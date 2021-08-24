package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
	var _mainMenu:FlxGroup;
	var _startButton:FlxButton;
	var _newgameButton:FlxButton;
	var _optionsButton:FlxButton;
	var _continueButton:FlxButton;
	var _levelsButton:FlxButton;

	var _menuMusic:FlxSound;

	var _screenWidth:Float;
	var _screenHeight:Float;
	var _buttonWidth:Float;

	override public function create()
	{
		_screenWidth = FlxG.width;
		_screenHeight = FlxG.height;

		_buttonWidth = _screenWidth - 100;

		FlxG.autoPause = true;
		_startButton = new FlxButton(0, 0, "begin", clickPlay);
		_startButton.screenCenter();
		add(_startButton);

		_newgameButton = new FlxButton(_buttonWidth, 0, "New Game", newGame);
		add(_newgameButton);
		_continueButton = new FlxButton(_buttonWidth, 30, "Continue", continueGame);
		add(_continueButton);
		_levelsButton = new FlxButton(_buttonWidth, 60, "Level Select", levelsMenu);
		add(_levelsButton);
		_optionsButton = new FlxButton(_buttonWidth, 90, "Options", optionsMenu);
		add(_optionsButton);

		_mainMenu = new FlxGroup();
		_mainMenu.add(_newgameButton);
		_mainMenu.add(_continueButton);
		_mainMenu.add(_levelsButton);
		_mainMenu.add(_optionsButton);

		_mainMenu.forEach(hideButton);

		_menuMusic = FlxG.sound.load("assets/music/menu.mp3", 1, // volume
			true, // looped
			null, // group
			false // , // destroy when finished
			// true); // autoplay
		);

		FlxG.sound.music = _menuMusic;
		FlxG.sound.music.play();

		super.create();
	}

	function hideButton(button:FlxBasic)
	{
		button.visible = false;
	}

	function showButton(button:FlxBasic)
	{
		button.visible = true;
	}

	function clickPlay()
	{
		_startButton.visible = false;
		_mainMenu.forEach(showButton);
	}

	function newGame()
	{
		FlxG.sound.music.pause();
		FlxG.switchState(new PlayState());
	}

	function optionsMenu()
	{
		// this doesn't do anything right now
	}

	function continueGame()
	{
		// this doesn't do anything right now
	}

	function levelsMenu()
	{
		// this doesn't do anything right now
	}
}
