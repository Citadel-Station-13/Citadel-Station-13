/*
DOG BORG EQUIPMENT HERE
SLEEPER CODE IS IN game/objects/items/devices/dogborg_sleeper.dm !
*/

/obj/item/dogborg/jaws
	name = "Dogborg jaws"
	desc = "The jaws of the debug errors oh god."
	icon = 'icons/mob/dogborg.dmi'
	flags_1 = CONDUCT_1
	force = 1
	throwforce = 0
	w_class = 3
	hitsound = 'sound/weapons/bite.ogg'
	sharpness = IS_SHARP
	var/stamtostunconversion = 0.1 //Total stamloss gets multiplied by this value for the help intent hard stun. Resting adds an additional 2x multiplier on top. Keep this low or so help me god.
	var/stuncooldown = 4 SECONDS //How long it takes before you're able to attempt to stun a target again
	var/nextstuntime

/obj/item/dogborg/jaws/examine(mob/user)
	. = ..()
	if(!CONFIG_GET(flag/weaken_secborg))
		. += "<span class='notice'>Use help intent to attempt to non-lethally incapacitate the target by latching on with your maw. This is more effective against exhausted and resting targets.</span>"

/obj/item/dogborg/jaws/big
	name = "combat jaws"
	desc = "The jaws of the law. Very sharp."
	icon_state = "jaws"
	force = 15 //Chomp chomp. Crew harm.
	attack_verb = list("chomped", "bit", "ripped", "mauled", "enforced")
	stamtostunconversion = 0.2 // 100*0.2*2=40. Stun's just long enough to slap on cuffs with click delay if the target is near hard stamcrit.
	stuncooldown = 6 SECONDS


/obj/item/dogborg/jaws/small
	name = "puppy jaws"
	desc = "Rubberized teeth designed to protect accidental harm. Sharp enough for specialized tasks however."
	icon_state = "smalljaws"
	force = 6
	attack_verb = list("nibbled", "bit", "gnawed", "chomped", "nommed")
	var/status = 0

/obj/item/dogborg/jaws/attack(atom/A, mob/living/silicon/robot/user)
	if(!istype(user))
		return
	if(!CONFIG_GET(flag/weaken_secborg) && user.a_intent != INTENT_HARM && istype(A, /mob/living))
		if(A == user.pulling)
			to_chat(user, "<span class='warning'>You already have [A] in your jaws.</span>")
			return
		if(nextstuntime >= world.time)
			to_chat(user, "<span class='warning'>Your jaw servos are still recharging.</span>")
			return
		nextstuntime = world.time + stuncooldown
		var/mob/living/M = A
		var/cachedstam = M.getStaminaLoss()
		var/totalstuntime = cachedstam * stamtostunconversion * (M.lying ? 2 : 1)
		if(CHECK_MOBILITY(M, MOBILITY_STAND))
			M.DefaultCombatKnockdown(cachedstam*2) //BORK BORK. GET DOWN.
		M.Stun(totalstuntime)
		user.do_attack_animation(A, ATTACK_EFFECT_BITE)
		user.start_pulling(M, TRUE) //Yip yip. Come with.
		user.changeNext_move(CLICK_CD_MELEE)
		M.visible_message("<span class='danger'>[user] clamps [user.p_their()] [src] onto [M] and latches on!</span>", "<span class='userdanger'>[user] clamps [user.p_their()] [src] onto you and latches on!</span>")
		if(totalstuntime >= 4 SECONDS)
			playsound(usr, 'sound/effects/k9_jaw_strong.ogg', 75, FALSE, 2) //Wuff wuff. Big stun.
		else
			playsound(usr, 'sound/effects/k9_jaw_weak.ogg', 50, TRUE, -1) //Arf arf. Pls buff.
	else
		. = ..()
		user.do_attack_animation(A, ATTACK_EFFECT_BITE)

/obj/item/dogborg/jaws/small/attack_self(mob/user)
	var/mob/living/silicon/robot/R = user
	if(R.cell && R.cell.charge > 100)
		if(R.emagged && status == 0)
			name = "combat jaws"
			icon_state = "jaws"
			desc = "The jaws of the law."
			force = 12
			attack_verb = list("chomped", "bit", "ripped", "mauled", "enforced")
			stamtostunconversion = 0.15
			stuncooldown = 5 SECONDS
			status = 1
			to_chat(user, "<span class='notice'>Your jaws are now [status ? "Combat" : "Pup'd"].</span>")
		else
			name = "puppy jaws"
			icon_state = "smalljaws"
			desc = "The jaws of a small dog."
			force = initial(force)
			attack_verb = list("nibbled", "bit", "gnawed", "chomped", "nommed")
			stamtostunconversion = initial(stamtostunconversion)
			stuncooldown = initial(stuncooldown)
			status = 0
			if(R.emagged)
				to_chat(user, "<span class='notice'>Your jaws are now [status ? "Combat" : "Pup'd"].</span>")
	update_icon()

//Boop

/obj/item/analyzer/nose
	name = "boop module"
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "nose"
	desc = "The BOOP module"
	flags_1 = CONDUCT_1
	force = 0
	throwforce = 0
	attack_verb = list("nuzzles", "pushes", "boops")
	w_class = 1

/obj/item/analyzer/nose/attack_self(mob/user)
	user.visible_message("[user] sniffs around the air.", "<span class='warning'>You sniff the air for gas traces.</span>")

	var/turf/location = user.loc
	if(!istype(location))
		return

	var/datum/gas_mixture/environment = location.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles()

	to_chat(user, "<span class='info'><B>Results:</B></span>")
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		to_chat(user, "<span class='info'>Pressure: [round(pressure,0.1)] kPa</span>")
	else
		to_chat(user, "<span class='alert'>Pressure: [round(pressure,0.1)] kPa</span>")
	if(total_moles)
		var/list/env_gases = environment.gases

		var/o2_concentration = env_gases[/datum/gas/oxygen]/total_moles
		var/n2_concentration = env_gases[/datum/gas/nitrogen]/total_moles
		var/co2_concentration = env_gases[/datum/gas/carbon_dioxide]/total_moles
		var/plasma_concentration = env_gases[/datum/gas/plasma]/total_moles
		GAS_GARBAGE_COLLECT(environment.gases)

		if(abs(n2_concentration - N2STANDARD) < 20)
			to_chat(user, "<span class='info'>Nitrogen: [round(n2_concentration*100, 0.01)] %</span>")
		else
			to_chat(user, "<span class='alert'>Nitrogen: [round(n2_concentration*100, 0.01)] %</span>")

		if(abs(o2_concentration - O2STANDARD) < 2)
			to_chat(user, "<span class='info'>Oxygen: [round(o2_concentration*100, 0.01)] %</span>")
		else
			to_chat(user, "<span class='alert'>Oxygen: [round(o2_concentration*100, 0.01)] %</span>")

		if(co2_concentration > 0.01)
			to_chat(user, "<span class='alert'>CO2: [round(co2_concentration*100, 0.01)] %</span>")
		else
			to_chat(user, "<span class='info'>CO2: [round(co2_concentration*100, 0.01)] %</span>")

		if(plasma_concentration > 0.005)
			to_chat(user, "<span class='alert'>Plasma: [round(plasma_concentration*100, 0.01)] %</span>")
		else
			to_chat(user, "<span class='info'>Plasma: [round(plasma_concentration*100, 0.01)] %</span>")


		for(var/id in env_gases)
			if(id in GLOB.hardcoded_gases)
				continue
			var/gas_concentration = env_gases[id]/total_moles
			to_chat(user, "<span class='alert'>[GLOB.meta_gas_names[id]]: [round(gas_concentration*100, 0.01)] %</span>")
		to_chat(user, "<span class='info'>Temperature: [round(environment.temperature-T0C)] &deg;C</span>")

/obj/item/analyzer/nose/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	do_attack_animation(target, null, src)
	user.visible_message("<span class='notice'>[user] [pick(attack_verb)] \the [target.name] with their nose!</span>")

//Delivery
/obj/item/storage/bag/borgdelivery
	name = "fetching storage"
	desc = "Fetch the thing!"
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "dbag"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/bag/borgdelivery/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_combined_w_class = 5
	STR.max_items = 1
	STR.cant_hold = typecacheof(list(/obj/item/disk/nuclear, /obj/item/radio/intercom))

//Tongue stuff
/obj/item/soap/tongue
	name = "synthetic tongue"
	desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "synthtongue"
	hitsound = 'sound/effects/attackblob.ogg'
	cleanspeed = 80
	var/status = 0

/obj/item/soap/tongue/scrubpup
	cleanspeed = 25 //slightly faster than a mop.

/obj/item/soap/tongue/New()
	..()
	item_flags |= NOBLUDGEON //No more attack messages

/obj/item/soap/tongue/attack_self(mob/user)
	var/mob/living/silicon/robot/R = user
	if(R.cell && R.cell.charge > 100)
		if(R.emagged && status == 0)
			status = !status
			name = "energized tongue"
			desc = "Your tongue is energized for dangerously maximum efficency."
			icon_state = "syndietongue"
			to_chat(user, "<span class='notice'>Your tongue is now [status ? "Energized" : "Normal"].</span>")
			cleanspeed = 10 //(nerf'd)tator soap stat
		else
			status = 0
			name = "synthetic tongue"
			desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
			icon_state = "synthtongue"
			cleanspeed = initial(cleanspeed)
			if(R.emagged)
				to_chat(user, "<span class='notice'>Your tongue is now [status ? "Energized" : "Normal"].</span>")
	update_icon()

/obj/item/soap/tongue/afterattack(atom/target, mob/user, proximity)
	var/mob/living/silicon/robot/R = user
	if(!proximity || !check_allowed_items(target))
		return
	if(R.client && (target in R.client.screen))
		to_chat(R, "<span class='warning'>You need to take that [target.name] off before cleaning it!</span>")
	else if(is_cleanable(target))
		R.visible_message("[R] begins to lick off \the [target.name].", "<span class='warning'>You begin to lick off \the [target.name]...</span>")
		if(do_after(R, src.cleanspeed, target = target))
			if(!in_range(src, target)) //Proximity is probably old news by now, do a new check.
				return //If they moved away, you can't eat them.
			to_chat(R, "<span class='notice'>You finish licking off \the [target.name].</span>")
			qdel(target)
			R.cell.give(50)
	else if(isobj(target)) //hoo boy. danger zone man
		if(istype(target,/obj/item/trash))
			R.visible_message("[R] nibbles away at \the [target.name].", "<span class='warning'>You begin to nibble away at \the [target.name]...</span>")
			if(!do_after(R, src.cleanspeed, target = target))
				return //If they moved away, you can't eat them.
			to_chat(R, "<span class='notice'>You finish off \the [target.name].</span>")
			qdel(target)
			R.cell.give(250)
			return
		if(istype(target,/obj/item/stock_parts/cell))
			R.visible_message("[R] begins cramming \the [target.name] down its throat.", "<span class='warning'>You begin cramming \the [target.name] down your throat...</span>")
			if(!do_after(R, 50, target = target))
				return //If they moved away, you can't eat them.
			to_chat(R, "<span class='notice'>You finish off \the [target.name].</span>")
			var/obj/item/stock_parts/cell/C = target
			R.cell.charge = R.cell.charge + (C.charge / 3) //Instant full cell upgrades op idgaf
			qdel(target)
			return
		var/obj/item/I = target //HAHA FUCK IT, NOT LIKE WE ALREADY HAVE A SHITTON OF WAYS TO REMOVE SHIT
		if(!I.anchored && R.emagged)
			R.visible_message("[R] begins chewing up \the [target.name]. Looks like it's trying to loophole around its diet restriction!", "<span class='warning'>You begin chewing up \the [target.name]...</span>")
			if(!do_after(R, 100, target = I)) //Nerf dat time yo
				return //If they moved away, you can't eat them.
			visible_message("<span class='warning'>[R] chews up \the [target.name] and cleans off the debris!</span>")
			to_chat(R, "<span class='notice'>You finish off \the [target.name].</span>")
			qdel(I)
			R.cell.give(500)
			return
		R.visible_message("[R] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
	else if(ishuman(target))
		var/mob/living/L = target
		if(status == 0 && check_zone(R.zone_selected) == "head")
			R.visible_message("<span class='warning'>\the [R] affectionally licks \the [L]'s face!</span>", "<span class='notice'>You affectionally lick \the [L]'s face!</span>")
			playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
			if(istype(L) && L.fire_stacks > 0)
				L.adjust_fire_stacks(-10)
			return
		else if(status == 0)
			R.visible_message("<span class='warning'>\the [R] affectionally licks \the [L]!</span>", "<span class='notice'>You affectionally lick \the [L]!</span>")
			playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
			if(istype(L) && L.fire_stacks > 0)
				L.adjust_fire_stacks(-10)
			return
		else
			if(R.cell.charge <= 800)
				to_chat(R, "Insufficent Power!")
				return
			L.Stun(4) // normal stunbaton is force 7 gimme a break good sir!
			L.DefaultCombatKnockdown(80)
			L.apply_effect(EFFECT_STUTTER, 4)
			L.visible_message("<span class='danger'>[R] has shocked [L] with its tongue!</span>", \
								"<span class='userdanger'>[R] has shocked you with its tongue!</span>")
			playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
			R.cell.use(666)
			log_combat(R, L, "tongue stunned")

	else if(istype(target, /obj/structure/window))
		R.visible_message("[R] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
		if(do_after(user, src.cleanspeed, target = target))
			to_chat(user, "<span class='notice'>You clean \the [target.name].</span>")
			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			target.set_opacity(initial(target.opacity))
	else
		R.visible_message("[R] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
		if(do_after(user, src.cleanspeed, target = target))
			to_chat(user, "<span class='notice'>You clean \the [target.name].</span>")
			var/obj/effect/decal/cleanable/C = locate() in target
			qdel(C)
			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			SEND_SIGNAL(target, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_MEDIUM)
			target.wash_cream()
	return

//Nerfed tongue for flavour reasons (haha geddit?). Used for aux skins for regular borgs
/obj/item/soap/tongue/flavour
	desc = "For giving affectionate kisses."

/obj/item/soap/tongue/flavour/attack_self(mob/user)
	return

/obj/item/soap/tongue/flavour/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	var/mob/living/silicon/robot/R = user
	if(ishuman(target))
		var/mob/living/L = target
		if(status == 0 && check_zone(R.zone_selected) == "head")
			R.visible_message("<span class='warning'>\the [R] affectionally licks \the [L]'s face!</span>", "<span class='notice'>You affectionally lick \the [L]'s face!</span>")
			playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
			return
		else if(status == 0)
			R.visible_message("<span class='warning'>\the [R] affectionally licks \the [L]!</span>", "<span class='notice'>You affectionally lick \the [L]!</span>")
			playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
			return

//Same as above but for noses
/obj/item/analyzer/nose/flavour/AltClick(mob/user)
	return

/obj/item/analyzer/nose/flavour/attack_self(mob/user)
	return

/obj/item/analyzer/nose/flavour/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	do_attack_animation(target, null, src)
	user.visible_message("<span class='notice'>[user] [pick(attack_verb)] \the [target.name] with their nose!</span>")


//Dogfood

/obj/item/trash/rkibble
	name = "robo kibble"
	desc = "A novelty bowl of assorted mech fabricator byproducts. Mockingly feed this to the sec-dog to help it recharge."
	icon = 'icons/mob/dogborg.dmi'
	icon_state= "kibble"

// Pounce stuff for K-9

/obj/item/dogborg/pounce
	name = "pounce"
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "pounce"
	desc = "Leap at your target to momentarily stun them."
	force = 0
	throwforce = 0

/obj/item/dogborg/pounce/New()
	..()
	item_flags |= NOBLUDGEON

/mob/living/silicon/robot
	var/leaping = 0
	var/pounce_cooldown = 0
	var/pounce_cooldown_time = 30 //Time in deciseconds between pounces
	var/pounce_spoolup = 5 //Time in deciseconds for the pounce to happen after clicking
	var/pounce_stamloss_cap = 120 //How much staminaloss pounces alone are capable of bringing a spaceman to
	var/pounce_stamloss = 80 //Base staminaloss value of the pounce
	var/leap_at
	var/disabler
	var/laser
	var/sleeper_g
	var/sleeper_r
	var/sleeper_nv

#define MAX_K9_LEAP_DIST 4 //because something's definitely borked the pounce functioning from a distance.

/obj/item/dogborg/pounce/afterattack(atom/A, mob/user)
	var/mob/living/silicon/robot/R = user
	if(R && (world.time >= R.pounce_cooldown))
		R.pounce_cooldown = world.time + R.pounce_cooldown_time
		to_chat(R, "<span class ='warning'>Your targeting systems lock on to [A]...</span>")
		playsound(R, 'sound/effects/servostep.ogg', 100, TRUE)
		addtimer(CALLBACK(R, /mob/living/silicon/robot.proc/leap_at, A), R.pounce_spoolup)
	else if(R && (world.time < R.pounce_cooldown))
		to_chat(R, "<span class='danger'>Your leg actuators are still recharging!</span>")

/mob/living/silicon/robot/proc/leap_at(atom/A)
	if(leaping || stat || buckled || lying)
		return

	if(!has_gravity(src) || !has_gravity(A))
		to_chat(src,"<span class='danger'>It is unsafe to leap without gravity!</span>")
		//It's also extremely buggy visually, so it's balance+bugfix
		return

	if(cell.charge <= 750)
		to_chat(src,"<span class='danger'>Insufficent reserves for jump actuators!</span>")
		return

	else
		leaping = 1
		weather_immunities += "lava"
		pixel_y = 10
		update_icons()
		throw_at(A, MAX_K9_LEAP_DIST, 1, spin=0, diagonals_first = 1)
		cell.use(750) //Less than a stunbaton since stunbatons hit everytime.
		playsound(src, 'sound/effects/stealthoff.ogg', 25, TRUE, -1)
		weather_immunities -= "lava"

/mob/living/silicon/robot/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)

	if(!leaping)
		return ..()

	if(hit_atom)
		if(isliving(hit_atom))
			var/mob/living/L = hit_atom
			if(!L.check_shields(0, "the [name]", src, attack_type = LEAP_ATTACK))
				L.visible_message("<span class ='danger'>[src] pounces on [L]!</span>", "<span class ='userdanger'>[src] pounces on you!</span>")
				L.DefaultCombatKnockdown(iscarbon(L) ? 60 : 45, override_stamdmg = CLAMP(pounce_stamloss, 0, pounce_stamloss_cap-L.getStaminaLoss())) // Temporary. If someone could rework how dogborg pounces work to accomodate for combat changes, that'd be nice.
				playsound(src, 'sound/weapons/Egloves.ogg', 50, 1)
				sleep(2)//Runtime prevention (infinite bump() calls on hulks)
				step_towards(src,L)
				log_combat(src, L, "borg pounced")
			else
				DefaultCombatKnockdown(15, 1, 1)

			pounce_cooldown = !pounce_cooldown
			spawn(pounce_cooldown_time) //3s by default
				pounce_cooldown = !pounce_cooldown
		else if(hit_atom.density && !hit_atom.CanPass(src))
			visible_message("<span class ='danger'>[src] smashes into [hit_atom]!</span>", "<span class ='userdanger'>You smash into [hit_atom]!</span>")
			playsound(src, 'sound/items/trayhit1.ogg', 50, 1)
			DefaultCombatKnockdown(15, 1, 1)

		if(leaping)
			leaping = 0
			pixel_y = initial(pixel_y)
			update_icons()
			update_mobility()
