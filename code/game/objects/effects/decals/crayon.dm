/obj/effect/decal/cleanable/crayon
	name = "rune"
	desc = "Graffiti. Damn kids."
	icon = 'icons/effects/crayondecal.dmi'
	icon_state = "rune1"
	plane = ABOVE_WALL_PLANE //makes the graffiti visible over a wall.
	gender = NEUTER
	persistent = TRUE
	persistence_allow_stacking = TRUE
	mergeable_decal = FALSE
	var/do_icon_rotate = TRUE
	var/rotation = 0
	var/paint_colour = "#FFFFFF"

/obj/effect/decal/cleanable/crayon/Initialize(mapload, main, type, e_name, graf_rot, alt_icon = null)
	. = ..()

	if(e_name)
		name = e_name
	desc = "A [name] vandalizing the station."
	if(alt_icon)
		icon = alt_icon
	if(type)
		icon_state = type
	if(graf_rot)
		rotation = graf_rot
	if(rotation && do_icon_rotate)
		var/matrix/M = matrix()
		M.Turn(rotation)
		src.transform = M
	if(main)
		paint_colour = main
	add_atom_colour(paint_colour, FIXED_COLOUR_PRIORITY)

/obj/effect/decal/cleanable/crayon/PersistenceSave(list/data)
	. = ..()
	if(icon != initial(icon))	// no support for alticons yet, awful system anyways
		return null
	data["icon_state"] = icon_state
	data["paint_color"] = paint_colour
	if(do_icon_rotate)
		data["rotation"] = rotation
	data["name"] = name
	if(pixel_x != initial(pixel_x))
		data["pixel_x"] = pixel_x
	if(pixel_y != initial(pixel_y))
		data["pixel_y"] = pixel_y

/obj/effect/decal/cleanable/crayon/PersistenceLoad(list/data)
	. = ..()
	if(data["name"])
		name = data["name"]
	if(do_icon_rotate && data["rotation"])
		var/matrix/M = matrix()
		M.Turn(text2num(data["rotation"]))
		transform = M
	if(data["paint_color"])
		paint_colour = data["paint_color"]
		add_atom_colour(paint_colour, FIXED_COLOUR_PRIORITY)
	if(data["icon_state"])
		icon_state = data["icon_state"]
	if(data["pixel_x"])
		pixel_x = data["pixel_x"]
	if(data["pixel_y"])
		pixel_y = data["pixel_y"]

// special crayon decals
/obj/effect/decal/cleanable/crayon/special
	persistent = FALSE

// the arrow throws things in the direction it's facing when stepped on
/obj/effect/decal/cleanable/crayon/special/arrow/Crossed(atom/movable/AM)
	. = ..()
	var/throw_dir
	switch(dir)
		if(NORTH)
			throw_dir = WEST
		if(EAST)
			throw_dir = NORTH
		if(SOUTH)
			throw_dir = EAST
		if(WEST)
			throw_dir = SOUTH
	var/atom/throw_target = get_edge_target_turf(AM, throw_dir)
	AM.throw_at(throw_target, 1 , 1)

// the splatter slips you, it's as strong as regular soap
/obj/effect/decal/cleanable/crayon/special/splatter/Initialize()
	. = ..()
	AddComponent(/datum/component/slippery, 80)

// the firedanger decal sets people on fire when they step on it
// can't adjust your firestacks past 5 though
/obj/effect/decal/cleanable/crayon/special/firedanger/Crossed(atom/movable/AM)
	if(iscarbon(AM))
		var/mob/living/carbon/C = AM
		C.IgniteMob()
		if(C.fire_stacks < 5)
			C.adjust_fire_stacks(5 - C.fire_stacks)

// bigheart heals the graffiti artist by .2 in burn/brute/tox per 0.2 seconds, and harms .2 brute if they aren't the graffiti artist
// this has the highest paint cost of all special decals
/obj/effect/decal/cleanable/crayon/special/bigheart/Crossed(atom/movable/AM)
	if(iscarbon(AM))
		var/mob/living/carbon/C = AM
		if(C.mind?.has_antag_datum(/datum/antagonist/graffiti_artist))
			while(get_turf(C) == get_turf(src))
				C.adjustBruteLoss(-0.2)
				C.adjustFireLoss(-0.2)
				C.adjustToxLoss(-0.2, TRUE, TRUE)
				sleep(2)
		else
			while(get_turf(C) == get_turf(src))
				C.adjustBruteLoss(0.2)
				sleep(2)
