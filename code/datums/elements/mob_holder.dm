/datum/element/mob_holder
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2
	var/worn_state
	var/alt_worn
	var/right_hand
	var/left_hand
	var/inv_slots
	var/proctype //if present, will be invoked on headwear generation.
	var/escape_on_find = FALSE //if present, will be released upon the item being 'found' (i.e. opening a container or pocket with it present)

/datum/element/mob_holder/Attach(datum/target, worn_state, alt_worn, right_hand, left_hand, inv_slots = NONE, proctype, escape_on_find)
	. = ..()

	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE

	src.worn_state = worn_state
	src.alt_worn = alt_worn
	src.right_hand = right_hand
	src.left_hand = left_hand
	src.inv_slots = inv_slots
	src.proctype = proctype
	src.escape_on_find = escape_on_find

	RegisterSignal(target, COMSIG_ATOM_REQUESTING_CONTEXT_FROM_ITEM, PROC_REF(on_requesting_context_from_item))
	RegisterSignal(target, COMSIG_CLICK_ALT, PROC_REF(mob_try_pickup))
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/element/mob_holder/Detach(datum/source, force)
	. = ..()
	UnregisterSignal(source, list(COMSIG_ATOM_REQUESTING_CONTEXT_FROM_ITEM, COMSIG_CLICK_ALT, COMSIG_PARENT_EXAMINE))

/datum/element/mob_holder/proc/on_examine(mob/living/source, mob/user, list/examine_list)
	if(ishuman(user) && !istype(source.loc, /obj/item/clothing/head/mob_holder))
		examine_list += "<span class='notice'>Looks like [source.p_they(TRUE)] can be picked up with <b>Alt+Click</b>!</span>"

/datum/element/mob_holder/proc/on_requesting_context_from_item(
	obj/source,
	list/context,
	obj/item/held_item,
	mob/living/user,
)
	SIGNAL_HANDLER

	if(ishuman(user))
		LAZYSET(context[SCREENTIP_CONTEXT_ALT_LMB], INTENT_ANY, "Pick up")
		return CONTEXTUAL_SCREENTIP_SET

/datum/element/mob_holder/proc/mob_try_pickup(mob/living/source, mob/user)
	if(!ishuman(user) || !user.Adjacent(source) || user.incapacitated())
		return FALSE
	if(user.get_active_held_item())
		to_chat(user, "<span class='warning'>Your hands are full!</span>")
		return FALSE
	if(source.buckled)
		to_chat(user, "<span class='warning'>[source] is buckled to something!</span>")
		return FALSE
	if(source == user)
		to_chat(user, "<span class='warning'>You can't pick yourself up.</span>")
		return FALSE
	source.visible_message("<span class='warning'>[user] starts picking up [source].</span>", \
					"<span class='userdanger'>[user] starts picking you up!</span>")
	if(!do_after(user, 2 SECONDS, target = source) || source.buckled)
		return FALSE

	source.visible_message("<span class='warning'>[user] picks up [source]!</span>", \
					"<span class='userdanger'>[user] picks you up!</span>")
	to_chat(user, "<span class='notice'>You pick [source] up.</span>")
	source.drop_all_held_items()
	var/obj/item/clothing/head/mob_holder/holder = new(get_turf(source), source, worn_state, alt_worn, right_hand, left_hand, inv_slots)
	holder.escape_on_find = escape_on_find

	if(proctype)
		INVOKE_ASYNC(src, proctype, source, holder, user)
	user.put_in_hands(holder)
	return TRUE

/datum/element/mob_holder/proc/drone_worn_icon(mob/living/simple_animal/drone/D, obj/item/clothing/head/mob_holder/holder, mob/user)
	var/new_state = "[D.visualAppearence]_hat"
	holder.item_state = new_state
	holder.icon_state = new_state


//The item itself,
/obj/item/clothing/head/mob_holder
	name = "bugged mob"
	desc = "Yell at coderbrush."
	icon = null
	mob_overlay_icon = 'icons/mob/animals_held.dmi'
	righthand_file = 'icons/mob/animals_held_rh.dmi'
	lefthand_file = 'icons/mob/animals_held_lh.dmi'
	icon_state = ""
	w_class = WEIGHT_CLASS_BULKY
	dynamic_hair_suffix = ""
	var/mob/living/held_mob
	var/escape_on_find
	var/destroying = FALSE

/obj/item/clothing/head/mob_holder/Initialize(mapload, mob/living/target, worn_state, alt_worn, right_hand, left_hand, slots = NONE)
	. = ..()

	if(target)
		assimilate(target)

	if(alt_worn)
		mob_overlay_icon = alt_worn
	if(worn_state)
		item_state = worn_state
		icon_state = worn_state
	if(left_hand)
		lefthand_file = left_hand
	if(right_hand)
		righthand_file = right_hand
	slot_flags = slots

/obj/item/clothing/head/mob_holder/proc/assimilate(mob/living/target)
	target.setDir(SOUTH)
	held_mob = target
	target.forceMove(src)
	var/image/I = new //work around to retain the same appearance to the mob idependently from inhands/worn states.
	I.appearance = target.appearance
	I.layer = FLOAT_LAYER //So it doesn't get screwed up by layer overrides.
	I.plane = FLOAT_PLANE //Same as above but for planes.
	I.override = TRUE
	add_overlay(I)
	name = target.name
	desc = target.desc
	switch(target.mob_size)
		if(MOB_SIZE_TINY)
			w_class = WEIGHT_CLASS_TINY
		if(MOB_SIZE_SMALL)
			w_class = WEIGHT_CLASS_NORMAL
		if(MOB_SIZE_LARGE)
			w_class = WEIGHT_CLASS_HUGE

/obj/item/clothing/head/mob_holder/Destroy()
	destroying = TRUE
	if(held_mob)
		release(FALSE)
	return ..()

/obj/item/clothing/head/mob_holder/examine(mob/user)
	return held_mob?.examine(user) || ..()

/obj/item/clothing/head/mob_holder/on_thrown(mob/living/carbon/user, atom/target)
	if((item_flags & ABSTRACT) || HAS_TRAIT(src, TRAIT_NODROP))
		return
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_notice("You set [src] down gently on the ground."))
		release()
		return

	var/mob/living/throw_mob = held_mob
	release()
	return throw_mob

/obj/item/clothing/head/mob_holder/dropped(mob/user)
	. = ..()
	if(held_mob && isturf(loc))
		release()

/obj/item/clothing/head/mob_holder/proc/release(del_on_release = TRUE, display_messages = TRUE)
	if(!held_mob)
		if(del_on_release && !destroying)
			qdel(src)
		return FALSE
	var/mob/living/released_mob = held_mob
	held_mob = null // stops the held mob from being release()'d twice.
	if(isliving(loc))
		var/mob/living/L = loc
		if(display_messages)
			to_chat(L, span_warning("[released_mob] wriggles free!"))
		L.dropItemToGround(src)
	released_mob.forceMove(drop_location())
	released_mob.reset_perspective()
	released_mob.setDir(SOUTH)
	if(display_messages)
		released_mob.visible_message(span_warning("[released_mob] uncurls!"))
	if(del_on_release && !destroying)
		qdel(src)
	return TRUE

/obj/item/clothing/head/mob_holder/relaymove(mob/living/user, direction)
	container_resist()

/obj/item/clothing/head/mob_holder/container_resist()
	if(isliving(loc))
		var/mob/living/L = loc
		L.visible_message("<span class='warning'>[held_mob] escapes from [L]!</span>", "<span class='warning'>[held_mob] escapes your grip!</span>")
	release()

/obj/item/clothing/head/mob_holder/Exited(atom/movable/gone, direction)
	. = ..()
	if(held_mob && held_mob == gone)
		release()

/obj/item/clothing/head/mob_holder/mob_can_equip(M, equipper, slot, disable_warning, bypass_equip_delay_self)
	if(M == held_mob || !ishuman(M)) //monkeys holding monkeys holding monkeys...
		return FALSE
	return ..()

/obj/item/clothing/head/mob_holder/assume_air(datum/gas_mixture/env)
	var/atom/location = loc
	if(!loc)
		return //null
	var/turf/T = get_turf(loc)
	while(location != T)
		location = location.loc
		if(ismob(location))
			return location.loc.assume_air(env)
	return location.assume_air(env)

/obj/item/clothing/head/mob_holder/proc/get_loc_for_air()
	var/atom/location = loc
	if(!loc)
		return //null
	var/turf/T = get_turf(loc)
	while(location != T)
		location = location.loc
		if(ismob(location))
			return location.loc
	return location

/obj/item/clothing/head/mob_holder/assume_air_moles(datum/gas_mixture/env, moles)
	var/atom/location = get_loc_for_air()
	return location.assume_air_moles(env, moles)

/obj/item/clothing/head/mob_holder/assume_air_ratio(datum/gas_mixture/env, ratio)
	var/atom/location = get_loc_for_air()
	return location.assume_air_ratio(env, ratio)

/obj/item/clothing/head/mob_holder/remove_air(amount)
	var/atom/location = get_loc_for_air()
	return location.remove_air(amount)

/obj/item/clothing/head/mob_holder/remove_air_ratio(ratio)
	var/atom/location = get_loc_for_air()
	return location.remove_air_ratio(ratio)

/obj/item/clothing/head/mob_holder/transfer_air(datum/gas_mixture/taker, amount)
	var/atom/location = get_loc_for_air()
	return location.transfer_air(taker, amount)

/obj/item/clothing/head/mob_holder/transfer_air_ratio(datum/gas_mixture/taker, ratio)
	var/atom/location = get_loc_for_air()
	return location.transfer_air(taker, ratio)

// escape when found if applicable
/obj/item/clothing/head/mob_holder/on_found(mob/finder)
	if(escape_on_find)
		to_chat(finder, span_warning("\A [held_mob.name] pops out! "))
		finder.visible_message(span_warning("\A [held_mob.name] pops out of the container [finder] is opening!"), ignored_mobs = finder)
		release(TRUE, FALSE)
		return
