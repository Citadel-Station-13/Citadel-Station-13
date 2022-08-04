/datum/component/dullahan
	var/obj/item/dullahan_head/dullahan_head


/datum/component/dullahan/Initialize()
	var/mob/living/carbon/human/H = parent
	if(!H)
		return

	dullahan_head = new(get_turf(H))

	dullahan_head.name = "[H.name]'s head"
	dullahan_head.desc = "the decapitated head of [H.name]"
	dullahan_head.owner = H

	// make sure the brain can't decay or fall out
	var/obj/item/organ/brain/B = H.getorganslot(ORGAN_SLOT_BRAIN)
	B.zone = "abstract" // it exists in the ethereal plain
	B.organ_flags = ORGAN_NO_SPOIL | ORGAN_NO_DISMEMBERMENT	| ORGAN_VITAL

	// moving the brain's zone means we don't need the head to survive
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	head.drop_limb()
	qdel(head)

	dullahan_head.update_appearance()

/obj/item/dullahan_head
	name = "coders lament"
	desc = "you shouldn't be reading this"
	flags_1 = HEAR_1
	var/mob/living/carbon/human/owner
	// this is for keeping track of the overlays because you can't read the actual overlays list as it's a special byond var
	var/list/overlays_standing

// allow the 'fake' head to relay speech back to the mob
/obj/item/dullahan_head/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, message_mode)
	if(owner)
		var/namepart = "[speaker.GetVoice()][speaker.get_alt_name()]"
		var/hrefpart = "<a href='?src=[REF(src)];track=[html_encode(namepart)]'>"
		var/treated_message = lang_treat(speaker, message_language, raw_message, spans, message_mode)
		var/rendered = "<i><span class='game say'><span class='name'>[hrefpart][namepart]</a> </span><span class='message'>[treated_message]</span></span></i>"

		if (owner.client?.prefs.chat_on_map && (owner.client.prefs.see_chat_non_mob || ismob(speaker)))
			owner.create_chat_message(speaker, message_language, raw_message, spans, message_mode)
		owner.show_message(rendered, MSG_AUDIBLE)

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
	owner.regenerate_icons() // yes i know it's expensive but do you want me to rewrite our entire overlay system
	var/obj/item/bodypart/head/head = owner.get_bodypart(BODY_ZONE_HEAD)
	add_overlay(head.get_limb_icon(FALSE, TRUE, TRUE))
	for(var/overlay in owner.overlays_standing)
		if(istype(overlay, /mutable_appearance))
			var/mutable_appearance/mutable = overlay
			message_admins("category is [mutable.category] and icon is [mutable.icon_state]")
			if(mutable.category == "HEAD")
				add_head_overlay(mutable)
		else
			if(islist(overlay))
				var/list/list_appearances = overlay
				for(var/overlay2 in list_appearances)
					if(istype(overlay2, /mutable_appearance))
						var/mutable_appearance/mutable = overlay2
						message_admins("category is [mutable.category] and icon is [mutable.icon_state]")
						if(mutable.category == "HEAD")
							add_head_overlay(mutable)
	//head.drop_limb()
	//qdel(head)