/datum/component/virtual_reality
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/mind/real_mind // where is my mind t. pixies
	var/datum/mind/current_mind
	var/obj/machinery/vr_sleeper/vr_sleeper
	var/datum/action/quit_vr/quit_action
	var/you_die_in_the_game_you_die_for_real = FALSE

/datum/component/virtual_reality/Initialize(datum/mind/mastermind, obj/machinery/vr_sleeper/gaming_pod, yolo = FALSE, new_char = TRUE)
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE

	you_die_in_the_game_you_die_for_real = yolo
	quit_action = new()
	quit_action.Grant(parent)
	if(gaming_pod)
		vr_sleeper = gaming_pod
		RegisterSignal(vr_sleeper, COMSIG_ATOM_EMAG_ACT, .proc/you_only_live_once)
		RegisterSignal(vr_sleeper, COMSIG_MACHINE_EJECT_OCCUPANT, .proc/revert_to_reality)

/datum/component/virtual_reality/RegisterWithParent()
	var/mob/M = parent
	current_mind = M.mind
	RegisterSignal(parent, COMSIG_MOB_DEATH, .proc/game_over)
	RegisterSignal(parent, COMSIG_MOB_KEY_CHANGE, .proc/pass_me_the_remote)
	RegisterSignal(current_mind, COMSIG_MIND_TRANSFER, .proc/pass_me_the_remote)
	RegisterSignal(parent, COMSIG_MOB_GHOSTIZE, .proc/be_a_quitter)
	RegisterSignal(quit_action, COMSIG_ACTION_TRIGGER, .proc/revert_to_reality)

/datum/component/virtual_reality/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_MOB_DEATH, COMSIG_MOB_KEY_CHANGE, COMSIG_MOB_GHOSTIZE))
	UnregisterSignal(quit_action, COMSIG_ACTION_TRIGGER)
	UnregisterSignal(current_mind, COMSIG_MIND_TRANSFER)

/datum/component/virtual_reality/proc/action_trigger(datum/signal_source, datum/action/source)
	if(source != quit_action)
		return COMPONENT_ACTION_BLOCK_TRIGGER
	revert_to_reality(signal_source)

/datum/component/virtual_reality/proc/you_only_live_once()
	if(you_die_in_the_game_you_die_for_real)
		return FALSE
	you_die_in_the_game_you_die_for_real = TRUE
	return TRUE

/datum/component/virtual_reality/proc/pass_me_the_remote(datum/source, mob/new_mob)
	if(new_mob == real_mind.current)
		revert_to_reality(source)
	new_mob.TakeComponent(src)
	return TRUE

/datum/component/virtual_reality/PostTransfer()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/virtual_reality/proc/revert_to_reality(datum/source)
	quit_it(FALSE)

/datum/component/virtual_reality/proc/game_over(datum/source)
	quit_it(TRUE)

/datum/component/virtual_reality/proc/be_a_quitter(datum/source)
	quit_it(FALSE)
	return COMPONENT_BLOCK_GHOSTING

/datum/component/virtual_reality/proc/quit_it(deathcheck = FALSE)
	var/mob/M = parent
	if(!real_mind)
		to_chat(M, "<span class='warning'>You feel as if something terrible happened, you try to wake up from this dream... but you can't...</span>")
	else
		real_mind.current.audiovisual_redirect = null
		real_mind.current.ckey = M.ckey
		real_mind.current.stop_sound_channel(CHANNEL_HEARTBEAT)
		if(deathcheck)
			var/obj/effect/vr_clean_master/cleanbot = locate() in get_area(M)
			if(cleanbot)
				LAZYADD(cleanbot.corpse_party, M)
			if(you_die_in_the_game_you_die_for_real)
				to_chat(real_mind, "<span class='warning'>You feel everything fading away...</span>")
				real_mind.current.death(0)
			if(vr_sleeper)
				vr_sleeper.vr_mob = null
				vr_sleeper = null
	qdel(src)

/datum/component/virtual_reality/Destroy()
	QDEL_NULL(quit_action)
	return ..()