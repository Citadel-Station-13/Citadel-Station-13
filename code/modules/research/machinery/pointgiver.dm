/obj/machinery/rnd/pointgiver
	name = "virtual technology node"
	desc = "A virtual representation of stored research, ideas and knowledge."
	layer = BELOW_OBJ_LAYER
	var/reward = 0
	var/factionname = "blank"

/obj/machinery/rnd/pointgiver/examine(mob/living/user)
	..()
	to_chat(user, "<span class='notice'>This one belongs to [factionname] and will give [reward] points if destoyed.</span>")

/obj/machinery/rnd/pointgiver/Destroy()
	SSresearch.science_tech.add_point_type(TECHWEB_POINT_TYPE_DEFAULT, reward)
	. = ..()


/obj/machinery/rnd/pointgiver/syndicate
	name = "syndicate virtual technology node"
	layer = BELOW_OBJ_LAYER
	reward = 1000
	factionname = "the Syndicate"
