/obj/screen/restbutton
	name = "rest"
	icon = 'modular_citadel/icons/ui/screen_midnight.dmi'
	icon_state = "rest"

/obj/screen/restbutton/Click()
	if(isliving(usr))
		var/mob/living/theuser = usr
		theuser.lay_down()

/obj/screen/combattoggle
	name = "toggle combat mode"
	icon = 'modular_citadel/icons/ui/screen_midnight.dmi'
	icon_state = "combat_off"

/obj/screen/combattoggle/Click()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.user_toggle_intentional_combat_mode()

/obj/screen/combattoggle/update_icon_state()
	var/mob/living/carbon/user = hud?.mymob
	if(!istype(user))
		return
	if((user.combat_flags & COMBAT_FLAG_COMBAT_ACTIVE))
		icon_state = "combat"
	else if(HAS_TRAIT(user, TRAIT_COMBAT_MODE_LOCKED))
		icon_state = "combat_locked"
	else
		icon_state = "combat_off"

/obj/screen/voretoggle
	name = "toggle vore mode"
	icon = 'modular_citadel/icons/ui/screen_midnight.dmi'
	icon_state = "nom_off"

/obj/screen/voretoggle/Click()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.toggle_vore_mode()

/obj/screen/voretoggle/update_icon_state()
	var/mob/living/carbon/user = hud?.mymob
	if(!istype(user))
		return
	if(user.voremode && !(user.combat_flags & COMBAT_FLAG_COMBAT_ACTIVE))
		icon_state = "nom"
	else
		icon_state = "nom_off"
