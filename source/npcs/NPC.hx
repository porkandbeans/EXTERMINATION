package npcs;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

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
	public var raycastSprite:FlxSprite;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		_state = IDLE;

		_newAction = true;
		_canJump = true;

		_random = new FlxRandom();

		maxVelocity.set(60, 200);
		acceleration.y = _weight;
		drag.x = maxVelocity.x * 5;
		raycastSprite = new FlxSprite();
		raycastSprite.makeGraphic(10, 10, FlxColor.WHITE);
	}

	override public function update(elapsed:Float)
	{
		physics();

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

	/**
	 * Casts a ray to look for the player and sets _state to TRIGGERED if so.
	 *   
	 * @param  walls    the flxtilemap data of the current level
	 *
	 * @param  player   the player class that handles all the interactive stuff
	 */
	public function lookForPlayer(walls:FlxTilemap, player:Player)
	{
		_playerPos = player.getMidpoint(); // grab this while I'm here

		if (walls.ray(this.getMidpoint(), _playerPos))
		{
			_state = TRIGGERED;
			_walkSpeed = 120;
		}
		else
		{
			_state = IDLE;
			_walkSpeed = 60;
		}
	}

	var xdistance:Float;
	var ydistance:Float;
	var c2:Float;
	var hyp:Float;
	var tan:Float;
	var intan:Float;
	var toDegs:Float;

	/**
		casts a ray from one FlxPoint to the next. Returns TRUE if nothing collides with the ray and FALSE if the view is obstructed
		@param	pos1	the starting point of the raycast
		@param	pos2	the end point of the raycast
		@param	objects	a FlxGroup containing the objects you want the raycast to be obstructed by
	**/
	public function flxRayCast(pos1:FlxPoint, pos2:FlxPoint, objects:FlxGroup)
	{
		raycastSprite.x = pos1.x;
		raycastSprite.y = pos1.y;
		xdistance = pos1.x - pos2.x;
		if (xdistance < 0)
		{
			xdistance = -xdistance;
		}

		ydistance = pos1.y - pos2.y;

		// pythagorean theorum (a^2 + b^2 = c^2)
		c2 = ((xdistance * xdistance) + (ydistance * ydistance));

		// square root the c^2 and we have the distance between pos1 and pos2 (or the hypotenuse)
		hyp = Math.sqrt(c2);
		raycastSprite.width = hyp;

		toDegs = 180 / Math.PI * Math.atan2(ydistance, xdistance);

		raycastSprite.set_angle(toDegs);

		if (FlxG.overlap(raycastSprite, objects))
		{
			trace("there was an overlap");
			return false;
		}
		else
		{
			trace("no overlaps");
			return true;
		}
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
