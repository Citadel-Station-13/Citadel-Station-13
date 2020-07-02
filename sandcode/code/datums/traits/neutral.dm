/datum/quirk/hypnotic_stupor //straight from skyrat
	name = "Hypnotic Stupor"
	desc = "Your prone to episodes of extreme stupor that leaves you extremely suggestible."
	value = 0
	human_only = TRUE
	gain_text = null // Handled by trauma.
	lose_text = null
	medical_record_text = "Patient has an untreatable condition with their brain, wiring them to be extreamly suggestible..."

/datum/quirk/hypnotic_stupor/add()
	var/datum/brain_trauma/severe/hypnotic_stupor/T = new()
	var/mob/living/carbon/human/H = quirk_holder
	H.gain_trauma(T, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/knows_sagaru
	name = "Sagaru"
	desc = "From heavy study or just being born in Tal, you know the language Sagaru"
	value = 0
	human_only = TRUE
	gain_text = "<span class='danger'>You remember that you know Sagaru.</span>"
	lose_text = "<span class='danger'>You simply forgot how to speak Sagaru.</span>"
	medical_record_text = null
	mob_trait = TRAIT_KNOWSSAGARU

/datum/quirk/knows_sagaru/add()
	var/mob/living/carbon/human/H = quirk_holder
	H.grant_language(/datum/language/sandcode/sergal)

/datum/quirk/knows_sagaru/remove() //theorically you're not even able to lose it, but what if you do?
	var/mob/living/carbon/human/H = quirk_holder
	H.remove_language(/datum/language/sandcode/sergal)
