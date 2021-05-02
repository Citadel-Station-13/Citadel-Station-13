/*

Roleplay Drake

The Roleplay Drake is a special Ash Drake for admemery roleplay. It's distinguishing features are the name, description, and the glowing blue eyes.

When not controlled by a player, it acts as a normal ashdrake, but with various changes.

Whenever possible, the drake will breathe fire in the direction it faces, igniting and heavily damaging anything caught in the blast.
It also often causes fire to rain from the sky - many nearby turfs will flash red as a fireball crashes into them, dealing damage to anything on the turfs.
The Roleplay Drake is unable to fly due to excess years of damage to its wings, but it is much faster on its legs.

Due to just being an Ash Drake variant, they have no unique loot from other drakes as to not cause miners to attack them immediately.

*/

/mob/living/simple_animal/hostile/megafauna/dragon/rpdrake
	name = "tomb drake"
	desc = "An ancient Ash Drake untouched except for age. It's eyes glow a soft blue color as opposed to a regular yellow. It carries itself with more strength than the standard drake, eyeing those who come near with caution. Perhaps it is smarter and capable of speech?"
	health = 2000
	maxHealth = 2000
	spacewalk = TRUE
	initial_language_holder = /datum/language_holder/lizard
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE /*NIGHTVISIONHOLYFUCKTHISWASNTHARD*/
	sight = SEE_MOBS|SEE_TURFS /*and thermal cause why the fuck not? Ash drakes have six fuckin eyes. But no x-ray. Can't see objects through walls. Just people.*/
	attack_verb_continuous = "chomps"
	attack_verb_simple = "chomp"
	attack_sound = 'sound/magic/demon_attack1.ogg'
	icon = 'icons/mob/lavaland/rpdrake.dmi'
	icon_state = "rpdrake"
	icon_living = "rpdrake"
	icon_dead = "rpdrake_dead"
	friendly_verb_continuous = "stares down"
	friendly_verb_simple = "stare down"
	speak_emote = list("roars")
	armour_penetration = 50
	melee_damage_lower = 25
	melee_damage_upper = 25
	aggro_vision_range = 10 /*if you can out-run it, it won't chase. keyword if, cause i can't make it slower*/
	speed = 1
	move_to_delay = 5
	ranged = 1
	pixel_x = -16
	crusher_loot = list(/obj/structure/closet/crate/necropolis/dragon/crusher)
	loot = list(/obj/structure/closet/crate/necropolis/dragon)
	butcher_results = list(/obj/item/stack/ore/diamond = 5, /obj/item/stack/sheet/sinew = 5, /obj/item/stack/sheet/bone = 30)
	guaranteed_butcher_results = list(/obj/item/stack/sheet/animalhide/ashdrake = 10)
	deathmessage = "collapses into a pile of bones, its flesh sloughing away. You can almost hear it congratulating you on such a well fought battle."
	death_sound = 'sound/magic/demon_dies.ogg'
	/*These should stop it from destroying walls and objects by just walking into them.*/
	move_force = MOVE_FORCE_NORMAL
	move_resist = MOVE_FORCE_NORMAL
	pull_force = MOVE_FORCE_NORMAL
	footstep_type = FOOTSTEP_MOB_HEAVY

/mob/living/simple_animal/hostile/megafauna/dragon/rpdrake/Initialize()
	smallsprite.Grant(src)
	. = ..()
	internal = new/obj/item/gps/internal/rpdrake(src)

/*
This should make their fire attack straight forward instead of in a three-line cone.
*/
/mob/living/simple_animal/hostile/megafauna/dragon/line_target(offset, range, atom/at = target)
	if(!at)
		return
	var/angle = ATAN2(at.x - src.x, at.y - src.y) + offset
	var/turf/T = get_turf(src)
	for(var/i in 1 to range)
		var/turf/check = locate(src.x + cos(angle) * i, src.y + sin(angle) * i, src.z)
		if(!check)
			break
		T = check
	return (getline(src, T) - get_turf(src))

/mob/living/simple_animal/hostile/megafauna/dragon/fire_line(var/list/turfs)
	sleep(0)
	dragon_fire_line(src, turfs)

/mob/living/simple_animal/hostile/megafauna/dragon/proc/fire_stream(var/atom/at = target)
	playsound(get_turf(src),'sound/magic/fireball.ogg', 200, TRUE)
	sleep(0)
	var/range = 8
	var/list/turfs = list()
	turfs = line_target(0, range, at)
	INVOKE_ASYNC(src, .proc/fire_line, turfs)

/mob/living/simple_animal/hostile/megafauna/dragon/rpdrake/OpenFire()
	if(swooping)
		return
	ranged_cooldown = world.time + ranged_cooldown_time
	fire_stream()

/*
This should stop them from swooping entirely.
*/
/mob/living/simple_animal/hostile/megafauna/dragon/rpdrake/lava_swoop()
	return null

/mob/living/simple_animal/hostile/megafauna/dragon/rpdrake/swoop_attack(fire_rain, atom/movable/manual_target, swoop_duration = 40)
	return null

/mob/living/simple_animal/hostile/megafauna/dragon/rpdrake/AltClickOn(atom/movable/A)
	if(!istype(A))
		to_chat(src, "<span class='warning'>Your wings are too damaged for old swoop maneuvers.</span>")
		return

/*
Cause who doesn't want to find a player-controlled beast?
*/
/obj/item/gps/internal/rpdrake
	icon_state = null
	gpstag = "Wise Signal"
	desc = "Something ancient lies this way."
	invisibility = 100