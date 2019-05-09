/obj/item/implant/integrated_circuit
	name = "electronic implant"
	desc = "It's a case, for building tiny-sized, implantable electronics with."
	icon = 'icons/obj/assemblies/electronic_setups.dmi'
	icon_state = "setup_implant"
	actions_types = list()
	item_flags = null
	allow_multiple = TRUE
	var/obj/item/electronic_assembly/small/implant/IC = null

/obj/item/implant/integrated_circuit/Destroy()
	IC.implant = null
	qdel(IC)
	. = ..()

/obj/item/implant/integrated_circuit/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/electronic_assembly) || istype(O, /obj/item/integrated_electronics) || istype(O, /obj/item/integrated_circuit) || istype(O, /obj/item/stock_parts/cell) )
		IC.attackby(O, user)
	else if(istype(O, /obj/item/implanter)) //So that it can be sucked directly into an implanter
		var/obj/item/implanter/I = O
		if(I.imp)
			return
		forceMove(I)
		I.imp = src
		update_icon()
		I.update_icon()
	else
		. = ..()

/obj/item/implant/integrated_circuit/emp_act(severity)
	IC.emp_act(severity)

/obj/item/implant/integrated_circuit/examine(mob/user)
	IC.examine(user)

/obj/item/implant/integrated_circuit/screwdriver_act(mob/living/user, obj/item/I)
	IC.screwdriver_act(user, I)


/obj/item/implant/integrated_circuit/implant(mob/living/target, mob/user, silent = FALSE)
	. = ..()
	IC.forceMove(target)


/obj/item/implant/integrated_circuit/removed(mob/living/source, silent = FALSE, special = 0)
	. = ..()
	IC.forceMove(src)


/obj/item/implant/integrated_circuit/attack_self(mob/user)
	IC.attack_self(user)