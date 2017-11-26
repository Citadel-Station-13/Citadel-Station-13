/*
//////////////////////////////////////

Weight Loss

	Very Very Noticable.
	Decreases resistance.
	Decreases stage speed.
	Reduced Transmittable.
	High level.

Bonus
	Decreases the weight of the mob,
	forcing it to be skinny.

//////////////////////////////////////
*/

/datum/symptom/weight_loss

	name = "Weight Loss"
	desc = "The virus mutates the host's metabolism, making it almost unable to gain nutrition from food."
	stealth = -2
	resistance = 2
	stage_speed = -2
	transmittable = -2
	level = 3
	severity = 3
	base_message_chance = 100
	symptom_delay_min = 15
	symptom_delay_max = 45
	threshold_desc = "<b>Stealth 4:</b> The symptom is less noticeable."

/datum/symptom/weight_loss/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["stealth"] >= 4) //warn less often
		base_message_chance = 25

/datum/symptom/weight_loss/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(1, 2, 3, 4)
			if(prob(base_message_chance))
				to_chat(M, "<span class='warning'>[pick("You feel hungry.", "You crave for food.")]</span>")
		else
			to_chat(M, "<span class='warning'><i>[pick("So hungry...", "You'd kill someone for a bite of food...", "Hunger cramps seize you...")]</i></span>")
			M.overeatduration = max(M.overeatduration - 100, 0)
<<<<<<< HEAD
			M.nutrition = max(M.nutrition - 100, 0)

/*
//////////////////////////////////////

Weight Even

	Very Noticable.
	Decreases resistance.
	Decreases stage speed.
	Reduced transmittable.
	High level.

Bonus
	Causes the weight of the mob to
	be even, meaning eating isn't
	required anymore.

//////////////////////////////////////
*/

/datum/symptom/weight_even

	name = "Weight Even"
	desc = "The virus alters the host's metabolism, making it far more efficient then normal, and synthesizing nutrients from normally unedible sources."
	stealth = -3
	resistance = -2
	stage_speed = -2
	transmittable = -2
	level = 4
	symptom_delay_min = 5
	symptom_delay_max = 5

/datum/symptom/weight_even/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(4, 5)
			M.overeatduration = 0
			M.nutrition = NUTRITION_LEVEL_WELL_FED + 50
=======
			M.nutrition = max(M.nutrition - 100, 0)
>>>>>>> fbe8889... [Super-Ready for review]Reworks healing symptoms into conditional healing symptoms (#32432)
