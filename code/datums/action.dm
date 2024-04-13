#define AB_CHECK_RESTRAINED 1
#define AB_CHECK_STUN 2
#define AB_CHECK_LYING 4
#define AB_CHECK_CONSCIOUS 8
#define AB_CHECK_ALIVE 16

/datum/action
	var/name = "Generic Action"
	var/desc = null
	var/atom/target = null
	var/check_flags = 0
	var/required_mobility_flags = MOBILITY_USE
	var/processing = FALSE
	var/buttontooltipstyle = ""
	var/transparent_when_unavailable = TRUE
	/// Where any buttons we create should be by default. Accepts screen_loc and location defines
	var/default_button_position = SCRN_OBJ_IN_LIST

	var/button_icon = 'icons/mob/actions/backgrounds.dmi' //This is the file for the BACKGROUND icon
	var/background_icon_state = ACTION_BUTTON_DEFAULT_BACKGROUND //And this is the state for the background icon

	var/icon_icon = 'icons/mob/actions.dmi' //This is the file for the ACTION icon
	var/button_icon_state = "default" //And this is the state for the action icon
	var/mob/owner
	///List of all mobs that are viewing our action button -> A unique movable for them to view.
	var/list/viewers = list()

/datum/action/New(Target)
	link_to(Target)

/datum/action/proc/link_to(Target)
	target = Target
	RegisterSignal(Target, COMSIG_ATOM_UPDATED_ICON, PROC_REF(OnUpdatedIcon))

/datum/action/Destroy()
	if(owner)
		Remove(owner)
	target = null
	QDEL_LIST_ASSOC_VAL(viewers) // Qdel the buttons in the viewers list **NOT THE HUDS**
	return ..()

/datum/action/proc/Grant(mob/M)
	if(!M)
		Remove(owner)
		return
	if(owner)
		if(owner == M)
			return
		Remove(owner)
	owner = M
	RegisterSignal(owner, COMSIG_PARENT_QDELETING, PROC_REF(clear_ref), override = TRUE)

	GiveAction(M)

/datum/action/proc/clear_ref(datum/ref)
	SIGNAL_HANDLER
	if(ref == owner)
		Remove(owner)
	if(ref == target)
		qdel(src)

/datum/action/proc/Remove(mob/M)
	for(var/datum/hud/hud in viewers)
		if(!hud.mymob)
			continue
		HideFrom(hud.mymob)
	LAZYREMOVE(M.actions, src) // We aren't always properly inserted into the viewers list, gotta make sure that action's cleared
	viewers = list()

	if(owner)
		UnregisterSignal(owner, COMSIG_PARENT_QDELETING)
		if(target == owner)
			RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(clear_ref))
		owner = null

/datum/action/proc/Trigger()
	if(!IsAvailable())
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_ACTION_TRIGGER, target) & COMPONENT_ACTION_BLOCK_TRIGGER)
		return FALSE
	return TRUE

/datum/action/proc/Process()
	return

/datum/action/proc/IsAvailable(silent = FALSE)
	if(!owner)
		return FALSE
	var/mob/living/L = owner
	if(istype(L) && !CHECK_ALL_MOBILITY(L, required_mobility_flags))
		return FALSE
	if(check_flags & AB_CHECK_RESTRAINED)
		if(owner.restrained())
			return FALSE
	if(check_flags & AB_CHECK_STUN)
		if(istype(L) && !CHECK_MOBILITY(L, MOBILITY_USE))
			return FALSE
	if(check_flags & AB_CHECK_LYING)
		if(istype(L) && !CHECK_MOBILITY(L, MOBILITY_STAND))
			return FALSE
	if(check_flags & AB_CHECK_CONSCIOUS)
		if(owner.stat)
			return FALSE
	if(check_flags & AB_CHECK_ALIVE)
		if(owner.stat == DEAD)
			return FALSE
	return TRUE

/datum/action/proc/UpdateButtons(status_only, force)
	for(var/datum/hud/hud in viewers)
		var/atom/movable/screen/movable/button = viewers[hud]
		UpdateButton(button, status_only, force)

/datum/action/proc/UpdateButton(atom/movable/screen/movable/action_button/button, status_only = FALSE, force = FALSE)
	if(!button)
		return
	if(!status_only)
		button.name = name
		button.desc = desc
		if(owner?.hud_used && background_icon_state == ACTION_BUTTON_DEFAULT_BACKGROUND)
			var/list/settings = owner.hud_used.get_action_buttons_icons()
			if(button.icon != settings["bg_icon"])
				button.icon = settings["bg_icon"]
			if(button.icon_state != settings["bg_state"])
				button.icon_state = settings["bg_state"]
		else
			if(button.icon != button_icon)
				button.icon = button_icon
			if(button.icon_state != background_icon_state)
				button.icon_state = background_icon_state

		ApplyIcon(button, force)

	if(!IsAvailable(TRUE))
		button.color = transparent_when_unavailable ? rgb(128,0,0,128) : rgb(128,0,0)
	else
		button.color = rgb(255,255,255,255)
		return TRUE

/datum/action/proc/ApplyIcon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	if(icon_icon && button_icon_state && ((current_button.button_icon_state != button_icon_state) || force))
		current_button.cut_overlays()
		current_button.add_overlay(mutable_appearance(icon_icon, button_icon_state))
		current_button.button_icon_state = button_icon_state

/datum/action/ghost
	icon_icon = 'icons/mob/mob.dmi'
	button_icon_state = "ghost"
	name = "Ghostize"
	desc = "Turn into a ghost and freely come back to your body."

/datum/action/ghost/Trigger()
	if(!..())
		return FALSE
	var/mob/M = target
	M.ghostize(can_reenter_corpse = TRUE, voluntary = TRUE)

/datum/action/proc/OnUpdatedIcon()
	SIGNAL_HANDLER
	UpdateButtons(force = TRUE)

//Give our action button to the player
/datum/action/proc/GiveAction(mob/viewer)
	var/datum/hud/our_hud = viewer.hud_used
	if(viewers[our_hud]) // Already have a copy of us? go away
		return

	LAZYOR(viewer.actions, src) // Move this in
	ShowTo(viewer)

//Adds our action button to the screen of a player
/datum/action/proc/ShowTo(mob/viewer)
	var/datum/hud/our_hud = viewer.hud_used
	if(!our_hud || viewers[our_hud]) // There's no point in this if you have no hud in the first place
		return

	var/atom/movable/screen/movable/action_button/button = CreateButton()
	SetId(button, viewer)

	button.our_hud = our_hud
	viewers[our_hud] = button
	if(viewer.client)
		viewer.client.screen += button

	button.load_position(viewer)
	viewer.update_action_buttons()

//Removes our action button from the screen of a player
/datum/action/proc/HideFrom(mob/viewer)
	var/datum/hud/our_hud = viewer.hud_used
	var/atom/movable/screen/movable/action_button/button = viewers[our_hud]
	LAZYREMOVE(viewer.actions, src)
	if(button)
		qdel(button)

/datum/action/proc/CreateButton()
	var/atom/movable/screen/movable/action_button/button = new()
	button.linked_action = src
	button.actiontooltipstyle = buttontooltipstyle
	if(desc)
		button.desc = desc
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

//Presets for item actions
/datum/action/item_action
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	button_icon_state = null
	// If you want to override the normal icon being the item
	// then change this to an icon state

/datum/action/item_action/New(Target)
	..()
	var/obj/item/I = target
	LAZYINITLIST(I.actions)
	I.actions += src

/datum/action/item_action/Destroy()
	var/obj/item/I = target
	I.actions -= src
	UNSETEMPTY(I.actions)
	return ..()

/datum/action/item_action/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	if(target)
		var/obj/item/I = target
		I.ui_action_click(owner, src)
	return TRUE

/datum/action/item_action/ApplyIcon(atom/movable/screen/movable/action_button/current_button, force)
	var/obj/item/item_target = target
	if(button_icon && button_icon_state)
		// If set, use the custom icon that we set instead
		// of the item appearence
		..()
	else if((target && current_button.appearance_cache != item_target.appearance) || force) //replace with /ref comparison if this is not valid.
		var/old_layer = item_target.layer
		var/old_plane = item_target.plane
		item_target.layer = FLOAT_LAYER //AAAH
		item_target.plane = FLOAT_PLANE //^ what that guy said
		current_button.filters = null
		current_button.cut_overlays()
		current_button.add_overlay(item_target)
		item_target.layer = old_layer
		item_target.plane = old_plane
		current_button.appearance_cache = item_target.appearance

/datum/action/item_action/toggle_light
	name = "Toggle Light"

/datum/action/item_action/toggle_light/pda/Trigger(trigger_flags)
	if(istype(target, /obj/item/pda))
		var/obj/item/pda/P = target
		return P.toggle_light(owner)

/datum/action/item_action/toggle_hood
	name = "Toggle Hood"

/datum/action/item_action/toggle_firemode
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "fireselect_no"
	name = "Toggle Firemode"

/datum/action/item_action/rcl_col
	name = "Change Cable Color"
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "rcl_rainbow"

/datum/action/item_action/rcl_gui
	name = "Toggle Fast Wiring Gui"
	icon_icon = 'icons/mob/actions/actions_items.dmi'
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

/datum/action/item_action/set_internals/UpdateButton(atom/movable/screen/movable/action_button/button, status_only = FALSE, force)
	if(!..()) // no button available
		return
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/C = owner
	if(target == C.internal)
		button.icon_state = "template_active"

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

/datum/action/item_action/toggle_welding_screen/Trigger()
	var/obj/item/clothing/head/hardhat/weldhat/H = target
	if(istype(H))
		H.toggle_welding_screen(owner)

/datum/action/item_action/toggle_welding_screen/plasmaman

/datum/action/item_action/toggle_welding_screen/plasmaman/Trigger()
	var/obj/item/clothing/head/helmet/space/plasmaman/H = target
	if(istype(H))
		H.toggle_welding_screen(owner)

/datum/action/item_action/toggle_headphones
	name = "Toggle Headphones"
	desc = "UNTZ UNTZ UNTZ"

/datum/action/item_action/toggle_headphones/Trigger()
	var/obj/item/clothing/ears/headphones/H = target
	if(istype(H))
		H.toggle(owner)

/datum/action/item_action/toggle_unfriendly_fire
	name = "Toggle Friendly Fire \[ON\]"
	desc = "Toggles if the club's blasts cause friendly fire."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "vortex_ff_on"

/datum/action/item_action/toggle_unfriendly_fire/Trigger()
	if(..())
		UpdateButtons()

/datum/action/item_action/toggle_unfriendly_fire/UpdateButton(atom/movable/screen/movable/action_button/button, status_only = FALSE, force)
	if(istype(target, /obj/item/hierophant_club))
		var/obj/item/hierophant_club/H = target
		if(H.friendly_fire_check)
			button_icon_state = "vortex_ff_off"
			name = "Toggle Friendly Fire \[OFF\]"
		else
			button_icon_state = "vortex_ff_on"
			name = "Toggle Friendly Fire \[ON\]"
	..()

/datum/action/item_action/vortex_recall
	name = "Vortex Recall"
	desc = "Recall yourself, and anyone nearby, to an attuned hierophant beacon at any time.<br>If the beacon is still attached, will detach it."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "vortex_recall"

/datum/action/item_action/vortex_recall/IsAvailable(silent = FALSE)
	if(istype(target, /obj/item/hierophant_club))
		var/obj/item/hierophant_club/H = target
		if(H.teleporting)
			return FALSE
	return ..()

/datum/action/item_action/clock
	icon_icon = 'icons/mob/actions/actions_clockcult.dmi'
	background_icon_state = "bg_clock"
	buttontooltipstyle = "clockcult"

/datum/action/item_action/clock/IsAvailable(silent = FALSE)
	if(!is_servant_of_ratvar(owner))
		return FALSE
	return ..()

/datum/action/item_action/clock/toggle_visor
	name = "Create Judicial Marker"
	desc = "Allows you to create a stunning Judicial Marker at any location in view. Click again to disable."

/datum/action/item_action/clock/toggle_visor/IsAvailable(silent = FALSE)
	if(!is_servant_of_ratvar(owner))
		return FALSE
	if(istype(target, /obj/item/clothing/glasses/judicial_visor))
		var/obj/item/clothing/glasses/judicial_visor/V = target
		if(V.recharging)
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
	name = "Toggle [target.name]"

/datum/action/item_action/halt
	name = "HALT!"

/datum/action/item_action/toggle_voice_box
	name = "Toggle Voice Box"

/datum/action/item_action/change
	name = "Change"

/datum/action/item_action/nano_picket_sign
	name = "Retext Nano Picket Sign"
	var/obj/item/picket_sign/S

/datum/action/item_action/nano_picket_sign/New(Target)
	..()
	if(istype(Target, /obj/item/picket_sign))
		S = Target

/datum/action/item_action/nano_picket_sign/Trigger()
	if(istype(S))
		S.retext(owner)

/datum/action/item_action/adjust

/datum/action/item_action/adjust/New(Target)
	..()
	name = "Adjust [target.name]"

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

/datum/action/item_action/jetpack_stabilization/IsAvailable(silent = FALSE)
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
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "scan_mode"
	var/active = FALSE

/datum/action/item_action/toggle_research_scanner/Trigger()
	if(IsAvailable())
		active = !active
		if(active)
			owner.research_scanner++
		else
			owner.research_scanner--
		to_chat(owner, "<span class='notice'>[target] research scanner has been [active ? "activated" : "deactivated"].</span>")
		return TRUE

/datum/action/item_action/toggle_research_scanner/Remove(mob/M)
	if(owner && active)
		owner.research_scanner--
		active = FALSE
	..()

/datum/action/item_action/instrument
	name = "Use Instrument"
	desc = "Use the instrument specified"

/datum/action/item_action/instrument/Trigger()
	if(istype(target, /obj/item/instrument))
		var/obj/item/instrument/I = target
		I.interact(usr)
		return
	return ..()

/datum/action/item_action/organ_action
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/item_action/organ_action/IsAvailable(silent = FALSE)
	var/obj/item/organ/I = target
	if(!I.owner)
		return FALSE
	return ..()

/datum/action/item_action/organ_action/toggle/New(Target)
	..()
	name = "Toggle [target.name]"

/datum/action/item_action/organ_action/use/New(Target)
	..()
	name = "Use [target.name]"

/datum/action/item_action/cult_dagger
	name = "Draw Blood Rune"
	desc = "Use the ritual dagger to create a powerful blood rune"
	icon_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "draw"
	buttontooltipstyle = "cult"
	background_icon_state = "bg_demon"
	default_button_position = "6:157,4:-2"

/datum/action/item_action/cult_dagger/Grant(mob/M)
	if(!iscultist(M))
		Remove(owner)
		return
	return ..()

/datum/action/item_action/cult_dagger/Trigger()
	for(var/obj/item/H in owner.held_items) //In case we were already holding another dagger
		if(istype(H, /obj/item/melee/cultblade/dagger))
			H.attack_self(owner)
			return
	var/obj/item/I = target
	if(owner.can_equip(I, ITEM_SLOT_HANDS))
		owner.temporarilyRemoveItemFromInventory(I)
		owner.put_in_hands(I)
		I.attack_self(owner)
	else
		to_chat(owner, "<span class='cultitalic'>Your hands are full!</span>")

//MGS Box
/datum/action/item_action/agent_box
	name = "Deploy Box"
	desc = "Find inner peace, here, in the box."
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_CONSCIOUS
	background_icon_state = "bg_agent"
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "deploy_box"
	var/cooldown = 0
	var/boxtype = /obj/structure/closet/cardboard/agent

//Handles open and closing the box
/datum/action/item_action/agent_box/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if(istype(owner.loc, /obj/structure/closet/cardboard/agent))
		var/obj/structure/closet/cardboard/agent/box = owner.loc
		owner.playsound_local(box, 'sound/misc/box_deploy.ogg', 50, TRUE)
		box.open()
		return
	//Box closing from here on out.
	if(!isturf(owner.loc)) //Don't let the player use this to escape mechs/welded closets.
		to_chat(owner, "<span class = 'notice'>You need more space to activate this implant.</span>")
		return
	if(cooldown < world.time - 100)
		var/box = new boxtype(owner.drop_location())
		owner.forceMove(box)
		cooldown = world.time
		owner.playsound_local(box, 'sound/misc/box_deploy.ogg', 50, TRUE)

/datum/action/item_action/removeAPCs
	name = "Relinquish APC"
	desc = "Let go of an APC, relinquish control back to the station."
	icon_icon = 'icons/obj/implants.dmi'
	button_icon_state = "hijackx"

/datum/action/item_action/removeAPCs/Trigger()
	var/list/areas = list()
	for (var/area/a in owner.siliconaccessareas)
		areas[a.name] = a
	var/removeAPC = input("Select an APC to remove:","Remove APC Control",1) as null|anything in areas
	if (!removeAPC)
		return
	var/area/area = areas[removeAPC]
	var/obj/machinery/power/apc/apc = area.get_apc()
	if (!apc || !(area in owner.siliconaccessareas))
		return
	apc.hijacker = null
	apc.update_icon()
	apc.set_hijacked_lighting()
	owner.toggleSiliconAccessArea(area)

/datum/action/item_action/accessAPCs
	name = "Access APC Interface"
	desc = "Open the APC's interface."
	icon_icon = 'icons/obj/implants.dmi'
	button_icon_state = "hijacky"

/datum/action/item_action/accessAPCs/Trigger()
	var/list/areas = list()
	for (var/area/a in owner.siliconaccessareas)
		areas[a.name] = a
	var/accessAPC = input("Select an APC to access:","Access APC Interface",1) as null|anything in areas
	if (!accessAPC)
		return
	var/area/area = areas[accessAPC]
	var/obj/machinery/power/apc/apc = area.get_apc()
	if (!apc || !(area in owner.siliconaccessareas))
		return
	apc.ui_interact(owner)

/datum/action/item_action/stealthmodetoggle
	name = "Toggle Stealth Mode"
	desc = "Toggles the stealth mode on the hijack implant."
	icon_icon = 'icons/obj/implants.dmi'
	button_icon_state = "hijackz"

/datum/action/item_action/stealthmodetoggle/Trigger()
	var/obj/item/implant/hijack/H = target
	if (!istype(H))
		return
	if (H.stealthcooldown > world.time)
		to_chat(owner,"<span class='warning'>The hijack implant's stealth mode toggle is still rebooting!</span>")
		return
	H.stealthmode = !H.stealthmode
	for (var/area/area in H.imp_in.siliconaccessareas)
		var/obj/machinery/power/apc/apc = area.get_apc()
		if (apc)
			apc.set_hijacked_lighting()
			apc.update_icon()
	H.stealthcooldown = world.time + 15 SECONDS
	H.toggle_eyes()
	to_chat(owner,"<span class='notice'>You toggle the hijack implant's stealthmode [H.stealthmode ? "on" : "off"].</span>")

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
	icon_icon = S.action_icon
	button_icon_state = S.action_icon_state
	background_icon_state = S.action_background_icon_state

/datum/action/spell_action/Destroy()
	var/obj/effect/proc_holder/S = target
	S.action = null
	target = null
	return ..()

/datum/action/spell_action/Trigger()
	if(!..())
		return FALSE
	if(target)
		var/obj/effect/proc_holder/S = target
		S.Trigger(usr)
		return TRUE

/datum/action/spell_action/IsAvailable(silent = FALSE)
	if(!target)
		return FALSE
	return TRUE

/datum/action/spell_action/spell

/datum/action/spell_action/spell/IsAvailable(silent = FALSE)
	if(!target)
		return FALSE
	var/obj/effect/proc_holder/spell/S = target
	if(owner)
		return S.can_cast(owner, FALSE, silent)
	return FALSE

/datum/action/spell_action/alien

/datum/action/spell_action/alien/IsAvailable(silent = FALSE)
	if(!target)
		return FALSE
	var/obj/effect/proc_holder/alien/ab = target
	if(owner)
		return ab.cost_check(ab.check_turf,owner,silent)
	return FALSE



//Preset for general and toggled actions
/datum/action/innate
	check_flags = NONE
	required_mobility_flags = NONE
	var/active = 0

/datum/action/innate/Trigger()
	if(!..())
		return FALSE
	if(!active)
		Activate()
	else
		Deactivate()
	return TRUE

/datum/action/innate/proc/Activate()
	return

/datum/action/innate/proc/Deactivate()
	return

//Preset for an action with a cooldown

/datum/action/cooldown
	check_flags = 0
	transparent_when_unavailable = FALSE
	// The default cooldown applied when StartCooldown() is called
	var/cooldown_time = 0
	// The actual next time this ability can be used
	var/next_use_time = 0
	// Whether or not you want the cooldown for the ability to display in text form
	var/text_cooldown = TRUE
	// Setting for intercepting clicks before activating the ability
	var/click_to_activate = FALSE
	// Shares cooldowns with other cooldown abilities of the same value, not active if null
	var/shared_cooldown

/datum/action/cooldown/CreateButton()
	var/atom/movable/screen/movable/action_button/button = ..()
	button.maptext = ""
	button.maptext_x = 8
	button.maptext_y = 0
	button.maptext_width = 24
	button.maptext_height = 12
	return button

/datum/action/cooldown/IsAvailable()
	return ..() && (next_use_time <= world.time)

/// Starts a cooldown time to be shared with similar abilities, will use default cooldown time if an override is not specified
/datum/action/cooldown/proc/StartCooldown(override_cooldown_time)
	if(shared_cooldown)
		for(var/datum/action/cooldown/shared_ability in owner.actions - src)
			if(shared_cooldown == shared_ability.shared_cooldown)
				if(isnum(override_cooldown_time))
					shared_ability.StartCooldownSelf(override_cooldown_time)
				else
					shared_ability.StartCooldownSelf(cooldown_time)
	StartCooldownSelf(override_cooldown_time)

/// Starts a cooldown time for this ability only, will use default cooldown time if an override is not specified
/datum/action/cooldown/proc/StartCooldownSelf(override_cooldown_time)
	if(isnum(override_cooldown_time))
		next_use_time = world.time + override_cooldown_time
	else
		next_use_time = world.time + cooldown_time
	UpdateButtons()
	START_PROCESSING(SSfastprocess, src)

/datum/action/cooldown/Trigger(trigger_flags, atom/target)
	. = ..()
	if(!.)
		return
	if(!owner)
		return FALSE
	if(click_to_activate)
		if(target)
			// For automatic / mob handling
			return InterceptClickOn(owner, null, target)
		if(owner.click_intercept == src)
			owner.click_intercept = null
		else
			owner.click_intercept = src
		for(var/datum/action/cooldown/ability in owner.actions)
			ability.UpdateButtons()
		return TRUE
	return PreActivate(owner)

/// Intercepts client owner clicks to activate the ability
/datum/action/cooldown/proc/InterceptClickOn(mob/living/caller, params, atom/target)
	if(!IsAvailable())
		return FALSE
	if(!target)
		return FALSE
	PreActivate(target)
	caller.click_intercept = null
	return TRUE

/// For signal calling
/datum/action/cooldown/proc/PreActivate(atom/target)
	if(SEND_SIGNAL(owner, COMSIG_MOB_ABILITY_STARTED, src) & COMPONENT_BLOCK_ABILITY_START)
		return
	. = Activate(target)
	SEND_SIGNAL(owner, COMSIG_MOB_ABILITY_FINISHED, src)

/// To be implemented by subtypes
/datum/action/cooldown/proc/Activate(atom/target)
	return

/datum/action/cooldown/UpdateButton(atom/movable/screen/movable/action_button/button, status_only = FALSE, force = FALSE)
	. = ..()
	if(!button)
		return
	var/time_left = max(next_use_time - world.time, 0)
	if(text_cooldown)
		button.maptext = MAPTEXT("<b>[round(time_left/10, 0.1)]</b>")
	if(!owner || time_left == 0)
		button.maptext = ""
	if(IsAvailable() && owner.click_intercept == src)
		button.color = COLOR_GREEN

/datum/action/cooldown/process()
	var/time_left = max(next_use_time - world.time, 0)
	if(!owner || time_left == 0)
		STOP_PROCESSING(SSfastprocess, src)
	UpdateButtons()

/datum/action/cooldown/Grant(mob/M)
	..()
	if(!owner)
		return
	UpdateButtons()
	if(next_use_time > world.time)
		START_PROCESSING(SSfastprocess, src)

//surf_ss13
/datum/action/item_action/bhop
	name = "Activate Jump Boots"
	desc = "Activates the jump boot's internal propulsion system, allowing the user to dash over 4-wide gaps."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "jetboot"

/datum/action/language_menu
	name = "Language Menu"
	desc = "Open the language menu to review your languages, their keys, and select your default language."
	button_icon_state = "language_menu"
	check_flags = 0

/datum/action/language_menu/Trigger()
	if(!..())
		return FALSE
	if(ismob(owner))
		var/mob/M = owner
		var/datum/language_holder/H = M.get_language_holder()
		H.open_language_menu(usr)

/datum/action/item_action/wheelys
	name = "Toggle Wheely-Heel's Wheels"
	desc = "Pops out or in your wheely-heel's wheels."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "wheelys"

/datum/action/item_action/kindleKicks
	name = "Activate Kindle Kicks"
	desc = "Kick you feet together, activating the lights in your Kindle Kicks."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
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

/datum/action/small_sprite/Trigger()
	..()
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

/datum/action/item_action/storage_gather_mode
	name = "Switch gathering mode"
	desc = "Switches the gathering mode of a storage object."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "storage_gather_switch"

/datum/action/item_action/storage_gather_mode/ApplyIcon(atom/movable/screen/movable/action_button/current_button)
	. = ..()
	var/old_layer = target.layer
	var/old_plane = target.plane
	target.layer = FLOAT_LAYER //AAAH
	target.plane = FLOAT_PLANE //^ what that guy said
	current_button.cut_overlays()
	current_button.add_overlay(target)
	target.layer = old_layer
	target.plane = old_plane
	current_button.appearance_cache = target.appearance

/proc/get_action_of_type(mob/M, action_type)
	if(!M.actions || !ispath(action_type, /datum/action))
		return
	for(var/datum/action/A in M.actions)
		if(istype(A, action_type))
			return A
	return
