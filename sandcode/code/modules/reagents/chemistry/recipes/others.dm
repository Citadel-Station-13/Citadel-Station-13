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