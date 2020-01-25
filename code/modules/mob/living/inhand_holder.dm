//Generic system for picking up mobs.
//Currently works for head and hands.
/obj/item/clothing/head/mob_holder
	name = "bugged mob"
	desc = "Yell at coderbrush."
	icon = null
	icon_state = ""
	var/mob/living/held_mob
	var/can_head = FALSE
	w_class = WEIGHT_CLASS_BULKY

/obj/item/clothing/head/mob_holder/Initialize(mapload, mob/living/M, _worn_state, alt_worn, lh_icon, rh_icon, _can_head_override = FALSE)
	. = ..()

	if(M)
		M.setDir(SOUTH)
		held_mob = M
		M.forceMove(src)
		appearance = M.appearance
		name = M.name
		desc = M.desc

	if(_can_head_override)
		can_head = _can_head_override
	if(alt_worn)
		alternate_worn_icon = alt_worn
	if(_worn_state)
		item_state = _worn_state
		icon_state = _worn_state
	if(lh_icon)
		lefthand_file = lh_icon
	if(rh_icon)
		righthand_file = rh_icon
	if(!can_head)
		slot_flags = NONE

/obj/item/clothing/head/mob_holder/Destroy()
	if(held_mob)
		release()
	return ..()

/obj/item/clothing/head/mob_holder/dropped()
	..()
	if(isturf(loc))//don't release on soft-drops
		release()

/obj/item/clothing/head/mob_holder/proc/release()
	if(isliving(loc))
		var/mob/living/L = loc
		L.dropItemToGround(src)
	if(held_mob)
		var/mob/living/m = held_mob
		m.forceMove(get_turf(m))
		m.reset_perspective()
		m.setDir(SOUTH)
		held_mob = null
	qdel(src)

/obj/item/clothing/head/mob_holder/relaymove(mob/user)
	return

/obj/item/clothing/head/mob_holder/container_resist()
	if(isliving(loc))
		var/mob/living/L = loc
		visible_message("<span class='warning'>[src] escapes [L]!</span>")
	release()

/mob/living/proc/mob_pickup(mob/living/L)
	var/obj/item/clothing/head/mob_holder/holder = generate_mob_holder()
	if(!holder)
		return
	drop_all_held_items()
	L.put_in_hands(holder)
	return

/mob/living/proc/mob_try_pickup(mob/living/user)
	if(!ishuman(user) || !src.Adjacent(user) || user.incapacitated() || !can_be_held)
		return FALSE
	if(user.get_active_held_item())
		to_chat(user, "<span class='warning'>Your hands are full!</span>")
		return FALSE
	if(buckled)
		to_chat(user, "<span class='warning'>[src] is buckled to something!</span>")
		return FALSE
	if(src == user)
		to_chat(user, "<span class='warning'>You can't pick yourself up.</span>")
		return FALSE
	visible_message("<span class='warning'>[user] starts picking up [src].</span>", \
					"<span class='userdanger'>[user] starts picking you up!</span>")
	if(!do_after(user, 20, target = src))
		return FALSE

	if(user.get_active_held_item()||buckled)
		return FALSE

	visible_message("<span class='warning'>[user] picks up [src]!</span>", \
					"<span class='userdanger'>[user] picks you up!</span>")
	to_chat(user, "<span class='notice'>You pick [src] up.</span>")
	mob_pickup(user)
	return TRUE

/mob/living/AltClick(mob/user)
	. = ..()
	if(mob_try_pickup(user))
		return TRUE


// I didn't define these for mobs, because you shouldn't be able to breathe out of mobs and using their loc isn't always the logical thing to do.

/obj/item/clothing/head/mob_holder/assume_air(datum/gas_mixture/env)
	var/atom/location = loc
	if(!loc)
		return //null
	var/turf/T = get_turf(loc)
	while(location != T)
		location = location.loc
		if(ismob(location))
			return location.loc.assume_air(env)
	return loc.assume_air(env)

/obj/item/clothing/head/mob_holder/remove_air(amount)
	var/atom/location = loc
	if(!loc)
		return //null
	var/turf/T = get_turf(loc)
	while(location != T)
		location = location.loc
		if(ismob(location))
			return location.loc.remove_air(amount)
	return loc.remove_air(amount)
