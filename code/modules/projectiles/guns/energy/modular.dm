/obj/item/gun/energy/modular
	name = "modular energy gun"
	desc = "Bug item.."
	icon_state = "laser"
	item_state = "laser"
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(MAT_METAL=2000)
	ammo_type = list(/obj/item/ammo_casing/energy/modular)
	ammo_x_offset = 1
	shaded_charge = 1
	var/obj/item/egunpart/framepart/frame
	var/obj/item/gunmodule/stockpart/stock
	var/obj/item/egunpart/focuspart/focus
	var/obj/item/egunpart/beammodule/module

/obj/item/ammo_casing/energy/modular
	projectile_type = /obj/item/projectile/beam/laser
	select_name = "debug"

/obj/item/egunpart
	name = "fragment of an energy weapon"
	desc = "Uh oh. This shouldn't exist."
	var/wclassmod = 0
	var/spreadmod = 0

/obj/item/egunpart/framepart
	name = "energy weapon frame"
	desc = "Uh oh. This shouldn't exist."
	var/obj/item/stock_parts/cell/usedcell = /obj/item/stock_parts/cell{charge = 500; maxcharge = 500}
	var/capacity = "500 kJ"
	var/selfcharge = FALSE
	wclassmod = 1.5

/obj/item/egunpart/framepart/examine(mob/user)
	..()
	to_chat(user, "The frame's internal cell has a [capacity] capacity and [selfcharge == TRUE ? "can" : "cannot"] generate power itself. ")

/obj/item/egunpart/stockpart
	name = "energy weapon stock"
	desc = "Why do recoilless energy weapons have stocks, again? Balancing concerns? Don't want an unbalanced weapon, would be hell to handle."
	wclassmod = 1.5
	spreadmod = 0

/obj/item/egunpart/focuspart
	name = "energy beam focus"
	desc = "Uh oh. This shouldn't exist."
	var/damagemod = 1
	var/shotcount = 1

/obj/item/egunpart/focuspart/examine(mob/user)
	..()
	to_chat(user, "The focus multiplies projectile damage by [damagemod] and causes the projectile to form [shotcount == 1 : "a single shot" : "multiple shots"] upon exiting the barrel.")

/obj/item/egunpart/beammodule
	name = "energy weapon beam module"
	desc = "Uh oh. This shouldn't exist."
	var/shotdamage = 20
	var/obj/item/projectile/shottype = /obj/item/projectile/beam/laser
	var/shotcost = 50

/obj/item/egunpart/beammodule/Initialize()
	shottype.damage = shotdamage
	//shottype.e_cost = shotcost

/obj/item/egunpart/beammodule/examine(mob/user)
	..()
	to_chat(user, "The beam module fires [shotdamage] damage [shottype.name] shots.")

/obj/item/egunpart/framepart/basic
	name = "basic energy weapon frame"
	desc = "Basic energy weapon frame."
	wclassmod = 1.5


/obj/item/egunpart/stockpart/basic
	name = "basic energy weapon stock"
	desc = "Bog standard energy weapon stock. Doesn't affect spread that much."
	wclassmod = 1.5
	spreadmod = 5

/obj/item/egunpart/focuspart/single
	name = "single shot focus"
	desc = "Garden variety energy weapon focus. Calibrated to fire a single normal shot."
	damagemod = 1
	shotcount = 1
	spreadmod = 0

/obj/item/egunpart/beammodule/simplaser
	name = "energy weapon laser beam module"
	desc = "The thing that makes the energy gun go pew. Pretty basic laser module."
	shotdamage = 20
	shottype = /obj/item/projectile/beam/laser

/obj/item/egunpart/beammodule/simpdisabler
	name = "energy weapon disabler beam module"
	desc = "The thing that makes the energy gun go pew. Pretty basic disabler module."
	shotdamage = 28
	shottype = /obj/item/projectile/beam/disabler
	shotcost = 33 //15 shots on basic 500kj cell.

/obj/item/egunpart/beammodule/simptaser
	name = "energy weapon taser electrode module"
	desc = "The thing that makes the energy gun go zap. Pretty basic taser module."
	shotdamage = 0
	shottype = /obj/item/projectile/energy/electrode
	shotcost = 100 //5 shots on basic 500kj cell.
