/obj/structure/closet/secure_closet/personal
	desc = "It's a secure locker for personnel. The first card swiped gains control."
	name = "personal closet"
	req_access = list(ACCESS_ALL_PERSONAL_LOCKERS)
	var/registered_name = null

/obj/structure/closet/secure_closet/personal/examine(mob/user)
	. = ..()
	if(registered_name)
		. += "<span class='notice'>The display reads, \"Owned by [registered_name]\".</span>"

/obj/structure/closet/secure_closet/personal/check_access(obj/item/I)
	. = ..()
	if(!I || !istype(I))
		return
	if(istype(I,/obj/item/modular_computer/tablet))
		var/obj/item/modular_computer/tablet/ourTablet = I
		var/obj/item/computer_hardware/card_slot/card_slot = ourTablet.all_components[MC_CARD]
		if(card_slot)
			return registered_name == card_slot.stored_card.registered_name || registered_name == card_slot.stored_card2.registered_name
	var/obj/item/card/id/ID = I.GetID()
	if(ID && registered_name == ID.registered_name)
		return TRUE
	return FALSE

/obj/structure/closet/secure_closet/personal/PopulateContents()
	..()
	if(prob(50))
		new /obj/item/storage/backpack/duffelbag(src)
	if(prob(50))
		new /obj/item/storage/backpack(src)
	else
		new /obj/item/storage/backpack/satchel(src)
	new /obj/item/radio/headset( src )

/obj/structure/closet/secure_closet/personal/patient
	name = "patient's closet"

/obj/structure/closet/secure_closet/personal/patient/PopulateContents()
	new /obj/item/clothing/under/color/white( src )
	new /obj/item/clothing/shoes/sneakers/white( src )

/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinet"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	material_drop = /obj/item/stack/sheet/mineral/wood
	cutting_tool = /obj/item/screwdriver

/obj/structure/closet/secure_closet/personal/cabinet/PopulateContents()
	new /obj/item/storage/backpack/satchel/leather/withwallet( src )
	new /obj/item/instrument/piano_synth(src)
	new /obj/item/radio/headset( src )
	new /obj/item/clothing/head/colour(src)

/obj/structure/closet/secure_closet/personal/attackby(obj/item/W, mob/user, params)
	var/obj/item/card/id/I = W.GetID()
	if(!I || !istype(I))
		return ..()
	if(!can_lock(user, FALSE)) //Can't do anything if there isn't a lock!
		return
	if(I.registered_name && !registered_name)
		to_chat(user, "<span class='notice'>You claim [src].</span>")
		registered_name = I.registered_name
	else
		..()

/obj/structure/closet/secure_closet/personal/handle_lock_addition() //If lock construction is successful we don't care what access the electronics had, so we override it
	if(..())
		req_access = list(ACCESS_ALL_PERSONAL_LOCKERS)
		lockerelectronics.accesses = req_access

/obj/structure/closet/secure_closet/personal/handle_lock_removal()
	if(..())
		registered_name = null
