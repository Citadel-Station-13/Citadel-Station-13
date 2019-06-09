/datum/outfit
	var/name = "Naked"

	var/uniform = null
	var/suit = null
	var/toggle_helmet = TRUE
	var/back = null
	var/belt = null
	var/gloves = null
	var/shoes = null
	var/head = null
	var/mask = null
	var/neck = null
	var/ears = null
	var/glasses = null
	var/id = null
	var/l_pocket = null
	var/r_pocket = null
	var/suit_store = null
	var/r_hand = null
	var/l_hand = null
	var/internals_slot = null //ID of slot containing a gas tank
	var/list/backpack_contents = null // In the list(path=count,otherpath=count) format
	var/list/implants = null
	var/accessory = null

	var/can_be_admin_equipped = TRUE // Set to FALSE if your outfit requires runtime parameters
	var/list/chameleon_extras //extra types for chameleon outfit changes, mostly guns

/datum/outfit/proc/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	//to be overridden for customization depending on client prefs,species etc
	return

/datum/outfit/proc/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	//to be overridden for toggling internals, id binding, access etc
	return

#define OUTFIT_SETUP(path, slot, mob, cryo_destroy)\
	var/obj/item/__CURRENT = new path(mob);\
	mob.equip_to_slot_or_del(__CURRENT, slot);\
	if(cryo_destroy)\
		__CURRENT.item_flags |= CRYO_DELETE

/datum/outfit/proc/equip(mob/living/carbon/human/H, visualsOnly = FALSE, cryo_destroy = FALSE)
	pre_equip(H, visualsOnly)

	//Start with uniform,suit,backpack for additional slots
	if(uniform)
		OUTFIT_SETUP(uniform, SLOT_W_UNIFORM, H, cryo_destroy)
	if(suit)
		OUTFIT_SETUP(suit, SLOT_WEAR_SUIT, H, cryo_destroy)
	if(back)
		OUTFIT_SETUP(back, SLOT_BACK, H, cryo_destroy)
	if(belt)
		OUTFIT_SETUP(belt, SLOT_BELT, H, cryo_destroy)
	if(gloves)
		OUTFIT_SETUP(gloves, SLOT_GLOVES, H, cryo_destroy)
	if(shoes)
		OUTFIT_SETUP(shoes, SLOT_SHOES, H, cryo_destroy)
	if(head)
		OUTFIT_SETUP(head, SLOT_HEAD, H, cryo_destroy)
	if(mask)
		OUTFIT_SETUP(mask, SLOT_WEAR_MASK, H, cryo_destroy)
	if(neck)
		OUTFIT_SETUP(neck, SLOT_NECK, H, cryo_destroy)
	if(ears)
		OUTFIT_SETUP(ears, SLOT_EARS, H, cryo_destroy)
	if(glasses)
		OUTFIT_SETUP(glasses, SLOT_GLASSES, H, cryo_destroy)
	if(id)
		OUTFIT_SETUP(id, SLOT_WEAR_ID, H, cryo_destroy)
	if(suit_store)
		OUTFIT_SETUP(suit_store, SLOT_S_STORE, H, cryo_destroy)

	if(accessory)
		var/obj/item/clothing/under/U = H.w_uniform
		if(U)
			var/obj/item/A = new accessory(H)
			if(cryo_destroy)
				A.item_flags |= CRYO_DELETE
			U.attach_accessory(A)
		else
			WARNING("Unable to equip accessory [accessory] in outfit [name]. No uniform present!")

	if(l_hand)
		var/obj/item/I = new l_hand(H)
		if(cryo_destroy)
			H.item_flags |= CRYO_DELETE
		H.put_in_l_hand(I)
	if(r_hand)
		var/obj/item/I = new r_hand(H)
		if(cryo_destroy)
			H.item_flags |= CRYO_DELETE
		H.put_in_r_hand(I)

	if(!visualsOnly) // Items in pockets or backpack don't show up on mob's icon.
		if(l_pocket)
			var/obj/item/I = new l_pocket(H)
			if(cryo_destroy)
				H.item_flags |= CRYO_DELETE
			H.equip_to_slot_or_del(I, SLOT_L_STORE)
		if(r_pocket)
			var/obj/item/I = new r_pocket(H)
			if(cryo_destroy)
				H.item_flags |= CRYO_DELETE
			H.equip_to_slot_or_del(I, SLOT_R_STORE)
		if(backpack_contents)
			for(var/path in backpack_contents)
				var/number = backpack_contents[path]
				if(!isnum(number))//Default to 1
					number = 1
				for(var/i in 1 to number)
					OUTFIT_SETUP(path, SLOT_IN_BACKPACK, H, cryo_destroy)

	if(!H.head && toggle_helmet && istype(H.wear_suit, /obj/item/clothing/suit/space/hardsuit))
		var/obj/item/clothing/suit/space/hardsuit/HS = H.wear_suit
		HS.ToggleHelmet()

	post_equip(H, visualsOnly)

	if(!visualsOnly)
		apply_fingerprints(H)
		if(internals_slot)
			H.internal = H.get_item_by_slot(internals_slot)
			H.update_action_buttons_icon()
		if(implants)
			for(var/implant_type in implants)
				var/obj/item/implant/I = new implant_type(H)
				I.implant(H, null, TRUE)

	H.update_body()
	return TRUE

#undef OUTFIT_SETUP

/datum/outfit/proc/apply_fingerprints(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(H.back)
		H.back.add_fingerprint(H,1)	//The 1 sets a flag to ignore gloves
		for(var/obj/item/I in H.back.contents)
			I.add_fingerprint(H,1)
	if(H.wear_id)
		H.wear_id.add_fingerprint(H,1)
	if(H.w_uniform)
		H.w_uniform.add_fingerprint(H,1)
	if(H.wear_suit)
		H.wear_suit.add_fingerprint(H,1)
	if(H.wear_mask)
		H.wear_mask.add_fingerprint(H,1)
	if(H.wear_neck)
		H.wear_neck.add_fingerprint(H,1)
	if(H.head)
		H.head.add_fingerprint(H,1)
	if(H.shoes)
		H.shoes.add_fingerprint(H,1)
	if(H.gloves)
		H.gloves.add_fingerprint(H,1)
	if(H.ears)
		H.ears.add_fingerprint(H,1)
	if(H.glasses)
		H.glasses.add_fingerprint(H,1)
	if(H.belt)
		H.belt.add_fingerprint(H,1)
		for(var/obj/item/I in H.belt.contents)
			I.add_fingerprint(H,1)
	if(H.s_store)
		H.s_store.add_fingerprint(H,1)
	if(H.l_store)
		H.l_store.add_fingerprint(H,1)
	if(H.r_store)
		H.r_store.add_fingerprint(H,1)
	for(var/obj/item/I in H.held_items)
		I.add_fingerprint(H,1)
	return 1

/datum/outfit/proc/get_chameleon_disguise_info()
	var/list/types = list(uniform, suit, back, belt, gloves, shoes, head, mask, neck, ears, glasses, id, l_pocket, r_pocket, suit_store, r_hand, l_hand)
	types += chameleon_extras
	listclearnulls(types)
	return types
