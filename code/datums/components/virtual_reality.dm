/**
  * The virtual reality turned component.
  * Originally created to overcome issues of mob polymorphing locking the player inside virtual reality
  * and allow for a more "immersive" virtual reality in a virtual reality experience.
  * It relies on comically complex order of logic, expect things to break if procs such as mind/transfer_to() are revamped.
  * In short, a barebone not so hardcoded VR framework.
  * If you plan to add more devices that make use of this component, remember to isolate their code outta here where possible.
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
	var/datum/component/virtual_reality/level_below
	var/datum/component/virtual_reality/level_above
	//Used to stop the component from executing certain functions that'd cause us some issues otherwise.
	//FALSE if there is a connected player, otherwise TRUE.
	var/session_paused = TRUE
	//Used to stop unwarranted behaviour from happening in cases where the master mind transference is unsupported. Set on Initialize().
	var/allow_mastermind_transfer = FALSE

/datum/component/virtual_reality/Initialize(yolo = FALSE, _allow_mastermind_transfer = FALSE)
	var/mob/M = parent
	if(!istype(M) || !M.mind)
		return COMPONENT_INCOMPATIBLE
	you_die_in_the_game_you_die_for_real = yolo
	allow_mastermind_transfer = _allow_mastermind_transfer
	quit_action = new

/datum/component/virtual_reality/Destroy()
	QDEL_NULL(quit_action)
	if(level_above)
		level_above.level_below = null
		level_above = null
	if(level_below)
		level_below.level_above = null
		level_below = null
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
	RegisterSignal(M, COMSIG_MOB_KEY_CHANGE, .proc/on_player_transfer)
	RegisterSignal(current_mind, COMSIG_MIND_TRANSFER, .proc/on_player_transfer)
	RegisterSignal(current_mind, COMSIG_PRE_MIND_TRANSFER, .proc/pre_player_transfer)
	if(mastermind?.current)
		mastermind.current.audiovisual_redirect = M
	ADD_TRAIT(M, TRAIT_NO_MIDROUND_ANTAG, VIRTUAL_REALITY_TRAIT)

/datum/component/virtual_reality/UnregisterFromParent()
	. = ..()
	if(quit_action)
		quit_action.Remove(parent)
		UnregisterSignal(quit_action, COMSIG_ACTION_TRIGGER)
	UnregisterSignal(parent, list(COMSIG_MOB_DEATH, COMSIG_PARENT_QDELETING, COMSIG_MOB_KEY_CHANGE, COMSIG_MOB_GHOSTIZE))
	UnregisterSignal(current_mind, list(COMSIG_MIND_TRANSFER, COMSIG_PRE_MIND_TRANSFER))
	current_mind = null
	if(mastermind?.current)
		mastermind.current.audiovisual_redirect = null
	REMOVE_TRAIT(parent, TRAIT_NO_MIDROUND_ANTAG, VIRTUAL_REALITY_TRAIT)

/**
  * Called when attempting to connect a mob to a virtual reality mob.
  * This will return FALSE if the mob is without player or dead. TRUE otherwise
  */
/datum/component/virtual_reality/proc/connect(mob/M)
	var/mob/vr_M = parent
	if(!M.mind || M.stat == DEAD || !vr_M.mind || vr_M.stat == DEAD)
		return FALSE
	var/datum/component/virtual_reality/VR = M.GetComponent(/datum/component/virtual_reality)
	if(VR)
		VR.level_below = src
		level_above = VR
	M.transfer_ckey(vr_M, FALSE)
	mastermind = M.mind
	mastermind.current.audiovisual_redirect = parent
	RegisterSignal(mastermind, COMSIG_PRE_MIND_TRANSFER, .proc/switch_player)
	RegisterSignal(M, list(COMSIG_MOB_DEATH, COMSIG_PARENT_QDELETING), .proc/game_over)
	RegisterSignal(M, COMSIG_MOB_PRE_PLAYER_CHANGE, .proc/player_hijacked)
	SStgui.close_user_uis(vr_M, src)
	session_paused = FALSE
	return TRUE

/**
  * emag_act() hook. Makes the game deadlier, killing the mastermind mob too should the parent die.
  */
/datum/component/virtual_reality/proc/you_only_live_once()
	if(you_die_in_the_game_you_die_for_real)
		return FALSE
	you_die_in_the_game_you_die_for_real = TRUE
	return TRUE

/**
  * Called when the mastermind mind is transferred to another mob.
  * This is pretty much just going to simply quit the session until machineries support polymorphed occupants etcetera.
  */
/datum/component/virtual_reality/proc/switch_player(datum/source, mob/new_mob, mob/old_mob)
	if(session_paused)
		return
	if(!allow_mastermind_transfer)
		quit()
		return COMPONENT_STOP_MIND_TRANSFER
	UnregisterSignal(old_mob, list(COMSIG_MOB_DEATH, COMSIG_PARENT_QDELETING, COMSIG_MOB_PRE_PLAYER_CHANGE))
	RegisterSignal(new_mob, list(COMSIG_MOB_DEATH, COMSIG_PARENT_QDELETING), .proc/game_over)
	RegisterSignal(new_mob, COMSIG_MOB_PRE_PLAYER_CHANGE, .proc/player_hijacked)
	old_mob.audiovisual_redirect = null
	new_mob.audiovisual_redirect = parent

/**
  * Called to stop the player mind from being transferred should the new mob happen to be one of our masterminds'.
  * Since the target's mind.current is going to be null'd in the mind transfer process,
  * This has to be done in a different signal proc than on_player_transfer(), by then the mastermind.current will be null.
  */
/datum/component/virtual_reality/proc/pre_player_transfer(datum/source, mob/new_mob, mob/old_mob)
	if(!mastermind || session_paused)
		return
	if(new_mob == mastermind.current)
		quit()
		return COMPONENT_STOP_MIND_TRANSFER
	if(!level_above)
		return
	var/datum/component/virtual_reality/VR = level_above
	while(VR)
		if(VR.mastermind.current == new_mob)
			VR.quit() //this will revert the ckey back to new_mob.
			return COMPONENT_STOP_MIND_TRANSFER
		VR = VR.level_above

/**
  * Called when someone or something else is somewhat about to replace the mastermind's mob key somehow.
  * And potentially lock the player in a broken virtual reality plot. Not really something to be proud of.
  */
/datum/component/virtual_reality/proc/player_hijacked(datum/source, mob/our_character, mob/their_character)
	if(session_paused)
		return
	if(!their_character)
		quit(cleanup = TRUE)
		return
	var/will_it_be_handled_in_their_pre_player_transfer = FALSE
	var/datum/component/virtual_reality/VR = src
	while(VR)
		if(VR.parent == their_character)
			will_it_be_handled_in_their_pre_player_transfer = TRUE
			break
		VR = VR.level_below
	if(!will_it_be_handled_in_their_pre_player_transfer) //it's not the player playing shenanigeans, abandon all ships.
		quit(cleanup = TRUE)

/**
  * Takes care of moving the component from a mob to another when their mind or ckey is transferred.
  * The very reason this component even exists (else one would be stuck playing as a monky if monkyified)
  */
/datum/component/virtual_reality/proc/on_player_transfer(datum/source, mob/new_mob, mob/old_mob)
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
		session_paused = TRUE
		var/mob/dreamer = override || mastermind.current
		if(!dreamer) //This shouldn't happen.
			stack_trace("virtual reality component quit() called without a mob to transfer the parent ckey to.")
			to_chat(M, "<span class='warning'>You feel a dreadful sensation, something terrible happened. You try to wake up, but you find yourself unable to...</span>")
			qdel(src)
			return
		if(level_below?.parent)
			level_below.vr_in_a_vr(dreamer, deathcheck, (deathcheck && cleanup))
		else
			M.transfer_ckey(dreamer, FALSE)
			if(deathcheck)
				to_chat(dreamer, "<span class='warning'>You feel everything fading away...</span>")
				dreamer.death(FALSE)
		mastermind.current.audiovisual_redirect = null
		if(!cleanup)
			if(level_above)
				level_above.level_below = null
				level_above = null
			UnregisterSignal(mastermind.current, list(COMSIG_MOB_DEATH, COMSIG_PARENT_QDELETING, COMSIG_MOB_PRE_PLAYER_CHANGE))
			UnregisterSignal(mastermind, COMSIG_PRE_MIND_TRANSFER)
			mastermind = null
	if(cleanup)
		var/obj/effect/vr_clean_master/cleanbot = locate() in get_base_area(M)
		if(cleanbot)
			LAZYOR(cleanbot.corpse_party, M)
		qdel(src)

/**
  * Used for recursive virtual realities shenanigeans and should be called by the above proc.
  */
/datum/component/virtual_reality/proc/vr_in_a_vr(mob/player, deathcheck = FALSE, lethal_cleanup = FALSE)
	var/mob/M = parent
	quit(deathcheck, lethal_cleanup, player)
	M.audiovisual_redirect = null
	if(lethal_cleanup)
		M.death(FALSE)
