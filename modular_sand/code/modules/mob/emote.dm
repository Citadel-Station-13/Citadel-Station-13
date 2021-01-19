/obj/effect/overlay/emote_popup
	icon = 'modular_sand/icons/mob/popup_flicks.dmi'
	icon_state = "combat"
	layer = FLY_LAYER
	plane = GAME_PLANE
	appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	mouse_opacity = 0

/proc/flick_emote_popup_on_mob(mob/M, state, time)
	var/obj/effect/overlay/emote_popup/I = new
	I.icon_state = state
	M.vis_contents += I
	animate(I, alpha = 255, time = 5, easing = BOUNCE_EASING, pixel_y = 10)
	QDEL_IN_CLIENT_TIME(I, time)

/datum/emote/living/peep
	key = "peep"
	key_third_person = "peeps like a bird"
	message = "peeps like a bird!"
	emote_type = EMOTE_AUDIBLE
	muzzle_ignore = FALSE
	restraint_check = FALSE
	mob_type_allowed_typecache = list(/mob/living/carbon, /mob/living/silicon/pai)

/datum/emote/living/peep/run_emote(mob/living/user, params)
	if(!(. = ..()))
		return
	if(user.nextsoundemote >= world.time)
		return
	user.nextsoundemote = world.time + 7
	playsound(user, 'modular_sand/sound/voice/peep_once.ogg', 50, 1, -1)

/datum/emote/living/peep2
	key = "peep2"
	key_third_person = "peeps twice like a bird"
	message = "peeps twice like a bird!"
	emote_type = EMOTE_AUDIBLE
	muzzle_ignore = FALSE
	restraint_check = FALSE
	mob_type_allowed_typecache = list(/mob/living/carbon, /mob/living/silicon/pai)

/datum/emote/living/peep2/run_emote(mob/living/user, params)
	if(!(. = ..()))
		return
	if(user.nextsoundemote >= world.time)
		return
	user.nextsoundemote = world.time + 7
	playsound(user, 'modular_citadel/sound/voice/peep.ogg', 50, 1, -1)
