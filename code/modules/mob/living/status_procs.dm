// YEEHAW GAMERS STAMINA REWORK PROC GETS TO BE FIRST
// amount = strength
// updating = update mobility etc etc
// ignore_castun = same logic as Paralyze() in general
// override_duration = If this is set, does Paralyze() for this duration.
// override_stam = If this is set, does this amount of stamina damage.
/mob/living/proc/DefaultCombatKnockdown(amount, updating = TRUE, ignore_canknockdown = FALSE, override_hardstun, override_stamdmg)
	if(!iscarbon(src))
		return Paralyze(amount, updating, ignore_canknockdown)
	if(!ignore_canknockdown && !(status_flags & CANKNOCKDOWN))
		return FALSE
	if(istype(buckled, /obj/vehicle/ridden))
		buckled.unbuckle_mob(src)
	var/drop_items = amount > 80		//80 is cutoff for old item dropping behavior
	var/stamdmg = isnull(override_stamdmg)? (amount * 0.25) : override_stamdmg
	KnockToFloor(drop_items, TRUE, updating)
	adjustStaminaLoss(stamdmg)
	if(!isnull(override_hardstun))
		Paralyze(override_hardstun)

////////////////////////////// STUN ////////////////////////////////////

/mob/living/proc/IsStun() //If we're stunned
	return has_status_effect(STATUS_EFFECT_STUN)

/mob/living/proc/AmountStun() //How many deciseconds remain in our stun
	var/datum/status_effect/incapacitating/stun/S = IsStun()
	if(S)
		return S.duration - world.time
	return 0

/mob/living/proc/Stun(amount, updating = TRUE, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_STUN, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANSTUN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/stun/S = IsStun()
	if(S)
		S.duration = max(world.time + amount, S.duration)
	else if(amount > 0)
		S = apply_status_effect(STATUS_EFFECT_STUN, amount, updating)
	return S

/mob/living/proc/SetStun(amount, updating = TRUE, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_STUN, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANSTUN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	var/datum/status_effect/incapacitating/stun/S = IsStun()
	if(amount <= 0)
		if(S)
			qdel(S)
	else
		if(absorb_stun(amount, ignore_canstun))
			return
		if(S)
			S.duration = world.time + amount
		else
			S = apply_status_effect(STATUS_EFFECT_STUN, amount, updating)
	return S

/mob/living/proc/AdjustStun(amount, updating = TRUE, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_STUN, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANSTUN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/stun/S = IsStun()
	if(S)
		S.duration += amount
	else if(amount > 0)
		S = apply_status_effect(STATUS_EFFECT_STUN, amount, updating)
	return S

///////////////////////////////// KNOCKDOWN /////////////////////////////////////

/mob/living/proc/IsKnockdown() //If we're knocked down
	return has_status_effect(STATUS_EFFECT_KNOCKDOWN)

/mob/living/proc/AmountKnockdown() //How many deciseconds remain in our knockdown
	var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
	if(K)
		return K.duration - world.time
	return 0

/mob/living/proc/Knockdown(amount, updating = TRUE, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_KNOCKDOWN, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
	if(K)
		K.duration = max(world.time + amount, K.duration)
	else if(amount > 0)
		K = apply_status_effect(STATUS_EFFECT_KNOCKDOWN, amount, updating)
	return K

/mob/living/proc/SetKnockdown(amount, updating = TRUE, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_KNOCKDOWN, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
	if(amount <= 0)
		if(K)
			qdel(K)
	else
		if(absorb_stun(amount, ignore_canstun))
			return
		if(K)
			K.duration = world.time + amount
		else
			K = apply_status_effect(STATUS_EFFECT_KNOCKDOWN, amount, updating)
	return K

/mob/living/proc/AdjustKnockdown(amount, updating = TRUE, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_KNOCKDOWN, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
	if(K)
		K.duration += amount
	else if(amount > 0)
		K = apply_status_effect(STATUS_EFFECT_KNOCKDOWN, amount, updating)
	return K

///////////////////////////////// IMMOBILIZED ////////////////////////////////////
/mob/living/proc/IsImmobilized() //If we're immobilized
	return has_status_effect(STATUS_EFFECT_IMMOBILIZED)

/mob/living/proc/AmountImmobilized() //How many deciseconds remain in our Immobilized status effect
	var/datum/status_effect/incapacitating/immobilized/I = IsImmobilized()
	if(I)
		return I.duration - world.time
	return 0

/mob/living/proc/Immobilize(amount, updating = TRUE, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_IMMOBILIZE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/immobilized/I = IsImmobilized()
	if(I)
		I.duration = max(world.time + amount, I.duration)
	else if(amount > 0)
		I = apply_status_effect(STATUS_EFFECT_IMMOBILIZED, amount, updating)
	return I

/mob/living/proc/SetImmobilized(amount, updating = TRUE, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_IMMOBILIZE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	var/datum/status_effect/incapacitating/immobilized/I = IsImmobilized()
	if(amount <= 0)
		if(I)
			qdel(I)
	else
		if(absorb_stun(amount, ignore_canstun))
			return
		if(I)
			I.duration = world.time + amount
		else
			I = apply_status_effect(STATUS_EFFECT_IMMOBILIZED, amount, updating)
	return I

/mob/living/proc/AdjustImmobilized(amount, updating = TRUE, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_IMMOBILIZE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/immobilized/I = IsImmobilized()
	if(I)
		I.duration += amount
	else if(amount > 0)
		I = apply_status_effect(STATUS_EFFECT_IMMOBILIZED, amount, updating)
	return I

///////////////////////////////// PARALYZED //////////////////////////////////
/mob/living/proc/IsParalyzed() //If we're immobilized
	return has_status_effect(STATUS_EFFECT_PARALYZED)

/mob/living/proc/AmountParalyzed() //How many deciseconds remain in our Paralyzed status effect
	var/datum/status_effect/incapacitating/paralyzed/P = IsParalyzed(FALSE)
	if(P)
		return P.duration - world.time
	return 0

/mob/living/proc/Paralyze(amount, updating = TRUE, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_PARALYZE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/paralyzed/P = IsParalyzed(FALSE)
	if(P)
		P.duration = max(world.time + amount, P.duration)
	else if(amount > 0)
		P = apply_status_effect(STATUS_EFFECT_PARALYZED, amount, updating)
	return P

/mob/living/proc/SetParalyzed(amount, updating = TRUE, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_PARALYZE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	var/datum/status_effect/incapacitating/paralyzed/P = IsParalyzed(FALSE)
	if(amount <= 0)
		if(P)
			qdel(P)
	else
		if(absorb_stun(amount, ignore_canstun))
			return
		if(P)
			P.duration = world.time + amount
		else
			P = apply_status_effect(STATUS_EFFECT_PARALYZED, amount, updating)
	return P

/mob/living/proc/AdjustParalyzed(amount, updating = TRUE, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_PARALYZE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/paralyzed/P = IsParalyzed(FALSE)
	if(P)
		P.duration += amount
	else if(amount > 0)
		P = apply_status_effect(STATUS_EFFECT_PARALYZED, amount, updating)
	return P

///////////////////////////////// DAZED ////////////////////////////////////
/mob/living/proc/IsDazed() //If we're Dazed
	return has_status_effect(STATUS_EFFECT_DAZED)

/mob/living/proc/AmountDazed() //How many deciseconds remain in our Dazed status effect
	var/datum/status_effect/incapacitating/dazed/I = IsDazed()
	if(I)
		return I.duration - world.time
	return 0

/mob/living/proc/Daze(amount, updating = TRUE, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_DAZE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/dazed/I = IsDazed()
	if(I)
		I.duration = max(world.time + amount, I.duration)
	else if(amount > 0)
		I = apply_status_effect(STATUS_EFFECT_DAZED, amount, updating)
	return I

/mob/living/proc/SetDazed(amount, updating = TRUE, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_DAZE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	var/datum/status_effect/incapacitating/dazed/I = IsDazed()
	if(amount <= 0)
		if(I)
			qdel(I)
	else
		if(absorb_stun(amount, ignore_canstun))
			return
		if(I)
			I.duration = world.time + amount
		else
			I = apply_status_effect(STATUS_EFFECT_DAZED, amount, updating)
	return I

/mob/living/proc/AdjustDazed(amount, updating = TRUE, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_DAZE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/dazed/I = IsDazed()
	if(I)
		I.duration += amount
	else if(amount > 0)
		I = apply_status_effect(STATUS_EFFECT_DAZED, amount, updating)
	return I

///////////////////////////////// STAGGERED ////////////////////////////////////
/mob/living/proc/IsStaggered() //If we're Staggered
	return has_status_effect(STATUS_EFFECT_STAGGERED)

/mob/living/proc/AmountStaggered() //How many deciseconds remain in our Staggered status effect
	var/datum/status_effect/staggered/I = IsStaggered()
	if(I)
		return I.duration - world.time
	return 0

/mob/living/proc/Stagger(amount, updating = TRUE, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_STAGGER, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/staggered/I = IsStaggered()
	if(I)
		I.duration = max(world.time + amount, I.duration)
	else if(amount > 0)
		I = apply_status_effect(STATUS_EFFECT_STAGGERED, amount, updating)
	return I

/mob/living/proc/SetStaggered(amount, updating = TRUE, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_STAGGER, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	var/datum/status_effect/staggered/I = IsStaggered()
	if(amount <= 0)
		if(I)
			qdel(I)
	else
		if(absorb_stun(amount, ignore_canstun))
			return
		if(I)
			I.duration = world.time + amount
		else
			I = apply_status_effect(STATUS_EFFECT_STAGGERED, amount, updating)
	return I

/mob/living/proc/AdjustStaggered(amount, updating = TRUE, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_STAGGER, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/staggered/I = IsStaggered()
	if(I)
		I.duration += amount
	else if(amount > 0)
		I = apply_status_effect(STATUS_EFFECT_STAGGERED, amount, updating)
	return I

//Blanket
/mob/living/proc/AllImmobility(amount, updating, ignore_canstun = FALSE)
	Paralyze(amount, FALSE, ignore_canstun)
	Knockdown(amount, FALSE, ignore_canstun)
	Stun(amount, FALSE, ignore_canstun)
	Immobilize(amount, FALSE, ignore_canstun)
	Daze(amount, FALSE, ignore_canstun)
	Stagger(amount, FALSE, ignore_canstun)
	if(updating)
		update_mobility()

/mob/living/proc/SetAllImmobility(amount, updating, ignore_canstun = FALSE)
	SetParalyzed(amount, FALSE, ignore_canstun)
	SetKnockdown(amount, FALSE, ignore_canstun)
	SetStun(amount, FALSE, ignore_canstun)
	SetImmobilized(amount, FALSE, ignore_canstun)
	SetDazed(amount, FALSE, ignore_canstun)
	SetStaggered(amount, FALSE, ignore_canstun)
	if(updating)
		update_mobility()

/mob/living/proc/AdjustAllImmobility(amount, updating, ignore_canstun = FALSE)
	AdjustParalyzed(amount, FALSE, ignore_canstun)
	AdjustKnockdown(amount, FALSE, ignore_canstun)
	AdjustStun(amount, FALSE, ignore_canstun)
	AdjustImmobilized(amount, FALSE, ignore_canstun)
	AdjustDazed(amount, FALSE, ignore_canstun)
	AdjustStaggered(amount, FALSE, ignore_canstun)
	if(updating)
		update_mobility()

/// Makes sure all 5 of the non-knockout immobilizing status effects are lower or equal to amount.
/mob/living/proc/HealAllImmobilityUpTo(amount, updating, ignore_canstun = FALSE)
	if(AmountStun() > amount)
		SetStun(amount, FALSE, ignore_canstun)
	if(AmountKnockdown() > amount)
		SetKnockdown(amount, FALSE, ignore_canstun)
	if(AmountParalyzed() > amount)
		SetParalyzed(amount, FALSE, ignore_canstun)
	if(AmountImmobilized() > amount)
		SetImmobilized(amount, FALSE, ignore_canstun)
	if(AmountDazed() > amount)
		SetImmobilized(amount, FALSE, ignore_canstun)
	if(AmountStaggered() > amount)
		SetStaggered(amount, FALSE, ignore_canstun)
	if(updating)
		update_mobility()

/mob/living/proc/HighestImmobilityAmount()
	return max(AmountStun(), AmountKnockdown(), AmountParalyzed(), AmountImmobilized(), AmountDazed(), AmountStaggered())

//////////////////UNCONSCIOUS
/mob/living/proc/IsUnconscious() //If we're unconscious
	return has_status_effect(STATUS_EFFECT_UNCONSCIOUS)

/mob/living/proc/AmountUnconscious() //How many deciseconds remain in our unconsciousness
	var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
	if(U)
		return U.duration - world.time
	return 0

/mob/living/proc/Unconscious(amount, updating = TRUE, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_UNCONSCIOUS, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANUNCONSCIOUS) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE))  || ignore_canstun)
		var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
		if(U)
			U.duration = max(world.time + amount, U.duration)
		else if(amount > 0)
			U = apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, amount, updating)
		return U

/mob/living/proc/SetUnconscious(amount, updating = TRUE, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_UNCONSCIOUS, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANUNCONSCIOUS) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
		if(amount <= 0)
			if(U)
				qdel(U)
		else if(U)
			U.duration = world.time + amount
		else
			U = apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, amount, updating)
		return U

/mob/living/proc/AdjustUnconscious(amount, updating = TRUE, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_UNCONSCIOUS, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANUNCONSCIOUS) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
		if(U)
			U.duration += amount
		else if(amount > 0)
			U = apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, amount, updating)
		return U

/////////////////////////////////// SLEEPING ////////////////////////////////////

/mob/living/proc/IsSleeping() //If we're asleep
	return has_status_effect(STATUS_EFFECT_SLEEPING)

/mob/living/proc/AmountSleeping() //How many deciseconds remain in our sleep
	var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
	if(S)
		return S.duration - world.time
	return 0

/mob/living/proc/Sleeping(amount, updating = TRUE, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_SLEEP, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if((!HAS_TRAIT(src, TRAIT_SLEEPIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
		if(S)
			S.duration = max(world.time + amount, S.duration)
		else if(amount > 0)
			S = apply_status_effect(STATUS_EFFECT_SLEEPING, amount, updating)
		return S

/mob/living/proc/SetSleeping(amount, updating = TRUE, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_SLEEP, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if((!HAS_TRAIT(src, TRAIT_SLEEPIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
		if(amount <= 0)
			if(S)
				qdel(S)
		else if(S)
			S.duration = world.time + amount
		else
			S = apply_status_effect(STATUS_EFFECT_SLEEPING, amount, updating)
		return S

/mob/living/proc/AdjustSleeping(amount, updating = TRUE, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_SLEEP, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if((!HAS_TRAIT(src, TRAIT_SLEEPIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
		if(S)
			S.duration += amount
		else if(amount > 0)
			S = apply_status_effect(STATUS_EFFECT_SLEEPING, amount, updating)
		return S

///////////////////////////////// FROZEN /////////////////////////////////////

/mob/living/proc/IsFrozen()
	return has_status_effect(/datum/status_effect/freon)

///////////////////////////////////// STUN ABSORPTION /////////////////////////////////////

/mob/living/proc/add_stun_absorption(key, duration, priority, message, self_message, examine_message)
//adds a stun absorption with a key, a duration in deciseconds, its priority, and the messages it makes when you're stun/examined, if any
	if(!islist(stun_absorption))
		stun_absorption = list()
	if(stun_absorption[key])
		stun_absorption[key]["end_time"] = world.time + duration
		stun_absorption[key]["priority"] = priority
		stun_absorption[key]["stuns_absorbed"] = 0
	else
		stun_absorption[key] = list("end_time" = world.time + duration, "priority" = priority, "stuns_absorbed" = 0, \
		"visible_message" = message, "self_message" = self_message, "examine_message" = examine_message)

/mob/living/proc/absorb_stun(amount, ignoring_flag_presence)
	if(amount < 0 || stat || ignoring_flag_presence || !islist(stun_absorption))
		return FALSE
	if(!amount)
		amount = 0
	var/priority_absorb_key
	var/highest_priority
	for(var/i in stun_absorption)
		if(stun_absorption[i]["end_time"] > world.time && (!priority_absorb_key || stun_absorption[i]["priority"] > highest_priority))
			priority_absorb_key = stun_absorption[i]
			highest_priority = priority_absorb_key["priority"]
	if(priority_absorb_key)
		if(amount) //don't spam up the chat for continuous stuns
			if(priority_absorb_key["visible_message"] || priority_absorb_key["self_message"])
				if(priority_absorb_key["visible_message"] && priority_absorb_key["self_message"])
					visible_message("<span class='warning'>[src][priority_absorb_key["visible_message"]]</span>", "<span class='boldwarning'>[priority_absorb_key["self_message"]]</span>")
				else if(priority_absorb_key["visible_message"])
					visible_message("<span class='warning'>[src][priority_absorb_key["visible_message"]]</span>")
				else if(priority_absorb_key["self_message"])
					to_chat(src, "<span class='boldwarning'>[priority_absorb_key["self_message"]]</span>")
			priority_absorb_key["stuns_absorbed"] += amount
		return TRUE

/////////////////////////////////// DISABILITIES ////////////////////////////////////
/mob/living/proc/add_quirk(quirktype, spawn_effects) //separate proc due to the way these ones are handled
	if(HAS_TRAIT(src, quirktype))
		return
	var/datum/quirk/T = quirktype
	var/qname = initial(T.name)
	if(!SSquirks || !SSquirks.quirks[qname])
		return
	new quirktype (src, spawn_effects)
	return TRUE

/mob/living/proc/remove_quirk(quirktype)
	for(var/datum/quirk/Q in roundstart_quirks)
		if(Q.type == quirktype)
			qdel(Q)
			return TRUE
	return FALSE

/mob/living/proc/has_quirk(quirktype)
	for(var/datum/quirk/Q in roundstart_quirks)
		if(Q.type == quirktype)
			return TRUE
	return FALSE

/////////////////////////////////// TRAIT PROCS ////////////////////////////////////

/mob/living/proc/cure_blind(source)
	REMOVE_TRAIT(src, TRAIT_BLIND, source)
	if(!HAS_TRAIT(src, TRAIT_BLIND))
		update_blindness()

/mob/living/proc/become_blind(source)
	if(!HAS_TRAIT(src, TRAIT_BLIND)) // not blind already, add trait then overlay
		ADD_TRAIT(src, TRAIT_BLIND, source)
		update_blindness()
	else
		ADD_TRAIT(src, TRAIT_BLIND, source)

/mob/living/proc/cure_nearsighted(source)
	REMOVE_TRAIT(src, TRAIT_NEARSIGHT, source)
	if(!HAS_TRAIT(src, TRAIT_NEARSIGHT))
		clear_fullscreen("nearsighted")

/mob/living/proc/become_nearsighted(source)
	if(!HAS_TRAIT(src, TRAIT_NEARSIGHT))
		overlay_fullscreen("nearsighted", /obj/screen/fullscreen/impaired, 1)
	ADD_TRAIT(src, TRAIT_NEARSIGHT, source)

/mob/living/proc/cure_husk(source)
	REMOVE_TRAIT(src, TRAIT_HUSK, source)
	if(!HAS_TRAIT(src, TRAIT_HUSK))
		REMOVE_TRAIT(src, TRAIT_DISFIGURED, "husk")
		update_body()
		return TRUE

/mob/living/proc/become_husk(source)
	if(!HAS_TRAIT(src, TRAIT_HUSK))
		ADD_TRAIT(src, TRAIT_HUSK, source)
		ADD_TRAIT(src, TRAIT_DISFIGURED, "husk")
		update_body()
	else
		ADD_TRAIT(src, TRAIT_HUSK, source)

/mob/living/proc/cure_fakedeath(source)
	REMOVE_TRAIT(src, TRAIT_FAKEDEATH, source)
	REMOVE_TRAIT(src, TRAIT_DEATHCOMA, source)
	if(stat != DEAD)
		tod = null
	update_stat()

/mob/living/proc/fakedeath(source, silent = FALSE)
	if(stat == DEAD)
		return
	if(!silent)
		emote("deathgasp")
	ADD_TRAIT(src, TRAIT_FAKEDEATH, source)
	ADD_TRAIT(src, TRAIT_DEATHCOMA, source)
	tod = STATION_TIME_TIMESTAMP("hh:mm:ss", world.time)
	update_stat()

///Unignores all slowdowns that lack the IGNORE_NOSLOW flag.
/mob/living/proc/unignore_slowdown(source)
	REMOVE_TRAIT(src, TRAIT_IGNORESLOWDOWN, source)
	update_movespeed()

///Ignores all slowdowns that lack the IGNORE_NOSLOW flag.
/mob/living/proc/ignore_slowdown(source)
	ADD_TRAIT(src, TRAIT_IGNORESLOWDOWN, source)
	update_movespeed()

///Ignores specific slowdowns. Accepts a list of slowdowns.
/mob/living/proc/add_movespeed_mod_immunities(source, slowdown_type, update = TRUE)
	if(islist(slowdown_type))
		for(var/listed_type in slowdown_type)
			if(ispath(listed_type))
				listed_type = "[listed_type]" //Path2String
			LAZYADDASSOC(movespeed_mod_immunities, listed_type, source)
	else
		if(ispath(slowdown_type))
			slowdown_type = "[slowdown_type]" //Path2String
		LAZYADDASSOC(movespeed_mod_immunities, slowdown_type, source)
	if(update)
		update_movespeed()

///Unignores specific slowdowns. Accepts a list of slowdowns.
/mob/living/proc/remove_movespeed_mod_immunities(source, slowdown_type, update = TRUE)
	if(islist(slowdown_type))
		for(var/listed_type in slowdown_type)
			if(ispath(listed_type))
				listed_type = "[listed_type]" //Path2String
			LAZYREMOVEASSOC(movespeed_mod_immunities, listed_type, source)
	else
		if(ispath(slowdown_type))
			slowdown_type = "[slowdown_type]" //Path2String
		LAZYREMOVEASSOC(movespeed_mod_immunities, slowdown_type, source)
	if(update)
		update_movespeed()
