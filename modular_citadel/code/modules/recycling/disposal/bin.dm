/obj/machinery/disposal/bin/alt_attack_hand(mob/user)
	if(is_interactable() && !user.stat)
		flush = !flush
		update_icon()
		return TRUE
	return FALSE
