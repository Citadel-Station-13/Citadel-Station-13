/obj/item/storage/wallet
	name = "wallet"
	desc = "It can hold a few small and personal things."
	icon_state = "wallet"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_ID

	var/obj/item/card/id/front_id = null
	var/list/combined_access

/obj/item/storage/wallet/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 4
	STR.cant_hold = typecacheof(list(/obj/item/screwdriver/power))
	STR.can_hold = typecacheof(list(
		/obj/item/stack/spacecash,
		/obj/item/card,
		/obj/item/clothing/mask/cigarette,
		/obj/item/flashlight/pen,
		/obj/item/seeds,
		/obj/item/stack/medical,
		/obj/item/toy/crayon,
		/obj/item/coin,
		/obj/item/dice,
		/obj/item/disk,
		/obj/item/implanter,
		/obj/item/lighter,
		/obj/item/lipstick,
		/obj/item/match,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/photo,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/syringe,
		/obj/item/screwdriver,
		/obj/item/valentine,
		/obj/item/stamp,
		/obj/item/key,
		/obj/item/cartridge,
		/obj/item/camera_film,
		/obj/item/stack/ore/bluespace_crystal,
		/obj/item/reagent_containers/food/snacks/grown/poppy,
		/obj/item/instrument/harmonica,
		/obj/item/mining_voucher,
		/obj/item/suit_voucher,
		/obj/item/reagent_containers/pill))

/obj/item/storage/wallet/Exited(atom/movable/AM)
	. = ..()
	refreshID()

/obj/item/storage/wallet/proc/refreshID()
	LAZYCLEARLIST(combined_access)
	if(!(front_id in src))
		front_id = null
	for(var/obj/item/card/id/I in contents)
		if(!front_id)
			front_id = I
		LAZYINITLIST(combined_access)
		combined_access |= I.access
	update_icon()

/obj/item/storage/wallet/Entered(atom/movable/AM)
	. = ..()
	refreshID()

/obj/item/storage/wallet/update_icon_state()
	var/new_state = "wallet"
	if(front_id)
		new_state = "wallet_id"
	if(new_state != icon_state)		//avoid so many icon state changes.
		icon_state = new_state

/obj/item/storage/wallet/GetID()
	return front_id

/obj/item/storage/wallet/RemoveID()
	if(!front_id)
		return
	. = front_id
	front_id.forceMove(get_turf(src))

/obj/item/storage/wallet/InsertID(obj/item/inserting_item)
	var/obj/item/card/inserting_id = inserting_item.RemoveID()
	if(!inserting_id)
		return FALSE
	attackby(inserting_id)
	if(inserting_id in contents)
		return TRUE
	return FALSE

/obj/item/storage/wallet/GetAccess()
	if(LAZYLEN(combined_access))
		return combined_access
	else
		return ..()

/obj/item/storage/wallet/random
	icon_state = "random_wallet"

/obj/item/storage/wallet/random/PopulateContents()
	var/item1_type = pick( /obj/item/stack/spacecash/c10, /obj/item/stack/spacecash/c100, /obj/item/stack/spacecash/c1000, /obj/item/stack/spacecash/c20, /obj/item/stack/spacecash/c200, /obj/item/stack/spacecash/c50, /obj/item/stack/spacecash/c500)
	var/item2_type
	if(prob(50))
		item2_type = pick( /obj/item/stack/spacecash/c10, /obj/item/stack/spacecash/c100, /obj/item/stack/spacecash/c1000, /obj/item/stack/spacecash/c20, /obj/item/stack/spacecash/c200, /obj/item/stack/spacecash/c50, /obj/item/stack/spacecash/c500)
	var/item3_type = pick( /obj/item/coin/silver, /obj/item/coin/silver, /obj/item/coin/gold, /obj/item/coin/iron, /obj/item/coin/iron, /obj/item/coin/iron )

	spawn(2)
		if(item1_type)
			new item1_type(src)
		if(item2_type)
			new item2_type(src)
		if(item3_type)
			new item3_type(src)
	update_icon()
