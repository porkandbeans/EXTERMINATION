package npcs;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.util.FlxTimer;
import lime.math.Vector2;

enum State
{ // gonna declare this new state enum so I can tell the code when the NPC is supposed to be idle, and if it's not idle it will have behaviour to follow in child classes
	IDLE;
	TRIGGERED;
}

class NPC extends FlxSprite
{
	var _random:FlxRandom;
	var _painSound01:FlxSound;
	var _painSound02:FlxSound;
	var _painSound03:FlxSound;
	var _painSounds:Array<FlxSound>;
	var _currentAction:Int;
	var _newAction:Bool;
	var _canJump:Bool;
	var _weight:Float = 300;
	var _touchingFloor:Bool; // debugging only
	var _state(default, null):State;
	var _playerPos:FlxPoint;
	var _walkSpeed = 60;
	var thisPos:Vector2;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		_state = IDLE;

		_newAction = true;
		_canJump = true;

		_random = new FlxRandom();

		_playerPos = new FlxPoint();
		thisPos = new Vector2(x, y);

		maxVelocity.set(60, 200);
		acceleration.y = _weight;
		drag.x = maxVelocity.x * 5;
	}

	override public function update(elapsed:Float)
	{
		physics();
		thisPos.setTo(x, y);
		if (alive)
		{
			if (_state == IDLE)
			{
				decideAction();
				doAction();
			}
			else if (_state == TRIGGERED)
			{
				triggered();
			}
		}
		_touchingFloor = isTouching(FlxObject.FLOOR);
		super.update(elapsed);
	}

	public function lookForPlayer(playerPos:Vector2)
	{
		_playerPos.x = playerPos.x;
		_playerPos.y = playerPos.y;

		if (Vector2.distance(playerPos, thisPos) > 100)
		{
			_state = IDLE;
			_walkSpeed = 60;
		}
		else
		{
			_state = TRIGGERED;
			_walkSpeed = 120;
		}
		/*_playerPos = player.getMidpoint(); // grab this while I'm here

		if (walls.ray(this.getMidpoint(), _playerPos))
		{
			_state = TRIGGERED;
			_walkSpeed = 120;
		}
		else
		{
			_state = IDLE;
			_walkSpeed = 60;
		}*/
	}

	/**
		to be overriden by child classes
	**/
	public function triggered() {}

	/**
		applies gravity
	**/
	function physics()
	{
		acceleration.y = _weight;
	}

	/**
		Use random integer math and a timer to decide which direction to move in, or to move at all.
	**/
	function decideAction()
	{
		if (_newAction)
		{
			_newAction = false;
			new FlxTimer().start(_random.float(0, 3), _ ->
			{
				_newAction = true;
			},
				1); // random float between 0 and 3 amount of seconds before choosing next action to take
			_currentAction = _random.int(0, 2);
		}
	}

	/*
		function newAction(timer:FlxTimer){
			_newAction = true;
	}*/
	/**
		After deciding what to do, do the thing you have decided to do.
	**/
	function doAction()
	{
		switch (_currentAction)
		{
			case 0:
				walkLeft();
				return;
			case 1:
				walkRight();
				return;
			case 2:
				acceleration.x = 0;
				animation.play("idle");
				return; // stand still for a bit
		}
	}

	function walkLeft()
	{
		animation.play("walk");
		acceleration.x = -_walkSpeed; // walk left
		flipX = true;
		if (isTouching(FlxObject.WALL) && isTouching(FlxObject.FLOOR))
		{
			jump();
		}
	}

	function walkRight()
	{
		animation.play("walk");
		acceleration.x = _walkSpeed; // walk right
		flipX = false;
		if (isTouching(FlxObject.WALL) && isTouching(FlxObject.FLOOR))
		{
			jump();
		}
	}

	function jump()
	{
		velocity.y = -100;
	}

	/**
		handles animation logic for when an NPC dies. "Stabbed" is out of date, probably due for a refactor. But I'm lazy.
	**/
	public function getStabbed()
	{
		if (health > 0)
		{
			animation.play("stabbed");
			// TODO: this exists because the sounds don't
			for (sound in _painSounds)
			{
				if (sound == null)
				{
					die();
					return; // don't play sounds that don't exist
				}
			}

			_painSounds[_random.int(0, _painSounds.length - 1)].play(true);

			die();
		}
	}

	/**
		called at the end of getStabbed()
	**/
	function die()
	{
		alive = false;
		acceleration.x = 0;
		health = 0;

		new FlxTimer().start(3, finalDeath);
	}

	/**
		callback for a FlxTimer to remove the object from the game permanently.
	**/
	function finalDeath(obj:FlxTimer)
	{
		kill(); // 死ね

		// TODO: fade-out animation maybe?
	}

	/**
		Whenever a new NPC type is being declared, this function should be called
		kinda towards the end of new(). Basically it assigns the hitbox, the volumes,
		animations, all the stuff that NPCs should just globally have.
	 */
	function init()
	{
		setSize(16, 24);
		offset.set(8, 8);

		_painSounds = [_painSound01, _painSound02, _painSound03];

		for (sound in _painSounds)
		{
			if (sound != null)
			{ // TODO: this is only here because I don't have death sounds for the cops yet
				sound.volume = FlxG.sound.volume;
			}
		}

		animation.add("idle", [0]);
		animation.add("stabbed", [1, 2, 3, 4], 4, false);
		animation.add("walk", [8, 9, 10, 11, 12, 13, 14, 15], 8, true);
	}
}
