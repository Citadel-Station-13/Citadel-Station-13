/datum/chemical_reaction/space_drugs
	name = "Space Drugs"
	id = "space_drugs"
	results = list("space_drugs" = 3)
	required_reagents = list("mercury" = 1, "sugar" = 1, "lithium" = 1)

/datum/chemical_reaction/crank
	name = "Crank"
	id = "crank"
	results = list("crank" = 5)
	required_reagents = list("diphenhydramine" = 1, "ammonia" = 1, "lithium" = 1, "sacid" = 1, "welding_fuel" = 1)
	mix_message = "The mixture violently reacts, leaving behind a few crystalline shards."
	required_temp = 390


/datum/chemical_reaction/krokodil
	name = "Krokodil"
	id = "krokodil"
	results = list("krokodil" = 6)
	required_reagents = list("diphenhydramine" = 1, "morphine" = 1, "cleaner" = 1, "potassium" = 1, "phosphorus" = 1, "welding_fuel" = 1)
	mix_message = "The mixture dries into a pale blue powder."
	required_temp = 380

/datum/chemical_reaction/methamphetamine
	name = "methamphetamine"
	id = "methamphetamine"
	results = list("methamphetamine" = 4)
	required_reagents = list("ephedrine" = 1, "iodine" = 1, "phosphorus" = 1, "hydrogen" = 1)
	required_temp = 374

/datum/chemical_reaction/bath_salts
	name = "bath_salts"
	id = "bath_salts"
	results = list("bath_salts" = 7)
	required_reagents = list("bad_food" = 1, "saltpetre" = 1, "nutriment" = 1, "cleaner" = 1, "enzyme" = 1, "tea" = 1, "mercury" = 1)
	required_temp = 374

/datum/chemical_reaction/aranesp
	name = "aranesp"
	id = "aranesp"
	results = list("aranesp" = 3)
	required_reagents = list("epinephrine" = 1, "atropine" = 1, "morphine" = 1)

/datum/chemical_reaction/happiness
	name = "Happiness"
	id = "happiness"
	results = list("happiness" = 4)
	required_reagents = list("nitrous_oxide" = 2, "epinephrine" = 1, "ethanol" = 1)
	required_catalysts = list("plasma" = 5)

/datum/chemical_reaction/skooma
	name = "skooma"
	id = "skooma"
	results = list("skooma" = 2, "moonshine" = 4, "sugar" = 4)
	required_temp = 280
	is_cold_recipe = TRUE
	required_reagents = list("moonsugar" = 10, "morphine" = 5)

/datum/chemical_reaction/skoomarevert
	name = "skoomarevert"
	id = "skoomarevert"
	results = list("moonsugar" = 1, "morphine" = 2.5)
	required_temp = 315 //a little above normal body temperature
	required_reagents = list("skooma" = 1)
