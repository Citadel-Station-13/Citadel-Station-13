/obj/item/dogborg/jaws/big
	name = "combat jaws"
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "jaws"
	desc = "The jaws of the law."
	flags_1 = CONDUCT_1
	force = 12
	throwforce = 0
	hitsound = 'sound/weapons/bite.ogg'
	attack_verb = list("chomped", "bit", "ripped", "mauled", "enforced")
	w_class = 3
	sharpness = IS_SHARP

/obj/item/dogborg/jaws/small
	name = "puppy jaws"
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "smalljaws"
	desc = "The jaws of a small dog."
	flags_1 = CONDUCT_1
	force = 6
	throwforce = 0
	hitsound = 'sound/weapons/bite.ogg'
	attack_verb = list("nibbled", "bit", "gnawed", "chomped", "nommed")
	w_class = 3
	sharpness = IS_SHARP

/obj/item/dogborg/jaws/attack(atom/A, mob/living/silicon/robot/user)
	..()
	user.do_attack_animation(A, ATTACK_EFFECT_BITE)

/obj/item/dogborg/jaws/small/attack_self(mob/user)
	var/mob/living/silicon/robot.R = user
	if(R.emagged)
		emagged = !emagged
		if(emagged)
			name = "combat jaws"
			icon = 'icons/mob/dogborg.dmi'
			icon_state = "jaws"
			desc = "The jaws of the law."
			flags_1 = CONDUCT_1
			force = 12
			throwforce = 0
			hitsound = 'sound/weapons/bite.ogg'
			attack_verb = list("chomped", "bit", "ripped", "mauled", "enforced")
			w_class = 3
			sharpness = IS_SHARP
		else
			name = "puppy jaws"
			icon = 'icons/mob/dogborg.dmi'
			icon_state = "smalljaws"
			desc = "The jaws of a small dog."
			flags_1 = CONDUCT_1
			force = 5
			throwforce = 0
			hitsound = 'sound/weapons/bite.ogg'
			attack_verb = list("nibbled", "bit", "gnawed", "chomped", "nommed")
			w_class = 3
			sharpness = IS_SHARP
		update_icon()


//Cuffs

/obj/item/restraints/handcuffs/cable/zipties/cyborg/dog/attack(mob/living/carbon/C, mob/user)
	if(!C.handcuffed)
		playsound(loc, 'sound/weapons/cablecuff.ogg', 30, 1, -2)
		C.visible_message("<span class='danger'>[user] is trying to put zipties on [C]!</span>", \
							"<span class='userdanger'>[user] is trying to put zipties on [C]!</span>")
		if(do_mob(user, C, 30))
			if(!C.handcuffed)
				C.handcuffed = new /obj/item/restraints/handcuffs/cable/zipties/used(C)
				C.update_inv_handcuffed(0)
				to_chat(user,"<span class='notice'>You handcuff [C].</span>")
				playsound(loc, pick('sound/voice/bgod.ogg', 'sound/voice/biamthelaw.ogg', 'sound/voice/bsecureday.ogg', 'sound/voice/bradio.ogg', 'sound/voice/binsult.ogg', 'sound/voice/bcreep.ogg'), 50, 0)
				add_logs(user, C, "handcuffed")
		else
			to_chat(user,"<span class='warning'>You fail to handcuff [C]!</span>")


//Boop

/obj/item/device/analyzer/nose
	name = "boop module"
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "nose"
	desc = "The BOOP module"
	flags_1 = CONDUCT_1
	force = 0
	throwforce = 0
	attack_verb = list("nuzzled", "nosed", "booped")
	w_class = 1

/obj/item/device/analyzer/nose/attack_self(mob/user)
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

		environment.assert_gases(arglist(GLOB.hardcoded_gases))
		var/o2_concentration = env_gases[/datum/gas/oxygen][MOLES]/total_moles
		var/n2_concentration = env_gases[/datum/gas/nitrogen][MOLES]/total_moles
		var/co2_concentration = env_gases[/datum/gas/carbon_dioxide][MOLES]/total_moles
		var/plasma_concentration = env_gases[/datum/gas/plasma][MOLES]/total_moles
		environment.garbage_collect()

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
			var/gas_concentration = env_gases[id][MOLES]/total_moles
			to_chat(user, "<span class='alert'>[env_gases[id][GAS_META][META_GAS_NAME]]: [round(gas_concentration*100, 0.01)] %</span>")
		to_chat(user, "<span class='info'>Temperature: [round(environment.temperature-T0C)] &deg;C</span>")


//Delivery

/obj/item/storage/bag/borgdelivery
	name = "fetching storage"
	desc = "Fetch the thing!"
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "dbag"
	//Can hold one big item at a time. Drops contents on unequip.(see inventory.dm)
	w_class = 5
	max_w_class = 2
	max_combined_w_class = 2
	storage_slots = 1
	collection_mode = 0
	can_hold = list() // any
	cant_hold = list(/obj/item/disk/nuclear)


//Tongue stuff

/obj/item/soap/tongue
	name = "synthetic tongue"
	desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "synthtongue"
	hitsound = 'sound/effects/attackblob.ogg'
	cleanspeed = 80

/obj/item/soap/tongue/scrubpup
	cleanspeed = 25 //slightly faster than a mop.

/obj/item/soap/tongue/New()
	..()
	flags_1 |= NOBLUDGEON_1 //No more attack messages

/obj/item/trash/rkibble
	name = "robo kibble"
	desc = "A novelty bowl of assorted mech fabricator byproducts. Mockingly feed this to the sec-dog to help it recharge."
	icon = 'icons/mob/dogborg.dmi'
	icon_state= "kibble"

/obj/item/soap/tongue/attack_self(mob/user)
	var/mob/living/silicon/robot.R = user
	if(R.emagged)
		emagged = !emagged
		if(emagged)
			name = "hacked tongue of doom"
			desc = "Your tongue has been upgraded successfully. Congratulations."
			icon = 'icons/mob/dogborg.dmi'
			icon_state = "syndietongue"
			cleanspeed = 10 //(nerf'd)tator soap stat
		else
			name = "synthetic tongue"
			desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
			icon = 'icons/mob/dogborg.dmi'
			icon_state = "synthtongue"
			cleanspeed = initial(cleanspeed)
		update_icon()

/obj/item/soap/tongue/afterattack(atom/target, mob/user, proximity)
	if(!proximity || !check_allowed_items(target))
		return
	if(user.client && (target in user.client.screen))
		to_chat(user, "<span class='warning'>You need to take that [target.name] off before cleaning it!</span>")
	else if(istype(target,/obj/effect/decal/cleanable))
		user.visible_message("[user] begins to lick off \the [target.name].", "<span class='warning'>You begin to lick off \the [target.name]...</span>")
		if(do_after(user, src.cleanspeed, target = target))
			if(!in_range(src, target)) //Proximity is probably old news by now, do a new check.
				return //If they moved away, you can't eat them.
			to_chat(user, "<span class='notice'>You finish licking off \the [target.name].</span>")
			qdel(target)
			var/mob/living/silicon/robot.R = user
			R.cell.give(50)
	else if(istype(target,/obj/item)) //hoo boy. danger zone man
		if(istype(target,/obj/item/trash))
			user.visible_message("[user] nibbles away at \the [target.name].", "<span class='warning'>You begin to nibble away at \the [target.name]...</span>")
			if(do_after(user, src.cleanspeed, target = target))
				if(!in_range(src, target)) //Proximity is probably old news by now, do a new check.
					return //If they moved away, you can't eat them.
				to_chat(user, "<span class='notice'>You finish off \the [target.name].</span>")
				qdel(target)
				var/mob/living/silicon/robot.R = user
				R.cell.give(250)
			return
		if(istype(target,/obj/item/stock_parts/cell))
			user.visible_message("[user] begins cramming \the [target.name] down its throat.", "<span class='warning'>You begin cramming \the [target.name] down your throat...</span>")
			if(do_after(user, 50, target = target))
				if(!in_range(src, target)) //Proximity is probably old news by now, do a new check.
					return //If they moved away, you can't eat them.
				to_chat(user, "<span class='notice'>You finish off \the [target.name].</span>")
				var/mob/living/silicon/robot.R = user
				var/obj/item/stock_parts/cell.C = target
				R.cell.charge = R.cell.charge + (C.charge / 3) //Instant full cell upgrades op idgaf
				qdel(target)
			return
		var/obj/item/I = target //HAHA FUCK IT, NOT LIKE WE ALREADY HAVE A SHITTON OF WAYS TO REMOVE SHIT
		if(!I.anchored && src.emagged)
			user.visible_message("[user] begins chewing up \the [target.name]. Looks like it's trying to loophole around its diet restriction!", "<span class='warning'>You begin chewing up \the [target.name]...</span>")
			if(do_after(user, 100, target = I)) //Nerf dat time yo
				if(!in_range(src, target)) //Proximity is probably old news by now, do a new check. Even emags don't make you magically eat things at range.
					return //If they moved away, you can't eat them.
				visible_message("<span class='warning'>[user] chews up \the [target.name] and cleans off the debris!</span>")
				to_chat(user, "<span class='notice'>You finish off \the [target.name].</span>")
				qdel(I)
				var/mob/living/silicon/robot.R = user
				R.cell.give(500)
			return
		user.visible_message("[user] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
		if(do_after(user, src.cleanspeed, target = target))
			if(!in_range(src, target)) //Proximity is probably old news by now, do a new check.
				return //If they moved away, you can't clean them.
			to_chat(user,"<span class='notice'>You clean \the [target.name].</span>")
			var/obj/effect/decal/cleanable/C = locate() in target
			qdel(C)
			target.clean_blood()
	else if(ishuman(target))
		if(src.emagged)
			var/mob/living/silicon/robot.R = user
			var/mob/living/L = target
			if(R.cell.charge <= 666)
				return
			L.Stun(4) // normal stunbaton is force 7 gimme a break good sir!
			L.Knockdown(80)
			L.apply_effect(STUTTER, 4)
			L.visible_message("<span class='danger'>[user] has shocked [L] with its tongue!</span>", \
								"<span class='userdanger'>[user] has shocked you with its tongue! You can feel the betrayal.</span>")
			playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
			R.cell.use(666)
		else
			user.visible_message("<span class='warning'>\the [user] affectionally licks \the [target]'s face!</span>", "<span class='notice'>You affectionally lick \the [target]'s face!</span>")
			playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
			return
	else if(istype(target, /obj/structure/window))
		user.visible_message("[user] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
		if(do_after(user, src.cleanspeed, target = target))
			if(!in_range(src, target)) //Proximity is probably old news by now, do a new check.
				return //If they moved away, you can't clean them.
			to_chat(user, "<span class='notice'>You clean \the [target.name].</span>")
			target.color = initial(target.color)
	else
		user.visible_message("[user] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
		if(do_after(user, src.cleanspeed, target = target))
			if(!in_range(src, target)) //Proximity is probably old news by now, do a new check.
				return //If they moved away, you can't clean them.
			to_chat(user, "<span class='notice'>You clean \the [target.name].</span>")
			var/obj/effect/decal/cleanable/C = locate() in target
			qdel(C)
			target.clean_blood()
	return



//Defibs

/obj/item/twohanded/shockpaddles/hound
	name = "defibrillator paws"
	desc = "MediHound specific shock paws."
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "defibpaddles0"
	item_state = "defibpaddles0"
	req_defib = 0
	wielded = 1

/obj/item/twohanded/shockpaddles/hound/attack(mob/M, mob/user)
	var/mob/living/silicon/robot.R = user
	if(R.cell.charge < 1000)
		user.visible_message("<span class='warning'>You don't have enough charge for this operation!</span class>")
		return
	if(src.cooldown == 0)
		R.cell.use(1000)
	return ..()


//Sleeper

/obj/item/device/dogborg/sleeper
	name = "hound sleeper"
	desc = "nothing should see this."
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "sleeper"
	w_class = WEIGHT_CLASS_TINY
	var/mob/living/carbon/patient = null
	var/mob/living/silicon/robot/hound = null
	var/inject_amount = 10
	var/min_health = -100
	var/cleaning = FALSE
	var/cleaning_cycles = 10
	var/patient_laststat = null
	var/list/injection_chems = list("antitoxin", "epinephrine", "morphine", "salbutamol", "bicaridine", "kelotane")
	var/eject_port = "ingestion"
	var/escape_in_progress = FALSE
	var/message_cooldown
	var/breakout_time = 300
	var/list/items_preserved = list(
		/obj/item/hand_tele,
		/obj/item/card/id,
		/obj/item/device/pda,
		/obj/item/device/aicard,
		/obj/item/gun,
		/obj/item/pinpointer,
		/obj/item/clothing/shoes/magboots,
		/obj/item/clothing/head/helmet/space,
		/obj/item/clothing/suit/space,
		/obj/item/reagent_containers/hypospray/CMO,
		/obj/item/tank/jetpack/oxygen/captain,
		/obj/item/clothing/accessory/medal/gold/captain,
		/obj/item/clothing/suit/armor,
		/obj/item/documents,
		/obj/item/nuke_core,
		/obj/item/nuke_core_container,
		/obj/item/areaeditor/blueprints,
		/obj/item/documents/syndicate,
		/obj/item/disk/nuclear,
		/obj/item/bombcore,
		/obj/item/grenade
		)

	var/list/important_items = list(
		/obj/item/hand_tele,
		/obj/item/card/id/captains_spare,
		/obj/item/device/aicard,
		/obj/item/gun,
		/obj/item/pinpointer,
		/obj/item/clothing/shoes/magboots,
		/obj/item/clothing/head/helmet/space,
		/obj/item/clothing/suit/space,
		/obj/item/reagent_containers/hypospray/CMO,
		/obj/item/tank/jetpack/oxygen/captain,
		/obj/item/clothing/accessory/medal/gold/captain,
		/obj/item/clothing/suit/armor,
		/obj/item/documents,
		/obj/item/nuke_core,
		/obj/item/nuke_core_container,
		/obj/item/areaeditor/blueprints,
		/obj/item/documents/syndicate,
		/obj/item/disk/nuclear,
		/obj/item/bombcore,
		/obj/item/grenade
		)

/obj/item/device/dogborg/sleeper/New()
	..()
	update_icon()
	flags_1 |= NOBLUDGEON_1 //No more attack messages

/obj/item/device/dogborg/sleeper/Exit(atom/movable/O)
	return 0

/obj/item/device/dogborg/sleeper/afterattack(mob/living/carbon/target, mob/living/silicon/user, proximity)
	hound = loc
	if(!proximity)
		return
	if(!ishuman(target))
		return
	if(target.buckled)
		to_chat(user, "<span class='warning'>The user is buckled and can not be put into your [src.name].</span>")
		return
	if(patient)
		to_chat(user, "<span class='warning'>Your [src.name] is already occupied.</span>")
		return
	user.visible_message("<span class='warning'>[hound.name] is carefully inserting [target.name] into their [src.name].</span>", "<span class='notice'>You start placing [target] into your [src]...</span>")
	if(!patient && ishuman(target) && !target.buckled && do_after (user, 50, target = target))

		if(!in_range(src, target)) //Proximity is probably old news by now, do a new check.
			return //If they moved away, you can't eat them.

		if(patient) return //If you try to eat two people at once, you can only eat one.

		else //If you don't have someone in you, proceed.
			if(!isslimeperson(target) && ("toxin" in injection_chems))
				injection_chems -= "toxin"
				injection_chems += "antitoxin"
			if(isslimeperson(target) && !("toxin" in injection_chems))
				injection_chems -= "antitoxin"
				injection_chems += "toxin"
			target.forceMove(src)
			target.reset_perspective(src)
			update_gut()
			START_PROCESSING(SSobj, src)
			user.visible_message("<span class='warning'>[hound.name]'s medical pod lights up and expands as [target.name] slips inside into their [src.name].</span>", "<span class='notice'>Your medical pod lights up as [target] slips into your [src]. Life support functions engaged.</span>")
			message_admins("[key_name(hound)] has eaten [key_name(patient)] as a dogborg. ([hound ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[hound.x];Y=[hound.y];Z=[hound.z]'>JMP</a>" : "null"])")
			playsound(hound, 'sound/effects/bin_close.ogg', 100, 1)

/obj/item/device/dogborg/sleeper/container_resist(mob/living/user)
	hound = loc
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	if(user.a_intent == INTENT_HELP)
		return
	user.visible_message("<span class='notice'>You see [user] kicking against the expanded material of [hound.name]'s gut!</span>", \
		"<span class='notice'>You struggle inside [src], kicking the release with your foot... (this will take about [DisplayTimeText(breakout_time)].)</span>", \
		"<span class='italics'>You hear a thump from [hound.name].</span>")
	if(do_after(user, breakout_time, target = src))
		if(!user || user.stat != CONSCIOUS || user.loc != src )
			return
		user.visible_message("<span class='warning'>[user] successfully broke out of [hound.name]!</span>", \
			"<span class='notice'>You successfully break out of [hound.name]!</span>")
		go_out()

/obj/item/device/dogborg/sleeper/proc/go_out(var/target)
	hound = src.loc
	testing("go_out activated")
	hound.setClickCooldown(50)
	if(length(contents) > 0)
		hound.visible_message("<span class='warning'>[hound.name] empties out their contents via their release port.</span>", "<span class='notice'>You empty your contents via your release port.</span>")
		if(target)
			if(ishuman(target))
				var/mob/living/carbon/human/person = target
				person.forceMove(get_turf(src))
				person.reset_perspective()
			else
				var/obj/T = target
				T.loc = hound.loc
		else
			for(var/C in contents)
				if(ishuman(C))
					var/mob/living/carbon/human/person = C
					person.forceMove(get_turf(src))
					person.reset_perspective()
				else
					var/obj/T = C
					T.loc = hound.loc
		items_preserved.Cut()
		update_gut()
		cleaning = FALSE
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)

	else //You clicked eject with nothing in you, let's just reset stuff to be sure.
		items_preserved.Cut()
		cleaning = FALSE
		hound.visible_message("<span class='warning'>[hound.name] belches, torso flexing.</span>")
		update_gut()

/obj/item/device/dogborg/sleeper/attack_self(mob/user)
	if(..())
		return
	ui_interact(user)

/obj/item/device/dogborg/sleeper/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
									datum/tgui/master_ui = null, datum/ui_state/state = GLOB.notcontained_state)

	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "dogborg_sleeper", name, 375, 550, master_ui, state)
		ui.open()

/obj/item/device/dogborg/sleeper/ui_data()
	var/list/data = list()
	data["occupied"] = patient ? 1 : 0

	if(cleaning && length(contents - items_preserved))
		data["items"] = "Self-cleaning mode active: [length(contents - items_preserved)] object(s) remaining."
	data["cleaning"] = cleaning
	if(injection_chems != null)
		data["chem"] = list()
		for(var/chem in injection_chems)
			var/datum/reagent/R = GLOB.chemical_reagents_list[chem]
			data["chem"] += list(list("name" = R.name, "id" = R.id))

	data["occupant"] = list()
	var/mob/living/mob_occupant = patient
	if(mob_occupant)
		data["occupant"]["name"] = mob_occupant.name
		switch(mob_occupant.stat)
			if(CONSCIOUS)
				data["occupant"]["stat"] = "Conscious"
				data["occupant"]["statstate"] = "good"
			if(SOFT_CRIT)
				data["occupant"]["stat"] = "Conscious"
				data["occupant"]["statstate"] = "average"
			if(UNCONSCIOUS)
				data["occupant"]["stat"] = "Unconscious"
				data["occupant"]["statstate"] = "average"
			if(DEAD)
				data["occupant"]["stat"] = "Dead"
				data["occupant"]["statstate"] = "bad"
		data["occupant"]["health"] = mob_occupant.health
		data["occupant"]["maxHealth"] = mob_occupant.maxHealth
		data["occupant"]["minHealth"] = HEALTH_THRESHOLD_DEAD
		data["occupant"]["bruteLoss"] = mob_occupant.getBruteLoss()
		data["occupant"]["oxyLoss"] = mob_occupant.getOxyLoss()
		data["occupant"]["toxLoss"] = mob_occupant.getToxLoss()
		data["occupant"]["fireLoss"] = mob_occupant.getFireLoss()
		data["occupant"]["cloneLoss"] = mob_occupant.getCloneLoss()
		data["occupant"]["brainLoss"] = mob_occupant.getBrainLoss()
		data["occupant"]["reagents"] = list()
		if(mob_occupant.reagents.reagent_list.len)
			for(var/datum/reagent/R in mob_occupant.reagents.reagent_list)
				data["occupant"]["reagents"] += list(list("name" = R.name, "volume" = R.volume))
	return data

/obj/item/device/dogborg/sleeper/ui_act(action, params)
	if(..())
		return

	switch(action)
		if("eject")
			go_out()
			. = TRUE
		if("inject")
			var/chem = params["chem"]
			if(!patient)
				return
			inject_chem(chem)
			. = TRUE
		if("cleaning")
			testing("cleaning attempted")
			if(!contents)
				testing("cleaning has no contents")
				to_chat(src, "Your [src] is already cleaned.")
				return
			if(patient)
				to_chat(patient, "<span class='danger'>[hound.name]'s [src.name] fills with caustic enzymes around you!</span>")
				testing("clean_cycle activated")
			to_chat(src, "<span class='danger'>Cleaning process enabled.</span>")
			clean_cycle()
			. = TRUE

/obj/item/device/dogborg/sleeper/proc/update_gut()
	testing("update_gut proc fired")
	//Well, we HAD one, what happened to them?
	if(patient in contents)
		if(patient_laststat != patient.stat)
			if(patient.stat & DEAD)
				hound.sleeper_r = 1
				hound.sleeper_g = 0
				patient_laststat = patient.stat
			else
				hound.sleeper_r = 0
				hound.sleeper_g = 1
				patient_laststat = patient.stat
			//Update icon
			hound.update_icons()
		//Return original patient
		return(patient)

	//Check for a new patient
	else
		for(var/mob/living/carbon/human/C in contents)
			patient = C
			if(patient.stat & DEAD)
				hound.sleeper_r = 1
				hound.sleeper_g = 0
				patient_laststat = patient.stat
			else
				hound.sleeper_r = 0
				hound.sleeper_g = 1
				patient_laststat = patient.stat
			//Update icon and return new patient
			hound.update_icons()
			return(C)

	//Cleaning looks better with red on, even with nobody in it
	if(cleaning && !patient)
		hound.sleeper_r = 1
		hound.sleeper_g = 0

	//Couldn't find anyone, and not cleaning
	else if(!cleaning && !patient)
		hound.sleeper_r = 0
		hound.sleeper_g = 0

	patient_laststat = null
	patient = null
	hound.update_icons()
	return

//Gurgleborg process
/obj/item/device/dogborg/sleeper/proc/clean_cycle()
	testing("clean_cycle activated")
	//Sanity? Maybe not required. More like if indigestible person OOC escapes.
	for(var/I in items_preserved)
		if(!(I in contents))
			items_preserved -= I

	var/list/touchable_items = contents - items_preserved

	if(cleaning_cycles)
		testing("clean_cycle being used")
		cleaning_cycles--
		cleaning = TRUE
		//Burn all the mobs or add them to the exclusion list
		for(var/mob/living/carbon/human/T in (touchable_items))
			if((T.status_flags & GODMODE) || !T.digestable)
				src.items_preserved += T
			else
				T.adjustBruteLoss(2)
				T.adjustFireLoss(3)
				update_gut()
				addtimer(CALLBACK(src, .proc/clean_cycle), 50)
	else
		testing("clean_cycle resetted")
		cleaning_cycles = initial(cleaning_cycles)
		cleaning = FALSE
		update_gut()
		to_chat(hound, "<span class='notice'>Your [src.name] chimes it ends its self-cleaning cycle.</span>")//Belly is entirely empty

	if(!length(contents))
		to_chat(hound, "<span class='notice'>Your [src.name] is now clean. Ending self-cleaning cycle.</span>")
		cleaning = FALSE
		update_gut()
		return

	//sound effects
	for(var/mob/living/M in contents)
		if(prob(50))
			M.stop_sound_channel(CHANNEL_PRED)
			playsound(get_turf(hound),"digest_pred",75,0,-6,0,channel=CHANNEL_PRED)
			M.stop_sound_channel(CHANNEL_PRED)
			M.playsound_local("digest_prey",60)


		//Pick a random item to deal with (if there are any)
		var/atom/target = pick(touchable_items)

		//Handle the target being a mob
		if(ishuman(target))
			var/mob/living/carbon/human/T = target

			//Mob is now dead
			if(T.stat == DEAD && T.digestable)
				message_admins("[key_name(hound)] has digested [key_name(T)] as a dogborg. ([hound ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[hound.x];Y=[hound.y];Z=[hound.z]'>JMP</a>" : "null"])")
				to_chat(hound,"<span class='notice'>You feel your belly slowly churn around [T], breaking them down into a soft slurry to be used as power for your systems.</span>")
				to_chat(T,"<span class='notice'>You feel [hound]'s belly slowly churn around your form, breaking you down into a soft slurry to be used as power for [hound]'s systems.</span>")
				src.hound.cell.give(30000) //Fueeeeellll
				T.stop_sound_channel(CHANNEL_PRED)
				playsound(get_turf(hound),"death_pred",50,0,-6,0,channel=CHANNEL_PRED)
				T.stop_sound_channel(CHANNEL_PRED)
				T.playsound_local("death_prey",60)
				qdel(T)
				src.update_gut()

		//Handle the target being anything but a /mob/living/carbon/human
		else
			var/obj/T = target

			//If the object is in the items_preserved global list //POLARISTODO

			if(T.type in important_items)
				src.items_preserved += T

			//If the object is not one to preserve
			else
				qdel(T)
				src.update_gut()
				src.hound.cell.give(10)
	return

/obj/item/device/dogborg/sleeper/proc/inject_chem(chem)
	testing("inject chem triggered, checking power")
	if(hound.cell.charge <= 800) //This is so borgs don't kill themselves with it. Remember, 750 charge used every injection.
		to_chat(hound, "<span class='notice'>You don't have enough power to synthesize fluids.</span>")
		return
	testing("Has power, checking for overdose")
	if(patient.reagents.get_reagent_amount(chem) + 10 >= 20) //Preventing people from accidentally killing themselves by trying to inject too many chemicals!
		to_chat(hound, "<span class='notice'>Your stomach is currently too full of fluids to secrete more fluids of this kind.</span>")
		return
	testing("isn't overdosing, attempting to add_reagent")
	patient.reagents.add_reagent(chem, 10)
	testing("add_reagent")
	src.hound.cell.use(750) //-750 charge per injection
	testing("draining power")
	var/units = round(patient.reagents.get_reagent_amount(chem))
	to_chat(hound, "<span class='notice'>Injecting [units] unit\s of [chem] into occupant.</span>") //If they were immersed, the reagents wouldn't leave with them.

/obj/item/device/dogborg/sleeper/medihound //Medihound sleeper
	name = "Mobile Sleeper"
	desc = "Equipment for medical hound. A mounted sleeper that stabilizes patients and can inject reagents in the borg's reserves."
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "sleeper"

/obj/item/device/dogborg/sleeper/K9 //The K9 portabrig
	name = "Mobile Brig"
	desc = "Equipment for a K9 unit. A mounted portable-brig that holds criminals."
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "sleeperb"
	inject_amount = 0
	min_health = -100
	injection_chems = null //So they don't have all the same chems as the medihound!

/obj/item/storage/attackby(obj/item/device/dogborg/sleeper/K9, mob/user, proximity)
	K9.afterattack(src, user ,1)

/obj/item/device/dogborg/sleeper/K9/afterattack(var/atom/movable/target, mob/living/silicon/user, proximity)
	hound = loc

	if(!istype(target))
		return
	if(!proximity)
		return
	if(target.anchored)
		return
	if(ishuman(target))
		var/mob/living/carbon/human/brigman = target
		if (!brigman.devourable)
			to_chat(user, "The target registers an error code. Unable to insert into [src.name].")
			return
		if(patient)
			to_chat(user,"<span class='warning'>Your [src.name] is already occupied.</span>")
			return
		if(brigman.buckled)
			to_chat(user,"<span class='warning'>[brigman] is buckled and can not be put into your [src.name].</span>")
			return
		user.visible_message("<span class='warning'>[hound.name] is ingesting [brigman] into their [src.name].</span>", "<span class='notice'>You start ingesting [brigman] into your [src.name]...</span>")
		if(do_after(user, 30, target = brigman) && !patient && !brigman.buckled)
			if(!in_range(src, brigman)) //Proximity is probably old news by now, do a new check.
				return //If they moved away, you can't eat them.
			brigman.forceMove(src)
			brigman.reset_perspective(src)
			update_gut()
			START_PROCESSING(SSobj, src)
			user.visible_message("<span class='warning'>[hound.name]'s mobile brig clunks in series as [brigman] slips inside.</span>", "<span class='notice'>Your mobile brig groans lightly as [brigman] slips inside.</span>")
			playsound(hound, 'sound/effects/bin_close.ogg', 80, 1) // Really don't need ERP sound effects for robots
		return
	return

/obj/item/device/dogborg/sleeper/compactor //Janihound gut.
	name = "garbage processor"
	desc = "A mounted garbage compactor unit with fuel processor."
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "compactor"
	inject_amount = 0
	min_health = -100
	injection_chems = null //So they don't have all the same chems as the medihound!
	var/max_item_count = 30

/obj/item/storage/attackby(obj/item/device/dogborg/sleeper/compactor, mob/user, proximity) //GIT CIRCUMVENTED YO!
	compactor.afterattack(src, user ,1)

/obj/item/device/dogborg/sleeper/compactor/afterattack(var/atom/movable/target, mob/living/silicon/user, proximity)//GARBO NOMS
	hound = loc

	if(!istype(target))
		return
	if(!proximity)
		return
	if(target.anchored)
		return
	if(length(contents) > (max_item_count - 1))
		to_chat(user,"<span class='warning'>Your [src.name] is full. Eject or process contents to continue.</span>")
		return
	if(istype(target,/obj/item))
		var/obj/item/target_obj = target
		if(target_obj.type in important_items)
			to_chat(user,"<span class='warning'>\The [target] registers an error code to your [src.name]</span>")
			return
		if(target_obj.w_class > WEIGHT_CLASS_NORMAL)
			to_chat(user,"<span class='warning'>\The [target] is too large to fit into your [src.name]</span>")
			return
		user.visible_message("<span class='warning'>[hound.name] is ingesting [target.name] into their [src.name].</span>", "<span class='notice'>You start ingesting [target] into your [src.name]...</span>")
		if(do_after(user, 15, target = target) && length(contents) < max_item_count)
			if(!in_range(src, target)) //Proximity is probably old news by now, do a new check.
				return //If they moved away, you can't eat them. This still applies to items, don't magically eat things I picked up already.
			target.forceMove(src)
			user.visible_message("<span class='warning'>[hound.name]'s garbage processor groans lightly as [target.name] slips inside.</span>", "<span class='notice'>Your garbage compactor groans lightly as [target] slips inside.</span>")
			playsound(hound, 'sound/machines/disposalflush.ogg', 50, 1)
			if(length(contents) > 11) //grow that tum after a certain junk amount
				hound.sleeper_r = 1
				hound.update_icons()
		return

	else if(ishuman(target))
		var/mob/living/carbon/human/trashman = target
		if (!trashman.devourable)
			to_chat(user, "<span class='warning'>\The [target] registers an error code to your [src.name]</span>")
			return
		if(patient)
			to_chat(user,"<span class='warning'>Your [src.name] is already occupied.</span>")
			return
		if(trashman.buckled)
			to_chat(user,"<span class='warning'>[trashman] is buckled and can not be put into your [src.name].</span>")
			return
		user.visible_message("<span class='warning'>[hound.name] is ingesting [trashman] into their [src.name].</span>", "<span class='notice'>You start ingesting [trashman] into your [src.name]...</span>")
		if(do_after(user, 30, target = trashman) && !patient && !trashman.buckled && length(contents) < max_item_count)
			if(!in_range(src, trashman)) //Proximity is probably old news by now, do a new check.
				return //If they moved away, you can't eat them.
			trashman.forceMove(src)
			trashman.reset_perspective(src)
			update_gut()
			START_PROCESSING(SSobj, src)
			user.visible_message("<span class='warning'>[hound.name]'s garbage processor groans lightly as [trashman] slips inside.</span>", "<span class='notice'>Your garbage compactor groans lightly as [trashman] slips inside.</span>")
			playsound(hound, 'sound/effects/bin_close.ogg', 80, 1)
		return
	return


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
	flags_1 |= NOBLUDGEON_1

/mob/living/silicon/robot
	var/leaping = 0
	var/pounce_cooldown = 0
	var/pounce_cooldown_time = 50 //Nearly doubled, u happy?
	var/pounce_spoolup = 3
	var/leap_at
	var/disabler
	var/laser
	var/sleeper_g
	var/sleeper_r

#define MAX_K9_LEAP_DIST 4 //because something's definitely borked the pounce functioning from a distance.

/obj/item/dogborg/pounce/afterattack(atom/A, mob/user)
	var/mob/living/silicon/robot/R = user
	if(R && !R.pounce_cooldown)
		R.pounce_cooldown = !R.pounce_cooldown
		to_chat(R, "<span class ='warning'>Your targeting systems lock on to [A]...</span>")
		addtimer(CALLBACK(R, /mob/living/silicon/robot.proc/leap_at, A), R.pounce_spoolup)
		spawn(R.pounce_cooldown_time)
			R.pounce_cooldown = !R.pounce_cooldown
	else if(R && R.pounce_cooldown)
		to_chat(R, "<span class='danger'>Your leg actuators are still recharging!</span>")

/mob/living/silicon/robot/proc/leap_at(atom/A)
	if(leaping || stat || buckled || lying)
		return

	if(!has_gravity(src) || !has_gravity(A))
		to_chat(src,"<span class='danger'>It is unsafe to leap without gravity!</span>")
		//It's also extremely buggy visually, so it's balance+bugfix
		return

	if(cell.charge <= 500)
		to_chat(src,"<span class='danger'>Insufficent reserves for jump actuators!</span>")
		return

	else
		leaping = 1
		weather_immunities += "lava"
		pixel_y = 10
		update_icons()
		throw_at(A, MAX_K9_LEAP_DIST, 1, spin=0, diagonals_first = 1)
		cell.use(500) //Doubled the energy consumption
		weather_immunities -= "lava"

/mob/living/silicon/robot/throw_impact(atom/A)

	if(!leaping)
		return ..()

	if(A)
		if(isliving(A))
			var/mob/living/L = A
			var/blocked = 0
			if(ishuman(A))
				var/mob/living/carbon/human/H = A
				if(H.check_shields(0, "the [name]", src, attack_type = LEAP_ATTACK))
					blocked = 1
			if(!blocked)
				L.visible_message("<span class ='danger'>[src] pounces on [L]!</span>", "<span class ='userdanger'>[src] pounces on you!</span>")
				L.Knockdown(45)
				playsound(src, 'sound/weapons/Egloves.ogg', 50, 1)
				sleep(2)//Runtime prevention (infinite bump() calls on hulks)
				step_towards(src,L)
			else
				Knockdown(45, 1, 1)

			pounce_cooldown = !pounce_cooldown
			spawn(pounce_cooldown_time) //3s by default
				pounce_cooldown = !pounce_cooldown
		else if(A.density && !A.CanPass(src))
			visible_message("<span class ='danger'>[src] smashes into [A]!</span>", "<span class ='userdanger'>You smash into [A]!</span>")
			playsound(src, 'sound/items/trayhit1.ogg', 50, 1)
			Knockdown(45, 1, 1)

		if(leaping)
			leaping = 0
			pixel_y = initial(pixel_y)
			update_icons()
			update_canmove()
