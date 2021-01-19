/obj/item/stack/sheet/plasteel/cyborg
	custom_materials = null
	//var/datum/robot_energy_storage/metsource
	//var/datum/robot_energy_storage/plasource
	//var/metcost = 250
	//var/placost = 250
	cost = 500
	is_cyborg = 1
/* Commented out to pick up shit
/obj/item/stack/sheet/plasteel/cyborg/get_amount()
	return min(round(source.energy / metcost), round(plasource.energy / placost))

/obj/item/stack/sheet/plasteel/cyborg/use(used, transfer = FALSE) // Requires special checks, because it uses two storages
	source.use_charge(used * metcost)
	plasource.use_charge(used * placost)

/obj/item/stack/sheet/plasteel/cyborg/add(amount)
	source.add_charge(amount * metcost)
	plasource.add_charge(amount * placost)
*/

/obj/item/stack/sheet/mineral/wood
	name = "wooden plank"
	desc = "One can only guess that this is a bunch of wood. You might be able to make a stake with this if you use something sharp on it"
	singular_name = "wood plank"
	icon_state = "sheet-wood"
	item_state = "sheet-wood"
	icon = 'icons/obj/stack_objects.dmi'
	sheettype = "wood"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 0)
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/sheet/mineral/wood
	novariants = TRUE
	grind_results = list(/datum/reagent/cellulose = 20)
