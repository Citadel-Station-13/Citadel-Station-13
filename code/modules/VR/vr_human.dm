

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


/mob/living/carbon/human/virtual_reality/ghostize()
	stack_trace("Ghostize was called on a virtual reality mob")

/mob/living/carbon/human/virtual_reality/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = "Relinquish your life and enter the land of the dead."
<<<<<<< HEAD
	var/mob/living/carbon/human/H = real_me
	revert_to_reality(FALSE, FALSE)
	if(H)
		H.ghost()


/mob/living/carbon/human/virtual_reality/proc/revert_to_reality(refcleanup = TRUE, deathchecks = TRUE)
	if(real_me && mind)
		mind.transfer_to(real_me)
		if(deathchecks && vr_sleeper && vr_sleeper.you_die_in_the_game_you_die_for_real)
			real_me.death(0)
	if(refcleanup)
=======
	revert_to_reality(FALSE)

/mob/living/carbon/human/virtual_reality/proc/revert_to_reality(deathchecks = TRUE)
	if(real_mind && mind)
		real_mind.current.ckey = ckey
		real_mind.current.stop_sound_channel(CHANNEL_HEARTBEAT)
		if(deathchecks && vr_sleeper)
			if(vr_sleeper.you_die_in_the_game_you_die_for_real)
				to_chat(real_mind, "<span class='warning'>You feel everything fading away...</span>")
				real_mind.current.death(0)
	if(deathchecks && vr_sleeper)
>>>>>>> 92a811e... Adds VR Snowdin and Syndicate Trainer/VR Update roll up (#37915)
		vr_sleeper.vr_human = null
		vr_sleeper = null
		real_me = null


/datum/action/quit_vr
	name = "Quit Virtual Reality"

/datum/action/quit_vr/Trigger()
	if(..())
		if(istype(owner, /mob/living/carbon/human/virtual_reality))
			var/mob/living/carbon/human/virtual_reality/VR = owner
			VR.revert_to_reality(FALSE, FALSE)
		else
			Remove(owner)
