/obj/item/storage/backpack/case
	name = "compartment case"
	desc = "A large compartment case for holding lots of things."
	icon = 'modular_sand/icons/obj/storage.dmi'
	icon_state = "infiltrator_case_basic"
	item_state = "infiltrator_case_basic"
	slot_flags = null

/obj/item/storage/backpack/case/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 25
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_items = 25

/obj/item/storage/backpack/case/security
	name = "secure compartment case"
	desc = "It's a case for people that wanna hurt people."
	icon_state = "infiltrator_case_security"
	item_state = "infiltrator_case_security"

/obj/item/storage/backpack/case/command
	name = "command compartment case"
	desc = "It's a special case made exclusively for Nanotrasen officers."
	icon_state = "infiltrator_case_command"
	item_state = "infiltrator_case_command"

/obj/item/storage/backpack/case/medical
	name = "medical compartment case"
	desc = "It's a case especially designed for keeping everything to save a fellow co-worker."
	icon_state = "infiltrator_case_medical"
	item_state = "infiltrator_case_medical"

/obj/item/storage/backpack/case/engineering
	name = "industrial compartment case"
	desc = "A large case for holding tools and supplies for large constructions."
	icon_state = "infiltrator_case_engineering"
	item_state = "infiltrator_case_engineering"

/obj/item/storage/backpack/case/mining
	name = "mining compartment case"
	desc = "A large case for holding both loot and equipment."
	icon_state = "infiltrator_case_mining"
	item_state = "infiltrator_case_mining"

/obj/item/storage/backpack/case/science
	name = "science compartment case"
	desc = "A large case for holding science supplies."
	icon_state = "infiltrator_case_science"
	item_state = "infiltrator_case_science"

/obj/item/storage/backpack/case/cosmos
	name = "cosmos compartment case"
	desc = "A large compartment case for holding lots of things.\nThis one has been designed to look like space, neat."
	icon_state = "infiltrator_case_cosmos"
	item_state = "infiltrator_case_cosmos"
