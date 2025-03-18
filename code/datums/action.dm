/**
 * # Action system
 *
 * A simple base for an modular behavior attached to atom or datum.
 */
/datum/action
	/// The name of the action
	var/name = "Generic Action"
	/// The description of what the action does, shown in button tooltips
	var/desc = null
	/// The target the action is attached to. If the target datum is deleted, the action is as well.
	/// Set in New() via the proc link_to(). PLEASE set a target if you're making an action
	var/datum/target = null
	/// Where any buttons we create should be by default. Accepts screen_loc and location defines
	var/default_button_position = SCRN_OBJ_IN_LIST
	/// This is who currently owns the action, and most often, this is who is using the action if it is triggered
	/// This can be the same as "target" but is not ALWAYS the same - this is set and unset with Grant() and Remove()
	var/mob/owner
	/// If False, the owner of this action does not get a hud and cannot activate it on their own
	var/owner_has_control = TRUE
	/// Flags that will determine of the owner / user of the action can... use the action
	var/check_flags = NONE
	var/required_mobility_flags = MOBILITY_USE
	var/processing = FALSE
	/// Whether the button becomes transparent when it can't be used, or just reddened
	var/transparent_when_unavailable = TRUE
	///List of all mobs that are viewing our action button -> A unique movable for them to view.
	var/list/viewers = list()
	/// If TRUE, this action button will be shown to observers / other mobs who view from this action's owner's eyes.
	/// Used in [/mob/proc/show_other_mob_action_buttons]
	var/show_to_observers = TRUE

	/// The style the button's tooltips appear to be
	var/buttontooltipstyle = ""

	/// This is the file for the BACKGROUND underlay icon of the button
	var/background_icon = 'icons/mob/actions/backgrounds.dmi'
	/// This is the icon state state for the BACKGROUND underlay icon of the button
	/// (If set to ACTION_BUTTON_DEFAULT_BACKGROUND, uses the hud's default background)
	var/background_icon_state = ACTION_BUTTON_DEFAULT_BACKGROUND

	/// This is the file for the icon that appears on the button
	var/button_icon = 'icons/hud/actions.dmi'
	/// This is the icon state for the icon that appears on the button
	var/button_icon_state = "default"

	/// This is the file for any FOREGROUND overlay icons on the button (such as borders)
	var/overlay_icon = 'icons/mob/actions/backgrounds.dmi'
	/// This is the icon state for any FOREGROUND overlay icons on the button (such as borders)
	var/overlay_icon_state

	/// full key we are bound to
	var/full_key

	/// Toggles whether this action is usable or not
	var/action_disabled = FALSE
	/// Can this action be shared with our rider?
	var/can_be_shared = TRUE

/datum/action/New(Target)
	link_to(Target)

/datum/action/proc/link_to(Target)
	target = Target
	RegisterSignal(Target, COMSIG_PARENT_QDELETING, PROC_REF(clear_ref), override = TRUE)

	if(isatom(Target))
		RegisterSignal(Target, COMSIG_ATOM_UPDATED_ICON, PROC_REF(OnUpdatedIcon))

/datum/action/Destroy()
	if(owner)
		Remove(owner)
	target = null
	QDEL_LIST_ASSOC_VAL(viewers) // Qdel the buttons in the viewers list **NOT THE HUDS**
	return ..()

/// Signal proc that clears any references based on the owner or target deleting
/// If the owner's deleted, we will simply remove from them, but if the target's deleted, we will self-delete
/datum/action/proc/clear_ref(datum/ref)
	SIGNAL_HANDLER
	if(ref == owner)
		Remove(owner)
	if(ref == target)
		qdel(src)

/datum/action/proc/Grant(mob/grant_to)
	if(isnull(grant_to))
		Remove(owner)
		return
	if(grant_to == owner)
		return // We already have it
	var/mob/previous_owner = owner
	owner = grant_to
	if(!isnull(previous_owner))
		Remove(previous_owner)
	SEND_SIGNAL(src, COMSIG_ACTION_GRANTED, owner)
	SEND_SIGNAL(owner, COMSIG_MOB_GRANTED_ACTION, src)
	RegisterSignal(owner, COMSIG_PARENT_QDELETING, PROC_REF(clear_ref), override = TRUE)

	// Register some signals based on our check_flags
	// so that our button icon updates when relevant
	if(check_flags & AB_CHECK_CONSCIOUS)
		RegisterSignal(owner, COMSIG_MOB_STATCHANGE, PROC_REF(update_status_on_signal))
	if(check_flags & AB_CHECK_LYING)
		RegisterSignal(owner, COMSIG_LIVING_RESTING, PROC_REF(update_status_on_signal))

	GiveAction(grant_to)

/datum/action/proc/Remove(mob/remove_from)
	SHOULD_CALL_PARENT(TRUE)

	for(var/datum/hud/hud in viewers)
		if(!hud.mymob)
			continue
		HideFrom(hud.mymob)
	LAZYREMOVE(remove_from?.actions, src) // We aren't always properly inserted into the viewers list, gotta make sure that action's cleared
	viewers = list()

	if(isnull(owner))
		return
	UnregisterSignal(owner, COMSIG_PARENT_QDELETING)

	// Clean up our check_flag signals
	UnregisterSignal(owner, list(
		COMSIG_LIVING_RESTING,
		COMSIG_MOB_STATCHANGE,
	))

	if(target == owner)
		RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(clear_ref))
	if(owner == remove_from)
		owner = null

/// Actually triggers the effects of the action.
/// Called when the on-screen button is clicked, for example.
/datum/action/proc/Trigger(trigger_flags)
	if(!(trigger_flags & TRIGGER_FORCE_AVAILABLE) && !IsAvailable(feedback = TRUE))
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_ACTION_TRIGGER, target) & COMPONENT_ACTION_BLOCK_TRIGGER)
		return FALSE
	return TRUE

/datum/action/proc/Process()
	return

/**
 * Whether our action is currently available to use or not
 * * feedback - If true this is being called to check if we have any messages to show to the owner
 */
/datum/action/proc/IsAvailable(feedback = FALSE)
	if(!owner)
		return FALSE
	if(action_disabled)
		return FALSE
	var/mob/living/L = owner
	if(istype(L) && !CHECK_ALL_MOBILITY(L, required_mobility_flags))
		return FALSE
	if(check_flags & AB_CHECK_RESTRAINED && owner.restrained())
		if (feedback)
			owner.balloon_alert(owner, "restrained!")
		return FALSE
	if(check_flags & AB_CHECK_STUN)
		if(istype(L) && !CHECK_MOBILITY(L, MOBILITY_USE))
			return FALSE
	if(check_flags & AB_CHECK_LYING)
		if(istype(L) && !CHECK_MOBILITY(L, MOBILITY_STAND))
			if (feedback)
				owner.balloon_alert(owner, "must stand up!")
			return FALSE
	if(check_flags & AB_CHECK_CONSCIOUS && owner.stat != CONSCIOUS)
		if (feedback)
			switch(owner.stat)
				if(SOFT_CRIT)
					owner.balloon_alert(owner, "soft crit!")
				if(UNCONSCIOUS)
					owner.balloon_alert(owner, "unconscious!")
				if(DEAD)
					owner.balloon_alert(owner, "dead!")
		return FALSE
	return TRUE

/// Builds / updates all buttons we have shared or given out
/datum/action/proc/build_all_button_icons(update_flags = ALL, force)
	for(var/datum/hud/hud as anything in viewers)
		build_button_icon(viewers[hud], update_flags, force)

/**
 * Builds the icon of the button.
 *
 * Concept:
 * - Underlay (Background icon)
 * - Icon (button icon)
 * - Maptext
 * - Overlay (Background border)
 *
 * button - which button we are modifying the icon of
 * force - whether we're forcing a full update
 */
/datum/action/proc/build_button_icon(atom/movable/screen/movable/action_button/button, update_flags = ALL, force = FALSE)
	if(!button)
		return

	if(update_flags & UPDATE_BUTTON_NAME)
		update_button_name(button, force)

	if(update_flags & UPDATE_BUTTON_BACKGROUND)
		apply_button_background(button, force)

	if(update_flags & UPDATE_BUTTON_ICON)
		apply_button_icon(button, force)

	if(update_flags & UPDATE_BUTTON_OVERLAY)
		apply_button_overlay(button, force)

	if(update_flags & UPDATE_BUTTON_STATUS)
		update_button_status(button, force)

/**
 * Updates the name and description of the button to match our action name and discription.
 *
 * current_button - what button are we editing?
 * force - whether an update is forced regardless of existing status
 */
/datum/action/proc/update_button_name(atom/movable/screen/movable/action_button/button, force = FALSE)
	button.name = name
	if(desc)
		button.desc = desc

/**
 * Creates the background underlay for the button
 *
 * current_button - what button are we editing?
 * force - whether an update is forced regardless of existing status
 */
/datum/action/proc/apply_button_background(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	if(!background_icon || !background_icon_state || (current_button.active_underlay_icon_state == background_icon_state && !force))
		return

	// What icons we use for our background
	var/list/icon_settings = list(
		// The icon file
		"bg_icon" = background_icon,
		// The icon state, if is_action_active() returns FALSE
		"bg_state" = background_icon_state,
		// The icon state, if is_action_active() returns TRUE
		"bg_state_active" = background_icon_state,
	)

	// If background_icon_state is ACTION_BUTTON_DEFAULT_BACKGROUND instead use our hud's action button scheme
	if(background_icon_state == ACTION_BUTTON_DEFAULT_BACKGROUND && owner?.hud_used)
		icon_settings = owner.hud_used.get_action_buttons_icons()

	// Determine which icon to use
	var/used_icon_key = is_action_active(current_button) ? "bg_state_active" : "bg_state"

	// Make the underlay
	current_button.underlays.Cut()
	current_button.underlays += image(icon = icon_settings["bg_icon"], icon_state = icon_settings[used_icon_key])
	current_button.active_underlay_icon_state = icon_settings[used_icon_key]

/**
 * Applies our button icon and icon state to the button
 *
 * current_button - what button are we editing?
 * force - whether an update is forced regardless of existing status
 */
/datum/action/proc/apply_button_icon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	if(!button_icon || !button_icon_state || (current_button.icon_state == button_icon_state && !force))
		return

	current_button.icon = button_icon
	current_button.icon_state = button_icon_state

/**
 * Applies any overlays to our button
 *
 * current_button - what button are we editing?
 * force - whether an update is forced regardless of existing status
 */
/datum/action/proc/apply_button_overlay(atom/movable/screen/movable/action_button/current_button, force = FALSE)

	SEND_SIGNAL(src, COMSIG_ACTION_OVERLAY_APPLY, current_button, force)

	if(!overlay_icon || !overlay_icon_state || (current_button.active_overlay_icon_state == overlay_icon_state && !force))
		return

	current_button.cut_overlay(current_button.button_overlay)
	current_button.button_overlay = mutable_appearance(icon = overlay_icon, icon_state = overlay_icon_state)
	current_button.add_overlay(current_button.button_overlay)
	current_button.active_overlay_icon_state = overlay_icon_state

/**
 * Any other miscellaneous "status" updates within the action button is handled here,
 * such as redding out when unavailable or modifying maptext.
 *
 * current_button - what button are we editing?
 * force - whether an update is forced regardless of existing status
 */
/datum/action/proc/update_button_status(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	current_button.update_keybind_maptext(full_key)
	if(IsAvailable())
		current_button.color = rgb(255,255,255,255)
	else
		current_button.color = transparent_when_unavailable ? rgb(128,0,0,128) : rgb(128,0,0)

/datum/action/ghost
	button_icon = 'icons/mob/mob.dmi'
	button_icon_state = "ghost"
	name = "Ghostize"
	desc = "Turn into a ghost and freely come back to your body."

/datum/action/ghost/Trigger(trigger_flags)
	if(!..())
		return FALSE
	var/mob/M = target
	M.ghostize(can_reenter_corpse = TRUE, voluntary = TRUE)
	return TRUE

/datum/action/proc/OnUpdatedIcon()
	SIGNAL_HANDLER
	build_all_button_icons(force = TRUE)

/// Gives our action to the passed viewer.
/// Puts our action in their actions list and shows them the button.
/datum/action/proc/GiveAction(mob/viewer)
	var/datum/hud/our_hud = viewer.hud_used
	if(viewers[our_hud]) // Already have a copy of us? go away
		return

	LAZYOR(viewer.actions, src) // Move this in
	ShowTo(viewer)

/// Adds our action button to the screen of the passed viewer.
/datum/action/proc/ShowTo(mob/viewer)
	var/datum/hud/our_hud = viewer.hud_used
	if(!our_hud || viewers[our_hud]) // There's no point in this if you have no hud in the first place
		return

	var/atom/movable/screen/movable/action_button/button = create_button()
	SetId(button, viewer)

	button.our_hud = our_hud
	viewers[our_hud] = button
	if(viewer.client)
		viewer.client.screen += button

	button.load_position(viewer)
	viewer.update_action_buttons()

/// Removes our action from the passed viewer.
/datum/action/proc/HideFrom(mob/viewer)
	var/datum/hud/our_hud = viewer.hud_used
	var/atom/movable/screen/movable/action_button/button = viewers[our_hud]
	LAZYREMOVE(viewer.actions, src)
	if(button)
		qdel(button)

/datum/action/proc/create_button()
	var/atom/movable/screen/movable/action_button/button = new()
	button.linked_action = src
	build_button_icon(button, ALL, TRUE)
	return button

/datum/action/proc/SetId(atom/movable/screen/movable/action_button/our_button, mob/owner)
	//button id generation
	var/bitfield = 0
	for(var/datum/action/action in owner.actions)
		if(action == src) // This could be us, which is dumb
			continue
		var/atom/movable/screen/movable/action_button/button = action.viewers[owner.hud_used]
		if(action.name == name && button.id)
			bitfield |= button.id

	bitfield = ~bitfield // Flip our possible ids, so we can check if we've found a unique one
	for(var/i in 0 to 23) // We get 24 possible bitflags in dm
		var/bitflag = 1 << i // Shift us over one
		if(bitfield & bitflag)
			our_button.id = bitflag
			return

/// Updates our buttons if our target's icon was updated
/datum/action/proc/on_target_icon_update(datum/source, updates, updated)
	SIGNAL_HANDLER

	var/update_flag = NONE
	var/forced = FALSE
	if(updates & UPDATE_ICON_STATE)
		update_flag |= UPDATE_BUTTON_ICON
		forced = TRUE
	if(updates & UPDATE_OVERLAYS)
		update_flag |= UPDATE_BUTTON_OVERLAY
		forced = TRUE
	if(updates & (UPDATE_NAME|UPDATE_DESC))
		update_flag |= UPDATE_BUTTON_NAME
	// Status is not relevant, and background is not relevant. Neither will change

	// Force the update if an icon state or overlay change was done
	build_all_button_icons(update_flag, forced)

/// A general use signal proc that reacts to an event and updates JUST our button's status
/datum/action/proc/update_status_on_signal(datum/source, new_stat, old_stat)
	SIGNAL_HANDLER

	build_all_button_icons(UPDATE_BUTTON_STATUS)

/// Signal proc for COMSIG_MIND_TRANSFERRED - for minds, transfers our action to our new mob on mind transfer
/datum/action/proc/on_target_mind_swapped(datum/mind/source, mob/old_current)
	SIGNAL_HANDLER

	// Grant() calls Remove() from the existing owner so we're covered on that
	Grant(source.current)

/// Checks if our action is actively selected. Used for selecting icons primarily.
/datum/action/proc/is_action_active(atom/movable/screen/movable/action_button/current_button)
	return FALSE

/datum/action/proc/keydown(mob/source, key, client/client, full_key)
	SIGNAL_HANDLER
	if(isnull(full_key) || full_key != src.full_key)
		return
	if(istype(source))
		if(!source.CheckActionCooldown())
			return
		else
			source.DelayNextAction(1)
	INVOKE_ASYNC(src, PROC_REF(Trigger))

/datum/action/item_action/toggle_light
	name = "Toggle Light"

/datum/action/item_action/toggle_light/pda/do_effect(trigger_flags)
	var/obj/item/pda/P = target
	if(!istype(P))
		return FALSE
	return P.toggle_light(owner)

/datum/action/item_action/toggle_hood
	name = "Toggle Hood"

/datum/action/item_action/toggle_firemode
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "fireselect_no"
	name = "Toggle Firemode"

/datum/action/item_action/rcl_col
	name = "Change Cable Color"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "rcl_rainbow"

/datum/action/item_action/rcl_gui
	name = "Toggle Fast Wiring Gui"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "rcl_gui"

/datum/action/item_action/startchainsaw
	name = "Pull The Starting Cord"

/datum/action/item_action/toggle_gunlight
	name = "Toggle Gunlight"

/datum/action/item_action/toggle_mode
	name = "Toggle Mode"

/datum/action/item_action/toggle_barrier_spread
	name = "Toggle Barrier Spread"

/datum/action/item_action/equip_unequip_TED_Gun
	name = "Equip/Unequip TED Gun"

/datum/action/item_action/toggle_paddles
	name = "Toggle Paddles"

/datum/action/item_action/set_internals
	name = "Set Internals"
	default_button_position = SCRN_OBJ_INSERT_FIRST
	overlay_icon_state = "ab_goldborder"

/datum/action/item_action/set_internals/is_action_active(atom/movable/screen/movable/action_button/current_button)
	var/mob/living/carbon/carbon_owner = owner
	return istype(carbon_owner) && target == carbon_owner.internal

/datum/action/item_action/pick_color
	name = "Choose A Color"

/datum/action/item_action/toggle_mister
	name = "Toggle Mister"

/datum/action/item_action/activate_injector
	name = "Activate Injector"

/datum/action/item_action/toggle_helmet_light
	name = "Toggle Helmet Light"

/datum/action/item_action/toggle_welding_screen
	name = "Toggle Welding Screen"

/datum/action/item_action/toggle_welding_screen/do_effect(trigger_flags)
	var/obj/item/clothing/head/hardhat/weldhat/H = target
	if(!istype(H))
		return FALSE
	H.toggle_welding_screen(owner)
	return TRUE

/datum/action/item_action/toggle_welding_screen/plasmaman

/datum/action/item_action/toggle_welding_screen/plasmaman/do_effect(trigger_flags)
	var/obj/item/clothing/head/helmet/space/plasmaman/H = target
	if(!istype(H))
		return FALSE
	H.toggle_welding_screen(owner)
	return TRUE

/datum/action/item_action/toggle_headphones
	name = "Toggle Headphones"
	desc = "UNTZ UNTZ UNTZ"

/datum/action/item_action/toggle_headphones/do_effect(trigger_flags)
	var/obj/item/clothing/ears/headphones/H = target
	if(!istype(H))
		return FALSE
	H.toggle(owner)
	return TRUE

/datum/action/item_action/toggle_unfriendly_fire
	name = "Toggle Friendly Fire \[ON\]"
	desc = "Toggles if the club's blasts cause friendly fire."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "vortex_ff_on"

/datum/action/item_action/toggle_unfriendly_fire/update_button_name(atom/movable/screen/movable/action_button/button, force)
	var/obj/item/hierophant_club/club = target
	name = "Toggle Friendly Fire [club.friendly_fire_check ? "\[OFF\]" : "\[ON\]"]"
	return ..()

/datum/action/item_action/toggle_unfriendly_fire/apply_button_icon(atom/movable/screen/movable/action_button/current_button, force)
	var/obj/item/hierophant_club/club = target
	button_icon_state = club.friendly_fire_check ? "vortex_ff_off" : "vortex_ff_on"
	return ..()

/datum/action/item_action/vortex_recall
	name = "Vortex Recall"
	desc = "Recall yourself, and anyone nearby, to an attuned hierophant beacon at any time.<br>If the beacon is still attached, will detach it."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "vortex_recall"

/datum/action/item_action/vortex_recall/IsAvailable(feedback = TRUE)
	if(!istype(target, /obj/item/hierophant_club))
		return FALSE
	var/obj/item/hierophant_club/teleport_stick = target
	if(teleport_stick.teleporting)
		return FALSE
	return ..()

/datum/action/item_action/clock
	button_icon = 'icons/mob/actions/actions_clockcult.dmi'
	background_icon_state = "bg_clock"
	buttontooltipstyle = "clockcult"

/datum/action/item_action/clock/IsAvailable(feedback = TRUE)
	if(!is_servant_of_ratvar(owner))
		return FALSE
	return ..()

/datum/action/item_action/clock/toggle_visor
	name = "Create Judicial Marker"
	desc = "Allows you to create a stunning Judicial Marker at any location in view. Click again to disable."

/datum/action/item_action/clock/toggle_visor/IsAvailable(feedback = TRUE)
	if(!is_servant_of_ratvar(owner))
		return FALSE
	if(!istype(target, /obj/item/clothing/glasses/judicial_visor))
		return FALSE
	var/obj/item/clothing/glasses/judicial_visor/goggles = target
	if(goggles.recharging)
		return FALSE
	return ..()

/datum/action/item_action/clock/hierophant
	name = "Hierophant Network"
	desc = "Lets you discreetly talk with all other servants. Nearby listeners can hear you whispering, so make sure to do this privately."
	button_icon_state = "hierophant_slab"

/datum/action/item_action/clock/quickbind
	name = "Quickbind"
	desc = "If you're seeing this, file a bug report."
	var/scripture_index = 0 //the index of the scripture we're associated with

/datum/action/item_action/toggle_helmet_flashlight
	name = "Toggle Helmet Flashlight"

/datum/action/item_action/toggle_helmet_mode
	name = "Toggle Helmet Mode"

/datum/action/item_action/toggle

/datum/action/item_action/toggle/New(Target)
	..()
	var/obj/item/item_target = target
	name = "Toggle [item_target.name]"

/datum/action/item_action/halt
	name = "HALT!"

/datum/action/item_action/toggle_voice_box
	name = "Toggle Voice Box"

/datum/action/item_action/change
	name = "Change"

/datum/action/item_action/nano_picket_sign
	name = "Retext Nano Picket Sign"

/datum/action/item_action/nano_picket_sign/do_effect(trigger_flags)
	if(!istype(target, /obj/item/picket_sign))
		return FALSE
	var/obj/item/picket_sign/sign = target
	sign.retext(owner)
	return TRUE

/datum/action/item_action/adjust

/datum/action/item_action/adjust/New(Target)
	..()
	var/obj/item/item_target = target
	name = "Adjust [item_target.name]"


/datum/action/item_action/switch_hud
	name = "Switch HUD"

/datum/action/item_action/toggle_wings
	name = "Toggle Wings"

/datum/action/item_action/toggle_human_head
	name = "Toggle Human Head"

/datum/action/item_action/toggle_helmet
	name = "Toggle Helmet"

/datum/action/item_action/toggle_jetpack
	name = "Toggle Jetpack"

/datum/action/item_action/jetpack_stabilization
	name = "Toggle Jetpack Stabilization"

/datum/action/item_action/jetpack_stabilization/IsAvailable(feedback = TRUE)
	var/obj/item/tank/jetpack/J = target
	if(!istype(J) || !J.on)
		return FALSE
	return ..()

/datum/action/item_action/hands_free
	check_flags = AB_CHECK_CONSCIOUS
	required_mobility_flags = NONE

/datum/action/item_action/hands_free/activate
	name = "Activate"

/datum/action/item_action/hands_free/shift_nerves
	name = "Shift Nerves"

/datum/action/item_action/explosive_implant
	check_flags = NONE
	required_mobility_flags = NONE
	name = "Activate Explosive Implant"

/datum/action/item_action/toggle_research_scanner
	name = "Toggle Research Scanner"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "scan_mode"
	var/active = FALSE

/datum/action/item_action/toggle_research_scanner/do_effect(trigger_flags)
	if(!IsAvailable())
		return FALSE
	active = !active
	if(active)
		owner.research_scanner++
	else
		owner.research_scanner--
	to_chat(owner, span_notice("[target] research scanner has been [active ? "activated" : "deactivated"]."))
	return TRUE

/datum/action/item_action/toggle_research_scanner/Remove(mob/M)
	if(owner && active)
		owner.research_scanner--
		active = FALSE
	..()

/datum/action/item_action/instrument
	name = "Use Instrument"
	desc = "Use the instrument specified"

/datum/action/item_action/instrument/do_effect(trigger_flags)
	if(!istype(target, /obj/item/instrument))
		return FALSE
	var/obj/item/instrument/I = target
	I.interact(usr)
	return TRUE

/datum/action/item_action/organ_action
	name = "Organ Action"
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/item_action/organ_action/IsAvailable(feedback)
	var/obj/item/organ/attached_organ = target
	if(!attached_organ.owner)
		return FALSE
	return ..()

/datum/action/item_action/organ_action/toggle
	name = "Toggle Organ"

/datum/action/item_action/organ_action/toggle/New(Target)
	..()
	var/obj/item/organ/organ_target = target
	name = "Toggle [organ_target.name]"

/datum/action/item_action/organ_action/use
	name = "Use Organ"

/datum/action/item_action/organ_action/use/New(Target)
	..()
	var/obj/item/organ/organ_target = target
	name = "Use [organ_target.name]"


/datum/action/item_action/cult_dagger
	name = "Draw Blood Rune"
	desc = "Use the ritual dagger to create a powerful blood rune"
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "draw"
	buttontooltipstyle = "cult"
	background_icon_state = "bg_demon"
	default_button_position = "6:157,4:-2"

/datum/action/item_action/cult_dagger/Grant(mob/grant_to)
	if(!grant_to?.mind.has_antag_datum(grant_to, /datum/antagonist/cult))
		return

	return ..()

/datum/action/item_action/cult_dagger/do_effect(trigger_flags)
	if(!isliving(owner))
		to_chat(owner, span_warning("You lack the necessary living force for this action."))
		return FALSE

	var/obj/item/target_item = target
	var/mob/living/living_owner = owner
	if(target in owner.held_items)
		target_item.attack_self(owner)
		return TRUE

	if(owner.can_equip(target_item, ITEM_SLOT_HANDS))
		owner.temporarilyRemoveItemFromInventory(target_item)
		owner.put_in_hands(target_item)
		target_item.attack_self(owner)
		return TRUE

	if (living_owner.get_num_arms())
		to_chat(living_owner, span_warning("You don't have any usable hands!"))
	else
		to_chat(living_owner, span_warning("Your hands are full!"))
	return FALSE


//MGS Box
/datum/action/item_action/agent_box
	name = "Deploy Box"
	desc = "Find inner peace, here, in the box."
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_CONSCIOUS
	background_icon_state = "bg_agent"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "deploy_box"
	var/boxtype = /obj/structure/closet/cardboard/agent
	COOLDOWN_DECLARE(box_cooldown)

//Handles open and closing the box
/datum/action/item_action/agent_box/do_effect(trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	if(istype(owner.loc, /obj/structure/closet/cardboard/agent))
		var/obj/structure/closet/cardboard/agent/box = owner.loc
		if(box.open())
			owner.playsound_local(box, 'sound/misc/box_deploy.ogg', 50, TRUE)
		return FALSE
	//Box closing from here on out.
	if(!isturf(owner.loc)) //Don't let the player use this to escape mechs/welded closets.
		to_chat(owner, span_warning("You need more space to activate this implant."))
		return FALSE
	if(!COOLDOWN_FINISHED(src, box_cooldown))
		return FALSE
	COOLDOWN_START(src, box_cooldown, 10 SECONDS)
	var/box = new boxtype(owner.drop_location())
	owner.forceMove(box)
	owner.playsound_local(box, 'sound/misc/box_deploy.ogg', 50, TRUE)

/datum/action/item_action/removeAPCs
	name = "Relinquish APC"
	desc = "Let go of an APC, relinquish control back to the station."
	button_icon = 'icons/obj/implants.dmi'
	button_icon_state = "hijackx"

/datum/action/item_action/removeAPCs/do_effect(trigger_flags)
	var/list/areas = list()
	for (var/area/a in owner.siliconaccessareas)
		areas[a.name] = a
	var/removeAPC = input("Select an APC to remove:","Remove APC Control",1) as null|anything in areas
	if (!removeAPC)
		return FALSE
	var/area/area = areas[removeAPC]
	var/obj/machinery/power/apc/apc = area.get_apc()
	if (!apc || !(area in owner.siliconaccessareas))
		return FALSE
	apc.hijacker = null
	apc.update_icon()
	apc.set_hijacked_lighting()
	owner.toggleSiliconAccessArea(area)
	return TRUE

/datum/action/item_action/accessAPCs
	name = "Access APC Interface"
	desc = "Open the APC's interface."
	button_icon = 'icons/obj/implants.dmi'
	button_icon_state = "hijacky"

/datum/action/item_action/accessAPCs/do_effect(trigger_flags)
	var/list/areas = list()
	for (var/area/a in owner.siliconaccessareas)
		areas[a.name] = a
	var/accessAPC = input("Select an APC to access:","Access APC Interface",1) as null|anything in areas
	if (!accessAPC)
		return FALSE
	var/area/area = areas[accessAPC]
	var/obj/machinery/power/apc/apc = area.get_apc()
	if (!apc || !(area in owner.siliconaccessareas))
		return FALSE
	apc.ui_interact(owner)
	return TRUE

/datum/action/item_action/stealthmodetoggle
	name = "Toggle Stealth Mode"
	desc = "Toggles the stealth mode on the hijack implant."
	button_icon = 'icons/obj/implants.dmi'
	button_icon_state = "hijackz"

/datum/action/item_action/stealthmodetoggle/do_effect(trigger_flags)
	var/obj/item/implant/hijack/H = target
	if (!istype(H))
		return FALSE
	if (H.stealthcooldown > world.time)
		to_chat(owner, span_warning("The hijack implant's stealth mode toggle is still rebooting!"))
		return FALSE
	H.stealthmode = !H.stealthmode
	for (var/area/area in H.imp_in.siliconaccessareas)
		var/obj/machinery/power/apc/apc = area.get_apc()
		if (apc)
			apc.set_hijacked_lighting()
			apc.update_icon()
	H.stealthcooldown = world.time + 15 SECONDS
	H.toggle_eyes()
	to_chat(owner, span_notice("You toggle the hijack implant's stealthmode [H.stealthmode ? "on" : "off"]."))
	return TRUE

/datum/action/item_action/flash
	name = "Flash"

//Preset for spells
/datum/action/spell_action
	check_flags = 0
	background_icon_state = "bg_spell"

/datum/action/spell_action/New(Target)
	..()
	var/obj/effect/proc_holder/S = target
	S.action = src
	name = S.name
	desc = S.desc
	button_icon = S.action_icon
	button_icon_state = S.action_icon_state
	background_icon_state = S.action_background_icon_state

/datum/action/spell_action/Destroy()
	var/obj/effect/proc_holder/S = target
	S.action = null
	return ..()

/datum/action/spell_action/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	if(!target)
		return FALSE
	var/obj/effect/proc_holder/S = target
	return S.Trigger(usr)

/datum/action/spell_action/IsAvailable(feedback = TRUE)
	if(!target)
		return FALSE
	return TRUE

/datum/action/spell_action/spell

/datum/action/spell_action/spell/IsAvailable(feedback = TRUE)
	if(!target)
		return FALSE
	var/obj/effect/proc_holder/spell/S = target
	if(owner)
		return S.can_cast(owner, FALSE, !feedback)
	return FALSE

/datum/action/spell_action/alien

/datum/action/spell_action/alien/IsAvailable(feedback = TRUE)
	if(!target)
		return FALSE
	var/obj/effect/proc_holder/alien/ab = target
	if(owner)
		return ab.cost_check(ab.check_turf,owner, !feedback)
	return FALSE

//surf_ss13
/datum/action/item_action/bhop
	name = "Activate Jump Boots"
	desc = "Activates the jump boot's internal propulsion system, allowing the user to dash over 4-wide gaps."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "jetboot"

/datum/action/item_action/wheelys
	name = "Toggle Wheely-Heel's Wheels"
	desc = "Pops out or in your wheely-heel's wheels."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "wheelys"

/datum/action/item_action/kindleKicks
	name = "Activate Kindle Kicks"
	desc = "Kick you feet together, activating the lights in your Kindle Kicks."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "kindleKicks"

//Small sprites
/datum/action/small_sprite
	name = "Toggle Giant Sprite"
	desc = "Others will always see you as giant"
	button_icon_state = "smallqueen"
	background_icon_state = "bg_alien"
	var/small = FALSE
	var/small_icon
	var/small_icon_state

/datum/action/small_sprite/queen
	small_icon = 'icons/mob/alien.dmi'
	small_icon_state = "alienq"

/datum/action/small_sprite/drake
	small_icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	small_icon_state = "ash_whelp"

/datum/action/small_sprite/megafauna/colossus
	small_icon_state = "Basilisk"

/datum/action/small_sprite/megafauna/bubblegum
	small_icon_state = "goliath2"

/datum/action/small_sprite/megafauna/legion
	small_icon_state = "mega_legion"

/datum/action/small_sprite/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	if(!small)
		var/image/I = image(icon = small_icon, icon_state = small_icon_state, loc = owner)
		I.override = TRUE
		I.pixel_x -= owner.pixel_x
		I.pixel_y -= owner.pixel_y
		owner.add_alt_appearance(/datum/atom_hud/alternate_appearance/basic, "smallsprite", I)
		small = TRUE
	else
		owner.remove_alt_appearance("smallsprite")
		small = FALSE
	return TRUE

/datum/action/item_action/storage_gather_mode
	name = "Switch gathering mode"
	desc = "Switches the gathering mode of a storage object."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	background_icon_state = "storage_gather_switch"

/proc/get_action_of_type(mob/M, action_type)
	if(!M.actions || !ispath(action_type, /datum/action))
		return
	for(var/datum/action/A in M.actions)
		if(istype(A, action_type))
			return A
	return
