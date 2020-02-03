//Organ reconstruction, limited to the chest region as most organs in the head have their own repair method (eyes/brain). We require synthflesh for these
//steps since fixing internal organs aren't as simple as mending exterior flesh, though in the future it would be neat to add more chems to the viable list.
//TBD: Add heart damage, have heart reconstruction seperate from organ reconstruction, and find a better name for this. I can imagine people getting it confused with manipulation.

/datum/surgery/graft_synthtissue
	name = "Graft synthtissue"
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_EYES)
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
	implements = list(TOOL_HEMOSTAT = 100, TOOL_SCREWDRIVER = 35, /obj/item/pen = 15)
	repeatable = TRUE
	time = 75
	chems_needed = list(/datum/reagent/synthtissue)
	var/obj/item/organ/chosen_organ
	var/health_restored = 10

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
			chosen_organ = input("Target which organ?", "Surgery", null, null) as null|anything in organs
			chosen_organ = organs[chosen_organ]
			if(!chosen_organ)
				return -1
			if(!target.reagents.has_reagent(/datum/reagent/synthtissue))
				to_chat(user, "<span class='notice'>There's no synthtissue available for use on [chosen_organ]</span>")
				return -1
			var/datum/reagent/synthtissue/Sf = locate(/datum/reagent/synthtissue) in target.reagents.reagent_list
			if(Sf.volume < 10)
				to_chat(user, "<span class='notice'>There's not enough synthtissue to perform the operation! There needs to be at least 10u.</span>")
				return -1

			if((chosen_organ.organ_flags & ORGAN_FAILING) && !(Sf.data["grown_volume"] >= 80))
				to_chat(user, "<span class='notice'>[chosen_organ] is too damaged to graft onto!</span>")
				return -1

			if(health_restored != 10)
				health_restored = 10
			health_restored += (Sf.data["grown_volume"]/10)

	user.visible_message("[user] begins to graft synthtissue onto [chosen_organ].</span>")
	target.reagents.remove_reagent(/datum/reagent/synthtissue, 10)

/datum/surgery_step/graft_synthtissue/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] successfully grafts synthtissue to [chosen_organ].", "<span class='notice'>You succeed in grafting 10u of the synthflesh to the [chosen_organ].</span>")
	chosen_organ.applyOrganDamage(-health_restored)
	return TRUE

/datum/surgery_step/graft_synthtissue/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='warning'>[user] accidentally damages part of [chosen_organ]!</span>", "<span class='warning'>You damage [chosen_organ]! Apply more synthtissue if it's run out.</span>")
	chosen_organ.applyOrganDamage(10)
	return FALSE
