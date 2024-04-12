/obj/machinery/hydroponics/constructable/automagic
	name = "automated hydroponics system"
	desc = "The bane of botanists everywhere. Accepts chemical reagents via plumbing, automatically harvests and removes dead plants."
	icon_state = "hydrotray4"
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME
	circuit = /obj/item/circuitboard/machine/hydroponics/automagic

/obj/machinery/hydroponics/constructable/automagic/default_unfasten_wrench(mob/user, obj/item/I, time = 20)
	. = ..()
	if(. == SUCCESSFUL_UNFASTEN)
		user.visible_message("<span class='notice'>[user.name] [anchored ? "fasten" : "unfasten"] [src]</span>", \
		"<span class='notice'>You [anchored ? "fasten" : "unfasten"] [src]</span>")
		var/datum/component/plumbing/CP = GetComponent(/datum/component/plumbing)
		if(anchored)
			CP.enable()
		else
			CP.disable()

/obj/machinery/hydroponics/constructable/automagic/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/machinery/hydroponics/constructable/automagic/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	create_reagents(100 , AMOUNT_VISIBLE)

/obj/machinery/hydroponics/constructable/automagic/process()
	if(dead)
		dead = 0
		qdel(myseed)
		myseed = null
		update_icon()
		name = initial(name)
		desc = initial(desc)
	if(harvest)
		myseed.harvest_userless()
		harvest = 0
		lastproduce = age
		if(!myseed.get_gene(/datum/plant_gene/trait/repeated_harvest))
			qdel(myseed)
			myseed = null
			dead = 0
			name = initial(name)
			desc = initial(desc)
		update_icon()
	..()
