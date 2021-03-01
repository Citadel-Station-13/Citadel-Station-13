/obj/item/clothing/gloves
	var/dummy_thick = FALSE // is able to hold accessories on its item
	//SKYRAT EDIT - Removed the old attached accessory system. We use a list of accessories instead.
	var/list/obj/item/clothing/accessory/ring/attached_accessories = list()
	var/max_accessories = 1
	//SKYRAT EDIT END
	var/mutable_appearance/accessory_overlay

/obj/item/clothing/gloves/worn_overlays(isinhands = FALSE, icon_file, used_state, style_flags = NONE)
	. = ..()
	if(!isinhands)
		if(accessory_overlay)
			. += accessory_overlay

/obj/item/clothing/gloves/attackby(obj/item/I, mob/user, params)
	if(!attach_accessory(I, user))
		return ..()

/obj/item/clothing/gloves/AltClick(mob/user)
	. = ..()
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	if(length(attached_accessories)) //SKYRAT EDIT
		remove_accessory(user)

/obj/item/clothing/gloves/equipped(mob/user, slot)
	..()

	//SKYRAT EDIT
	for(var/obj/item/clothing/accessory/ring/attached_accessory in attached_accessories)
		if(attached_accessory && slot != SLOT_HANDS && ishuman(user))
			var/mob/living/carbon/human/H = user
			attached_accessory.on_uniform_equip(src, user)
			if(attached_accessory.above_suit)
				H.update_inv_wear_suit()
	//SKYRAT EDIT END

/obj/item/clothing/gloves/dropped(mob/user)
	//SKYRAT EDIT
	for(var/obj/item/clothing/accessory/ring/attached_accessory in attached_accessories)
		attached_accessory.on_uniform_dropped(src, user)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(attached_accessory.above_suit)
				H.update_inv_wear_suit()
	//SKYRAT EDIT END
	..()

/obj/item/clothing/gloves/proc/attach_accessory(obj/item/I, mob/user, notifyAttach = 1)
	. = FALSE
	if(istype(I, /obj/item/clothing/accessory/ring))
		var/obj/item/clothing/accessory/ring/A = I
		if(length(attached_accessories) >= max_accessories)
			if(user)
				to_chat(user, "<span class='warning'>[src] already has [length(attached_accessories)] accessories.</span>")
			return
		if(dummy_thick)
			if(user)
				to_chat(user, "<span class='warning'>[src] is too bulky and cannot have accessories attached to it!</span>")
			return
		else
			if(user && !user.temporarilyRemoveItemFromInventory(I))
				return
			if(!A.attach(src, user))
				return

			if(user && notifyAttach)
				to_chat(user, "<span class='notice'>You attach [I] to [src].</span>")

			if((flags_inv & HIDEACCESSORY) || (A.flags_inv & HIDEACCESSORY))
				return TRUE

			//SKYRAT EDIT
			accessory_overlay = mutable_appearance(I.mob_overlay_icon, I.item_state)
			for(var/obj/item/clothing/accessory/ring/attached_accessory in attached_accessories)
				var/mutable_appearance/Y = mutable_appearance(attached_accessory.mob_overlay_icon, attached_accessory.icon_state, ABOVE_HUD_LAYER)
				Y.alpha = attached_accessory.alpha
				Y.color = attached_accessory.color
				accessory_overlay.add_overlay(Y)
			//SKYRAT EDIT END

			if(ishuman(loc))
				var/mob/living/carbon/human/H = loc
				H.update_inv_gloves()

			return TRUE

/obj/item/clothing/gloves/proc/remove_accessory(mob/user)
	if(!isliving(user))
		return
	if(!can_use(user))
		return

	//SKYRAT EDIT
	if(length(attached_accessories))
		var/obj/item/clothing/accessory/ring/A = attached_accessories[length(attached_accessories)]
	//SKYRAT EDIT END
		A.detach(src, user)
		if(user.put_in_hands(A))
			to_chat(user, "<span class='notice'>You detach [A] from [src].</span>")
		else
			to_chat(user, "<span class='notice'>You detach [A] from [src] and it falls on the floor.</span>")

		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			H.update_inv_gloves()

/obj/item/clothing/gloves/examine(mob/user)
	. = ..()
	if(length(attached_accessories))
		for(var/obj/item/clothing/accessory/ring/attached_accessory in attached_accessories)
			. += "\A [attached_accessory] is attached to one of it's fingers."
