/obj/item/implant/explosive
	name = "microbomb implant"
	desc = "And boom goes the weasel."
	icon_state = "explosive"
	actions_types = list(/datum/action/item_action/explosive_implant)
	// Explosive implant action is always available.
	var/weak = 2
	var/medium = 0.8
	var/heavy = 0.4
	var/delay = 7
	var/popup = FALSE // is the DOUWANNABLOWUP window open?
	var/active = FALSE

/obj/item/implant/explosive/trigger(emote, mob/source)
	if(emote == "deathgasp")
		activate("death")

/obj/item/implant/explosive/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Robust Corp RX-78 Employee Management Implant<BR>
				<b>Life:</b> Activates upon death.<BR>
				<b>Important Notes:</b> Explodes<BR>
				<HR>
				<b>Implant Details:</b><BR>
				<b>Function:</b> Contains a compact, electrically detonated explosive that detonates upon receiving a specially encoded signal or upon host death.<BR>
				<b>Special Features:</b> Explodes<BR>
				"}
	return dat

/obj/item/implant/explosive/activate(cause)
	. = ..()
	if(!cause || !imp_in || active)
		return FALSE
	if(cause == "action_button" && !popup)
		popup = TRUE
		var/response = alert(imp_in, "Are you sure you want to activate your [name]? This will cause you to explode!", "[name] Confirmation", "Yes", "No")
		popup = FALSE
		if(response == "No")
			return FALSE
	addtimer(CALLBACK(src, PROC_REF(timed_explosion), cause), 1)

/obj/item/implant/explosive/implant(mob/living/target)
	for(var/X in target.implants)
		if(istype(X, /obj/item/implant/explosive))
			var/obj/item/implant/explosive/imp_e = X
			imp_e.heavy += heavy
			imp_e.medium += medium
			imp_e.weak += weak
			imp_e.delay += delay
			qdel(src)
			return 1

	return ..()

/obj/item/implant/explosive/proc/timed_explosion(cause)
	if(cause == "death" && imp_in.stat != DEAD)
		return FALSE
	heavy = round(heavy)
	medium = round(medium)
	weak = round(weak)
	to_chat(imp_in, "<span class='notice'>You activate your [name].</span>")
	active = TRUE
	var/turf/boomturf = get_turf(imp_in)
	message_admins("[ADMIN_LOOKUPFLW(imp_in)] has activated their [name] at [ADMIN_VERBOSEJMP(boomturf)], with cause of [cause].")
	if(delay > 7)
		imp_in?.visible_message("<span class='warning'>[imp_in] starts beeping ominously!</span>")
		playsound(get_turf(imp_in ? imp_in : src), 'sound/items/timer.ogg', 30, 0)
		addtimer(CALLBACK(src, PROC_REF(double_pain), TRUE), delay * 0.25)
		addtimer(CALLBACK(src, PROC_REF(double_pain)), delay * 0.5)
		addtimer(CALLBACK(src, PROC_REF(double_pain)), delay * 0.75)
		addtimer(CALLBACK(src, PROC_REF(boom_goes_the_weasel)), delay)
	else //If the delay is short, just blow up already jeez
		boom_goes_the_weasel()

/obj/item/implant/explosive/proc/double_pain(message = FALSE)
	playsound(get_turf(imp_in ? imp_in : src), 'sound/items/timer.ogg', 30, 0)
	if(!imp_in)
		return
	if(message && imp_in.stat == CONSCIOUS)
		imp_in.visible_message("<span class='warning'>[imp_in] doubles over in pain!</span>")
	imp_in.DefaultCombatKnockdown(140)

/obj/item/implant/explosive/proc/boom_goes_the_weasel()
	explosion(get_turf(imp_in ? imp_in : src), heavy, medium, weak, weak, flame_range = weak)
	if(!QDELETED(imp_in))
		imp_in.gib(TRUE)
		qdel(src)

/obj/item/implant/explosive/macro
	name = "macrobomb implant"
	desc = "And boom goes the weasel. And everything else nearby."
	icon_state = "explosive"
	weak = 16
	medium = 8
	heavy = 4
	delay = 70

/obj/item/implant/explosive/macro/implant(mob/living/target)
	for(var/X in target.implants)
		if(istype(X, type))
			return FALSE

	return ..()


/obj/item/implanter/explosive
	name = "implanter (explosive)"
	imp_type = /obj/item/implant/explosive

/obj/item/implantcase/explosive
	name = "implant case - 'Explosive'"
	desc = "A glass case containing an explosive implant."
	imp_type = /obj/item/implant/explosive
