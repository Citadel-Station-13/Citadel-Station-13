/obj/item/tank/internals/oxygen
	tank_holder_icon_state = "holder_oxygen"

/obj/item/tank/internals/oxygen/yellow
	tank_holder_icon_state = "holder_oxygen_f"

/obj/item/tank/internals/oxygen/red
	tank_holder_icon_state = "holder_oxygen_fr"

/obj/item/tank/internals/anesthetic
	tank_holder_icon_state = "holder_oxygen_anesthetic"

/obj/item/tank/internals/plasma
	tank_holder_icon_state = null

/obj/item/tank/internals/plasmaman
	tank_holder_icon_state = null

/obj/item/tank/internals/plasmaman/belt
	tank_holder_icon_state = null

/obj/item/tank/internals/emergency_oxygen
	tank_holder_icon_state = "holder_emergency"

/obj/item/tank/internals/emergency_oxygen/engi
	tank_holder_icon_state = "holder_emergency_engi"

/obj/item/tank/internals/emergency_oxygen/double
	tank_holder_icon_state = "holder_emergency_engi"
	volume = 12 //If it's double of the above, shouldn't it be double the volume??

// *
// * GENERIC
// *

/obj/item/tank/internals/generic
	name = "gas tank"
	desc = "A generic tank used for storing and transporting gasses. Can be used for internals."
	icon = 'modular_sand/icons/obj/tank.dmi'
	icon_state = "generic"
	lefthand_file = 'modular_sand/icons/mob/inhands/equipment/tanks_lefthand.dmi'
	righthand_file = 'modular_sand/icons/mob/inhands/equipment/tanks_righthand.dmi'
	mob_overlay_icon = 'modular_sand/icons/mob/clothing/back.dmi'
	distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
	force = 10
	dog_fashion = /datum/dog_fashion/back

/obj/item/tank/internals/generic/populate_gas()
	return
