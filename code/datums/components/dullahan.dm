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
				if(tongue)
					tongue.accents += new /datum/accent/dullahan
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

				//handle the head
				if(has_custom_head())
					head.icon = custom_head_icon
					head.icon_state = custom_head_icon_state
					head.custom_head = TRUE
				head.drop_limb()
				if(!QDELETED(head)) //drop_limb() deletes the limb if it's no drop location and dummy humans used for rendering icons are located in nullspace. Do the math.
					head.throwforce = 25
					relay = new /obj/item/dullahan_relay (head, owner)
					owner.put_in_hands(head)
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
	accents = list(/datum/accent/dullahan)

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
