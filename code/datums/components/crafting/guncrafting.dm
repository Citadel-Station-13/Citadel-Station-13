//Gun crafting parts til they can be moved elsewhere

// PARTS //

/obj/item/weaponcrafting/receiver
	name = "broken gun part" // Replaced with new receivers below!!
	desc = "An irreparably broken receiver. This is beyond saving and cannot be used. OOC: Outdated item, report to coders, you shouldn't get this." // Replaced with new receivers below!!
	icon = 'icons/obj/improvised.dmi'
	icon_state = "receiver"

// OLD NAME 	name = "modular receiver"
// OLD DESC 	desc = "A prototype modular receiver and trigger assembly for a firearm."

/obj/item/weaponcrafting/stock
	name = "rifle stock"
	desc = "A classic rifle stock that doubles as a grip, roughly carved out of wood."
	icon = 'icons/obj/guns/gun_parts.dmi'
	icon_state = "riflestock"

/obj/item/weaponcrafting/silkstring
	name = "silkstring"
	desc = "A long piece of silk with some resemblance to cable coil."
	icon = 'icons/obj/improvised.dmi'
	icon_state = "silkstring"

////////////////////////////////
// KAT IMPROVISED WEAPON PARTS//
////////////////////////////////

/obj/item/weaponcrafting/improvised_parts
	name = "Nuclear Syndicate Hyper Giga-Operative Undercover 5th-Dimensional Super-Tank"
	desc = "An undercover hypno sissification operative attempting to make Nanotrasen homosexual. Report this to Central immediately. Something is off here."
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

/obj/item/weaponcrafting/improvised_parts/barrel_pistol
	name = "pistol barrel"
	desc = "A pipe with a small diameter and some holes finely cut into it. It fits .32 ACP bullets. Probably."
	icon_state = "barrel_pistol"

// RECEIVERS

/obj/item/weaponcrafting/improvised_parts/rifle_receiver
	name = "bolt action receiver"
	desc = "A crudely constructed receiver to create an improvised bolt-action breechloaded rifle."
	icon_state = "receiver_rifle"

/obj/item/weaponcrafting/improvised_parts/shotgun_receiver
	name = "break-action assembly"
	desc = "An improvised receiver to create a break-action breechloaded shotgun."
	icon_state = "receiver_shotgun"

/obj/item/weaponcrafting/improvised_parts/pistol_receiver
	name = "pistol receiver"
	desc = "A receiver to connect house and connects all the parts to make an improvised pistol."
	icon_state = "receiver_pistol"


/obj/item/weaponcrafting/improvised_parts/laser_receiver
	name = "energy emitter assembly"
	desc = "A mixture of components haphazardly wired together to form an energy emitter."
	icon_state = "laser_assembly"

// MISC

/obj/item/weaponcrafting/improvised_parts/trigger_assembly
	name = "firearm trigger assembly"
	desc = "A modular trigger assembly with a firing pin, this can be used to make a whole bunch of improvised firearss."
	icon_state = "trigger_assembly"

/obj/item/weaponcrafting/improvised_parts/wooden_body
	name = "wooden firearm body"
	desc = "A crudely fashioned wooden body to help keep higher calibre improvised weapons from blowing themselves apart."
	icon_state = "wooden_body"

/obj/item/weaponcrafting/improvised_parts/wooden_grip
	name = "wooden pistol grip"
	desc = "A nice wooden grip hollowed out for pistol magazines."
	icon_state = "wooden_pistolgrip"

/obj/item/weaponcrafting/improvised_parts/makeshift_lens
	name = "makeshift focusing lens"
	desc = "A properly made lens made with actual glassworking tools would perform much better, but this will have to do."
	icon_state = "focusing_lens"
