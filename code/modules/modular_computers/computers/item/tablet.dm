/obj/item/modular_computer/tablet  //Its called tablet for theme of 90ies but actually its a "big smartphone" sized
	name = "tablet computer"
	icon = 'icons/obj/modular_tablet.dmi'
	icon_state = "tablet-red"
	icon_state_unpowered = "tablet"
	icon_state_powered = "tablet"
	icon_state_menu = "menu"
	// worn_icon_state = "tablet"
	hardware_flag = PROGRAM_TABLET
	max_hardware_size = 1
	w_class = WEIGHT_CLASS_SMALL
	max_bays = 3
	steel_sheet_cost = 1
	slot_flags = ITEM_SLOT_ID | ITEM_SLOT_BELT
	has_light = TRUE //LED flashlight!
	comp_light_luminosity = 2.3 //Same as the PDA
	looping_sound = FALSE
	var/has_variants = TRUE
	var/finish_color = null

	//Pen stuff
	var/list/contained_item = list(/obj/item/pen, /obj/item/toy/crayon, /obj/item/lipstick, /obj/item/flashlight/pen, /obj/item/clothing/mask/cigarette)
	var/obj/item/inserted_item //Used for pen, crayon, and lipstick insertion or removal. Same as above.
	var/can_have_pen = TRUE

/obj/item/modular_computer/tablet/examine(mob/user)
	. = ..()
	if(inserted_item && (!isturf(loc)))
		. += "<span class='notice'>Ctrl-click to remove [inserted_item].</span>"

/obj/item/modular_computer/tablet/Initialize()
	. = ..()
	if(can_have_pen)
		if(inserted_item)
			inserted_item = new inserted_item(src)
		else
			inserted_item =	new /obj/item/pen(src)

/obj/item/modular_computer/tablet/proc/insert_pen(obj/item/pen)
	if(!usr.transferItemToLoc(pen, src))
		return
	to_chat(usr, "<span class='notice'>You slide \the [pen] into \the [src]'s pen slot.</span>")
	inserted_item = pen
	playsound(src, 'sound/machines/button.ogg', 50, 1)

/obj/item/modular_computer/tablet/proc/remove_pen()
	if(hasSiliconAccessInArea(usr) || !usr.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return

	if(inserted_item)
		usr.put_in_hands(inserted_item)
		to_chat(usr, "<span class='notice'>You remove [inserted_item] from \the [src]'s pen slot.</span>")
		inserted_item = null
	else
		to_chat(usr, "<span class='warning'>\The [src] does not have a pen in it!</span>")

/obj/item/modular_computer/tablet/CtrlClick(mob/user)
	. = ..()
	if(isturf(loc))
		return

	if(can_have_pen)
		remove_pen(user)

/obj/item/modular_computer/tablet/attackby(obj/item/W, mob/user)
	if(can_have_pen && is_type_in_list(W, contained_item))
		if(inserted_item)
			to_chat(user, "<span class='warning'>There is \a [inserted_item] blocking \the [src]'s pen slot!</span>")
			return
		else
			insert_pen(W)
			return
	. = ..()

/obj/item/modular_computer/tablet/Destroy()
	if(istype(inserted_item))
		QDEL_NULL(inserted_item)
	return ..()

/obj/item/modular_computer/tablet/ui_data(mob/user)
	. = ..()
	.["PC_showpeneject"] = inserted_item ? 1 : 0

/obj/item/modular_computer/tablet/update_icon_state()
	if(has_variants)
		if(!finish_color)
			finish_color = pick("red","blue","brown","green","black")
		icon_state = icon_state_powered = icon_state_unpowered = "tablet-[finish_color]"

/obj/item/modular_computer/tablet/syndicate_contract_uplink
	name = "contractor tablet"
	icon = 'icons/obj/contractor_tablet.dmi'
	icon_state = "tablet"
	icon_state_unpowered = "tablet"
	icon_state_powered = "tablet"
	icon_state_menu = "assign"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_ID | ITEM_SLOT_BELT
	comp_light_luminosity = 6.3
	has_variants = FALSE

/// Given to Nuke Ops members.
/obj/item/modular_computer/tablet/nukeops
	icon_state = "tablet-syndicate"
	comp_light_luminosity = 6.3
	has_variants = FALSE
	device_theme = "syndicate"
	light_color = COLOR_RED

/obj/item/modular_computer/tablet/nukeops/emag_act(mob/user)
	if(!enabled)
		to_chat(user, "<span class='warning'>You'd need to turn the [src] on first.</span>")
		return FALSE
	to_chat(user, "<span class='notice'>You swipe \the [src]. It's screen briefly shows a message reading \"MEMORY CODE INJECTION DETECTED AND SUCCESSFULLY QUARANTINED\".</span>")
	return FALSE

/// Borg Built-in tablet interface
/obj/item/modular_computer/tablet/integrated
	name = "modular interface"
	icon_state = "tablet-silicon"
	has_light = FALSE //tablet light button actually enables/disables the borg lamp
	comp_light_luminosity = 0
	has_variants = FALSE
	///Ref to the borg we're installed in. Set by the borg during our creation.
	var/mob/living/silicon/robot/borgo
	///Ref to the RoboTact app. Important enough to borgs to deserve a ref.
	var/datum/computer_file/program/robotact/robotact
	///IC log that borgs can view in their personal management app
	var/list/borglog = list()
	can_have_pen = FALSE

/obj/item/modular_computer/tablet/integrated/Initialize(mapload)
	. = ..()
	vis_flags |= VIS_INHERIT_ID
	borgo = loc
	if(!istype(borgo))
		borgo = null
		stack_trace("[type] initialized outside of a borg, deleting.")
		return INITIALIZE_HINT_QDEL

/obj/item/modular_computer/tablet/integrated/Destroy()
	borgo = null
	return ..()

/obj/item/modular_computer/tablet/integrated/turn_on(mob/user)
	if(borgo?.stat != DEAD)
		return ..()
	return FALSE

/**
 * Returns a ref to the RoboTact app, creating the app if need be.
 *
 * The RoboTact app is important for borgs, and so should always be available.
 * This proc will look for it in the tablet's robotact var, then check the
 * hard drive if the robotact var is unset, and finally attempt to create a new
 * copy if the hard drive does not contain the app. If the hard drive rejects
 * the new copy (such as due to lack of space), the proc will crash with an error.
 * RoboTact is supposed to be undeletable, so these will create runtime messages.
 */
/obj/item/modular_computer/tablet/integrated/proc/get_robotact()
	if(!borgo)
		return null
	if(!robotact)
		var/obj/item/computer_hardware/hard_drive/hard_drive = all_components[MC_HDD]
		robotact = hard_drive.find_file_by_name("robotact")
		if(!robotact)
			stack_trace("Cyborg [borgo] ( [borgo.type] ) was somehow missing their self-manage app in their tablet. A new copy has been created.")
			robotact = new(hard_drive)
			if(!hard_drive.store_file(robotact))
				qdel(robotact)
				robotact = null
				CRASH("Cyborg [borgo]'s tablet hard drive rejected recieving a new copy of the self-manage app. To fix, check the hard drive's space remaining. Please make a bug report about this.")
	return robotact

//Makes the light settings reflect the borg's headlamp settings
/obj/item/modular_computer/tablet/integrated/ui_data(mob/user)
	. = ..()
	.["has_light"] = TRUE
	.["light_on"] = borgo?.lamp_intensity
	.["comp_light_color"] = borgo?.lamp_color

//Makes the flashlight button affect the borg rather than the tablet
/obj/item/modular_computer/tablet/integrated/toggle_flashlight()
	if(!borgo || QDELETED(borgo))
		return FALSE
	borgo.toggle_headlamp()
	return TRUE

//Makes the flashlight color setting affect the borg rather than the tablet
/obj/item/modular_computer/tablet/integrated/set_flashlight_color(color)
	if(!borgo || QDELETED(borgo) || !color)
		return FALSE
	borgo.lamp_color = color
	borgo.toggle_headlamp(FALSE, TRUE)
	return TRUE

/obj/item/modular_computer/tablet/integrated/alert_call(datum/computer_file/program/caller, alerttext, sound = 'sound/machines/twobeep_high.ogg')
	if(!caller || !caller.alert_able || caller.alert_silenced || !alerttext) //Yeah, we're checking alert_able. No, you don't get to make alerts that the user can't silence.
		return
	borgo.playsound_local(src, sound, 50, TRUE)
	to_chat(borgo, "<span class='notice'>The [src] displays a [caller.filedesc] notification: [alerttext]</span>")


/obj/item/modular_computer/tablet/integrated/syndicate
	icon_state = "tablet-silicon-syndicate"
	device_theme = "syndicate"


/obj/item/modular_computer/tablet/integrated/syndicate/Initialize()
	. = ..()
	borgo.lamp_color = COLOR_RED //Syndicate likes it red
