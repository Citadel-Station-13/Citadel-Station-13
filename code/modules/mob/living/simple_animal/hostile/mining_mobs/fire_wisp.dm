/mob/living/simple_animal/hostile/asteroid/fire_wisp
	name = "fire wisp"
	desc = "A tiny fire wisp, made of lava. Touching it looks like a bad idea..."
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "fire_wisp"
	icon_living = "fire_wisp"
	mob_biotypes = MOB_MINERAL|MOB_BEAST
	mouse_opacity = MOUSE_OPACITY_ICON
	speak_emote = list("screams")
	speed = -1 //VERY SPEEDY BOI
	move_to_delay = 1

	maxHealth = 15 //It's a suicidal enemy
	health = 15

	obj_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 5

	attack_verb_continuous = "rushes at"
	attack_verb_simple = "rush at"
	attack_sound = 'sound/magic/fireball.ogg'

	vision_range = 9
	aggro_vision_range = 9
	move_force = MOVE_FORCE_VERY_STRONG
	move_resist = MOVE_FORCE_VERY_STRONG
	pull_force = MOVE_FORCE_VERY_STRONG
	del_on_death = TRUE
	deathmessage = "<span class = 'danger'>explodes in a ball of fire!</span>"

	stat_attack = UNCONSCIOUS
	movement_type = FLYING
	robust_searching = TRUE

/mob/living/simple_animal/hostile/asteroid/fire_wisp/death(gibbed)
	var/turf/T = get_turf(src)
	explosion(T, -1, 0, 1, 0, 0, flame_range = 3)
	. = ..()

/mob/living/simple_animal/hostile/asteroid/fire_wisp/AttackingTarget() //SUICIDE
	death()

/mob/living/simple_animal/hostile/asteroid/fire_wisp/Bump(atom/A)
	if(iscarbon(A))
		var/mob/living/carbon/C = A
		C.adjust_fire_stacks(2)
		C.IgniteMob()
	. = ..()

/mob/living/simple_animal/hostile/asteroid/fire_wisp/Bumped(atom/movable/A)
	if(iscarbon(A))
		var/mob/living/carbon/C = A
		C.adjust_fire_stacks(2)
		C.IgniteMob()
	. = ..()

/mob/living/simple_animal/hostile/asteroid/fire_wisp/attack_hand(mob/living/carbon/human/M)
	M.adjust_fire_stacks(2)
	M.IgniteMob()
	. = ..()
