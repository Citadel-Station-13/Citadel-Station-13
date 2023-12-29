/*
	Before anything else, defer these calls to a per-mobtype handler.  This allows us to
	remove istype() spaghetti code, but requires the addition of other handler procs to simplify it.

	Alternately, you could hardcode every mob's variation in a flat ClickOn() proc; however,
	that's a lot of code duplication and is hard to maintain.

	Note that this proc can be overridden, and is in the case of screen objects.
*/
/atom/Click(location,control,params)
	if(flags_1 & INITIALIZED_1)
		SEND_SIGNAL(src, COMSIG_CLICK, location, control, params, usr)
		usr.CommonClickOn(src, params)

/atom/DblClick(location,control,params)
	if(flags_1 & INITIALIZED_1)
		usr.DblClickOn(src,params)

/atom/MouseWheel(delta_x,delta_y,location,control,params)
	if(flags_1 & INITIALIZED_1)
		usr.MouseWheelOn(src, delta_x, delta_y, params)

/**
  * Common mob click code
  */
/mob/proc/CommonClickOn(atom/A, params)
	//SHOULD_NOT_SLEEP(TRUE)
	if(mob_transforming)
		return
	if(SEND_SIGNAL(src, COMSIG_MOB_CLICKON, A, params) & COMSIG_MOB_CANCEL_CLICKON)
		return
	. = ClickOn(A, params)
	if(!(. & DISCARD_LAST_ACTION))
		FlushCurrentAction()
	else
		DiscardCurrentAction()

/*
	Standard mob ClickOn()
	Handles exceptions: Buildmode, middle click, modified clicks, mech actions

	After that, mostly just check your state, check whether you're holding an item,
	check whether you're adjacent to the target, then pass off the click to whoever
	is receiving it.
	The most common are:
	* mob/UnarmedAttack(atom,adjacent) - used here only when adjacent, with no item in hand; in the case of humans, checks gloves
	* atom/attackby(item,user) - used only when adjacent
	* item/afterattack(atom,user,adjacent,params) - used both ranged and adjacent
	* mob/RangedAttack(atom,params) - used only ranged, only used for tk and laser eyes but could be changed
*/
/mob/proc/ClickOn(atom/A, params)
	if(check_click_intercept(params,A))
		return

	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["middle"])
		return ShiftMiddleClickOn(A)
	if(modifiers["shift"] && modifiers["ctrl"])
		return CtrlShiftClickOn(A)
	if(modifiers["middle"])
		if(modifiers["ctrl"])
			return CtrlMiddleClickOn(A)
		else
			return MiddleClickOn(A)
	if(modifiers["shift"] && (client && client.show_popup_menus || modifiers["right"])) //CIT CHANGE - makes shift-click examine use right click instead of left click in combat mode
		return ShiftClickOn(A)
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		return AltClickOn(A)
	if(modifiers["ctrl"] && modifiers["right"]) //CIT CHANGE - right click ctrl for a new form of dropping items
		return CtrlRightClickOn(A, params) //CIT CHANGE
	if(modifiers["ctrl"])
		return CtrlClickOn(A)

	if(modifiers["right"]) //CIT CHANGE - allows right clicking to perform actions
		return RightClickOn(A, params) //CIT CHANGE - ditto

	if(incapacitated(ignore_restraints = 1))
		return

	face_atom(A)

	if(!CheckActionCooldown(immediate = TRUE))
		return

	if(!modifiers["catcher"] && A.IsObscured())
		return

	if(restrained())
		DelayNextAction(CLICK_CD_HANDCUFFED)
		return RestrainedClickOn(A)

	if(throw_mode)
		throw_item(A)
		return

	var/obj/item/W = get_active_held_item()

	if(W == A)
		W.attack_self(src)
		update_inv_hands()
		return

	//These are always reachable.
	//User itself, current loc, and user inventory
	if(A in DirectAccess())
		if(W)
			return W.melee_attack_chain(src, A, params)
		else
			. = UnarmedAttack(A, TRUE, a_intent)
			if(!(. & NO_AUTO_CLICKDELAY_HANDLING) && ismob(A))
				DelayNextAction(CLICK_CD_MELEE)
			return

	//Can't reach anything else in lockers or other weirdness
	if(!loc.AllowClick())
		return

	//Standard reach turf to turf or reaching inside storage
	if(CanReach(A,W))
		if(W)
			return W.melee_attack_chain(src, A, params)
		else
			. = UnarmedAttack(A, TRUE, a_intent)
			if(!(. & NO_AUTO_CLICKDELAY_HANDLING) && ismob(A))
				DelayNextAction(CLICK_CD_MELEE)
			return
	else
		if(W)
			return W.ranged_attack_chain(src, A, params)
		else
			return RangedAttack(A,params)

//Is the atom obscured by a PREVENT_CLICK_UNDER_1 object above it
/atom/proc/IsObscured()
	if(!isturf(loc)) //This only makes sense for things directly on turfs for now
		return FALSE
	var/turf/T = get_turf_pixel(src)
	if(!T)
		return FALSE
	for(var/atom/movable/AM in T)
		if(AM.flags_1 & PREVENT_CLICK_UNDER_1 && AM.density && AM.layer > layer)
			return TRUE
	return FALSE

/turf/IsObscured()
	for(var/atom/movable/AM in src)
		if(AM.flags_1 & PREVENT_CLICK_UNDER_1 && AM.density)
			return TRUE
	return FALSE

/atom/movable/proc/CanReach(atom/ultimate_target, obj/item/tool, view_only = FALSE)
	// A backwards depth-limited breadth-first-search to see if the target is
	// logically "in" anything adjacent to us.
	var/list/direct_access = DirectAccess()
	var/depth = 1 + (view_only ? STORAGE_VIEW_DEPTH : INVENTORY_DEPTH)

	var/list/closed = list()
	var/list/checking = list(ultimate_target)
	while (checking.len && depth > 0)
		var/list/next = list()
		--depth

		for(var/atom/target in checking)  // will filter out nulls
			if(closed[target] || isarea(target))  // avoid infinity situations
				continue
			closed[target] = TRUE
			if(isturf(target) || isturf(target.loc) || (target in direct_access)) //Directly accessible atoms
				if(Adjacent(target) || (tool && CheckToolReach(src, target, tool.reach))) //Adjacent or reaching attacks
					return TRUE

			if (!target.loc)
				continue

			if(!(SEND_SIGNAL(target.loc, COMSIG_ATOM_CANREACH, next) & COMPONENT_BLOCK_REACH) && target.loc.canReachInto(src, ultimate_target, next, view_only, tool))
				next += target.loc

		checking = next
	return FALSE

/atom/movable/proc/DirectAccess()
	return list(src, loc)

/mob/DirectAccess(atom/target)
	return ..() + contents

/mob/living/DirectAccess(atom/target)
	return ..() + GetAllContents()

//This is called reach into but it's called on the deepest things first so uh, make sure to account for that!
/atom/proc/canReachInto(atom/user, atom/target, list/next, view_only, obj/item/tool)
	return TRUE

/atom/proc/AllowClick()
	return FALSE

/turf/AllowClick()
	return TRUE

/proc/CheckToolReach(atom/movable/here, atom/movable/there, reach)
	if(!here || !there)
		return
	switch(reach)
		if(0)
			return FALSE
		if(1)
			return FALSE //here.Adjacent(there)
		if(2 to INFINITY)
			var/obj/dummy = new(get_turf(here))
			dummy.pass_flags |= PASSTABLE
			dummy.invisibility = INVISIBILITY_ABSTRACT
			for(var/i in 1 to reach) //Limit it to that many tries
				var/turf/T = get_step(dummy, get_dir(dummy, there))
				if(dummy.CanReach(there))
					qdel(dummy)
					return TRUE
				if(!dummy.Move(T)) //we're blocked!
					qdel(dummy)
					return
			qdel(dummy)

// Default behavior: ignore double clicks (the second click that makes the doubleclick call already calls for a normal click)
/mob/proc/DblClickOn(atom/A, params)
	return


/*
	Translates into attack_hand, etc.

	Note: proximity_flag here is used to distinguish between normal usage (flag=1),
	and usage when clicking on things telekinetically (flag=0).  This proc will
	not be called at ranged except with telekinesis.

	proximity_flag is not currently passed to attack_hand, and is instead used
	in human click code to allow glove touches only at melee range.
*/
/mob/proc/UnarmedAttack(atom/A, proximity, intent = a_intent, flags = NONE)

/*
	Ranged unarmed attack:

	This currently is just a default for all mobs, involving
	laser eyes and telekinesis.  You could easily add exceptions
	for things like ranged glove touches, spitting alien acid/neurotoxin,
	animals lunging, etc.
*/
/mob/proc/RangedAttack(atom/A, params)
	SEND_SIGNAL(src, COMSIG_MOB_ATTACK_RANGED, A, params)
/*
	Restrained ClickOn

	Used when you are handcuffed and click things.
	Not currently used by anything but could easily be.
*/
/mob/proc/RestrainedClickOn(atom/A)
	return

/*
	Middle click
	Only used for swapping hands
*/
/mob/proc/MiddleClickOn(atom/A)
	return

/mob/living/carbon/MiddleClickOn(atom/A)
	if(!stat && mind && iscarbon(A) && A != src)
		var/datum/antagonist/changeling/C = mind.has_antag_datum(/datum/antagonist/changeling)
		if(C && C.chosen_sting)
			C.chosen_sting.try_to_sting(src,A)
			return
	swap_hand()

/mob/living/simple_animal/drone/MiddleClickOn(atom/A)
	swap_hand()

// In case of use break glass
/*
/atom/proc/MiddleClick(mob/M as mob)
	return
*/

/*
	Shift click
	For most mobs, examine.
	This is overridden in ai.dm
*/
/mob/proc/ShiftClickOn(atom/A)
	A.ShiftClick(src)
	return

/atom/proc/ShiftClick(mob/user)
	attempt_examinate(user)

/atom/proc/attempt_examinate(mob/user)
	var/flags = SEND_SIGNAL(src, COMSIG_CLICK_SHIFT, user) | SEND_SIGNAL(user, COMSIG_MOB_CLICKED_SHIFT_ON, src)
	if(!(flags & COMPONENT_DENY_EXAMINATE) && user.client && (user.client.eye == user || user.client.eye == user.loc || flags & COMPONENT_ALLOW_EXAMINATE))
		user.examinate(src)

/*
	Ctrl + Right click
	Combat mode feature
	Drop item in hand at position.
*/
/atom/proc/CtrlRightClickOn(atom/A, params)
	if(isliving(src) && Adjacent(A)) //honestly only humans can do this given it's combat mode but if it's implemented for any other mobs...
		var/mob/living/L = src
		if(L.incapacitated())
			return
		var/obj/item/I = L.get_active_held_item()
		var/turf/T = get_turf(A)
		if(T)
			if(I) //drop item at cursor.
				if(T.density) //no, you can't use your funny blue cube or red cube to clip into the fucking wall.
					return
				for(var/atom/C in T.contents) //nor can you clip into a window or a door/false wall that's not open.
					if(C.opacity || (((C.flags_1 & PREVENT_CLICK_UNDER_1) > 0) != (istype(C,/obj/machinery/door) && !C.density))) //XOR operation within because doors always have PREVENT_CLICK_UNDER_1 flag enabled. Dumb, I know.
						return
				if(L.transferItemToLoc(I, T))
					var/list/click_params = params2list(params)
					//Center the icon where the user clicked. (shamelessly stole code from tables)
					if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
						return
					//Clamp it so that the icon never moves more than 16 pixels in either direction
					I.pixel_x = clamp(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
					I.pixel_y = clamp(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)
					return TRUE
			else if(isitem(A) && L.has_active_hand()) //if they have an open hand they'll rotate the item instead.
				var/obj/item/I2 = A
				if(!I2.anchored)
					var/matrix/ntransform = matrix(I2.transform)
					ntransform.Turn(15)
					animate(I2, transform = ntransform, time = 2)
					return TRUE
			else
				A.CtrlClick(src)



/*
	Ctrl click
	For most objects, pull
*/

/mob/proc/CtrlClickOn(atom/A)
	return A.CtrlClick(src)

/atom/proc/CtrlClick(mob/user)
	SEND_SIGNAL(src, COMSIG_CLICK_CTRL, user)
	var/mob/living/ML = user
	if(istype(ML))
		INVOKE_ASYNC(ML, /mob/living.verb/pulled, src)

/mob/living/carbon/human/CtrlClick(mob/user)
	if(ishuman(user) && Adjacent(user) && !user.incapacitated())
		if(!user.CheckActionCooldown())
			return FALSE
		var/mob/living/carbon/human/H = user
		H.dna.species.grab(H, src, H.mind.martial_art)
		H.DelayNextAction(CLICK_CD_MELEE)
		return TRUE
	else
		return ..()

/mob/proc/CtrlMiddleClickOn(atom/A)
	if(check_rights_for(client, R_ADMIN))
		client.toggle_tag_datum(A)
	else
		A.CtrlClick(src)
	return

/*
	Alt click
	Used as an alternate way to interact with things.
*/
/mob/proc/AltClickOn(atom/A)
	. = SEND_SIGNAL(src, COMSIG_MOB_ALTCLICKON, A)
	if(. & COMSIG_MOB_CANCEL_CLICKON)
		return
	A.AltClick(src)

/mob/living/carbon/AltClickOn(atom/A)
	if(!stat && mind && iscarbon(A) && A != src)
		var/datum/antagonist/changeling/C = mind.has_antag_datum(/datum/antagonist/changeling)
		if(C && C.chosen_sting)
			C.chosen_sting.try_to_sting(src,A)
			DelayNextAction(CLICK_CD_RANGE)
			return TRUE
	..()

/atom/proc/AltClick(mob/user)
	SEND_SIGNAL(src, COMSIG_CLICK_ALT, user)
	var/turf/T = get_turf(src)
	if(T && (isturf(loc) || isturf(src)) && user.TurfAdjacent(T))
		user.listed_turf = T
		user.client << output("[url_encode(json_encode(T.name))];", "statbrowser:create_listedturf")

/// Use this instead of [/mob/proc/AltClickOn] where you only want turf content listing without additional atom alt-click interaction
/atom/proc/AltClickNoInteract(mob/user, atom/A)
	var/turf/T = get_turf(A)
	if(T && user.TurfAdjacent(T))
		user.listed_turf = T
		user.client << output("[url_encode(json_encode(T.name))];", "statbrowser:create_listedturf")

/mob/proc/TurfAdjacent(turf/T)
	return T.Adjacent(src)

/*
	Control+Shift click
	Unused except for AI
*/
/mob/proc/CtrlShiftClickOn(atom/A)
	A.CtrlShiftClick(src)
	return

/mob/proc/ShiftMiddleClickOn(atom/A)
	src.pointed(A)
	return

/atom/proc/CtrlShiftClick(mob/user)
	SEND_SIGNAL(src, COMSIG_CLICK_CTRL_SHIFT, user)
	return

/*
	Misc helpers

	Laser Eyes: as the name implies, handles this since nothing else does currently
	face_atom: turns the mob towards what you clicked on
*/
/mob/proc/LaserEyes(atom/A, params)
	return

/mob/living/LaserEyes(atom/A, params)
	if(!CheckActionCooldown(CLICK_CD_RANGE))
		return
	DelayNextAction()

	var/obj/item/projectile/beam/LE = new /obj/item/projectile/beam(loc)
	LE.icon = 'icons/effects/genetics.dmi'
	LE.icon_state = "eyelasers"
	playsound(usr.loc, 'sound/weapons/taser2.ogg', 75, 1)

	LE.firer = src
	LE.def_zone = get_organ_target()
	LE.preparePixelProjectile(A, src, params)
	LE.fire()
	return TRUE

// Simple helper to face what you clicked on, in case it should be needed in more than one place
/mob/proc/face_atom(atom/A, ismousemovement = FALSE)
	if( buckled || stat != CONSCIOUS || !loc || !A || !A.x || !A.y )
		return
	var/atom/L = loc
	if(L.flags_1 & BLOCK_FACE_ATOM_1)
		return
	var/turf/T = get_turf(src)
	var/dx = A.x - T.x
	var/dy = A.y - T.y
	if(!dx && !dy) // Wall items are graphically shifted but on the floor
		if(A.pixel_y > 16)
			setDir(NORTH, ismousemovement)
		else if(A.pixel_y < -16)
			setDir(SOUTH, ismousemovement)
		else if(A.pixel_x > 16)
			setDir(EAST, ismousemovement)
		else if(A.pixel_x < -16)
			setDir(WEST, ismousemovement)
		return

	if(abs(dx) < abs(dy))
		if(dy > 0)
			setDir(NORTH, ismousemovement)
		else
			setDir(SOUTH, ismousemovement)
	else
		if(dx > 0)
			setDir(EAST, ismousemovement)
		else
			setDir(WEST, ismousemovement)

/* MouseWheelOn */

/mob/proc/MouseWheelOn(atom/A, delta_x, delta_y, params)
	return

/mob/dead/observer/MouseWheelOn(atom/A, delta_x, delta_y, params)
	var/list/modifier = params2list(params)
	if(modifier["shift"])
		var/view = 0
		if(delta_y > 0)
			view = -1
		else
			view = 1
		add_view_range(view)

/mob/proc/check_click_intercept(params,A)
	//Client level intercept
	if(client && client.click_intercept)
		if(call(client.click_intercept, "InterceptClickOn")(src, params, A))
			return TRUE

	//Mob level intercept
	if(click_intercept)
		if(call(click_intercept, "InterceptClickOn")(src, params, A))
			return TRUE

	return FALSE
