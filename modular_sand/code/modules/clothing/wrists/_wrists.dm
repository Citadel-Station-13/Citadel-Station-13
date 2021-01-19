//wrist items (now we do, ha ha!)
/obj/item/clothing/wrists
	name = "slap bracelet"
	desc = "oh no."
	gender = PLURAL //change this if it is for a single wrist
	w_class = WEIGHT_CLASS_SMALL
	icon = 'modular_sand/icons/obj/clothing/wrist.dmi'
	mob_overlay_icon = 'modular_sand/icons/mob/clothing/wrists.dmi'
	siemens_coefficient = 0.5
	body_parts_covered = HANDS
	slot_flags = ITEM_SLOT_WRISTS
	attack_verb = list("slapped on the wrist")
	strip_delay = 20
	equip_delay_other = 40
