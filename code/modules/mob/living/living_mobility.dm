//Stuff like mobility flag updates, resting updates, etc.

//Force-set resting variable, without needing to resist/etc.
/mob/living/proc/set_resting(new_resting, silent = FALSE, updating = TRUE)
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
	if(!silent)
		to_chat(src, "<span class='warning'>You are knocked to the floor!</span>")
	set_resting(TRUE, TRUE, updating)
	if(disarm_items)
		drop_all_held_items()






/mob/living/proc/lay_down()
	set name = "Rest"
	set category = "IC"

	if(client && client.prefs && client.prefs.autostand)
		intentionalresting = !intentionalresting
		to_chat(src, "<span class='notice'>You are now attempting to [intentionalresting ? "[!resting ? "lay down and ": ""]stay down" : "[resting ? "get up and ": ""]stay up"].</span>")
		if(intentionalresting && !resting)
			resting = TRUE
			update_canmove()
		else
			resist_a_rest()
	else
		if(!resting)
			resting = TRUE
			to_chat(src, "<span class='notice'>You are now laying down.</span>")
			update_canmove()
		else
			resist_a_rest()

/mob/living/proc/resist_a_rest(automatic = FALSE, ignoretimer = FALSE) //Lets mobs resist out of resting. Major QOL change with combat reworks.
	if(!resting || stat || attemptingstandup)
		return FALSE
	if(ignoretimer)
		resting = FALSE
		update_canmove()
		return TRUE
	else
		var/totaldelay = 3 //A little bit less than half of a second as a baseline for getting up from a rest
		if(getStaminaLoss() >= STAMINA_SOFTCRIT)
			to_chat(src, "<span class='warning'>You're too exhausted to get up!")
			return FALSE
		attemptingstandup = TRUE
		var/health_deficiency = max((maxHealth - (health - getStaminaLoss()))*0.5, 0)
		if(!has_gravity())
			health_deficiency = health_deficiency*0.2
		totaldelay += health_deficiency
		var/standupwarning = "[src] and everyone around them should probably yell at the dev team"
		switch(health_deficiency)
			if(-INFINITY to 10)
				standupwarning = "[src] stands right up!"
			if(10 to 35)
				standupwarning = "[src] tries to stand up."
			if(35 to 60)
				standupwarning = "[src] slowly pushes [p_them()]self upright."
			if(60 to 80)
				standupwarning = "[src] weakly attempts to stand up."
			if(80 to INFINITY)
				standupwarning = "[src] struggles to stand up."
		var/usernotice = automatic ? "<span class='notice'>You are now getting up. (Auto)</span>" : "<span class='notice'>You are now getting up.</span>"
		visible_message("<span class='notice'>[standupwarning]</span>", usernotice, vision_distance = 5)
		if(do_after(src, totaldelay, target = src))
			resting = FALSE
			attemptingstandup = FALSE
			update_canmove()
			return TRUE
		else
			visible_message("<span class='notice'>[src] falls right back down.</span>", "<span class='notice'>You fall right back down.</span>")
			attemptingstandup = FALSE
			if(has_gravity())
				playsound(src, "bodyfall", 20, 1)
			return FALSE


/*
//Updates canmove, lying and icons. Could perhaps do with a rename but I can't think of anything to describe it.
//Robots, animals and brains have their own version so don't worry about them
/mob/living/proc/update_mobility()
	var/stat_softcrit = stat == SOFT_CRIT
	var/stat_conscious = (stat == CONSCIOUS) || stat_softcrit
	var/conscious = !IsUnconscious() && stat_conscious && !HAS_TRAIT(src, TRAIT_DEATHCOMA)
	var/chokehold = pulledby && pulledby.grab_state >= GRAB_NECK
	var/restrained = restrained()
	var/has_legs = get_num_legs()
	var/has_arms = get_num_arms()
	var/paralyzed = IsParalyzed()
	var/stun = IsStun()
	var/knockdown = IsKnockdown()
	var/ignore_legs = get_leg_ignore()
	var/canmove = !IsImmobilized() && !stun && conscious && !paralyzed && !buckled && (!stat_softcrit || !pulledby) && !chokehold && !IsFrozen() && !IS_IN_STASIS(src) && (has_arms || ignore_legs || has_legs)
	if(canmove)
		mobility_flags |= MOBILITY_MOVE
	else
		mobility_flags &= ~MOBILITY_MOVE
	var/canstand_involuntary = conscious && !stat_softcrit && !knockdown && !chokehold && !paralyzed && (ignore_legs || has_legs) && !(buckled && buckled.buckle_lying)
	var/canstand = canstand_involuntary && !resting

	var/should_be_lying = !canstand
	if(buckled)
		if(buckled.buckle_lying != -1)
			should_be_lying = buckled.buckle_lying

	if(should_be_lying)
		mobility_flags &= ~MOBILITY_STAND
		if(buckled)
			if(buckled.buckle_lying != -1)
				lying = buckled.buckle_lying
		if(!lying) //force them on the ground
			lying = pick(90, 270)
	else
		mobility_flags |= MOBILITY_STAND
		lying = 0

	if(should_be_lying || restrained || incapacitated())
		mobility_flags &= ~(MOBILITY_UI|MOBILITY_PULL)
	else
		mobility_flags |= MOBILITY_UI|MOBILITY_PULL



	var/canitem = !paralyzed && !stun && conscious && !chokehold && !restrained && has_arms
	if(canitem)
		mobility_flags |= (MOBILITY_USE | MOBILITY_PICKUP | MOBILITY_STORAGE)
	else
		mobility_flags &= ~(MOBILITY_USE | MOBILITY_PICKUP | MOBILITY_STORAGE)
	if(!(mobility_flags & MOBILITY_USE))
		drop_all_held_items()
	if(!(mobility_flags & MOBILITY_PULL))
		if(pulling)
			stop_pulling()
	if(!(mobility_flags & MOBILITY_UI))
		unset_machine()
	density = !lying
	if(lying)
		if(!lying_prev)
			fall(!canstand_involuntary)
		if(layer == initial(layer)) //to avoid special cases like hiding larvas.
			layer = LYING_MOB_LAYER //so mob lying always appear behind standing mobs
	else
		if(layer == LYING_MOB_LAYER)
			layer = initial(layer)
	update_transform()
	lying_prev = lying

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
*/

//Updates canmove, lying and icons. Could perhaps do with a rename but I can't think of anything to describe it.
//Robots, animals and brains have their own version so don't worry about them
/mob/living/proc/update_canmove()
/*
	var/ko = IsKnockdown() || IsUnconscious() || (stat && (stat != SOFT_CRIT || pulledby)) || (HAS_TRAIT(src, TRAIT_DEATHCOMA))
	var/move_and_fall = stat == SOFT_CRIT && !pulledby
	var/chokehold = pulledby && pulledby.grab_state >= GRAB_NECK
	var/buckle_lying = !(buckled && !buckled.buckle_lying)
	var/has_legs = get_num_legs()
	var/has_arms = get_num_arms()
	var/ignore_legs = get_leg_ignore()
	var/pinned = resting && pulledby && pulledby.grab_state >= GRAB_AGGRESSIVE // Cit change - adds pinning for aggressive-grabbing people on the ground
	if(ko || move_and_fall || IsStun() || chokehold) // Cit change - makes resting not force you to drop everything
		drop_all_held_items()
		unset_machine()
		if(pulling)
			stop_pulling()
	else if(resting) //CIT CHANGE - makes resting make you stop pulling and interacting with machines
		unset_machine() //CIT CHANGE - Ditto!
		if(pulling) //CIT CHANGE - Ditto.
			stop_pulling() //CIT CHANGE - Ditto...
	else if(has_legs || ignore_legs)
		lying = 0
		if (pulledby)
			var/mob/living/L = pulledby
			L.update_pull_movespeed()
	if(buckled)
		lying = 90*buckle_lying
	else if(!lying)
		if(resting)
			lying = pick(90, 270) // Cit change - makes resting not force you to drop your held items
			if(has_gravity()) // Cit change - Ditto
				playsound(src, "bodyfall", 50, 1) // Cit change - Ditto!
		else if(ko || move_and_fall || (!has_legs && !ignore_legs) || chokehold)
			fall(forced = 1)
	canmove = !(ko || recoveringstam || pinned || IsStun() || IsFrozen() || chokehold || buckled || (!has_legs && !ignore_legs && !has_arms)) //Cit change - makes it plausible to move while resting, adds pinning and stamina crit
	density = !lying
	if(lying)
		if(layer == initial(layer)) //to avoid special cases like hiding larvas.
			layer = LYING_MOB_LAYER //so mob lying always appear behind standing mobs
	else
		if(layer == LYING_MOB_LAYER)
			layer = initial(layer)
	update_transform()
	if(!lying && lying_prev)
		if(client)
			client.move_delay = world.time + movement_delay()
	lying_prev = lying
	if(canmove && !intentionalresting && iscarbon(src) && client && client.prefs && client.prefs.autostand)//CIT CHANGE - adds autostanding as a preference
		addtimer(CALLBACK(src, .proc/resist_a_rest, TRUE), 0) //CIT CHANGE - ditto
	return canmove
*/
