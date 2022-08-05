/datum/component/dullahan
	var/obj/item/dullahan_head/dullahan_head

/datum/component/dullahan/Initialize()
	. = ..()

	var/mob/living/carbon/human/H = parent
	if(!H)
		return .

	ADD_TRAIT(H, TRAIT_DULLAHAN, "dullahan_component")

	dullahan_head = new(get_turf(H))

	dullahan_head.name = "[H.name]'s head"
	dullahan_head.desc = "the decapitated head of [H.name]"
	dullahan_head.owner = H
	RegisterSignal(H, COMSIG_LIVING_REGENERATE_LIMBS, .proc/unlist_head)

	// make sure the brain can't decay or fall out
	var/obj/item/organ/brain/B = H.getorganslot(ORGAN_SLOT_BRAIN)
	B.zone = "abstract" // it exists in the ethereal plain
	B.organ_flags = ORGAN_NO_SPOIL | ORGAN_NO_DISMEMBERMENT	| ORGAN_VITAL
	dullahan_head.B = B

	// the eyes get similar treatment
	var/obj/item/organ/eyes/dullahan/new_eyes = new()
	var/obj/item/organ/eyes/E = H.getorganslot(ORGAN_SLOT_EYES)
	new_eyes.left_eye_color = E.left_eye_color
	new_eyes.right_eye_color = E.right_eye_color
	E.Remove()
	qdel(E)
	new_eyes.Insert(H)

	// make sure you handle the tongue correctly, too!
	var/obj/item/organ/tongue/T = H.getorganslot(ORGAN_SLOT_TONGUE)
	T.Remove()
	qdel(T)

	var/obj/item/organ/tongue/dullahan/new_tongue = new()
	new_tongue.Insert(H)

	// moving the brain's zone means we don't need the head to survive
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	head.drop_limb()
	qdel(head)

	H.flags_1 &= ~(HEAR_1)

	RegisterSignal(dullahan_head, COMSIG_ATOM_HEARER_IN_VIEW, .proc/include_owner)

	dullahan_head.update_appearance()

/datum/component/dullahan/proc/include_owner(datum/source, list/processing_list, list/hearers)
	if(!QDELETED(parent))
		hearers += parent

/datum/component/dullahan/proc/unlist_head(datum/source, noheal = FALSE, list/excluded_limbs)
	excluded_limbs |= BODY_ZONE_HEAD // So we don't gib when regenerating limbs.

/obj/item/organ/tongue/dullahan
	zone = "abstract"
	initial_accents = list(/datum/accent/dullahan)
	organ_flags = ORGAN_NO_SPOIL | ORGAN_NO_DISMEMBERMENT

/obj/item/organ/eyes/dullahan
	name = "head vision"
	desc = "An abstraction."
	actions_types = list(/datum/action/item_action/organ_action/dullahan)
	zone = "abstract"
	tint = INFINITY // used to switch the vision perspective to the head on species_gain().

/obj/item/dullahan_head
	name = "coders lament"
	desc = "you shouldn't be reading this"
	flags_1 = HEAR_1
	var/mob/living/carbon/human/owner
	// this is for keeping track of the overlays because you can't read the actual overlays list as it's a special byond var
	var/list/overlays_standing
	var/obj/item/organ/brain/B

/obj/item/dullahan_head/Destroy()
	B.Remove()
	B.forceMove(get_turf(src))
	. = ..()

// allow the 'fake' head to relay speech back to the mob
/obj/item/dullahan_head/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, message_mode)
	if(owner)
		var/namepart = "[speaker.GetVoice()][speaker.get_alt_name()]"
		var/hrefpart = "<a href='?src=[REF(src)];track=[html_encode(namepart)]'>"
		var/treated_message = lang_treat(speaker, message_language, raw_message, spans, message_mode)
		var/rendered = "<i><span class='game say'><span class='name'>[hrefpart][namepart]</a> </span><span class='message'>[treated_message]</span></span></i>"

		if (owner.client?.prefs.chat_on_map && (owner.client.prefs.see_chat_non_mob || ismob(speaker)))
			owner.create_chat_message(speaker, message_language, raw_message, spans, message_mode)
		owner.show_message(rendered, "")

// update head sprite
/obj/item/dullahan_head/proc/remove_head_overlays()
	overlays_standing = list()
	cut_overlays()

/obj/item/dullahan_head/proc/add_head_overlay(var/overlay)
	overlays_standing += overlay
	add_overlay(overlay)

/obj/item/dullahan_head/update_appearance()
	remove_head_overlays()
	// to do this without duplicating large amounts of code
	// it's best to regenerate the head, then remove it once we have the overlays we want
	owner.regenerate_limb(BODY_ZONE_HEAD, TRUE) // don't heal them
	owner.regenerate_icons(TRUE) // yes i know it's expensive but do you want me to rewrite our entire overlay system, also block recursive calls here by passing in TRUE (it wont go back to call update_appearance this way)
	var/obj/item/bodypart/head/head = owner.get_bodypart(BODY_ZONE_HEAD)
	add_overlay(head.get_limb_icon(FALSE, TRUE, TRUE))
	for(var/overlay in owner.overlays_standing)
		if(istype(overlay, /mutable_appearance))
			var/mutable_appearance/mutable = overlay
			if(mutable.category == "HEAD")
				add_head_overlay(mutable)
		else
			if(islist(overlay))
				var/list/list_appearances = overlay
				for(var/overlay2 in list_appearances)
					if(istype(overlay2, /mutable_appearance))
						var/mutable_appearance/mutable = overlay2
						if(mutable.category == "HEAD")
							add_head_overlay(mutable)
	head.drop_limb()
	qdel(head)

/obj/item/dullahan_head/proc/unlist_head(datum/source, noheal = FALSE, list/excluded_limbs)
	excluded_limbs |= BODY_ZONE_HEAD // So we don't gib when regenerating limbs.

/datum/action/item_action/organ_action/dullahan
	name = "Toggle Perspective"
	desc = "Switch between seeing normally from your head, or blindly from your body."

/datum/action/item_action/organ_action/dullahan/Trigger()
	. = ..()
	var/mob/living/carbon/human/H = owner
	var/obj/item/organ/eyes/E = owner.getorganslot(ORGAN_SLOT_EYES)
	if(E)
		if(E.tint)
			E.tint = 0
		else
			E.tint = INFINITY

	var/datum/component/dullahan/D = H.GetComponent(/datum/component/dullahan)
	if(D)
		D.update_vision_perspective()

/datum/component/dullahan/proc/update_vision_perspective()
	var/mob/living/carbon/human/H = parent
	if(!H)
		return .
	var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		H.update_tint()
		if(eyes.tint)
			H.reset_perspective(H)
		else
			H.reset_perspective(dullahan_head)

/datum/component/dullahan/Destroy()
	UnregisterSignal(parent, COMSIG_LIVING_REGENERATE_LIMBS)
	qdel(dullahan_head)
	REMOVE_TRAIT(parent, TRAIT_DULLAHAN, "dullahan_component")

	// work out what organs to give them based on their species
	if(ishuman(parent))
		var/mob/living/carbon/human/H = parent
		var/obj/item/organ/eyes/new_eyes = new H.dna.species.mutant_eyes()
		var/obj/item/organ/brain/new_brain = new H.dna.species.mutant_brain()
		var/obj/item/organ/eyes/old_eyes = H.getorganslot(ORGAN_SLOT_EYES)
		var/obj/item/organ/brain/old_brain = H.getorganslot(ORGAN_SLOT_BRAIN)

		old_brain.Remove(TRUE,TRUE)
		QDEL_NULL(old_brain)
		new_brain.Insert(H, TRUE, TRUE)

		old_eyes.Remove(TRUE,TRUE)
		QDEL_NULL(old_eyes)
		new_eyes.Insert(H, TRUE, TRUE)
	. = ..()
