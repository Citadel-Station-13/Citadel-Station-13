/obj/structure/swarmer //Default swarmer effect object visual feedback
	name = "swarmer ui"
	desc = null
	gender = NEUTER
	icon = 'icons/mob/swarmer.dmi'
	icon_state = "ui_light"
	layer = MOB_LAYER
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	light_color = LIGHT_COLOR_CYAN
	max_integrity = 30
	anchored = TRUE
	///How strong the light effect for the structure is
	var/glow_range = 1

/obj/structure/swarmer/Initialize(mapload)
	. = ..()
	set_light(glow_range)

/obj/structure/swarmer/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = NONE)
	switch(damage_type)
		if(BRUTE)
			playsound(src, 'sound/weapons/egloves.ogg', 80, TRUE)
		if(BURN)
			playsound(src, 'sound/items/welder.ogg', 100, TRUE)

/obj/structure/swarmer/emp_act()
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	qdel(src)

/**
  * # Swarmer Beacon
  *
  * Beacon which creates sentient player swarmers.
  *
  * The beacon which creates sentient player swarmers during the swarmer event.  Spawns in maint on xeno locations, and can create a player swarmer once every 30 seconds.
  * The beacon cannot be damaged by swarmers, and must be destroyed to prevent the spawning of further player-controlled swarmers.
  * Holds a swarmer within itself during the 30 seconds before releasing it and allowing for another swarmer to be spawned in.
  */

/obj/structure/swarmer_beacon
	name = "swarmer beacon"
	desc = "A machine that prints swarmers."
	icon = 'icons/mob/swarmer.dmi'
	icon_state = "swarmer_console"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 100, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	max_integrity = 400
	layer = MASSIVE_OBJ_LAYER
	light_color = LIGHT_COLOR_CYAN
	light_range = 10
	anchored = TRUE
	density = FALSE
	///Whether or not a swarmer is currently being created by this beacon
	var/processing_swarmer = FALSE

/obj/structure/swarmer_beacon/attack_ghost(mob/user)
	. = ..()
	if(processing_swarmer)
		to_chat(user, "<b>A swarmer is currently being created.  Try again soon.</b>")
		return
	que_swarmer(user)

/**
  * Interaction when a ghost interacts with a swarmer beacon
  *
  * Called when a ghost interacts with a swarmer beacon, allowing them to become a swarmer
  * Arguments:
  * * user - A reference to the ghost interacting with the beacon
  */
/obj/structure/swarmer_beacon/proc/que_swarmer(mob/user)
	var/swarm_ask = alert("Become a swarmer?", "Do you wish to consume the station?", "Yes", "No")
	if(swarm_ask == "No" || QDELETED(src) || QDELETED(user) || processing_swarmer)
		return FALSE
	var/mob/living/simple_animal/hostile/swarmer/newswarmer = new /mob/living/simple_animal/hostile/swarmer(src)
	newswarmer.key = user.key
	addtimer(CALLBACK(src, .proc/release_swarmer, newswarmer), 30 SECONDS)
	to_chat(newswarmer, "<span class='boldannounce'>SWARMER CONSTURCTION INITIALIZED.  TIME TO COMPLETION: 30 SECONDS</span>")
	processing_swarmer = TRUE
	return TRUE

/**
  * Releases a swarmer from the beacon and tells it what to do
  *
  * Occcurs 30 seconds after a ghost becomes a swarmer.  The beacon releases it, tells it what to do, and opens itself up to spawn in a new swarmer.
  * Arguments:
  * * swarmer - The swarmer being released and told what to do
  */
/obj/structure/swarmer_beacon/proc/release_swarmer(mob/swarmer)
	to_chat(swarmer, "<span class='bold'>SWARMER CONSTURCTION COMPLETED.  OBJECTIVES:\n\
	                     1. CONSUME RESOURCES AND REPLICATE UNTIL THERE ARE NO MORE RESOURCES LEFT\n\
						 2. ENSURE PROTECTION OF THE BEACON SO THIS LOCATION CAN BE INVADED AT A LATER DATE; DO NOT PERFORM ACTIONS THAT WOULD RENDER THIS LOCATION DANGEROUS OR INHOSPITABLE\n\
						 3. BIOLOGICAL RESOURCES WILL BE HARVESTED AT A LATER DATE: DO NOT HARM THEM\n\
						 OPERATOR NOTES:\n\
						 - CONSUME RESOURCES TO CONSTRUCT TRAPS, BARRIERS, AND FOLLOWER DRONES\n\
						 - FOLLOWER DRONES CAN BE ORDERED TO MOVE VIA MIDDLE CLICKING ON A TILE.  WHILE DRONES CANNOT ASSIST IN RESOURCE HARVESTING, THEY CAN PROTECT YOU FROM THREATS\n\
						 - LCTRL + ATTACKING AN ORGANIC WILL ALOW YOU TO REMOVE SAID ORGANIC FROM THE AREA\n\
						 - YOU AND YOUR DRONES HAVE A STUN EFFECT ON MELEE.  YOU ARE ALSO ARMED WITH A DISABLER PROJECTILE, USE THESE TO PREVENT ORGANICS FROM HALTING YOUR PROGRESS\n\
						 GLORY TO !*# $*#^</span>")
	swarmer.forceMove(get_turf(src))
	processing_swarmer = FALSE

/obj/structure/swarmer/trap
	name = "swarmer trap"
	desc = "A quickly assembled trap that electrifies living beings and overwhelms machine sensors. Will not retain its form if damaged enough."
	icon_state = "trap"
	max_integrity = 10
	density = FALSE

/obj/structure/swarmer/trap/Crossed(atom/movable/AM)
	if(isliving(AM))
		var/mob/living/living_crosser = AM
		if(!istype(living_crosser, /mob/living/simple_animal/hostile/swarmer))
			playsound(loc,'sound/effects/snap.ogg',50, TRUE, -1)
			living_crosser.electrocute_act(0, src, 1, flags = SHOCK_NOGLOVES|SHOCK_ILLUSION)
			if(iscyborg(living_crosser))
				living_crosser.Paralyze(100)
			qdel(src)
	return ..()

/obj/structure/swarmer/blockade
	name = "swarmer blockade"
	desc = "A quickly assembled energy blockade. Will not retain its form if damaged enough, but disabler beams and swarmers pass right through."
	icon_state = "barricade"
	light_range = MINIMUM_USEFUL_LIGHT_RANGE
	max_integrity = 50

/obj/structure/swarmer/blockade/CanAllowThrough(atom/movable/O)
	. = ..()
	if(isswarmer(O))
		return TRUE
	if(istype(O, /obj/projectile/beam/disabler))
		return TRUE

/obj/effect/temp_visual/swarmer //temporary swarmer visual feedback objects
	icon = 'icons/mob/swarmer.dmi'
	layer = BELOW_MOB_LAYER

/obj/effect/temp_visual/swarmer/disintegration
	icon_state = "disintegrate"
	duration = 1 SECONDS

/obj/effect/temp_visual/swarmer/disintegration/Initialize()
	. = ..()
	playsound(loc, "sparks", 100, TRUE)

/obj/effect/temp_visual/swarmer/dismantle
	icon_state = "dismantle"
	duration = 2.5 SECONDS

/obj/effect/temp_visual/swarmer/integrate
	icon_state = "integrate"
	duration = 0.5 SECONDS