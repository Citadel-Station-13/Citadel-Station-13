/*
//////////////////////////////////////
Alopecia

	Noticable.
	Decreases resistance slightly.
	Reduces stage speed slightly.
	Transmittable.
	Intense Level.

BONUS
	Makes the mob lose hair.

//////////////////////////////////////
*/

/datum/symptom/shedding

	name = "Alopecia"
	stealth = -1
	resistance = -1
	stage_speed = -1
	transmittable = 2
	level = 4
	severity = 1

/datum/symptom/shedding/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/M = A.affected_mob
		M << "<span class='warning'>[pick("Your scalp itches.", "Your skin feels flakey.")]</span>"
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			switch(A.stage)
				if(3, 4)
					if(!(H.hair_style == "Bald") && !(H.hair_style == "Balding Hair"))
						H << "<span class='warning'>Your hair starts to fall out in clumps...</span>"
						spawn(50)
							H.hair_style = "Balding Hair"
							H.update_hair()
				if(5)
					if(!(H.facial_hair_style == "Shaved") || !(H.hair_style == "Bald"))
						H << "<span class='warning'>Your hair starts to fall out in clumps...</span>"
						spawn(50)
							H.facial_hair_style = "Shaved"
							H.hair_style = "Bald"
							H.update_hair()
	return