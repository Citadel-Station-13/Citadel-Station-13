/obj/item/implant/weapons_auth
	name = "firearms authentication implant"
	desc = "Lets you shoot your guns."
	icon_state = "auth"
	activated = 0

/obj/item/implant/weapons_auth/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Firearms Authentication Implant<BR>
				<b>Life:</b> 4 hours after death of host<BR>
				<b>Implant Details:</b> <BR>
				<b>Function:</b> Allows operation of implant-locked weaponry, preventing equipment from falling into enemy hands."}
	return dat


/obj/item/implant/adrenalin
	name = "adrenal implant"
	desc = "Removes all stuns."
	icon_state = "adrenal"
	uses = 3

/obj/item/implant/adrenalin/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Cybersun Industries Adrenaline Implant<BR>
				<b>Life:</b> Five days.<BR>
				<b>Important Notes:</b> <font color='red'>Illegal</font><BR>
				<HR>
				<b>Implant Details:</b> Subjects injected with implant can activate an injection of medical cocktails.<BR>
				<b>Function:</b> Removes stuns, increases speed, and has a mild healing effect.<BR>
				<b>Integrity:</b> Implant can only be used three times before reserves are depleted."}
	return dat

/obj/item/implant/adrenalin/activate()
	. = ..()
	uses--
	imp_in.do_adrenaline(150, TRUE, 0, 0, TRUE, list(/datum/reagent/medicine/inaprovaline = 3, /datum/reagent/medicine/synaptizine = 10, /datum/reagent/medicine/regen_jelly = 10, /datum/reagent/medicine/stimulants = 10), "<span class='boldnotice'>You feel a sudden surge of energy!</span>")
	to_chat(imp_in, "<span class='notice'>You feel a sudden surge of energy!</span>")
	if(!uses)
		qdel(src)

/obj/item/implant/warp
	name = "warp implant"
	desc = "Warps you to where you were 10 seconds before when activated."
	icon_state = "warp"
	uses = -1
	var/total_delay = 10 SECONDS
	var/cooldown = 30 SECONDS
	var/last_use = 0
	var/list/positions = list()
	var/next_prune = 0

/obj/item/implant/warp/Destroy()
	positions = null
	return ..()

/obj/item/implant/warp/implant(mob/living/target, mob/user, silent, force)
	. = ..()
	if(.)
		update_position()
		RegisterSignal(imp_in, COMSIG_MOVABLE_MOVED, .proc/update_position)

/obj/item/implant/warp/removed(mob/living/source, silent, special)
	. = ..()
	clear_positions()

/obj/item/implant/warp/proc/update_position(datum/source)
	if(!isatom(imp_in.loc))
		return
	positions[num2text(world.time)] = imp_in.loc
	if(!((++next_prune) % 10))
		prune()

/obj/item/implant/warp/proc/clear_positions()
	positions = list()

/obj/item/implant/warp/proc/get_tele_position()
	prune()
	return positions[positions[1]]

/obj/item/implant/warp/proc/do_teleport_effects()
	var/safety = 100
	var/list/done = list()
	var/time
	var/turf/target
	for(var/i in 1 to positions.len)
		if(!--safety)
			break
		time = positions[i]
		target = positions[time]
		if(done[target])
			continue
		done[target] = TRUE
		if(!istype(target))
			continue
		new /obj/effect/temp_visual/dir_setting/ninja(target)

/obj/item/implant/warp/activate()
	. = ..()
	if(last_use + cooldown > world.time)
		to_chat(imp_in, "<span class=warning'>[src] is still recharging!</span>")
		return
	last_use = world.time
	prune()
	do_teleport_effects()		//first.
	do_teleport(imp_in, get_tele_position(), 0, TRUE, null, null, null, null, null, TELEPORT_CHANNEL_QUANTUM, TRUE)

/obj/item/implant/warp/proc/prune()
	var/minimum_time = world.time - total_delay
	var/remove = 0
	for(var/i in 1 to length(positions))
		if(text2num(positions[i]) < minimum_time)
			remove++
		else
			break
	if(remove)
		positions.Cut(1, remove + 1)

/obj/item/implanter/warp
	name = "implanter (warp)"
	imp_type = /obj/item/implant/warp

/obj/item/implant/emp
	name = "emp implant"
	desc = "Triggers an EMP."
	icon_state = "emp"
	uses = 3

/obj/item/implant/emp/activate()
	. = ..()
	uses--
	empulse_using_range(imp_in, 7)
	if(!uses)
		qdel(src)


//Health Tracker Implant

/obj/item/implant/health
	name = "health implant"
	activated = 0
	var/healthstring = ""
	var/list/raw_data = list()

/obj/item/implant/health/proc/sensehealth(get_list = FALSE)
	if (!imp_in)
		return "ERROR"
	else
		if(isliving(imp_in))
			var/mob/living/L = imp_in
			healthstring = "<small>Oxygen Deprivation Damage => [round(L.getOxyLoss())]<br />Fire Damage => [round(L.getFireLoss())]<br />Toxin Damage => [round(L.getToxLoss())]<br />Brute Force Damage => [round(L.getBruteLoss())]</small>"
			raw_data = list() //Reset list
			raw_data["oxy"] = list("[round(L.getOxyLoss())]")		//Suffocation
			raw_data["burn"] = list("[round(L.getFireLoss())]")		//Burn
			raw_data["tox"] = list("[round(L.getToxLoss())]")		//Tox
			raw_data["brute"] = list("[round(L.getBruteLoss())]")	//Brute
		if(!healthstring)											//I have no idea who made it go this order but okay.
			healthstring = "ERROR"
		if(!length(raw_data))
			raw_data = list("ERROR")
		if(!get_list)
			return healthstring
		else
			return raw_data
