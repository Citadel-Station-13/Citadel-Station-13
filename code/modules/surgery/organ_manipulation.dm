/datum/surgery/organ_manipulation
	name = "organ manipulation"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/saw, /datum/surgery_step/clamp_bleeders,
	/datum/surgery_step/incise, /datum/surgery_step/manipulate_organs)
	species = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list("chest", "head")
	requires_organic_bodypart = 0

/datum/surgery/organ_manipulation/soft
	possible_locs = list("groin", "eyes", "mouth", "l_arm", "r_arm")
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/clamp_bleeders,
	/datum/surgery_step/incise, /datum/surgery_step/manipulate_organs)

/datum/surgery/organ_manipulation/alien
	name = "alien organ manipulation"
	possible_locs = list("chest", "head", "groin", "eyes", "mouth", "l_arm", "r_arm")
	species = list(/mob/living/carbon/alien/humanoid)
	steps = list(/datum/surgery_step/saw, /datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/saw, /datum/surgery_step/manipulate_organs)




/datum/surgery_step/manipulate_organs
	time = 64
	name = "manipulate organs"
	implements = list(/obj/item/organ = 100, /obj/item/weapon/reagent_containers/food/snacks/organ = 0)
	var/implements_extract = list(/obj/item/weapon/hemostat = 100, /obj/item/weapon/crowbar = 55)
	var/implements_mend = list(/obj/item/weapon/cautery = 100, /obj/item/weapon/weldingtool = 70, /obj/item/weapon/lighter = 45, /obj/item/weapon/match = 20)
	var/current_type
	var/obj/item/organ/I = null

/datum/surgery_step/manipulate_organs/New()
	..()
	implements = implements + implements_extract + implements_mend

/datum/surgery_step/manipulate_organs/tool_check(mob/user, obj/item/tool)
	if(istype(tool, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = tool
		if(!WT.isOn())
			return 0

	else if(istype(tool, /obj/item/weapon/lighter))
		var/obj/item/weapon/lighter/L = tool
		if(!L.lit)
			return 0

	else if(istype(tool, /obj/item/weapon/match))
		var/obj/item/weapon/match/M = tool
		if(!M.lit)
			return 0

	return 1


/datum/surgery_step/manipulate_organs/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	I = null
	if(isorgan(tool))
		current_type = "insert"
		I = tool
		if(target_zone != I.zone || target.getorganslot(I.slot))
			to_chat(user, "<span class='notice'>There is no room for [I] in [target]'s [parse_zone(target_zone)]!</span>")
			return -1

		user.visible_message("[user] begins to insert [tool] into [target]'s [parse_zone(target_zone)].",
			"<span class='notice'>You begin to insert [tool] into [target]'s [parse_zone(target_zone)]...</span>")

	else if(implement_type in implements_extract)
		current_type = "extract"
		var/list/organs = target.getorganszone(target_zone)
		var/mob/living/simple_animal/borer/B = target.has_brain_worms()
		if(target.has_brain_worms())
			user.visible_message("[user] begins to extract [B] from [target]'s [parse_zone(target_zone)].",
					"<span class='notice'>You begin to extract [B] from [target]'s [parse_zone(target_zone)]...</span>")
			return TRUE
		if(!organs.len)
			to_chat(user, "<span class='notice'>There is no removeable organs in [target]'s [parse_zone(target_zone)]!</span>")
			return -1
		else
			for(var/obj/item/organ/O in organs)
				O.on_find(user)
				organs -= O
				organs[O.name] = O

			I = input("Remove which organ?", "Surgery", null, null) as null|anything in organs
			if(I && user && target && user.Adjacent(target) && user.get_active_held_item() == tool)
				I = organs[I]
				if(!I) return -1
				user.visible_message("[user] begins to extract [I] from [target]'s [parse_zone(target_zone)].",
					"<span class='notice'>You begin to extract [I] from [target]'s [parse_zone(target_zone)]...</span>")
			else
				return -1

	else if(implement_type in implements_mend)
		current_type = "mend"
		user.visible_message("[user] begins to mend the incision in [target]'s [parse_zone(target_zone)].",
			"<span class='notice'>You begin to mend the incision in [target]'s [parse_zone(target_zone)]...</span>")

	else if(istype(tool, /obj/item/weapon/reagent_containers/food/snacks/organ))
		to_chat(user, "<span class='warning'>[tool] was biten by someone! It's too damaged to use!</span>")
		return -1

/datum/surgery_step/manipulate_organs/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(current_type == "mend")
		user.visible_message("[user] mends the incision in [target]'s [parse_zone(target_zone)].",
			"<span class='notice'>You mend the incision in [target]'s [parse_zone(target_zone)].</span>")
		if(locate(/datum/surgery_step/saw) in surgery.steps)
			target.heal_bodypart_damage(45,0)
		return 1
	else if(current_type == "insert")
		I = tool
		user.drop_item()
		I.Insert(target)
		user.visible_message("[user] inserts [tool] into [target]'s [parse_zone(target_zone)]!",
			"<span class='notice'>You insert [tool] into [target]'s [parse_zone(target_zone)].</span>")

	else if(current_type == "extract")
		var/mob/living/simple_animal/borer/B = target.has_brain_worms()
		if(B && B.victim == target)
			user.visible_message("[user] successfully extracts [B] from [target]'s [parse_zone(target_zone)]!",
				"<span class='notice'>You successfully extract [B] from [target]'s [parse_zone(target_zone)].</span>")
			add_logs(user, target, "surgically removed [B] from", addition="INTENT: [uppertext(user.a_intent)]")
			B.leave_victim()
			return FALSE
		if(I && I.owner == target)
			user.visible_message("[user] successfully extracts [I] from [target]'s [parse_zone(target_zone)]!",
				"<span class='notice'>You successfully extract [I] from [target]'s [parse_zone(target_zone)].</span>")
			add_logs(user, target, "surgically removed [I.name] from", addition="INTENT: [uppertext(user.a_intent)]")
			I.Remove(target)
			I.loc = get_turf(target)
		else
			user.visible_message("[user] can't seem to extract anything from [target]'s [parse_zone(target_zone)]!",
				"<span class='notice'>You can't extract anything from [target]'s [parse_zone(target_zone)]!</span>")
	return 0
