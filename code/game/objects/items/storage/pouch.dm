/obj/item/storage/pouch
	name = "pouch"
	desc = "Can hold various things."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "ammopouch"
	slot_flags = ITEM_SLOT_POCKET
	max_integrity = 200

/obj/item/storage/pouch/ammo
	name = "ammo pouch"
	desc = "A pouch for your ammo that goes in your pocket."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "ammopouch"
	slot_flags = ITEM_SLOT_POCKET
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FLAMMABLE

/obj/item/storage/pouch/ammo/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 30
	STR.max_items = 3
	STR.display_numerical_stacking = FALSE
	STR.can_hold = typecacheof(list(/obj/item/ammo_box/magazine, /obj/item/ammo_casing))