area/edina
	name = "Nova Edina wilderness"
	icon_state = "edina"
	valid_territory = FALSE
	has_gravity = STANDARD_GRAVITY
	icon = 'icons/turf/areas.dmi'
	clockwork_warp_allowed = FALSE // Can servants warp into this area from Reebe?
	clockwork_warp_fail = "The aurora borealis is interfering with your teleport! Try somewhere closer to the city."
	requires_power = TRUE
	always_unpowered = TRUE

	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	valid_territory = FALSE
	outdoors = TRUE
	ambientsounds = SPACE
	blob_allowed = FALSE //Eating up space doesn't count for victory as a blob.

	/// If false, loading multiple maps with this area type will create multiple instances.
	unique = TRUE


area/edina/backstreet
	name = "Nova Edina backstreets"
	icon_state = "edina_alley"
	clockwork_warp_allowed = TRUE
	ambientsounds = MAINTENANCE
	always_unpowered = FALSE //Sure you can have power if you want

area/edina/street
	name = "Nova Edina Streets"
	icon_state = "edina_street"
	ambientsounds = null //TODO:add ?

/area/edina/protected //Prevents ice storms
	name = "Sheltered Nova Edina"


/turf/open/floor/grass/snow/edina//But for now, we just handle what is outside, for light control etc.
	name = "Scottish snow"
	desc = "Looks super chilly!"

	light_range = 3 //MIDNIGHT BLUE
	light_power = 0.15 //NOT PITCH BLACK, JUST REALLY DARK
	light_color = "#00111a" //The light can technically cycle on a timer worldwide, but no daynight cycle.
	baseturfs = /turf/open/floor/grass/snow/edina //If we explode or die somehow, we just make more! Ahahaha!!!
	tiled_dirt = 0 //NO TILESMOOTHING DIRT/DIRT SPAWNS OR SOME SHIT

//lets people build
/turf/open/floor/grass/snow/edina/attackby(obj/item/C, mob/user, params)
	.=..()
	if(istype(C, /obj/item/stack/tile))
		for(var/obj/O in src)
			if(O.level == 1) //ex. pipes laid underneath a tile
				for(var/M in O.buckled_mobs)
					to_chat(user, "<span class='warning'>Someone is buckled to \the [O]! Unbuckle [M] to move \him out of the way.</span>")
					return
		var/obj/item/stack/tile/W = C
		if(!W.use(1))
			return
		var/turf/open/floor/T = PlaceOnTop(W.turf_type)
		if(istype(W, /obj/item/stack/tile/light)) //TODO: get rid of this ugly check somehow
			var/obj/item/stack/tile/light/L = W
			var/turf/open/floor/light/F = T
			F.state = L.state
		playsound(src, 'sound/weapons/genhit.ogg', 50, 1)
