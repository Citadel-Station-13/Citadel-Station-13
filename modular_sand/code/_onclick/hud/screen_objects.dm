/obj/screen/healthdoll/Click(location, control, params)
	var/mob/living/L = usr
	usr.Click(L, control, params)
	return FALSE	//The health doll doesn't really do anything on it's own, change this if you need to
