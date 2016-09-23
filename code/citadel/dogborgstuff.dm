// Special tools and items for "Borgi" and "K-9 Unit"
// PASTA SPAGHETTI FEST WOOHOOO!!! var/regrets = null

/obj/item/weapon/dogborg/jaws/big
	name = "combat jaws"
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "jaws"
	desc = "The jaws of the law."
	flags = CONDUCT
	force = 10
	throwforce = 0
	hitsound = 'sound/weapons/bite.ogg'
	attack_verb = list("chomped", "bit", "ripped", "mauled", "enforced")
	w_class = 3
	sharpness = IS_SHARP

/obj/item/weapon/dogborg/jaws/small
	name = "puppy jaws"
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "smalljaws"
	desc = "The jaws of a small dog."
	flags = CONDUCT
	force = 5
	throwforce = 0
	hitsound = 'sound/weapons/bite.ogg'
	attack_verb = list("nibbled", "bit", "gnawed", "chomped", "nommed")
	w_class = 3
	sharpness = IS_SHARP
	var/emagged = 0

/obj/item/weapon/dogborg/jaws/small/attack_self(mob/user)
	var/mob/living/silicon/robot.R = user
	if(R.emagged)
		emagged = !emagged
		if(emagged)
			name = "combat jaws"
			icon = 'icons/mob/dogborg.dmi'
			icon_state = "jaws"
			desc = "The jaws of the law."
			flags = CONDUCT
			force = 10
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
			flags = CONDUCT
			force = 5
			throwforce = 0
			hitsound = 'sound/weapons/bite.ogg'
			attack_verb = list("nibbled", "bit", "gnawed", "chomped", "nommed")
			w_class = 3
			sharpness = IS_SHARP
		update_icon()


//Cuffs

/obj/item/weapon/restraints/handcuffs/cable/zipties/cyborg/dog/attack(mob/living/carbon/C, mob/user)
	if(isrobot(user))
		if(!C.handcuffed)
			playsound(loc, 'sound/weapons/cablecuff.ogg', 30, 1, -2)
			C.visible_message("<span class='danger'>[user] is trying to put zipties on [C]!</span>", \
								"<span class='userdanger'>[user] is trying to put zipties on [C]!</span>")
			if(do_mob(user, C, 30))
				if(!C.handcuffed)
					C.handcuffed = new /obj/item/weapon/restraints/handcuffs/cable/zipties/used(C)
					C.update_inv_handcuffed(0)
					user << "<span class='notice'>You handcuff [C].</span>"
					playsound(loc, pick('sound/voice/bgod.ogg', 'sound/voice/biamthelaw.ogg', 'sound/voice/bsecureday.ogg', 'sound/voice/bradio.ogg', 'sound/voice/binsult.ogg', 'sound/voice/bcreep.ogg'), 50, 0)
					add_logs(user, C, "handcuffed")
			else
				user << "<span class='warning'>You fail to handcuff [C]!</span>"


//Boop

/obj/item/device/analyzer/nose
	name = "boop module"
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "nose"
	desc = "The BOOP module"
	flags = CONDUCT
	force = 0
	throwforce = 0
	attack_verb = list("nuzzled", "nosed", "booped")
	w_class = 1

/obj/item/device/analyzer/nose/attack_self(mob/user)
	user.visible_message("[user] sniffs around the air.", "<span class='warning'>You sniff the air for gas traces.</span>")

	var/turf/location = user.loc
	if (!( istype(location, /turf) ))
		return

	var/datum/gas_mixture/environment = location.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles()

	user.show_message("<span class='info'><B>Results:</B></span>", 1)
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		user.show_message("<span class='info'>Pressure: [round(pressure,0.1)] kPa</span>", 1)
	else
		user.show_message("<span class='alert'>Pressure: [round(pressure,0.1)] kPa</span>", 1)
	if(total_moles)
		var/list/env_gases = environment.gases

		environment.assert_gases(arglist(hardcoded_gases))
		var/o2_concentration = env_gases["o2"][MOLES]/total_moles
		var/n2_concentration = env_gases["n2"][MOLES]/total_moles
		var/co2_concentration = env_gases["co2"][MOLES]/total_moles
		var/plasma_concentration = env_gases["plasma"][MOLES]/total_moles
		environment.garbage_collect()

		if(abs(n2_concentration - N2STANDARD) < 20)
			user << "<span class='info'>Nitrogen: [round(n2_concentration*100, 0.01)] %</span>"
		else
			user << "<span class='alert'>Nitrogen: [round(n2_concentration*100, 0.01)] %</span>"

		if(abs(o2_concentration - O2STANDARD) < 2)
			user << "<span class='info'>Oxygen: [round(o2_concentration*100, 0.01)] %</span>"
		else
			user << "<span class='alert'>Oxygen: [round(o2_concentration*100, 0.01)] %</span>"

		if(co2_concentration > 0.01)
			user << "<span class='alert'>CO2: [round(co2_concentration*100, 0.01)] %</span>"
		else
			user << "<span class='info'>CO2: [round(co2_concentration*100, 0.01)] %</span>"

		if(plasma_concentration > 0.005)
			user << "<span class='alert'>Plasma: [round(plasma_concentration*100, 0.01)] %</span>"
		else
			user << "<span class='info'>Plasma: [round(plasma_concentration*100, 0.01)] %</span>"

		user.show_message("<span class='info'>Temperature: [round(environment.temperature-T0C)] &deg;C</span>", 1)
	return


//Delivery

/obj/item/weapon/storage/bag/borgdelivery
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
	cant_hold = list(/obj/item/weapon/disk/nuclear)


//Tongue stuff

/obj/item/weapon/soap/tongue
	name = "synthetic tongue"
	desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "synthtongue"
	hitsound = 'sound/effects/attackblob.ogg'
	cleanspeed = 80
	var/emagged = 0

/obj/item/trash/rkibble
	name = "robo kibble"
	desc = "A novelty bowl of assorted mech fabricator byproducts. Mockingly feed this to the sec-dog to help it recharge."
	icon = 'icons/mob/dogborg.dmi'
	icon_state= "kibble"

/obj/item/weapon/soap/tongue/attack_self(mob/user)
	var/mob/living/silicon/robot.R = user
	if(R.emagged)
		emagged = !emagged
		if(emagged)
			name = "hacked tongue of doom"
			desc = "Your tongue has been upgraded successfully. Congratulations."
			icon = 'icons/mob/dogborg.dmi'
			icon_state = "syndietongue"
			cleanspeed = 60 //(nerf'd)tator soap stat
		else
			name = "synthetic tongue"
			desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
			icon = 'icons/mob/dogborg.dmi'
			icon_state = "synthtongue"
			cleanspeed = 80
		update_icon()

/obj/item/weapon/soap/tongue/afterattack(atom/target, mob/user, proximity)
	if(!proximity || !check_allowed_items(target))
		return
	if(user.client && (target in user.client.screen))
		user << "<span class='warning'>You need to take that [target.name] off before cleaning it!</span>"
	else if(istype(target,/obj/effect/decal/cleanable))
		user.visible_message("[user] begins to lick off \the [target.name].", "<span class='warning'>You begin to lick off \the [target.name]...</span>")
		if(do_after(user, src.cleanspeed, target = target))
			user << "<span class='notice'>You finish licking off \the [target.name].</span>"
			qdel(target)
			var/mob/living/silicon/robot.R = user
			R.cell.charge = R.cell.charge + 50
	else if(istype(target,/obj/item)) //hoo boy. danger zone man
		if(istype(target,/obj/item/trash))
			user.visible_message("[user] nibbles away at \the [target.name].", "<span class='warning'>You begin to nibble away at \the [target.name]...</span>")
			if(do_after(user, src.cleanspeed, target = target))
				user << "<span class='notice'>You finish off \the [target.name].</span>"
				qdel(target)
				var/mob/living/silicon/robot.R = user
				R.cell.charge = R.cell.charge + 250
			return
		if(istype(target,/obj/item/weapon/stock_parts/cell))
			user.visible_message("[user] begins cramming \the [target.name] down its throat.", "<span class='warning'>You begin cramming \the [target.name] down your throat...</span>")
			if(do_after(user, 50, target = target))
				user << "<span class='notice'>You finish off \the [target.name].</span>"
				var/mob/living/silicon/robot.R = user
				var/obj/item/weapon/stock_parts/cell.C = target
				R.cell.charge = R.cell.charge + (C.charge / 3) //Instant full cell upgrades op idgaf
				qdel(target)
			return
		var/obj/item/I = target //HAHA FUCK IT, NOT LIKE WE ALREADY HAVE A SHITTON OF WAYS TO REMOVE SHIT
		if(!I.anchored && src.emagged)
			user.visible_message("[user] begins chewing up \the [target.name]. Looks like it's trying to loophole around its diet restriction!", "<span class='warning'>You begin chewing up \the [target.name]...</span>")
			if(do_after(user, 100, target = I)) //Nerf dat time yo
				visible_message("<span class='warning'>[user] chews up \the [target.name] and cleans off the debris!</span>")
				user << "<span class='notice'>You finish off \the [target.name].</span>"
				qdel(I)
				var/mob/living/silicon/robot.R = user
				R.cell.charge = R.cell.charge + 500
			return
		user.visible_message("[user] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
		if(do_after(user, src.cleanspeed, target = target))
			user << "<span class='notice'>You clean \the [target.name].</span>"
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
			L.Weaken(4)
			L.apply_effect(STUTTER, 4)
			L.visible_message("<span class='danger'>[user] has shocked [L] with its tongue!</span>", \
								"<span class='userdanger'>[user] has shocked you with its tongue! You can feel the betrayal.</span>")
			playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
			R.cell.charge = R.cell.charge - 666
		else
			user.visible_message("<span class='warning'>\the [user] affectionally licks \the [target]'s face!</span>", "<span class='notice'>You affectionally lick \the [target]'s face!</span>")
			playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
			return
	else if(istype(target, /obj/structure/window))
		user.visible_message("[user] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
		if(do_after(user, src.cleanspeed, target = target))
			user << "<span class='notice'>You clean \the [target.name].</span>"
			target.color = initial(target.color)
			target.SetOpacity(initial(target.opacity))
	else
		user.visible_message("[user] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
		if(do_after(user, src.cleanspeed, target = target))
			user << "<span class='notice'>You clean \the [target.name].</span>"
			var/obj/effect/decal/cleanable/C = locate() in target
			qdel(C)
			target.clean_blood()
	return



//Defibs

/obj/item/weapon/twohanded/shockpaddles/hound
	name = "defibrillator paws"
	desc = "MediHound specific shock paws."
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "defibpaddles0"
	item_state = "defibpaddles0"
	req_defib = 0
	wielded = 1

/obj/item/weapon/twohanded/shockpaddles/hound/attack(mob/M, mob/user)
	var/mob/living/silicon/robot.R = user
	if(R.cell.charge < 1000)
		user.visible_message("<span class='warning'>You don't have enough charge for this operation!</span class>")
		return
	if(src.cooldown == 0)
		R.cell.charge = R.cell.charge - 1000
	return ..()


//Sleeper

/obj/item/weapon/dogborg/sleeper
	name = "mounted sleeper"
	desc = "Equipment for medical hound. A mounted sleeper that stabilizes patients and can inject reagents in the borg's reserves."
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "sleeper"
	var/mob/living/carbon/patient = null
	var/mob/living/silicon/hound = null
	var/inject_amount = 10
	var/min_health = -100
	var/occupied = 0
	var/list/injection_chems = list("morphine", "salbutamol", "bicaridine", "kelotane","antitoxin")

/obj/item/weapon/dogborg/sleeper/Exit(atom/movable/O)
	return 0

/obj/item/weapon/dogborg/sleeper/afterattack(mob/living/carbon/target, mob/living/silicon/user, proximity)
	if(!proximity)
		return
	if(!ishuman(target))
		return
	if(!patient_insertion_check(target))
		return
	user.visible_message("<span class='warning'>[user] starts putting [target] into \the [src].</span>", "<span class='notice'>You start putting [target] into [src]...</span>")
	if(do_after(user, 50, target = target))
		if(!patient_insertion_check(target))
			return
		target.forceMove(src)
		patient = target
		hound = user
		target.reset_perspective(src)
		user << "<span class='notice'>[target] successfully loaded into [src]. Life support functions engaged.</span>"
		user.visible_message("<span class='warning'>[user] loads [target] into [src].</span>")
		user.visible_message("[target] loaded. Life support functions engaged.")
		src.occupied = 1
		var/mob/living/silicon/robot.R = user
		if(patient.stat < 2)
			R.sleeper_r = 0
			R.sleeper_g = 1
			R.update_icons()
		else
			R.sleeper_g = 0
			R.sleeper_r = 1
			R.update_icons()
		SSobj.processing |= src

/obj/item/weapon/dogborg/sleeper/proc/patient_insertion_check(mob/living/carbon/target, mob/user)
	if(target.anchored)
		user << "<span class='warning'>[target] will not fit into the sleeper because they are buckled to [target.buckled]!</span>"
		return
	if(patient)
		user << "<span class='warning'>The sleeper is already occupied!</span>"
		return
	return 1

/obj/item/weapon/dogborg/sleeper/proc/go_out()
	if(src.occupied == 0)
		return
	var/mob/living/silicon/robot.R = hound
	hound << "<span class='notice'>[patient] ejected. Life support functions disabled.</span>"
	R.sleeper_r = 0
	R.sleeper_g = 0
	R.update_icons()
	patient.forceMove(get_turf(src))
	patient.reset_perspective()
	patient = null
	src.occupied = 0
	src.occupied = 0 //double check just in case

/obj/item/weapon/dogborg/sleeper/proc/drain()
	var/mob/living/silicon/robot.R = hound
	R.cell.charge = R.cell.charge - 10

/obj/item/weapon/dogborg/sleeper/attack_self(mob/user)
	if(..())
		return
	sleeperUI(user)

/obj/item/weapon/dogborg/sleeper/proc/sleeperUI(mob/user)
	var/dat
	dat += "<h3>Injector</h3>"
	if(patient)
		dat += "<A href='?src=\ref[src];inject=epinephrine'>Inject Epinephrine</A>"
	else
		dat += "<span class='linkOff'>Inject Epinephrine</span>"
	if(patient && patient.health > min_health)
		for(var/re in injection_chems)
			var/datum/reagent/C = chemical_reagents_list[re]
			if(C)
				dat += "<BR><A href='?src=\ref[src];inject=[C.id]'>Inject [C.name]</A>"
	else
		for(var/re in injection_chems)
			var/datum/reagent/C = chemical_reagents_list[re]
			if(C)
				dat += "<BR><span class='linkOff'>Inject [C.name]</span>"

	dat += "<h3>Sleeper Status</h3>"
	dat += "<A href='?src=\ref[src];refresh=1'>Scan</A>"
	dat += "<A href='?src=\ref[src];eject=1'>Eject</A>"
	dat += "<div class='statusDisplay'>"
	if(!patient)
		dat += "Sleeper Unoccupied"
	else
		dat += "[patient.name] => "
		switch(patient.stat)	//obvious, see what their status is
			if(0)
				dat += "<span class='good'>Conscious</span>"
				var/mob/living/silicon/robot.R = user
				R.sleeper_r = 0
				R.sleeper_g = 1
				R.update_icons()
			if(1)
				dat += "<span class='average'>Unconscious</span>"
				var/mob/living/silicon/robot.R = user
				R.sleeper_r = 0
				R.sleeper_g = 1
				R.update_icons()
			else
				dat += "<span class='bad'>DEAD</span>"
				var/mob/living/silicon/robot.R = user
				R.sleeper_g = 0
				R.sleeper_r = 1
				R.update_icons()
		dat += "<br />"
		dat +=  "<div class='line'><div class='statusLabel'>Health:</div><div class='progressBar'><div style='width: [patient.health < 0 ? "0" : "[patient.health]"]%;' class='progressFill good'></div></div><div class='statusValue'>[patient.stat > 1 ? "" : "[patient.health]%"]</div></div>"
		dat +=  "<div class='line'><div class='statusLabel'>\> Brute Damage:</div><div class='progressBar'><div style='width: [patient.getBruteLoss()]%;' class='progressFill bad'></div></div><div class='statusValue'>[patient.getBruteLoss()]%</div></div>"
		dat +=  "<div class='line'><div class='statusLabel'>\> Resp. Damage:</div><div class='progressBar'><div style='width: [patient.getOxyLoss()]%;' class='progressFill bad'></div></div><div class='statusValue'>[patient.getOxyLoss()]%</div></div>"
		dat +=  "<div class='line'><div class='statusLabel'>\> Toxin Content:</div><div class='progressBar'><div style='width: [patient.getToxLoss()]%;' class='progressFill bad'></div></div><div class='statusValue'>[patient.getToxLoss()]%</div></div>"
		dat +=  "<div class='line'><div class='statusLabel'>\> Burn Severity:</div><div class='progressBar'><div style='width: [patient.getFireLoss()]%;' class='progressFill bad'></div></div><div class='statusValue'>[patient.getFireLoss()]%</div></div><br>"

		dat += "<HR><div class='line'><div style='width: 170px;' class='statusLabel'>Paralysis Summary:</div><div class='statusValue'>[round(patient.paralysis)]% [patient.paralysis ? "([round(patient.paralysis / 4)] seconds left)" : ""]</div></div><br>"
		if(patient.getCloneLoss())
			dat += "<div class='line'><span class='average'>Subject appears to have cellular damage.</span></div><br>"
		if(patient.getBrainLoss())
			dat += "<div class='line'><span class='average'>Significant brain damage detected.</span></div><br>"
		if(patient.reagents.reagent_list.len)
			for(var/datum/reagent/R in patient.reagents.reagent_list)
				dat += "<div class='line'><div style='width: 170px;' class='statusLabel'>[R.name]:</div><div class='statusValue'>[round(R.volume, 0.1)] units</div></div><br>"
	dat += "</div>"

	var/datum/browser/popup = new(user, "sleeper", "Sleeper Console", 520, 540)	//Set up the popup browser window
	popup.set_title_image(user.browse_rsc_icon(icon, icon_state))
	popup.set_content(dat)
	popup.open()

/obj/item/weapon/dogborg/sleeper/Topic(href, href_list)
	if(..() || usr == patient)
		return
	usr.set_machine(src)
	if(href_list["refresh"])
		updateUsrDialog()
		return
	if(href_list["eject"])
		go_out()
		return
	if(patient && patient.stat != DEAD)
		if(href_list["inject"] == "epinephrine" || patient.health > min_health)
			inject_chem(usr, href_list["inject"])
		else
			usr << "<span class='notice'>ERROR: Subject is not in stable condition for auto-injection.</span>"
	else
		usr << "<span class='notice'>ERROR: Subject cannot metabolise chemicals.</span>"
	updateUsrDialog()

/obj/item/weapon/dogborg/sleeper/proc/inject_chem(mob/user, chem)
	if(patient && patient.reagents)
		if(chem in injection_chems + "epinephrine")
			if(patient.reagents.get_reagent_amount(chem) + 10 <= 20)
				patient.reagents.add_reagent(chem, 10)
				var/mob/living/silicon/robot.R = user
				R.cell.charge = R.cell.charge - 250 //-250 charge per sting.
			var/units = round(patient.reagents.get_reagent_amount(chem))
			user << "<span class='notice'>Occupant now has [units] unit\s of [chemical_reagents_list[chem]] in their bloodstream.</span>"

/obj/item/weapon/dogborg/sleeper/process()
	if(src.occupied == 0)
		SSobj.processing.Remove(src)
		return
	if(patient.health > 0)
		patient.adjustOxyLoss(-1)
		patient.updatehealth()
	patient.AdjustStunned(-4)
	patient.AdjustWeakened(-4)
	src.drain()
	if(patient.reagents.get_reagent_amount("epinephrine") < 5)
		patient.reagents.add_reagent("epinephrine", 5)

/obj/item/weapon/dogborg/sleeper/container_resist()
	go_out()

// Pounce stuff for K-9

/obj/item/weapon/dogborg/pounce
	name = "pounce"
	icon = 'icons/mob/dogborg.dmi'
	icon_state = "pounce"
	desc = "Leap at your target to momentarily stun them."
	force = 0
	throwforce = 0

/mob/living/silicon/robot
	var/leaping = 0
	var/pounce_cooldown = 0
	var/pounce_cooldown_time = 40 //Nearly doubled, u happy?
	var/leap_at
	var/disabler
	var/laser
	var/sleeper_g
	var/sleeper_r

#define MAX_K9_LEAP_DIST 3 //Dropped from 7 to 3 because waa waa

/obj/item/weapon/dogborg/pounce/afterattack(atom/A, mob/user)
	var/mob/living/silicon/robot.R = user
	R.leap_at(A)

/mob/living/silicon/robot/proc/leap_at(atom/A)
	if(pounce_cooldown)
		src << "<span class='danger'>Your leg actuators are still recharging!</span>"
		return

	if(leaping) //Leap while you leap, so you can leap while you leap
		return

	if(!has_gravity(src) || !has_gravity(A))
		src << "<span class='danger'>It is unsafe to leap without gravity!</span>"
		//It's also extremely buggy visually, so it's balance+bugfix
		return

	if(cell.charge <= 500)
		return

	else
		leaping = 1
		pixel_y = 10
		throw_at(A,MAX_K9_LEAP_DIST,1, spin=0, diagonals_first = 1)
		leaping = 0
		pixel_y = initial(pixel_y)
		cell.charge = cell.charge - 500 //Doubled the energy consumption
		pounce_cooldown = !pounce_cooldown
		spawn(pounce_cooldown_time)
			pounce_cooldown = !pounce_cooldown

/mob/living/silicon/robot/throw_impact(atom/A, params)

	if(!leaping)
		return ..()

	if(A)
		if(istype(A, /mob/living))
			var/mob/living/L = A
			var/blocked = 0
			if(ishuman(A))
				var/mob/living/carbon/human/H = A
				if(H.check_shields(90, "the [name]", src, 1))
					blocked = 1
			if(!blocked)
				L.visible_message("<span class ='danger'>[src] pounces on [L]!</span>", "<span class ='userdanger'>[src] pounces on you!</span>")
				L.Weaken(2)// NO LONGER enough to cuff em before they run off again, unless you're lucky. Requested nerf.
				sleep(2)//Runtime prevention (infinite bump() calls on hulks)
				step_towards(src,L)

		else if(A.density && !A.CanPass(src))
			visible_message("<span class ='danger'>[src] smashes into [A]!</span>")
			weakened = 2

		if(leaping)
			leaping = 0
			update_canmove()
