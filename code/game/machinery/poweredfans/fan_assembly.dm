/obj/structure/fan_assembly
	name = "fan assembly"
	desc = "A basic microfan assembly."
	icon = 'icons/obj/poweredfans.dmi'
	icon_state = "mfan_assembly"
	max_integrity = 150
	var/state = 1
	var/buildstacktype = /obj/item/stack/sheet/plasteel
	var/buildstackamount = 5
	/*
			1 = Wrenched in place
			2 = Welded in place
			3 = Wires attached to it
	*/

/obj/structure/fan_assembly/Initialize(mapload, ndir, building)
	. = ..()
	if(building)
		setDir(ndir)

/obj/structure/fan_assembly/Destroy()
	return ..()

/obj/structure/fan_assembly/attackby(obj/item/W, mob/living/user, params)
	switch(state)
		if(1)
			// State 1
			if(istype(W, /obj/item/weldingtool))
				if(weld(W, user))
					to_chat(user, "<span class='notice'>You weld the fan assembly securely into place.</span>")
					setAnchored(TRUE)
					state = 2
					update_icon()
				return
		if(2)
			// State 2
			if(istype(W, /obj/item/stack/cable_coil))
				if(!W.tool_start_check(user, amount=2))
					to_chat(user, "<span class='warning'>You need two lengths of cable to wire the fan assembly!</span>")
					return
				to_chat(user, "<span class='notice'>You start to add wires to the assembly...</span>")
				if(W.use_tool(src, user, 30, volume=50, amount=2))
					to_chat(user, "<span class='notice'>You add wires to the fan assembly.</span>")
					state = 3
					var/obj/machinery/poweredfans/F = new(loc, src)
					forceMove(F)
					F.setDir(src.dir)
					return
			else if(istype(W, /obj/item/weldingtool))
				if(weld(W, user))
					to_chat(user, "<span class='notice'>You unweld the fan assembly from its place.</span>")
					state = 1
					update_icon()
					setAnchored(FALSE)
				return
	return ..()

/obj/structure/fan_assembly/wirecutter_act(mob/user, obj/item/I)
	if(state != 3)
		return FALSE

	new /obj/item/stack/cable_coil(drop_location(), 2)
	I.play_tool_sound(src)
	to_chat(user, "<span class='notice'>You cut the wires from the circuits.</span>")
	state = 2
	update_icon()
	return TRUE

/obj/structure/fan_assembly/wrench_act(mob/user, obj/item/I)
	if(state != 1)
		return FALSE
	user.visible_message("<span class='warning'>[user] disassembles [src].</span>",
		"<span class='notice'>You start to disassemble [src]...</span>", "You hear wrenching noises.")
	if(I.use_tool(src, user, 30, volume=50))
		deconstruct()
	return TRUE

/obj/structure/fan_assembly/proc/weld(obj/item/weldingtool/W, mob/living/user)
	if(!W.tool_start_check(user, amount=0))
		return FALSE
	switch(state)
		if(1)
			to_chat(user, "<span class='notice'>You start to weld \the [src]...</span>")
		if(2)
			to_chat(user, "<span class='notice'>You start to unweld \the [src]...</span>")
	if(W.use_tool(src, user, 30, volume=50))
		return TRUE
	return FALSE

/obj/structure/fan_assembly/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new buildstacktype(loc,buildstackamount)
	qdel(src)

/obj/structure/fan_assembly/examine(mob/user)
	..()
	deconstruction_hints(user)

/obj/structure/fan_assembly/proc/deconstruction_hints(mob/user)
	switch(state)
		if(1)
			to_chat(user, "<span class='notice'>The fan assembly seems to be <b>unwelded</b> and loose.</span>")
		if(2)
			to_chat(user, "<span class='notice'>The fan assembly seems to be welded, but missing <b>wires</b>.</span>")
		if(3)
			to_chat(user, "<span class='notice'>The outer plating is <b>wired</b> firmly in place.</span>")

/obj/structure/fan_assembly/update_icon()
	switch(state)
		if(1)
			icon_state = "mfan_assembly"
		if(2)
			icon_state = "mfan_welded"
