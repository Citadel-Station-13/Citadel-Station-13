/datum/component/combat_mode
	var/combatmessagecooldown
	var/lastmousedir
	var/obj/screen/combattoggle/hud_icon
	var/hud_loc

/datum/component/combat_mode/Initialize(hud_loc = ui_combat_toggle)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	src.hud_loc = hud_loc

	RegisterSignal(parent, SIGNAL_TRAIT(TRAIT_COMBAT_MODE_LOCKED), .proc/update_combat_lock)
	RegisterSignal(parent, COMSIG_TOGGLE_COMBAT_MODE, .proc/user_toggle_intentional_combat_mode)
	RegisterSignal(parent, COMSIG_DISABLE_COMBAT_MODE, .proc/disable_intentional_combat_mode)
	RegisterSignal(parent, COMSIG_ENABLE_COMBAT_MODE, .proc/enable_intentional_combat_mode)
	RegisterSignal(parent, COMSIG_MOB_DEATH, .proc/on_death)
	RegisterSignal(parent, COMSIG_MOB_CLIENT_LOGOUT, .proc/on_logout)
	RegisterSignal(parent, COMSIG_MOB_HUD_CREATED, .proc/on_mob_hud_created)
	RegisterSignal(parent, COMSIG_HAS_COMBAT_MODE_ENABLED, .proc/check_enabled)
	RegisterSignal(parent, COMSIG_HAS_COMBAT_MODE_ENABLED, .proc/check_disabled)

	update_combat_lock()

/datum/component/combat_mode/Destroy()
	if(parent)
		disable_intentional_combat_mode(parent)
	if(hud_icon)
		QDEL_NULL(hud_icon)
	return ..()

/datum/component/combat_mode/proc/on_mob_hud_created(mob/source)
	hud_icon = new
	hud_icon.icon = tg_ui_icon_to_cit_ui(source.hud_used.ui_style)
	hud_icon.screen_loc = hud_loc
	source.hud_used.static_inventory += hud_icon

/datum/component/combat_mode/proc/update_combat_lock()
	var/mob/living/L = parent
	var/locked = HAS_TRAIT(L, TRAIT_COMBAT_MODE_LOCKED)
	var/desired = (L.combat_flags & COMBAT_FLAG_COMBAT_TOGGLED)
	var/actual = (L.combat_flags & COMBAT_FLAG_COMBAT_ACTIVE)
	if(actual)
		if(locked)
			disable_combat_mode(L, FALSE, TRUE)
		else if(!desired)
			disable_combat_mode(L, TRUE, TRUE)
	else
		if(desired && !locked)
			enable_combat_mode(L, FALSE, TRUE)

/datum/component/combat_mode/proc/enable_combat_mode(mob/living/source, silent = TRUE, forced = FALSE, visible = FALSE, locked = FALSE)
	if(locked)
		hud_icon?.update_icon()
		return
	if(source.combat_flags & COMBAT_FLAG_COMBAT_ACTIVE)
		return
	source.combat_flags |= COMBAT_FLAG_COMBAT_ACTIVE
	SEND_SIGNAL(source, COMSIG_LIVING_COMBAT_ENABLED, forced)
	if(!silent)
		if(visible)
			if(!forced)
				if(world.time >= combatmessagecooldown)
					combatmessagecooldown = world.time + 10 SECONDS
					if(source.a_intent != INTENT_HELP)
						source.visible_message("<span class='warning'>[source] [source.resting ? "tenses up" : (prob(95)? "drops into a combative stance" : (prob(95)? "poses aggressively" : "asserts dominance with their pose"))].</span>")
					else
						source.visible_message("<span class='notice'>[source] [pick("looks","seems","goes")] [pick("alert","attentive","vigilant")].</span>")
			else
				source.visible_message("<span class='warning'>[source] drops into a combative stance!</span>", "<span class='warning'>You drop into a combative stance!</span>")
		else
			to_chat(source, forced? "<span class='warning'>Your muscles reflexively tighten!</span>" : "<span class='warning'>You tighten your muscles.</span>")
		if(!forced)
			source.playsound_local(source, 'sound/misc/ui_toggle.ogg', 50, FALSE, pressure_affected = FALSE) //Sound from interbay!
	RegisterSignal(source, COMSIG_MOB_CLIENT_MOUSEMOVE, .proc/onMouseMove)
	RegisterSignal(source, COMSIG_MOVABLE_MOVED, .proc/on_move)
	hud_icon?.update_icon()

/datum/component/combat_mode/proc/disable_combat_mode(mob/living/source, silent = TRUE, forced = FALSE, visible = FALSE, locked = FALSE)
	if(locked)
		hud_icon?.update_icon()
		return
	if(!(source.combat_flags & COMBAT_FLAG_COMBAT_ACTIVE) || (source.combat_flags & COMBAT_FLAG_COMBAT_FORCED))
		return
	source.combat_flags &= ~COMBAT_FLAG_COMBAT_ACTIVE
	SEND_SIGNAL(source, COMSIG_LIVING_COMBAT_DISABLED, forced)
	if(!silent)
		if(visible)
			source.visible_message("<span class='warning'>[source] goes limp.</span>", "<span class='warning'>Your muscles are forcibly relaxed!</span>")
		else
			to_chat(source, forced? "<span class='warning'>Your muscles are forcibly relaxed!</span>" : "<span class='warning'>You relax your muscles.</span>")
		if(!forced)
			source.playsound_local(source, 'sound/misc/ui_toggleoff.ogg', 50, FALSE, pressure_affected = FALSE) //Slightly modified version of the toggleon sound!
	hud_icon?.update_icon()
	UnregisterSignal(source, list(COMSIG_MOB_CLIENT_MOUSEMOVE, COMSIG_MOVABLE_MOVED))

/datum/component/combat_mode/proc/on_move(atom/movable/AM, dir, atom/oldloc, forced)
	var/mob/living/L = AM
	if(L.combat_flags & COMBAT_FLAG_COMBAT_ACTIVE && L.client && lastmousedir && lastmousedir != dir)
		L.setDir(lastmousedir, ismousemovement = TRUE)

/datum/component/combat_mode/proc/onMouseMove(mob/source, object, location, control, params)
	if(source.client.show_popup_menus)
		return
	source.face_atom(object, TRUE)
	lastmousedir = source.dir

/// Toggles whether the user is intentionally in combat mode. THIS should be the proc you generally use! Has built in visual/to other player feedback, as well as an audible cue to ourselves.
/datum/component/combat_mode/proc/user_toggle_intentional_combat_mode(mob/living/source)
	if(source.combat_flags & COMBAT_FLAG_COMBAT_TOGGLED)
		if(!disable_intentional_combat_mode(source))
			to_chat(source, "<span class='warning'>You are unable to relax your muscles.</span>")
	else if(source.stat == CONSCIOUS && !(source.combat_flags & COMBAT_FLAG_HARD_STAMCRIT))
		enable_intentional_combat_mode(source)

/// Enables intentionally being in combat mode. Please try not to use this proc for feedback whenever possible.
/datum/component/combat_mode/proc/enable_intentional_combat_mode(mob/living/source, silent = FALSE, visible = TRUE)
	if((source.combat_flags & COMBAT_FLAG_COMBAT_TOGGLED) && (source.combat_flags & COMBAT_FLAG_COMBAT_ACTIVE))
		return TRUE
	source.combat_flags |= COMBAT_FLAG_COMBAT_TOGGLED
	enable_combat_mode(source, silent, FALSE, visible, HAS_TRAIT(source, TRAIT_COMBAT_MODE_LOCKED))
	if(source.client)
		source.client.show_popup_menus = FALSE
	if(iscarbon(source)) //I dislike this typecheck. It probably should be removed once that spoiled apple is componentized too.
		var/mob/living/carbon/C = source
		if(C.voremode)
			C.disable_vore_mode()
	return TRUE

/// Disables intentionally being in combat mode. Please try not to use this proc for feedback whenever possible.
/datum/component/combat_mode/proc/disable_intentional_combat_mode(mob/living/source, silent = TRUE, visible = FALSE)
	if(!(source.combat_flags & COMBAT_FLAG_COMBAT_TOGGLED) && !(source.combat_flags & COMBAT_FLAG_COMBAT_ACTIVE))
		return TRUE
	if(source.combat_flags & COMBAT_FLAG_COMBAT_FORCED)
		return FALSE
	source.combat_flags &= ~COMBAT_FLAG_COMBAT_TOGGLED
	disable_combat_mode(source, silent, FALSE, visible, !(source.combat_flags & COMBAT_FLAG_COMBAT_ACTIVE))
	if(source.client)
		source.client.show_popup_menus = TRUE
	return TRUE

/datum/component/combat_mode/proc/check_enabled(mob/living/source)
	return (source.combat_flags & COMBAT_FLAG_COMBAT_ACTIVE)

/datum/component/combat_mode/proc/check_disabled(mob/living/source)
	return !(source.combat_flags & COMBAT_FLAG_COMBAT_ACTIVE)

/datum/component/combat_mode/proc/on_death(mob/living/source)
	disable_intentional_combat_mode(source)

/datum/component/combat_mode/proc/on_logout(mob/living/source)
	disable_intentional_combat_mode(source)

/// The screen button.
/obj/screen/combattoggle
	name = "toggle combat mode"
	icon = 'modular_citadel/icons/ui/screen_midnight.dmi'
	icon_state = "combat_off"
	var/mutable_appearance/flashy

/obj/screen/combattoggle/Click()
	if(hud && usr == hud.mymob)
		SEND_SIGNAL(hud.mymob, COMSIG_TOGGLE_COMBAT_MODE)

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

/obj/screen/combattoggle/update_overlays()
	. = ..()
	var/mob/living/carbon/user = hud?.mymob
	if(!istype(user) || !user.client)
		return

	if((user.combat_flags & COMBAT_FLAG_COMBAT_ACTIVE) && user.client.prefs.hud_toggle_flash)
		if(!flashy)
			flashy = mutable_appearance('icons/mob/screen_gen.dmi', "togglefull_flash")
		if(flashy.color != user.client.prefs.hud_toggle_color)
			flashy.color = user.client.prefs.hud_toggle_color
		. += flashy //TODO - beg lummox jr for the ability to force mutable appearances or images to be created rendering from their first frame of animation rather than being based entirely around the client's frame count
