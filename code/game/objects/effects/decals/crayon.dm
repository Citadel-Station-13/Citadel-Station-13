/obj/effect/decal/cleanable/crayon
	name = "rune"
	desc = "Graffiti. Damn kids."
	icon = 'icons/effects/crayondecal.dmi'
	icon_state = "rune1"
	layer = ABOVE_NORMAL_TURF_LAYER
	var/do_icon_rotate = TRUE

/obj/effect/decal/cleanable/crayon/examine()
	set src in view(2)
	..()
	return


/obj/effect/decal/cleanable/crayon/New(location, main = "#FFFFFF", var/type = "rune1", var/e_name = "rune", var/rotation = 0, var/alt_icon = null)
	..()
	loc = location

	name = e_name
	desc = "A [name] vandalizing the station."
	if(type == "poseur tag")
		type = pick(gang_name_pool)

	if(alt_icon)
		icon = alt_icon
	icon_state = type

	if(rotation && do_icon_rotate)
		var/matrix/M = matrix()
		M.Turn(rotation)
		src.transform = M

	color = main


/obj/effect/decal/cleanable/crayon/gang
	layer = HIGH_OBJ_LAYER //Harder to hide
	do_icon_rotate = FALSE //These are designed to always face south, so no rotation please.
	var/datum/gang/gang

/obj/effect/decal/cleanable/crayon/gang/New(location, var/datum/gang/G, var/e_name = "gang tag", var/rotation = 0)
	if(!type || !G)
		qdel(src)

	var/area/territory = get_area(location)
	var/color

	gang = G
	color = G.color_hex
	icon_state = G.name
	G.territory_new |= list(territory.type = territory.name)

	..(location, color, icon_state, e_name, rotation)

/obj/effect/decal/cleanable/crayon/gang/Destroy()
	var/area/territory = get_area(src)

	if(gang)
		gang.territory -= territory.type
		gang.territory_new -= territory.type
		gang.territory_lost |= list(territory.type = territory.name)
	return ..()
