/datum/antagonist/abductee
	name = "Abductee"
	roundend_category = "abductees"
	antagpanel_category = "Abductee"
	var/datum/brain_trauma/abductee/brain_trauma

/datum/antagonist/abductee/on_gain()
	give_objective()
	. = ..()

/datum/antagonist/abductee/greet()
	to_chat(owner, "<span class='warning'><b>Your mind snaps!</b></span>")
	to_chat(owner, "<big><span class='warning'><b>You can't remember how you got here...</b></span></big>")
	owner.announce_objectives()

/datum/antagonist/abductee/proc/give_objective()
	var/mob/living/carbon/human/H = owner.current
	if(istype(H))
		H.gain_trauma_type(BRAIN_TRAUMA_MILD, TRAUMA_RESILIENCE_LOBOTOMY)
	var/objtype = (prob(75) ? /datum/objective/abductee/random : pick(subtypesof(/datum/objective/abductee/) - /datum/objective/abductee/random))
	var/datum/objective/abductee/O = new objtype()
	objectives += O

/datum/antagonist/abductee/apply_innate_effects(mob/living/mob_override)
	update_abductor_icons_added(mob_override ? mob_override.mind : owner,"abductee")
	var/mob/living/carbon/C = mob_override || owner?.current
	if(istype(C))
		if(brain_trauma)
			qdel(brain_trauma)			//make sure there's no lingering trauma
		brain_trauma = C.gain_trauma(/datum/brain_trauma/abductee, TRAUMA_RESILIENCE_SURGERY)

/datum/antagonist/abductee/remove_innate_effects(mob/living/mob_override)
	update_abductor_icons_removed(mob_override ? mob_override.mind : owner)
	if(!QDELETED(brain_trauma))
		qdel(brain_trauma)
