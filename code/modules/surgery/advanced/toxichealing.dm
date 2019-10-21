/datum/surgery/advanced/toxichealing
	name = "Body Rejuvenation"
	desc = "A surgical procedure that helps deal with oxygen  deprivation, and treats parts damaged due to toxic compounds. Works on corpses and alive alike without chemicals."
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/incise,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/toxichealing,
				/datum/surgery_step/close)

	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(BODY_ZONE_CHEST)
	requires_bodypart_type = 0

/datum/surgery_step/toxichealing
	name = "rejuvenate body"
	implements = list(TOOL_HEMOSTAT  = 100, TOOL_SCREWDRIVER = 35, /obj/item/pen = 15)
	repeatable = TRUE
	time = 25

/datum/surgery_step/toxichealing/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] starts rejuvenating some of [target]'s flesh back to life.", "<span class='notice'>You start knitting some of [target]'s flesh back to life.</span>")

/datum/surgery_step/toxichealing/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] fixes some of [target]'s wounds.", "<span class='notice'>You succeed in fixing some of [target]'s wounds.</span>")
	target.heal_bodypart_damage(0,0,30) //Heals stam
	target.adjustToxLoss(-15, 0, TRUE)
	target.adjustOxyLoss(-20, 0)
	return TRUE

/datum/surgery_step/toxichealing/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] screws up!", "<span class='warning'>You screwed up!</span>")
	target.take_bodypart_damage(25,0)
	return FALSE