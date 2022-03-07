///////////////////////////
// Dost thou even hoist? //
///////////////////////////

/obj/item/hoist_kit
	name = "hoist kit"
	desc = "A setup kit for a hoist that can be used to lift things. The hoist will deploy in the direction you're facing."
	icon = 'icons/modules/multiz/hoists.dmi'
	icon_state = "hoist_case"

/obj/item/hoist_kit/attack_self(mob/user)
	. = ..()
	if (!do_after(usr, (2 SECONDS), src))
		return

	var/obj/structure/hoist/hoist = new (get_turf(user), user.dir)
	transfer_fingerprints_to(hoist)
	user.visible_message(
		span_notice("[user] deploys the hoist kit!"),
		span_notice("You deploy the hoist kit!"),
		"You hear the sound of parts snapping into place.")
	qdel(src)

/obj/effect/hoist_hook
	name = "hoist clamp"
	desc = "A clamp used to lift people or things."
	icon = 'icons/modules/multiz/hoists.dmi'
	icon_state = "hoist_hook"
	can_buckle = TRUE
	anchored = TRUE

	/// hoist that owns us
	var/obj/structure/hoist/source_hoist
	/// attached atom
	var/atom/movable/attached

/obj/effect/hoist_hook/proc/Attach(atom/movable/target, mob/user)
	if(attached)
		Detach()
	if(!isobj(target) && !ismob(target))
		if(user)
			to_chat(user, span_warning("[target] can't be attached to [src]!"))
		return
	if(target.anchored || target.move_resist >= MOVE_FORCE_EXTREMELY_STRONG)
		if(user)
			to_chat(user, span_warning("[target] is too heavy to attach to [src], or is anchored to the ground!"))
		return
	visible_message(span_notice(user? "[user] attached [target] to src." : "[target] attaches to [src]!"))
	attached = target
	source_hoist?.layer = target.layer + 0.1
	target.forceMove(loc)
	RegisterSignal(attached, COMSIG_MOVABLE_CAN_ZFALL, .proc/InterceptAttachedFall)
	RegisterSignal(attached, COMSIG_MOVABLE_MOVED, .proc/InterceptMove)

/obj/effect/hoist_hook/proc/Detach(mob/user)
	if(!attached)
		return
	if(ismob(attached))
		unbuckle_mob(attached)
	UnregisterSignal(attached, list(
		COMSIG_MOVABLE_CAN_ZFALL,
		COMSIG_MOVABLE_MOVED
	))
	if(source_hoist)
		source_hoist.layer = initial(source_hoist.layer)
	visible_message(span_notice(user? "[user] detached [attached] from [src]." : "[attached] is detached from [src]!"))
	attached.ZFall()	// go on, git.
	attached = null

/obj/effect/hoist_hook/proc/InterceptMove(datum/source)
	if(source == attached)
		Detach()

/obj/effect/hoist_hook/proc/InterceptAttachedFall()
	return FALL_BLOCKED

/obj/effect/hoist_hook/Moved(atom/OldLoc, Dir)
	. = ..()
	if(attached && !ismob(attached))	// buckle handles mob
		attached.forceMove(loc)

/obj/effect/hoist_hook/MouseDropped(atom/dropping, mob/user)
	. = ..()
	if(!Adjacent(dropping) || !Adjacent(user))
		return
	Attach(dropping, user)

/obj/effect/hoist_hook/on_attack_hand(mob/living/user, act_intent, unarmed_attack_flags)
	. = ..()
	Detach(user)

/obj/structure/hoist
	name = "hoist"
	desc = "A manual hoist, uses a clamp and pulley to hoist things."
	icon = 'icons/modules/multiz/hoists.dmi'
	icon_state = "hoist_base"
	density = TRUE
	anchored = TRUE

	var/broken = FALSE
	var/atom/movable/hoistee
	var/movedir = UP
	var/obj/effect/hoist_hook/source_hook

/obj/structure/hoist/Initialize(mapload, ndir)
	. = ..()
	set_dir(ndir)
	var/turf/newloc = get_step(src, dir)
	source_hook = new(newloc)
	source_hook.source_hoist = src

/obj/structure/hoist/Destroy()
	if(hoistee)
		release_hoistee()
	QDEL_NULL(src.source_hook)
	return ..()

/obj/effect/hoist_hook/Destroy()
	source_hoist = null
	return ..()

/obj/structure/hoist/proc/check_consistency()
	if (!hoistee)
		return
	if (hoistee.z != source_hook.z)
		release_hoistee()
		return

/obj/structure/hoist/proc/release_hoistee()
	if(ismob(hoistee))
		source_hook.unbuckle_mob(hoistee)
	else
		hoistee.anchored = FALSE
	events_repository.unregister(/decl/observ/destroyed, hoistee, src)
	hoistee = null
	layer = initial(layer)

/obj/structure/hoist/proc/break_hoist()
	if(broken)
		return
	broken = TRUE
	desc += " It looks broken, and the clamp has retracted back into the hoist. Seems like you'd have to re-deploy it to get it to work again."
	if(hoistee)
		release_hoistee()
	QDEL_NULL(source_hook)
/obj/structure/hoist/explosion_act(severity)
	. = ..()
	if(.)

		if(severity == 1 || (severity == 2 && prob(50)))
			physically_destroyed()
		else if(severity == 2)
			visible_message("\The [src] shakes violently, and neatly collapses as its damage sensors go off.")
			collapse_kit()
		else if(severity == 3 && prob(50) && !broken)
			break_hoist()

/obj/effect/hoist_hook/explosion_act(severity)
	. = ..()
	if(. && (severity == 1 || (severity == 2 && prob(50)) || (severity == 3 && prob(25))))
		source_hoist.break_hoist()

/obj/structure/hoist/attack_hand(mob/user)
	if (!ishuman(user))
		return

	if (user.incapacitated())
		to_chat(user, span_warning("You can't do that while incapacitated."))
		return

	if (!user.check_dexterity(DEXTERITY_GRIP))
		return

	if(broken)
		to_chat(user, span_warning("The hoist is broken!"))
		return
	var/can = can_move_dir(movedir)
	var/movtext = movedir == UP ? "raise" : "lower"
	if (!can) // If you can't...
		movedir = movedir == UP ? DOWN : UP // switch directions!
		to_chat(user, span_notice("You switch the direction of the pulley."))
		return

	if (!hoistee)
		user.visible_message(
			span_notice("[user] begins to [movtext] the clamp."),
			span_notice("You begin to [movtext] the clamp."),
			span_notice("You hear the sound of a crank."))
		move_dir(movedir, 0)
		return

	check_consistency()

	var/size
	if (ismob(hoistee))
		var/mob/M = hoistee
		size = M.mob_size
	else if (isobj(hoistee))
		var/obj/O = hoistee
		size = O.w_class

	user.visible_message(
		span_notice("[user] begins to [movtext] \the [hoistee]!"),
		span_notice("You begin to [movtext] \the [hoistee]!"),
		span_notice("You hear the sound of a crank."))
	if (do_after(user, (1 SECONDS) * size / 4, src))
		move_dir(movedir, 1)

/obj/structure/hoist/proc/collapse_kit(atom/location)
	var/obj/item/hoist_kit/kit = new(location)
	transfer_fingerprints_to(kit)
	. = kit
	qdel(src)

/obj/structure/hoist/verb/collapse_hoist()
	set name = "Collapse Hoist"
	set category = "Object"
	set src in range(1)

	if (!ishuman(usr))
		return

	if (isobserver(usr) || usr.incapacitated())
		return
	if (!usr.check_dexterity(DEXTERITY_GRIP))
		return

	if (hoistee)
		to_chat(usr, span_notice("You cannot collapse the hoist with \the [hoistee] attached!"))
		return

	if (!do_after(usr, (2 SECONDS), src))
		return

	collapse_kit()

/obj/structure/hoist/proc/can_move_dir(direction)
	var/turf/dest = direction == UP ? GetAbove(source_hook) : GetBelow(source_hook)
	if(!istype(dest))
		return FALSE
	switch(direction)
		if (UP)
			if(!dest.is_open()) // can't move into a solid tile
				return FALSE
			if (source_hook in get_step(src, dir)) // you don't get to move above the hoist
				return FALSE
		if (DOWN)
			var/turf/T = get_turf(source_hook)
			if(!istype(T) || !T.is_open()) // can't move down through a solid tile
				return FALSE
	return TRUE // i thought i could trust myself to write something as simple as this, guess i was wrong

/obj/structure/hoist/proc/move_dir(direction, ishoisting)
	var/can = can_move_dir(direction)
	if (!can)
		return 0
	var/turf/move_dest = direction == UP ? GetAbove(source_hook) : GetBelow(source_hook)
	source_hook.forceMove(move_dest)
	if (!ishoisting)
		return 1
	hoistee.hoist_act(move_dest)
	return 1

/atom/movable/proc/hoist_act(turf/dest)
	forceMove(dest)
	return TRUE
