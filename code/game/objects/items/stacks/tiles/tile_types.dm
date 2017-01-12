/obj/item/stack/tile
	name = "broken tile"
	singular_name = "broken tile"
	desc = "A broken tile. This should not exist."
	icon = 'icons/obj/tiles.dmi'
	w_class = 3
	force = 1
	throwforce = 1
	throw_speed = 3
	throw_range = 7
	max_amount = 60
	origin_tech = "materials=1"
	var/turf_type = null
	var/mineralType = null

/obj/item/stack/tile/New(loc, amount)
	..()
	pixel_x = rand(-3, 3)
	pixel_y = rand(-3, 3) //randomize a little

/obj/item/stack/tile/attackby(obj/item/W, mob/user, params)

	if (istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W

		if(get_amount() < 4)
			user << "<span class='warning'>You need at least four tiles to do this!</span>"
			return

		if(WT.is_hot() && !mineralType)
			user << "<span class='warning'>You can not reform this!</span>"
			return

		if(WT.remove_fuel(0,user))

			if(mineralType == "plasma")
				atmos_spawn_air("plasma=5;TEMP=1000")
				user.visible_message("<span class='warning'>[user.name] sets the plasma tiles on fire!</span>", \
									"<span class='warning'>You set the plasma tiles on fire!</span>")
				qdel(src)
				return

			if (mineralType == "metal")
				var/obj/item/stack/sheet/metal/new_item = new(user.loc)
				user.visible_message("[user.name] shaped [src] into metal with the welding tool.", \
							 "<span class='notice'>You shaped [src] into metal with the welding tool.</span>", \
							 "<span class='italics'>You hear welding.</span>")
				var/obj/item/stack/rods/R = src
				src = null
				var/replace = (user.get_inactive_hand()==R)
				R.use(4)
				if (!R && replace)
					user.put_in_hands(new_item)

			else
				var/sheet_type = text2path("/obj/item/stack/sheet/mineral/[mineralType]")
				var/obj/item/stack/sheet/mineral/new_item = new sheet_type(user.loc)
				user.visible_message("[user.name] shaped [src] into a sheet with the welding tool.", \
							 "<span class='notice'>You shaped [src] into a sheet with the welding tool.</span>", \
							 "<span class='italics'>You hear welding.</span>")
				var/obj/item/stack/rods/R = src
				src = null
				var/replace = (user.get_inactive_hand()==R)
				R.use(4)
				if (!R && replace)
					user.put_in_hands(new_item)
	else
		return ..()

//Grass
/obj/item/stack/tile/grass
	name = "grass tile"
	singular_name = "grass floor tile"
	desc = "A patch of grass like they use on space golf courses."
	icon_state = "tile_grass"
	origin_tech = "biotech=1"
	turf_type = /turf/open/floor/grass
	burn_state = FLAMMABLE


//Wood
/obj/item/stack/tile/wood
	name = "wood floor tile"
	singular_name = "wood floor tile"
	desc = "An easy to fit wood floor tile."
	icon_state = "tile-wood"
	origin_tech = "biotech=1"
	turf_type = /turf/open/floor/wood
	burn_state = FLAMMABLE


//Carpets
/obj/item/stack/tile/carpet
	name = "carpet"
	singular_name = "carpet"
	desc = "A piece of carpet. It is the same size as a floor tile."
	icon_state = "tile-carpet"
	turf_type = /turf/open/floor/carpet
	burn_state = FLAMMABLE


/obj/item/stack/tile/fakespace
	name = "astral carpet"
	singular_name = "astral carpet"
	desc = "A piece of carpet with a convincing star pattern."
	icon_state = "tile_space"
	turf_type = /turf/open/floor/fakespace
	burn_state = FLAMMABLE

/obj/item/stack/tile/fakespace/loaded
	amount = 30

//High-traction
/obj/item/stack/tile/noslip
	name = "high-traction floor tile"
	singular_name = "high-traction floor tile"
	desc = "A high-traction floor tile. It feels rubbery in your hand."
	icon_state = "tile_noslip"
	turf_type = /turf/open/floor/noslip
	origin_tech = "materials=3"

/obj/item/stack/tile/noslip/thirty
	amount = 30

//Pod floor
/obj/item/stack/tile/pod
	name = "pod floor tile"
	singular_name = "pod floor tile"
	desc = "A grooved floor tile."
	icon_state = "tile_pod"
	turf_type = /turf/open/floor/pod

/obj/item/stack/tile/pod/light
	name = "light pod floor tile"
	singular_name = "light pod floor tile"
	desc = "A lightly colored grooved floor tile."
	icon_state = "tile_podlight"
	turf_type = /turf/open/floor/pod/light

/obj/item/stack/tile/pod/dark
	name = "dark pod floor tile"
	singular_name = "dark pod floor tile"
	desc = "A darkly colored grooved floor tile."
	icon_state = "tile_poddark"
	turf_type = /turf/open/floor/pod/dark

//Plasteel (normal)
/obj/item/stack/tile/plasteel
	name = "floor tile"
	singular_name = "floor tile"
	desc = "Those could work as a pretty decent throwing weapon."
	icon_state = "tile"
	force = 6
	materials = list(MAT_METAL=500)
	throwforce = 10
	flags = CONDUCT
	turf_type = /turf/open/floor/plasteel
	mineralType = "metal"

/obj/item/stack/tile/plasteel/cyborg
	desc = "The ground you walk on." //Not the usual floor tile desc as that refers to throwing, Cyborgs can't do that - RR
	materials = list() // All other Borg versions of items have no Metal or Glass - RR
	is_cyborg = 1
	cost = 125
