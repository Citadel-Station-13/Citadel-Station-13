GLOBAL_LIST(gang_tags)

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
/obj/effect/decal/cleanable/crayon/NeverShouldHaveComeHere(turf/T)
	return isgroundlessturf(T)

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

/obj/effect/decal/cleanable/crayon/gang
	name = "Leet Like Jeff K gang tag"
	desc = "Looks like someone's claimed this area for Leet Like Jeff K."
	icon = 'icons/obj/gang/tags.dmi'
	layer = BELOW_MOB_LAYER
	var/datum/team/gang/my_gang

/obj/effect/decal/cleanable/crayon/gang/Initialize(mapload, main, type, e_name, graf_rot, alt_icon = null)
	. = ..()
	LAZYADD(GLOB.gang_tags, src)

/obj/effect/decal/cleanable/crayon/gang/Destroy()
	LAZYREMOVE(GLOB.gang_tags, src)
	..()
