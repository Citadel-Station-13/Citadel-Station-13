
/datum/hud/revenant/New(mob/owner)
	..()

	healths = new /atom/movable/screen/healths/revenant(null, src)
	infodisplay += healths
