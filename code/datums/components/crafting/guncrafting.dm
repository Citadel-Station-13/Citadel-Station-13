// PARTS //
/obj/item/weaponcrafting
	icon = 'icons/obj/improvised.dmi'

/obj/item/weaponcrafting/receiver
	name = "modular receiver"
	desc = "A prototype modular receiver and trigger assembly for a firearm."
	icon = 'icons/obj/improvised.dmi'
	icon_state = "receiver"

/obj/item/weaponcrafting/stock
	name = "rifle stock"
	desc = "A classic rifle stock that doubles as a grip, roughly carved out of wood."
	custom_materials = list(/datum/material/wood = MINERAL_MATERIAL_AMOUNT * 6)
	icon_state = "riflestock"

/obj/item/weaponcrafting/string
	name = "wound thread"
	desc = "A long piece of thread with some resemblance to cable coil."
	icon_state = "durastring"
