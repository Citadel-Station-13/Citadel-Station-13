//An immortal(!) boss with a very complicated AI. Basically, he will attack plasmemes and dwarfes on sight, won't attack ashwalkers until they do, will attack everybody if they try to pass though.

/mob/living/simple_animal/hostile/megafauna/gladiator
	name = "gladiator"
	desc = "An immortal ash walker, whose powers have been granted by the necropolis itself."
	icon = 'icons/mob/lavaland/gladiator.dmi'
	icon_state = "gladiator_equip"

	melee_damage_lower = 35
	melee_damage_upper = 35
	speed = 1
	move_to_delay = 2.25

	rapid_melee = 1
	melee_queue_distance = 2
	wander = FALSE

	ranged = 1
	ranged_cooldown_time = 30
	minimum_distance = 1
	health = 1500
	maxHealth = 1500
	movement_type = GROUND
	move_force = MOVE_FORCE_VERY_STRONG
	move_resist = MOVE_FORCE_VERY_STRONG
	pull_force = MOVE_FORCE_VERY_STRONG
	weather_immunities = list("lava","ash")

	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"

	var/list/introduced = list() //Basically all the mobs which the gladiator has already introduced himself to.
	var/list/champions = list() //Everybody who "killed" the gladiator will be counted as champions and won't get attacked by him
	var/list/friendly_lizards = list() //Whoever he won't attack until they attack him or try to pass though him

	var/charging = FALSE
	var/chargetiles = 0
	var/chargerange = 21
	var/stunned = FALSE
	var/stunduration = 15

	var/mob/living/last_attacker

	var/starter_x
	var/starter_y
	var/starter_z

/obj/item/gps/internal/gladiator
	gpstag = "Dreadful Signal"
	desc = "Let me help you to see, miner."
	invisibility = 100

/mob/living/simple_animal/hostile/megafauna/gladiator/Initialize(mapload)
	. = ..()
	internal = new /obj/item/gps/internal/gladiator(src)
	starter_x = x
	starter_y = y
	starter_z = z

/mob/living/simple_animal/hostile/megafauna/gladiator/ListTargets()
	var/list/enemies = list()
	enemies = hearers(vision_range, targets_from)
	enemies -= src

	var/static/hostile_machines = typecacheof(list(/obj/machinery/porta_turret, /obj/mecha))

	for(var/HM in typecache_filter_list(range(vision_range, targets_from), hostile_machines))
		if(can_see(targets_from, HM, vision_range))
			enemies += HM

	for(var/mob/champion in champions)
		enemies -= champion

	for(var/mob/lizard in friendly_lizards)
		if(get_dist(lizard, src) >= 2)
			enemies -= lizard
		else
			friendly_lizards -= lizard

	return enemies

/mob/living/simple_animal/hostile/megafauna/gladiator/GiveTarget(new_target)
	if(new_target in champions)
		return 0
	if(new_target in friendly_lizards)
		if(get_dist(new_target, src) >= 2)
			return
		else
			friendly_lizards -= new_target
	target = new_target
	LosePatience()
	if(!target in introduced)
		introduction(target)
		return

	if(target != null)
		GainPatience()
		Aggro()
		return 1

/mob/living/simple_animal/hostile/megafauna/gladiator/proc/introduction(mob/living/victim)
	if(src == victim)
		introduced += src
		return
	if(victim in introduced)
		return

	if(ishuman(victim))
		var/mob/living/carbon/human/H = victim
		var/datum/species/Hspecies = H.dna.species
		face_atom(H)
		if(Hspecies.id == "ashlizard")
			var/list/messages = list("I am sorry, tribesssmate. I cannot let you through.",\
									"Pleassse leave, walker. I don't want to hurt you.",\
									"The Necropolisss must be protected even from it'ss servants. Pleassse retreat.")
			say(message = pick(messages), language = /datum/language/draconic)
			friendly_lizards |= H
			introduced |= H
		else if(Hspecies.id == "lizard")
			var/list/messages = list("Thisss isss not the time nor place to be. Leave.",\
									"Go back where you came from. I am sssafeguarding thisss sssacred place.",\
									"You ssshould not be here. Turn.",\
									"I can sssee an outlander from a mile away. You're not one of us."\
									)
			say(message = pick(messages), language = /datum/language/draconic)
			introduced |= H
		else if(Hspecies.id == "plasmaman") //Don't you even try to come nearby him. He is fucking immortal and he will kill you. He WILL.
			var/list/messages = list("I will finisssh what little of your race remainsss, starting with you!",\
									"Lavaland belongsss to the lizzzards!",\
									"Thisss sacred land wasn't your property before, it won't be now!")
			say(message = pick(messages))
			introduced |= H
			GiveTarget(H)
		else
			var/list/messages = list("Get out of my sssight, outlander.",\
									"You will not run your dirty handsss through what little sssacred land we have left. Out.",\
									"My urge to end your life isss immeasssurable, but I am willing to ssspare you. Leave.",\
									"You're not invited. Get out.")
			say(message = pick(messages))
			introduced |= H

	else
		say("You are not welcome into the Necropolisss.")
		introduced |= victim

/mob/living/simple_animal/hostile/megafauna/gladiator/proc/chargeattack(atom/victim, var/range)
	face_atom(target)
	visible_message("<span class='boldwarning'>[src] lifts his shield, and prepares to charge!</span>")
	animate(src, color = "#ff6666", 3)
	sleep(4)
	face_atom(target)
	speed = -1
	charging = TRUE

/mob/living/simple_animal/hostile/megafauna/gladiator/proc/discharge(var/modifier = 1)
	stunned = TRUE
	charging = FALSE
	minimum_distance = 1
	chargetiles = 0
	animate(src, color = initial(color), 7)
	sleep(stunduration * modifier)
	stunned = FALSE

/mob/living/simple_animal/hostile/megafauna/gladiator/Move(atom/newloc, dir, step_x, step_y)
	if(stunned)
		return FALSE

	if(ischasm(newloc))
		var/list/possiblelocs = list()
		switch(dir)
			if(NORTH)
				possiblelocs += locate(x +1, y + 1, z)
				possiblelocs += locate(x -1, y + 1, z)
			if(EAST)
				possiblelocs += locate(x + 1, y + 1, z)
				possiblelocs += locate(x + 1, y - 1, z)
			if(WEST)
				possiblelocs += locate(x - 1, y + 1, z)
				possiblelocs += locate(x - 1, y - 1, z)
			if(SOUTH)
				possiblelocs += locate(x - 1, y - 1, z)
				possiblelocs += locate(x + 1, y - 1, z)
			if(SOUTHEAST)
				possiblelocs += locate(x + 1, y, z)
				possiblelocs += locate(x + 1, y + 1, z)
			if(SOUTHWEST)
				possiblelocs += locate(x - 1, y, z)
				possiblelocs += locate(x - 1, y + 1, z)
			if(NORTHWEST)
				possiblelocs += locate(x - 1, y, z)
				possiblelocs += locate(x - 1, y - 1, z)
			if(NORTHEAST)
				possiblelocs += locate(x + 1, y - 1, z)
				possiblelocs += locate(x + 1, y, z)
		for(var/turf/T in possiblelocs)
			if(ischasm(T))
				possiblelocs -= T
		if(possiblelocs.len)
			var/turf/validloc = pick(possiblelocs)
			if(charging)
				chargetiles++
				validloc = get_step(get_turf(src), dir)
			if(chargetiles >= chargerange)
					discharge()
			return ..(validloc)
		return FALSE
	else
		if(charging)
			chargetiles++
			if(chargetiles >= chargerange)
				discharge()
			validloc = get_step(get_turf(src), dir)
			return ..(validloc)
	..()

/mob/living/simple_animal/hostile/megafauna/gladiator/proc/teleport(atom/target)
	var/turf/T = get_step(target, -target.dir)
	new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(src))
	sleep(4)
	if(!ischasm(T) && !(/mob/living in T))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		forceMove(T)
	else
		var/list/possiblelocs = (view(3, target) - view(1, target))
		for(var/atom/A in possiblelocs)
			if(!isturf(A))
				possiblelocs -= A
			else
				if(ischasm(A) || istype(A, /turf/closed) || (/mob/living in A))
					possiblelocs -= A
		if(possiblelocs.len)
			T = pick(possiblelocs)
			new /obj/effect/temp_visual/small_smoke/halfsecond(T)
			forceMove(T)

/mob/living/simple_animal/hostile/megafauna/gladiator/Bump(atom/A)
	. = ..()
	if(charging)
		if(isliving(A))
			var/mob/living/LM = A
			forceMove(LM.loc)
			visible_message("<span class='danger'>[src] knocks [LM] down!</span>", "<span class='userdanger'>[src] knocks you down!</span>")
			LM.DefaultCombatKnockdown(60)
			discharge()
		else if(istype(A, /turf/closed))
			visible_message("<span class='danger'>[src] crashes headfirst into [A]!</span>")
			discharge(1.33)

/mob/living/simple_animal/hostile/megafauna/gladiator/attacked_by(obj/item/I, mob/living/user, attackchain_flags = NONE, damage_multiplier = 1)
	if(iscarbon(user))
		last_attacker = user
	. = ..()

/mob/living/simple_animal/hostile/megafauna/gladiator/bullet_act(obj/item/projectile/P)
	if(P.damtype == BRUTE || P.damtype == BURN)
		if(prob(75))
			visible_message("<span class='danger'>[src] reflects the [P] with his sword!</span>")
			return BULLET_ACT_BLOCK
	if(P.firer && get_dist(src, P.firer) <= aggro_vision_range && iscarbon(P.firer))
		last_attacker = P.firer
	. = ..()

/mob/living/simple_animal/hostile/megafauna/gladiator/death(gibbed)
	health = maxHealth //Immortal guy
	LoseTarget()

	if(!last_attacker)
		return

	var/turf/T = locate(starter_x, starter_y, starter_z)
	Goto(T, speed, 0)
	champions |= last_attacker

	if(ishuman(last_attacker))
		var/mob/living/carbon/human/H = last_attacker
		var/datum/species/Hspecies = H.dna.species
		if(Hspecies.id == "plasmaman")
			say(message = "You proved your power and can pass, [last_attacker]. For now..."
			return
	say(message = "It wasss a great fight, [last_attacker]. You proved that you are worthy of the Necropolisss.")

/mob/living/simple_animal/hostile/megafauna/gladiator/proc/boneappletea(mob/living/victim)
	for(var/i = 1 to 3)
		var/obj/item/kitchen/knife/combat/bone/boned = new /obj/item/kitchen/knife/combat/bone(get_turf(src))
		playsound(src, 'sound/weapons/fwoosh.wav', 60, 0)
		boned.throw_at(victim, 7, 3, src)
		QDEL_IN(boned, 30)
		sleep(1)

/mob/living/simple_animal/hostile/megafauna/gladiator/OpenFire()
	if(stunned)
		return
	anger_modifier = clamp(((maxHealth - health)/50),0,20)
	ranged_cooldown = world.time + ranged_cooldown_time
	if(prob(15 + anger_modifier))
		INVOKE_ASYNC(src, .proc/teleport, target)
	else
		INVOKE_ASYNC(src, .proc/boneappletea, target)

	if(prob(10+anger_modifier))
		var/range = clamp(anger_modifier, 4, 20)
		INVOKE_ASYNC(src, .proc/chargeattack, target, range)