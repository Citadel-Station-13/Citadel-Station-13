/datum/chemical_reaction/cruderefine
	name = "Crude oil refining"
	id = "crudefine"
	results = list("asphalt" = 0.3, "fueloil" = 0.3, "diesel" = 0.2, "kerosene" = 0.1, "naphtha" = 0.05, "butane" = 0.05)
	required_reagents = list("crudeoil" = 5, "water" = "1" )
	mix_message = "the mixture splits into fractions."
	required_temp = 900
	required_container = /obj/machinery/plumbing/reaction_chamber

/datum/chemical_reaction/fermi/shalerefine
	name = "Shale oil refining"
	id = "shalefine"
	results = list("asphalt" = 0.35, "fueloil" = 0.35, "diesel" = 0.2, "kerosene" = 0.05, "naphtha" = 0.05)
	required_reagents = list("shaleoil" = 5, "water" = "1" )
	mix_message = "the mixture splits into fractions."
	required_temp = 950
	required_container = /obj/machinery/plumbing/reaction_chamber

/datum/chemical_reaction/fermi/sandrefine
	name = "Tar sand oil refining"
	id = "sandfine"
	results = list("asphalt" = 0.3, "fueloil" = 0.4, "diesel" = 0.3)
	required_reagents = list("lightsandoil" = 5, "water" = "1" )
	mix_message = "the mixture splits into fractions."
	required_temp = 1100
	required_container = /obj/machinery/plumbing/reaction_chamber

/datum/chemical_reaction/fermi/naphthagas
	name = "Naphtha isomerization"
	id = "naphthagas"
	results = list("gasoline" = 0.2, "naphtha" = 0.1)
	required_reagents = list("naphtha" = 0.5 )
	mix_message = "the mixture splits into fractions."
	required_temp = 662
	required_container = /obj/machinery/plumbing/reaction_chamber

/datum/chemical_reaction/tarlight
	name = "Tar Sand Lightening"
	id = "tarlight"
	results = list("lightsandoil" = 1)
	required_reagents = list("sandoil" = 2, "naphtha" = 0.1)

/datum/chemical_reaction/reagent_explosion/butane_explosion
	name = "Butane explosion"
	id = "butane_explosion"
	required_reagents = list("butane" = 1)
	required_temp = 672
	strengthdiv = 4 //half strength of nitro, i thinke
