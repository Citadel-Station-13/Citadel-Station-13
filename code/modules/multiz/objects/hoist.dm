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
	/// currently moving the attached atom
	var/moving = FALSE

/obj/effect/hoist_hook/Destroy()
	if(attached)
		Detach()
	if(source_hoist)
		if(source_hoist.hook == src)
			source_hoist.hook = null
		source_hoist.obj_break()
		source_hoist = null
	return ..()

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
	if(ismob(target))
		var/mob/M = target
		buckle_mob(M, TRUE, FALSE)
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
	if(source != attached)
		return
	if(!moving)
		Detach()

/obj/effect/hoist_hook/proc/InterceptAttachedFall()
	return FALL_BLOCKED

/obj/effect/hoist_hook/proc/MoveTo(atom/newloc)
	moving = TRUE
	forceMove(newloc)
	moving = FALSE
	var/attached = src.attached
	attached?.forceMove(loc)
	if(attached && !src.attached)
		Attach(attached)

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

	var/movedir = UP
	var/obj/effect/hoist_hook/hook

/obj/structure/hoist/Initialize(mapload, ndir)
	. = ..()
	setDir(ndir)
	var/turf/newloc = get_step(src, dir)
	hook = new(newloc)
	hook.source_hoist = src

/obj/structure/hoist/Destroy()
	QDEL_NULL(hook)
	return ..()

/obj/structure/hoist/obj_break(damage_flag)
	. = ..()
	if(hook)
		visible_message("[src] breaks!")
		QDEL_NULL(hook)

/obj/structure/hoist/deconstruct(disassembled)
	var/obj/item/hoist_kit/kit = new(location)
	transfer_fingerprints_to(kit)
	return ..()

/obj/structure/hoist/examine(mob/user)
	. = ..()
	if(!hook)
		. += span_warning("It looks broken, and the clamp has retracted back into the hoist. Seems like you'd have to re-deploy it to get it to work again.")

/obj/structure/hoist/on_attack_hand(mob/user, act_intent, unarmed_attack_flags)
	. = ..()

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

	if(!isliving(usr))
		return
	var/mob/living/L = usr
	if(!CHECK_MOBILITY(L, MOBILITY_USE))
		return
	visible_message(span_notice("[L] begins to collapse [src]."))
	if (!do_after(L, 2 SECONDS, src))
		L.show_message("You fail to collapse [src]!")
		return
	visible_message(span_notice("[L] collapses [src]."))
	collapse_kit()

/obj/structure/hoist/proc/can_move_dir(direction, mob/user)
	var/turf/source = get_turf(hook)
	if(!source)
		return FALSE
	var/turf/dest = get_step_multiz(source, direction)
	if(!dest)
		return FALSE
	if(!source.CanZPass(hook, direction))
		if(user)
			to_chat(user, span_warning("Something is blocking the hoist hook!"))
		return FALSE
	switch(direction)
		if(UP)
			// no moving above hoist
			var/list/stack = SSmapping.GetZStack(z)
			if(!(hook.z in stack) || (stack.Find(dest.z) > stack.Find(z)))
				to_chat(user, span_warning("How are you going to move the hoist hook above the hoist?"))
				return FALSE
	return TRUE

/obj/structure/hoist/proc/move_dir(direction, mob/user)
	ASSERT(direction == UP || direction == DOWN)
	if(!can_move_dir(direction, user))
		return FALSE
	if(user)
		visible_message(span_notice("[user] [direction == UP? "raises" : "lowers"] \the [src]."))
	hook.forceMove(get_step_multiz(hook, direction))

/atom/movable/proc/hoist_act(turf/dest)
	forceMove(dest)
	return TRUE
