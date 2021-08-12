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
	maxHealth = 15
	health = 15
	see_in_dark = 6
	obj_damage = 10
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 1)
	response_help_continuous = "glares at"
	response_help_simple = "glare at"
	response_disarm_continuous = "skoffs at"
	response_disarm_simple = "skoff at"
	response_harm_continuous = "slashes"
	response_harm_simple = "slash"
	melee_damage_lower = 5
	melee_damage_upper = 7
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
	///Number assigned to rats and mice, checked when determining infighting.

/mob/living/simple_animal/hostile/plaguerat/Initialize()
	. = ..()
	SSmobs.cheeserats += src
	AddComponent(/datum/component/swarming)
	AddElement(/datum/element/ventcrawling, given_tier = VENTCRAWLER_ALWAYS)
	scavenge = new /datum/action/cooldown/scavenge
	scavenge.Grant(src)

/mob/living/simple_animal/hostile/plaguerat/Destroy()
	SSmobs.cheeserats -= src
	return ..()

/mob/living/simple_animal/hostile/plaguerat/BiologicalLife(seconds, times_fired)
	if(!(. = ..()))
		return
	if(isopenturf(loc))
		var/turf/open/T = src.loc
		if(T.air)
			T.atmos_spawn_air("miasma=5;TEMP=293.15")
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
		if(istype(O, /obj/item/trash) || istype(O, /obj/effect/decal/cleanable/blood/gibs))
			qdel(O)
			be_fruitful()

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
	var/cap = CONFIG_GET(number/ratcap)
	if(LAZYLEN(SSmobs.cheeserats) >= cap)
		visible_message("<span class='warning'>[src] gnaws into its food, [cap] rats are now on the station!</span>")
		return
	var/mob/living/newmouse = new /mob/living/simple_animal/hostile/plaguerat(loc)
	SSmobs.cheeserats += newmouse
	visible_message("<span class='notice'>[src] gnaws into its food, attracting another rat!</span>")

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
			new /obj/effect/decal/cleanable/dirt(T)
			new pickedtrash(T)
		if(4 to 6)
			to_chat(owner, "<span class='notice'>You find blood and gibs to feed your young!</span>")
			new /obj/effect/decal/cleanable/blood/gibs(T)
			new /obj/effect/decal/cleanable/blood/(T)
		if(7 to 18)
			to_chat(owner, "<span class='notice'>A corpse rises from the ground. Best to leave it alone.</span>")
			new /obj/effect/mob_spawn/human/corpse/assistant(T)
		if(19 to 100)
			to_chat(owner, "<span class='notice'>Drat. Nothing.</span>")
			new /obj/effect/decal/cleanable/dirt(T)
	StartCooldown()
