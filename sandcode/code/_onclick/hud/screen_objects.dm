/obj/screen/healthdoll/Click(location,control,params)
	var/list/modifiers = params2list(params)
	var/mob/living/L = usr
	if(isliving(usr) && !(modifiers["shift"]))
		usr.ClickOn(L)
	else
		usr.ShiftClickOn(L)
