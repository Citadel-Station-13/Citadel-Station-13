/datum/traitor_class/human/gorlex
	name = "Gorlex Marauders"
	employer = "Gorlex Marauders"
	weight = 2
	chaos = 20
	TC = 30

/datum/traitor_class/proc/forge_objectives(/datum/antagonist/traitor/T)
	// Like the old forge_human_objectives. Makes all the objectives for this traitor class.

/datum/traitor_class/proc/forge_single_objective(/datum/antagonist/traitor/T)
	// As forge_single_objective.

/datum/traitor_class/proc/on_removal(/datum/antagonist/traitor/T)
	// What this does to the antag datum on removal. Called before proper removal, obviously.

/datum/traitor_class/proc/apply_innate_effects(mob/living/M)
	// What innate effects it should have. See: AI.

/datum/traitor_class/proc/remove_innate_effects(mob/living/M)
	// Cleaning up the innate effects.

/datum/traitor_class/proc/finalize_traitor(/datum/antagonist/traitor/T)
	// Finalization. Return TRUE if should play standard traitor sound/equip, return FALSE if both are special case
	return TRUE
