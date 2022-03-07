/mob/dead/observer/move_up()
	var/turf/T = get_turf(src)
	if(!T.Above())
		to_chat(src, span_warning("There is nothing of interest in that direction."))
		return
	forceMove(T.Above())

/mob/dead/observer/move_down()
	var/turf/T = get_turf(src)
	if(!T.Below())
		to_chat(src, span_warning("There is nothing of interest in that direction."))
		return
	forceMove(T.Above())

/mob/dead/observer/CanZFall(fall_flags)
	return FALSE


