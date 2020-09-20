//turns the user into a dullahan by popping their head off and applying a bunch of snowflakey stuff
/datum/component/dullahan
	//who is the person who is going to lose their head
	var/mob/living/carbon/human/owner
	//do we need to change what their head looks like
	var/custom_head_icon
	var/custom_head_icon_state
	//keep track of your relay
	var/obj/item/dullahan_relay/relay

/datum/component/dullahan/Initialize()
	if(ishuman(parent))
		owner = parent
		if(owner.health > 0)
			DISABLE_BITFIELD(owner.flags_1, HEAR_1)
			var/obj/item/bodypart/head/head = owner.get_bodypart(BODY_ZONE_HEAD)
			if(head)
				//give the new organs
				var/obj/item/organ/brain/brain = owner.getorganslot(ORGAN_SLOT_BRAIN)
				if(brain)
					brain.Remove(TRUE,TRUE)
					QDEL_NULL(brain)
					var/obj/item/organ/brain/new_brain = new /obj/item/organ/brain/dullahan
					new_brain.Insert(owner, TRUE, TRUE)
				var/obj/item/organ/tongue/tongue = owner.getorganslot(ORGAN_SLOT_TONGUE)
				var/list/accents
				if(tongue)
					accents = tongue.accents
					tongue.Remove(TRUE,TRUE)
					QDEL_NULL(tongue)
					var/obj/item/organ/tongue/new_tongue = new /obj/item/organ/tongue/dullahan
					if(accents)
						new_tongue.accents = accents + new_tongue.accents //dullahan accent needs to be last applied
					new_tongue.Insert(owner, TRUE, TRUE)
				var/obj/item/organ/ears/ears = owner.getorganslot(ORGAN_SLOT_EARS)
				if(ears)
					ears.Remove(TRUE,TRUE)
					QDEL_NULL(ears)
					var/obj/item/organ/ears/new_ears = new /obj/item/organ/ears/dullahan
					new_ears.Insert(owner, TRUE, TRUE)
				var/obj/item/organ/eyes/eyes = owner.getorganslot(ORGAN_SLOT_EYES)
				if(eyes)
					eyes.Remove(TRUE,TRUE)
					QDEL_NULL(eyes)
					var/obj/item/organ/eyes/new_eyes = new /obj/item/organ/eyes/dullahan
					new_eyes.Insert(owner, TRUE, TRUE)

				var/obj/item/bodypart/head/dullahan/dullahan_head = new
				//handle the head
				if(has_custom_head())
					dullahan_head.icon = custom_head_icon
					dullahan_head.icon_state = custom_head_icon_state
					dullahan_head.custom_head = TRUE
				for(var/X in list(owner.glasses, owner.ears, owner.wear_mask, owner.head))
					var/obj/item/I = X
					if(I)
						I.forceMove(dullahan_head)
				dullahan_head.dullahan_eyes = owner.glasses
				dullahan_head.dullahan_ears = owner.ears
				dullahan_head.dullahan_mask = owner.wear_mask
				dullahan_head.dullahan_hat = owner.head
				qdel(head)
				dullahan_head.update_all_overlays(owner)
				relay = new /obj/item/dullahan_relay (dullahan_head, owner)
				owner.put_in_hands(dullahan_head)
				var/obj/item/organ/eyes/E = owner.getorganslot(ORGAN_SLOT_EYES)
				for(var/datum/action/item_action/organ_action/OA in E.actions)
					OA.Trigger()
		else
			RemoveComponent()
	else
		//they shouldn't have this component!
		RemoveComponent()

/datum/component/dullahan/RemoveComponent()
	//delete their organs and regenerate them to their species specific ones, remove accent from tongue, place head on body
	..()

/datum/component/dullahan/proc/has_custom_head()
	return (custom_head_icon && custom_head_icon_state)

//dullahan vision
/datum/component/dullahan/proc/update_vision_perspective(mob/living/carbon/human/H)
	var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		H.update_tint()
		if(eyes.tint)
			H.reset_perspective(H)
		else
			H.reset_perspective(relay)

//dullahan organs
/obj/item/organ/brain/dullahan
	decoy_override = TRUE
	organ_flags = ORGAN_NO_SPOIL//Do not decay

/obj/item/organ/tongue/dullahan
	zone = "abstract"
	initial_accents = list(/datum/accent/dullahan)

/obj/item/organ/ears/dullahan
	zone = "abstract"

/obj/item/organ/eyes/dullahan
	name = "head vision"
	desc = "An abstraction."
	actions_types = list(/datum/action/item_action/organ_action/dullahan)
	zone = "abstract"
	tint = INFINITY // used to switch the vision perspective to the head.

/datum/action/item_action/organ_action/dullahan
	name = "Toggle Perspective"
	desc = "Switch between seeing normally from your head, or blindly from your body."

/datum/action/item_action/organ_action/dullahan/Trigger()
	. = ..()
	var/obj/item/organ/eyes/dullahan/DE = target
	if(DE.tint)
		DE.tint = 0
	else
		DE.tint = INFINITY

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(isdullahan(H))
			var/datum/component/dullahan/D = H.GetComponent(/datum/component/dullahan)
			D.update_vision_perspective(H)

//dullahan relays
/obj/item/dullahan_relay
	name = "dullahan relay"
	var/mob/living/owner
	flags_1 = HEAR_1

/obj/item/dullahan_relay/Initialize(mapload, mob/living/carbon/human/new_owner)
	. = ..()
	if(!new_owner)
		return INITIALIZE_HINT_QDEL
	owner = new_owner
	START_PROCESSING(SSobj, src)
	RegisterSignal(owner, COMSIG_MOB_CLICKED_SHIFT_ON, .proc/examinate_check)
	RegisterSignal(src, COMSIG_ATOM_HEARER_IN_VIEW, .proc/include_owner)
	RegisterSignal(owner, COMSIG_LIVING_REGENERATE_LIMBS, .proc/unlist_head)
	RegisterSignal(owner, COMSIG_LIVING_REVIVE, .proc/retrieve_head)

/obj/item/dullahan_relay/proc/examinate_check(mob/source, atom/target)
	if(source.client.eye == src)
		return COMPONENT_ALLOW_EXAMINATE

/obj/item/dullahan_relay/proc/include_owner(datum/source, list/processing_list, list/hearers)
	if(!QDELETED(owner))
		hearers += owner

/obj/item/dullahan_relay/proc/unlist_head(datum/source, noheal = FALSE, list/excluded_limbs)
	excluded_limbs |= BODY_ZONE_HEAD // So we don't gib when regenerating limbs.

//Retrieving the owner's head for better ahealing.
/obj/item/dullahan_relay/proc/retrieve_head(datum/source, full_heal, admin_revive)
	if(admin_revive)
		var/obj/item/bodypart/head/H = loc
		var/turf/T = get_turf(owner)
		if(H && istype(H) && T && !(H in owner.GetAllContents()))
			H.forceMove(T)

/obj/item/dullahan_relay/process()
	if(!istype(loc, /obj/item/bodypart/head) || QDELETED(owner))
		. = PROCESS_KILL
		qdel(src)

/obj/item/dullahan_relay/Destroy()
	if(!QDELETED(owner))
		var/mob/living/carbon/human/H = owner
		if(isdullahan(H))
			var/datum/component/dullahan/D = H.GetComponent(/datum/component/dullahan)
			D.relay = null
			owner.gib()
	owner = null
	..()

//custom dullahan head that makes this shitcode easier to do
/obj/item/bodypart/head/dullahan
	//accessories the head can wear
	var/obj/item/dullahan_hat
	var/obj/item/dullahan_mask
	var/obj/item/dullahan_ears
	var/obj/item/dullahan_eyes

//proc that grabs clothing items inside a head and renders them on the head
/obj/item/bodypart/head/dullahan/proc/update_dismembered_accessory_overlays(mob/living/carbon/human/the_dullahan, item_type)
	//make sure we physically have enough slots in the overlays for it
	while(length(overlays) < TOTAL_LAYERS)
		overlays += null
	if(!owner) //why are you doing this if it's not dismembered
		var/obj/item/head_accessory
		var/accessory_layer
		var/accessory_offset
		var/accessory_icon_file
		switch(item_type) //these go off the worn item slot number
			if(SLOT_WEAR_MASK) //mask
				head_accessory = dullahan_mask
				accessory_layer = FACEMASK_LAYER
				accessory_offset = OFFSET_FACEMASK
				accessory_icon_file = 'icons/mob/clothing/mask.dmi'
			if(SLOT_HEAD) //head
				head_accessory = dullahan_hat
				accessory_layer = HEAD_LAYER
				accessory_offset = OFFSET_HEAD
				accessory_icon_file = 'icons/mob/clothing/head.dmi'
			if(SLOT_EARS) //ears
				head_accessory = dullahan_ears
				accessory_layer = EARS_LAYER
				accessory_offset = OFFSET_EARS
				accessory_icon_file = 'icons/mob/ears.dmi'
			if(SLOT_GLASSES) //eyes
				head_accessory = dullahan_eyes
				accessory_layer = GLASSES_LAYER
				accessory_offset = OFFSET_GLASSES
				accessory_icon_file = 'icons/mob/clothing/eyes.dmi'
		if(head_accessory)
			message_admins("the index is [accessory_layer]")
			var/mutable_appearance/accessory_overlay = head_accessory.build_worn_icon(default_layer = accessory_layer, default_icon_file = accessory_icon_file, override_state = head_accessory.icon_state)
			if(accessory_overlay)
				if(accessory_offset in the_dullahan.dna.species.offset_features)
					accessory_overlay.pixel_x += the_dullahan.dna.species.offset_features[accessory_offset][1]
					accessory_overlay.pixel_y += the_dullahan.dna.species.offset_features[accessory_offset][2]
				add_overlay(list(accessory_overlay))

/obj/item/bodypart/head/dullahan/proc/update_all_overlays(mob/living/carbon/human/the_dullahan)
	cut_overlays()
	if(dullahan_mask)
		update_dismembered_accessory_overlays(the_dullahan, SLOT_WEAR_MASK)
	if(dullahan_hat)
		update_dismembered_accessory_overlays(the_dullahan, SLOT_HEAD)
	if(dullahan_ears)
		update_dismembered_accessory_overlays(the_dullahan, SLOT_EARS)
	if(dullahan_eyes)
		update_dismembered_accessory_overlays(the_dullahan, SLOT_GLASSES)
