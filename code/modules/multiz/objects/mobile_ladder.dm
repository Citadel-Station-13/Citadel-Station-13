/obj/item/mobile_ladder
	name = "mobile ladder"
	desc = "A lightweight deployable ladder, which you can use to move up or down. Or alternatively, you can bash some faces in."
	icon = 'icons/modules/multiz/items.dmi'
	lefthand_file = 'icons/modules/multiz/items_lefthand.dmi'
	righthand_file = 'icons/modules/multiz/items_righthand.dmi'
	mob_overlay_icon = 'icons/modules/multiz/items_worn.dmi'
	icon_state = "mobile_ladder"
	throw_range = 3
	force = 10
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	/// place delay
	var/place_delay = 20

/obj/item/mobile_ladder/proc/place_ladder(atom/A, mob/user)
	var/dir
	var/turf/T = isturf(A)? A : A.loc
	if(!istype(T))
		return FALSE

	var/turf/below = T.Below()
	var/turf/above
	if(T.contains_dense_object())
		to_chat(user, span_warning("There's no room in [T] to place [src]."))
		return FALSE

	if(T.zPassOut(null, DOWN, below))
		if(!istype(below))
			to_chat(user, span_warning("There's nothing below you!"))
			return FALSE
		// try to place below
		if(below.contains_dense_object() || !below.zPassIn(null, DOWN, T))
			to_chat(user, span_warning("There's something blocking you from extending [src] into [below]."))
			return FALSE
		if(locate(/obj/structure/ladder) in below)
			to_chat(user, span_warning("There's already a ladder below [T]."))
			return FALSE
		dir = DOWN
	else
		// try to place to reach above
		above = T.Above()
		if(!above)
			to_chat(user, span_warning("There's nothing of interest above [T]."))
			return FALSE
		if(above.contains_dense_object() || !above.zPassIn(null, UP, T) || !T.zPassOut(null, UP, above))
			to_chat(user, span_warning("There's something blocking you from extending [src] into [above]."))
			return FALSE
		if(locate(/obj/structure/ladder) in above)
			to_chat(user, span_warning("There's already a ladder above [T]."))
			return FALSE
		dir = UP
	if(!dir)
		return FALSE
	if(above)
		user.visible_message(
			span_notice("\The [user] begins deploying \the [src] on \the [A]."),
			span_notice("You begin to deploy \the [src] on \the [A].")
		)
	else
		user.visible_message(
			span_notice("\The [user] begins to lower \the [src] into \the [A]."),
			span_warning("You begin to lower \the [src] into \the [A].")
		)

	if (!handle_action(A, user))
		return
	if(!user.dropItemToGround(src))
		to_chat(user, span_warning("You can't seem to get [src] out of your hands..."))
		return
	if(above)
		user.visible_message(
			span_notice("\The [user] deploys \the [src] on \the [A]."),
			span_notice("You deploy \the [src] on \the [A].")
		)
	else
		user.visible_message(
			span_notice("\The [user] lowers \the [src] into \the [A]."),
			span_warning("You lower \the [src] into \the [A].")
		)
	ASSERT(above || below)
	var/obj/structure/ladder/mobile/ladder = new(above || below)
	transfer_fingerprints_to(ladder)
	ladder = new(T)
	transfer_fingerprints_to(ladder)
	qdel(src)

/obj/item/mobile_ladder/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if (!proximity)
		return
	place_ladder(A,user)

/obj/item/mobile_ladder/proc/handle_action(atom/A, mob/user)
	if (!do_after(user, place_delay, user))
		return FALSE
	if (QDELETED(A) || QDELETED(src))
		// Shit was deleted during delay, call is no longer valid.
		return FALSE
	return TRUE

/obj/structure/ladder/mobile
	name = "mobile ladder"
	desc = "A lightweight deployable ladder, it can be folded back into its portable form."
	icon_state = "mobile_ladder"

/obj/structure/ladder/mobile/verb/fold_ladder()
	set name = "Fold Ladder"
	set category = "Object"
	set src in oview(1)

	if(!isliving(usr))
		return

	if(!usr.CanReach(src))
		return

	fold(usr)

/obj/structure/ladder/mobile/AltClick(mob/user)
	. = ..()
	if(isliving(user) && user.CanReach(src))
		fold(user)

/obj/structure/ladder/mobile/proc/fold(mob/living/user)
	if(user)
		if(!in_range(src, user))
			to_chat(user, span_warning("You can't reach [src] from there."))
			return

		if(!user.IsAdvancedToolUser())
			to_chat(user, span_warning("You lack the dexterity to do this."))
			return

		if(!CHECK_MOBILITY(user, MOBILITY_USE))
			to_chat(user, span_warning("You can't do that right now!"))
			return

		user.visible_message(
			span_notice("[user] starts folding up \the [src]."),
			span_notice("You start folding up \the [src]."))

		if(!do_after(user, 20, src))
			return

	var/obj/item/mobile_ladder/R = new(get_turf(user) || drop_location())

	transfer_fingerprints_to(R)
	if(user)
		user.put_in_hands(R)
		user.visible_message(
			span_notice("[user] folds \the [src]."),
			span_notice("You fold \the [src]."))

	if(istype(down, /obj/structure/ladder/mobile))
		QDEL_NULL(down)
	else if(istype(up, /obj/structure/ladder/mobile))
		QDEL_NULL(up)

	qdel(src)
