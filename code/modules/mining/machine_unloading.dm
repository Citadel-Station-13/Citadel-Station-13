/**********************Unloading unit**************************/


/obj/machinery/mineral/unloading_machine
	name = "unloading machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "unloader"
	density = TRUE
	input_dir = WEST
	output_dir = EAST
	speed_process = TRUE
	init_process = TRUE

/obj/machinery/mineral/unloading_machine/proc/horrible_quadratic_monster(var/turf/T)
	set waitfor = FALSE
	var/limit = 0
	for(var/obj/structure/ore_box/B in T)
		for (var/obj/item/stack/ore/O in B)
			B.contents -= O
			unload_mineral(O)
			limit++
			if (limit>=10)
				return
			CHECK_TICK
	for(var/obj/item/I in T)
		unload_mineral(I)
		limit++
		if (limit>=10)
			return
		CHECK_TICK

/obj/machinery/mineral/unloading_machine/process()
	var/turf/T = get_step(src,input_dir)
	if(T)
		horrible_quadratic_monster(T)
