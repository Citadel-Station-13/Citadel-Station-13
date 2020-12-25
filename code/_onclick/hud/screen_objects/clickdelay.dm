/obj/screen/action_bar

/obj/screen/action_bar/Destroy()
	STOP_PROCESSING(SShuds, src)
	return ..()

/obj/screen/action_bar/proc/mark_dirty()
	var/mob/living/L = hud?.mymob
	if(L?.client && update_to_mob(L))
		START_PROCESSING(SShuds, src)

/obj/screen/action_bar/process()
	var/mob/living/L = hud?.mymob
	if(!L?.client || !update_to_mob(L))
		return PROCESS_KILL

/obj/screen/action_bar/proc/update_to_mob(mob/living/L)
	return FALSE

/datum/hud/var/obj/screen/action_bar/clickdelay/clickdelay

/obj/screen/action_bar/clickdelay
	name = "click delay"
	icon = 'icons/effects/progessbar.dmi'
	icon_state = "prog_bar_100"
	layer = 20		// under hand buttons

/obj/screen/action_bar/clickdelay/Initialize()
	. = ..()
	var/matrix/M = new
	M.Scale(2, 1)
	transform = M

/obj/screen/action_bar/clickdelay/update_to_mob(mob/living/L)
	var/estimated = L.EstimatedNextActionTime()
	var/diff = estimated - L.last_action
	var/left = estimated - world.time
	if(left < 0 || diff < 0)
		icon_state = "prog_bar_100"
		return FALSE
	icon_state = "prog_bar_[round(clamp(((diff - left)/diff) * 100, 0, 100), 5)]"
	return TRUE

/datum/hud/var/obj/screen/action_bar/resistdelay/resistdelay

/obj/screen/action_bar/resistdelay
	name = "resist delay"
	icon = 'icons/effects/progessbar.dmi'
	icon_state = "prog_bar_100"

/obj/screen/action_bar/resistdelay/update_to_mob(mob/living/L)
	var/diff = L.next_resist - L.last_resist
	var/left = L.next_resist - world.time
	if(left < 0 || diff < 0)
		icon_state = "prog_bar_100"
		return FALSE
	icon_state = "prog_bar_[round(clamp(((diff - left)/diff) * 100, 0, 100), 5)]"
	return TRUE
