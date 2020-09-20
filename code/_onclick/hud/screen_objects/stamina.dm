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
		to_chat(L, "<span class='notice'>You have <b>[L.getStaminaLoss()]</b> stamina loss.<br>Your stamina buffer can take <b>[L.stambuffer]</b> stamina loss, and recharges at no cost.<br>Your stamina buffer is <b>[(L.stambuffer*(100/L.stambuffer))-(L.bufferedstam*(100/L.stambuffer))]%</b> full.</span>")

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

//stam buffer
/obj/screen/staminabuffer
	icon = 'modular_citadel/icons/ui/screen_gen.dmi'
	name = "stamina buffer"
	icon_state = "stambuffer0"
	screen_loc = ui_stamina
	layer = ABOVE_HUD_LAYER + 0.1
	mouse_opacity = 0

/obj/screen/staminabuffer/update_icon_state()
	var/mob/living/carbon/user = hud?.mymob
	if(!user)
		return
	if(user.stat == DEAD || (user.combat_flags & COMBAT_FLAG_HARD_STAMCRIT) || (user.hal_screwyhud in 1 to 2))
		icon_state = "stambuffer0"
	else if(user.hal_screwyhud == 5)
		icon_state = "stambuffer29"
	else
		icon_state = "stambuffer[FLOOR((stamina_buffer / stamina_buffer_max) * 29, 1)]"

/obj/screen/staminabuffer/update_overlays()
	var/level = FLOOR((stamina_buffer / stamina_buffer_max) * 29, 1)
	if((user.stat == DEAD) || (user.combat_flags & COMBAT_FLAG_HARD_STAMCRIT) || (user.hal_screwyhud in 1 to 2) || (level <= 5))
		. = list("stamina_alert3")
	else if(level <= 8)
		. = list("stamina_alert2")
	else if(level <= 12)
		. = list("stamina_alert1")
