#define HIJACK_APC_MAX_AMOUNT 4

/obj/item/implant/hijack
	name = "hijack implant"
	desc = "Allows you to control the machinery in a room by hacking into the APC."
	actions_types = list(/datum/action/item_action/hands_free/activate, /datum/action/item_action/removeAPCs, /datum/action/item_action/accessAPCs)
	activated = 1
	var/toggled = FALSE
	icon_state = "hijack"
	var/eye_color
	var/stealthmode = FALSE
	var/stealthcooldown = 0

/obj/item/implant/hijack/activate()
	. = ..()
	toggled = !toggled
	if (toggled)
		imp_in.click_intercept = src
		imp_in.siliconaccesstoggle = TRUE
		to_chat(imp_in,"<span class='notice'>You turn on [src]'s silicon interactions.</span>")
		if (ishuman(imp_in) && !stealthmode)
			toggle_eyes(TRUE)
	else
		imp_in.click_intercept = null
		imp_in.siliconaccesstoggle = FALSE
		to_chat(imp_in,"<span class='notice'>You turn off [src]'s silicon interactions.</span>")
		if (ishuman(imp_in) && !stealthmode)
			toggle_eyes(FALSE)

/obj/item/implant/hijack/proc/toggle_eyes(on)
	if (!on)
		var/mob/living/carbon/human/H = imp_in
		H.eye_color = eye_color
		H.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
		H.update_body()
	else
		var/mob/living/carbon/human/H = imp_in
		H.eye_color = "ff0"
		H.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
		H.update_body()

/obj/item/implant/hijack/implant(mob/living/target, mob/user, silent = FALSE)
	if(..())
		ADD_TRAIT(target, TRAIT_HIJACKER, "implant")
		if (ishuman(target))
			var/mob/living/carbon/human/H = target
			eye_color = H.eye_color
		return TRUE

/obj/item/implant/hijack/removed(mob/target, silent = FALSE, special = 0)
	if(..())
		REMOVE_TRAIT(target, TRAIT_HIJACKER, "implant")
		if (ishuman(target))
			var/mob/living/carbon/human/H = target
			H.eye_color = eye_color
		return TRUE

/obj/item/implant/hijack/proc/InterceptClickOn(mob/living/user,params,atom/object)
	if (user.get_active_held_item() || isitem(object) || !toggled || user.incapacitated())
		return
	if (stealthmode == FALSE && istype(object,/obj/machinery/power/apc))
		hijack_remotely()
	var/area/a = get_area(object)
	if (!hasSiliconAccessInArea(imp_in,a))
		return
	var/list/modifiers = params2list(params)
	imp_in.face_atom(object)
	if (modifiers["shift"] && modifiers["ctrl"])
		object.AICtrlShiftClick(imp_in)
		return TRUE
	if (modifiers["shift"])
		object.AIShiftClick(imp_in)
		return TRUE
	if (modifiers["ctrl"])
		object.AICtrlClick(imp_in)
		return TRUE
	if (modifiers["alt"])
		object.AIAltClick(imp_in)
		return TRUE
	object.attack_ai(imp_in)
	return TRUE

/obj/item/implant/hijack/proc/hijack_remotely(/obj/machinery/power/apc/apc)
	if (apc.hijacker)
		return //can't remotely hijack an already hijacked APC
	if (do_after(imp_in,25 SECONDS,target=apc))
		apc.hijacker = imp_in
		imp_in.toggleSiliconAccessArea(apc.area)
		apc.update_icon()
		cooldown = world.time + 2 MINUTES
		toggle_eyes(TRUE)
		stealthmode = FALSE