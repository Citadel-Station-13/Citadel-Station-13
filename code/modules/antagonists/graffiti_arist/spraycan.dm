// the special spraycan that allows the use of this antag's abilities
/obj/item/toy/crayon/spraycan/antag
	name = "spraycan of life"
	desc = "A spraycan containing the raw essence of life mixed in with some paint."
	charges = -1 // it has its own mechanic for keeping track of if it can be used

	//lists of drawings that can be made, keys are item name, values are paint cost
	var/static/list/creatures = list("stickman" = 10, "carp" = 25)
	var/static/list/creature_to_path = list("stickman" = /mob/living/simple_animal/hostile/stickman, "carp" = /mob/living/simple_animal/hostile/carp)

	var/static/list/traps = list("arrow" = 5)

	var/static/list/all_special_drawings = creatures

// to use it, you need to be an antag, otherwise it displays as being empty
/obj/item/toy/crayon/spraycan/antag/check_empty(mob/user)
	if(user.mind?.has_antag_datum(/datum/antagonist/graffiti_artist))
		return FALSE
	to_chat(user, "The can seems empty.")
	return TRUE

// swap the drawing out for the antag version
/obj/item/toy/crayon/spraycan/antag/create_normal_drawing(mob/user, clickx, clicky, atom/target, paint_color, drawing, temp, graf_rot)
	// make sure enough paint exists for what you wish to create
	var/paint_cost = all_special_drawings[drawing]
	var/datum/antagonist/graffiti_artist/artist = user.mind.has_antag_datum(/datum/antagonist/graffiti_artist)
	if(artist.paint_amount >= paint_cost)
		artist.paint_amount -= paint_cost
	else
		return FALSE // cancels the operation

	// categorise the drawing to determine what we want to do

	// category 1: mobs
	if(drawing in creatures)
		var/mob_path = creature_to_path[drawing]
		var/mob/living/simple_animal/drawn_creature = new mob_path(target)
		drawn_creature.icon = 'icons/effects/crayondecal.dmi'
		drawn_creature.icon_state = "[drawing]_mob"
		drawn_creature.icon_dead = "[drawing]_mob_dead"
		drawn_creature.icon_gib = null
		drawn_creature.name = "graffiti [drawn_creature.name]"
		drawn_creature.desc = "A creature made from paint. How is this even possible?!"
		drawn_creature.faction += "\[[user.tag]\]" // so they don't attack the user
		drawn_creature.add_atom_colour(paint_color, FIXED_COLOUR_PRIORITY)

	// category 2: traps, placed like decals but they have effects when stood on
	if(drawing in traps)
		var/decal_path = text2path("/obj/effect/decal/cleanable/crayon/special/[drawing]")
		new decal_path(target, paint_color, drawing, temp, graf_rot)

// generate the different ui by returning different drawables
/obj/item/toy/crayon/spraycan/antag/staticDrawables()
	. = list()

	var/list/creature_items = list()
	. += list(list("name" = "Creatures", "items" = creature_items))
	for(var/c in creatures)
		creature_items += list(list("item" = c))

	var/list/trap_items = list()
	. += list(list("name" = "Traps", "items" = trap_items))
	for(var/trap in traps)
		trap_items += list(list("item" = trap))
