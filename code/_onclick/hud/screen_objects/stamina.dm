/datum/hud/var/atom/movable/screen/staminas/staminas
/datum/hud/var/atom/movable/screen/staminabuffer/staminabuffer

/atom/movable/screen/staminas
	icon = 'modular_citadel/icons/ui/screen_gen.dmi'
	name = "stamina"
	icon_state = "stamina0"
	screen_loc = ui_stamina
	mouse_opacity = 1

/atom/movable/screen/staminas/Click(location,control,params)
	if(isliving(usr))
		var/mob/living/L = usr
		CONFIG_CACHE_ENTRY_AND_FETCH_VALUE(number/stamina_combat/buffer_max, buffer_max)
		to_chat(L, "<span class='notice'>You have <b>[L.getStaminaLoss()]</b> stamina loss.<br>\
		<br>Your stamina buffer is <b>[round((L.stamina_buffer / buffer_max) * 100, 0.1)]%</b> full.</span>")

/atom/movable/screen/staminas/update_icon_state()
	var/mob/living/carbon/user = hud?.mymob
	if(!user)
		return
	if(user.stat == DEAD || (user.combat_flags & COMBAT_FLAG_HARD_STAMCRIT) || (user.hal_screwyhud in 1 to 2))
		icon_state = "staminacrit"
	else if(user.hal_screwyhud == 5)
		icon_state = "stamina0"
	else
		icon_state = "stamina[clamp(FLOOR(user.getStaminaLoss() /20, 1), 0, 6)]"

/atom/movable/screen/staminas/update_overlays()
	. = ..()
	var/mob/living/carbon/user = hud?.mymob
	if(!user)
		return
	var/percent = user.getStaminaLoss() / STAMINA_CRIT
	if((user.stat == DEAD) || (user.combat_flags & COMBAT_FLAG_HARD_STAMCRIT) || (user.hal_screwyhud in 1 to 2))
		. += list("stamina_alert3")
	else if(percent >= 0.85)
		. += list("stamina_alert2")
	else if(percent >= 0.7)
		. += list("stamina_alert1")

//stam buffer
/atom/movable/screen/staminabuffer
	icon = 'modular_citadel/icons/ui/screen_gen.dmi'
	name = "stamina buffer"
	icon_state = "stambuffer0"
	screen_loc = ui_stamina
	layer = ABOVE_HUD_LAYER + 0.1
	mouse_opacity = 0

/atom/movable/screen/staminabuffer/proc/mark_dirty()
	if(update_to_mob())
		START_PROCESSING(SShuds, src)

/atom/movable/screen/staminabuffer/process()
	if(!update_to_mob())
		return PROCESS_KILL

/atom/movable/screen/staminabuffer/Destroy()
	STOP_PROCESSING(SShuds, src)
	return ..()

/atom/movable/screen/staminabuffer/proc/update_to_mob()
	var/mob/living/carbon/user = hud?.mymob
	user.UpdateStaminaBuffer(FALSE)
	CONFIG_CACHE_ENTRY_AND_FETCH_VALUE(number/stamina_combat/buffer_max, buffer_max)
	if(!user?.client)
		return FALSE
	if(user.stat == DEAD || (user.combat_flags & COMBAT_FLAG_HARD_STAMCRIT) || (user.hal_screwyhud in 1 to 2))
		icon_state = "stambuffer0"
		return FALSE
	else if(user.hal_screwyhud == 5)
		icon_state = "stambuffer29"
		return FALSE
	else if(user.stamina_buffer >= buffer_max)
		icon_state = "stambuffer29"
		return FALSE
	else
		icon_state = "stambuffer[FLOOR((user.stamina_buffer / buffer_max) * 29, 1)]"
		return TRUE
