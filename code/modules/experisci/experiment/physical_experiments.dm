/datum/experiment/physical/meat_wall_explosion
	name = "Extreme Cooking Experiment"
	description = "There has been interest in using our engineering equipment to see what kind of new cooking appliances we can create"

/datum/experiment/physical/meat_wall_explosion/register_events()
	if(!istype(currently_scanned_atom, /turf/closed/wall))
		linked_experiment_handler.announce_message("Incorrect object for experiment.")
		return FALSE

	if(!(/datum/material/meat in currently_scanned_atom.custom_materials))
		linked_experiment_handler.announce_message("Object is not made out of the correct materials.")
		return FALSE

	RegisterSignal(currently_scanned_atom, COMSIG_ATOM_BULLET_ACT, .proc/check_experiment)
	linked_experiment_handler.announce_message("Experiment ready to start.")
	return TRUE

/datum/experiment/physical/meat_wall_explosion/unregister_events()
	UnregisterSignal(currently_scanned_atom, COMSIG_ATOM_BULLET_ACT)

/datum/experiment/physical/meat_wall_explosion/check_progress()
	. += EXP_PROG_BOOL("Fire an emitter at a tracked meat wall", is_complete())

/datum/experiment/physical/meat_wall_explosion/proc/check_experiment(datum/source, obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/beam/emitter))
		finish_experiment(linked_experiment_handler)

/datum/experiment/physical/meat_wall_explosion/finish_experiment(datum/component/experiment_handler/experiment_handler)
	. = ..()
	new /obj/effect/gibspawner/generic(currently_scanned_atom)
	var/turf/meat_wall = currently_scanned_atom
	var/turf/new_turf = meat_wall.ScrapeAway()
	new /obj/effect/gibspawner/generic(new_turf)
	new /obj/item/reagent_containers/food/snacks/meat/steak(new_turf)

/datum/experiment/physical/arcade_winner
	name = "Playtesting Experiences"
	description = "How do they make these arcade games so fun? Let's play one and win it to find out."

/datum/experiment/physical/arcade_winner/register_events()
	if(!istype(currently_scanned_atom, /obj/machinery/computer/arcade))
		linked_experiment_handler.announce_message("Incorrect object for experiment.")
		return FALSE

	RegisterSignal(currently_scanned_atom, COMSIG_ARCADE_PRIZEVEND, .proc/win_arcade)
	linked_experiment_handler.announce_message("Experiment ready to start.")
	return TRUE

/datum/experiment/physical/arcade_winner/unregister_events()
	UnregisterSignal(currently_scanned_atom, COMSIG_ARCADE_PRIZEVEND)

/datum/experiment/physical/arcade_winner/check_progress()
	. += EXP_PROG_BOOL("Win an arcade game at a tracked arcade cabinet.", is_complete())

/datum/experiment/physical/arcade_winner/proc/win_arcade(datum/source)
	finish_experiment(linked_experiment_handler)

/datum/experiment/physical/bluespace_stuffing
	name = "Prototype Bluespace Storage"
	description = "What if we stuff a bunch of bluespace crystals into a bag, apply the magic of science to it and try to insert something really big?"

/datum/experiment/physical/bluespace_stuffing/register_events()
	if(istype(currently_scanned_atom, /obj/item/storage/backpack/holding) || !istype(currently_scanned_atom, /obj/item/storage/backpack)) //We don't need bags of holding being turned into prototype bluespace bags of holding
		linked_experiment_handler.announce_message("Incorrect object for experiment.")
		return FALSE

	if(!((locate(/obj/item/stack/sheet/bluespace_crystal) in currently_scanned_atom) || (locate(/obj/item/stack/ore/bluespace_crystal) in currently_scanned_atom)))
		linked_experiment_handler.announce_message("Object is not filled with required materials.")
		return FALSE

	RegisterSignal(currently_scanned_atom, COMSIG_TRY_STORAGE_INSERT, .proc/check_experiment)

	linked_experiment_handler.announce_message("Experiment ready to start.")
	return TRUE

/datum/experiment/physical/bluespace_stuffing/unregister_events()
	UnregisterSignal(currently_scanned_atom, COMSIG_TRY_STORAGE_INSERT)

/datum/experiment/physical/bluespace_stuffing/check_progress()
	. += EXP_PROG_BOOL("Put some bluespace crystals in the backpack, scan it and then try to insert something bulky in it. Remember to fill the bag to the brim before scanning!", is_complete())

/datum/experiment/physical/bluespace_stuffing/proc/check_experiment(datum/source, obj/item/I, mob/M, silent = FALSE, force = FALSE)
	if(!((/obj/item/stack/sheet/bluespace_crystal in currently_scanned_atom) || (/obj/item/stack/ore/bluespace_crystal in currently_scanned_atom)))
		return

	if(I.w_class >= WEIGHT_CLASS_BULKY) //Shrinks the bag's volume, but allows to store bigger items. A decent trade
		finish_experiment(linked_experiment_handler)

/datum/experiment/physical/bluespace_stuffing/finish_experiment(datum/component/experiment_handler/experiment_handler)
	. = ..()
	var/obj/item/storage/backpack/bag = currently_scanned_atom
	bag.name = "prototype bluespace [bag.name]"
	bag.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
	bag.add_atom_colour(COLOR_BLUE, FIXED_COLOUR_PRIORITY)
	var/datum/component/storage/STR = bag.GetComponent(/datum/component/storage)
	STR.max_w_class = MAX_WEIGHT_CLASS_BAG_OF_HOLDING
	STR.max_volume /= 2
