/obj/screen/restbutton
	name = "rest"
	icon = 'modular_citadel/icons/ui/screen_midnight.dmi'
	icon_state = "rest"

/obj/screen/restbutton/Click()
	if(isliving(usr))
		var/mob/living/theuser = usr
		theuser.lay_down()

/obj/screen/voretoggle
	name = "toggle vore mode"
	icon = 'modular_citadel/icons/ui/screen_midnight.dmi'
	icon_state = "nom_off"

/obj/screen/voretoggle/Click()
	if(usr != hud.mymob)
		return
	var/mob/living/carbon/C = usr
	if(SEND_SIGNAL(usr, COMSIG_HAS_COMBAT_MODE_ENABLED))
		to_chat(usr, "<span class='warning'>Disable combat mode first.</span>")
		return
	C.toggle_vore_mode()

/obj/screen/voretoggle/update_icon_state()
	var/mob/living/carbon/user = hud?.mymob
	if(!istype(user))
		return
	if(user.voremode)
		icon_state = "nom"
	else
		icon_state = "nom_off"
