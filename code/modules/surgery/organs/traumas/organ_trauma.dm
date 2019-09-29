//Looking for organ traumas?
//They're not here, look in datums/organ_damage

//Organ trauma's are the hip new thing from Fermis
//They apply when an organ has been damaged

//For people looking to add/edit the concept;
//organ_traumas are supposed to be minor effects to the organ/host, with a medical flavour
//try to implement IRL diseases and conditions, be they infections/genetic/diseases/causes.
//They are supposed to have a specific cure, with incorrect cures increasing the severity of the trauma
//Higher severity, higher effects.
//They need to be diagnosed, i.e. they are NOT to be displayed easily on scanners. This is antithetical to the design
//Try to make the diagnosis process use any many techniques as possible avalible in medbay.
//Biopsies, ect.
/datum/organ_trauma
	var/name = "Organ Trauma"
	var/scan_desc //description when detected by a health scanner, to aid DIAGNOSIS, not to outright tell them what it is.
	var/mob/living/carbon/owner //the poor bastard
	var/obj/item/organ/organ //the poor bastard's organ
    //Do I want these?
	var/gain_text = "<span class='notice'>You feel traumatized.</span>"
	var/lose_text = "<span class='notice'>You no longer feel traumatized.</span>"

	var/random_gain = TRUE //can this be gained through random traumas?
    var/can_cure = TRUE
    var/severity = 1 //How bad the trauma is, usually made worse by incorrect diagnosis.
    var/max_severity = 3
    var/trauma_slot //What type the organ is, i.e. tongue/lung/ect

//obj/organ/organ_traumas
////////////////////////////////////ORGAN OBJ PROCS////////////////////////////////////

/obj/item/organ/proc/has_organ_trauma_type(organ_trauma_type = /datum/organ_trauma)
	for(var/X in organ_traumas)
		var/datum/organ_trauma/OT = X
		if(istype(OT, organ_trauma_type))
			return OT

/obj/item/organ/proc/get_organ_traumas_type(organ_trauma_type = /datum/organ_trauma)
	. = list()
	for(var/X in organ_traumas)
		var/datum/organ_trauma/OT = X
		if(istype(OT, organ_trauma_type))
			. += OT

/obj/item/organ/proc/can_gain_organ_trauma(datum/organ_trauma/trauma)
    for(var/X in organ_traumas)//No duplicates
        if(X == trauma)
            return FALSE
    if(slot != trauma_slot)//correct slots only please
        return FALSE
	if(!ispath(trauma))//Make sure it's a path
		trauma = trauma.type
	if(LAZYLEN(organ_traumas) >= 3)//3 max per organ
		return FALSE
	return TRUE

//Proc to use when directly adding a trauma to the organ, so extra args can be given
/obj/item/organ/proc/gain_organ_trauma(datum/organ_trauma/trauma, _severity = 1)
	if(!can_gain_trauma(trauma))
		return

	var/datum/organ_trauma/actual_trauma
	if(ispath(trauma))
		actual_trauma = new trauma()
	else
		actual_trauma = trauma

	if(actual_trauma.organ) //we don't accept used traumas here
		WARNING("gain_organ_trauma was given an already active trauma.")
		return

	traumas += actual_trauma
	actual_trauma.organ = src
	if(owner)
		actual_trauma.owner = owner
		actual_trauma.on_gain()
        actual_trauma.severity = _severity //Set severity

	SSblackbox.record_feedback("tally", "organ_traumas", 1, actual_trauma.type)

//Add a random trauma of a certain subtype
/obj/item/organ/proc/gain_organ_trauma_type(organ_trauma_type = /datum/organ_trauma, _slot, _severity = 1)
    if(!slot)
        _slot = slot
    if(slot != _slot)
        return FALSE
	var/list/datum/organ_trauma/possible_traumas = list()
	for(var/T in subtypesof(organ_trauma_type))
		var/datum/organ_trauma/OT = T
		if(can_gain_trauma(OT) && initial(OT.random_gain) && (_slot == OT.trauma_slot))
			possible_traumas += OT

	if(!LAZYLEN(possible_traumas))
		return FALSE

	var/trauma_type = pick(possible_traumas)
	gain_organ_trauma(trauma_type, _severity)

//Cure a random trauma of a certain organ slot level
/obj/item/organ/proc/cure_organ_trauma_slot(organ_trauma_type = /datum/organ_trauma, force_remove = FALSE)
	var/list/traumas = get_organ_traumas_type(organ_trauma_type)
	if(LAZYLEN(traumas))
		cure_organ_trauma(pick(traumas), force_remove)

/obj/item/organ/proc/cure_all_organ_traumas(full_remove)
	var/list/traumas = get_organ_traumas_type()
	for(var/X in traumas)
		cure_organ_trauma(X, TRUE)

//Only curable is severity 1
/obj/item/organ/proc/cure_organ_trauma(/datum/organ_trauma/trauma, force_remove = FALSE)
    if(force_remove)
        qdel(trauma)
        return TRUE
    if(trauma.severity > 1)
        trauma.decrease_severity()
        return FALSE
    if(!can_cure)
        return FALSE
    qdel(trauma)
    return TRUE


////////////////////////////////////ACTIVE///////////////////////////////////

/datum/organ_trauma/Destroy()
    on_lose()
	organ.traumas -= src
	organ = null
	owner = null
	return ..()

//Called on life ticks
/datum/organ_trauma/proc/on_life()
	return

//Called on death
/datum/organ_trauma/proc/on_death()
	return

//Called when exposed to correct treatment
/datum/organ_trauma/proc/cure_expose()
	return

//Called when given to a mob
/datum/organ_trauma/proc/on_gain()
    if(gain_text && owner)//generally no message, diagnosics isn't a simple art!
        to_chat(owner, gain_text)
    return


//Called when removed from a mob
/datum/organ_trauma/proc/on_lose()
	if(lose_text && owner)
		to_chat(owner, lose_text)
    return

//Called when incorrect treatment is given
/datum/organ_trauma/proc/increase_severity()
    if(max_severity > severity)
        severity++
    else
        can_cure = FALSE
    return

//Called when correct treatment is given
/datum/organ_trauma/proc/decrease_severity()
    if(!can_cure)
        return
    severity--
    if(!severity)
        if(can_cure)
            qdel(src)


//Called when hearing a spoken message


//Called when speaking
/datum/organ_trauma/proc/handle_speech(datum/source, list/speech_args)
	UnregisterSignal(owner, COMSIG_MOB_SAY)
