/obj/machinery/dna_scannernew
	name = "\improper DNA scanner"
	desc = "It scans DNA structures."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "scanner"
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 50
	active_power_usage = 300
	occupant_typecache = list(/mob/living, /obj/item/bodypart/head, /obj/item/organ/brain)
	circuit = /obj/item/circuitboard/machine/clonescanner
	var/locked = FALSE
	var/damage_coeff
	var/scan_level
	var/precision_coeff
	var/message_cooldown
	var/breakout_time = 1200

/obj/machinery/dna_scannernew/RefreshParts()
	scan_level = 0
	damage_coeff = 0
	precision_coeff = 0
	for(var/obj/item/stock_parts/scanning_module/P in component_parts)
		scan_level += P.rating
	for(var/obj/item/stock_parts/matter_bin/P in component_parts)
		precision_coeff = P.rating
	for(var/obj/item/stock_parts/micro_laser/P in component_parts)
		damage_coeff = P.rating

/obj/machinery/dna_scannernew/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Radiation pulse accuracy increased by factor <b>[precision_coeff**2]</b>.<br>Radiation pulse damage decreased by factor <b>[damage_coeff**2]</b>.</span>"
		if(scan_level >= 3)
			. += "<span class='notice'>Scanner has been upgraded to support autoprocessing.<span>"

/obj/machinery/dna_scannernew/update_icon_state()

	//no power or maintenance
	if(stat & (NOPOWER|BROKEN))
		icon_state = initial(icon_state)+ (state_open ? "_open" : "") + "_unpowered"
		return

	if((stat & MAINT) || panel_open)
		icon_state = initial(icon_state)+ (state_open ? "_open" : "") + "_maintenance"
		return

	//running and someone in there
	if(occupant)
		icon_state = initial(icon_state)+ "_occupied"
		return

	//running
	icon_state = initial(icon_state)+ (state_open ? "_open" : "")

/obj/machinery/dna_scannernew/power_change()
	..()
	update_icon()

/obj/machinery/dna_scannernew/proc/toggle_open(mob/user)
	if(panel_open)
		to_chat(user, "<span class='notice'>Close the maintenance panel first.</span>")
		return

	if(state_open)
		close_machine()
		return

	else if(locked)
		to_chat(user, "<span class='notice'>The bolts are locked down, securing the door shut.</span>")
		return

	open_machine()

/obj/machinery/dna_scannernew/container_resist(mob/living/user)
	if(!locked)
		open_machine()
		return
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	user.visible_message("<span class='notice'>You see [user] kicking against the door of [src]!</span>", \
		"<span class='notice'>You lean on the back of [src] and start pushing the door open... (this will take about [DisplayTimeText(breakout_time)].)</span>", \
		"<span class='italics'>You hear a metallic creaking from [src].</span>")
	if(do_after(user,(breakout_time), target = src))
		if(!user || user.stat != CONSCIOUS || user.loc != src || state_open || !locked)
			return
		locked = FALSE
		user.visible_message("<span class='warning'>[user] successfully broke out of [src]!</span>", \
			"<span class='notice'>You successfully break out of [src]!</span>")
		open_machine()

/obj/machinery/dna_scannernew/proc/locate_computer(type_)
	for(var/direction in GLOB.cardinals)
		var/C = locate(type_, get_step(src, direction))
		if(C)
			return C
	return null

/obj/machinery/dna_scannernew/close_machine(atom/movable/target)
	if(!state_open)
		return FALSE

	..(target)

	// search for ghosts, if the corpse is empty and the scanner is connected to a cloner
	var/mob/living/mob_occupant = get_mob_or_brainmob(occupant)
	if(istype(mob_occupant))
		if(locate_computer(/obj/machinery/computer/cloning))
			if(!mob_occupant.suiciding && !(HAS_TRAIT(mob_occupant, TRAIT_NOCLONE)) && !mob_occupant.hellbound)
				mob_occupant.notify_ghost_cloning("Your corpse has been placed into a cloning scanner. Re-enter your corpse if you want to be cloned!", source = src)

	// DNA manipulators cannot operate on severed heads or brains
	if(isliving(occupant))
		var/obj/machinery/computer/scan_consolenew/console = locate_computer(/obj/machinery/computer/scan_consolenew)
		if(console)
			console.on_scanner_close()

	return TRUE

/obj/machinery/dna_scannernew/open_machine()
	if(state_open || panel_open)
		return FALSE

	..()

	return TRUE

/obj/machinery/dna_scannernew/relaymove(mob/user as mob)
	if(user.stat || locked)
		if(message_cooldown <= world.time)
			message_cooldown = world.time + 50
			to_chat(user, "<span class='warning'>[src]'s door won't budge!</span>")
		return
	open_machine()

/obj/machinery/dna_scannernew/screwdriver_act(mob/living/user, obj/item/I)
	. = TRUE
	if(..())
		return
	if(occupant)
		to_chat(user, "<span class='warning'>[src] is currently occupied!</span>")
		return
	if(state_open)
		to_chat(user, "<span class='warning'>[src] must be closed to [panel_open ? "close" : "open"] its maintenance hatch!</span>")
		return
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, I)) //sent icon_state is irrelevant...
		update_icon() //..since we're updating the icon here, since the scanner can be unpowered when opened/closed
		return
	return FALSE

/obj/machinery/dna_scannernew/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	if(default_change_direction_wrench(user, I))
		return TRUE

/obj/machinery/dna_scannernew/crowbar_act(mob/living/user, obj/item/I)
	. = ..()
	if(default_pry_open(I))
		return TRUE
	if(default_deconstruction_crowbar(I))
		return TRUE

/obj/machinery/dna_scannernew/default_pry_open(obj/item/I) //wew
	. = !(state_open || panel_open || (flags_1 & NODECONSTRUCT_1)) && I.tool_behaviour == TOOL_CROWBAR
	if(.)
		I.play_tool_sound(src, 50)
		visible_message("<span class='notice'>[usr] pries open [src].</span>", "<span class='notice'>You pry open [src].</span>")
		open_machine()

/obj/machinery/dna_scannernew/interact(mob/user)
	toggle_open(user)

/obj/machinery/dna_scannernew/AltClick(mob/user)
	. = ..()
	if(!user.canUseTopic(src, !hasSiliconAccessInArea(user)))
		return
	interact(user)
	return TRUE

/obj/machinery/dna_scannernew/MouseDrop_T(mob/target, mob/user)
	if(user.stat || user.lying || !Adjacent(user) || !user.Adjacent(target) || !iscarbon(target) || !user.IsAdvancedToolUser())
		return
	close_machine(target)
