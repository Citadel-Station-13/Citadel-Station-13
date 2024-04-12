/datum/surgery/advanced/robot_brainwashing
	name = "Reprogramming"
	desc = "A surgical procedure which hardcodes a directive into the patient's logic subroutines, making it their absolute priority. It can be purged using a mindshield implant."
	possible_locs = list(BODY_ZONE_HEAD)
	requires_bodypart_type = BODYPART_ROBOTIC
	steps = list(/datum/surgery_step/mechanic_open,
	/datum/surgery_step/open_hatch,
	/datum/surgery_step/mechanic_unwrench,
	/datum/surgery_step/prepare_electronics,
	/datum/surgery_step/reprogram,
	/datum/surgery_step/mechanic_wrench,
	/datum/surgery_step/mechanic_close)

/datum/surgery/advanced/reprogramming/can_start(mob/user, mob/living/carbon/target, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/brain/B = target.getorganslot(ORGAN_SLOT_BRAIN)
	if(!B)
		return FALSE
	return TRUE

/datum/surgery_step/reprogram
	name = "reprogram"
	implements = list(TOOL_MULTITOOL = 85, TOOL_HEMOSTAT = 50, TOOL_WIRECUTTER = 35, /obj/item/stack/packageWrap = 35, /obj/item/stack/cable_coil = 15, /obj/item/card/emag = 100)
	time = 200
	var/objective

/datum/surgery_step/reprogram/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	objective = stripped_input(user, "Choose the objective to imprint on your victim's posibrain.", "Reprogramming", null, MAX_MESSAGE_LEN)
	if(!objective)
		return -1
	display_results(user, target, "<span class='notice'>You begin to reprogram [target]...</span>",
		"[user] begins to fix [target]'s posibrain.",
		"[user] begins to perform surgery on [target]'s posibrain.")

/datum/surgery_step/reprogram/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!target.mind)
		to_chat(user, "<span class='warning'>[target] doesn't respond to the reprogramming, as if [target.p_they()] lacked a mind...</span>")
		return FALSE
	if(HAS_TRAIT(target, TRAIT_MINDSHIELD))
		to_chat(user, "<span class='warning'>You hear a faint buzzing from a device inside [target]'s posibrain, and the programming is purged.</span>")
		return FALSE
	display_results(user, target, "<span class='notice'>You succeed in reprogramming [target].</span>",
		"[user] successfully fixes [target]'s posibrain!",
		"[user] completes the surgery on [target]'s posibrain.")
	to_chat(target, "<span class='userdanger'>A new directive fills your mind... you feel forced to obey it!</span>")
	brainwash(target, objective)
	message_admins("[ADMIN_LOOKUPFLW(user)] surgically synth-brainwashed [ADMIN_LOOKUPFLW(target)] with the objective '[objective]'.")
	log_game("[key_name(user)] surgically synth-brainwashed [key_name(target)] with the objective '[objective]'.")
	return TRUE

/datum/surgery_step/reprogram/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.getorganslot(ORGAN_SLOT_BRAIN))
		display_results(user, target, "<span class='warning'>You screw up, causing more damage!</span>",
			"<span class='warning'>[user] screws up, causing damage to the circuits!/span>",
			"[user] completes the surgery on [target]'s posibrain.")
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 40)
	else
		user.visible_message("<span class='warning'>[user] suddenly notices that the posibrain [user.p_they()] [user.p_were()] working on is not there anymore.", "<span class='warning'>You suddenly notice that the posibrain you were working on is not there anymore.</span>")
	return FALSE
