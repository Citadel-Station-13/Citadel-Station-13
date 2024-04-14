/*
 * Energy guns that draw from a cell to fire.
 *
 * This is a bit weird but this is how it currently works:
 * When switching shots, it clears the chamber, and loads the correct energy ammo casing if there is enough energy to fire it.
 * If there's no projectile in the casing, it creates it now.
 * Otherwise the chamber stays null.
 * After firing, it actually deducts the energy and then clears the chamber and does the above again.
 * It detects if a successful fire is done by checking if the chambered energy ammo casing still has its projectile intact.
 *
 * It might be good in the future to move away from ammo casinsgs and instead use a datum-firemode system, but that would make handling firing,
 * which the casing does as of now, a little interesting to implement.
 */
/obj/item/gun/energy
	icon_state = "energy"
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon = 'icons/obj/guns/energy.dmi'
	recoil = 0.1

	var/obj/item/stock_parts/cell/cell //What type of power cell this uses
	var/cell_type = /obj/item/stock_parts/cell
	var/modifystate = FALSE
	/// If TRUE, when modifystate is TRUE this energy gun gets an overlay based on its selected shot type, like "[icon_state]_disable".
	var/shot_type_overlay = TRUE
	/// = TRUE/FALSE decides if the user can switch to it of their own accord
	var/list/ammo_type = list(/obj/item/ammo_casing/energy = TRUE)
	/// The index of the ammo_types/firemodes which we're using right now
	var/current_firemode_index = 1
	var/can_charge = 1 //Can it be charged in a recharger?
	var/automatic_charge_overlays = TRUE	//Do we handle overlays with base update_icon()?
	var/charge_sections = 4
	ammo_x_offset = 2
	var/shaded_charge = FALSE //if this gun uses a stateful charge bar for more detail
	var/selfcharge = EGUN_NO_SELFCHARGE // EGUN_SELFCHARGE if true, EGUN_SELFCHARGE_BORG drains the cyborg's cell to recharge its own
	var/charge_tick = 0
	var/charge_delay = 4
	var/use_cyborg_cell = FALSE //whether the gun drains the cyborg user's cell instead, not to be confused with EGUN_SELFCHARGE_BORG
	var/dead_cell = FALSE //set to true so the gun is given an empty cell

	/// SET THIS TO TRUE IF YOU OVERRIDE altafterattack() or ANY right click action! If this is FALSE, the gun will show in examine its default right click behavior, which is to switch modes.
	var/right_click_overridden = FALSE

/obj/item/gun/energy/emp_act(severity)
	. = ..()
	if(!(. & EMP_PROTECT_CONTENTS))
		cell.use(round(cell.charge * severity/100))
		chambered = null //we empty the chamber
		recharge_newshot() //and try to charge a new shot
		update_appearance()

/obj/item/gun/energy/get_cell()
	return cell

/obj/item/gun/energy/Initialize(mapload)
	. = ..()
	if(cell_type)
		cell = new cell_type(src)
	else
		cell = new(src)
	if(!dead_cell)
		cell.give(cell.maxcharge)
	update_ammo_types()
	recharge_newshot(TRUE)
	if(selfcharge)
		START_PROCESSING(SSobj, src)
	update_appearance()

/obj/item/gun/energy/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/gun/energy/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/energy/handle_atom_del(atom/A)
	if(A == cell)
		cell = null
		update_appearance()
	return ..()

/obj/item/gun/energy/examine(mob/user)
	. = ..()
	if(!right_click_overridden)
		. += "<span class='notice'>Right click in combat mode to switch modes.</span>"

/obj/item/gun/energy/process()
	if(selfcharge && cell?.charge < cell.maxcharge)
		charge_tick++
		if(charge_tick < charge_delay)
			return
		charge_tick = 0
		if(selfcharge == EGUN_SELFCHARGE_BORG)
			var/atom/owner = loc
			if(istype(owner, /obj/item/robot_module))
				owner = owner.loc
			if(!iscyborg(owner))
				return
			var/mob/living/silicon/robot/R = owner
			if(!R.cell?.use(100))
				return
		cell.give(100)
		if(!chambered) //if empty chamber we try to charge a new shot
			recharge_newshot(TRUE)
		update_appearance()

// ATTACK SELF IGNORING PARENT RETURN VALUE
/obj/item/gun/energy/attack_self(mob/living/user)
	. = ..()
	if(can_select_fire(user))
		select_fire(user)

/obj/item/gun/energy/can_shoot()
	var/obj/item/ammo_casing/energy/shot = ammo_type[current_firemode_index]
	return !QDELETED(cell) ? (cell.charge >= shot.e_cost) : FALSE

/obj/item/gun/energy/recharge_newshot(no_cyborg_drain)
	if (!ammo_type || !cell)
		return
	if(use_cyborg_cell && !no_cyborg_drain)
		if(iscyborg(loc))
			var/mob/living/silicon/robot/R = loc
			if(R.cell)
				var/obj/item/ammo_casing/energy/shot = ammo_type[current_firemode_index] //Necessary to find cost of shot
				if(R.cell.use(shot.e_cost)) 		//Take power from the borg...
					cell.give(shot.e_cost)	//... to recharge the shot
	if(!chambered)
		var/obj/item/ammo_casing/energy/AC = ammo_type[current_firemode_index]
		if(cell.charge >= AC.e_cost) //if there's enough power in the cell cell...
			chambered = AC //...prepare a new shot based on the current ammo type selected
			if(!chambered.BB)
				chambered.newshot()

/obj/item/gun/energy/process_chamber()
	if(chambered && !chambered.BB) //if BB is null, i.e the shot has been fired...
		var/obj/item/ammo_casing/energy/shot = chambered
		cell.use(shot.e_cost)//... drain the cell cell
	chambered = null //either way, released the prepared shot
	recharge_newshot() //try to charge a new shot

/obj/item/gun/energy/do_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, stam_cost = 0)
	if(!chambered && can_shoot())
		process_chamber()	// If the gun was drained and then recharged, load a new shot.
	return ..()

/obj/item/gun/energy/do_burst_shot(mob/living/user, atom/target, message = TRUE, params = null, zone_override="", sprd = 0, randomized_gun_spread = 0, randomized_bonus_spread = 0, rand_spr = 0, iteration = 0, stam_cost = 0)
	if(!chambered && can_shoot())
		process_chamber()	// Ditto.
	return ..()

// Firemodes/Ammotypes

/obj/item/gun/energy/proc/update_ammo_types()
	var/obj/item/ammo_casing/energy/C
	for(var/i in 1 to length(ammo_type))
		var/v = ammo_type[i]
		var/user_can_select = ammo_type[v]
		if(istype(v, /obj/item/ammo_casing/energy))		//already set
			ammo_type[v] = isnull(user_can_select)? TRUE : user_can_select
		else
			C = new v(src)			//if you put non energycasing/type stuff in here you deserve the runtime
			ammo_type[i] = C
			ammo_type[C] = isnull(user_can_select)? TRUE : user_can_select
	set_firemode_index(initial(current_firemode_index))

/obj/item/gun/energy/proc/set_firemode_index(index, mob/user_for_feedback)
	chambered = null		//unchamber whatever we have chambered
	if(index > length(ammo_type))
		index = 1
	else if(index < 1)
		index = length(ammo_type)
	var/obj/item/ammo_casing/energy/C = ammo_type[index]		//energy weapons should not have no casings, if it does you deserve the runtime.
	current_firemode_index = index
	fire_sound = C.fire_sound
	fire_delay = C.delay
	if(user_for_feedback)
		to_chat(user_for_feedback, "<span class='notice'>[src] is now set to [C.select_name || C].</span>")
	post_set_firemode()
	update_appearance()

/obj/item/gun/energy/proc/post_set_firemode(recharge_newshot = TRUE)
	if(recharge_newshot)
		recharge_newshot(TRUE)

/obj/item/gun/energy/proc/set_firemode_to_next(mob/user_for_feedback)
	return set_firemode_index(++current_firemode_index, user_for_feedback)

/obj/item/gun/energy/proc/set_firemode_to_prev(mob/user_for_feedback)
	return set_firemode_index(--current_firemode_index, user_for_feedback)

/obj/item/gun/energy/proc/get_firemode_index(casing_type)
	var/obj/item/ammo_casing/energy/E = locate(casing_type) in ammo_type
	if(E)
		return ammo_type.Find(E)

/obj/item/gun/energy/proc/set_firemode_to_type(casing_type)
	var/index = get_firemode_index(casing_type)
	if(index)
		set_firemode_index(index)

/// This is the proc used in general for when a user switches firemodes. Just goes to next firemode by default.
/obj/item/gun/energy/proc/select_fire(mob/living/user)
	return user_set_firemode_to_next(user)

/obj/item/gun/energy/proc/can_select_fire(mob/living/user)
	return TRUE

#define INCREMENT_OR_WRAP(i) i = (i >= length(ammo_type))? 1 : (i + 1)
#define DECREMENT_OR_WRAP(i) i = (i <= 1)? length(ammo_type) : (i - 1)
#define IS_VALID_INDEX(i) (ammo_type[ammo_type[i]])
/obj/item/gun/energy/proc/user_set_firemode_to_next(mob/user_for_feedback)
	var/current_index = current_firemode_index
	var/new_index = current_index
	INCREMENT_OR_WRAP(new_index)
	if(!IS_VALID_INDEX(new_index))
		var/initial_index = new_index
		while(!IS_VALID_INDEX(new_index) && (new_index != initial_index))
			new_index = INCREMENT_OR_WRAP(new_index)
		if(initial_index == new_index)		//cycled through without finding another
			new_index = current_index

	set_firemode_index(new_index, user_for_feedback)

/obj/item/gun/energy/proc/user_set_firemode_to_prev(mob/user_for_feedback)
	var/current_index = current_firemode_index
	var/new_index = current_index
	DECREMENT_OR_WRAP(new_index)
	if(!IS_VALID_INDEX(new_index))
		var/initial_index = new_index
		while(!IS_VALID_INDEX(new_index) && (new_index != initial_index))
			new_index = DECREMENT_OR_WRAP(new_index)
		if(initial_index == new_index)		//cycled through without finding another
			new_index = current_index

	set_firemode_index(new_index, user_for_feedback)
#undef INCREMENT_OR_WRAP
#undef DECREMENT_OR_WRAP
#undef IS_VALID_INDEX

/obj/item/gun/energy/update_icon_state()
	if(initial(item_state))
		return
	..()
	var/ratio = get_charge_ratio()
	var/new_item_state = ""
	new_item_state = initial(icon_state)
	if(modifystate)
		var/obj/item/ammo_casing/energy/shot = ammo_type[current_firemode_index]
		new_item_state += "[shot.select_name]"
	new_item_state += "[ratio]"
	item_state = new_item_state

/obj/item/gun/energy/update_overlays()
	. = ..()
	if(QDELETED(src))
		return
	if(!automatic_charge_overlays)
		return
	var/overlay_icon_state  = "[icon_state]_charge"
	var/ratio = get_charge_ratio()
	if (modifystate)
		var/obj/item/ammo_casing/energy/shot = ammo_type[current_firemode_index]
		// Some guns, like the mini egun, don't have non-charge mode states. Remove or rework this check when that's fixed.
		// Currently, it's entirely too hyperspecific; there's no way to have the non-charge overlay without the charge overlay, for example.
		// Oh, well.
		if (shot_type_overlay)
			. += "[icon_state]_[shot.select_name]"
		overlay_icon_state += "_[shot.select_name]"
	if(ratio == 0)
		. += "[icon_state]_empty"
	else
		if(!shaded_charge)
			var/mutable_appearance/charge_overlay = mutable_appearance(icon, overlay_icon_state)
			for(var/i = ratio, i >= 1, i--)
				charge_overlay.pixel_x = ammo_x_offset * (i - 1)
				charge_overlay.pixel_y = ammo_y_offset * (i - 1)
				. += new /mutable_appearance(charge_overlay)
		else
			. += "[icon_state]_charge[ratio]"

///Used by update_icon_state() and update_overlays()
/obj/item/gun/energy/proc/get_charge_ratio()
	return can_shoot() ? CEILING(clamp(cell.charge / cell.maxcharge, 0, 1) * charge_sections, 1) : 0
	// Sets the ratio to 0 if the gun doesn't have enough charge to fire, or if its power cell is removed.

/obj/item/gun/energy/suicide_act(mob/living/user)
	if (istype(user) && can_shoot() && can_trigger_gun(user) && user.get_bodypart(BODY_ZONE_HEAD))
		user.visible_message("<span class='suicide'>[user] is putting the barrel of [src] in [user.p_their()] mouth.  It looks like [user.p_theyre()] trying to commit suicide!</span>")
		sleep(25)
		if(user.is_holding(src))
			user.visible_message("<span class='suicide'>[user] melts [user.p_their()] face off with [src]!</span>")
			playsound(loc, fire_sound, 50, 1, -1)
			playsound(src, 'sound/weapons/dink.ogg', 30, 1)
			var/obj/item/ammo_casing/energy/shot = ammo_type[current_firemode_index]
			cell.use(shot.e_cost)
			update_icon()
			return(FIRELOSS)
		else
			user.visible_message("<span class='suicide'>[user] panics and starts choking to death!</span>")
			return(OXYLOSS)
	else
		user.visible_message("<span class='suicide'>[user] is pretending to melt [user.p_their()] face off with [src]! It looks like [user.p_theyre()] trying to commit suicide!</b></span>")
		playsound(src, "gun_dry_fire", 30, 1)
		return (OXYLOSS)


/obj/item/gun/energy/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, selfcharge))
			if(var_value)
				START_PROCESSING(SSobj, src)
			else
				STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/gun/energy/ignition_effect(atom/A, mob/living/user)
	if(!can_shoot() || !ammo_type[current_firemode_index])
		shoot_with_empty_chamber()
		. = ""
	else
		var/obj/item/ammo_casing/energy/E = ammo_type[current_firemode_index]
		var/obj/item/projectile/energy/BB = E.BB
		if(!BB)
			. = ""
		else if(BB.nodamage || !BB.damage || BB.damage_type == STAMINA)
			user.visible_message("<span class='danger'>[user] tries to light [user.p_their()] [A.name] with [src], but it doesn't do anything. Dumbass.</span>")
			playsound(user, E.fire_sound, 50, 1)
			playsound(user, BB.hitsound, 50, 1)
			cell.use(E.e_cost)
			. = ""
		else if(BB.damage_type != BURN)
			user.visible_message("<span class='danger'>[user] tries to light [user.p_their()] [A.name] with [src], but only succeeds in utterly destroying it. Dumbass.</span>")
			playsound(user, E.fire_sound, 50, 1)
			playsound(user, BB.hitsound, 50, 1)
			cell.use(E.e_cost)
			qdel(A)
			. = ""
		else
			playsound(user, E.fire_sound, 50, 1)
			playsound(user, BB.hitsound, 50, 1)
			cell.use(E.e_cost)
			. = "<span class='danger'>[user] casually lights their [A.name] with [src]. Damn.</span>"

/obj/item/gun/energy/altafterattack(atom/target, mob/user, proximity_flags, params)
	if(!right_click_overridden)
		select_fire(user)
		return TRUE
	return ..()
