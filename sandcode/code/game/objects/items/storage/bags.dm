/*
 *  Construction bag (for engineering, holds stock parts and electronics)
 */

/obj/item/storage/bag/construction
	name = "construction bag"
	icon = 'sandcode/icons/obj/tools.dmi'
	icon_state = "construction_bag"
	desc = "A bag for storing small construction components."
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE

/obj/item/storage/bag/construction/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 100
	STR.max_items = 50
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.insert_preposition = "in"
	STR.can_hold = typecacheof(list(/obj/item/stack/ore/bluespace_crystal, /obj/item/assembly, /obj/item/stock_parts, /obj/item/reagent_containers/glass/beaker, /obj/item/stack/cable_coil, /obj/item/circuitboard, /obj/item/electronics, /obj/item/wallframe/camera))
