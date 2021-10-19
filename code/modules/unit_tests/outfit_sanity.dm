#define CHECK_OUTFIT_SLOT(outfit_key, slot_name) if (outfit.##outfit_key) { \
	H.equip_to_slot_or_del(new outfit.##outfit_key(H), ##slot_name, TRUE); \
	/* We don't check the result of equip_to_slot_or_del because it returns false for random jumpsuits, as they delete themselves on init */ \
	if (!H.get_item_by_slot(##slot_name)) { \
		Fail("[outfit.name]'s [#outfit_key] is invalid!"); \
	} \
}

/datum/unit_test/outfit_sanity/Run()
	var/mob/living/carbon/human/H = allocate(/mob/living/carbon/human)

	for (var/outfit_type in subtypesof(/datum/outfit))
		// Only make one human and keep undressing it because it's much faster
		for (var/obj/item/I in H.get_equipped_items(include_pockets = TRUE))
			qdel(I)

		var/datum/outfit/outfit = new outfit_type
		outfit.pre_equip(H, TRUE)

		CHECK_OUTFIT_SLOT(uniform, SLOT_FLAG_UNIFORM)
		CHECK_OUTFIT_SLOT(suit, SLOT_FLAG_SUIT)
		CHECK_OUTFIT_SLOT(back, SLOT_FLAG_BACK)
		CHECK_OUTFIT_SLOT(belt, SLOT_FLAG_BELT)
		CHECK_OUTFIT_SLOT(gloves, SLOT_FLAG_GLOVES)
		CHECK_OUTFIT_SLOT(shoes, SLOT_FLAG_FEET)
		CHECK_OUTFIT_SLOT(head, SLOT_FLAG_HEAD)
		CHECK_OUTFIT_SLOT(mask, SLOT_FLAG_MASK)
		CHECK_OUTFIT_SLOT(neck, SLOT_FLAG_NECK)
		CHECK_OUTFIT_SLOT(ears, SLOT_FLAG_EARS)
		CHECK_OUTFIT_SLOT(glasses, SLOT_FLAG_EYES)
		CHECK_OUTFIT_SLOT(id, SLOT_FLAG_ID)
		CHECK_OUTFIT_SLOT(suit_store, SLOT_FLAG_SUITSTORE)
		CHECK_OUTFIT_SLOT(l_pocket, ITEM_SLOT_LPOCKET)
		CHECK_OUTFIT_SLOT(r_pocket, ITEM_SLOT_RPOCKET)

		if (outfit.backpack_contents || outfit.box)
			var/list/backpack_contents = outfit.backpack_contents?.Copy()
			if (outfit.box)
				if (!backpack_contents)
					backpack_contents = list()
				backpack_contents.Insert(1, outfit.box)
				backpack_contents[outfit.box] = 1

			for (var/path in backpack_contents)
				var/number = backpack_contents[path] || 1
				for (var/_ in 1 to number)
					if (!H.equip_to_slot_or_del(new path(H), SLOT_FLAG_BACKPACK, TRUE))
						Fail("[outfit.name]'s backpack_contents are invalid! Couldn't add [path] to backpack.")

#undef CHECK_OUTFIT_SLOT
