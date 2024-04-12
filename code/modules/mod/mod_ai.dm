/obj/item/mod/control/transfer_ai(interaction, mob/user, mob/living/silicon/ai/intAI, obj/item/aicard/card)
	. = ..()
	if(!.)
		return
	if(!open) //mod must be open
		balloon_alert(user, "suit must be open to transfer!")
		return
	switch(interaction)
		if(AI_TRANS_TO_CARD)
			if(!ai)
				balloon_alert(user, "no AI in suit!")
				return
			if(!isAI(ai))
				balloon_alert(user, "onboard AI cannot fit in this card!")
				return
			balloon_alert(user, "transferring to card...")
			if(!do_after(user, 5 SECONDS, target = src))
				balloon_alert(user, "interrupted!")
				return
			if(!ai)
				return
			intAI = ai
			intAI.ai_restore_power()//So the AI initially has power.
			intAI.control_disabled = TRUE
			intAI.radio_enabled = FALSE
			intAI.disconnect_shell()
			intAI.forceMove(card)
			card.AI = intAI
			for(var/datum/action/action as anything in actions)
				action.Remove(intAI)
			intAI.controlled_equipment = null
			intAI.remote_control = null
			balloon_alert(intAI, "transferred to a card")
			balloon_alert(user, "AI transferred to card")
			ai = null

		if(AI_TRANS_FROM_CARD) //Using an AI card to upload to the suit.
			intAI = card.AI
			if(!intAI)
				balloon_alert(user, "no AI in card!")
				return
			if(ai)
				balloon_alert(user, "already has AI!")
				return
			if(intAI.deployed_shell) //Recall AI if shelled so it can be checked for a client
				intAI.disconnect_shell()
			if(intAI.stat || !intAI.client)
				balloon_alert(user, "AI unresponsive!")
				return
			balloon_alert(user, "transferring to suit...")
			if(!do_after(user, 5 SECONDS, target = src))
				balloon_alert(user, "interrupted!")
				return
			if(ai)
				return
			balloon_alert(user, "AI transferred to suit")
			ai_enter_mod(intAI)
			card.AI = null

/obj/item/mod/control/proc/ai_enter_mod(mob/living/silicon/ai/new_ai)
	new_ai.control_disabled = FALSE
	new_ai.radio_enabled = TRUE
	new_ai.ai_restore_power()
	new_ai.cancel_camera()
	new_ai.controlled_equipment = src
	new_ai.remote_control = src
	new_ai.forceMove(src)
	ai = new_ai
	balloon_alert(new_ai, "transferred to a suit")
	for(var/datum/action/action as anything in actions)
		action.Grant(ai)

/**
 * Simple proc to insert the pAI into the MODsuit.
 *
 * user - The person trying to put the pAI into the MODsuit.
 * card - The pAI card we're slotting in the MODsuit.
 */

/obj/item/mod/control/proc/insert_pai(mob/user, obj/item/paicard/card)
	if(ai)
		balloon_alert(user, "AI already installed!")
		return
	if(!card.pai || !card.pai.mind)
		balloon_alert(user, "pAI unresponsive!")
		return
	balloon_alert(user, "transferring to suit...")
	if(!do_after(user, 5 SECONDS, target = src))
		balloon_alert(user, "interrupted!")
		return FALSE
	if(!user.transferItemToLoc(card, src))
		return

	card.pai.canholo = FALSE
	ai = card.pai
	balloon_alert(user, "pAI transferred to suit")
	balloon_alert(ai, "transferred to a suit")
	ai.remote_control = src
	for(var/datum/action/action as anything in actions)
		action.Grant(ai)
	return TRUE

/**
 * Simple proc to extract the pAI from the MODsuit. It's the proc to call if you want to take it out,
 * remove_pai() is there so atom_destruction() doesn't have any risk of sleeping.
 *
 * user - The person trying to take out the pAI from the MODsuit.
 * forced - Whether or not we skip the checks and just eject the pAI. Defaults to FALSE.
 * feedback - Whether to give feedback via balloon alerts or not. Defaults to TRUE.
 */
/obj/item/mod/control/proc/extract_pai(mob/user, forced = FALSE, feedback = TRUE)
	if(!ai)
		if(user && feedback)
			balloon_alert(user, "no pAI to remove!")
		return
	if(!ispAI(ai))
		if(user && feedback)
			balloon_alert(user, "onboard AI cannot fit in this card!")
		return
	if(!forced)
		if(!open)
			if(user && feedback)
				balloon_alert(user, "open the suit panel!")
			return FALSE
		if(!do_after(user, 5 SECONDS, target = src))
			if(user && feedback)
				balloon_alert(user, "interrupted!")
			return FALSE

	remove_pai(feedback)

	if(feedback && user)
		balloon_alert(user, "pAI removed from the suit")

/**
 * Simple proc that handles the safe removal of the pAI from a MOD control unit.
 *
 * Arguments:
 * * feedback - Whether or not we want to give balloon alert feedback to the ai. Defaults to FALSE.
 */
/obj/item/mod/control/proc/remove_pai(feedback = FALSE)
	if(!ispAI(ai))
		return
	var/mob/living/silicon/pai/pai = ai
	var/turf/drop_off = get_turf(src)
	if(drop_off) // In case there's no drop_off, the pAI will simply get deleted.
		pai.card.forceMove(drop_off)

	for(var/datum/action/action as anything in actions)
		if(action.owner == pai)
			action.Remove(pai)

	if(feedback)
		balloon_alert(pai, "removed from a suit")
	pai.remote_control = null
	pai.canholo = TRUE
	pai = null
	ai = null

#define MOVE_DELAY 2
#define WEARER_DELAY 1
#define LONE_DELAY 5
#define CELL_PER_STEP (DEFAULT_CHARGE_DRAIN * 2.5)
#define AI_FALL_TIME (1 SECONDS)

/obj/item/mod/control/relaymove(mob/user, direction)
	if((!active && wearer) || !cell || cell.charge < CELL_PER_STEP  || user != ai || !COOLDOWN_FINISHED(src, cooldown_mod_move) || (wearer?.pulledby?.grab_state > GRAB_PASSIVE))
		return FALSE
	var/timemodifier = MOVE_DELAY * (ISDIAGONALDIR(direction) ? SQRT_2 : 1) * (wearer ? WEARER_DELAY : LONE_DELAY)
	if(wearer && !wearer.Process_Spacemove(direction))
		return FALSE
	else if(!wearer && (!has_gravity() || !isturf(loc)))
		return FALSE
	COOLDOWN_START(src, cooldown_mod_move, movedelay * timemodifier + slowdown)
	cell.charge = max(0, cell.charge - CELL_PER_STEP)
	playsound(src, 'sound/mecha/mechmove01.ogg', 25, TRUE)
	if(ismovable(wearer?.loc))
		return wearer.loc.relaymove(wearer, direction)
	else if(wearer)
		ADD_TRAIT(wearer, TRAIT_MOBILITY_NOREST, MOD_TRAIT)
		addtimer(CALLBACK(src, PROC_REF(ai_fall)), AI_FALL_TIME, TIMER_UNIQUE | TIMER_OVERRIDE)
	var/atom/movable/mover = wearer || src
	return step(mover, direction)

#undef MOVE_DELAY
#undef WEARER_DELAY
#undef LONE_DELAY
#undef CELL_PER_STEP
#undef AI_FALL_TIME

/obj/item/mod/control/proc/ai_fall()
	if(!wearer)
		return
	REMOVE_TRAIT(wearer, TRAIT_MOBILITY_NOREST, MOD_TRAIT)

/obj/item/mod/control/ui_state(mob/user)
	if(user == ai)
		return GLOB.contained_state
	return ..()
