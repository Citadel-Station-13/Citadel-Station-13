/obj/machinery/firealarm/alt_attack_hand(mob/user)
	if(is_interactable() && !user.stat)
		var/area/A = get_area(src)
		if(istype(A))
			if(A.fire)
				reset()
			else
				alarm()
			return TRUE
	return FALSE
