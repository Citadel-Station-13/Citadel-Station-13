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

/obj/machinery/doppler_array/Initialize(mapload)
	. = ..()
	GLOB.doppler_arrays += src

/obj/machinery/doppler_array/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE,null,null,CALLBACK(src,PROC_REF(rot_message)))

/obj/machinery/doppler_array/Destroy()
	GLOB.doppler_arrays -= src
	return ..()

/obj/machinery/doppler_array/ui_interact(mob/user)
	. = ..()
	if(machine_stat)
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
	if(I.tool_behaviour == TOOL_WRENCH)
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
	if(machine_stat & NOPOWER)
		return FALSE
	var/turf/zone = get_turf(src)
	if(zone.z != epicenter.z)
		return FALSE

	if(next_announce > world.time)
		return FALSE
	next_announce = world.time + cooldown

	var/distance = get_dist(epicenter, zone)
	var/direct = get_dir(zone, epicenter)

	if(distance > max_dist)
		return FALSE
	if(!(direct & dir) && !integrated)
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
	return TRUE

/obj/machinery/doppler_array/proc/sense_wave_explosion(turf/epicenter, power, speed)
	if(machine_stat & NOPOWER)
		return FALSE
	var/turf/zone = get_turf(src)
	if(zone.z != epicenter.z)
		return FALSE

	if(next_announce > world.time)
		return FALSE
	next_announce = world.time + cooldown

	var/distance = get_dist(epicenter, zone)
	var/direct = get_dir(zone, epicenter)

	if(distance > max_dist)
		return FALSE
	if(!(direct & dir) && !integrated)
		return FALSE


	var/list/messages = list("Explosive shockwave detected.", \
							 "Epicenter at: grid ([epicenter.x],[epicenter.y]). Shockwave expanding at a theoretical speed of [speed] m/s.", \
							 "Wave energy: [power]MJ.")

	if(integrated)
		var/obj/item/clothing/head/helmet/space/hardsuit/helm = loc
		if(!helm || !istype(helm, /obj/item/clothing/head/helmet/space/hardsuit))
			return FALSE
		helm.display_visor_message("Waveform explosion detected! Wave energy: [power]MJ.")
	else
		for(var/message in messages)
			say(message)
		if(LAZYLEN(message_log) > list_limit)
			say("Storage buffer is full! Clearing buffers...")
			LAZYCLEARLIST(message_log)
		LAZYADD(message_log, messages.Join(" "))
	return TRUE

/obj/machinery/doppler_array/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Its dish is facing to the [dir2text(dir)].</span>"

/obj/machinery/doppler_array/process()
	return PROCESS_KILL

/obj/machinery/doppler_array/power_change()
	if(machine_stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else
		if(powered() && anchored)
			icon_state = initial(icon_state)
			machine_stat &= ~NOPOWER
		else
			icon_state = "[initial(icon_state)]-off"
			machine_stat |= NOPOWER

//Portable version, built into EOD equipment. It simply provides an explosion's three damage levels.
/obj/machinery/doppler_array/integrated
	name = "integrated tachyon-doppler module"
	integrated = TRUE
	max_dist = 21 //Should detect most explosions in hearing range.
	use_power = NO_POWER_USE

/obj/machinery/doppler_array/research
	name = "tachyon-doppler research array"
	desc = "A specialized tachyon-doppler bomb detection array that uses the results of the highest yield of explosions for research."
	var/datum/techweb/linked_techweb

/obj/machinery/doppler_array/research/sense_explosion(turf/epicenter, dev, heavy, light, time, orig_dev, orig_heavy, orig_light)	//probably needs a way to ignore admin explosives later on
	. = ..()
	if(!.)
		return FALSE
	if(!istype(linked_techweb))
		say("Warning: No linked research system!")
		return

	var/point_gain = 0

	/*****The Point Calculator*****/

	if(orig_light < 5)
		say("Explosion not large enough for research calculations.")
		return
	else if(orig_light < BOMB_TARGET_SIZE) // we want to give fewer points if below the target; this curve does that
		point_gain = (BOMB_TARGET_POINTS * orig_light ** BOMB_SUB_TARGET_EXPONENT) / (BOMB_TARGET_SIZE**BOMB_SUB_TARGET_EXPONENT)
	else // once we're at the target, switch to a hyperbolic function so we can't go too far above it, but bigger bombs always get more points
		point_gain = (BOMB_TARGET_POINTS * 2 * orig_light) / (orig_light + BOMB_TARGET_SIZE)

	/*****The Point Capper*****/

	var/list/largest_values = linked_techweb.largest_values
	if(!(LARGEST_BOMB in largest_values))
		largest_values[LARGEST_BOMB] = 0
	if(point_gain > largest_values[LARGEST_BOMB])
		var/old_tech_largest_bomb_value = largest_values[LARGEST_BOMB] //held so we can pull old before we do math
		linked_techweb.largest_values[LARGEST_BOMB] = point_gain
		point_gain -= old_tech_largest_bomb_value
		var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_SCI)
		if(D)
			D.adjust_money(point_gain)
		linked_techweb.add_point_type(TECHWEB_POINT_TYPE_DEFAULT, point_gain)
		say("Explosion details and mixture analyzed and sold to the highest bidder for [point_gain] cr, with a reward of [point_gain] points.")

	else //you've made smaller bombs
		say("Data already captured. Aborting.")
		return


/obj/machinery/doppler_array/research/science/Initialize(mapload)
	. = ..()
	linked_techweb = SSresearch.science_tech
