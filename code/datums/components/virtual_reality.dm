/**
  * The virtual reality turned component.
  * Originally created to overcome issues of mob polymorphing locking the player inside virtual reality
  * and allow for a more "realistic" virtual reality in a virtual reality experience.
  * (I was there when VR sleepers were first tested on /tg/station, it was whacky.)
  * In short, a barebone not so hardcoded VR framework.
  * If you plan to add more devices that make use of this component, remember to isolate their specific code outta here where possible.
  */
/datum/component/virtual_reality
	can_transfer = TRUE
	//the player's mind (not the parent's), should something happen to them or to their mob.
	var/datum/mind/mastermind
	//the current mob's mind, which we need to keep track for mind transfer.
	var/datum/mind/current_mind
	//the action datum used by the mob to quit the vr session.
	var/datum/action/quit_vr/quit_action
	//This one's name should be self explainatory, currently used for emags.
	var/you_die_in_the_game_you_die_for_real = FALSE
	//Used to allow people to play recursively playing vr while playing vr without many issues.
	var/datum/component/virtual_reality/inception
	//Used to stop the component from executing certain functions that'd cause us some issues otherwise.
	//FALSE if there is a connected player, otherwise TRUE.
	var/session_paused = TRUE
	//Used to stop unwarranted behaviour from happening in cases where the master mind transference is unsupported. Set on Initialize().
	var/allow_mastermind_transfer = FALSE

/datum/component/virtual_reality/Initialize(yolo = FALSE, _allow_mastermind_transfer = FALSE)
	var/mob/vr_M = parent
	if(!istype(vr_M) || !vr_M.mind)
		return COMPONENT_INCOMPATIBLE
	you_die_in_the_game_you_die_for_real = yolo
	allow_mastermind_transfer = _allow_mastermind_transfer
	quit_action = new

/datum/component/virtual_reality/Destroy()
	QDEL_NULL(quit_action)
	return ..()

/datum/component/virtual_reality/RegisterWithParent()
	. = ..()
	var/mob/M = parent
	current_mind = M.mind
	if(!quit_action)
		quit_action = new
	quit_action.Grant(M)
	RegisterSignal(quit_action, COMSIG_ACTION_TRIGGER, .proc/action_trigger)
	RegisterSignal(M, list(COMSIG_MOB_DEATH, COMSIG_PARENT_QDELETING), .proc/game_over)
	RegisterSignal(M, COMSIG_MOB_GHOSTIZE, .proc/be_a_quitter)
	RegisterSignal(M, COMSIG_MOB_KEY_CHANGE, .proc/pass_me_the_remote)
	RegisterSignal(current_mind, COMSIG_MIND_TRANSFER, .proc/pass_me_the_remote)
	if(mastermind)
		mastermind.current.audiovisual_redirect = M

/datum/component/virtual_reality/UnregisterFromParent()
	. = ..()
	if(quit_action)
		quit_action.Remove(parent)
		UnregisterSignal(quit_action, COMSIG_ACTION_TRIGGER)
	UnregisterSignal(parent, list(COMSIG_MOB_DEATH, COMSIG_PARENT_QDELETING, COMSIG_MOB_KEY_CHANGE, COMSIG_MOB_GHOSTIZE))
	UnregisterSignal(current_mind, COMSIG_MIND_TRANSFER)
	current_mind = null
	if(mastermind)
		mastermind.current.audiovisual_redirect = null

/**
  * Called when attempting to connect a mob to a virtual reality mob.
  * This will return FALSE if the mob is without player or dead.
  */
/datum/component/virtual_reality/proc/connect(mob/M)
	if(!M.mind || M.stat == DEAD)
		return FALSE
	RegisterSignal(M, list(COMSIG_MOB_DEATH, COMSIG_PARENT_QDELETING), .proc/game_over)
	mastermind = M.mind
	RegisterSignal(mastermind, COMSIG_MIND_TRANSFER, .proc/switch_player)
	var/datum/component/virtual_reality/clusterfk = M.GetComponent(/datum/component/virtual_reality)
	if(clusterfk)
		clusterfk.inception = src
	var/mob/vr_M = parent
	SStgui.close_user_uis(M, src)
	M.transfer_ckey(vr_M, FALSE)
	session_paused = FALSE
	return TRUE

/**
  * Called when the mastermind mind is transferred to another mob.
  * This is pretty much going to simply quit the session until machineries support polymorphed occupants etcetera.
  */
/datum/component/virtual_reality/proc/switch_player(datum/source, mob/new_mob, mob/old_mob)
	if(!allow_mastermind_transfer)
		quit()
		return
	old_mob.audiovisual_redirect = null
	new_mob.audiovisual_redirect = parent

/**
  * VR sleeper emag_act() hook.
  */
/datum/component/virtual_reality/proc/you_only_live_once()
	if(you_die_in_the_game_you_die_for_real)
		return FALSE
	you_die_in_the_game_you_die_for_real = TRUE
	return TRUE

/**
  * Takes care of moving the component from a mob to another when their mind or ckey is transferred.
  * The very reason this component even exists (else one would be stuck playing as a monky if monkyified)
  * Should the new mob happen to be one of the virtual realities ultimately associated the player
  * a 180° turn will be done and quit the session instead.
  */
/datum/component/virtual_reality/proc/pass_me_the_remote(datum/source, mob/new_mob)
	if(mastermind && new_mob == mastermind.current)
		quit()
		return
	var/datum/component/virtual_reality/VR = new_mob.GetComponent(/datum/component/virtual_reality)
	if(VR.inception)
		var/datum/component/virtual_reality/VR2 = VR.inception
		var/emergency_quit = FALSE
		while(VR2)
			if(VR2 == src)
				emergency_quit = TRUE
				break
			VR2 = VR2.inception
		if(emergency_quit)
			VR.inception.quit() //this will make the ckey revert back to the new mob.
			return
	new_mob.TakeComponent(src)

/**
  * Required for the component to be transferable from mob to mob.
  */
/datum/component/virtual_reality/PostTransfer()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE

/**
  *The following procs simply acts as hooks for quit(), since components do not use callbacks anymore
  */
/datum/component/virtual_reality/proc/action_trigger(datum/signal_source, datum/action/source)
	quit()
	return COMPONENT_ACTION_BLOCK_TRIGGER

/datum/component/virtual_reality/proc/revert_to_reality(datum/source)
	quit()

/datum/component/virtual_reality/proc/game_over(datum/source)
	quit(you_die_in_the_game_you_die_for_real, TRUE)
	return COMPONENT_BLOCK_DEATH_BROADCAST

/datum/component/virtual_reality/proc/be_a_quitter(datum/source, can_reenter_corpse, special = FALSE, penalize = FALSE)
	if(!special)
		quit()
		return COMPONENT_BLOCK_GHOSTING

/datum/component/virtual_reality/proc/machine_destroyed(datum/source)
	quit(cleanup = TRUE)

/**
  * Takes care of deleting itself, moving the player back to the mastermind's current and queueing the parent for deletion.
  * It supports nested virtual realities by recursively calling vr_in_a_vr(), which in turns calls quit(),
  * up to the deepest level, where the ckey will be transferred back to our mastermind's mob instead.
  * The above operation is skipped when session_paused is TRUE (ergo no player in control of the current mob).
  * vars:
  * * deathcheck is used to kill the master, you want this FALSE unless for stuff that doesn't involve emagging.
  * * cleanup is used to queue the parent for the next vr_clean_master's run, where they'll be deleted should they be dead.
  * * mob/override is used for the recursive virtual reality explained above and shouldn't be used outside of vr_in_a_vr().
  */
/datum/component/virtual_reality/proc/quit(deathcheck = FALSE, cleanup = FALSE, mob/override)
	var/mob/M = parent
	if(!session_paused)
		var/mob/dreamer = override || mastermind?.current
		if(!dreamer) //This should NEVER happen.
			stack_trace("virtual reality component quit() called without a mob to transfer the parent key to.")
			to_chat(M, "<span class='warning'>You feel a dreadful sensation, something terrible happened. You try to wake up, but you find yourself unable to...</span>")
			qdel(src)
			return
		if(inception?.parent)
			inception.vr_in_a_vr(dreamer, deathcheck, cleanup, src)
		else if(M.ckey)
			M.transfer_ckey(dreamer, FALSE)
			if(deathcheck)
				to_chat(dreamer, "<span class='warning'>You feel everything fading away...</span>")
				dreamer.death(FALSE)
			dreamer.stop_sound_channel(CHANNEL_HEARTBEAT)
			dreamer.audiovisual_redirect = null
	if(cleanup)
		var/obj/effect/vr_clean_master/cleanbot = locate() in get_area(M)
		if(cleanbot)
			LAZYOR(cleanbot.corpse_party, M)
		qdel(src)
	else if(mastermind)
		UnregisterSignal(mastermind.current, list(COMSIG_MOB_DEATH, COMSIG_PARENT_QDELETING))
		UnregisterSignal(mastermind, COMSIG_MIND_TRANSFER)
		mastermind = null
		session_paused = TRUE

/**
  * Used for recursive virtual realities shenanigeans and should be called only through the above proc.
  */
/datum/component/virtual_reality/proc/vr_in_a_vr(mob/player, deathcheck = FALSE, cleanup = FALSE, datum/component/virtual_reality/yo_dawg)
	var/mob/M = parent
	quit(deathcheck, cleanup, player, yo_dawg)
	yo_dawg.inception = null
	if(deathcheck && cleanup)
		M.death(FALSE)
