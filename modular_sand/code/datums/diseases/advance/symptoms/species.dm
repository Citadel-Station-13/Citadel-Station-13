/datum/symptom/inorganic_adaptation/OnAdd(datum/disease/advance/A)
	. = ..()
	A.infectable_biotypes |= MOB_ROBOTIC //Mineral covers plasmamen and golems.

/datum/symptom/inorganic_adaptation/OnRemove(datum/disease/advance/A)
	. = ..()
	A.infectable_biotypes &= ~MOB_ROBOTIC
