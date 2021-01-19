/datum/chemical_reaction/silicon_dioxide
	name = "silicon dioxide"
	id = "silicon_dioxide"
	required_reagents = list(/datum/reagent/silicon = 5, /datum/reagent/oxygen = 10)//kinda handy
	required_temp = 450

/datum/chemical_reaction/silicon_dioxide/on_reaction(datum/reagents/holder, multiplier)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to multiplier)
		new /obj/item/stack/ore/glass(location)

/datum/chemical_reaction/rought_iron
	name = "rought iron"
	id = "rought iron"
	required_reagents = list(/datum/reagent/iron = 50, /datum/reagent/carbon = 1)
	required_temp = 900 //time wasterd

/datum/chemical_reaction/rought_iron/on_reaction(datum/reagents/holder, multiplier)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to multiplier)
		new /obj/item/stack/ore/iron(location)

/datum/chemical_reaction/anomaly
	name = "flux anomaly"
	id = "flux_anomaly"
	required_reagents = list(/datum/reagent/bluespace = 60, /datum/reagent/teslium/energized_jelly = 5)
	required_temp = 400
	mix_message = "The mixture starts solidifying and then floats out of it's container."

/datum/chemical_reaction/anomaly/gravity
	name = "gravity anomaly"
	id = "gravity_anomaly"
	required_reagents = list(/datum/reagent/bluespace = 60, /datum/reagent/liquid_dark_matter = 5)

/datum/chemical_reaction/anomaly/bluespace
	name = "bluespace anomaly"
	id = "bluespace_anomaly"
	required_reagents = list(/datum/reagent/bluespace = 80)
	required_temp = 600

/datum/chemical_reaction/anomaly/pyro
	name = "pyro anomaly"
	id = "pyro_anomaly"
	required_reagents = list(/datum/reagent/bluespace = 60, /datum/reagent/napalm = 5)

/datum/chemical_reaction/anomaly/on_reaction(datum/reagents/holder, multiplier)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to multiplier)
		switch(id)
			if("gravity_anomaly")
				new /obj/effect/anomaly/grav(location)
			if("flux_anomaly")
				new /obj/effect/anomaly/flux(location)
			if("bluespace_anomaly")
				new /obj/effect/anomaly/bluespace(location)
			if("pyro_anomaly")
				new /obj/effect/anomaly/pyro(location)
