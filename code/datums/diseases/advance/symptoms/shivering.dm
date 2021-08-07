/*
//////////////////////////////////////

Shivering

	No change to hidden.
	Increases resistance.
	Increases stage speed.
	Little transmittable.
	Low level.

Bonus
	Cools down your body.

//////////////////////////////////////
*/

/datum/symptom/shivering
	name = "Shivering"
	desc = "The virus inhibits the body's thermoregulation, cooling the body down."
	stealth = 0
	resistance = 2
	stage_speed = 3
	transmittable = 2
	level = 2
	severity = 2
	symptom_delay_min = 10
	symptom_delay_max = 30
	var/unsafe = FALSE //over the cold threshold
	threshold_desc = list(
		"Stage Speed 5" = "Increases cooling speed,; the host can fall below safe temperature levels.",
		"Stage Speed 10" = "Further increases cooling speed."
	)

/datum/symptom/shivering/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stage_rate"] >= 5) //dangerous cold
		power = 1.5
		unsafe = TRUE
	if(A.properties["stage_rate"] >= 10)
		power = 2.5

/datum/symptom/shivering/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	if(!unsafe || A.stage < 4)
		to_chat(M, "<span class='warning'>[pick("You feel cold.", "You shiver.")]</span>")
	else
		to_chat(M, "<span class='userdanger'>[pick("You feel your blood run cold.", "You feel ice in your veins.", "You feel like you can't heat up.", "You shiver violently." )]</span>")
	var/get_cold = M.bodytemp_normal + ((power*A.stage)*((M.bodytemp_normal - M.hypothermia_limit)/A.max_stages))
	if(!unsafe)
		M.thermoregulation_baseline = max(M.hypothermia_limit+0.1, get_cold)
	else
		M.thermoregulation_baseline = get_cold
	return 1

/datum/symptom/shivering/End(datum/disease/advance/A)
	. = ..()
	if(.)
		var/mob/living/L = A.affected_mob
		L.thermoregulation_baseline = L.bodytemp_normal
