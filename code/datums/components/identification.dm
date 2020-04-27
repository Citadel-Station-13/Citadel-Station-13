/**
  * Identification components
  */
/datum/component/identification
	/// General flags for how we should work.
	var/identification_flags = NONE
	/// General flags for what we should do.
	var/identification_effect_flags = NONE
	/// General flags for how we can be identified.
	var/identification_method_flags = NONE
	/// If this is set, show this on examine to the examiner if they know how to use it.
	var/additional_examine_text = "<span class='notice'>You seem to know more about this item than others..</span>"
	/// Added to deconstructive analyzer say on success if set
	var/deconstructor_reveal_text = "item operation instructions"

/datum/component/identification/Initialize(id_flags, id_effect_flags, id_method_flags)
	if(!isobj(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. & COMPONENT_INCOMPATIBLE)
		return
	identification_flags = id_flags
	identification_effect_flags = id_effect_flags
	identification_method_flags = id_method_flags

/datum/component/identification/RegisterWithParent()
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/on_examine)
	if(identification_effect_flags & ID_COMPONENT_EFFECT_NO_ACTIONS)
		RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, .proc/on_equip)
	if(identification_method_flags & ID_COMPONENT_IDENTIFY_WITH_DECONSTRUCTOR)
		RegisterSignal(parent, COMSIG_ITEM_DECONSTRUCTOR_DEEPSCAN, .proc/on_deconstructor_deepscan)

/datum/component/identification/UnregisterFromParent()
	var/list/unregister = list(COMSIG_PARENT_EXAMINE)
	if(identification_effect_flags & ID_COMPONENT_EFFECT_NO_ACTIONS)
		unregister += COMSIG_ITEM_EQUIPPED
	if(identification_method_flags & ID_COMPONENT_IDENTIFY_WITH_DECONSTRUCTOR)
		unregister += COMSIG_ITEM_DECONSTRUCTOR_DEEPSCAN
	UnregisterSignal(parent, unregister)

/datum/component/identification/proc/on_examine(datum/source, mob/user, list/returnlist)
	if(check_knowledge(user) != ID_COMPONENT_KNOWLEDGE_FULL)
		return
	if(!additional_examine_text)
		return
	returnlist += additional_examine_text

/datum/component/identification/vv_edit_var(var_name, var_value)
	// since i care SOOO much about memory optimization, we only register signals we need to
	// so when someone vv's us, we should probably make sure we have the ones we need to with an update.
	if((var_value == NAMEOF(src, identification_flags)) || (var_value == NAMEOF(src, identification_effect_flags)) || (var_value == NAMEOF(src, identification_method_flags)))
		UnregisterFromParent()
	. = ..()
	if((var_value == NAMEOF(src, identification_flags)) || (var_value == NAMEOF(src, identification_effect_flags)) || (var_value == NAMEOF(src, identification_method_flags)))
		RegisterWithParent()

/datum/component/identification/proc/on_equip(datum/source, mob/user)
	if(check_knowledge(user) == ID_COMPONENT_KNOWLEDGE_FULL)
		return
	if(identification_method_flags & ID_COMPONENT_EFFECT_NO_ACTIONS)
		return COMPONENT_NO_GRANT_ACTIONS

/datum/component/identification/proc/check_knowledge(mob/user)
	return ID_COMPONENT_KNOWLEDGE_NONE

/datum/component/identification/proc/on_identify(mob/user)
	if(identification_flags & ID_COMPONENT_DEL_ON_IDENTIFY)
		qdel(src)

/datum/component/identification/proc/on_deconstructor_deepscan(datum/source, obj/machinery/rnd/destructive_analyzer/analyzer, mob/user, list/information = list())
	if((identification_method_flags & ID_COMPONENT_IDENTIFY_WITH_DECONSTRUCTOR) && !(identification_flags & ID_COMPONENT_DECONSTRUCTOR_DEEPSCANNED))
		identification_flags |= ID_COMPONENT_DECONSTRUCTOR_DEEPSCANNED
		on_identify(user)
		if(deconstructor_reveal_text)
			information += deconstructor_reveal_text
		return COMPONENT_DEEPSCAN_UNCOVERED_INFORMATION

/**
  * Identification component subtype - Syndicate
  *
  * Checks if the user is a traitor.
  */
/datum/component/identification/syndicate

/datum/component/identification/syndicate/check_knowledge(mob/user)
	. = ..()
	if(user?.mind?.has_antag_datum(/datum/antagonist/traitor))
		. = max(., ID_COMPONENT_KNOWLEDGE_FULL)
