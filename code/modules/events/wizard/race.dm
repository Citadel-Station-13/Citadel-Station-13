/datum/round_event_control/wizard/race //Lizard Wizard? Lizard Wizard.
	name = "Race Swap"
	weight = 2
	typepath = /datum/round_event/wizard/race
	max_occurrences = 5
	earliest_start = 0 MINUTES
	can_be_midround_wizard = FALSE

/datum/round_event/wizard/race
	var/list/stored_name
	var/list/stored_species
	var/list/stored_dna
	threat = 10

/datum/round_event/wizard/race/setup()
	stored_name = list()
	stored_species = list()
	stored_dna = list()
	endWhen = rand(600,1200) //10 to 20 minutes
	..()

/datum/round_event/wizard/race/start()

	var/all_the_same = 0
	var/all_species = list()

	for(var/speciestype in subtypesof(/datum/species))
		var/datum/species/S = new speciestype()
		if(!S.dangerous_existence && !S.blacklisted && !S.nojumpsuit) //Dangerous Species, Blacklisted Species, and Species who can't wear jumpsuits are blacklisted.
			all_species += speciestype

	var/datum/species/new_species = pick(all_species)

	if(prob(75))
		all_the_same = 1

	for(var/mob/living/carbon/human/H in GLOB.carbon_list)
		var/turf/T = get_turf(H)
		if(!T)
			continue
		if(!is_station_level(T.z))
			continue
		stored_name[H] = H.real_name
		stored_species[H] = H.dna.species
		stored_dna[H] = H.dna.unique_enzymes
		H.set_species(new_species)
		H.real_name = H.dna.species.random_name(H.gender,1)
		H.dna.unique_enzymes = H.dna.generate_unique_enzymes()
		to_chat(H, "<span class='notice'>You feel somehow... different?</span>")
		if(!all_the_same)
			new_species = pick(all_species)

/datum/round_event/wizard/race/end()
	for(var/mob/living/carbon/human/H in GLOB.carbon_list)
		if(!(stored_name[H] && stored_species[H] && stored_dna[H]))
			continue
		H.set_species(stored_species[H])
		H.real_name = stored_name[H]
		H.dna.unique_enzymes = stored_dna[H]
		to_chat(H, "<span class='notice'>You feel back to your normal self again.</span>")
