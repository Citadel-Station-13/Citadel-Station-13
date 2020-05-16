
/datum/chemical_reaction/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	results = list(/datum/reagent/space_cleaner/sterilizine = 3)
	required_reagents = list(/datum/reagent/consumable/ethanol = 1, /datum/reagent/medicine/charcoal = 1, /datum/reagent/chlorine = 1)

/datum/chemical_reaction/lube
	name = "Space Lube"
	id = /datum/reagent/lube
	results = list(/datum/reagent/lube = 4)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/silicon = 1, /datum/reagent/oxygen = 1)

/datum/chemical_reaction/spraytan
	name = "Spray Tan"
	id = /datum/reagent/spraytan
	results = list(/datum/reagent/spraytan = 2)
	required_reagents = list(/datum/reagent/consumable/orangejuice = 1, /datum/reagent/oil = 1)

/datum/chemical_reaction/spraytan2
	name = "Spray Tan"
	id = "spraytan2"
	results = list(/datum/reagent/spraytan = 2)
	required_reagents = list(/datum/reagent/consumable/orangejuice = 1, /datum/reagent/consumable/cornoil = 1)

/datum/chemical_reaction/impedrezene
	name = "Impedrezene"
	id = /datum/reagent/impedrezene
	results = list(/datum/reagent/impedrezene = 2)
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/oxygen = 1, /datum/reagent/consumable/sugar = 1)

/datum/chemical_reaction/cryptobiolin
	name = "Cryptobiolin"
	id = /datum/reagent/cryptobiolin
	results = list(/datum/reagent/cryptobiolin = 3)
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/oxygen = 1, /datum/reagent/consumable/sugar = 1)

/datum/chemical_reaction/glycerol
	name = "Glycerol"
	id = /datum/reagent/glycerol
	results = list(/datum/reagent/glycerol = 1)
	required_reagents = list(/datum/reagent/consumable/cornoil = 3, /datum/reagent/toxin/acid = 1)

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	id = "sodiumchloride"
	results = list(/datum/reagent/consumable/sodiumchloride = 3)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/sodium = 1, /datum/reagent/chlorine = 1)

/datum/chemical_reaction/preservahyde
	name = "Preservahyde"
	id = "preservahyde"
	results = list(/datum/reagent/preservahyde = 3)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/toxin/formaldehyde = 1, /datum/reagent/bromine = 1)

/datum/chemical_reaction/plasmasolidification
	name = "Solid Plasma"
	id = "solidplasma"
	required_reagents = list(/datum/reagent/iron = 5, /datum/reagent/consumable/frostoil = 5, /datum/reagent/toxin/plasma = 20)
	mob_react = FALSE

/datum/chemical_reaction/plasmasolidification/on_reaction(datum/reagents/holder, multiplier)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= multiplier, i++)
		new /obj/item/stack/sheet/mineral/plasma(location)

/datum/chemical_reaction/goldsolidification
	name = "Solid Gold"
	id = "solidgold"
	required_reagents = list(/datum/reagent/consumable/frostoil = 5, /datum/reagent/gold = 20, /datum/reagent/iron = 1)
	mob_react = FALSE

/datum/chemical_reaction/goldsolidification/on_reaction(datum/reagents/holder, multiplier)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= multiplier, i++)
		new /obj/item/stack/sheet/mineral/gold(location)

/datum/chemical_reaction/uraniumsolidification
	name = "Solid Uranium"
	id = "soliduranium"
	required_reagents = list(/datum/reagent/consumable/frostoil = 5, /datum/reagent/uranium = 20, /datum/reagent/bromine = 1)
	mob_react = FALSE

/datum/chemical_reaction/uraniumsolidification/on_reaction(datum/reagents/holder, multiplier)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= multiplier, i++)
		new /obj/item/stack/sheet/mineral/uranium(location)

/datum/chemical_reaction/bluespacecrystalifaction
	name = "Crystal Bluespace"
	id = "crystalbluespace"
	required_reagents = list(/datum/reagent/consumable/frostoil = 5, /datum/reagent/bluespace = 20, /datum/reagent/iron = 1)
	mob_react = FALSE

/datum/chemical_reaction/bluespacecrystalifaction/on_reaction(datum/reagents/holder, multiplier)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= multiplier, i++)
		new /obj/item/stack/sheet/bluespace_crystal(location)

/datum/chemical_reaction/capsaicincondensation
	name = "Capsaicincondensation"
	id = /datum/reagent/consumable/condensedcapsaicin
	results = list(/datum/reagent/consumable/condensedcapsaicin = 5)
	required_reagents = list(/datum/reagent/consumable/capsaicin = 1, /datum/reagent/consumable/ethanol = 5)

/datum/chemical_reaction/soapification
	name = "Soapification"
	id = "soapification"
	required_reagents = list(/datum/reagent/liquidgibs = 10, /datum/reagent/lye  = 10) // requires two scooped gib tiles
	required_temp = 374
	mob_react = FALSE

/datum/chemical_reaction/mustard
	name = "Mustard"
	id = /datum/reagent/consumable/mustard
	results = list(/datum/reagent/consumable/mustard = 5)
	required_reagents = list(/datum/reagent/mustardgrind = 1, /datum/reagent/water  = 10, /datum/reagent/consumable/enzyme= 1)

/datum/chemical_reaction/soapification/on_reaction(datum/reagents/holder, multiplier)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= multiplier, i++)
		new /obj/item/soap/homemade(location)

/datum/chemical_reaction/candlefication
	name = "Candlefication"
	id = "candlefication"
	required_reagents = list(/datum/reagent/liquidgibs = 5, /datum/reagent/oxygen  = 5)
	required_temp = 374
	mob_react = FALSE

/datum/chemical_reaction/candlefication/on_reaction(datum/reagents/holder, multiplier)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= multiplier, i++)
		new /obj/item/candle(location)

/datum/chemical_reaction/meatification
	name = "Meatification"
	id = "meatification"
	required_reagents = list(/datum/reagent/liquidgibs = 10, /datum/reagent/consumable/nutriment = 10, /datum/reagent/carbon = 10)
	mob_react = FALSE

/datum/chemical_reaction/meatification/on_reaction(datum/reagents/holder, multiplier)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= multiplier, i++)
		new /obj/item/reagent_containers/food/snacks/meat/slab/meatproduct(location)
	return

/datum/chemical_reaction/carbondioxide
	name = "Direct Carbon Oxidation"
	id = /datum/reagent/carbondioxide
	results = list(/datum/reagent/carbondioxide = 3)
	required_reagents = list(/datum/reagent/carbon = 1, /datum/reagent/oxygen = 2)
	required_temp = 777 // pure carbon isn't especially reactive.

/datum/chemical_reaction/nitrous_oxide
	name = "Nitrous Oxide"
	id = /datum/reagent/nitrous_oxide
	results = list(/datum/reagent/nitrous_oxide = 5)
	required_reagents = list(/datum/reagent/ammonia = 2, /datum/reagent/nitrogen = 1, /datum/reagent/oxygen = 2)
	required_temp = 525

//Technically a mutation toxin
/datum/chemical_reaction/mulligan
	name = "Mulligan"
	id = "mulligan"
	results = list(/datum/reagent/mulligan = 1)
	required_reagents = list(/datum/reagent/slime_toxin = 1, /datum/reagent/toxin/mutagen = 1)


/datum/chemical_reaction/fermis_plush
	name = "Fermis plush"
	id = "fermis_plush"
	required_reagents = list(/datum/reagent/consumable/caramel = 10, /datum/reagent/blood = 10, /datum/reagent/stable_plasma = 10)
	mob_react = FALSE
	required_temp = 300

/datum/chemical_reaction/fermis_plush/on_reaction(datum/reagents/holder, multiplier)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= multiplier, i+=10)
		new /obj/item/toy/plush/catgirl/fermis(location)

////////////////////////////////// VIROLOGY //////////////////////////////////////////

/datum/chemical_reaction/virus_food
	name = "Virus Food"
	id = "virusfood"
	results = list(/datum/reagent/consumable/virus_food = 15)
	required_reagents = list(/datum/reagent/water = 5, /datum/reagent/consumable/milk = 5)

/datum/chemical_reaction/virus_food_mutagen
	name = "mutagenic agar"
	id = "mutagenvirusfood"
	results = list(/datum/reagent/toxin/mutagen/mutagenvirusfood = 1)
	required_reagents = list(/datum/reagent/toxin/mutagen = 1, /datum/reagent/consumable/virus_food = 1)

/datum/chemical_reaction/virus_food_synaptizine
	name = "virus rations"
	id = "synaptizinevirusfood"
	results = list(/datum/reagent/medicine/synaptizine/synaptizinevirusfood = 1)
	required_reagents = list(/datum/reagent/medicine/synaptizine = 1, /datum/reagent/consumable/virus_food = 1)

/datum/chemical_reaction/virus_food_plasma
	name = "virus plasma"
	id = /datum/reagent/toxin/plasma/plasmavirusfood
	results = list(/datum/reagent/toxin/plasma/plasmavirusfood = 1)
	required_reagents = list(/datum/reagent/toxin/plasma = 1, /datum/reagent/consumable/virus_food = 1)

/datum/chemical_reaction/virus_food_plasma_synaptizine
	name = "weakened virus plasma"
	id = /datum/reagent/toxin/plasma/plasmavirusfood/weak
	results = list(/datum/reagent/toxin/plasma/plasmavirusfood/weak = 2)
	required_reagents = list(/datum/reagent/medicine/synaptizine = 1, /datum/reagent/toxin/plasma/plasmavirusfood = 1)

/datum/chemical_reaction/virus_food_mutagen_sugar
	name = "sucrose agar"
	id = /datum/reagent/toxin/mutagen/mutagenvirusfood/sugar
	results = list(/datum/reagent/toxin/mutagen/mutagenvirusfood/sugar = 2)
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/toxin/mutagen/mutagenvirusfood = 1)

/datum/chemical_reaction/virus_food_mutagen_salineglucose
	name = "sucrose agar"
	id = "salineglucosevirusfood"
	results = list(/datum/reagent/toxin/mutagen/mutagenvirusfood/sugar = 2)
	required_reagents = list(/datum/reagent/medicine/salglu_solution = 1, /datum/reagent/toxin/mutagen/mutagenvirusfood = 1)

/datum/chemical_reaction/virus_food_uranium
	name = "Decaying uranium gel"
	id = /datum/reagent/uranium/uraniumvirusfood
	results = list(/datum/reagent/uranium/uraniumvirusfood = 1)
	required_reagents = list(/datum/reagent/uranium = 1, /datum/reagent/consumable/virus_food = 1)

/datum/chemical_reaction/virus_food_uranium_plasma
	name = "Unstable uranium gel"
	id = /datum/reagent/uranium/uraniumvirusfood/unstable
	results = list(/datum/reagent/uranium/uraniumvirusfood/unstable = 1)
	required_reagents = list(/datum/reagent/uranium = 5, /datum/reagent/toxin/plasma/plasmavirusfood = 1)

/datum/chemical_reaction/virus_food_uranium_plasma_gold
	name = "Stable uranium gel"
	id = "uraniumvirusfood_gold"
	results = list(/datum/reagent/uranium/uraniumvirusfood/stable = 1)
	required_reagents = list(/datum/reagent/uranium = 10, /datum/reagent/gold = 10, /datum/reagent/toxin/plasma = 1)

/datum/chemical_reaction/virus_food_uranium_plasma_silver
	name = "Stable uranium gel"
	id = "uraniumvirusfood_silver"
	results = list(/datum/reagent/uranium/uraniumvirusfood/stable = 1)
	required_reagents = list(/datum/reagent/uranium = 10, /datum/reagent/silver = 10, /datum/reagent/toxin/plasma = 1)

/datum/chemical_reaction/mix_virus
	name = "Mix Virus"
	id = "mixvirus"
	required_reagents = list(/datum/reagent/consumable/virus_food = 1)
	required_catalysts = list(/datum/reagent/blood = 1)
	var/level_min = 1
	var/level_max = 2

/datum/chemical_reaction/mix_virus/on_reaction(datum/reagents/holder, multiplier)
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			for(var/i in 1 to min(multiplier, 5))
				D.Evolve(level_min, level_max)

/datum/chemical_reaction/mix_virus/synth
	id = "mixvirus_synth"
	required_catalysts = list(/datum/reagent/blood/synthetics = 1)

/datum/chemical_reaction/mix_virus/mix_virus_2
	name = "Mix Virus 2"
	id = "mixvirus2"
	required_reagents = list(/datum/reagent/toxin/mutagen = 1)
	level_min = 2
	level_max = 4

/datum/chemical_reaction/mix_virus/mix_virus_2/synth
	id = "mixvirus2_synth"
	required_catalysts = list(/datum/reagent/blood/synthetics = 1)

/datum/chemical_reaction/mix_virus/mix_virus_3
	name = "Mix Virus 3"
	id = "mixvirus3"
	required_reagents = list(/datum/reagent/toxin/plasma = 1)
	level_min = 4
	level_max = 6

/datum/chemical_reaction/mix_virus/mix_virus_3/synth
	id = "mixvirus3_synth"
	required_catalysts = list(/datum/reagent/blood/synthetics = 1)

/datum/chemical_reaction/mix_virus/mix_virus_4
	name = "Mix Virus 4"
	id = "mixvirus4"
	required_reagents = list(/datum/reagent/uranium = 1)
	level_min = 5
	level_max = 6

/datum/chemical_reaction/mix_virus/mix_virus_4/synth
	id = "mixvirus4_synth"
	required_catalysts = list(/datum/reagent/blood/synthetics = 1)

/datum/chemical_reaction/mix_virus/mix_virus_5
	name = "Mix Virus 5"
	id = "mixvirus5"
	required_reagents = list(/datum/reagent/toxin/mutagen/mutagenvirusfood = 1)
	level_min = 3
	level_max = 3

/datum/chemical_reaction/mix_virus/mix_virus_5/synth
	id = "mixvirus5_synth"
	required_catalysts = list(/datum/reagent/blood/synthetics = 1)

/datum/chemical_reaction/mix_virus/mix_virus_6
	name = "Mix Virus 6"
	id = "mixvirus6"
	required_reagents = list(/datum/reagent/toxin/mutagen/mutagenvirusfood/sugar = 1)
	level_min = 4
	level_max = 4

/datum/chemical_reaction/mix_virus/mix_virus_6/synth
	id = "mixvirus6_synth"
	required_catalysts = list(/datum/reagent/blood/synthetics = 1)

/datum/chemical_reaction/mix_virus/mix_virus_7
	name = "Mix Virus 7"
	id = "mixvirus7"
	required_reagents = list(/datum/reagent/toxin/plasma/plasmavirusfood/weak = 1)
	level_min = 5
	level_max = 5

/datum/chemical_reaction/mix_virus/mix_virus_7/synth
	id = "mixvirus7_synth"
	required_catalysts = list(/datum/reagent/blood/synthetics = 1)

/datum/chemical_reaction/mix_virus/mix_virus_8
	name = "Mix Virus 8"
	id = "mixvirus8"
	required_reagents = list(/datum/reagent/toxin/plasma/plasmavirusfood = 1)
	level_min = 6
	level_max = 6

/datum/chemical_reaction/mix_virus/mix_virus_8/synth
	id = "mixvirus8_synth"
	required_catalysts = list(/datum/reagent/blood/synthetics = 1)

/datum/chemical_reaction/mix_virus/mix_virus_9
	name = "Mix Virus 9"
	id = "mixvirus9"
	required_reagents = list(/datum/reagent/medicine/synaptizine/synaptizinevirusfood = 1)
	level_min = 1
	level_max = 1

/datum/chemical_reaction/mix_virus/mix_virus_9/synth
	id = "mixvirus9_synth"
	required_catalysts = list(/datum/reagent/blood/synthetics = 1)

/datum/chemical_reaction/mix_virus/mix_virus_10
	name = "Mix Virus 10"
	id = "mixvirus10"
	required_reagents = list(/datum/reagent/uranium/uraniumvirusfood = 1)
	level_min = 6
	level_max = 7

/datum/chemical_reaction/mix_virus/mix_virus_10/synth
	id = "mixvirus10_synth"
	required_catalysts = list(/datum/reagent/blood/synthetics = 1)

/datum/chemical_reaction/mix_virus/mix_virus_11
	name = "Mix Virus 11"
	id = "mixvirus11"
	required_reagents = list(/datum/reagent/uranium/uraniumvirusfood/unstable = 1)
	level_min = 7
	level_max = 7

/datum/chemical_reaction/mix_virus/mix_virus_11/synth
	id = "mixvirus11_synth"
	required_catalysts = list(/datum/reagent/blood/synthetics = 1)

/datum/chemical_reaction/mix_virus/mix_virus_12
	name = "Mix Virus 12"
	id = "mixvirus12"
	required_reagents = list(/datum/reagent/uranium/uraniumvirusfood/stable = 1)
	level_min = 8
	level_max = 8

/datum/chemical_reaction/mix_virus/mix_virus_12/synth
	id = "mixvirus12_synth"
	required_catalysts = list(/datum/reagent/blood/synthetics = 1)

/datum/chemical_reaction/mix_virus/rem_virus
	name = "Devolve Virus"
	id = "remvirus"
	required_reagents = list(/datum/reagent/medicine/synaptizine = 1)
	required_catalysts = list(/datum/reagent/blood = 1)

/datum/chemical_reaction/mix_virus/rem_virus/on_reaction(datum/reagents/holder, multiplier)
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			for(var/i in 1 to min(multiplier, 5))
				D.Devolve()

/datum/chemical_reaction/mix_virus/rem_virus/synth
	id = "remvirus_synth"
	required_catalysts = list(/datum/reagent/blood/synthetics = 1)

/datum/chemical_reaction/mix_virus/neuter_virus
	name = "Neuter Virus"
	id = "neutervirus"
	required_reagents = list(/datum/reagent/toxin/formaldehyde = 1)
	required_catalysts = list(/datum/reagent/blood = 1)

/datum/chemical_reaction/mix_virus/neuter_virus/on_reaction(datum/reagents/holder, multiplier)
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in holder.reagent_list
	if(B && B.data)
		var/datum/disease/advance/D = locate(/datum/disease/advance) in B.data["viruses"]
		if(D)
			for(var/i in 1 to min(multiplier, 5))
				D.Neuter()

/datum/chemical_reaction/mix_virus/neuter_virus/synth
	id = "neutervirus_synth"
	required_catalysts = list(/datum/reagent/blood/synthetics = 1)

////////////////////////////////// foam and foam precursor ///////////////////////////////////////////////////


/datum/chemical_reaction/surfactant
	name = "Foam surfactant"
	id = "foam surfactant"
	results = list(/datum/reagent/fluorosurfactant = 5)
	required_reagents = list(/datum/reagent/fluorine = 2, /datum/reagent/carbon = 2, /datum/reagent/toxin/acid = 1)

/datum/chemical_reaction/foam
	name = "Foam"
	id = "foam"
	required_reagents = list(/datum/reagent/fluorosurfactant = 1, /datum/reagent/water = 1)
	mob_react = FALSE

/datum/chemical_reaction/foam/on_reaction(datum/reagents/holder, multiplier)
	var/turf/location = get_turf(holder.my_atom)
	location.visible_message("<span class='danger'>The solution spews out foam!</span>")
	var/datum/effect_system/foam_spread/s = new()
	s.set_up(multiplier*2, location, holder)
	s.start()
	holder.clear_reagents()
	return


/datum/chemical_reaction/metalfoam
	name = "Metal Foam"
	id = "metalfoam"
	required_reagents = list(/datum/reagent/aluminium = 3, /datum/reagent/foaming_agent = 1, /datum/reagent/toxin/acid/fluacid = 1)
	mob_react = FALSE

/datum/chemical_reaction/metalfoam/on_reaction(datum/reagents/holder, multiplier)
	var/turf/location = get_turf(holder.my_atom)
	location.visible_message("<span class='danger'>The solution spews out a metallic foam!</span>")
	var/datum/effect_system/foam_spread/metal/s = new()
	s.set_up(multiplier*5, location, holder, 1)
	s.start()
	holder.clear_reagents()

/datum/chemical_reaction/smart_foam
	name = "Smart Metal Foam"
	id = "smart_metal_foam"
	required_reagents = list(/datum/reagent/aluminium = 3, /datum/reagent/smart_foaming_agent = 1, /datum/reagent/toxin/acid/fluacid = 1)
	mob_react = TRUE

/datum/chemical_reaction/smart_foam/on_reaction(datum/reagents/holder, multiplier)
	var/turf/location = get_turf(holder.my_atom)
	location.visible_message("<span class='danger'>The solution spews out metallic foam!</span>")
	var/datum/effect_system/foam_spread/metal/smart/s = new()
	s.set_up(multiplier * 5, location, holder, TRUE)
	s.start()
	holder.clear_reagents()

/datum/chemical_reaction/ironfoam
	name = "Iron Foam"
	id = "ironlfoam"
	required_reagents = list(/datum/reagent/iron = 3, /datum/reagent/foaming_agent = 1, /datum/reagent/toxin/acid/fluacid = 1)
	mob_react = FALSE

/datum/chemical_reaction/ironfoam/on_reaction(datum/reagents/holder, multiplier)
	var/turf/location = get_turf(holder.my_atom)
	location.visible_message("<span class='danger'>The solution spews out metallic foam!</span>")
	var/datum/effect_system/foam_spread/metal/s = new()
	s.set_up(multiplier*5, location, holder, 2)
	s.start()
	holder.clear_reagents()

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	id = /datum/reagent/foaming_agent
	results = list(/datum/reagent/foaming_agent = 1)
	required_reagents = list(/datum/reagent/lithium = 1, /datum/reagent/hydrogen = 1)

/datum/chemical_reaction/smart_foaming_agent
	name = "Smart foaming Agent"
	id = /datum/reagent/smart_foaming_agent
	results = list(/datum/reagent/smart_foaming_agent = 3)
	required_reagents = list(/datum/reagent/foaming_agent = 3, /datum/reagent/acetone = 1, /datum/reagent/iron = 1)
	mix_message = "The solution mixes into a frothy metal foam and conforms to the walls of its container."


/////////////////////////////// Cleaning and hydroponics /////////////////////////////////////////////////

/datum/chemical_reaction/ammonia
	name = "Ammonia"
	id = /datum/reagent/ammonia
	results = list(/datum/reagent/ammonia = 3)
	required_reagents = list(/datum/reagent/hydrogen = 3, /datum/reagent/nitrogen = 1)

/datum/chemical_reaction/diethylamine
	name = "Diethylamine"
	id = /datum/reagent/diethylamine
	results = list(/datum/reagent/diethylamine = 2)
	required_reagents = list (/datum/reagent/ammonia = 1, /datum/reagent/consumable/ethanol = 1)

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	id = /datum/reagent/space_cleaner
	results = list(/datum/reagent/space_cleaner = 2)
	required_reagents = list(/datum/reagent/ammonia = 1, /datum/reagent/water = 1)

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	id = /datum/reagent/toxin/plantbgone
	results = list(/datum/reagent/toxin/plantbgone = 5)
	required_reagents = list(/datum/reagent/toxin = 1, /datum/reagent/water = 4)

/datum/chemical_reaction/weedkiller
	name = "Weed Killer"
	id = /datum/reagent/toxin/plantbgone/weedkiller
	results = list(/datum/reagent/toxin/plantbgone/weedkiller = 5)
	required_reagents = list(/datum/reagent/toxin = 1, /datum/reagent/ammonia = 4)

/datum/chemical_reaction/pestkiller
	name = "Pest Killer"
	id = /datum/reagent/toxin/pestkiller
	results = list(/datum/reagent/toxin/pestkiller = 5)
	required_reagents = list(/datum/reagent/toxin = 1, /datum/reagent/consumable/ethanol = 4)

/datum/chemical_reaction/drying_agent
	name = "Drying agent"
	id = /datum/reagent/drying_agent
	results = list(/datum/reagent/drying_agent = 3)
	required_reagents = list(/datum/reagent/stable_plasma = 2, /datum/reagent/consumable/ethanol = 1, /datum/reagent/sodium = 1)

//////////////////////////////////// Other goon stuff ///////////////////////////////////////////

/datum/chemical_reaction/acetone
	name = "acetone"
	id = /datum/reagent/acetone
	results = list(/datum/reagent/acetone = 3)
	required_reagents = list(/datum/reagent/oil = 1, /datum/reagent/fuel = 1, /datum/reagent/oxygen = 1)

/datum/chemical_reaction/oil
	name = "Oil"
	id = /datum/reagent/oil
	results = list(/datum/reagent/oil = 3)
	required_reagents = list(/datum/reagent/fuel = 1, /datum/reagent/carbon = 1, /datum/reagent/hydrogen = 1)

/datum/chemical_reaction/phenol
	name = "phenol"
	id = /datum/reagent/phenol
	results = list(/datum/reagent/phenol = 3)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/chlorine = 1, /datum/reagent/oil = 1)

/datum/chemical_reaction/ash
	name = "Ash"
	id = /datum/reagent/ash
	results = list(/datum/reagent/ash = 1)
	required_reagents = list(/datum/reagent/oil = 1)
	required_temp = 480

/datum/chemical_reaction/colorful_reagent
	name = "colorful_reagent"
	id = /datum/reagent/colorful_reagent
	results = list(/datum/reagent/colorful_reagent = 5)
	required_reagents = list(/datum/reagent/stable_plasma = 1, /datum/reagent/radium = 1, /datum/reagent/drug/space_drugs = 1, /datum/reagent/medicine/cryoxadone = 1, /datum/reagent/consumable/triple_citrus = 1)

/datum/chemical_reaction/life
	name = "Life"
	id = "life"
	required_reagents = list(/datum/reagent/medicine/strange_reagent = 1, /datum/reagent/medicine/synthflesh = 1, /datum/reagent/blood = 1)
	required_temp = 374

/datum/chemical_reaction/life/on_reaction(datum/reagents/holder, multiplier)
	chemical_mob_spawn(holder, rand(1, round(multiplier, 1)), "Life") // Lol.

//This is missing, I'm adding it back (see tgwiki). Not sure why we don't have it.
/datum/chemical_reaction/life_friendly
	name = "Life (Friendly)"
	id = "life_friendly"
	required_reagents = list(/datum/reagent/medicine/strange_reagent = 1, /datum/reagent/medicine/synthflesh = 1, /datum/reagent/consumable/sugar = 1)
	required_temp = 374

/datum/chemical_reaction/life_friendly/on_reaction(datum/reagents/holder, multiplier)
	chemical_mob_spawn(holder, rand(1, round(multiplier, 1)), "Life (friendly)", FRIENDLY_SPAWN) //Pray for cute cats

/datum/chemical_reaction/corgium
	name = "corgium"
	id = "corgium"
	required_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/colorful_reagent = 1, /datum/reagent/medicine/strange_reagent = 1, /datum/reagent/blood = 1)
	required_temp = 374

/datum/chemical_reaction/corgium/on_reaction(datum/reagents/holder, multiplier)
	var/location = get_turf(holder.my_atom)
	for(var/i = rand(1, multiplier), i <= multiplier, i++) // More lulz.
		new /mob/living/simple_animal/pet/dog/corgi(location)
	..()

/datum/chemical_reaction/hair_dye
	name = "hair_dye"
	id = /datum/reagent/hair_dye
	results = list(/datum/reagent/hair_dye = 5)
	required_reagents = list(/datum/reagent/colorful_reagent = 1, /datum/reagent/radium = 1, /datum/reagent/drug/space_drugs = 1)

/datum/chemical_reaction/barbers_aid
	name = "barbers_aid"
	id = /datum/reagent/barbers_aid
	results = list(/datum/reagent/barbers_aid = 5)
	required_reagents = list(/datum/reagent/carpet = 1, /datum/reagent/radium = 1, /datum/reagent/drug/space_drugs = 1)

/datum/chemical_reaction/concentrated_barbers_aid
	name = "concentrated_barbers_aid"
	id = /datum/reagent/concentrated_barbers_aid
	results = list(/datum/reagent/concentrated_barbers_aid = 2)
	required_reagents = list(/datum/reagent/barbers_aid = 1, /datum/reagent/toxin/mutagen = 1)

/datum/chemical_reaction/saltpetre
	name = "saltpetre"
	id = /datum/reagent/saltpetre
	results = list(/datum/reagent/saltpetre = 3)
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/nitrogen = 1, /datum/reagent/oxygen = 3)

/datum/chemical_reaction/lye
	name = "lye"
	id = /datum/reagent/lye
	results = list(/datum/reagent/lye = 3)
	required_reagents = list(/datum/reagent/sodium = 1, /datum/reagent/hydrogen = 1, /datum/reagent/oxygen = 1)

/datum/chemical_reaction/lye2
	name = "lye"
	id = "lye2"
	results = list(/datum/reagent/lye = 2)
	required_reagents = list(/datum/reagent/ash = 1, /datum/reagent/water = 1, /datum/reagent/carbon = 1)

/datum/chemical_reaction/royal_bee_jelly
	name = "royal bee jelly"
	id = /datum/reagent/royal_bee_jelly
	results = list(/datum/reagent/royal_bee_jelly = 5)
	required_reagents = list(/datum/reagent/toxin/mutagen = 10, /datum/reagent/consumable/honey = 40)

/datum/chemical_reaction/laughter
	name = "laughter"
	id = /datum/reagent/consumable/laughter
	results = list(/datum/reagent/consumable/laughter = 10) // Fuck it. I'm not touching this one.
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/consumable/banana = 1)

/datum/chemical_reaction/plastic_polymers
	name = "plastic polymers"
	id = "plastic_polymers"
	required_reagents = list(/datum/reagent/oil = 5, /datum/reagent/toxin/acid = 2, /datum/reagent/ash = 3)
	required_temp = 374 //lazily consistent with soap & other crafted objects generically created with heat.

/datum/chemical_reaction/plastic_polymers/on_reaction(datum/reagents/holder, multiplier)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to multiplier)
		new /obj/item/stack/sheet/plastic(location)

/datum/chemical_reaction/pax
	name = "pax"
	id = /datum/reagent/pax
	results = list(/datum/reagent/pax = 3)
	required_reagents  = list(/datum/reagent/toxin/mindbreaker = 1, /datum/reagent/medicine/synaptizine = 1, /datum/reagent/water = 1)

/datum/chemical_reaction/cat
	name = "felined mutation toxic"
	id = /datum/reagent/mutationtoxin/felinid
	results = list(/datum/reagent/mutationtoxin/felinid = 1)
	required_reagents  = list(/datum/reagent/toxin/mindbreaker = 1, /datum/reagent/ammonia = 1, /datum/reagent/water = 1, /datum/reagent/drug/aphrodisiac = 10, /datum/reagent/mutationtoxin = 1) // Maybe aphro+ if it becomes a shitty meme
	required_temp = 450

/datum/chemical_reaction/moff
	name = "insect mutation toxic"
	id = /datum/reagent/mutationtoxin/insect
	results = list(/datum/reagent/mutationtoxin/insect = 1)
	required_reagents  = list(/datum/reagent/liquid_dark_matter = 2, /datum/reagent/ammonia = 5, /datum/reagent/lithium = 1, /datum/reagent/mutationtoxin = 1)
	required_temp = 320

/datum/chemical_reaction/notlight //Harder to make do to it being a hard race to play
	name = "shadow muatatuin toxic"
	id = /datum/reagent/mutationtoxin/shadow
	results = list(/datum/reagent/mutationtoxin/shadow = 1)
	required_reagents  = list(/datum/reagent/liquid_dark_matter = 5, /datum/reagent/medicine/synaptizine = 10, /datum/reagent/medicine/oculine = 10, /datum/reagent/mutationtoxin = 1)
	required_temp = 600

// Liquid Carpets

/datum/chemical_reaction/carpet
	name = "carpet"
	id = /datum/reagent/carpet
	results = list(/datum/reagent/carpet = 2)
	required_reagents = list(/datum/reagent/drug/space_drugs = 1, /datum/reagent/blood = 1)

/datum/chemical_reaction/carpet/black
	name = "liquid black carpet"
	id = /datum/reagent/carpet/black
	results = list(/datum/reagent/carpet/black = 2)
	required_reagents = list(/datum/reagent/carpet = 1, /datum/reagent/carbon = 1)

/datum/chemical_reaction/carpet/blackred
	name = "liquid red black carpet"
	id = /datum/reagent/carpet/blackred
	results = list(/datum/reagent/carpet/blackred = 2)
	required_reagents = list(/datum/reagent/carpet = 1, /datum/reagent/medicine/charcoal = 1)

/datum/chemical_reaction/carpet/monochrome
	name = "liquid monochrome carpet"
	id = /datum/reagent/carpet/monochrome
	results = list(/datum/reagent/carpet/monochrome = 2)
	required_reagents = list(/datum/reagent/carpet = 1, /datum/reagent/oil = 1)

/datum/chemical_reaction/carpet/blue
	name = "liquid blue carpet"
	id = /datum/reagent/carpet/blue
	results = list(/datum/reagent/carpet/blue = 2)
	required_reagents = list(/datum/reagent/carpet = 1, /datum/reagent/consumable/tonic = 1)

/datum/chemical_reaction/carpet/cyan
	name = "liquid cyan carpet"
	id = /datum/reagent/carpet/cyan
	results = list(/datum/reagent/carpet/cyan = 2)
	required_reagents = list(/datum/reagent/carpet = 1, /datum/reagent/consumable/ice = 1)

/datum/chemical_reaction/carpet/green
	name = "liquid green carpet"
	id = /datum/reagent/carpet/green
	results = list(/datum/reagent/carpet/green = 2)
	required_reagents = list(/datum/reagent/carpet = 1, /datum/reagent/toxin/acid = 1)

/datum/chemical_reaction/carpet/orange
	name = "liquid orange carpet"
	id = /datum/reagent/carpet/orange
	results = list(/datum/reagent/carpet/orange = 2)
	required_reagents = list(/datum/reagent/carpet = 1, /datum/reagent/consumable/orangejuice = 1)

/datum/chemical_reaction/carpet/purple
	name = "liquid purple carpet"
	id = /datum/reagent/carpet/purple
	results = list(/datum/reagent/carpet/purple = 2)
	required_reagents = list(/datum/reagent/carpet = 1, /datum/reagent/stable_plasma = 1)

/datum/chemical_reaction/carpet/red
	name = "liquid red carpet"
	id = /datum/reagent/carpet/red
	results = list(/datum/reagent/carpet/red = 2)
	required_reagents = list(/datum/reagent/carpet = 1, /datum/reagent/fuel = 1)

/datum/chemical_reaction/carpet/royalblack
	name = "liquid royal black carpet"
	id = /datum/reagent/carpet/royalblack
	results = list(/datum/reagent/carpet/royalblack = 2)
	required_reagents = list(/datum/reagent/carpet = 1, /datum/reagent/consumable/blackpepper = 1)

/datum/chemical_reaction/carpet/royalblue
	name = "liquid royal blue carpet"
	id = /datum/reagent/carpet/royalblue
	results = list(/datum/reagent/carpet/royalblue = 2)
	required_reagents = list(/datum/reagent/carpet = 1, /datum/reagent/medicine/clonexadone = 1)

//////////////////////////////////// Glitter ///////////////////////////////////////////

/datum/chemical_reaction/white_glitter/blue
	name = "white glitter from blue"
	id = "white_glitter_blue"
	results = list(/datum/reagent/glitter/white = 2)
	required_reagents = list(/datum/reagent/glitter/blue = 1, /datum/reagent/colorful_reagent/crayonpowder/white = 1)

/datum/chemical_reaction/white_glitter/pink
	name = "white glitter from pink"
	id = "white_glitter_pink"
	results = list(/datum/reagent/glitter/white = 2)
	required_reagents = list(/datum/reagent/glitter/pink = 1, /datum/reagent/colorful_reagent/crayonpowder/white = 1)

/datum/chemical_reaction/pink_glitter/blue
	name = "pink glitter from blue"
	id = "pink_glitter_blue"
	results = list(/datum/reagent/glitter/pink = 2)
	required_reagents = list(/datum/reagent/glitter/blue = 1, /datum/reagent/colorful_reagent/crayonpowder/red = 1)

/datum/chemical_reaction/pink_glitter/white
	name = "pink glitter from white"
	id = "pink_glitter_white"
	results = list(/datum/reagent/glitter/pink = 2)
	required_reagents = list(/datum/reagent/glitter/white = 1, /datum/reagent/colorful_reagent/crayonpowder/red = 1)

/datum/chemical_reaction/blue_glitter/pink
	name = "blue glitter from pink"
	id = "blue_glitter_pink"
	results = list(/datum/reagent/glitter/blue = 2)
	required_reagents = list(/datum/reagent/glitter/pink = 1, /datum/reagent/colorful_reagent/crayonpowder/blue = 1)

/datum/chemical_reaction/blue_glitter/white
	name = "blue glitter from white"
	id = "blue_glitter_white"
	results = list(/datum/reagent/glitter/blue  = 2)
	required_reagents = list(/datum/reagent/glitter/white = 1, /datum/reagent/colorful_reagent/crayonpowder/blue = 1)

//////////////////////////////////// Synthblood ///////////////////////////////////////////

/datum/chemical_reaction/synth_blood
	name = "Synthetic Blood"
	id = /datum/reagent/blood/synthetics
	results = list(/datum/reagent/blood/synthetics = 3)
	required_reagents = list(/datum/reagent/medicine/salglu_solution = 1, /datum/reagent/iron = 1, /datum/reagent/stable_plasma = 1)
	mix_message = "The mixture congeals and gives off a faint copper scent."
	required_temp = 350
