
//For custom items.

/obj/item/custom/ceb_soap
	name = "Cebutris' Soap"
	desc = "A generic bar of soap that doesn't really seem to work right."
	gender = PLURAL
	icon = 'icons/obj/custom.dmi'
	icon_state = "cebu"
	w_class = WEIGHT_CLASS_TINY
	flags_1 = NOBLUDGEON_1

/obj/item/clothing/neck/cloak/inferno
	name = "Kiara's Cloak"
	desc = "The design on this seems a little too familiar."
	icon = 'icons/obj/clothing/cloaks.dmi'
	icon_state = "infcloak"
	item_state = "infcloak"
	w_class = WEIGHT_CLASS_SMALL
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/lighter/gold
	name = "\improper Engraved Zippo"
	desc = "A shiny and relatively expensive zippo lighter. There's a small etched in verse on the bottom that reads, 'No Gods, No Masters, Only Man.'"
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "gold_zippo"
	item_state = "gold_zippo"
	w_class = WEIGHT_CLASS_TINY
	flags_1 = CONDUCT_1
	slot_flags = SLOT_BELT
	heat = 1500
	resistance_flags = FIRE_PROOF
	light_color = LIGHT_COLOR_FIRE