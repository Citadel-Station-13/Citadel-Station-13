#define RAT_VENT_CHANCE 1.75
GLOBAL_LIST_EMPTY(plague_rats)

/mob/living/simple_animal/hostile/plaguerat
	name = "plague rat"
	desc = "A large decaying rat.  It spreads its filth and emits a putrid odor to create more of its kind."
	icon_state = "plaguerat"
	icon_living = "plaguerat"
	icon_dead = "plaguerat_dead"
	speak = list("Skree!","SKREEE!","Squeak?")
	speak_emote = list("squeaks")
	emote_hear = list("Hisses.")
	emote_see = list("runs in a circle.", "stands on its hind legs.")
	gender = NEUTER
	speak_chance = 1
	turns_per_move = 5
	maxHealth = 100
	health = 100
	see_in_dark = 6
	obj_damage = 10
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 1)
	response_help_continuous = "glares at"
	response_help_simple = "glare at"
	response_disarm_continuous = "skoffs at"
	response_disarm_simple = "skoff at"
	response_harm_continuous = "slashes"
	response_harm_simple = "slash"
	melee_damage_lower = 6
	melee_damage_upper = 8
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/punch1.ogg'
	faction = list("rat")
	density = FALSE
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	var/datum/action/cooldown/scavenge
	var/last_spawn_time = 0
	var/in_vent = FALSE
	var/min_next_vent = 0
	var/obj/machinery/atmospherics/components/unary/entry_vent
	var/obj/machinery/atmospherics/components/unary/exit_vent

/mob/living/simple_animal/hostile/plaguerat/Initialize(mapload)
	. = ..()
	GLOB.plague_rats += src
	AddComponent(/datum/component/swarming)
	AddElement(/datum/element/ventcrawling, given_tier = VENTCRAWLER_ALWAYS)
	scavenge = new /datum/action/cooldown/scavenge
	scavenge.Grant(src)

/mob/living/simple_animal/hostile/plaguerat/Destroy()
	GLOB.plague_rats -= src
	return ..()

/mob/living/simple_animal/hostile/plaguerat/Life(seconds, times_fired)
	. = ..()
	//Don't try to path to one target for too long. If it takes longer than a certain amount of time, assume it can't be reached and find a new one
	//Literally only here to prevent farming and that's it.
	if(!client) //don't do this shit if there's a client, they're capable of ventcrawling manually
		if(in_vent)
			target = null
		if(entry_vent && get_dist(src, entry_vent) <= 1)
			var/list/vents = list()
			var/datum/pipeline/entry_vent_parent = entry_vent.parents[1]
			for(var/obj/machinery/atmospherics/components/unary/temp_vent in entry_vent_parent.other_atmosmch)
				vents += temp_vent
			if(!vents.len)
				entry_vent = null
				in_vent = FALSE
				return
			exit_vent = pick(vents)
			visible_message("<span class='notice'>[src] crawls into the ventilation ducts!</span>")

			loc = exit_vent
			var/travel_time = round(get_dist(loc, exit_vent.loc) / 2)
			addtimer(CALLBACK(src, .proc/exit_vents), travel_time) //come out at exit vent in 2 to 20 seconds


		if(world.time > min_next_vent && !entry_vent && !in_vent && prob(RAT_VENT_CHANCE)) //small chance to go into a vent
			for(var/obj/machinery/atmospherics/components/unary/v in view(7,src))
				if(!v.welded)
					entry_vent = v
					in_vent = TRUE
					walk_to(src, entry_vent)
					break

/mob/living/simple_animal/hostile/plaguerat/BiologicalLife(delta_time, times_fired)
	if(!(. = ..()))
		return
	if(isopenturf(loc))
		var/turf/open/T = src.loc
		var/datum/gas_mixture/stank = new
		var/miasma_moles = T.air.get_moles(GAS_MIASMA)
		stank.set_moles(GAS_MIASMA,5)
		stank.set_temperature(BODYTEMP_NORMAL)
		if(T.air)
			if(miasma_moles < 200)
				T.assume_air(stank)
				T.air_update_turf()

	if(prob(40))
		scavenge.Trigger()
	if(prob(50))
		var/turf/open/floor/F = get_turf(src)
		if(istype(F) && !F.intact)
			var/obj/structure/cable/C = locate() in F
			if(C && C.avail())
				visible_message("<span class='warning'>[src] chews through the [C]. It looks unharmed!</span>")
				playsound(src, 'sound/effects/sparks2.ogg', 100, TRUE)
				C.deconstruct()
	for(var/obj/O in range(1,src))
		if((world.time - last_spawn_time) > 10 SECONDS && istype(O, /obj/item/trash) || istype(O, /obj/effect/decal/cleanable/blood/gibs))
			qdel(O)
			be_fruitful()
			last_spawn_time = world.time

/mob/living/simple_animal/hostile/plaguerat/CanAttack(atom/the_target)
	if(istype(the_target,/mob/living/simple_animal))
		var/mob/living/A = the_target
		if(istype(the_target, /mob/living/simple_animal/hostile/plaguerat) && A.stat == CONSCIOUS)
			var/mob/living/simple_animal/hostile/plaguerat/R = the_target
			if(R.faction_check_mob(src, TRUE))
				return FALSE
			else
				return TRUE
	return ..()

/**
  *Checks the mouse cap, if it's above the cap, doesn't spawn a mouse. If below, spawns a mouse and adds it to cheeserats.
  */

/mob/living/simple_animal/hostile/plaguerat/proc/be_fruitful()
	var/cap = 10
	if(LAZYLEN(GLOB.plague_rats) >= cap)
		visible_message("<span class='warning'>[src] gnaws into its food, [cap] rats are now on the station!</span>")
		return
	new /mob/living/simple_animal/hostile/plaguerat(loc)
	visible_message("<span class='notice'>[src] gnaws into its food, attracting another rat!</span>")

/mob/living/simple_animal/hostile/plaguerat/proc/exit_vents()
	if(!exit_vent || exit_vent.welded)
		loc = entry_vent
		entry_vent = null
		return
	loc = exit_vent.loc
	entry_vent = null
	exit_vent = null
	in_vent = FALSE
	var/area/new_area = get_area(loc)
	message_admins("[src] came out at [new_area][ADMIN_JMP(loc)]!")
	if(new_area)
		new_area.Entered(src)
	visible_message("<span class='notice'>[src] climbs out of the ventilation ducts!</span>")
	min_next_vent = world.time + 900 //90 seconds between ventcrawls

/**
  *Creates a chance to spawn more trash or gibs to repopulate.  Otherwise, spawns a corpse or dirt.
  */

/datum/action/cooldown/scavenge
	name = "Scavenge"
	desc = "Spread the plague, scavenge for trash and fresh meat to reproduce."
	icon_icon = 'icons/mob/actions/actions_animal.dmi'
	background_icon_state = "bg_clock"
	button_icon_state = "coffer"
	cooldown_time = 50

/datum/action/cooldown/scavenge/Trigger()
	. = ..()
	if(!.)
		return
	var/turf/T = get_turf(owner)
	var/loot = rand(1,100)
	switch(loot)
		if(1 to 3)
			var/pickedtrash = pick(GLOB.ratking_trash)
			to_chat(owner, "<span class='notice'>Excellent, you find more trash to spread your filth!</span>")
			new pickedtrash(T)
		if(4 to 6)
			to_chat(owner, "<span class='notice'>You find blood and gibs to feed your young!</span>")
			new /obj/effect/decal/cleanable/blood/gibs(T)
			if(!locate(/obj/effect/decal/cleanable/blood) in T)
				new /obj/effect/decal/cleanable/blood/(T)
		if(7 to 100)
			to_chat(owner, "<span class='notice'>Drat. Nothing.</span>")
	StartCooldown()
