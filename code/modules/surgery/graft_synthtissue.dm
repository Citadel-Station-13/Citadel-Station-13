//Organ reconstruction, limited to the chest region as most organs in the head have their own repair method (eyes/brain). We require synthflesh for these
//steps since fixing internal organs aren't as simple as mending exterior flesh, though in the future it would be neat to add more chems to the viable list.
//TBD: Add heart damage, have heart reconstruction seperate from organ reconstruction, and find a better name for this. I can imagine people getting it confused with manipulation.

/datum/surgery/graft_synthtissue
	name = "Graft_synthtissue"
	species = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
	/datum/surgery_step/incise,
	/datum/surgery_step/retract_skin,
	/datum/surgery_step/saw,
	/datum/surgery_step/clamp_bleeders,
	/datum/surgery_step/incise,
	/datum/surgery_step/graft_synthtissue,
	/datum/surgery_step/close
	)

//repair organs
/datum/surgery_step/graft_synthtissue
	name = "graft synthtissue"
	implements = list(/obj/item/hemostat = 100, TOOL_SCREWDRIVER = 35, /obj/item/pen = 15)
	repeatable = TRUE
	time = 25
	chems_needed = list("synthtissue")
	var/obj/item/organ/chosen_organ

/datum/surgery_step/graft_synthtissue/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(implement_type in implements)
		var/list/organs = target.getorganszone(target_zone)
		if(!organs.len)
			to_chat(user, "<span class='notice'>There are no targetable organs in [target]'s [parse_zone(target_zone)]!</span>")
			return -1
		else
			for(var/obj/item/organ/O in organs)
				O.on_find(user)
				organs -= O
				organs[O.name] = O
			chosen_organ = input("Remove which organ?", "Surgery", null, null) as null|anything in organs
			if(chosen_organ.isFailing())
				to_chat(user, "<span class='notice'>[target]'s [chosen_organ] is too damaged to repair graft onto!</span>")
				return -1

	user.visible_message("[user] begins to repair damaged portions of [target]'s [chosen_organ].</span>")

/datum/surgery_step/graft_synthtissue/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if((!chosen_organ)||(chosen_organ.isFailing()))
		to_chat(user, "[target] has no [chosen_organ] capable of repair!")
	else
		user.visible_message("[user] successfully repairs part of [target]'s [chosen_organ].", "<span class='notice'>You succeed in repairing parts of [target]'s [chosen_organ].</span>")
		chosen_organ.applyOrganDamage(-10)

/datum/surgery_step/graft_synthtissue/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if((!chosen_organ)||(chosen_organ.isFailing()))
		to_chat(user, "[target] has no [chosen_organ] capable of repair!")
	else
		user.visible_message("<span class='warning'>[user] accidentally damages part of [target]'s [chosen_organ]!</span>", "<span class='warning'>You damage [target]'s [chosen_organ]! Apply more synthtissue if it's run out.</span>")
		chosen_organ.applyOrganDamage(10)
	return FALSE
