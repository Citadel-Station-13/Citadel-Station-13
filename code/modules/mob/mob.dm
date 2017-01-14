/mob/Destroy()//This makes sure that mobs with clients/keys are not just deleted from the game.
	mob_list -= src
	dead_mob_list -= src
	living_mob_list -= src
	all_clockwork_mobs -= src
	if(observers && observers.len)
		for(var/M in observers)
			var/mob/dead/observe = M
			observe.reset_perspective(null)
	qdel(hud_used)
	if(mind && mind.current == src)
		spellremove(src)
	for(var/infection in viruses)
		qdel(infection)
	for(var/cc in client_colours)
		qdel(cc)
	client_colours = null
	ghostize()
	..()
	return QDEL_HINT_HARDDEL

var/next_mob_id = 0
/mob/New()
	tag = "mob_[next_mob_id++]"
	mob_list += src
	if(stat == DEAD)
		dead_mob_list += src
	else
		living_mob_list += src
	prepare_huds()
	..()

/atom/proc/prepare_huds()
	hud_list = list()
	for(var/hud in hud_possible)
		var/image/I = image('icons/mob/hud.dmi', src, "")
		I.appearance_flags = RESET_COLOR|RESET_TRANSFORM
		hud_list[hud] = I

/mob/proc/Cell()
	set category = "Admin"
	set hidden = 1

	if(!loc) return 0

	var/datum/gas_mixture/environment = loc.return_air()

	var/t =	"<span class='notice'>Coordinates: [x],[y] \n</span>"
	t +=	"<span class='danger'>Temperature: [environment.temperature] \n</span>"
	for(var/id in environment.gases)
		var/gas = environment.gases[id]
		if(gas[MOLES])
			t+="<span class='notice'>[gas[GAS_META][META_GAS_NAME]]: [gas[MOLES]] \n</span>"

	usr << t

/mob/proc/show_message(msg, type, alt_msg, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)

	if(!client)
		return

	msg = copytext(msg, 1, MAX_MESSAGE_LEN)

	if(type)
		if(type & 1 && eye_blind )//Vision related
			if(!alt_msg)
				return
			else
				msg = alt_msg
				type = alt_type

		if(type & 2 && ear_deaf)//Hearing related
			if(!alt_msg)
				return
			else
				msg = alt_msg
				type = alt_type
				if(type & 1 && eye_blind)
					return
	// voice muffling
	if(stat == UNCONSCIOUS)
		if(type & 2) //audio
			src << "<I>... You can almost hear something ...</I>"
	else
		src << msg

// Show a message to all player mobs who sees this atom
// Show a message to the src mob (if the src is a mob)
// Use for atoms performing visible actions
// message is output to anyone who can see, e.g. "The [src] does something!"
// self_message (optional) is what the src mob sees e.g. "You do something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"
// vision_distance (optional) define how many tiles away the message can be seen.
// ignored_mob (optional) doesn't show any message to a given mob if TRUE.

/atom/proc/visible_message(message, self_message, blind_message, vision_distance, ignored_mob)
	var/turf/T = get_turf(src)
	if(!T)
		return
	var/range = 7
	if(vision_distance)
		range = vision_distance
	for(var/mob/M in get_hearers_in_view(range, src))
		if(!M.client)
			continue
		if(M == ignored_mob)
			continue
		var/msg = message
		if(M == src) //the src always see the main message or self message
			if(self_message)
				msg = self_message
		else
			if(M.see_invisible<invisibility || (T != loc && T != src))//if src is invisible to us or is inside something (and isn't a turf),
				if(blind_message) // then people see blind message if there is one, otherwise nothing.
					msg = blind_message
				else
					continue
			else if(T.lighting_object)
				if(T.lighting_object.invisibility <= M.see_invisible && !T.lighting_object.luminosity) //the light object is dark and not invisible to us
					if(blind_message)
						msg = blind_message
					else
						continue
		M.show_message(msg,1,blind_message,2)

// Show a message to all mobs in earshot of this one
// This would be for audible actions by the src mob
// message is the message output to anyone who can hear.
// self_message (optional) is what the src mob hears.
// deaf_message (optional) is what deaf people will see.
// hearing_distance (optional) is the range, how many tiles away the message can be heard.

/mob/audible_message(message, deaf_message, hearing_distance, self_message)
	var/range = 7
	if(hearing_distance)
		range = hearing_distance
	for(var/mob/M in get_hearers_in_view(range, src))
		var/msg = message
		if(self_message && M==src)
			msg = self_message
		M.show_message( msg, 2, deaf_message, 1)

// Show a message to all mobs in earshot of this atom
// Use for objects performing audible actions
// message is the message output to anyone who can hear.
// deaf_message (optional) is what deaf people will see.
// hearing_distance (optional) is the range, how many tiles away the message can be heard.

/atom/proc/audible_message(message, deaf_message, hearing_distance)
	var/range = 7
	if(hearing_distance)
		range = hearing_distance
	for(var/mob/M in get_hearers_in_view(range, src))
		M.show_message( message, 2, deaf_message, 1)

/mob/proc/movement_delay()
	return 0

/mob/proc/Life()
	set waitfor = 0
	return

/mob/proc/get_item_by_slot(slot_id)
	return null

/mob/proc/restrained(ignore_grab)
	return

/mob/proc/incapacitated(ignore_restraints, ignore_grab)
	return

//This proc is called whenever someone clicks an inventory ui slot.
/mob/proc/attack_ui(slot)
	var/obj/item/W = get_active_held_item()

	if(istype(W))
		if(equip_to_slot_if_possible(W, slot,0,0,0))
			return 1

	if(!W)
		// Activate the item
		var/obj/item/I = get_item_by_slot(slot)
		if(istype(I))
			I.attack_hand(src)

	return 0

//This is a SAFE proc. Use this instead of equip_to_slot()!
//set qdel_on_fail to have it delete W if it fails to equip
//set disable_warning to disable the 'you are unable to equip that' warning.
//unset redraw_mob to prevent the mob from being redrawn at the end.
/mob/proc/equip_to_slot_if_possible(obj/item/W, slot, qdel_on_fail = 0, disable_warning = 0, redraw_mob = 1)
	if(!istype(W)) return 0
	if(!W.mob_can_equip(src, null, slot, disable_warning))
		if(qdel_on_fail)
			qdel(W)
		else
			if(!disable_warning)
				src << "<span class='warning'>You are unable to equip that!</span>" //Only print if qdel_on_fail is false
		return 0
	equip_to_slot(W, slot, redraw_mob) //This proc should not ever fail.
	return 1

//This is an UNSAFE proc. It merely handles the actual job of equipping. All the checks on whether you can or can't eqip need to be done before! Use mob_can_equip() for that task.
//In most cases you will want to use equip_to_slot_if_possible()
/mob/proc/equip_to_slot(obj/item/W, slot)
	return

//This is just a commonly used configuration for the equip_to_slot_if_possible() proc, used to equip people when the rounds tarts and when events happen and such.
/mob/proc/equip_to_slot_or_del(obj/item/W, slot)
	return equip_to_slot_if_possible(W, slot, 1, 1, 0)

//puts the item "W" into an appropriate slot in a human's inventory
//returns 0 if it cannot, 1 if successful
/mob/proc/equip_to_appropriate_slot(obj/item/W)
	if(!istype(W)) return 0
	var/slot_priority = W.slot_equipment_priority

	if(!slot_priority)
		slot_priority = list( \
			slot_back, slot_wear_id,\
			slot_w_uniform, slot_wear_suit,\
			slot_wear_mask, slot_head, slot_neck,\
			slot_shoes, slot_gloves,\
			slot_ears, slot_glasses,\
			slot_belt, slot_s_store,\
			slot_l_store, slot_r_store,\
			slot_generic_dextrous_storage\
		)

	for(var/slot in slot_priority)
		if(equip_to_slot_if_possible(W, slot, 0, 1, 1)) //qdel_on_fail = 0; disable_warning = 1; redraw_mob = 1
			return 1

	return 0

/mob/proc/reset_perspective(atom/A)
	if(client)
		if(istype(A, /atom/movable))
			client.perspective = EYE_PERSPECTIVE
			client.eye = A
		else
			if(isturf(loc))
				client.eye = client.mob
				client.perspective = MOB_PERSPECTIVE
			else
				client.perspective = EYE_PERSPECTIVE
				client.eye = loc
		return 1

/mob/living/reset_perspective(atom/A)
	if(..())
		update_sight()
		if(client.eye != src)
			var/atom/AT = client.eye
			AT.get_remote_view_fullscreens(src)
		else
			clear_fullscreen("remote_view", 0)
		update_pipe_vision()

/mob/proc/show_inv(mob/user)
	return

//mob verbs are faster than object verbs. See http://www.byond.com/forum/?post=1326139&page=2#comment8198716 for why this isn't atom/verb/examine()
/mob/verb/examinate(atom/A as mob|obj|turf in view()) //It used to be oview(12), but I can't really say why
	set name = "Examine"
	set category = "IC"

	if(is_blind(src))
		src << "<span class='notice'>Something is there but you can't see it.</span>"
		return

	face_atom(A)
	A.examine(src)

//same as above
//note: ghosts can point, this is intended
//visible_message will handle invisibility properly
//overriden here and in /mob/dead/observer for different point span classes and sanity checks
/mob/verb/pointed(atom/A as mob|obj|turf in view())
	set name = "Point To"
	set category = "Object"

	if(!src || !isturf(src.loc) || !(A in view(src.loc)))
		return 0
	if(istype(A, /obj/effect/overlay/temp/point))
		return 0

	var/tile = get_turf(A)
	if (!tile)
		return 0

	PoolOrNew(/obj/effect/overlay/temp/point, list(A,invisibility))

	return 1

//this and stop_pulling really ought to be /mob/living procs
/mob/proc/start_pulling(atom/movable/AM, supress_message = 0)
	if(!AM || !src)
		return
	if(AM == src || !isturf(AM.loc))
		return
	if(AM.anchored || AM.throwing)
		return
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.buckled && L.buckled.buckle_prevents_pull)
			return
	if(throwing || incapacitated())
		return

	AM.add_fingerprint(src)

	// If we're pulling something then drop what we're currently pulling and pull this instead.
	if(pulling)
		// Are we trying to pull something we are already pulling? Then just stop here, no need to continue.
		if(AM == pulling)
			return
		stop_pulling()

	changeNext_move(CLICK_CD_GRABBING)

	if(AM.pulledby)
		visible_message("<span class='danger'>[src] has pulled [AM] from [AM.pulledby]'s grip.</span>")
		AM.pulledby.stop_pulling() //an object can't be pulled by two mobs at once.

	pulling = AM
	AM.pulledby = src
	playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	update_pull_hud_icon()

	if(ismob(AM))
		var/mob/M = AM
		if(!supress_message)
			visible_message("<span class='warning'>[src] has grabbed [M] passively!</span>")
		if(!iscarbon(src))
			M.LAssailant = null
		else
			M.LAssailant = usr

/mob/verb/stop_pulling()
	set name = "Stop Pulling"
	set category = "IC"

	if(pulling)
		pulling.pulledby = null
		if(ismob(pulling))
			var/mob/M = pulling
			M.update_canmove()// mob gets up if it was lyng down in a chokehold
		pulling = null
		grab_state = 0
		update_pull_hud_icon()

/mob/proc/update_pull_hud_icon()
	if(hud_used)
		if(hud_used.pull_icon)
			hud_used.pull_icon.update_icon(src)

/mob/verb/mode()
	set name = "Activate Held Object"
	set category = "Object"
	set src = usr

	if(istype(loc,/obj/mecha))
		return

	if(incapacitated())
		return

	var/obj/item/I = get_active_held_item()
	if(I)
		I.attack_self(src)
		update_inv_hands()


/*
/mob/verb/dump_source()

	var/master = "<PRE>"
	for(var/t in typesof(/area))
		master += text("[]\n", t)
		//Foreach goto(26)
	src << browse(master)
	return
*/

/mob/verb/memory()
	set name = "Notes"
	set category = "IC"
	set desc = "View your character's notes memory."
	if(mind)
		mind.show_memory(src)
	else
		src << "You don't have a mind datum for some reason, so you can't look at your notes, if you had any."

/mob/verb/add_memory(msg as message)
	set name = "Add Note"
	set category = "IC"

	msg = copytext(msg, 1, MAX_MESSAGE_LEN)
	msg = sanitize(msg)

	if(mind)
		mind.store_memory(msg)
	else
		src << "You don't have a mind datum for some reason, so you can't add a note to it."

/mob/verb/abandon_mob()
	set name = "Respawn"
	set category = "OOC"

	if (!( abandon_allowed ))
		return
	if ((stat != 2 || !( ticker )))
		usr << "<span class='boldnotice'>You must be dead to use this!</span>"
		return

	log_game("[usr.name]/[usr.key] used abandon mob.")

	usr << "<span class='boldnotice'>Please roleplay correctly!</span>"

	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		return
	client.screen.Cut()
	client.screen += client.void
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		return

	var/mob/new_player/M = new /mob/new_player()
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		qdel(M)
		return

	M.key = key
//	M.Login()	//wat
	return



/mob/verb/cancel_camera()
	set name = "Cancel Camera View"
	set category = "OOC"
	reset_perspective(null)
	unset_machine()

/mob/Topic(href, href_list)
	if(href_list["mach_close"])
		var/t1 = text("window=[href_list["mach_close"]]")
		unset_machine()
		src << browse(null, t1)

	if(href_list["refresh"])
		if(machine && in_range(src, usr))
			show_inv(machine)

	if(usr.canUseTopic(src, BE_CLOSE, NO_DEXTERY))
		if(href_list["item"])
			var/slot = text2num(href_list["item"])
			var/hand_index = text2num(href_list["hand_index"])
			var/obj/item/what
			if(hand_index)
				what = get_item_for_held_index(hand_index)
				slot = list(slot,hand_index)
			else
				what = get_item_by_slot(slot)
			if(what)
				if(!(what.flags & ABSTRACT))
					usr.stripPanelUnequip(what,src,slot)
			else
				usr.stripPanelEquip(what,src,slot)

	if(usr.machine == src)
		if(Adjacent(usr))
			show_inv(usr)
		else
			usr << browse(null,"window=mob\ref[src]")

// The src mob is trying to strip an item from someone
// Defined in living.dm
/mob/proc/stripPanelUnequip(obj/item/what, mob/who)
	return

// The src mob is trying to place an item on someone
// Defined in living.dm
/mob/proc/stripPanelEquip(obj/item/what, mob/who)
	return

/mob/MouseDrop(mob/M)
	..()
	if(M != usr)
		return
	if(usr == src)
		return
	if(!Adjacent(usr))
		return
	if(isAI(M))
		return
	show_inv(usr)

/mob/proc/is_active()
	return (0 >= usr.stat)

/mob/proc/is_muzzled()
	return 0

/mob/proc/see(message)
	if(!is_active())
		return 0
	src << message
	return 1

/mob/proc/show_viewers(message)
	for(var/mob/M in viewers())
		M.see(message)

/mob/Stat()
	..()

	if(statpanel("Status"))
		if (client)
			stat(null, "Ping: [round(client.lastping, 1)]ms (Average: [round(client.avgping, 1)]ms)")
		stat(null, "Map: [MAP_NAME]")
		if(nextmap && istype(nextmap))
			stat(null, "Next Map: [nextmap.friendlyname]")
		stat(null, "Server Time: [time2text(world.realtime, "YYYY-MM-DD hh:mm")]")
		if(SSshuttle.emergency)
			stat(null, "Current Shuttle: [SSshuttle.emergency.name]")
			var/ETA = SSshuttle.emergency.getModeStr()
			if(ETA)
				stat(null, "[ETA] [SSshuttle.emergency.getTimerStr()]")


	if(client && client.holder)
		if(statpanel("MC"))
			stat("Location:", "([x], [y], [z])")
			stat("CPU:", "[world.cpu]")
			stat("Instances:", "[world.contents.len]")
			config.stat_entry()
			stat(null)
			if(Master)
				Master.stat_entry()
			else
				stat("Master Controller:", "ERROR")
			if(Failsafe)
				Failsafe.stat_entry()
			else
				stat("Failsafe Controller:", "ERROR")
			if(Master)
				stat(null)
				for(var/datum/subsystem/SS in Master.subsystems)
					SS.stat_entry()
			cameranet.stat_entry()

	if(listed_turf && client)
		if(!TurfAdjacent(listed_turf))
			listed_turf = null
		else
			statpanel(listed_turf.name, null, listed_turf)
			var/list/overrides = list()
			for(var/image/I in client.images)
				if(I.loc && I.loc.loc == listed_turf && I.override)
					overrides += I.loc
			for(var/atom/A in listed_turf)
				if(!A.mouse_opacity)
					continue
				if(A.invisibility > see_invisible)
					continue
				if(overrides.len && (A in overrides))
					continue
				statpanel(listed_turf.name, null, A)


	if(mind)
		add_spells_to_statpanel(mind.spell_list)
		if(mind.changeling)
			add_stings_to_statpanel(mind.changeling.purchasedpowers)
	add_spells_to_statpanel(mob_spell_list)

/mob/proc/add_spells_to_statpanel(list/spells)
	for(var/obj/effect/proc_holder/spell/S in spells)
		if(S.can_be_cast_by(src))
			switch(S.charge_type)
				if("recharge")
					statpanel("[S.panel]","[S.charge_counter/10.0]/[S.charge_max/10]",S)
				if("charges")
					statpanel("[S.panel]","[S.charge_counter]/[S.charge_max]",S)
				if("holdervar")
					statpanel("[S.panel]","[S.holder_var_type] [S.holder_var_amount]",S)

/mob/proc/add_stings_to_statpanel(list/stings)
	for(var/obj/effect/proc_holder/changeling/S in stings)
		if(S.chemical_cost >=0 && S.can_be_used_by(src))
			statpanel("[S.panel]",((S.chemical_cost > 0) ? "[S.chemical_cost]" : ""),S)

// facing verbs
/mob/proc/canface()
	if(!canmove)
		return 0
	if(client.moving)
		return 0
	if(world.time < client.move_delay)
		return 0
	if(stat==2)
		return 0
	if(anchored)
		return 0
	if(notransform)
		return 0
	if(restrained())
		return 0
	return 1


//Updates canmove, lying and icons. Could perhaps do with a rename but I can't think of anything to describe it.
//Robots, animals and brains have their own version so don't worry about them
/mob/proc/update_canmove()
	var/ko = weakened || paralysis || stat || (status_flags & FAKEDEATH)
	var/chokehold = pulledby && pulledby.grab_state >= GRAB_NECK
	var/buckle_lying = !(buckled && !buckled.buckle_lying)
	var/has_legs = get_num_legs()
	var/has_arms = get_num_arms()
	var/ignore_legs = get_leg_ignore()
	if(ko || resting || stunned || chokehold)
		drop_all_held_items()
		unset_machine()
		if(pulling)
			stop_pulling()
	else if(has_legs || ignore_legs)
		lying = 0

	if(buckled)
		lying = 90*buckle_lying
	else if(!lying)
		if(resting)
			fall()
		else if(ko || (!has_legs && !ignore_legs) || chokehold)
			fall(forced = 1)
	canmove = !(ko || resting || stunned || chokehold || buckled || (!has_legs && !ignore_legs && !has_arms))
	density = !lying
	if(lying)
		if(layer == initial(layer)) //to avoid special cases like hiding larvas.
			layer = LYING_MOB_LAYER //so mob lying always appear behind standing mobs
	else
		if(layer == LYING_MOB_LAYER)
			layer = initial(layer)
	update_transform()
	update_action_buttons_icon(status_only=TRUE)
	if(isliving(src))
		var/mob/living/L = src
		if(L.has_status_effect(/datum/status_effect/freon))
			canmove = 0
	lying_prev = lying
	return canmove


/mob/proc/fall(forced)
	drop_all_held_items()

/mob/verb/eastface()
	set hidden = 1
	if(!canface())
		return 0
	setDir(EAST)
	client.move_delay += movement_delay()
	return 1


/mob/verb/westface()
	set hidden = 1
	if(!canface())
		return 0
	setDir(WEST)
	client.move_delay += movement_delay()
	return 1


/mob/verb/northface()
	set hidden = 1
	if(!canface())
		return 0
	setDir(NORTH)
	client.move_delay += movement_delay()
	return 1


/mob/verb/southface()
	set hidden = 1
	if(!canface())
		return 0
	setDir(SOUTH)
	client.move_delay += movement_delay()
	return 1


/mob/proc/IsAdvancedToolUser()//This might need a rename but it should replace the can this mob use things check
	return 0

/mob/proc/swap_hand()
	return

/mob/proc/activate_hand(selhand)
	return

/mob/proc/assess_threat() //For sec bot threat assessment
	return

/mob/proc/get_ghost(even_if_they_cant_reenter = 0)
	if(mind)
		return mind.get_ghost(even_if_they_cant_reenter)

/mob/proc/grab_ghost(force)
	if(mind)
		return mind.grab_ghost(force = force)

/mob/proc/notify_ghost_cloning(var/message = "Someone is trying to revive you. Re-enter your corpse if you want to be revived!", var/sound = 'sound/effects/genetics.ogg', var/atom/source = null)
	var/mob/dead/observer/ghost = get_ghost()
	if(ghost)
		ghost.notify_cloning(message, sound, source)
		return ghost

/mob/proc/AddSpell(obj/effect/proc_holder/spell/S)
	mob_spell_list += S
	S.action.Grant(src)

//override to avoid rotating pixel_xy on mobs
/mob/shuttleRotate(rotation)
	setDir(angle2dir(rotation+dir2angle(dir)))

//You can buckle on mobs if you're next to them since most are dense
/mob/buckle_mob(mob/living/M, force = 0)
	if(M.buckled)
		return 0
	var/turf/T = get_turf(src)
	if(M.loc != T)
		var/old_density = density
		density = 0
		var/can_step = step_towards(M, T)
		density = old_density
		if(!can_step)
			return 0
	return ..()

//Default buckling shift visual for mobs
/mob/post_buckle_mob(mob/living/M)
	if(M in buckled_mobs)//post buckling
		var/height = M.get_mob_buckling_height(src)
		M.pixel_y = initial(M.pixel_y) + height
		if(M.layer < layer)
			M.layer = layer + 0.1
	else //post unbuckling
		M.layer = initial(M.layer)
		M.pixel_y = initial(M.pixel_y)

//returns the height in pixel the mob should have when buckled to another mob.
/mob/proc/get_mob_buckling_height(mob/seat)
	if(isliving(seat))
		var/mob/living/L = seat
		if(L.mob_size <= MOB_SIZE_SMALL) //being on top of a small mob doesn't put you very high.
			return 0
	return 9

//can the mob be buckled to something by default?
/mob/proc/can_buckle()
	return 1

//can the mob be unbuckled from something by default?
/mob/proc/can_unbuckle()
	return 1

//Can the mob see reagents inside of containers?
/mob/proc/can_see_reagents()
	if(stat == DEAD) //Ghosts and such can always see reagents
		return 1
	if(has_unlimited_silicon_privilege) //Silicons can automatically view reagents
		return 1
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.head && istype(H.head, /obj/item/clothing))
			var/obj/item/clothing/CL = H.head
			if(CL.scan_reagents)
				return 1
		if(H.wear_mask && H.wear_mask.scan_reagents)
			return 1
		if(H.glasses && istype(H.glasses, /obj/item/clothing))
			var/obj/item/clothing/CL = H.glasses
			if(CL.scan_reagents)
				return 1
	return 0

//Can the mob use Topic to interact with machines
/mob/proc/canUseTopic()
	return

/mob/proc/faction_check(mob/target)
	for(var/F in faction)
		if(F in target.faction)
			return 1
	return 0


//This will update a mob's name, real_name, mind.name, data_core records, pda, id and traitor text
//Calling this proc without an oldname will only update the mob and skip updating the pda, id and records ~Carn
/mob/proc/fully_replace_character_name(oldname,newname)
	if(!newname)
		return 0
	real_name = newname
	name = newname
	if(mind)
		mind.name = newname

	if(oldname)
		//update the datacore records! This is goig to be a bit costly.
		replace_records_name(oldname,newname)

		//update our pda and id if we have them on our person
		replace_identification_name(oldname,newname)

		for(var/datum/mind/T in ticker.minds)
			for(var/datum/objective/obj in T.objectives)
				// Only update if this player is a target
				if(obj.target && obj.target.current && obj.target.current.real_name == name)
					obj.update_explanation_text()
	return 1

//Updates data_core records with new name , see mob/living/carbon/human
/mob/proc/replace_records_name(oldname,newname)
	return

/mob/proc/replace_identification_name(oldname,newname)
	var/list/searching = GetAllContents()
	var/search_id = 1
	var/search_pda = 1

	for(var/A in searching)
		if( search_id && istype(A,/obj/item/weapon/card/id) )
			var/obj/item/weapon/card/id/ID = A
			if(ID.registered_name == oldname)
				ID.registered_name = newname
				ID.update_label()
				if(!search_pda)
					break
				search_id = 0

		else if( search_pda && istype(A,/obj/item/device/pda) )
			var/obj/item/device/pda/PDA = A
			if(PDA.owner == oldname)
				PDA.owner = newname
				PDA.update_label()
				if(!search_id)
					break
				search_pda = 0

/mob/proc/update_stat()
	return

/mob/proc/update_health_hud()
	return

/mob/living/vv_edit_var(var_name, var_value)
	switch(var_name)
		if("stat")
			if((stat == DEAD) && (var_value < DEAD))//Bringing the dead back to life
				dead_mob_list -= src
				living_mob_list += src
			if((stat < DEAD) && (var_value == DEAD))//Kill he
				living_mob_list -= src
				dead_mob_list += src
	. = ..()
	switch(var_name)
		if("weakened")
			SetWeakened(var_value)
		if("stunned")
			SetStunned(var_value)
		if("paralysis")
			SetParalysis(var_value)
		if("sleeping")
			SetSleeping(var_value)
		if("eye_blind")
			set_blindness(var_value)
		if("eye_damage")
			set_eye_damage(var_value)
		if("eye_blurry")
			set_blurriness(var_value)
		if("ear_deaf")
			setEarDamage(-1, var_value)
		if("ear_damage")
			setEarDamage(var_value, -1)
		if("maxHealth")
			updatehealth()
		if("resize")
			update_transform()


/mob/proc/is_literate()
	return 0

/mob/proc/can_hold_items()
	return FALSE

/mob/proc/get_idcard()
	return

/mob/vv_get_dropdown()
	. = ..()
	. += "---"
	.["Gib"] = "?_src_=vars;gib=\ref[src]"
	.["Give Spell"] = "?_src_=vars;give_spell=\ref[src]"
	.["Remove Spell"] = "?_src_=vars;remove_spell=\ref[src]"
	.["Give Disease"] = "?_src_=vars;give_disease=\ref[src]"
	.["Toggle Godmode"] = "?_src_=vars;godmode=\ref[src]"
	.["Drop Everything"] = "?_src_=vars;drop_everything=\ref[src]"
	.["Regenerate Icons"] = "?_src_=vars;regenerateicons=\ref[src]"
	.["Make Space Ninja"] = "?_src_=vars;ninja=\ref[src]"
	.["Show player panel"] = "?_src_=vars;mob_player_panel=\ref[src]"
	.["Toggle Build Mode"] = "?_src_=vars;build_mode=\ref[src]"
	.["Assume Direct Control"] = "?_src_=vars;direct_control=\ref[src]"
	.["Offer Control to Ghosts"] = "?_src_=vars;offer_control=\ref[src]"

/mob/vv_get_var(var_name)
	switch(var_name)
		if ("attack_log")
			return debug_variable(var_name, attack_log, 0, src, FALSE)
	. = ..()