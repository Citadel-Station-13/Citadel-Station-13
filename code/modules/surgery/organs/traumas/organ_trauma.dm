//Looking for brain traumas?
//They're not here, look in datums/brain_damage

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

/*TRAUMA TYPES:
Infection: Persists through organ transfer and can develop resistances to antibiotics (the cure) when administered to incorrect organs.
Generally cured via reagents, and detected by increased patient temperature. Microscopy of a biopsied agar can be used to confirm.
Severity will grow over time naturally, and require constant levels of antibiotics present in a patient over time to reduce.

Physiological: Caused by a physical deformation of the organ. Treated either by medication, or cured by grafting. Incorrect cures can cause inflamation, masking it as infectious.
Any organ damage taken with the trauma will increase the severity.

Genetic: Persists through cloning. Always present in monkey organs. Generally treatable but not curable.

Autoimmune: Strength is equal to patient health. Can be given targeted immunosuppressants to treat, but will make any infections present reach max_severity.

Allergies: Reagent based reactions. Requires antihistamines.

Defiencies: The oposite of Allergies, without the reagent causes problems.
*/

/*TODO:
1. bacteria datum
    different types with png
    microscope
    organs get infected if they decay too long.
2. Biopsies
3. Antibiotic reagents
    Antibiotics cause liver stress
    Something to do with appendix for bacteria
*/

//ORGAN_SLOT_HEART, ORGAN_SLOT_LIVER, ORGAN_SLOT_LUNG, ORGAN_SLOT_EYES, ORGAN_SLOT_EARS, ORGAN_SLOT_STOMACH, ORGAN_SLOT_TONGUE, ORGAN_SLOT_APPENDIX

/datum/organ_trauma
	var/name = "Organ Trauma"
	var/trauma_slot = list()//ORGAN_SLOTs of where the trauma can go
	var/scan_desc //description when detected by a health scanner, to aid DIAGNOSIS, not to outright tell them what it is.
	var/mob/living/carbon/owner //the poor bugger
	var/obj/item/organ/organ //the poor bugger's organ
    //Do I want these?
	var/gain_text = "<span class='notice'>You feel traumatized.</span>"
	var/lose_text = "<span class='notice'>You no longer feel traumatized.</span>"

	var/random_gain = TRUE //can this be gained through random traumas?
    var/can_cure = TRUE
    var/severity = 1 //How bad the trauma is, usually made worse by incorrect diagnosis.
    var/max_severity = 3 //How bad something can get.

    var/trauma_flags //What kind of trauma it is.

	var/datum/bacteria //If it has a bacterial infection

//obj/organ/organ_traumas
////////////////////////////////////ORGAN OBJ PROCS////////////////////////////////////
//Organ obj vars:
//var/list/datum/organ_trauma/organ_traumas = list()
//var/total_trauma_damage = 0

//Checks to see if the organ has a trauma and returns it
/obj/item/organ/proc/has_organ_trauma_type(organ_trauma_type = /datum/organ_trauma)
	for(var/X in organ_traumas)
		var/datum/organ_trauma/OT = X
		if(istype(OT, organ_trauma_type))
			return OT

//Returns traumas currently applied to an organ
/obj/item/organ/proc/get_organ_traumas_type(organ_trauma_type = /datum/organ_trauma)
	. = list()
	for(var/X in organ_traumas)
		var/datum/organ_trauma/OT = X
		if(istype(OT, organ_trauma_type))
			. += OT

//Checks to see if the organ can gain the trauma by blocking dupes,
//ensuring correct slot, ensuring passed argument is a path and limiting total num traumas
/obj/item/organ/proc/can_gain_organ_trauma(datum/organ_trauma/trauma)
    for(var/X in organ_traumas)//No duplicates
        if(X == trauma)
            return FALSE
    if(!is_correct_slot())//correct slots only please
        return FALSE
	if(!ispath(trauma))//Make sure it's a path
		trauma = trauma.type
	if(LAZYLEN(organ_traumas) >= 3)//3 max per organ
		return FALSE
	return TRUE

//Checks to see if the current trauma can be assinged to the current organ
/obj/item/organ/proc/is_correct_slot()
	var/is_correct = FALSE
	for(var/O in trauma.trauma_slot)
		if(O == slot)
			is_correct = TRUE
	return is_correct

//Proc to use when directly adding a trauma to the organ, so extra args can be given, -1 = max severity
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
		if(_severity = -1)
			actual_trauma.severity = max_severity //Set severity
		else
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
		if(can_gain_trauma(OT) && initial(OT.random_gain) && (is_correct_slot()))
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

////////////////////////////////////ORGAN PROCS



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

//Called when exposed to incorrect treatment
/datum/organ_trauma/proc/exacerbate_condition()
	return

//Called when given to a mob
/datum/organ_trauma/proc/on_gain()
	if(trauma_flags == ORGAN_TRAUMA_BACTERIA)
		bacteria = new/datum/bacterium()
		organ.organ_flags |= ORGAN_INFECTION
    if(gain_text && owner)//generally no message, diagnosics isn't a simple art!
        to_chat(owner, gain_text)
    return


//Called when removed from a mob
/datum/organ_trauma/proc/on_lose()
	if(lose_text && owner)
		to_chat(owner, lose_text)
    return

//Called when the thing gets swords_lefthand
/datum/organ_trauma/proc/increase_severity()
    if(max_severity > severity)
        severity++
		on_increase()
    else
		if(trauma_flags & ORGAN_TRAUMA_PERMA_MAX) //If it reaches endstate, is the organ uncureable?
			can_cure = FALSE
    return

//called when condition worsens
/datum/organ_trauma/proc/on_increase()
	return

//Called when correct treatment is given
/datum/organ_trauma/proc/decrease_severity()
    severity--
    if(!severity)
        if(can_cure)
            qdel(src)
			return
		severity = 1
	on_decrease()


//called when condition weakens
/datum/organ_trauma/proc/on_decrease()
	return

//Called when speaking
/datum/organ_trauma/proc/handle_speech(datum/source, list/speech_args)
	UnregisterSignal(owner, COMSIG_MOB_SAY)
