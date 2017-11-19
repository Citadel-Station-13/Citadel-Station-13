/*
Protolathe

Similar to an autolathe, you load glass and metal sheets (but not other objects) into it to be used as raw materials for the stuff
it creates. All the menus and other manipulation commands are in the R&D console.

Note: Must be placed west/left of and R&D console to function.

*/
/obj/machinery/rnd/protolathe
	name = "protolathe"
	desc = "Converts raw materials into useful objects."
	icon_state = "protolathe"
	container_type = OPENCONTAINER_1
	circuit = /obj/item/circuitboard/machine/protolathe

	var/efficiency_coeff
	var/console_link = TRUE		//allow console link.
	var/requires_console = TRUE
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

	var/datum/component/material_container/materials			//Store for hyper speed!

/obj/machinery/rnd/protolathe/Initialize()
	create_reagents(0)
	materials = AddComponent(/datum/component/material_container,
		list(MAT_METAL, MAT_GLASS, MAT_SILVER, MAT_GOLD, MAT_DIAMOND, MAT_PLASMA, MAT_URANIUM, MAT_BANANIUM, MAT_TITANIUM, MAT_BLUESPACE),
		FALSE, list(/obj/item/stack, /obj/item/ore/bluespace_crystal), CALLBACK(src, .proc/is_insertion_ready))
	materials.precise_insertion = TRUE
	return ..()

/obj/machinery/rnd/protolathe/RefreshParts()
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

/obj/machinery/rnd/protolathe/proc/check_mat(datum/design/being_built, M)	// now returns how many times the item can be built with the material
	var/list/all_materials = being_built.reagents_list + being_built.materials

	GET_COMPONENT(materials, /datum/component/material_container)
	var/A = materials.amount(M)
	if(!A)
		A = reagents.get_reagent_amount(M)

	return round(A / max(1, (all_materials[M]*efficiency_coeff)))

//we eject the materials upon deconstruction.
/obj/machinery/rnd/protolathe/on_deconstruction()
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		reagents.trans_to(G, G.reagents.maximum_volume)
	GET_COMPONENT(materials, /datum/component/material_container)
	materials.retrieve_all()
	..()


/obj/machinery/rnd/protolathe/disconnect_console()
	linked_console.linked_lathe = null
	..()

/obj/machinery/rnd/protolathe/ComponentActivated(datum/component/C)
	..()
	if(istype(C, /datum/component/material_container))
		var/datum/component/material_container/M = C
		if(!M.last_insert_success)
			return
		var/lit = M.last_inserted_type
		var/stack_name
		if(ispath(lit, /obj/item/ore/bluespace_crystal))
			stack_name = "bluespace"
			use_power(MINERAL_MATERIAL_AMOUNT / 10)
		else
			var/obj/item/stack/S = lit
			stack_name = initial(S.name)
			use_power(max(1000, (MINERAL_MATERIAL_AMOUNT * M.last_amount_inserted / 10)))
		add_overlay("protolathe_[stack_name]")
		addtimer(CALLBACK(src, /atom/proc/cut_overlay, "protolathe_[stack_name]"), 10)

/obj/machinery/rnd/protolathe/proc/user_try_print_id(id, amount)
	if((!istype(linked_console) && requires_console) || !id)
		return FALSE
	if(istext(amount))
		amount = text2num(amount)
	if(isnull(amount))
		amount = 1
	var/datum/design/D = (linked_console || requires_console)? linked_console.stored_research.researched_designs[id] : get_techweb_design_by_id(id)
	if(!istype(D))
		return FALSE
	if(D.make_reagents.len)
		return FALSE

	var/power = 1000
	amount = Clamp(amount, 1, 10)
	for(var/M in D.materials)
		power += round(D.materials[M] * amount / 5)
	power = max(3000, power)
	use_power(power)

	var/list/efficient_mats = list()
	for(var/MAT in D.materials)
		efficient_mats[MAT] = D.materials[MAT]*efficiency_coeff

	if(!materials.has_materials(efficient_mats, amount))
		say("Not enough materials to complete prototype[amount > 1? "s" : ""].")
		return FALSE
	for(var/R in D.reagents_list)
		if(!reagents.has_reagent(R, D.reagents_list[R]*efficiency_coeff))
			say("Not enough reagents to complete prototype[amount > 1? "s" : ""].")
			return FALSE

	materials.use_amount(efficient_mats, amount)
	for(var/R in D.reagents_list)
		reagents.remove_reagent(R, D.reagents_list[R]*efficiency_coeff)

	busy = TRUE
	flick("protolathe_n", src)
	var/timecoeff = efficiency_coeff * D.lathe_time_factor

	addtimer(CALLBACK(src, .proc/reset_busy), (32 * timecoeff * amount) ** 0.8)
	addtimer(CALLBACK(src, .proc/do_print, D.build_path, amount, efficient_mats, D.dangerous_construction), (32 * timecoeff * amount) ** 0.8)
	return TRUE

/obj/machinery/rnd/protolathe/proc/do_print(path, amount, list/matlist, notify_admins)
	if(notify_admins)
		if(usr)
			usr.investigate_log("built [amount] of [path] at a protolathe.", INVESTIGATE_RESEARCH)
			var/turf/T = get_turf(usr)
			message_admins("[key_name(usr)][ADMIN_JMP(T)] has built [amount] of [path] at a protolathe at [COORD(usr)]")
	for(var/i in 1 to amount)
		var/obj/item/I = new path(get_turf(src))
		if(!istype(I, /obj/item/stack/sheet) && !istype(I, /obj/item/ore/bluespace_crystal))
			I.materials = matlist.Copy()
	SSblackbox.record_feedback("nested_tally", "item_printed", amount, list("[type]", "[path]"))
