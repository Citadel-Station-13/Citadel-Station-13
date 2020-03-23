/// IN THE FUTURE, WE WILL PROBABLY REFACTOR TO LESSEN THE NEED FOR UPDATE_MOBILITY, BUT FOR NOW.. WE CAN START DOING THIS.
/// FOR BLOCKING MOVEMENT, USE TRAIT_MOBILITY_NOMOVE AS MUCH AS POSSIBLE. IT WILL MAKE REFACTORS IN THE FUTURE EASIER.
/mob/living/ComponentInitialize()
	. = ..()
	RegisterSignal(src, SIGNAL_TRAIT(TRAIT_MOBILITY_NOMOVE), .proc/update_mobility)
	RegisterSignal(src, SIGNAL_TRAIT(TRAIT_MOBILITY_NOPICKUP), .proc/update_mobility)
	RegisterSignal(src, SIGNAL_TRAIT(TRAIT_MOBILITY_NOUSE), .proc/update_mobility)

//Stuff like mobility flag updates, resting updates, etc.

//Force-set resting variable, without needing to resist/etc.
/mob/living/proc/set_resting(new_resting, silent = FALSE, updating = TRUE)
	if(new_resting != resting)
		resting = new_resting
		if(!silent)
			to_chat(src, "<span class='notice'>You are now [resting? "resting" : "getting up"].</span>")
		update_resting(updating)

/mob/living/proc/update_resting(update_mobility = TRUE)
	if(update_mobility)
		update_mobility()

//Force mob to rest, does NOT do stamina damage.
//It's really not recommended to use this proc to give feedback, hence why silent is defaulting to true.
/mob/living/proc/KnockToFloor(disarm_items = FALSE, silent = TRUE, updating = TRUE)
	if(!silent && !resting)
		to_chat(src, "<span class='warning'>You are knocked to the floor!</span>")
	set_resting(TRUE, TRUE, updating)
	if(disarm_items)
		drop_all_held_items()

/mob/living/proc/lay_down()
	set name = "Rest"
	set category = "IC"
	if(client?.prefs?.autostand)
		TOGGLE_BITFIELD(combat_flags, COMBAT_FLAG_INTENTIONALLY_RESTING)
		to_chat(src, "<span class='notice'>You are now attempting to [(combat_flags & COMBAT_FLAG_INTENTIONALLY_RESTING) ? "[!resting ? "lay down and ": ""]stay down" : "[resting ? "get up and ": ""]stay up"].</span>")
		if((combat_flags & COMBAT_FLAG_INTENTIONALLY_RESTING) && !resting)
			set_resting(TRUE, FALSE)
		else
			resist_a_rest()
	else
		if(!resting)
			set_resting(TRUE, FALSE)
			to_chat(src, "<span class='notice'>You are now laying down.</span>")
		else
			resist_a_rest()

/mob/living/proc/resist_a_rest(automatic = FALSE, ignoretimer = FALSE) //Lets mobs resist out of resting. Major QOL change with combat reworks.
	set_resting(FALSE, TRUE)
	return TRUE

//Updates canmove, lying and icons. Could perhaps do with a rename but I can't think of anything to describe it.
//Robots, animals and brains have their own version so don't worry about them
/mob/living/proc/update_mobility()
	var/stat_softcrit = stat == SOFT_CRIT
	var/stat_conscious = (stat == CONSCIOUS) || stat_softcrit

	var/conscious = !IsUnconscious() && stat_conscious && !HAS_TRAIT(src, TRAIT_DEATHCOMA)

	var/has_arms = get_num_arms()
	var/has_legs = get_num_legs()
	var/ignore_legs = get_leg_ignore()
	var/stun = IsStun()
	var/paralyze = IsParalyzed()
	var/knockdown = IsKnockdown()
	var/daze = IsDazed()
	var/immobilize = IsImmobilized()

	var/chokehold = pulledby && pulledby.grab_state >= GRAB_NECK
	var/restrained = restrained()
	var/pinned = resting && pulledby && pulledby.grab_state >= GRAB_AGGRESSIVE // Cit change - adds pinning for aggressive-grabbing people on the ground
	var/has_limbs = has_arms || ignore_legs || has_legs
	var/canmove = !immobilize && !stun && conscious && !paralyze && (!stat_softcrit || !pulledby) && !chokehold && !IsFrozen() && has_limbs && !pinned && !(combat_flags & COMBAT_FLAG_HARD_STAMCRIT)
	var/canresist = !stun && conscious && !stat_softcrit && !paralyze && has_limbs && !(combat_flags & COMBAT_FLAG_HARD_STAMCRIT)

	if(canmove)
		mobility_flags |= MOBILITY_MOVE
	else
		mobility_flags &= ~MOBILITY_MOVE

	if(canresist)
		mobility_flags |= MOBILITY_RESIST
	else
		mobility_flags &= ~MOBILITY_RESIST

	var/canstand_involuntary = conscious && !stat_softcrit && !knockdown && !chokehold && !paralyze && (ignore_legs || has_legs) && !(buckled && buckled.buckle_lying) && !(combat_flags & COMBAT_FLAG_HARD_STAMCRIT)
	var/canstand = canstand_involuntary && !resting

	var/should_be_lying = !canstand
	if(buckled)
		if(buckled.buckle_lying != -1)
			should_be_lying = buckled.buckle_lying

	if(should_be_lying)
		mobility_flags &= ~MOBILITY_STAND
		if(!lying) //force them on the ground
			lying = pick(90, 270)
			if(has_gravity() && !buckled)
				playsound(src, "bodyfall", 20, 1)
	else
		mobility_flags |= MOBILITY_STAND
		lying = 0

	if(should_be_lying || restrained || incapacitated())
		mobility_flags &= ~(MOBILITY_UI|MOBILITY_PULL)
	else
		mobility_flags |= MOBILITY_UI|MOBILITY_PULL

	var/canitem_general = !paralyze && !stun && conscious && !(stat_softcrit) && !chokehold && !restrained && has_arms && !(combat_flags & COMBAT_FLAG_HARD_STAMCRIT)
	if(canitem_general)
		mobility_flags |= (MOBILITY_USE | MOBILITY_PICKUP | MOBILITY_STORAGE | MOBILITY_HOLD)
	else
		mobility_flags &= ~(MOBILITY_USE | MOBILITY_PICKUP | MOBILITY_STORAGE | MOBILITY_HOLD)

	if(HAS_TRAIT(src, TRAIT_MOBILITY_NOMOVE))
		DISABLE_BITFIELD(mobility_flags, MOBILITY_MOVE)
	if(HAS_TRAIT(src, TRAIT_MOBILITY_NOPICKUP))
		DISABLE_BITFIELD(mobility_flags, MOBILITY_PICKUP)
	if(HAS_TRAIT(src, TRAIT_MOBILITY_NOUSE))
		DISABLE_BITFIELD(mobility_flags, MOBILITY_USE)

	if(daze)
		DISABLE_BITFIELD(mobility_flags, MOBILITY_USE)

	//Handle update-effects.
	if(!CHECK_MOBILITY(src, MOBILITY_HOLD))
		drop_all_held_items()
	if(!CHECK_MOBILITY(src, MOBILITY_PULL))
		if(pulling)
			stop_pulling()
	if(!CHECK_MOBILITY(src, MOBILITY_UI))
		unset_machine()

	if(isliving(pulledby))
		var/mob/living/L = pulledby
		L.update_pull_movespeed()

	//Handle lying down, voluntary or involuntary
	density = !lying
	if(lying)
		set_resting(TRUE, TRUE, FALSE)
		if(layer == initial(layer)) //to avoid special cases like hiding larvas.
			layer = LYING_MOB_LAYER //so mob lying always appear behind standing mobs
	else
		if(layer == LYING_MOB_LAYER)
			layer = initial(layer)
	update_transform()
	lying_prev = lying

	//Handle citadel autoresist
	if(CHECK_MOBILITY(src, MOBILITY_MOVE) && !(combat_flags & COMBAT_FLAG_INTENTIONALLY_RESTING) && canstand_involuntary && iscarbon(src) && client?.prefs?.autostand)//CIT CHANGE - adds autostanding as a preference
		addtimer(CALLBACK(src, .proc/resist_a_rest, TRUE), 0) //CIT CHANGE - ditto

	// Movespeed mods based on arms/legs quantity
	if(!get_leg_ignore())
		var/limbless_slowdown = 0
		// These checks for <2 should be swapped out for something else if we ever end up with a species with more than 2
		if(has_legs < 2)
			limbless_slowdown += 6 - (has_legs * 3)
			if(!has_legs && has_arms < 2)
				limbless_slowdown += 6 - (has_arms * 3)
		if(limbless_slowdown)
			add_movespeed_modifier(MOVESPEED_ID_LIVING_LIMBLESS, update=TRUE, priority=100, override=TRUE, multiplicative_slowdown=limbless_slowdown, movetypes=GROUND)
		else
			remove_movespeed_modifier(MOVESPEED_ID_LIVING_LIMBLESS, update=TRUE)

	return mobility_flags
