/obj/item/gun/energy/e_gun
	name = "energy gun"
	desc = "A basic hybrid energy gun with two settings: disable and kill."
	icon_state = "energy"
	item_state = null	//so the human update icon uses the icon_state instead.
	ammo_type = list(/obj/item/ammo_casing/energy/disabler, /obj/item/ammo_casing/energy/laser)
	modifystate = 1
	can_flashlight = 1
	ammo_x_offset = 3
	flight_x_offset = 15
	flight_y_offset = 10

/obj/item/gun/energy/e_gun/mini
	name = "miniature energy gun"
	desc = "A small, pistol-sized energy gun with a built-in flashlight. It has two settings: stun and kill."
	icon_state = "mini"
	item_state = "gun"
	w_class = WEIGHT_CLASS_SMALL
	cell_type = /obj/item/stock_parts/cell{charge = 600; maxcharge = 600}
	ammo_x_offset = 2
	charge_sections = 3
	can_flashlight = 0 // Can't attach or detach the flashlight, and override it's icon update

/obj/item/gun/energy/e_gun/mini/Initialize()
	gun_light = new /obj/item/flashlight/seclite(src)
	return ..()

/obj/item/gun/energy/e_gun/mini/update_icon()
	..()
	if(gun_light && gun_light.on)
		add_overlay("mini-light")

/obj/item/gun/energy/e_gun/stun
	name = "tactical energy gun"
	desc = "Military issue energy gun, is able to fire stun rounds."
	icon_state = "energytac"
	ammo_x_offset = 2
	ammo_type = list(/obj/item/ammo_casing/energy/electrode/spec, /obj/item/ammo_casing/energy/disabler, /obj/item/ammo_casing/energy/laser)

/obj/item/gun/energy/e_gun/old
	name = "prototype energy gun"
	desc = "NT-P:01 Prototype Energy Gun. Early stage development of a unique laser rifle that has multifaceted energy lens allowing the gun to alter the form of projectile it fires on command."
	icon_state = "protolaser"
	ammo_x_offset = 2
	ammo_type = list(/obj/item/ammo_casing/energy/laser, /obj/item/ammo_casing/energy/electrode/old)

/obj/item/gun/energy/e_gun/mini/practice_phaser
	name = "practice phaser"
	desc = "A modified version of the basic phaser gun, this one fires less concentrated energy bolts designed for target practice."
	ammo_type = list(/obj/item/ammo_casing/energy/disabler, /obj/item/ammo_casing/energy/laser/practice)
	icon_state = "decloner"

/obj/item/gun/energy/e_gun/hos
	name = "\improper X-01 MultiPhase Energy Gun"
	desc = "This is an expensive, modern recreation of an antique laser gun. This gun has several unique firemodes, but lacks the ability to recharge over time."
	icon_state = "hoslaser"
	force = 10
	ammo_type = list(/obj/item/ammo_casing/energy/electrode/hos, /obj/item/ammo_casing/energy/disabler, /obj/item/ammo_casing/energy/laser/hos)
	ammo_x_offset = 4
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/item/gun/energy/e_gun/dragnet
	name = "\improper DRAGnet"
	desc = "The \"Dynamic Rapid-Apprehension of the Guilty\" net is a revolution in law enforcement technology."
	icon_state = "dragnet"
	item_state = "dragnet"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	ammo_type = list(/obj/item/ammo_casing/energy/net, /obj/item/ammo_casing/energy/trap)
	can_flashlight = 0
	ammo_x_offset = 1

/obj/item/gun/energy/e_gun/dragnet/snare
	name = "Energy Snare Launcher"
	desc = "Fires an energy snare that slows the target down."
	ammo_type = list(/obj/item/ammo_casing/energy/trap)

/obj/item/gun/energy/e_gun/turret
	name = "hybrid turret gun"
	desc = "A heavy hybrid energy cannon with two settings: Stun and kill."
	icon_state = "turretlaser"
	item_state = "turretlaser"
	slot_flags = null
	w_class = WEIGHT_CLASS_HUGE
	ammo_type = list(/obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/laser)
	weapon_weight = WEAPON_HEAVY
	can_flashlight = 0
	trigger_guard = TRIGGER_GUARD_NONE
	ammo_x_offset = 2

/obj/item/gun/energy/e_gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized nuclear reactor that automatically charges the internal power cell."
	icon_state = "nucgun"
	item_state = "nucgun"
	charge_delay = 5
	pin = null
	can_charge = 0
	ammo_x_offset = 1
	ammo_type = list(/obj/item/ammo_casing/energy/disabler, /obj/item/ammo_casing/energy/laser)
	selfcharge = EGUN_SELFCHARGE
	var/fail_tick = 0
	var/fail_chance = 0

/obj/item/gun/energy/e_gun/nuclear/process()
	if(fail_tick > 0)
		fail_tick--
	..()

/obj/item/gun/energy/e_gun/nuclear/shoot_live_shot()
	failcheck()
	update_icon()
	..()

/obj/item/gun/energy/e_gun/nuclear/proc/failcheck()
	if(prob(fail_chance))
		switch(fail_tick)
			if(0 to 200)
				fail_tick += (2*(fail_chance))
				radiation_pulse(src, 50)
				var/mob/M = (ismob(loc) && loc) || (ismob(loc.loc) && loc.loc)		//thank you short circuiting. if you powergame and nest these guns deeply you get to suffer no-warning radiation death.
				if(M)
					to_chat(M, "<span class='userdanger'>Your [name] feels warmer.</span>")
			if(201 to INFINITY)
				SSobj.processing.Remove(src)
				radiation_pulse(src, 200)
				crit_fail = TRUE
				var/mob/M = (ismob(loc) && loc) || (ismob(loc.loc) && loc.loc)
				if(M)
					to_chat(M, "<span class='userdanger'>Your [name]'s reactor overloads!</span>")

/obj/item/gun/energy/e_gun/nuclear/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	fail_chance = min(fail_chance + round(15/severity), 100)

/obj/item/gun/energy/e_gun/nuclear/update_icon()
	..()
	if(crit_fail)
		add_overlay("[icon_state]_fail_3")
	else
		switch(fail_tick)
			if(0)
				add_overlay("[icon_state]_fail_0")
			if(1 to 150)
				add_overlay("[icon_state]_fail_1")
			if(151 to INFINITY)
				add_overlay("[icon_state]_fail_2")

//////////////// Type 21 is functionally identical to the HoS's gun.
// PLASMA GUN // Type 20 is functionally identical to a laser gun. You can tell it apart because it is red.
//////////////// Type 19 is worse than a laser gun. It fires in bursts of three. Use this for events, the burst scares the crew but doesn't harm them too much.

/obj/item/gun/energy/e_gun/plasmagun_type21
	name = "\improper Type-21 EED"
	desc = "A successor to the Type-20 model. This version includes new non-lethal firing modes."
	icon_state = "plasmagun"
	force = 10
	ammo_type = list(/obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/disabler, /obj/item/ammo_casing/energy/laser/hos)
	ammo_x_offset = 1
	shaded_charge = 1

/obj/item/gun/energy/e_gun/plasmagun_type20
	name = "\improper Type-20 EED"
	desc = "At a slightly increased power cost, this fires a singular bolt that is slightly more powerful than all three of the Type-19's burst-fired bolts combined. The question bamboozling Nanotrasen's top scientists to this day is: 'why is it red?'"
	icon_state = "plasmagun20"
	force = 10
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun)
	ammo_x_offset = 1
	shaded_charge = 1

/obj/item/gun/energy/e_gun/plasmagun_type19
	name = "\improper Type-19 EED"
	desc = "An ancient alien waepon, dubbed 'Encased Energy Director'. The original power source has been replaced with a Nanotrasen compatible power  supply."
	icon_state = "plasmagun19"
	force = 10
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun/plasmagun/triple) // WARNING! This damage type does a small amount of stamina damage too.
	ammo_x_offset = 1
	shaded_charge = 1
	fire_delay = 15 // You fire your burst in 0.75 seconds, wait 0.75 seconds, then fire another burst. Effectively this is a 0.75s cooldown.
	burst_size = 3
	burst_shot_delay = 2.5
