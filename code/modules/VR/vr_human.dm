

/mob/living/carbon/human/virtual_reality
	var/mob/living/carbon/human/real_me //The human controlling us, can be any human (including virtual ones... inception...)
	var/obj/machinery/vr_sleeper/vr_sleeper
	var/datum/action/quit_vr/quit_action


/mob/living/carbon/human/virtual_reality/Initialize()
	. = ..()
	quit_action = new()
	quit_action.Grant(src)


/mob/living/carbon/human/virtual_reality/death()
	revert_to_reality()
	..()


/mob/living/carbon/human/virtual_reality/Destroy()
	revert_to_reality()
	return ..()


/mob/living/carbon/human/virtual_reality/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = "Relinquish your life and enter the land of the dead."
	var/mob/living/real_me = real_mind.current
	revert_to_reality(FALSE)
	if(real_me)
		real_me.ghost()

/mob/living/carbon/human/virtual_reality/proc/revert_to_reality(deathchecks = TRUE)
	if(real_mind && mind)
		real_mind.current.ckey = ckey
		real_mind.current.stop_sound_channel(CHANNEL_HEARTBEAT)
		if(deathchecks && vr_sleeper)
			if(vr_sleeper.you_die_in_the_game_you_die_for_real)
				real_mind.current.death(0)
	if(deathchecks && vr_sleeper)
		vr_sleeper.vr_human = null
		vr_sleeper = null
	real_mind = null

/datum/action/quit_vr
	name = "Quit Virtual Reality"
	icon_icon = 'icons/mob/actions/actions_vr.dmi'
	button_icon_state = "logout"

/datum/action/quit_vr/Trigger()
	if(..())
		if(istype(owner, /mob/living/carbon/human/virtual_reality))
			var/mob/living/carbon/human/virtual_reality/VR = owner
			VR.revert_to_reality(FALSE, FALSE)
		else
			Remove(owner)
