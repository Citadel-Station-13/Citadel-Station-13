SUBSYSTEM_DEF(disease)
	name = "Disease"
	flags = SS_NO_FIRE

	var/list/active_diseases = list() //List of Active disease in all mobs; purely for quick referencing.
	var/list/diseases
	var/list/archive_diseases = list()

	var/static/list/list_symptoms = subtypesof(/datum/symptom)

/datum/controller/subsystem/disease/PreInit()
	if(!diseases)
		diseases = subtypesof(/datum/disease)

/datum/controller/subsystem/disease/stat_entry(msg)
	..("P:[active_diseases.len]")