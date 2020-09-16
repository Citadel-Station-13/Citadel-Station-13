/obj/item/stack/sheet/plasmaglass/cyborg
	custom_materials = null
	//var/datum/robot_energy_storage/glasource
	//var/datum/robot_energy_storage/plasource
	//var/glacost = 250
	//var/placost = 250
	cost = 500
	is_cyborg = 1
/* commented out to pick shit up
/obj/item/stack/sheet/plasmaglass/cyborg/get_amount()
	return min(round(plasource.energy / placost), round(glasource.energy / glacost))

/obj/item/stack/sheet/plasmaglass/cyborg/use(used, transfer = FALSE) // Requires special checks, because it uses two storages
	plasource.use_charge(used * placost)
	glasource.use_charge(used * glacost)

/obj/item/stack/sheet/plasmaglass/cyborg/add(amount)
	plasource.add_charge(amount * placost)
	glasource.add_charge(amount * glacost)
*/
/obj/item/stack/sheet/plasmarglass/cyborg
	custom_materials = null
	//var/datum/robot_energy_storage/glasource
	//var/datum/robot_energy_storage/plasource
	//var/glacost = 500
	//var/placost = 500
	cost = 1000
	is_cyborg = 1
/* commented out to pick shit up
/obj/item/stack/sheet/plasmarglass/cyborg/get_amount()
	return min(round(glasource.energy / glacost), round(plasource.energy / placost))

/obj/item/stack/sheet/plasmarglass/cyborg/use(used, transfer = FALSE) // Requires special checks, because it uses two storages
	glasource.use_charge(used * glacost)
	plasource.use_charge(used * placost)

/obj/item/stack/sheet/plasmarglass/cyborg/add(amount)
	glasource.add_charge(amount * glacost)
	plasource.add_charge(amount * placost)
*/
