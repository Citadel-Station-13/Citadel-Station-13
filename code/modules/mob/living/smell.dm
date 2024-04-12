#define DEFAULT_SMELL_SENSITIVITY 1

/mob/living
	var/last_smell_time
	var/last_smell_text

/mob/living/proc/get_smell_sensitivity()
	return DEFAULT_SMELL_SENSITIVITY

/mob/living/carbon/get_smell_sensitivity()
	. = DEFAULT_SMELL_SENSITIVITY
	var/obj/item/organ/lungs/lungs = getorganslot(ORGAN_SLOT_LUNGS) // don't think about it too hard
	if(istype(lungs))
		. = lungs.smell_sensitivity
	if(HAS_TRAIT(src, TRAIT_ANOSMIA))
		. *= 0
	else if(HAS_TRAIT(src, TRAIT_GOODSMELL))
		. *= 2

/mob/living/proc/smell(datum/gas_mixture/from)
	if(last_smell_time + 50 > world.time)
		return FALSE
	var/smell_sensitivity = get_smell_sensitivity()

	if(smell_sensitivity == 0)
		return FALSE

	var/pressure = from.return_pressure()
	var/total_moles = from.total_moles()

	#define PP_MOLES(X) ((X / total_moles) * pressure)

	#define PP(air, gas) PP_MOLES(air.get_moles(gas))

	var/list/odors = GLOB.gas_data.odors
	var/list/odor_strengths = GLOB.gas_data.odor_strengths
	var/list/odors_found = list()
	for(var/gas in from.get_gases())
		if(!(gas in odors))
			continue
		var/pp = PP(from, gas)
		var/strength = (odor_strengths[gas] / smell_sensitivity)
		if(pp > 2*strength)
			odors_found += "[odors[gas]]"
		else if(pp > strength)
			odors_found += "a hint of [odors[gas]]"
	if(!length(odors_found))
		return FALSE
	var/text_output = ""
	if(hallucination > 50 && prob(25))
		text_output = pick("", "spiders","dreams","nightmares","the future","the past","victory",\
		"defeat","pain","bliss","chaos","revenge","cold","rotten glass","poison","time","space","death","life","truth","lies","justice","memory",\
		"regrets","your soul","suffering","magic","music","noise","blood","hunger","the american way")
	else
		text_output = english_list(odors_found, "something indescribable")
	if(text_output != last_smell_text || last_smell_time + 100 < world.time)
		to_chat(src, "<span class='notice'>You can smell [text_output].</span>")
		last_smell_time = world.time
		last_smell_text = text_output

	#undef PP_MOLES
	#undef PP
