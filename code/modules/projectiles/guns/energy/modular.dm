/obj/item/gun/energy/modular
	name = "modular energy gun"
	desc = "Reading this is a crime. Report yourself to the Developers immediately."
	icon_state = "laser"
	item_state = "laser"
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(MAT_METAL=2000)
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun)
	ammo_x_offset = 1
	shaded_charge = 1
	var/obj/item/egunpart/framepart/frame
	var/obj/item/gunmodule/stockpart/stock
	var/obj/item/egunpart/focuspart/focus
	var/obj/item/egunpart/beammodule/module
