
//Harvest; activated ly clicking the target, will try to drain their essence.
/mob/living/simple_animal/revenant/ClickOn(atom/A, params) //revenants can't interact with the world directly.
	A.examine(src)
	if(ishuman(A))
		if(A in drained_mobs)
			src << "<span class='revenwarning'>[A]'s soul is dead and empty.</span>" //feedback at any range
		else if(in_range(src, A))
			Harvest(A)

/mob/living/simple_animal/revenant/proc/Harvest(mob/living/carbon/human/target)
	if(!castcheck(0))
		return
	if(draining)
		src << "<span class='revenwarning'>You are already siphoning the essence of a soul!</span>"
		return
	if(!target.stat)
		src << "<span class='revennotice'>[target.p_their(TRUE)] soul is too strong to harvest.</span>"
		if(prob(10))
			target << "You feel as if you are being watched."
		return
	draining = 1
	essence_drained += rand(15, 20)
	src << "<span class='revennotice'>You search for the soul of [target].</span>"
	if(do_after(src, rand(10, 20), 0, target)) //did they get deleted in that second?
		if(target.ckey)
			src << "<span class='revennotice'>[target.p_their(TRUE)] soul burns with intelligence.</span>"
			essence_drained += rand(20, 30)
		if(target.stat != DEAD)
			src << "<span class='revennotice'>[target.p_their(TRUE)] soul blazes with life!</span>"
			essence_drained += rand(40, 50)
		else
			src << "<span class='revennotice'>[target.p_their(TRUE)] soul is weak and faltering.</span>"
		if(do_after(src, rand(15, 20), 0, target)) //did they get deleted NOW?
			switch(essence_drained)
				if(1 to 30)
					src << "<span class='revennotice'>[target] will not yield much essence. Still, every bit counts.</span>"
				if(30 to 70)
					src << "<span class='revennotice'>[target] will yield an average amount of essence.</span>"
				if(70 to 90)
					src << "<span class='revenboldnotice'>Such a feast! [target] will yield much essence to you.</span>"
				if(90 to INFINITY)
					src << "<span class='revenbignotice'>Ah, the perfect soul. [target] will yield massive amounts of essence to you.</span>"
			if(do_after(src, rand(15, 25), 0, target)) //how about now
				if(!target.stat)
					src << "<span class='revenwarning'>[target.p_they(TRUE)] [target.p_are()] now powerful enough to fight off your draining.</span>"
					target << "<span class='boldannounce'>You feel something tugging across your body before subsiding.</span>"
					draining = 0
					essence_drained = 0
					return //hey, wait a minute...
				src << "<span class='revenminor'>You begin siphoning essence from [target]'s soul.</span>"
				if(target.stat != DEAD)
					target << "<span class='warning'>You feel a horribly unpleasant draining sensation as your grip on life weakens...</span>"
				reveal(46)
				stun(46)
				target.visible_message("<span class='warning'>[target] suddenly rises slightly into the air, [target.p_their()] skin turning an ashy gray.</span>")
				var/datum/beam/B = Beam(target,icon_state="drain_life",time=INFINITY)
				if(do_after(src, 46, 0, target)) //As one cannot prove the existance of ghosts, ghosts cannot prove the existance of the target they were draining.
					change_essence_amount(essence_drained, 0, target)
					if(essence_drained <= 90 && target.stat != DEAD)
						essence_regen_cap += 5
						src << "<span class='revenboldnotice'>The absorption of [target]'s living soul has increased your maximum essence level. Your new maximum essence is [essence_regen_cap].</span>"
					if(essence_drained > 90)
						essence_regen_cap += 15
						perfectsouls += 1
						src << "<span class='revenboldnotice'>The perfection of [target]'s soul has increased your maximum essence level. Your new maximum essence is [essence_regen_cap].</span>"
					src << "<span class='revennotice'>[target]'s soul has been considerably weakened and will yield no more essence for the time being.</span>"
					target.visible_message("<span class='warning'>[target] slumps onto the ground.</span>", \
										   "<span class='revenwarning'>Violets lights, dancing in your vision, getting clo--</span>")
					drained_mobs.Add(target)
					target.death(0)
				else
					src << "<span class='revenwarning'>[target ? "[target] has":"They have"] been drawn out of your grasp. The link has been broken.</span>"
					if(target) //Wait, target is WHERE NOW?
						target.visible_message("<span class='warning'>[target] slumps onto the ground.</span>", \
											   "<span class='revenwarning'>Violets lights, dancing in your vision, receding--</span>")
				qdel(B)
			else
				src << "<span class='revenwarning'>You are not close enough to siphon [target ? "[target]'s":"their"] soul. The link has been broken.</span>"
	draining = 0
	essence_drained = 0

//Toggle night vision: lets the revenant toggle its night vision
/obj/effect/proc_holder/spell/targeted/night_vision/revenant
	charge_max = 0
	panel = "Revenant Abilities"
	message = "<span class='revennotice'>You toggle your night vision.</span>"
	action_icon_state = "r_nightvision"
	action_background_icon_state = "bg_revenant"

//Transmit: the revemant's only direct way to communicate. Sends a single message silently to a single mob
/obj/effect/proc_holder/spell/targeted/revenant_transmit
	name = "Transmit"
	desc = "Telepathically transmits a message to the target."
	panel = "Revenant Abilities"
	charge_max = 0
	clothes_req = 0
	range = 7
	include_user = 0
	action_icon_state = "r_transmit"
	action_background_icon_state = "bg_revenant"

/obj/effect/proc_holder/spell/targeted/revenant_transmit/cast(list/targets, mob/living/simple_animal/revenant/user = usr)
	for(var/mob/living/M in targets)
		var/msg = stripped_input(usr, "What do you wish to tell [M]?", null, "")
		if(!msg)
			charge_counter = charge_max
			return
		log_say("RevenantTransmit: [key_name(user)]->[key_name(M)] : [msg]")
		user << "<span class='revenboldnotice'>You transmit to [M]:</span> <span class='revennotice'>[msg]</span>"
		M << "<span class='revenboldnotice'>You hear something behind you talking...</span> <span class='revennotice'>[msg]</span>"
		for(var/ded in dead_mob_list)
			if(!isobserver(ded))
				continue
			var/follow_rev = FOLLOW_LINK(ded, user)
			var/follow_whispee = FOLLOW_LINK(ded, M)
			ded << "[follow_rev] <span class='revenboldnotice'>[user] Revenant Transmit:</span> <span class='revennotice'>\"[msg]\" to</span> [follow_whispee] <span class='name'>[M]</span>"



/obj/effect/proc_holder/spell/aoe_turf/revenant
	clothes_req = 0
	action_background_icon_state = "bg_revenant"
	panel = "Revenant Abilities (Locked)"
	name = "Report this to a coder"
	var/reveal = 80 //How long it reveals the revenant in deciseconds
	var/stun = 20 //How long it stuns the revenant in deciseconds
	var/locked = 1 //If it's locked and needs to be unlocked before use
	var/unlock_amount = 100 //How much essence it costs to unlock
	var/cast_amount = 50 //How much essence it costs to use

/obj/effect/proc_holder/spell/aoe_turf/revenant/New()
	..()
	if(locked)
		name = "[initial(name)] ([unlock_amount]E)"
	else
		name = "[initial(name)] ([cast_amount]E)"

/obj/effect/proc_holder/spell/aoe_turf/revenant/can_cast(mob/living/simple_animal/revenant/user = usr)
	if(!istype(user)) //Badmins, no. Badmins, don't do it.
		if(charge_counter < charge_max)
			return 0
		return 1
	if(user.inhibited)
		return 0
	if(charge_counter < charge_max)
		return 0
	if(locked)
		if(user.essence <= unlock_amount)
			return 0
	if(user.essence <= cast_amount)
		return 0
	return 1

/obj/effect/proc_holder/spell/aoe_turf/revenant/proc/attempt_cast(mob/living/simple_animal/revenant/user = usr)
	if(!istype(user)) //If you're not a revenant, it works. Please, please, please don't give this to a non-revenant.
		name = "[initial(name)]"
		if(locked)
			panel = "Revenant Abilities"
			locked = 0
		return 1
	if(locked)
		if(!user.castcheck(-unlock_amount))
			charge_counter = charge_max
			return 0
		name = "[initial(name)] ([cast_amount]E)"
		user << "<span class='revennotice'>You have unlocked [initial(name)]!</span>"
		panel = "Revenant Abilities"
		locked = 0
		charge_counter = charge_max
		return 0
	if(!user.castcheck(-cast_amount))
		charge_counter = charge_max
		return 0
	name = "[initial(name)] ([cast_amount]E)"
	user.reveal(reveal)
	user.stun(stun)
	if(action)
		action.UpdateButtonIcon()
	return 1

//Overload Light: Breaks a light that's online and sends out lightning bolts to all nearby people.
/obj/effect/proc_holder/spell/aoe_turf/revenant/overload
	name = "Overload Lights"
	desc = "Directs a large amount of essence into nearby electrical lights, causing lights to shock those nearby."
	charge_max = 200
	range = 5
	stun = 30
	cast_amount = 40
	var/shock_range = 2
	var/shock_damage = 15
	action_icon_state = "overload_lights"

/obj/effect/proc_holder/spell/aoe_turf/revenant/overload/cast(list/targets, mob/living/simple_animal/revenant/user = usr)
	if(attempt_cast(user))
		for(var/turf/T in targets)
			INVOKE_ASYNC(src, .proc/overload, T, user)

/obj/effect/proc_holder/spell/aoe_turf/revenant/overload/proc/overload(turf/T, mob/user)
	for(var/obj/machinery/light/L in T)
		if(!L.on)
			return
		L.visible_message("<span class='warning'><b>\The [L] suddenly flares brightly and begins to spark!</span>")
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(4, 0, L)
		s.start()
		new /obj/effect/overlay/temp/revenant(L.loc)
		sleep(20)
		if(!L.on) //wait, wait, don't shock me
			return
		flick("[L.base_state]2", L)
		for(var/mob/living/carbon/human/M in view(shock_range, L))
			if(M == user)
				continue
			L.Beam(M,icon_state="purple_lightning",time=5)
			M.electrocute_act(shock_damage, L, safety=1)
			var/datum/effect_system/spark_spread/z = new /datum/effect_system/spark_spread
			z.set_up(4, 0, M)
			z.start()
			playsound(M, 'sound/machines/defib_zap.ogg', 50, 1, -1)

//Defile: Corrupts nearby stuff, unblesses floor tiles.
/obj/effect/proc_holder/spell/aoe_turf/revenant/defile
	name = "Defile"
	desc = "Twists and corrupts the nearby area as well as dispelling holy auras on floors."
	charge_max = 150
	range = 4
	stun = 20
	reveal = 40
	unlock_amount = 75
	cast_amount = 30
	action_icon_state = "defile"

/obj/effect/proc_holder/spell/aoe_turf/revenant/defile/cast(list/targets, mob/living/simple_animal/revenant/user = usr)
	if(attempt_cast(user))
		for(var/turf/T in targets)
			INVOKE_ASYNC(src, .proc/defile, T)

/obj/effect/proc_holder/spell/aoe_turf/revenant/defile/proc/defile(turf/T)
	if(T.flags & NOJAUNT)
		T.flags -= NOJAUNT
		new /obj/effect/overlay/temp/revenant(T)
	if(!istype(T, /turf/open/floor/plating) && !istype(T, /turf/open/floor/engine/cult) && isfloorturf(T) && prob(15))
		var/turf/open/floor/floor = T
		if(floor.intact && floor.floor_tile)
			new floor.floor_tile(floor)
		floor.broken = 0
		floor.burnt = 0
		floor.make_plating(1)
	if(T.type == /turf/closed/wall && prob(15))
		new /obj/effect/overlay/temp/revenant(T)
		T.ChangeTurf(/turf/closed/wall/rust)
	if(T.type == /turf/closed/wall/r_wall && prob(10))
		new /obj/effect/overlay/temp/revenant(T)
		T.ChangeTurf(/turf/closed/wall/r_wall/rust)
	for(var/obj/structure/closet/closet in T.contents)
		closet.open()
	for(var/obj/structure/bodycontainer/corpseholder in T)
		if(corpseholder.connected.loc == corpseholder)
			corpseholder.open()
	for(var/obj/machinery/dna_scannernew/dna in T)
		dna.open_machine()
	for(var/obj/structure/window/window in T)
		window.take_damage(rand(30,80))
		if(window && window.fulltile)
			new /obj/effect/overlay/temp/revenant/cracks(window.loc)
	for(var/obj/machinery/light/light in T)
		light.flicker(20) //spooky

//Malfunction: Makes bad stuff happen to robots and machines.
/obj/effect/proc_holder/spell/aoe_turf/revenant/malfunction
	name = "Malfunction"
	desc = "Corrupts and damages nearby machines and mechanical objects."
	charge_max = 200
	range = 4
	cast_amount = 60
	unlock_amount = 200
	action_icon_state = "malfunction"

//A note to future coders: do not replace this with an EMP because it will wreck malf AIs and gang dominators and everyone will hate you.
/obj/effect/proc_holder/spell/aoe_turf/revenant/malfunction/cast(list/targets, mob/living/simple_animal/revenant/user = usr)
	if(attempt_cast(user))
		for(var/turf/T in targets)
			INVOKE_ASYNC(src, .proc/malfunction, T, user)

/obj/effect/proc_holder/spell/aoe_turf/revenant/malfunction/proc/malfunction(turf/T, mob/user)
	for(var/mob/living/simple_animal/bot/bot in T)
		if(!bot.emagged)
			new /obj/effect/overlay/temp/revenant(bot.loc)
			bot.locked = 0
			bot.open = 1
			bot.emag_act()
	for(var/mob/living/carbon/human/human in T)
		if(human == user)
			continue
		human << "<span class='revenwarning'>You feel [pick("your sense of direction flicker out", "a stabbing pain in your head", "your mind fill with static")].</span>"
		new /obj/effect/overlay/temp/revenant(human.loc)
		human.emp_act(1)
	for(var/obj/thing in T)
		if(istype(thing, /obj/machinery/dominator) || istype(thing, /obj/machinery/power/apc) || istype(thing, /obj/machinery/power/smes)) //Doesn't work on dominators, SMES and APCs, to prevent kekkery
			continue
		if(prob(20))
			if(prob(50))
				new /obj/effect/overlay/temp/revenant(thing.loc)
			thing.emag_act(null)
		else
			if(!istype(thing, /obj/machinery/clonepod)) //I hate everything but mostly the fact there's no better way to do this without just not affecting it at all
				thing.emp_act(1)
	for(var/mob/living/silicon/robot/S in T) //Only works on cyborgs, not AI
		playsound(S, 'sound/machines/warning-buzzer.ogg', 50, 1)
		new /obj/effect/overlay/temp/revenant(S.loc)
		S.spark_system.start()
		S.emp_act(1)

//Blight: Infects nearby humans and in general messes living stuff up.
/obj/effect/proc_holder/spell/aoe_turf/revenant/blight
	name = "Blight"
	desc = "Causes nearby living things to waste away."
	charge_max = 200
	range = 3
	cast_amount = 50
	unlock_amount = 200
	action_icon_state = "blight"

/obj/effect/proc_holder/spell/aoe_turf/revenant/blight/cast(list/targets, mob/living/simple_animal/revenant/user = usr)
	if(attempt_cast(user))
		for(var/turf/T in targets)
			INVOKE_ASYNC(src, .proc/blight, T, user)

/obj/effect/proc_holder/spell/aoe_turf/revenant/blight/proc/blight(turf/T, mob/user)
	for(var/mob/living/mob in T)
		if(mob == user)
			continue
		new /obj/effect/overlay/temp/revenant(mob.loc)
		if(iscarbon(mob))
			if(ishuman(mob))
				var/mob/living/carbon/human/H = mob
				if(H.dna && H.dna.species)
					H.dna.species.handle_hair(H,"#1d2953") //will be reset when blight is cured
				var/blightfound = 0
				for(var/datum/disease/revblight/blight in H.viruses)
					blightfound = 1
					if(blight.stage < 5)
						blight.stage++
				if(!blightfound)
					H.AddDisease(new /datum/disease/revblight)
					H << "<span class='revenminor'>You feel [pick("suddenly sick", "a surge of nausea", "like your skin is <i>wrong</i>")].</span>"
			else
				if(mob.reagents)
					mob.reagents.add_reagent("plasma", 5)
		else
			mob.adjustToxLoss(5)
	for(var/obj/structure/spacevine/vine in T) //Fucking with botanists, the ability.
		vine.add_atom_colour("#823abb", TEMPORARY_COLOUR_PRIORITY)
		new /obj/effect/overlay/temp/revenant(vine.loc)
		QDEL_IN(vine, 10)
	for(var/obj/structure/glowshroom/shroom in T)
		shroom.add_atom_colour("#823abb", TEMPORARY_COLOUR_PRIORITY)
		new /obj/effect/overlay/temp/revenant(shroom.loc)
		QDEL_IN(shroom, 10)
	for(var/obj/machinery/hydroponics/tray in T)
		new /obj/effect/overlay/temp/revenant(tray.loc)
		tray.pestlevel = rand(8, 10)
		tray.weedlevel = rand(8, 10)
		tray.toxic = rand(45, 55)
