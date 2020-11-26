/*
Timeconsuming but highly effective surgery that purges any system corruption currently present, only works on robotic organisms.
Has a version for organic people and robotic/synthetic ones, considering robotic limbs and robotic organism isn't neccessarily linked and, say, someone could surgery a synthetic's brain into a nonsynthetic head.
*/
/datum/surgery/purge_corruption
	name = "Purge corruption"
	desc = "A highly complex and time-consuming surgery used to purge any corruption currently present in a robot. Will knock out the patient for an amount of time proportional to corruption purged."
	steps = list(
			/datum/surgery_step/incise,
			/datum/surgery_step/retract_skin,
			/datum/surgery_step/clamp_bleeders,
			/datum/surgery_step/saw,
			/datum/surgery_step/clamp_bleeders,
			/datum/surgery_step/incise,
			/datum/surgery_step/clamp_bleeders,
			/datum/surgery_step/override_safeties,
			/datum/surgery_step/remove_corruption,
			/datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_HEAD)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey) //If admins made a monkey into a robotic supersoldier or something.

/datum/surgery/purge_corruption/robotic
	requires_bodypart_type = BODYPART_ROBOTIC
	steps = list(
			/datum/surgery_step/mechanic_open,
			/datum/surgery_step/open_hatch,
			/datum/surgery_step/mechanic_unwrench,
			/datum/surgery_step/cut_wires,
			/datum/surgery_step/prepare_electronics,
			/datum/surgery_step/override_safeties,
			/datum/surgery_step/remove_corruption,
			/datum/surgery_step/mechanic_wrench,
			/datum/surgery_step/mechanic_close)

/datum/surgery/purge_corruption/can_start(mob/user, mob/living/carbon/target, obj/item/tool)
	. = ..()
	if(!.)
		return
	var/obj/item/organ/brain/B = target.getorganslot(ORGAN_SLOT_BRAIN)
	if(!B || !HAS_TRAIT(target, TRAIT_ROBOTIC_ORGANISM))
		return FALSE

/datum/surgery_step/override_safeties
	name = "Override inbuilt safeguards (multitool)"
	implements = list(TOOL_MULTITOOL = 100, TOOL_WIRECUTTER = 20)
	time = 50

/datum/surgery_step/override_safeties/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You begin to override the safeties of [target]...</span>",
		"[user] begins to override the hardware safeties of [target].",
		"[user] begins to perform surgery on [target]'s brain.")

/datum/surgery_step/override_safeties/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You succeed in overriding the safeties of [target].</span>",
		"[user] successfully overrides the safeties of [target]!",
		"[user] completes the surgery on [target]'s brain.")
	return TRUE

/datum/surgery_step/override_safeties/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You fail overriding the safeties of [target].</span>",
		"[user] fails overriding the safeties of [target]",
		"[user] completes the surgery on [target]'s brain.")
	return FALSE

/datum/surgery_step/remove_corruption
	name = "Initiate system purge (multitool)"
	implements = list(TOOL_MULTITOOL = 95, TOOL_WIRECUTTER = 10) //You are relatively safe just using a multitool, but you should use sterilizer or simillar success chance increasing chems regardless.
	time = 80 //Takes a l o n g time, but completely purges system corruption

/datum/surgery_step/remove_corruption/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You begin to initiate a system purge in [target]...</span>",
		"[user] begins to initiate a system purge in [target].",
		"[user] begins to perform surgery on [target].")

/datum/surgery_step/remove_corruption/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!target.getorganslot(ORGAN_SLOT_BRAIN) || !HAS_TRAIT(target, TRAIT_ROBOTIC_ORGANISM))
		user.visible_message("<span class='warning'>[user] suddenly realises that [user.p_they()] can't actually initiate a system purge in [target]...", "<span class='warning'>You suddenly realise that you cannot initiate a system purge in [target].</span>")
		return FALSE
	display_results(user, target, "<span class='notice'>You successfully initate a system purge in [target]...</span>",
		"[user] successfully initiates a system purge in [target].",
		"[user] completes the surgery on [target].")
	var/purged = target.getToxLoss(TOX_SYSCORRUPT)
	target.setToxLoss(0, toxins_type = TOX_SYSCORRUPT)
	target.Unconscious(round(purged * 0.2, 1))
	return TRUE

/datum/surgery_step/remove_corruption/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(!target.getorganslot(ORGAN_SLOT_BRAIN) || !HAS_TRAIT(target, TRAIT_ROBOTIC_ORGANISM))
		user.visible_message("<span class='warning'>[user] suddenly realises that [user.p_they()] can't actually initiate a system purge in [target]...", "<span class='warning'>You suddenly realise that you cannot initiate a system purge in [target].</span>")
		return FALSE
	display_results(user, target, "<span class='notice'>You fail purging [target]'s system of corruption, damaging [target.p_them()] instead...</span>",
	"[user] fails purging [target]'s system of corruption, damaging [target.p_them()] instead.",
	"[user] completes the surgery on [target].")
	target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 40)
	target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
	return FALSE
