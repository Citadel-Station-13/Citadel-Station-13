/mob
	var/hud_typing = FALSE //set when typing in an input window instead of chatline
	var/typing
	var/last_typed
	var/last_typed_time

	var/static/mutable_appearance/typing_indicator

/mob/proc/set_typing_indicator(var/state)
	if(!typing_indicator)
		typing_indicator = mutable_appearance('sandcode/icons/mob/typing_indicator.dmi', "default0", FLY_LAYER)
	if(client && !stat)
		if(state)
			if(!typing)
				add_overlay(typing_indicator)
				typing = TRUE
		else
			if(typing)
				cut_overlay(typing_indicator)
				typing = FALSE
		return state

/mob/proc/handle_typing_indicator()
	if(!client)
		return
	var/temp = winget(client, "input", "text")

	if (temp != last_typed)
		last_typed = temp
		last_typed_time = world.time

	if(length(temp) > 5 && findtext(temp, "Say \"", 1, 7))
		set_typing_indicator(TRUE)
		return
	if(length(temp) > 3 && findtext(temp, "Me ", 1, 5))
		set_typing_indicator(TRUE)
		return
	if(!hud_typing)
		set_typing_indicator(FALSE) 
