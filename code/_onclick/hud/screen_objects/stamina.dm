/datum/hud/var/obj/screen/staminas/staminas
/datum/hud/var/obj/screen/staminabuffer/staminabuffer

/obj/screen/staminas
	icon = 'modular_citadel/icons/ui/screen_gen.dmi'
	name = "stamina"
	icon_state = "stamina0"
	screen_loc = ui_stamina
	mouse_opacity = 1

/obj/screen/staminas/Click(location,control,params)
	if(isliving(usr))
		var/mob/living/L = usr
		to_chat(L, "<span class='notice'>You have <b>[L.getStaminaLoss()]</b> stamina loss.<br>\
		Your stamina buffer is currently [L.stamina_buffer]/[L.stamina_buffer_max], and recharges at [L.stamina_buffer_regen] and [L.stamina_buffer_regen_combat] (combat mode on) per second.<br>\
		Your stamina buffer will have its capacity reduced by up to [STAMINA_BUFFER_STAMCRIT_CAPACITY_PERCENT_PENALTY * 100]% from stamina damage, up until stamcrit, and similarly will be impacted in regeneration by \
		[STAMINA_BUFFER_STAMCRIT_REGEN_PERCENT_PENALTY * 100]% from said damage.\
		<br>Your stamina buffer is <b>[round((L.stamina_buffer / L.stamina_buffer_max) * 100, 0.1)]%</b> full.</span>")

/obj/screen/staminas/update_icon_state()
	var/mob/living/carbon/user = hud?.mymob
	if(!user)
		return
	if(user.stat == DEAD || (user.combat_flags & COMBAT_FLAG_HARD_STAMCRIT) || (user.hal_screwyhud in 1 to 2))
		icon_state = "staminacrit"
	else if(user.hal_screwyhud == 5)
		icon_state = "stamina0"
	else
		icon_state = "stamina[clamp(FLOOR(user.getStaminaLoss() /20, 1), 0, 6)]"

/obj/screen/staminas/update_overlays()
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
/obj/screen/staminabuffer
	icon = 'modular_citadel/icons/ui/screen_gen.dmi'
	name = "stamina buffer"
	icon_state = "stambuffer0"
	screen_loc = ui_stamina
	layer = ABOVE_HUD_LAYER + 0.1
	mouse_opacity = 0

/obj/screen/staminabuffer/proc/mark_dirty()
	if(update_to_mob())
		START_PROCESSING(SShuds, src)

/obj/screen/staminabuffer/process()
	if(!update_to_mob())
		return PROCESS_KILL

/obj/screen/staminabuffer/Destroy()
	STOP_PROCESSING(SShuds, src)
	return ..()

/obj/screen/staminabuffer/proc/update_to_mob()
	var/mob/living/carbon/user = hud?.mymob
	user.UpdateStaminaBuffer(FALSE)
	if(!user?.client)
		return FALSE
	if(user.stat == DEAD || (user.combat_flags & COMBAT_FLAG_HARD_STAMCRIT) || (user.hal_screwyhud in 1 to 2))
		icon_state = "stambuffer0"
		return FALSE
	else if(user.hal_screwyhud == 5)
		icon_state = "stambuffer29"
		return FALSE
	else if(user.stamina_buffer >= user.stamina_buffer_max)
		icon_state = "stambuffer29"
		return FALSE
	else
		icon_state = "stambuffer[FLOOR((user.stamina_buffer / user.stamina_buffer_max) * 29, 1)]"
		return TRUE
