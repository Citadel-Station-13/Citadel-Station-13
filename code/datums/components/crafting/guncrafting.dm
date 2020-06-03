k// PARTS //
/obj/item/weaponcrafting
	icon = 'icons/obj/improvised.dmi'

/obj/item/weaponcrafting/stock
	name = "rifle stock"
	desc = "A classic rifle stock that doubles as a grip, roughly carved out of wood."
	custom_materials = list(/datum/material/wood = MINERAL_MATERIAL_AMOUNT * 6)
	icon_state = "riflestock"

/obj/item/weaponcrafting/durathread_string
	name = "durathread string"
	desc = "A long piece of durathread with some resemblance to cable coil."
	icon_state = "durastring"

////////////////////////////////
// KAT IMPROVISED WEAPON PARTS//
////////////////////////////////

/obj/item/weaponcrafting/improvised_parts
	name = "Eerie bunch of coloured dots."
	desc = "You feel the urge to report to Central that the parent type of guncrafting, which should never appear in this reality, has appeared. Whatever that means."
	icon = 'icons/obj/guns/gun_parts.dmi'
	icon_state = "palette"

// BARRELS

/obj/item/weaponcrafting/improvised_parts/barrel_rifle
	name = "rifle barrel"
	desc = "A pipe with a diameter just the right size to fire 7.62 rounds out of."
	icon_state = "barrel_rifle"

/obj/item/weaponcrafting/improvised_parts/barrel_shotgun
	name = "shotgun barrel"
	desc = "A twenty bore shotgun barrel."
	icon_state = "barrel_shotgun"

// RECEIVERS

/obj/item/weaponcrafting/improvised_parts/rifle_receiver
	name = "bolt action receiver"
	desc = "A crudely constructed receiver to create an improvised bolt-action breechloaded rifle."
	icon_state = "receiver_rifle"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/weaponcrafting/improvised_parts/shotgun_receiver
	name = "break-action assembly"
	desc = "An improvised receiver to create a break-action breechloaded shotgun."
	icon_state = "receiver_shotgun"
	w_class = WEIGHT_CLASS_SMALL

// MISC

/obj/item/weaponcrafting/improvised_parts/trigger_assembly
	name = "firearm trigger assembly"
	desc = "A modular trigger assembly with a firing pin, this can be used to make a whole bunch of improvised firearss."
	icon_state = "trigger_assembly"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/weaponcrafting/improvised_parts/wooden_body
	name = "wooden firearm body"
	desc = "A crudely fashioned wooden body to help keep higher calibre improvised weapons from blowing themselves apart."
	icon_state = "wooden_body"

