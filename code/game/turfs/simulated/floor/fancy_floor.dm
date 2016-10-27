/* In this file:
 * Wood floor
 * Grass floor
 * Carpet floor
 */

/turf/open/floor/wood
	icon_state = "wood"
	floor_tile = /obj/item/stack/tile/wood
	broken_states = list("wood-broken", "wood-broken2", "wood-broken3", "wood-broken4", "wood-broken5", "wood-broken6", "wood-broken7")

/turf/open/floor/wood/attackby(obj/item/C, mob/user, params)
	if(..())
		return
	if(istype(C, /obj/item/weapon/screwdriver))
		if(broken || burnt)
			return
		user << "<span class='danger'>You unscrew the planks.</span>"
		new floor_tile(src)
		make_plating()
		playsound(src, C.usesound, 80, 1)
		return

/turf/open/floor/wood/cold
	temperature = 255.37

/turf/open/floor/grass
	name = "Grass patch"
	icon_state = "grass"
	floor_tile = /obj/item/stack/tile/grass
	broken_states = list("sand")

/turf/open/floor/grass/New()
	..()
	spawn(1)
		update_icon()

/turf/open/floor/grass/attackby(obj/item/C, mob/user, params)
	if(..())
		return
	if(istype(C, /obj/item/weapon/shovel))
		new /obj/item/weapon/ore/glass(src)
		new /obj/item/weapon/ore/glass(src) //Make some sand if you shovel grass
		user << "<span class='notice'>You shovel the grass.</span>"
		make_plating()

/turf/open/floor/carpet
	name = "Carpet"
	icon = 'icons/turf/floors/carpet.dmi'
	icon_state = "carpet"
	floor_tile = /obj/item/stack/tile/carpet
	broken_states = list("damaged")
	smooth = SMOOTH_TRUE
	canSmoothWith = null

/turf/open/floor/carpet/New()
	..()
	spawn(1)
		update_icon()

/turf/open/floor/carpet/update_icon()
	if(!..())
		return 0
	if(!broken && !burnt)
		if(smooth)
			queue_smooth(src)
	else
		make_plating()
		if(smooth)
			queue_smooth_neighbors(src)

/turf/open/floor/carpet/narsie_act()
	return

/turf/open/floor/carpet/break_tile()
	broken = 1
	update_icon()

/turf/open/floor/carpet/burn_tile()
	burnt = 1
	update_icon()

/turf/open/floor/carpet/carpetsymbol
	icon_state = "carpetsymbol"
	smooth = SMOOTH_FALSE

/turf/open/floor/carpet/carpetsymbol2
	icon_state = "carpetstar"
	smooth = SMOOTH_FALSE


/turf/open/floor/fakespace
	icon = 'icons/turf/space.dmi'
	icon_state = "0"
	floor_tile = /obj/item/stack/tile/fakespace
	broken_states = list("damaged")

/turf/open/floor/fakespace/New()
	..()
	icon_state = "[rand(0,25)]"