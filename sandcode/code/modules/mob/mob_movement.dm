/mob/Moved(atom/OldLoc, Dir, Forced = FALSE)
	. = ..()
	set_typing_indicator(FALSE)
