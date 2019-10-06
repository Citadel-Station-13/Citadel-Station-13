/obj/machinery/rnd/pointgiver
  name = "virtual technology node"
  desc = "A virtual representation of stored research, ideas and knowledge. This one belongs to [factionname] and will give [reward] points if destoyed."
  layer = BELOW_OBJ_LAYER


/obj/machinery/rnd/pointgiver/Destroy()
	SSresearch.science_tech.add_point_type(TECHWEB_POINT_TYPE_DEFAULT, reward)
	. = ..()


/obj/machinery/rnd/pointgiver/syndicate
  name = "syndicate virtual technology node"
  layer = BELOW_OBJ_LAYER
  reward = 1000
  factionname = "the Syndicate"
