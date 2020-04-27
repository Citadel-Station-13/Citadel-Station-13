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

/datum/component/identification/UnregisterFromParent()
	var/list/unregister = list(COMSIG_PARENT_EXAMINE)

	UnregisterSignal(parent, unregister)

/datum/component/identification/proc/on_examine(mob/user, list/returnlist)
	if(check_knowledge(user) != ID_COMPONENT_KNOWLEDGE_FULL)
		return
	if(!additional_examine_text)
		return
	returnlist += additional_examine_text

/datum/component/identification/vv_edit_var(var_name, var_value)
	// since i care SOOO much about memory optimization, we only register signals we need to
	// so when someone vv's us, we should probably make sure we have the ones we need to with an update.
	if((var_value == NAMEOF(src, identification_flags)) || (var_value == NAMEOF(src, identifcation_effect_flags)) || (var_value == NAMEOF(src, identification_method_flags)))
		UnregisterFromParent()
	. = ..()
	if((var_value == NAMEOF(src, identification_flags)) || (var_value == NAMEOF(src, identifcation_effect_flags)) || (var_value == NAMEOF(src, identification_method_flags)))
		RegisterwithParent()

/datum/component/identification/proc/check_knowledge(mob/user)
	return ID_COMPONENT_KNOWLEDGE_NONE

/datum/component/identification/proc/on_identify(mob/user)
	if(identification_flags & ID_COMPONENT_DEL_ON_IDENTIFY)
		qdel(src)

/**
  * Identification component subtype - Syndicate
  *
  * Checks if the user is a traitor.
  */
/datum/component/identification/syndicate/check_knowledge(mob/user)
	. = ..()
	if(user?.mind?.has_antag_datum(/datum/antagonist/traitor)
		. = max(., ID_COMPONENT_KNOWLEDGE_FULL)
