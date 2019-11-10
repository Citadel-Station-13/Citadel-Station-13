/obj/machinery/button/privacy
	name = "Privacy toggle"
	var/tar_name
	var/tint_objs = list()

/obj/machinery/button/privacy/setup_device()
	if(!device)
		for(var/obj/structure/S in get_area(src))
			if(S.name == tar_name)
				tint_objs += S
	..()

/obj/machinery/button/privacy/attack_hand(mob/user)
	.=..()
	for(var/obj/structure/S in tint_objs)
		if(S.opacity)
			S.color = "#919191"
			S.opacity = 0
		else
			S.opacity = 1
			S.color = "#000000"
