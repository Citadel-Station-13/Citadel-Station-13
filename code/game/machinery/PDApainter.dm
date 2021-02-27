/obj/machinery/pdapainter
	name = "\improper PDA painter"
	desc = "A PDA painting machine. To use, simply insert your PDA and choose the desired preset paint scheme."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pdapainter"
	density = TRUE
	max_integrity = 200
	var/obj/item/pda/storedpda = null
	var/list/colorlist = list()


/obj/machinery/pdapainter/update_icon_state()

	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
		return

	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

	return

/obj/machinery/pdapainter/update_overlays()
	. = ..()

	if(stat & BROKEN)
		return

	if(storedpda)
		. += "[initial(icon_state)]-closed"

/obj/machinery/pdapainter/Initialize()
	. = ..()
	var/list/blocked = list(
		/obj/item/pda/ai/pai,
		/obj/item/pda/ai,
		/obj/item/pda/heads,
		/obj/item/pda/clear,
		/obj/item/pda/syndicate,
		/obj/item/pda/chameleon,
		/obj/item/pda/chameleon/broken,
		/obj/item/pda/lieutenant)

	for(var/A in typesof(/obj/item/pda) - blocked)
		var/obj/item/pda/P = A
		var/PDA_name = initial(P.name)
		colorlist += PDA_name
		colorlist[PDA_name] = list(initial(P.icon_state), initial(P.desc), initial(P.overlays_offsets), initial(P.overlays_icons))

/obj/machinery/pdapainter/Destroy()
	QDEL_NULL(storedpda)
	return ..()

/obj/machinery/pdapainter/on_deconstruction()
	if(storedpda)
		storedpda.forceMove(loc)
		storedpda = null

/obj/machinery/pdapainter/contents_explosion(severity, target)
	if(storedpda)
		storedpda.ex_act(severity, target)

/obj/machinery/pdapainter/handle_atom_del(atom/A)
	if(A == storedpda)
		storedpda = null
		update_icon()

/obj/machinery/pdapainter/attackby(obj/item/O, mob/user, params)
	if(default_unfasten_wrench(user, O))
		power_change()
		return

	else if(istype(O, /obj/item/pda))
		if(storedpda)
			to_chat(user, "<span class='warning'>There is already a PDA inside!</span>")
			return
		else if(!user.transferItemToLoc(O, src))
			return
		storedpda = O
		O.add_fingerprint(user)
		update_icon()

	else if(O.tool_behaviour == TOOL_WELDER && user.a_intent != INTENT_HARM)
		if(stat & BROKEN)
			if(!O.tool_start_check(user, amount=0))
				return
			user.visible_message("[user] is repairing [src].", \
							"<span class='notice'>You begin repairing [src]...</span>", \
							"<span class='italics'>You hear welding.</span>")
			if(O.use_tool(src, user, 40, volume=50))
				if(!(stat & BROKEN))
					return
				to_chat(user, "<span class='notice'>You repair [src].</span>")
				stat &= ~BROKEN
				obj_integrity = max_integrity
				update_icon()
		else
			to_chat(user, "<span class='notice'>[src] does not need repairs.</span>")
	else
		return ..()

/obj/machinery/pdapainter/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(!(stat & BROKEN))
			stat |= BROKEN
			update_icon()

/obj/machinery/pdapainter/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)

	if(!storedpda)
		to_chat(user, "<span class='notice'>[src] is empty.</span>")
		return
	var/choice = input(user, "Select the new skin!", "PDA Painting") as null|anything in colorlist
	if(!choice || !storedpda || !in_range(src, user))
		return
	var/list/P = colorlist[choice]
	storedpda.icon_state = P[1]
	storedpda.desc = P[2]
	storedpda.overlays_offsets = P[3]
	storedpda.overlays_icons = P[4]
	storedpda.set_new_overlays()
	storedpda.update_icon()
	ejectpda()

/obj/machinery/pdapainter/verb/ejectpda()
	set name = "Eject PDA"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || usr.restrained())
		return

	if(storedpda)
		storedpda.forceMove(drop_location())
		storedpda = null
		update_icon()
	else
		to_chat(usr, "<span class='notice'>[src] is empty.</span>")


/obj/machinery/pdapainter/power_change()
	..()
	update_icon()
