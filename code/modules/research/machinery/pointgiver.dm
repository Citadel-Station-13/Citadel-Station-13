/obj/machinery/rnd/pointgiver
  name = "virtual technology node"
  desc = "This shouldn't exist."
  layer = BELOW_OBJ_LAYER
  var/reward

/obj/machinery/rnd/pointgiver/Destroy()
  SSresearch.points += reward
  . = ..()


/obj/machinery/rnd/pointgiver/syndicate
  name = "syndicate virtual technology node"
  desc = "A virtual representation of stored research, ideas and knowledge. This one belongs to the Syndicate and will give [pointsgiven] points if destoyed."
  layer = BELOW_OBJ_LAYER
  reward = 1000
