GLOBAL_LIST_EMPTY(doppler_arrays)

/obj/machinery/doppler_array
	name = "tachyon-doppler array"
	desc = "A highly precise directional sensor array which measures the release of quants from decaying tachyons. The doppler shifting of the mirror-image formed by these quants can reveal the size, location and temporal affects of energetic disturbances within a large radius ahead of the array.\n"
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "tdoppler"
	density = TRUE
	var/integrated = FALSE
	var/list_limit = 100
	var/cooldown = 10
	var/next_announce = 0
	var/max_dist = 150
	verb_say = "states coldly"
	var/list/message_log = list()

/obj/machinery/doppler_array/Initialize()
	. = ..()
	GLOB.doppler_arrays += src

/obj/machinery/doppler_array/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE,null,null,CALLBACK(src,.proc/rot_message))

/obj/machinery/doppler_array/Destroy()
	GLOB.doppler_arrays -= src
	return ..()

/obj/machinery/doppler_array/ui_interact(mob/user)
	. = ..()
	if(stat)
		return FALSE

	var/list/dat = list()
	for(var/i in 1 to LAZYLEN(message_log))
		dat += "Log recording #[i]: [message_log[i]]<br/><br>"
	dat += "<A href='?src=[REF(src)];delete_log=1'>Delete logs</A><br>"
	dat += "<hr>"
	dat += "<A href='?src=[REF(src)];refresh=1'>(Refresh)</A><br>"
	dat += "</body></html>"
	var/datum/browser/popup = new(user, "computer", name, 400, 500)
	popup.set_content(dat.Join(" "))
	popup.open()

/obj/machinery/doppler_array/Topic(href, href_list)
	if(..())
		return
	if(href_list["delete_log"])
		LAZYCLEARLIST(message_log)
	if(href_list["refresh"])
		updateUsrDialog()

	updateUsrDialog()
	return

/obj/machinery/doppler_array/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/wrench))
		if(!anchored && !isinspace())
			anchored = TRUE
			power_change()
			to_chat(user, "<span class='notice'>You fasten [src].</span>")
		else if(anchored)
			anchored = FALSE
			power_change()
			to_chat(user, "<span class='notice'>You unfasten [src].</span>")
		I.play_tool_sound(src)
	else
		return ..()

/obj/machinery/doppler_array/proc/rot_message(mob/user)
	to_chat(user, "<span class='notice'>You adjust [src]'s dish to face to the [dir2text(dir)].</span>")
	playsound(src, 'sound/items/screwdriver2.ogg', 50, 1)

/obj/machinery/doppler_array/proc/sense_explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range,
												  took, orig_dev_range, orig_heavy_range, orig_light_range)
	if(stat & NOPOWER)
		return FALSE
	var/turf/zone = get_turf(src)
	if(zone.z != epicenter.z)
		return FALSE

	if(next_announce > world.time)
		return FALSE
	next_announce = world.time + cooldown

	if((get_dist(epicenter, zone) > max_dist) || !(get_dir(zone, epicenter) & dir))
		return FALSE


	var/list/messages = list("Explosive disturbance detected.", \
							 "Epicenter at: grid ([epicenter.x],[epicenter.y]). Temporal displacement of tachyons: [took] seconds.", \
							 "Factual: Epicenter radius: [devastation_range]. Outer radius: [heavy_impact_range]. Shockwave radius: [light_impact_range].")

	// If the bomb was capped, say its theoretical size.
	if(devastation_range < orig_dev_range || heavy_impact_range < orig_heavy_range || light_impact_range < orig_light_range)
		messages += "Theoretical: Epicenter radius: [orig_dev_range]. Outer radius: [orig_heavy_range]. Shockwave radius: [orig_light_range]."

	if(integrated)
		var/obj/item/clothing/head/helmet/space/hardsuit/helm = loc
		if(!helm || !istype(helm, /obj/item/clothing/head/helmet/space/hardsuit))
			return FALSE
		helm.display_visor_message("Explosion detected! Epicenter: [devastation_range], Outer: [heavy_impact_range], Shock: [light_impact_range]")
	else
		for(var/message in messages)
			say(message)
		if(LAZYLEN(message_log) > list_limit)
			say("Storage buffer is full! Clearing buffers...")
			LAZYCLEARLIST(message_log)
		LAZYADD(message_log, messages.Join(" "))

	SEND_SIGNAL(src, COMSIG_DOPPLER_ARRAY_EXPLOSION_DETECTED, epicenter, devastation_range, heavy_impact_range, light_impact_range, took, orig_dev_range, orig_heavy_range, orig_light_range)

	return TRUE

/obj/machinery/doppler_array/powered()
	return anchored ? ..() : FALSE

/obj/machinery/doppler_array/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Its dish is facing to the [dir2text(dir)].</span>"

/obj/machinery/doppler_array/process()
	return PROCESS_KILL

/obj/machinery/doppler_array/power_change()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else
		if(powered() && anchored)
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
		else
			icon_state = "[initial(icon_state)]-off"
			stat |= NOPOWER

//Portable version, built into EOD equipment. It simply provides an explosion's three damage levels.
/obj/machinery/doppler_array/integrated
	name = "integrated tachyon-doppler module"
	integrated = TRUE
	max_dist = 21 //Should detect most explosions in hearing range.
	use_power = NO_POWER_USE

/obj/machinery/doppler_array/research
	name = "tachyon-doppler research array"
	desc = "A specialized tachyon-doppler bomb detection array that uses complex on-board software to record data for experiments."
	circuit = /obj/item/circuitboard/machine/doppler_array
	var/datum/techweb/linked_techweb

/obj/machinery/doppler_array/research/Initialize()
	..()
	linked_techweb = SSresearch.science_tech
	return INITIALIZE_HINT_LATELOAD

// Late initialize to allow the server machinery to initialize first
/obj/machinery/doppler_array/research/LateInitialize()
	. = ..()
	AddComponent(/datum/component/experiment_handler, \
		allowed_experiments = list(/datum/experiment/explosion), \
		config_mode = EXPERIMENT_CONFIG_UI, \
		config_flags = EXPERIMENT_CONFIG_ALWAYS_ACTIVE)

/obj/machinery/doppler_array/research/attackby(obj/item/I, mob/user, params)
	if (default_deconstruction_screwdriver(user, "tdoppler", "tdoppler", I) \
		|| default_deconstruction_crowbar(I))
		update_icon()
		return
	return ..()

/obj/machinery/doppler_array/research/sense_explosion(turf/epicenter, dev, heavy, light, time, orig_dev, orig_heavy, orig_light)	//probably needs a way to ignore admin explosives later on
	. = ..()
	if(!.)
		return FALSE
	if(!istype(linked_techweb))
		say("Warning: No linked research system!")
		return

	var/cash_gain = 0

	/*****The Point Calculator*****/

	if(orig_light < 10)
		say("Explosion not large enough for profitability.")
		return
	else if(orig_light < 4500)
		cash_gain = (83300 * orig_light) / (orig_light + 3000)
	else
		cash_gain  = TECHWEB_BOMB_POINTCAP

	/*****The Point Capper*****/
	if(cash_gain > linked_techweb.largest_bomb_value)
		if(cash_gain <= TECHWEB_BOMB_CASHCAP || linked_techweb.largest_bomb_value < TECHWEB_BOMB_CASHCAP)
			var/old_tech_largest_bomb_value = linked_techweb.largest_bomb_value //held so we can pull old before we do math
			linked_techweb.largest_bomb_value = cash_gain
			cash_gain -= old_tech_largest_bomb_value
			cash_gain = min(cash_gain,TECHWEB_BOMB_CASHCAP)
		else
			linked_techweb.largest_bomb_value = TECHWEB_BOMB_CASHCAP
			cash_gain = 1000
		var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_SCI)
		if(D)
			D.adjust_money(cash_gain)
			say("Explosion details and mixture analyzed and sold to the highest bidder for [cash_gain] cr.")

	else //you've made smaller bombs
		say("Data already captured. Aborting.")
		return


/obj/machinery/doppler_array/research/science/Initialize()
	. = ..()
	linked_techweb = SSresearch.science_tech

/obj/machinery/doppler_array/research/ui_data(mob/user)
	. = ..()
	.["is_research"] = TRUE

/obj/machinery/doppler_array/research/ui_act(action, list/params)
	. = ..()
	if (.)
		return
