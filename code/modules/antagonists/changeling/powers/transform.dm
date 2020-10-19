/obj/effect/proc_holder/changeling/transform
	name = "Transform"
	desc = "We take on the appearance and voice of one we have absorbed."
	chemical_cost = 5
	dna_cost = 0
	req_dna = 1
	req_human = 1
	action_icon = 'icons/mob/actions/actions_changeling.dmi'
	action_icon_state = "ling_transform"
	action_background_icon_state = "bg_ling"

/obj/item/clothing/glasses/changeling
	name = "flesh"

/obj/item/clothing/glasses/changeling/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)


/obj/item/clothing/glasses/changeling/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(loc == user && user.mind && user.mind.has_antag_datum(/datum/antagonist/changeling))
		to_chat(user, "<span class='notice'>You reabsorb [src] into your body.</span>")
		qdel(src)
		return
	. = ..()

/obj/item/clothing/under/changeling
	name = "flesh"

/obj/item/clothing/under/changeling/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)


/obj/item/clothing/under/changeling/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(loc == user && user.mind && user.mind.has_antag_datum(/datum/antagonist/changeling))
		to_chat(user, "<span class='notice'>You reabsorb [src] into your body.</span>")
		qdel(src)
		return
	. = ..()

/obj/item/clothing/suit/changeling
	name = "flesh"
	allowed = list(/obj/item/changeling)

/obj/item/clothing/suit/changeling/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)


/obj/item/clothing/suit/changeling/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(loc == user && user.mind && user.mind.has_antag_datum(/datum/antagonist/changeling))
		to_chat(user, "<span class='notice'>You reabsorb [src] into your body.</span>")
		qdel(src)
		return
	. = ..()

/obj/item/clothing/head/changeling
	name = "flesh"

/obj/item/clothing/head/changeling/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)

/obj/item/clothing/head/changeling/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(loc == user && user.mind && user.mind.has_antag_datum(/datum/antagonist/changeling))
		to_chat(user, "<span class='notice'>You reabsorb [src] into your body.</span>")
		qdel(src)
		return
	. = ..()

/obj/item/clothing/shoes/changeling
	name = "flesh"

/obj/item/clothing/shoes/changeling/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)


/obj/item/clothing/shoes/changeling/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(loc == user && user.mind && user.mind.has_antag_datum(/datum/antagonist/changeling))
		to_chat(user, "<span class='notice'>You reabsorb [src] into your body.</span>")
		qdel(src)
		return
	. = ..()

/obj/item/clothing/gloves/changeling
	name = "flesh"

/obj/item/clothing/gloves/changeling/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)


/obj/item/clothing/gloves/changeling/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(loc == user && user.mind && user.mind.has_antag_datum(/datum/antagonist/changeling))
		to_chat(user, "<span class='notice'>You reabsorb [src] into your body.</span>")
		qdel(src)
		return
	. = ..()

/obj/item/clothing/mask/changeling
	name = "flesh"

/obj/item/clothing/mask/changeling/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)


/obj/item/clothing/mask/changeling/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(loc == user && user.mind && user.mind.has_antag_datum(/datum/antagonist/changeling))
		to_chat(user, "<span class='notice'>You reabsorb [src] into your body.</span>")
		qdel(src)
		return
	. = ..()

/obj/item/changeling
	name = "flesh"
	slot_flags = ALL
	allowed = list(/obj/item/changeling)

/obj/item/changeling/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CHANGELING_TRAIT)


/obj/item/changeling/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(loc == user && user.mind && user.mind.has_antag_datum(/datum/antagonist/changeling))
		to_chat(user, "<span class='notice'>You reabsorb [src] into your body.</span>")
		qdel(src)
		return
	. = ..()

//Change our DNA to that of somebody we've absorbed.
/obj/effect/proc_holder/changeling/transform/sting_action(mob/living/carbon/human/user)
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	var/datum/changelingprofile/chosen_prof = changeling.select_dna("Select the target DNA: ", "Target DNA")

	if(!chosen_prof)
		return

	changeling_transform(user, chosen_prof)
	return TRUE

/datum/antagonist/changeling/proc/select_dna(var/prompt, var/title)
	var/mob/living/carbon/user = owner.current
	if(!istype(user))
		return
	var/list/names = list("Drop Flesh Disguise")
	for(var/datum/changelingprofile/prof in stored_profiles)
		names += "[prof.name]"

	var/chosen_name = input(prompt, title, null) as null|anything in names
	if(!chosen_name)
		return

	if(chosen_name == "Drop Flesh Disguise")
		for(var/slot in GLOB.slots)
			if(istype(user.vars[slot], GLOB.slot2type[slot]))
				qdel(user.vars[slot])

	var/datum/changelingprofile/prof = get_dna(chosen_name)
	return prof
