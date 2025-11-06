/datum/action/item_action/mod
	background_icon_state = "bg_tech_blue"
	button_icon = 'icons/mob/actions/actions_mod.dmi'
	check_flags = AB_CHECK_CONSCIOUS
	/// Whether this action is intended for the AI. Stuff breaks a lot if this is done differently.
	var/ai_action = FALSE

/datum/action/item_action/mod/New(Target)
	..()
	if(!istype(Target, /obj/item/mod/control))
		qdel(src)
		return
	if(ai_action)
		background_icon_state = ACTION_BUTTON_DEFAULT_BACKGROUND

/datum/action/item_action/mod/Grant(mob/user)
	var/obj/item/mod/control/mod = target
	if(ai_action && user != mod.ai)
		return
	else if(!ai_action && user == mod.ai)
		return
	return ..()

/datum/action/item_action/mod/Remove(mob/user)
	var/obj/item/mod/control/mod = target
	if(ai_action && mod && user != mod.ai)
		return
	else if(!ai_action && mod && user == mod.ai)
		return
	return ..()

/datum/action/item_action/mod/do_effect(trigger_flags)
	var/obj/item/mod/control/mod = target
	if(mod.malfunctioning && prob(75))
		mod.balloon_alert(usr, "button malfunctions!")
		return FALSE
	return TRUE

/datum/action/item_action/mod/deploy
	name = "Deploy MODsuit"
	desc = "Deploy/Conceal a part of the MODsuit."
	button_icon_state = "deploy"

/datum/action/item_action/mod/deploy/do_effect(trigger_flags)
	. = ..()
	if(!.)
		return
	var/obj/item/mod/control/mod = target
	mod.choose_deploy(usr)

/datum/action/item_action/mod/deploy/ai
	ai_action = TRUE

/datum/action/item_action/mod/activate
	name = "Activate MODsuit"
	desc = "Activate/Deactivate the MODsuit."
	button_icon_state = "activate"

/datum/action/item_action/mod/activate/do_effect(trigger_flags)
	. = ..()
	if(!.)
		return
	var/obj/item/mod/control/mod = target
	mod.toggle_activate(usr)

/datum/action/item_action/mod/activate/ai
	ai_action = TRUE

/datum/action/item_action/mod/module
	name = "Toggle Module"
	desc = "Toggle a MODsuit module."
	button_icon_state = "module"

/datum/action/item_action/mod/module/do_effect(trigger_flags)
	. = ..()
	if(!.)
		return
	var/obj/item/mod/control/mod = target
	mod.quick_module(usr)

/datum/action/item_action/mod/module/ai
	ai_action = TRUE

/datum/action/item_action/mod/panel
	name = "MODsuit Panel"
	desc = "Open the MODsuit's panel."
	button_icon_state = "panel"

/datum/action/item_action/mod/panel/do_effect(trigger_flags)
	. = ..()
	if(!.)
		return
	var/obj/item/mod/control/mod = target
	mod.ui_interact(usr)

/datum/action/item_action/mod/panel/ai
	ai_action = TRUE
