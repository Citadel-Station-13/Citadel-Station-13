/obj/structure/furnace
	name = "furnace"
	desc = "A furnace."
	icon = 'icons/obj/smith.dmi'
	icon_state = "furnace0"
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
		if(icon_state == "furnace0")
			icon_state = "furnace1"
	else
		working = FALSE
		icon_state = "furnace0"

/obj/structure/furnace/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/ingot))
		var/obj/item/ingot/notsword = I
		if(working)
			to_chat(user, "You heat the [notsword] in the [src].")
			notsword.workability = "shapeable"
		else
			to_chat(user, "The furnace isn't working!")
	else if(istype(I, /obj/item/stack/sheet/mineral/charcoal))
		to_chat(user, "You toss the [I] in the [src].")
		var/obj/item/stack/sheet/mineral/charcoal/CC = I
		reagents.add_reagent(/datum/reagent/fuel, 5*CC.amount)
		qdel(CC)
	else
		..()

/obj/structure/furnace/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I, 5)
	return TRUE

/obj/structure/furnace/attackby(obj/item/W, mob/user, params)
	if(W.reagents)
		W.reagents.trans_to(src, 250)
	else
		return ..()

/obj/structure/furnace/plunger_act(obj/item/plunger/P, mob/living/user, reinforced)
	to_chat(user, "<span class='notice'>You start furiously plunging [name].")
	if(do_after(user, 30, target = src))
		to_chat(user, "<span class='notice'>You finish plunging the [name].")
		reagents.reaction(get_turf(src), TOUCH) //splash on the floor
		reagents.clear_reagents()

/obj/structure/furnace/infinite
	name = "fuelless furnace"
	debug = TRUE
	icon_state = "ratfurnace"


/obj/structure/furnace/infinite/ratvar
	name = "brass furnace"
	desc = "A brass furnace. Powered by... something, but seems otherwise safe." //todo:sprites they're safe for noncultists because you're just putting ingots in them. also there's a reason to steal them ig

/obj/structure/furnace/infinite/narsie //unused, the cult forge does this already.
	name = "rune furnace"
	desc = "A runed furnace. Powered by... something, but seems otherwise safe."
	icon = 'icons/obj/cult.dmi'
	icon_state = "forge"


/obj/structure/bloomery
	name = "bloomery"
	desc = "Like a furnace, but special! Makes blooms."
	icon = 'icons/obj/smith.dmi'
	icon_state = "furnace0"
	density = TRUE
	anchored = TRUE
	var/fueluse = 1 //how much coal do we use
	var/fuel = 0
	var/obj/item/stack/ore/raw

/obj/structure/bloomery/attackby(obj/item/I, mob/user)
	if(I.get_temperature() && fuel > 1 && raw)
		to_chat(user, "<span class='notice'>You attempt to light the [name].")
		if(do_after(user, 15, target = src))
			to_chat(user, "<span class='notice'>You light the [name]!")
			bloominate(user)
		else if(istype(I, /obj/item/stack/ore))
			var/obj/item/stack/ore/ero = I
			raw = ero
			to_chat(user, "You place the [ero] into the [name]!")

/obj/structure/bloomery/proc/bloominate(mob/user)
	if(!raw || !fuel)
		return FALSE
	to_chat(user, "<span class='notice'>You watch the [name], carefully waiting for the right moment to take the bloom out.")
	if(do_after(user, 300, target = src))
		to_chat(user, "<span class='notice'>You remove the bloom from the [name]!")
	else
		to_chat(user, "<span class='notice'>The bloom condenses into a useless mass of slag!")
		qdel(raw)
		raw = null
		fuel = 0
		new /obj/item/stack/ore/slag(get_turf(src))
		return FALSE
	var/obj/item/metalbloom/newbloom = new /obj/item/metalbloom(src)
	var/obj/item/bloom_stuff
	if(isitem(raw.refined_type))
		bloom_stuff = raw.refined_type
	else
		return FALSE
	newbloom.type_to_create = bloom_stuff
	newbloom.amount_to_create = raw.amount * 5
	newbloom.forceMove(get_turf(src))
	qdel(raw)
	raw = null
	fuel = 0
