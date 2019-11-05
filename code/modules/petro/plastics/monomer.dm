/obj/item/monomer
	name = "debug monomer"
	desc = "You shouldn't see this."
	icon_state = "datadisk0"
	materials = list(MAT_PLASTIC=300)
	var/monomer_type


/obj/item/monomer/Initialize()
	. = ..()
	name = "[monomer_type] monomer"