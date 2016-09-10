/mob/living/silicon/examine(mob/user)
	if(laws && isobserver(user))
		user << "<b>[src] has the following laws:</b>
		laws.show_laws(user)