/datum/surgery/cavity_implant
	name = "cavity implant"
	steps = list(
	/datum/surgery_step/incise,
	/datum/surgery_step/clamp_bleeders,
	/datum/surgery_step/retract_skin,
	/datum/surgery_step/incise,
	/datum/surgery_step/handle_cavity,
	/datum/surgery_step/prep_bone,
	/datum/surgery_step/set_bone,
	/datum/surgery_step/mend_bone,
	/datum/surgery_step/close
	)
	species = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list("chest")
	requires_bodypart_type = BODYPART_ORGANIC
	requires_bones = TRUE

/datum/surgery/cavity_implant/boneless
	name = "boneless cavity implant"
	steps = list(
	/datum/surgery_step/incise,
	/datum/surgery_step/clamp_bleeders,
	/datum/surgery_step/retract_skin,
	/datum/surgery_step/incise,
	/datum/surgery_step/handle_cavity,
	/datum/surgery_step/close
	)
	requires_bodypart_type = BODYPART_FLUBBER
	requires_bones = FALSE

/datum/surgery/cavity_implant/golem
	name = "material cavity implant"
	steps = list(
	/datum/surgery_step/saw_material,
	/datum/surgery_step/retract_material,
	/datum/surgery_step/saw_material,
	/datum/surgery_step/retract_material,
	/datum/surgery_step/handle_cavity,
	/datum/surgery_step/prep_material,
	/datum/surgery_step/set_material,
	/datum/surgery_step/reinforce_material,
	/datum/surgery_step/close
	)
	requires_bones = FALSE
	requires_bodypart_type = BODYPART_MATERIAL


//handle cavity
/datum/surgery_step/handle_cavity
	name = "implant item"
	accept_hand = TRUE
	accept_any_item = TRUE
	time = 32
	var/obj/item/IC = null

/datum/surgery_step/handle_cavity/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/bodypart/chest/CH = target.get_bodypart("chest")
	IC = CH.cavity_item
	if(tool)
		user.visible_message("[user] begins to insert [tool] into [target]'s [target_zone].", "<span class='notice'>You begin to insert [tool] into [target]'s [target_zone]...</span>")
	else
		user.visible_message("[user] checks for items in [target]'s [target_zone].", "<span class='notice'>You check for items in [target]'s [target_zone]...</span>")

/datum/surgery_step/handle_cavity/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/bodypart/chest/CH = target.get_bodypart("chest")
	if(tool)
		if(IC || tool.w_class > WEIGHT_CLASS_NORMAL || (tool.flags_1 & NODROP_1) || istype(tool, /obj/item/organ))
			to_chat(user, "<span class='warning'>You can't seem to fit [tool] in [target]'s [target_zone]!</span>")
			return FALSE
		else
			user.visible_message("[user] stuffs [tool] into [target]'s [target_zone]!", "<span class='notice'>You stuff [tool] into [target]'s [target_zone].</span>")
			user.transferItemToLoc(tool, target, TRUE)
			CH.cavity_item = tool
			return TRUE
	else
		if(IC)
			user.visible_message("[user] pulls [IC] out of [target]'s [target_zone]!", "<span class='notice'>You pull [IC] out of [target]'s [target_zone].</span>")
			user.put_in_hands(IC)
			CH.cavity_item = null
			return TRUE
		else
			to_chat(user, "<span class='warning'>You don't find anything in [target]'s [target_zone].</span>")
			return FALSE
