// Cold

/datum/disease/advance/cold/New(var/process = TRUE, var/datum/disease/advance/D, var/copy = FALSE)
	if(!D)
		name = "Cold"
		symptoms = list(new/datum/symptom/sneeze)
	..(process, D, copy)


// Flu

/datum/disease/advance/flu/New(var/process = TRUE, var/datum/disease/advance/D, var/copy = FALSE)
	if(!D)
		name = "Flu"
		symptoms = list(new/datum/symptom/cough)
	..(process, D, copy)


// Voice Changing

/datum/disease/advance/voice_change/New(var/process = TRUE, var/datum/disease/advance/D, var/copy = FALSE)
	if(!D)
		name = "Epiglottis Mutation"
		symptoms = list(new/datum/symptom/voice_change)
	..(process, D, copy)


// Toxin Filter

/datum/disease/advance/heal/New(var/process = TRUE, var/datum/disease/advance/D, var/copy = FALSE)
	if(!D)
		name = "Liver Enhancer"
		symptoms = list(new/datum/symptom/heal)
	..(process, D, copy)


// Hallucigen

/datum/disease/advance/hallucigen/New(var/process = TRUE, var/datum/disease/advance/D, var/copy = FALSE)
	if(!D)
		name = "Second Sight"
		symptoms = list(new/datum/symptom/hallucigen)
	..(process, D, copy)

// Sensory Restoration

/datum/disease/advance/mind_restoration/New(var/process = TRUE, var/datum/disease/advance/D, var/copy = FALSE)
	if(!D)
		name = "Intelligence Booster"
		symptoms = list(new/datum/symptom/mind_restoration)
	..(process, D, copy)

// Sensory Destruction

/datum/disease/advance/narcolepsy/New(var/process = TRUE, var/datum/disease/advance/D, var/copy = FALSE)
	if(!D)
		name = "Experimental Insomnia Cure"
		symptoms = list(new/datum/symptom/narcolepsy)
	..(process, D, copy)