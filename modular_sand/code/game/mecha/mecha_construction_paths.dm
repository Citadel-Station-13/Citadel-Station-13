/datum/component/construction/mecha/examine(datum/source, mob/user, list/examine_list)
	. = ..()
	if(looky_helpy)
		switch(steps[index]["key"])
			if(TOOL_WELDER)
				examine_list += "<span class='notice'>The mech's parts could be <b>welded</b> into place.</span>"
			if(/obj/item/stack/sheet/bluespace_crystal)
				examine_list += "<span class='notice'>The mech could use a <b>crystal</b> of sorts.</span>"
			if(/obj/item/stock_parts/capacitor/quadratic)
				examine_list += "<span class='notice'>The mech requires a <b>quadratic capacitor</b>.</span>"
			//All the game's boards because code is stupid --start
			if(/obj/item/circuitboard/mecha/ripley/main)
				examine_list += "<span class='notice'>The mech requires a <b>Ripley Central Control module circuitboard</b>.</span>"
			if(/obj/item/circuitboard/mecha/ripley/peripherals)
				examine_list += "<span class='notice'>The mech requires a <b>Ripley Peripherals Control circuitboard</b>.</span>"
			if(/obj/item/circuitboard/mecha/gygax/main)
				examine_list += "<span class='notice'>The mech requires a <b>Gygax Central Control circuitboard</b>.</span>"
			if(/obj/item/circuitboard/mecha/gygax/peripherals)
				examine_list += "<span class='notice'>The mech requires a <b>Gygax Peripherals Control circuitboard</b>.</span>"
			if(/obj/item/circuitboard/mecha/gygax/targeting)
				examine_list += "<span class='notice'>The mech requires a <b>Gygax Weapon Control and Targeting circuitboard</b>.</span>"
			if(/obj/item/circuitboard/mecha/honker/main)
				examine_list += "<span class='notice'>The mech requires a <b>H.O.N.K Central Control circuitboard</b>.</span>"
			if(/obj/item/circuitboard/mecha/honker/peripherals)
				examine_list += "<span class='notice'>The mech requires a <b>H.O.N.K Peripherals Control circuitboard</b>.</span>"
			if(/obj/item/circuitboard/mecha/honker/targeting)
				examine_list += "<span class='notice'>The mech requires a <b>H.O.N.K Weapon Control and Targeting circuitboard</b>.</span>"
			if(/obj/item/circuitboard/mecha/durand/main)
				examine_list += "<span class='notice'>The mech requires a <b>Durand Central Control circuitboard</b>.</span>"
			if(/obj/item/circuitboard/mecha/durand/peripherals)
				examine_list += "<span class='notice'>The mech requires a <b>Durand Peripherals Control circuitboard</b>.</span>"
			if(/obj/item/circuitboard/mecha/durand/targeting)
				examine_list += "<span class='notice'>The mech requires a <b>Durand Weapon Control and Targeting circuitboard</b>.</span>"
			if(/obj/item/circuitboard/mecha/phazon/main)
				examine_list += "<span class='notice'>The mech requires a <b>Phazon Central Control circuitboard</b>.</span>"
			if(/obj/item/circuitboard/mecha/phazon/peripherals)
				examine_list += "<span class='notice'>The mech requires a <b>Phazon Peripherals Control circuitboard</b>.</span>"
			if(/obj/item/circuitboard/mecha/phazon/targeting)
				examine_list += "<span class='notice'>The mech requires a <b>Phazon Weapon Control and Targeting circuitboard</b>.</span>"
			if(/obj/item/circuitboard/mecha/odysseus/main)
				examine_list += "<span class='notice'>The mech requires a <b>Odysseus Central Control circuitboard</b>.</span>"
			if(/obj/item/circuitboard/mecha/odysseus/peripherals)
				examine_list += "<span class='notice'>The mech requires a <b>Odysseus Peripherals Control circuitboard</b>.</span>"
			//All the game's boards because code is stupid --end

//Power armor: now actually built!
/datum/component/construction/unordered/mecha_chassis/powerarmor
	result = /datum/component/construction/mecha/powerarmor
	steps = list(
		/obj/item/mecha_parts/part/powerarmor_torso,
		/obj/item/mecha_parts/part/powerarmor_helmet,
		/obj/item/mecha_parts/part/powerarmor_left_arm,
		/obj/item/mecha_parts/part/powerarmor_right_arm,
		/obj/item/mecha_parts/part/powerarmor_left_leg,
		/obj/item/mecha_parts/part/powerarmor_right_leg
	)

/datum/component/construction/mecha/powerarmor/update_parent(step_index)
	..()
	var/atom/parent_atom = parent
	parent_atom.icon = 'modular_sand/icons/mecha/mech_construction.dmi'

/datum/component/construction/mecha/powerarmor/spawn_result()
	if(!result)
		return
	new result(drop_location())
	SSblackbox.record_feedback("tally", "mechas_created", 1, "Power Armor")
	QDEL_NULL(parent)

/datum/component/construction/mecha/powerarmor
	result = /obj/item/clothing/suit/space/hardsuit/powerarmor
	base_icon = "powerarmor"
	steps = list(
		//1
		list(
			"key" = TOOL_WRENCH,
			"desc" = "The parts are disconnected."
		),

		//2
		list(
			"key" = TOOL_WELDER,
			"back_key" = TOOL_WRENCH,
			"desc" = "The parts are wrenched."
		),

		//3
		list(
			"key" = /obj/item/stack/sheet/bluespace_crystal,
			"amount" = 5,
			"back_key" = TOOL_WELDER,
			"desc" = "The parts are welded onto the chassis."
		),

		//4
		list(
			"key" = TOOL_WRENCH,
			"back_key" = TOOL_SCREWDRIVER,
			"desc" = "The bluespace crystals are slotted."
		),

		//5
		list(
			"key" = /obj/item/stock_parts/capacitor/quadratic,
			"action" = ITEM_MOVE_INSIDE,
			"back_key" = TOOL_WRENCH,
			"desc" = "The bluespace crystals are secured."
		),

		//6
		list(
			"key" = TOOL_WRENCH,
			"back_key" = TOOL_SCREWDRIVER,
			"desc" = "The capacitor is slotted."
		),

		//7
		list(
			"key" = /obj/item/stack/cable_coil,
			"amount" = 10,
			"back_key" = TOOL_SCREWDRIVER,
			"desc" = "The capacitor is secured."
		),

		//8
		list(
			"key" = TOOL_SCREWDRIVER,
			"back_key" = TOOL_WIRECUTTER,
			"desc" = "The chassis is wired."
		),

		//9
		list(
			"key" = TOOL_WELDER,
			"back_key" = TOOL_SCREWDRIVER,
			"desc" = "The wiring is linked to the limbs."
		),
	)

/datum/component/construction/mecha/powerarmor/custom_action(obj/item/I, mob/living/user, diff)
	if(!..())
		return FALSE

	switch(index)
		if(1)
			user.visible_message("[user] wrenches [parent]'s parts.", "<span class='notice'>You wrench [parent]'s parts.</span>")
		if(2)
			if(diff==FORWARD)
				user.visible_message("[user] welds [parent]'s parts.", "<span class='notice'>You weld [parent]'s parts</span>")
			else
				user.visible_message("[user] unwrenches [parent]'s parts.", "<span class='notice'>You unwrench [parent]'s parts.</span>")
		if(3)
			if(diff==FORWARD)
				user.visible_message("[user] slots bluespace crystals onto [parent].", "<span class='notice'>You slot the bluespace crystals onto [parent].</span>")
			else
				user.visible_message("[user] unwelds [parent]'s parts.", "<span class='notice'>You unweld [parent]'s parts.</span>")
		if(4)
			if(diff==FORWARD)
				user.visible_message("[user] secures the [parent]'s bluespace crystal slots.", "<span class='notice'>You secure the [parent]'s bluespace crystal slots</span>")
			else
				user.visible_message("[user] removes the bluespace crystals from [parent].", "<span class='notice'>You remove [parent]'s bluespace crystals.</span>")
		if(5)
			if(diff==FORWARD)
				user.visible_message("[user] slots the capacitor onto [parent].", "<span class='notice'>You slot the capacitor onto [parent].</span>")
			else
				user.visible_message("[user] unsecures the bluespace crystal slots from [parent].", "<span class='notice'>You unsecure [parent]'s bluespace crystal slots.</span>")
		if(6)
			if(diff==FORWARD)
				user.visible_message("[user] secures [parent]'s capacitor.", "<span class='notice'>You secure [parent]'s capacitor.</span>")
			else
				user.visible_message("[user] removes the [parent]'s capacitor.", "<span class='notice'>You remove the [parent]'s capacitor.</span>")
		if(7)
			if(diff==FORWARD)
				user.visible_message("[user] wires the [parent].", "<span class='notice'>You wire the [parent].</span>")
			else
				user.visible_message("[user] unsecures [parent]'s capacitor.", "<span class='notice'>You unsecure [parent]'s capacitor.</span>")
		if(8)
			if(diff==FORWARD)
				user.visible_message("[user] links [parent]'s wires to the limbs.", "<span class='notice'>You link [parent]'s wires to the limbs.</span>")
			else
				user.visible_message("[user] snips off [parent]'s wires.", "<span class='notice'>You snip off [parent]'s wires.</span>")
		if(9)
			if(diff==FORWARD)
				user.visible_message("[user] welds [parent]'s external armor layer.", "<span class='notice'>You weld [parent]'s external armor layer.</span>")
			else
				user.visible_message("[user] unlinks [parent]'s wires from the limbs.", "<span class='notice'>You unlink [parent]'s wires from the limbs.</span>")
	return TRUE
