/**
  * CLICKDELAY HANDLING SYSTEM
  * How this works is mobs can never do actions until their next_action is at or below world.time, but things can specify extra cooldown
  * to check for either from the time of last_action or from the end of next_action.
  *
  * Clickdelay should always be checked via [CheckActionCooldown()], never manually!
  */

/mob
	// CLICKDELAY AND RELATED
	// Generic clickdelay - Hybrid time-since-last-attack and time-to-next-attack system.
	// next_action is a hard cooldown, as Click()s will not pass unless it is passed.
	// last_action is not a hard cooldown and different items can check for different delays.
	/// Generic clickdelay variable. Marks down the last world.time we did something that should cause or impact generic clickdelay. This should be directly set or set using [DelayNextAction()]. This should only be checked using [CheckActionCooldown()].
	var/last_action = 0
	/**
	  * The difference between the above and this is this is set immediately before even the pre-attack begins to ensure clickdelay is respected.
	  * Then, it is flushed or discarded using [FlushLastAttack()] or [DiscardLastAttack()] respectively.
	  */

	var/last_action_immediate = 0
	/// Generic clickdelay variable. Next world.time we should be able to do something that respects generic clickdelay. This should be set using [DelayNextAction()] This should only be checked using [CheckActionCooldown()].
	var/next_action = 0
	/// Ditto
	var/next_action_immediate = 0
	/// Default clickdelay for an UnarmedAttack() that successfully passes. Respects action_cooldown_mod.
	var/unarmed_attack_speed = CLICK_CD_MELEE
	/// Simple modification variable multiplied to next action modifier on adjust and on checking time since last action using [CheckActionCooldown()].
	/// This should only be manually modified using multipliers.
	var/action_cooldown_mod = 1
	/// Simple modification variable added to amount on adjust and on checking time since last action using [CheckActionCooldown()].
	/// This should only be manually modified via addition.
	var/action_cooldown_adjust = 0

	// Resisting - While resisting will give generic clickdelay, it is also on its own resist delay system. However, resisting does not check generic movedelay.
	// Resist cooldown should only be set at the start of a resist chain - whether this is clicking an alert button, pressing or hotkeying the resist button, or moving to resist out of a locker.
	/*
	 * Special clickdelay variable for resisting. Last time we did a special action like resisting. This should only be set using [MarkResistTime()].
	 * Use [CheckResistCooldown()] to check cooldowns, this should only be used for the resist action bar visual.
	 */
	var/last_resist = 0
	/// How long we should wait before allowing another resist. This should only be manually modified using multipliers.
	var/resist_cooldown = CLICK_CD_RESIST
	/// Minimum world time for another resist. This should only be checked using [CheckResistCooldown()].
	var/next_resist = 0

/**
  * Applies a delay to next_action before we can do our next action.
  *
  * @params
  * * amount - Amount to delay by
  * * ignore_mod - ignores next action adjust and mult
  * * considered_action - Defaults to TRUE - If TRUE, sets last_action to world.time.
  * * immediate - defaults to TRUE - if TRUE, writes to cached/last_attack_immediate instead of last_attack. This ensures it can't collide with any delay checks in the actual attack.
  * * flush - defaults to FALSE - Use this while using this proc outside of clickcode to ensure everything is set properly. This should never be set to TRUE if this is called from clickcode.
  */
/mob/proc/DelayNextAction(amount = 0, ignore_mod = FALSE, considered_action = TRUE, immediate = TRUE, flush = FALSE)
	if(immediate)
		if(considered_action)
			last_action_immediate = world.time
		next_action_immediate = max(next_action, world.time + (ignore_mod? amount : (amount * GetActionCooldownMod() + GetActionCooldownAdjust())))
	else
		if(considered_action)
			last_action = world.time
		next_action = max(next_action, world.time + (ignore_mod? amount : (amount * GetActionCooldownMod() + GetActionCooldownAdjust())))
	if(flush)
		FlushCurrentAction()
	else
		hud_used?.clickdelay?.mark_dirty()

/**
  * Get estimated time of next attack.
  */
/mob/proc/EstimatedNextActionTime()
	var/attack_speed = unarmed_attack_speed * GetActionCooldownMod() + GetActionCooldownAdjust()
	var/obj/item/I = get_active_held_item()
	if(I)
		attack_speed = I.GetEstimatedAttackSpeed()
		if(!I.clickdelay_mod_bypass)
			attack_speed = attack_speed * GetActionCooldownMod() + GetActionCooldownAdjust()
	return max(next_action, next_action_immediate, max(last_action, last_action_immediate) + attack_speed)

/**
  * Sets our next action to. The difference is DelayNextAction cannot reduce next_action under any circumstances while this can.
  */
/mob/proc/SetNextAction(amount = 0, ignore_mod = FALSE, considered_action = TRUE, immediate = TRUE, flush = FALSE)
	if(immediate)
		if(considered_action)
			last_action_immediate = world.time
		next_action_immediate = world.time + (ignore_mod? amount : (amount * GetActionCooldownMod() + GetActionCooldownAdjust()))
	else
		if(considered_action)
			last_action = world.time
		next_action = world.time + (ignore_mod? amount : (amount * GetActionCooldownMod() + GetActionCooldownAdjust()))
	if(flush)
		FlushCurrentAction()
	else
		hud_used?.clickdelay?.mark_dirty()

/**
  * Checks if we can do another action.
  * Returns TRUE if we can and FALSE if we cannot.
  *
  * @params
  * * cooldown - Time required since last action. Defaults to 0.5
  * * from_next_action - Defaults to FALSE. Should we check from the tail end of next_action instead of last_action?
  * * ignore_mod - Defaults to FALSE. Ignore all adjusts and multipliers. Do not use this unless you know what you are doing and have a good reason.
  * * ignore_next_action - Defaults to FALSE. Ignore next_action and only care about cooldown param and everything else. Generally unused.
  * * immediate - Defaults to FALSE. Checks last action using immediate, used on the head end of an attack. This is to prevent colliding attacks in case of sleep. Not that you should sleep() in an attack but.. y'know.
  */
/mob/proc/CheckActionCooldown(cooldown = 0.5, from_next_action = FALSE, ignore_mod = FALSE, ignore_next_action = FALSE, immediate = FALSE)
	return (ignore_next_action || (world.time >= (immediate? next_action_immediate : next_action))) && \
	(world.time >= ((from_next_action? (immediate? next_action_immediate : next_action) : (immediate? last_action_immediate : last_action)) + max(0, ignore_mod? cooldown : (cooldown * GetActionCooldownMod() + GetActionCooldownAdjust()))))

/**
  * Gets action_cooldown_mod.
  */
/mob/proc/GetActionCooldownMod()
	return action_cooldown_mod

/**
  * Gets action_cooldown_adjust
  */
/mob/proc/GetActionCooldownAdjust()
	return action_cooldown_adjust

/**
  * Flushes last_action and next_action
  */
/mob/proc/FlushCurrentAction()
	last_action = last_action_immediate
	next_action = next_action_immediate
	hud_used?.clickdelay?.mark_dirty()

/**
  * Discards last_action and next_action
  */
/mob/proc/DiscardCurrentAction()
	last_action_immediate = last_action
	next_action_immediate = next_action
	hud_used?.clickdelay?.mark_dirty()

/**
  * Checks if we can resist again.
  */
/mob/proc/CheckResistCooldown()
	return (world.time >= next_resist)

/**
  * Mark the last resist as now.
  *
  * @params
  * * extra_cooldown - Extra cooldown to apply to next_resist. Defaults to this mob's resist_cooldown.
  * * override - Defaults to FALSE - if TRUE, extra_cooldown will replace the old next_resist even if the old is longer.
  */
/mob/proc/MarkResistTime(extra_cooldown = resist_cooldown, override = FALSE)
	last_resist = world.time
	next_resist = override? (world.time + extra_cooldown) : max(next_resist, world.time + extra_cooldown)
	hud_used?.resistdelay?.mark_dirty()

/atom
	// Standard clickdelay variables
	// These 3 are all handled at base of atom/attack_hand so uh.. yeah. Make sure that's called.
	/// Amount of time to check for from a mob's last attack to allow an attack_hand().
	var/attack_hand_speed = CLICK_CD_MELEE
	/// Amount of time to hard stagger (no clicking at all) the mob post attack_hand(). Lower = better
	var/attack_hand_unwieldlyness = 0
	/// Should we set last action for attack hand? This implies that attack_hands to this atom should flush to clickdelay buffers instead of discarding.
	var/attack_hand_is_action = FALSE

/obj/item
	// Standard clickdelay variables
	/// Amount of time to check for from a mob's last attack, checked before an attack happens. Lower = faster attacks
	var/attack_speed = CLICK_CD_MELEE
	/// Amount of time to hard-stagger (no clicking at all) the mob when attacking. Lower = better
	var/attack_unwieldlyness = 0
	/// This item bypasses any click delay mods
	var/clickdelay_mod_bypass = FALSE
	/// This item checks clickdelay from a user's delayed next action variable rather than the last time they attacked.
	var/clickdelay_from_next_action = FALSE
	/// This item ignores next action delays.
	var/clickdelay_ignores_next_action = FALSE

/**
  * Checks if a user's clickdelay is met for a standard attack, this is called before an attack happens.
  */
/obj/item/proc/CheckAttackCooldown(mob/user, atom/target)
	return user.CheckActionCooldown(attack_speed, clickdelay_from_next_action, clickdelay_mod_bypass, clickdelay_ignores_next_action)

/**
  * Called after a successful attack to set a mob's clickdelay.
  */
/obj/item/proc/ApplyAttackCooldown(mob/user, atom/target, attackchain_flags)
	user.DelayNextAction(attack_unwieldlyness, clickdelay_mod_bypass, !(attackchain_flags & ATTACK_IGNORE_ACTION))

/**
  * Get estimated time that a user has to not attack for to use us
  */
/obj/item/proc/GetEstimatedAttackSpeed()
	return attack_speed
