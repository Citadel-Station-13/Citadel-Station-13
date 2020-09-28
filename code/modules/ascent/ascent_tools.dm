/obj/item/crowbar/ascent
	name = "mantid clustertool"
	desc = "A complex assembly of self-guiding, modular heads capable of performing most manual tasks."
	icon = 'icons/obj/ascent/ascent_tools.dmi'
	icon_state = "clustertool_crowbar"
	toolspeed = 0.15

/obj/item/crowbar/ascent/attack_self(mob/user)
	playsound(get_turf(user), 'sound/items/change_jaws.ogg', 50, 1)
	var/obj/item/wirecutters/ascent/bugcutters = new /obj/item/wirecutters/ascent(drop_location())
	bugcutters.name = name
	to_chat(user, "<span class='notice'>You switch the clustertool to wirecutter mode.</span>")
	qdel(src)
	user.put_in_active_hand(bugcutters)

/obj/item/wirecutters/ascent
	name = "mantid clustertool"
	desc = "A complex assembly of self-guiding, modular heads capable of performing most manual tasks."
	icon = 'icons/obj/ascent/ascent_tools.dmi'
	icon_state = "clustertool_wirecutter"
	toolspeed = 0.15
	random_color = FALSE

/obj/item/wirecutters/ascent/attack_self(mob/user)
	playsound(get_turf(user),'sound/items/change_jaws.ogg',50,1)
	var/obj/item/wrench/ascent/bugwrench = new /obj/item/wrench/ascent(drop_location())
	bugwrench.name = name
	to_chat(user, "<span class='notice'>You switch the clustertool to wrench mode.</span>")
	qdel(src)
	user.put_in_active_hand(bugwrench)

/obj/item/wrench/ascent
	name = "mantid clustertool"
	desc = "A complex assembly of self-guiding, modular heads capable of performing most manual tasks."
	icon = 'icons/obj/ascent/ascent_tools.dmi'
	icon_state = "clustertool_wrench"
	toolspeed = 0.15

/obj/item/wrench/ascent/attack_self(mob/user)
	playsound(get_turf(user),'sound/items/change_jaws.ogg',50,1)
	var/obj/item/wirecutters/ascent/bugscrew = new /obj/item/screwdriver/ascent(drop_location())
	to_chat(user, "<span class='notice'>You switch the clustertool to screwdriver mode.</span>")
	qdel(src)
	user.put_in_active_hand(bugscrew)

/obj/item/screwdriver/ascent
	name = "mantid clustertool"
	desc = "A complex assembly of self-guiding, modular heads capable of performing most manual tasks."
	icon = 'icons/obj/ascent/ascent_tools.dmi'
	icon_state = "clustertool_screwdriver"
	toolspeed = 0.15
	random_color = FALSE

/obj/item/screwdriver/ascent/attack_self(mob/user)
	playsound(get_turf(user),'sound/items/change_jaws.ogg',50,1)
	var/obj/item/crowbar/ascent/bugpry = new /obj/item/crowbar/ascent(drop_location())
	to_chat(user, "<span class='notice'>You switch the clustertool to prying mode.</span>")
	qdel(src)
	user.put_in_active_hand(bugpry)

/obj/item/weldingtool/ascent
	name = "mantid welding arm"
	desc = "An electrical cutting torch of Ascent design."
	icon = 'icons/obj/ascent/ascent_tools.dmi'
	icon_state = "ascentwelder"
	toolspeed = 0.15
	light_intensity = 0
	change_icons = 0

/obj/item/weldingtool/ascent/process()
	if(get_fuel() <= max_fuel)
		reagents.add_reagent(/datum/reagent/fuel, 1)
	..()

/obj/item/multitool/ascent 
	name = "mantid integrated multitool"
	desc = "A limited-sentience integrated multitool capable of interfacing with any number of systems."
	icon = 'icons/obj/ascent/ascent_tools.dmi'
	icon_state = "ascentmultitool"
	toolspeed = 0.15 

/obj/item/storage/belt/ascent
	name = "mantid gear harness"
	desc = "A complex tangle of articulated cables and straps."
	icon = 'icons/obj/ascent/ascent_clothing.dmi'
	mob_overlay_icon = 'icons/mob/ascent/alate_clothing.dmi'
	icon_state = "ascent_harness"
	item_state = "ascent_harness"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_OCLOTHING

/obj/item/storage/belt/ascent/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.can_hold = typecacheof(list(
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/multitool,
		/obj/item/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/t_scanner,
		/obj/item/analyzer,
		/obj/item/geiger_counter,
		/obj/item/extinguisher/mini,
		/obj/item/radio,
		/obj/item/clothing/gloves,
		/obj/item/holosign_creator,
		/obj/item/forcefield_projector,
		/obj/item/assembly/signaler
		))

/obj/item/storage/belt/ascent/PopulateContents()
	new /obj/item/screwdriver/ascent(src)
	new /obj/item/crowbar/ascent(src)
	new /obj/item/weldingtool/ascent(src)
	new /obj/item/multitool/ascent(src)
	new /obj/item/stack/cable_coil/cyan(src)