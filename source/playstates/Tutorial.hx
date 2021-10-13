package playstates;

import flixel.FlxG;
import flixel.addons.editors.ogmo.FlxOgmo3Loader.EntityData;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import objects.Crate;
import objects.Levelgoal;
import playstates.tutorial_assets.Tutorial_goal;
import playstates.tutorial_assets.Tutorial_target;

class Tutorial extends PlayState
{
	var spawnPoint1:FlxPoint;
	var spawnPoint2:FlxPoint;
	var spawnPoint3:FlxPoint;
	var spawnPoint4:FlxPoint;
	var tut_goals:FlxTypedGroup<Tutorial_goal>;
	var tut_targets:FlxTypedGroup<Tutorial_target>;
	var melee_target:Tutorial_target;
	var pistol_target:Tutorial_target;
	var rifle_target:Tutorial_target;
	var _levelGoals:FlxTypedGroup<Levelgoal>; // triggers a new Playstate to load when the player overlaps this extended FlxSprite, lets keep these level-specific though
	var _current_stage:Int = 0;
	var _pistol_over:Bool = false;

	override public function create()
	{
		tut_goals = new FlxTypedGroup<Tutorial_goal>();
		tut_targets = new FlxTypedGroup<Tutorial_target>();
		_levelGoals = new FlxTypedGroup<Levelgoal>();
		_current_stage = 0;

		super.create();
		add(tut_goals);
		add(tut_targets);
		add(melee_target);
		add(pistol_target);
		add(rifle_target);
		add(_levelGoals);
		pistol_target.setPoint(spawnPoint3);
		rifle_target.setPoint(spawnPoint4);

		_hud.showDialogue([
			"6am. You were up late again last night, weren't you? Or did you skip sleep entirely perhaps? Nevermind. What matters now is that you're up and ready to begin training.",
			"We'll start with a warm-up. Lets see you jump up these stairs.",
			"(use the WASD keys to move your character. Press spacebar to jump.)"
		]);
		// add(_player);
		/**
			TODO:
				figure out how layers work
				and put that damn target behind the player
				idk what to do with this and I have no internet
				so I can't look it up
		**/
	}

	override public function placeEntities(entity:EntityData)
	{
		super.placeEntities(entity);
		switch (entity.name)
		{
			case "tutspawn1":
				spawnPoint1 = new FlxPoint(entity.x, entity.y);
				return;
			case "tutspawn2":
				spawnPoint2 = new FlxPoint(entity.x, entity.y);
				return;
			case "tutspawn3":
				spawnPoint3 = new FlxPoint(entity.x, entity.y);
				return;
			case "tutspawn4":
				spawnPoint4 = new FlxPoint(entity.x, entity.y);
				return;
			case "tutorial_goal":
				tut_goals.add(new Tutorial_goal(entity.x, entity.y));
				return;
			case "tutorial_target1":
				melee_target = new Tutorial_target(entity.x, entity.y, 1);
				tut_targets.add(melee_target);
				return;
			case "tutorial_target2":
				pistol_target = new Tutorial_target(entity.x, entity.y, 2);
				tut_targets.add(pistol_target);
				return;
			case "tutorial_target3":
				rifle_target = new Tutorial_target(entity.x, entity.y, 3);
				tut_targets.add(rifle_target);
				return;
			case "level_goal":
				_levelGoals.add(new Levelgoal(entity.x, entity.y));
				return;

		}
	}

	override public function collisions()
	{
		super.collisions();
		FlxG.overlap(_player, tut_goals, advanceTut1);
		FlxG.overlap(_player.hitreg, tut_targets, breakTarget);
		FlxG.overlap(_bullets, tut_targets, advanceTut);
		FlxG.overlap(_player, _levelGoals, nextLevel);
	}

	function advanceTut1(obj:Dynamic, obj0:Dynamic) // I don't actually want the params
	{
		_current_stage = 1;
		_player.x = spawnPoint1.x;
		_player.y = spawnPoint1.y - 16;
		new FlxTimer().start(0.1, (timer:FlxTimer) ->
		{
			_hud.showDialogue([
				"Good. You can climb stairs. That much is expected of you at least.",
				"Unfortunately your life is going to involve scarier monsters than stairs.",
				"Proceed to stab the target. You should always have a knife at the ready in that combat suit I've given you.",
				"(Press ENTER to attack enemies)"
			]);
		});
		
	}

	function advanceTut(obj:Dynamic, targ:Tutorial_target)
	{
		_player.x = targ.advanceTutorial().x;
		_player.y = targ.advanceTutorial().y;
		new FlxTimer().start(0.1, (timer:FlxTimer) ->
		{
			if (targ.getNum() == 2)
			{
				_hud.showDialogue([
					"You're getting sloppy. I'm restricting your vision for this next target.",
					"(The rifle will shoot through multiple targets and crates)"
				]);
			}
			else
			{
				_hud.showDialogue([
					"Where's the fun in shooting boxes and stabbing targets? This next room has a tennis ball launcher that shoots shurikens at you.",
					"Try not to lose any flesh like last time.",
					"(press S to duck out of danger)"
				]);
			}
		});
		
	}

	function breakTarget(obj:Dynamic, obj0:Dynamic)
	{
		_player.x = spawnPoint2.x;
		_player.y = spawnPoint2.y - 16;
		new FlxTimer().start(0.1, (timer:FlxTimer) ->
		{
			_hud.showDialogue([
				"Alright, that's enough stabbing. Try picking up this pistol and shooting the next target.",
				"(When you have multiple weapons, press the [ SQUARE BRACKET ] keys to cycle through them)"
			]);
			_current_stage = 2;
		});
	}
	function nextLevel(obj1:Player, obj2:Levelgoal)
	{
		FlxG.switchState(new PlayState("assets/levels/Level1.json"));
	}

}