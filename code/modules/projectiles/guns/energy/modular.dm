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

/obj/item/egunpart/focuspart/double
	name = "pulse-delay repeater focus"
	desc = "Advanced focus that splits the beam into two shots, one slightly behind the other."
	damagemod = 0.6
	shotcount = 2
	spreadmod = 3

/obj/item/egunpart/focuspart/quad
	name = "quadrangle-split focus"
	desc = "A simple focus that splits a single beam into four distinct beams at a moderate spread."
	damagemod = 0.3
	shotcount = 4
	spreadmod = 15

/obj/item/egunpart/focuspart/quint
	name = "quintangle-split focus"
	desc = "A very complex focus that splits a single beam into four distinct beams at a tight spread."
	damagemod = 0.25
	shotcount = 5
	spreadmod = 3

/obj/item/egunpart/focuspart/hyperscatter
	name = "hyperscatter multi-focus"
	desc = "Advanced focus that splits the beam into twelve really weak shots."
	damagemod = 0.09
	shotcount = 12
	spreadmod = 60

/obj/item/egunpart/focuspart/powershot
	name = "enviromental supercollector focus"
	desc = "A complex focus that draws less potent light from the enviroment to empower an energy weapon beam."
	damagemod = 2
	shotcount = 1
	spreadmod = 7

/obj/item/egunpart/framepart/highcap
	name = "heavy energy weapon frame"
	desc = "A frame for heavier energy weapons. Has a higher capacity."
	wclassmod = 2.5 //at least WEIGHT_CLASS_NORMAL
	usedcell /obj/item/stock_parts/cell{charge = 1000; maxcharge = 1000}
	capacity = "1 MJ"

/obj/item/egunpart/framepart/super
	name = 	"super-heavy energy weapon frame"
	desc = "A frame for very heavy energy weapons. Has a great capacity."
	wclassmod = 4.5 //at least WEIGHT_CLASS_HUGE
	usedcell /obj/item/stock_parts/cell{charge = 2000; maxcharge = 2000}
	capacity = "1 MJ"

/obj/item/egunpart/framepart/compact
	name = "compact energy weapon frame"
	desc = "A compact frame with a lesser capacity."
	wclassmod = 1
	usedcell /obj/item/stock_parts/cell{charge = 300; maxcharge = 300}
	capacity = "300 MJ"

/obj/item/egunpart/framepart/micro
	name = "micro-energy weapon frame"
	desc = "A really tiny energy weapon frame. Might not be able to fire with certain modules."
	wclassmod = 0.5
	usedcell /obj/item/stock_parts/cell{charge = 100; maxcharge = 100}
	capacity = "100 kJ"

/obj/item/egunpart/framepart/atomic
	name = "nuclear-powered energy weapon frame"
	desc = "Toasty! Moderate capacity, charges itself, heavy as fuck."
	wclassmod = 5.5 //whatever the hell is between huge and gigantic, this is it.
	usedcell /obj/item/stock_parts/cell{charge = 400; maxcharge = 400; self_recharge = TRUE; chargerate = 25} //16 seconds to fully recharge.
	capacity = "400 kJ"
	selfcharge = TRUE

/obj/item/egunpart/framepart/atomic/lame
	name = "simple nuclear-powered energy weapon frame"
	desc = "Toasty! Smaller but way slower selfcharging than the other atomic frame."
	wclassmod = 3.5 //at least huge
	usedcell /obj/item/stock_parts/cell{charge = 400; maxcharge = 400; self_recharge = TRUE; chargerate = 10} //40 seconds to fully recharge.

/obj/item/egunpart/framepart/syndicate
	name = "red and black energy weapon frame"
	desc = "A genuine Gorlex energy weapon frame. Where the hell did you get this?"
	wclassmod = 1.5
	usedcell /obj/item/stock_parts/cell{charge = 2500; maxcharge = 2500}
	capacity = "2.5 MJ"

/obj/item/egunpart/framepart/syndicate/selfcharge
	desc = "A genuine Gorlex energy weapon frame, nuclear version. Where the hell did you get this?"
	wclassmod = 1.5
	usedcell /obj/item/stock_parts/cell{charge = 2500; maxcharge = 2500 self_recharge = TRUE; chargerate = 250}//10 second selfcharge
	capacity = "2.5 MJ"
