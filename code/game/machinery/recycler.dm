#define SAFETY_COOLDOWN 100

/obj/machinery/recycler
	name = "recycler"
	desc = "A large crushing machine used to recycle small items inefficiently. There are lights on the side."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "grinder-o0"
	layer = ABOVE_ALL_MOB_LAYER // Overhead
	density = TRUE
	circuit = /obj/item/circuitboard/machine/recycler
	var/safety_mode = FALSE // Temporarily stops machine if it detects a mob
	var/icon_name = "grinder-o"
	var/bloody = FALSE
	var/eat_dir = WEST
	var/amount_produced = 50
	var/crush_damage = 1000
	var/eat_victim_items = TRUE
	var/item_recycle_sound = 'sound/items/welder.ogg'

/obj/machinery/recycler/Initialize()
	AddComponent(/datum/component/butchering/recycler, 1, amount_produced,amount_produced/5)
	var/list/allowed_materials = list(/datum/material/iron,
									/datum/material/glass,
									/datum/material/silver,
									/datum/material/plasma,
									/datum/material/gold,
									/datum/material/diamond,
									/datum/material/plastic,
									/datum/material/uranium,
									/datum/material/bananium,
									/datum/material/titanium,
									/datum/material/bluespace
									)
	AddComponent(/datum/component/material_container, allowed_materials, INFINITY)
	. = ..()
	update_appearance(UPDATE_ICON)
	req_one_access =get_all_accesses() + get_all_centcom_access()

/obj/machinery/recycler/RefreshParts()
	var/amt_made = 0
	var/mat_mod = 0
	for(var/obj/item/stock_parts/matter_bin/B in component_parts)
		mat_mod = 2 * B.rating
	mat_mod *= 50000
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		amt_made = 12.5 * M.rating //% of materials salvaged
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	materials.max_amount = mat_mod
	amount_produced = min(50, amt_made) + 50
	var/datum/component/butchering/butchering = GetComponent(/datum/component/butchering/recycler)
	butchering.effectiveness = amount_produced
	butchering.bonus_modifier = amount_produced/5

/obj/machinery/recycler/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Reclaiming <b>[amount_produced]%</b> of materials salvaged.</span>"
	. += {"The power light is [(machine_stat & NOPOWER) ? "off" : "on"].
	The safety-mode light is [safety_mode ? "on" : "off"].
	The safety-sensors status light is [obj_flags & EMAGGED ? "off" : "on"]."}


/obj/machinery/recycler/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "grinder-oOpen", "grinder-o0", I))
		return

	if(default_pry_open(I))
		return

	if(default_unfasten_wrench(user, I))
		return

	if(default_deconstruction_crowbar(I))
		return
	return ..()

/obj/machinery/recycler/emag_act(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	if(safety_mode)
		safety_mode = FALSE
		update_appearance()
	playsound(src, "sparks", 75, TRUE, SILENCED_SOUND_EXTRARANGE)
	to_chat(user, "<span class='notice'>You use the cryptographic sequencer on [src].</span>")
	return TRUE

/obj/machinery/recycler/update_icon_state()
	var/is_powered = !(machine_stat & (BROKEN|NOPOWER))
	if(safety_mode)
		is_powered = FALSE
	icon_state = icon_name + "[is_powered]" + "[(bloody ? "bld" : "")]" // add the blood tag at the end
	return ..()

/obj/machinery/recycler/CanPass(atom/movable/AM)
	. = ..()
	if(!anchored)
		return
	var/move_dir = get_dir(loc, AM.loc)
	if(move_dir == eat_dir)
		return TRUE

/obj/machinery/recycler/Crossed(atom/movable/AM)
	eat(AM)
	. = ..()

/obj/machinery/recycler/proc/eat(atom/movable/AM0, sound=TRUE)
	if(machine_stat & (BROKEN|NOPOWER))
		return
	if(safety_mode)
		return
	if(iseffect(AM0))
		return
	if(!isturf(AM0.loc))
		return //I don't know how you called Crossed() but stop it.

	var/list/to_eat = AM0.GetAllContents()

	var/living_detected = FALSE //technically includes silicons as well but eh
	var/list/nom = list()
	var/list/crunchy_nom = list() //Mobs have to be handled differently so they get a different list instead of checking them multiple times.

	for(var/i in to_eat)
		var/atom/movable/AM = i
		if(istype(AM, /obj/item))
			var/obj/item/bodypart/head/as_head = AM
			var/obj/item/mmi/as_mmi = AM
			if(istype(AM, /obj/item/organ/brain) || (istype(as_head) && as_head.brain) || (istype(as_mmi) && as_mmi.brain) || istype(AM, /obj/item/dullahan_relay))
				living_detected = TRUE
			nom += AM
		else if(isliving(AM))
			living_detected = TRUE
			crunchy_nom += AM
	var/not_eaten = to_eat.len - nom.len - crunchy_nom.len
	if(living_detected) // First, check if we have any living beings detected.
		if(obj_flags & EMAGGED)
			for(var/CRUNCH in crunchy_nom) // Eat them and keep going because we don't care about safety.
				if(isliving(CRUNCH)) // MMIs and brains will get eaten like normal items
					crush_living(CRUNCH)
		else // Stop processing right now without eating anything.
			emergency_stop()
			return
	for(var/nommed in nom)
		recycle_item(nommed)
	if(nom.len && sound)
		playsound(src, item_recycle_sound, (50 + nom.len*5), TRUE, nom.len, ignore_walls = (nom.len - 10)) // As a substitute for playing 50 sounds at once.
	if(not_eaten)
		playsound(src, 'sound/machines/buzz-sigh.ogg', (50 + not_eaten*5), FALSE, not_eaten, ignore_walls = (not_eaten - 10)) // Ditto.
	if(!ismob(AM0))
		qdel(AM0)
	else // Lets not move a mob to nullspace and qdel it, yes?
		for(var/i in AM0.contents)
			var/atom/movable/content = i
			content.moveToNullspace()
			qdel(content)

/obj/machinery/recycler/proc/recycle_item(obj/item/I)

	var/obj/item/grown/log/L = I
	if(istype(L))
		var/seed_modifier = 0
		if(L.seed)
			seed_modifier = round(L.seed.potency / 25)
		new L.plank_type(loc, 1 + seed_modifier)
		qdel(L)
	else
		var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
		var/material_amount = materials.get_item_material_amount(I)
		if(!material_amount)
			qdel(I)
			return
		materials.insert_item(I, multiplier = (amount_produced / 100))
		qdel(I)
		materials.retrieve_all()


/obj/machinery/recycler/proc/emergency_stop()
	playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
	safety_mode = TRUE
	update_appearance()
	addtimer(CALLBACK(src, .proc/reboot), SAFETY_COOLDOWN)

/obj/machinery/recycler/proc/reboot()
	playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
	safety_mode = FALSE
	update_appearance()

/obj/machinery/recycler/proc/crush_living(mob/living/L)

	L.forceMove(loc)

	if(issilicon(L))
		playsound(src, 'sound/items/welder.ogg', 50, TRUE)
	else
		playsound(src, 'sound/effects/splat.ogg', 50, TRUE)

	if(iscarbon(L))
		if(L.stat == CONSCIOUS)
			L.say("ARRRRRRRRRRRGH!!!", forced="recycler grinding")
		add_mob_blood(L)

	if(!bloody && !issilicon(L))
		bloody = TRUE
		update_appearance()

	// Remove and recycle the equipped items
	if(eat_victim_items)
		for(var/obj/item/I in L.get_equipped_items(TRUE))
			if(L.dropItemToGround(I))
				. += I

	// Instantly lie down, also go unconscious from the pain, before you die.
	L.Unconscious(100)
	L.adjustBruteLoss(crush_damage)

/obj/machinery/recycler/deathtrap
	name = "dangerous old crusher"
	obj_flags = CAN_BE_HIT | EMAGGED
	crush_damage = 120
	flags_1 = NODECONSTRUCT_1

/obj/item/paper/guides/recycler
	name = "paper - 'garbage duty instructions'"
	info = "<h2>New Assignment</h2> You have been assigned to collect garbage from trash bins, located around the station. The crewmembers will put their trash into it and you will collect the said trash.<br><br>There is a recycling machine near your closet, inside maintenance; use it to recycle the trash for a small chance to get useful minerals. Then deliver these minerals to cargo or engineering. You are our last hope for a clean station, do not screw this up!"

#undef SAFETY_COOLDOWN
