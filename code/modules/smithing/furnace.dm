/obj/structure/furnace
	name = "furnace"
	desc = "A furnace."
	icon = 'icons/obj/smith.dmi'
	icon_state = "anvil"
	density = TRUE
	anchored = TRUE
	var/debug = FALSE //debugging only
	var/working = TRUE
	var/fueluse = 1


/obj/structure/furnace/Initialize()
	..()
	create_reagents(250, TRANSPARENT)
	START_PROCESSING(SSobj, src)

/obj/structure/furnace/Destroy()
	..()
	STOP_PROCESSING(SSobj, src)

/obj/structure/furnace/process()
	if(debug)
		reagents.add_reagent(/datum/reagent/fuel, 1)
		return TRUE
	if(reagents.remove_reagent(/datum/reagent/fuel, fueluse))
		working = TRUE
	else
		working = FALSE
/obj/structure/furnace/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/ingot))
		var/obj/item/ingot/notsword = I
		if(working)
			to_chat(user, "You heat the [notsword] in the [src].")
			notsword.workability = "shapeable"
		else
			to_chat(user, "The furnace isn't working!.")
	else
		..()

/obj/structure/furnace/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I, 5)
	return TRUE

/obj/structure/furnace/infinite
	name = "fuelless furnace"
	debug = TRUE
