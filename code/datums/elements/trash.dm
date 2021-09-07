/datum/element/trash
	element_flags = ELEMENT_DETACH

/datum/element/trash/Attach(datum/target)
	. = ..()
	RegisterSignal(target, COMSIG_ITEM_ATTACK, .proc/UseFromHand)

/datum/element/trash/proc/UseFromHand(obj/item/source, mob/living/M, mob/living/user)
	if((M == user || user.vore_flags & TRASH_FORCEFEED) && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(HAS_TRAIT(H, TRAIT_TRASHCAN))
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			if(H.vore_selected)
				H.visible_message("<span class='notice'>[H] [H.vore_selected.vore_verb]s the [source] into their [H.vore_selected]</span>",
					"<span class='notice'>You [H.vore_selected.vore_verb]s the [source] into your [H.vore_selected]</span>")
				source.forceMove(H.vore_selected)
			else
				H.visible_message("<span class='notice'>[H] consumes the [source].")
				qdel(source)
