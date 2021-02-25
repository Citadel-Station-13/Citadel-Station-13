// the special spraycan that allows the use of this antag's abilities
/obj/item/toy/crayon/spraycan/antag
	name = "spraycan of life"
	desc = "A spraycan containing the raw essence of life mixed in with some paint."
	charges = -1 // it has its own mechanic for keeping track of if it can be used

	//lists of drawings that can be made, keys are item name, values are paint cost
	var/static/list/creatures = list("stickman" = 1, "carp" = 1)
	var/static/list/creature_to_path = list("stickman" = /mob/living/simple_animal/hostile/stickman, "carp" = /mob/living/simple_animal/hostile/carp)

/obj/item/toy/crayon/spraycan/antag/check_empty()
	// do a cooldown check here and an antag paint-amount check
	return FALSE

// swap the drawing out for the antag version
/obj/item/toy/crayon/spraycan/antag/create_normal_drawing(mob/user, clickx, clicky, atom/target, paint_color, drawing, temp, graf_rot)
	// first categorise the drawing to determine what we want to do

	// category 1: mobs, these
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

// generate the different ui by returning different drawables
/obj/item/toy/crayon/spraycan/antag/staticDrawables()
	. = list()

	var/list/g_items = list()
	. += list(list("name" = "Creatures", "items" = g_items))
	for(var/g in creatures)
		g_items += list(list("item" = g))
