/*
Protolathe

Similar to an autolathe, you load glass and metal sheets (but not other objects) into it to be used as raw materials for the stuff
it creates. All the menus and other manipulation commands are in the R&D console.

Note: Must be placed west/left of and R&D console to function.

*/
/obj/machinery/r_n_d/protolathe
	name = "protolathe"
	desc = "Converts raw materials into useful objects."
	icon_state = "protolathe"
	container_type = OPENCONTAINER_1
	circuit = /obj/item/circuitboard/machine/protolathe

	var/efficiency_coeff

	var/list/categories = list(
								"Power Designs",
								"Medical Designs",
								"Bluespace Designs",
								"Stock Parts",
								"Equipment",
								"Mining Designs",
								"Electronics",
								"Weapons",
								"Ammo",
								"Firing Pins",
								"Computer Parts"
								)


/obj/machinery/r_n_d/protolathe/Initialize()
	create_reagents(0)
<<<<<<< HEAD
	var/datum/component/material_container/materials = AddComponent(/datum/component/material_container,
		list(MAT_METAL, MAT_GLASS, MAT_SILVER, MAT_GOLD, MAT_DIAMOND, MAT_PLASMA, MAT_URANIUM, MAT_BANANIUM, MAT_TITANIUM, MAT_BLUESPACE),
=======
	materials = AddComponent(/datum/component/material_container,
		list(MAT_METAL, MAT_GLASS, MAT_SILVER, MAT_GOLD, MAT_DIAMOND, MAT_PLASMA, MAT_URANIUM, MAT_BANANIUM, MAT_TITANIUM, MAT_BLUESPACE), 0,
>>>>>>> 09ec914... Fixes certain material containers (#33370)
		FALSE, list(/obj/item/stack, /obj/item/ore/bluespace_crystal), CALLBACK(src, .proc/is_insertion_ready), CALLBACK(src, .proc/AfterMaterialInsert))
	materials.precise_insertion = TRUE
	return ..()

/obj/machinery/r_n_d/protolathe/RefreshParts()
	reagents.maximum_volume = 0
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		reagents.maximum_volume += G.volume
		G.reagents.trans_to(src, G.reagents.total_volume)

	GET_COMPONENT(materials, /datum/component/material_container)
	materials.max_amount = 0
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		materials.max_amount += M.rating * 75000

	var/T = 1.2
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		T -= M.rating/10
	efficiency_coeff = min(max(0, T), 1)

/obj/machinery/r_n_d/protolathe/proc/check_mat(datum/design/being_built, M)	// now returns how many times the item can be built with the material
	var/list/all_materials = being_built.reagents_list + being_built.materials

	GET_COMPONENT(materials, /datum/component/material_container)
	var/A = materials.amount(M)
	if(!A)
		A = reagents.get_reagent_amount(M)

	return round(A / max(1, (all_materials[M]*efficiency_coeff)))

//we eject the materials upon deconstruction.
/obj/machinery/r_n_d/protolathe/on_deconstruction()
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		reagents.trans_to(G, G.reagents.maximum_volume)
	GET_COMPONENT(materials, /datum/component/material_container)
	materials.retrieve_all()
	..()


/obj/machinery/r_n_d/protolathe/disconnect_console()
	linked_console.linked_lathe = null
	..()
