/obj/machinery/button/privacy
	name = "Privacy toggle"
	var/tar_name
	var/tint_objs = list()

/obj/machinery/button/privacy/setup_device()
	if(!device)
		for(var/obj/O in get_area(src))
			if(O.name == tar_name)
				tint_objs += O
	..()

/obj/machinery/button/privacy/attack_hand(mob/user)
	.=..()
	for(var/obj/O in tint_objs)
		if(O.opacity)
			O.color = "#919191"
			O.opacity = 0
		else
			O.opacity = 1
			O.color = "#000000"
