/obj/item/borg/upgrade/xwelding
	name = "engineering cyborg experimental welding tool"
	desc = "An experimental welding tool replacement for the engineering module's standard welding tool."
	icon_state = "cyborg_upgrade3"
	require_module = 1
	module_type = list(/obj/item/robot_module/engineering)

/obj/item/borg/upgrade/xwelding/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/weldingtool/largetank/cyborg/WT = locate() in R
		var/obj/item/weldingtool/experimental/XW = locate() in R
		if(!WT)
			WT = locate() in R.module
		if(!XW)
			XW = locate() in R.module
		if(XW)
			to_chat(user, "<span class='warning'>This unit is already equipped with an experimental welding tool module.</span>")
			return FALSE
		XW = new(R.module)
		qdel(WT)
		R.module.basic_modules += XW
		R.module.add_module(XW, FALSE, TRUE)

/obj/item/borg/upgrade/xwelding/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/weldingtool/experimental/XW in R.module)
			R.module.remove_module(XW, TRUE)

		var/obj/item/weldingtool/largetank/cyborg/WT = new (R.module)
		R.module.basic_modules += WT
		R.module.add_module(WT, FALSE, TRUE)

/* Shit doesnt work, work on it later
/obj/item/borg/upgrade/plasma
	name = "engineering cyborg plasma resource upgrade"
	desc = "An upgrade that allows cyborgs the ability to use plasma and assorted plasma products."
	icon_state = "cyborg_upgrade3"
	require_module = 1
	module_type = list(/obj/item/robot_module/engineering)
*/

/* Shit doesnt work, do it later
/obj/item/borg/upgrade/plasma/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		R.module.basic_modules += /obj/item/stack/sheet/plasmaglass/cyborg
		R.module.add_module(/obj/item/stack/sheet/plasmaglass/cyborg, FALSE, TRUE)
		R.module.basic_modules += /obj/item/stack/sheet/plasmarglass/cyborg
		R.module.add_module(/obj/item/stack/sheet/plasmarglass/cyborg, FALSE, TRUE)
		R.module.basic_modules += /obj/item/stack/sheet/plasteel/cyborg
		R.module.add_module(/obj/item/stack/sheet/plasteel/cyborg, FALSE, TRUE)
		R.module.basic_modules += /obj/item/stack/sheet/mineral/plasma/cyborg
		R.module.add_module(/obj/item/stack/sheet/mineral/plasma/cyborg, FALSE, TRUE)

/obj/item/borg/upgrade/plasma/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		R.module.remove_module(/obj/item/stack/sheet/plasmaglass/cyborg, TRUE)
		R.module.remove_module(/obj/item/stack/sheet/plasmarglass/cyborg, TRUE)
		R.module.remove_module(/obj/item/stack/sheet/plasteel/cyborg, TRUE)
		R.module.remove_module(/obj/item/stack/sheet/mineral/plasma/cyborg, TRUE)
*/

/obj/item/borg/upgrade/bsrpd
	name = "engineering cyborg bluespace RPD"
	desc = "A bluespace RPD replacement for the engineering module's standard RPD."
	icon_state = "cyborg_upgrade3"
	require_module = 1
	module_type = list(/obj/item/robot_module/engineering)

/obj/item/borg/upgrade/bsrpd/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/pipe_dispenser/PD = locate() in R
		var/obj/item/pipe_dispenser/bluespace/BD = locate() in R // Skyrat edit
		if(!PD)
			PD = locate() in R.module
		if(!BD)
			BD = locate() in R.module //There's gotta be a smarter way to do this.
		if(BD)
			to_chat(user, "<span class='warning'>This unit is already equipped with a BSRPD module.</span>")
			return FALSE

		BD = new(R.module)
		qdel(PD)
		R.module.basic_modules += BD
		R.module.add_module(BD, FALSE, TRUE)

/obj/item/borg/upgrade/bsrpd/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/pipe_dispenser/bluespace/BD in R.module) // Skyrat edit
			R.module.remove_module(BD, TRUE)

		var/obj/item/pipe_dispenser/PD = new (R.module)
		R.module.basic_modules += PD
		R.module.add_module(PD, FALSE, TRUE)

/obj/item/borg/upgrade/premiumka
	name = "mining cyborg premium KA"
	desc = "A premium kinetic accelerator replacement for the mining module's standard kinetic accelerator."
	icon_state = "cyborg_upgrade3"
	require_module = 1
	module_type = list(/obj/item/robot_module/miner)

/obj/item/borg/upgrade/premiumka/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/gun/energy/kinetic_accelerator/cyborg/KA in R.module)
			for(var/obj/item/borg/upgrade/modkit/M in KA.modkits)
				M.uninstall(src)
			R.module.remove_module(KA, TRUE)

		var/obj/item/gun/energy/kinetic_accelerator/premiumka/cyborg/PKA = new /obj/item/gun/energy/kinetic_accelerator/premiumka/cyborg(R.module)
		R.module.basic_modules += PKA
		R.module.add_module(PKA, FALSE, TRUE)

/obj/item/borg/upgrade/premiumka/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/gun/energy/kinetic_accelerator/premiumka/cyborg/PKA in R.module)
			for(var/obj/item/borg/upgrade/modkit/M in PKA.modkits)
				M.uninstall(src)
			R.module.remove_module(PKA, TRUE)

		var/obj/item/gun/energy/kinetic_accelerator/cyborg/KA = new (R.module)
		R.module.basic_modules += KA
		R.module.add_module(KA, FALSE, TRUE)

/obj/item/borg/upgrade/expand/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)

		if(R.hasExpanded)
			to_chat(usr, "<span class='notice'>This unit already has an expand module installed!</span>")
			return FALSE

		if(R.hasShrunk)
			to_chat(usr, "<span class='notice'>This unit already has an shrink module installed!</span>")
			return FALSE

		R.mob_transforming = TRUE
		var/prev_locked_down = R.locked_down
		R.SetLockdown(1)
		R.anchored = TRUE
		var/datum/effect_system/smoke_spread/smoke = new
		smoke.set_up(1, R.loc)
		smoke.start()
		sleep(2)
		for(var/i in 1 to 4)
			playsound(R, pick('sound/items/drill_use.ogg', 'sound/items/jaws_cut.ogg', 'sound/items/jaws_pry.ogg', 'sound/items/welder.ogg', 'sound/items/ratchet.ogg'), 80, 1, -1)
			sleep(12)
		if(!prev_locked_down)
			R.SetLockdown(0)
		R.anchored = FALSE
		R.mob_transforming = FALSE
		R.transform = R.transform.Scale(1.25, 1.25)
		R.hasExpanded = TRUE

/obj/item/borg/upgrade/expand/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		R.transform = R.transform.Scale(0.8, 0.8)
		R.hasExpanded = FALSE

/obj/item/borg/upgrade/shrink
	name = "borg shrinker"
	desc = "A cyborg resizer, it makes a cyborg small."
	icon_state = "cyborg_upgrade3"

/obj/item/borg/upgrade/shrink/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)

		if(R.hasShrunk)
			to_chat(usr, "<span class='notice'>This unit already has an shrink module installed!</span>")
			return FALSE

		if(R.hasExpanded)
			to_chat(usr, "<span class='notice'>This unit already has an expand module installed!</span>")
			return FALSE


		R.mob_transforming = TRUE
		var/prev_locked_down = R.locked_down
		R.SetLockdown(1)
		R.anchored = TRUE
		var/datum/effect_system/smoke_spread/smoke = new
		smoke.set_up(1, R.loc)
		smoke.start()
		sleep(2)
		for(var/i in 1 to 4)
			playsound(R, pick('sound/items/drill_use.ogg', 'sound/items/jaws_cut.ogg', 'sound/items/jaws_pry.ogg', 'sound/items/welder.ogg', 'sound/items/ratchet.ogg'), 80, 1, -1)
			sleep(12)
		if(!prev_locked_down)
			R.SetLockdown(0)
		R.anchored = FALSE
		R.mob_transforming = FALSE
		R.transform = R.transform.Scale(0.75, 0.75)
		R.hasShrunk = TRUE

/obj/item/borg/upgrade/shrink/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		R.transform = R.transform.Scale((4/3), (4/3))
		R.hasShrunk = FALSE

/obj/item/borg/upgrade/transform/syndicatejack
    name = "borg module picker (Syndicate)"
    desc = "Allows you to to turn a cyborg into a experimental syndicate cyborg."
    icon_state = "cyborg_upgrade3"
    new_module = /obj/item/robot_module/syndicatejack

/obj/item/borg/upgrade/transform/syndicatejack/action(mob/living/silicon/robot/R, user = usr)
    if(R.emagged)
        return ..()
