package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import guns.Bullet;
import guns.Pistol;
import guns.Rifle;

class Player extends FlxSprite
{
	/**
		write game over code
	**/
	// === PRIVATE VARS ===
	var _jumpForce:Float = 80;

	var _jumpHold:Int;
	var _weight:Float = 300;
	var _grounded:Bool = true;
	var _canJump:Bool;
	var _canAttack:Bool;
	var _attacking:Bool;
	var _pedestrians:FlxGroup;
	var _heldWeapons:Array<Int>;
	var _crouching:Bool;
	var _moving:Bool;
	var _midPoint:FlxPoint;

	// weapons
	var _wep_names:Array<String>;
	var _pBullets:FlxTypedGroup<Bullet>;
	var _rBullets:FlxTypedGroup<Bullet>;

	// === PUBLIC VARS ===
	public var hud:HUD;
	public var current_weapon:Int;
	public var pistol:Pistol;
	public var rifle:Rifle;
	public var hasRifle:Bool;
	public var hasPistol:Bool;
	public var hitreg:FlxSprite;

	// === CONSTANTS ===
	var MAX_JUMPHOLD = 20;
	var MAX_WEAPONS:Int;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		health = 20;

		// === WEAPON DECLARATION STUFF ===
		_wep_names = ["none", "pistol", "rifle"];
		current_weapon = 0;
		MAX_WEAPONS = _wep_names.length - 1; // what even are constants? GoKritz clearly does not know...
		_canAttack = true;
		_heldWeapons = [0]; // append to this with ints so it becomes [0, 1] and [0, 1, 2]
		hasRifle = false;

		// === PHYSICS STUFF ===
		maxVelocity.set(160, 200);
		acceleration.y = _weight;
		drag.x = maxVelocity.x * 5;
		_jumpHold = MAX_JUMPHOLD;

		loadGraphic("assets/images/Player/player.png", true, 32, 32);
		setSize(16, 26); // makes the hitbox better
		offset.set(8, 6);

		// === ANIMATIONS ===
		animation.add("idle", [0]);
		animation.add("run", [1, 2, 3, 4, 5, 6, 7, 8], 9, true);
		animation.add("jump", [9, 10], 4, false);
		animation.add("fall", [11, 12], 9, true);
		animation.add("melee", [13, 14, 15], 12, false);
		animation.add("idlePistol", [16]);
		animation.add("runPistol", [17, 18, 19, 20, 21, 22, 23, 24], 9, true);
		animation.add("jumpPistol", [25, 26], 4, false);
		animation.add("fallPistol", [27, 28], 9, true);
		animation.add("idleRifle", [32]);
		animation.add("runRifle", [33, 34, 35, 36, 37, 38, 39, 40], 9, true);
		animation.add("jumpRifle", [41, 42], 4, false);
		animation.add("fallRifle", [43, 44], 9, true);
		animation.add("crouch", [48]);
		animation.add("crouchPistol", [49]);
		animation.add("crouchRifle", [50]);

		hitreg = new FlxSprite();
		hitreg.makeGraphic(10, 10, FlxColor.TRANSPARENT);
	}

	public function declareBullets(pBulls:FlxTypedGroup<Bullet>, rBulls:FlxTypedGroup<Bullet>)
	{
		_pBullets = pBulls;
		pistol = new Pistol(_pBullets);
		_rBullets = rBulls;
		rifle = new Rifle(_rBullets);
	}

	override public function update(elapsed:Float)
	{
		if (_attacking)
		{
			hitreg.active = true;
			hitregPos();
		}
		else
		{
			hitreg.active = false;
		}
		frameInit();
		keyListeners();
		animations();

		if (health <= 0)
		{
			die();
		}
		super.update(elapsed);
	}

	function hitregPos()
	{
		_midPoint = getMidpoint();
		flipX ? hitreg.x = _midPoint.x - 15 : hitreg.x = _midPoint.x + 5;
		hitreg.y = y + 5;
	}

	function frameInit()
	{
		if (isTouching(FlxObject.FLOOR))
		{
			_jumpHold = MAX_JUMPHOLD;
		}

		acceleration.x = 0;
		acceleration.y = _weight;
	}

	public function updateHUD()
	{
		switch (_heldWeapons[current_weapon])
		{
			case 0:
				hud.updateGun(_heldWeapons[current_weapon], 0);
				return;
			case 1:
				hud.updateGun(_heldWeapons[current_weapon], pistol.ammo);
				return;
			case 2:
				hud.updateGun(_heldWeapons[current_weapon], rifle.ammo);
				return;
		}
	}

	function keyListeners()
	{
		if (!_attacking)
		{
			if (FlxG.keys.anyPressed([LEFT, A]))
			{
				acceleration.x = -maxVelocity.x * 7;
				_moving = true;
			}
			else if (FlxG.keys.anyPressed([RIGHT, D]))
			{
				acceleration.x = maxVelocity.x * 7;
				_moving = true;
			}
			else
			{
				_moving = false;
			}

			// fixes being able to spam jump while in the air
			if (FlxG.keys.anyJustReleased([SPACE, W, UP]) && !isTouching(FlxObject.FLOOR))
			{
				_canJump = false;
			}

			if (isTouching(FlxObject.FLOOR))
			{
				_canJump = true;
			}

			if (FlxG.keys.anyPressed([SPACE, W, UP]) && velocity.y <= 0 && _canJump)
			{
				if (_jumpHold > 0)
				{
					_jumpHold -= 1;
					velocity.y = -_jumpForce;
				}
			}

			if (FlxG.keys.pressed.ENTER && _canAttack)
			{
				attack();
				updateHUD();
			}

			if (FlxG.keys.justPressed.RBRACKET)
			{
				current_weapon++;
				cycleWeps();
				updateHUD();
			}

			if (FlxG.keys.justPressed.LBRACKET)
			{
				current_weapon--;
				cycleWeps();
				updateHUD();
			}

			if (FlxG.keys.anyPressed([S, DOWN]) && !_moving)
			{
				if (!_crouching)
				{
					_crouching = true;
					offset.set(8, 16);
					y = y + 10;
					setSize(16, 16);
				}
			}
			else
			{
				if (_crouching)
				{
					_crouching = false;
					y = y - 10;
					offset.set(8, 6);
					setSize(16, 26);
				}
			}
		}
	}

	function cycleWeps()
	{
		if (current_weapon > _heldWeapons.length - 1)
		{
			current_weapon = 0;
		}
		else if (current_weapon < 0)
		{
			current_weapon = _heldWeapons.length - 1;
		}
	}

	function animations()
	{
		if (!_attacking)
		{
			if (velocity.y == 0)
			{
				if (velocity.x == 0)
				{
					_crouching ? crouch() : idle();
				}
				else
				{
					run();
				}
			}
			else
			{
				if (velocity.y > -0.7)
				{
					fall();
					// animation.play("fall");
				}
				else if (isTouching(FlxObject.FLOOR))
				{
					jump();
					// animation.play("jump");
				}
			}
		}

		if (FlxG.keys.anyPressed([LEFT, A]))
		{
			flipX = true;
		}

		if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			flipX = false;
		}

		if (animation.curAnim == animation.getByName("melee") && animation.finished)
		{
			_attacking = false;
		}
	}

	// === ANIMATION FUNCTIONS ===
	function idle()
	{
		switch (_heldWeapons[current_weapon])
		{
			case 0:
				animation.play("idle");
				return;
			case 1:
				animation.play("idlePistol");
				return;
			case 2:
				animation.play("idleRifle");
				return;
		}
	}

	function run()
	{
		switch (_heldWeapons[current_weapon])
		{
			case 0:
				animation.play("run");
				return;
			case 1:
				animation.play("runPistol");
				return;
			case 2:
				animation.play("runRifle");
				return;
		}
	}

	function jump()
	{
		switch (_heldWeapons[current_weapon])
		{
			case 0:
				animation.play("jump");
				return;
			case 1:
				animation.play("jumpPistol");
				return;
			case 2:
				animation.play("jumpRifle");
				return;
		}
	}

	function fall()
	{
		switch (_heldWeapons[current_weapon])
		{
			case 0:
				animation.play("fall");
				return;
			case 1:
				animation.play("fallPistol");
				return;
			case 2:
				animation.play("fallRifle");
				return;
		}
	}

	function crouch()
	{
		_crouching = true;
		switch (_heldWeapons[current_weapon])
		{
			case 0:
				animation.play("crouch");
				return;
			case 1:
				animation.play("crouchPistol");
				return;
			case 2:
				animation.play("crouchRifle");
				return;
		}
	}

	function finishAttacking(timer:FlxTimer):Void
	{
		_canAttack = true;
	}

	function attack()
	{
		var _x:Float = getMidpoint().x;
		var _y:Float = getMidpoint().y;
		switch (_heldWeapons[current_weapon])
		{
			case 0:
				hitregPos();
				stab();
				return;
			case 1:
				pistol.shoot(_x, _crouching ? (_y + 3) : _y - 2, flipX);
				updateHUD();
				return;
			case 2:
				rifle.shoot(_x, _crouching ? (_y + 3) : _y - 2, flipX);
				updateHUD();
				return;
		}
	}

	function stab()
	{
		_attacking = true;
		_canAttack = false;
		animation.play("melee");
		new FlxTimer().start(0.5, finishAttacking, 1);
	}

	function die()
	{
		FlxG.switchState(new MenuState());
	}

	public function pistolRestock(qty:Int)
	{
		pistol.addAmmo(qty);
	}

	public function rifleRestock(qty:Int)
	{
		rifle.addAmmo(qty);
	}

	public function pickupRifle()
	{
		_heldWeapons = _heldWeapons.concat([2]);
		hasRifle = true;
	}

	public function pickupPistol()
	{
		_heldWeapons = _heldWeapons.concat([1]);
		hasPistol = true;
	}
}
/* TODO

	dynamic stereo sound

	anyway, at the time of writing, I've had an idea to finish this weird little project off
	make a couple different maps and an NPC spawner, and include some environmental dangers
	like moving cars, crushing objects, keep the player moving at all times for the danger
	give the player points for each person they kill, and at the end, show them how well they did. give them achievements
	for the pistol and the rifle if they find them in the map. include Newgrounds high-scores.

	cops need to shoot at the player

	add cop voices

	blood particle effects

	use this engine you've made here to make your RPG?

	there really needs to be more sound. footsteps. Player voice. ambience. needs some gameplay music, too.

 */
