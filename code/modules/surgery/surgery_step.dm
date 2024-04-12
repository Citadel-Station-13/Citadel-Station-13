/datum/surgery_step
	var/name
	var/list/implements = list()	//format is path = probability of success. alternatively
	var/implement_type = null		//the current type of implement used. This has to be stored, as the actual typepath of the tool may not match the list type.
	var/accept_hand = FALSE				//does the surgery step require an open hand? If true, ignores implements. Compatible with accept_any_item.
	var/accept_any_item = FALSE			//does the surgery step accept any item? If true, ignores implements. Compatible with require_hand.
	var/time = 10					//how long does the step take?
	var/repeatable = FALSE				//can this step be repeated? Make shure it isn't last step, or it used in surgery with `can_cancel = 1`. Or surgion will be stuck in the loop
	var/list/chems_needed = list()  //list of chems needed to complete the step. Even on success, the step will have no effect if there aren't the chems required in the mob.
	var/require_all_chems = TRUE    //any on the list or all on the list?
	var/silicons_obey_prob = FALSE
	var/preop_sound //Sound played when the step is started
	var/success_sound //Sound played if the step succeeded
	var/failure_sound //Sound played if the step fails

/datum/surgery_step/proc/try_op(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, try_to_fail = FALSE)
	var/success = FALSE
	if(accept_hand)
		if(!tool)
			success = TRUE
		if(iscyborg(user))
			success = TRUE
	if(accept_any_item)
		if(tool && tool_check(user, tool))
			success = TRUE
	else if(tool)
		for(var/key in implements)
			var/match = FALSE
			if(ispath(key) && istype(tool, key))
				match = TRUE
			else if(tool.tool_behaviour == key)
				match = TRUE
			if(match)
				implement_type = key
				if(tool_check(user, tool))
					success = TRUE
					break
	if(success)
		if(target_zone == surgery.location)
			if(get_location_accessible(target, target_zone) || surgery.ignore_clothes)
				return initiate(user, target, target_zone, tool, surgery, try_to_fail)
			else
				to_chat(user, "<span class='warning'>You need to expose [target]'s [parse_zone(target_zone)] to perform surgery on it!</span>")
				return TRUE	//returns TRUE so we don't stab the guy in the dick or wherever.
	if(repeatable)
		var/datum/surgery_step/next_step = surgery.get_surgery_next_step()
		if(next_step)
			surgery.status++
			if(next_step.try_op(user, target, user.zone_selected, user.get_active_held_item(), surgery))
				return TRUE
			else
				surgery.status--
	return FALSE

/datum/surgery_step/proc/initiate(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, try_to_fail = FALSE)
	surgery.step_in_progress = TRUE
	var/speed_mod = 1
	var/advance = FALSE
	if(preop(user, target, target_zone, tool, surgery) == -1)
		surgery.step_in_progress = FALSE
		return FALSE

	play_preop_sound(user, target, target_zone, tool, surgery) // Here because most steps overwrite preop

	if(tool)
		speed_mod = tool.toolspeed //faster tools mean faster surgeries, but also less experience.
	if(user.mind)
		speed_mod = user.mind.action_skill_mod(/datum/skill/numerical/surgery, speed_mod, THRESHOLD_UNTRAINED, FALSE)
	var/delay = time * speed_mod
	if(do_after(user, delay, target = target))
		var/prob_chance = 100
		if(implement_type)	//this means it isn't a require hand or any item step.
			prob_chance = implements[implement_type]
		prob_chance *= surgery.get_propability_multiplier()

		if((prob(prob_chance) || (iscyborg(user) && !silicons_obey_prob)) && chem_check(target) && !try_to_fail)
			if(success(user, target, target_zone, tool, surgery))
				play_success_sound(user, target, target_zone, tool, surgery)
				var/multi = (delay/SKILL_GAIN_DELAY_DIVISOR)
				if(repeatable)
					multi *= 0.5 //Spammable surgeries award less experience.
				user.mind?.auto_gain_experience(/datum/skill/numerical/surgery, SKILL_GAIN_SURGERY_PER_STEP * multi)
				advance = TRUE
		else
			if(failure(user, target, target_zone, tool, surgery))
				play_failure_sound(user, target, target_zone, tool, surgery)
				advance = TRUE
		if(advance && !repeatable)
			surgery.status++
			if(surgery.status > surgery.steps.len)
				surgery.complete()
		surgery.step_in_progress = FALSE
		return advance

	if(target.stat == DEAD && user.client)
		user.client.give_award(/datum/award/achievement/misc/sandman, user)

	surgery.step_in_progress = FALSE
	if(repeatable)
		return FALSE //This is how the repeatable surgery detects it shouldn't cycle
	return TRUE //Stop the attack chain! - Except on repeatable steps, because otherwise we land in an infinite loop.


/datum/surgery_step/proc/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You begin to perform surgery on [target]...</span>",
		"[user] begins to perform surgery on [target].",
		"[user] begins to perform surgery on [target].")

/datum/surgery_step/proc/play_preop_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!preop_sound)
		return
	playsound(get_turf(target), preop_sound, 75, TRUE, falloff_exponent = 12, falloff_distance = 1)

/datum/surgery_step/proc/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You succeed.</span>",
		"[user] succeeds!",
		"[user] finishes.")
	return TRUE

/datum/surgery_step/proc/play_success_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!success_sound)
		return
	playsound(get_turf(target), success_sound, 75, TRUE, falloff_exponent = 12, falloff_distance = 1)

/datum/surgery_step/proc/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='warning'>You screw up!</span>",
		"<span class='warning'>[user] screws up!</span>",
		"[user] finishes.", TRUE) //By default the patient will notice if the wrong thing has been cut
	return FALSE

/datum/surgery_step/proc/play_failure_sound(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!failure_sound)
		return
	playsound(get_turf(target), failure_sound, 75, TRUE, falloff_exponent = 12, falloff_distance = 1)

/datum/surgery_step/proc/tool_check(mob/user, obj/item/tool)
	return TRUE

/datum/surgery_step/proc/chem_check(mob/living/target)
	if(!LAZYLEN(chems_needed))
		return TRUE
	if(require_all_chems)
		. = TRUE
		for(var/R in chems_needed)
			if(!target.reagents.has_reagent(R))
				return FALSE
	else
		. = FALSE
		for(var/R in chems_needed)
			if(target.reagents.has_reagent(R))
				return TRUE
/datum/surgery_step/proc/get_chem_list()
	if(!LAZYLEN(chems_needed))
		return
	var/list/chems = list()
	for(var/R in chems_needed)
		var/datum/reagent/temp = GLOB.chemical_reagents_list[R]
		if(temp)
			var/chemname = temp.name
			chems += chemname
	return english_list(chems, and_text = require_all_chems ? " and " : " or ")

//Replaces visible_message during operations so only people looking over the surgeon can tell what they're doing, allowing for shenanigans.
/datum/surgery_step/proc/display_results(mob/user, mob/living/carbon/target, self_message, detailed_message, vague_message, target_detailed = FALSE)
	var/list/detailed_mobs = get_hearers_in_view(1, user) //Only the surgeon and people looking over his shoulder can see the operation clearly
	if(!target_detailed)
		detailed_mobs -= target //The patient can't see well what's going on, unless it's something like getting cut
	user.visible_message(detailed_message, self_message, vision_distance = 1, ignored_mobs = target_detailed ? null : target)
	user.visible_message(vague_message, "", ignored_mobs = detailed_mobs)
