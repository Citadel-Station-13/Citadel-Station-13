var/datum/subsystem/parallax/SSparallax

/datum/subsystem/parallax
	name = "Space Parallax"
	init_order = 20
	flags = SS_NO_FIRE

/datum/subsystem/parallax/New()
	NEW_SS_GLOBAL(SSparallax)

/datum/subsystem/parallax/proc/cachespaceparallax()
	for(var/i in 1 to 9)
		var/obj/screen/parallax/parallax_layer = new /obj/screen/parallax()
		for(var/j in 0 to 224)
			var/image/I = image('icons/turf/space_parallax4.dmi',"[rand(26)]")
			I.pixel_x = 32 * (j%15)
			I.pixel_y = 32 * round(j/15)
			I.plane = PLANE_SPACE_PARALLAX
			parallax_layer.overlays += I
			parallax_layer.parallax_speed = 0
			parallax_layer.plane = PLANE_SPACE_PARALLAX
			calibrate_parallax(parallax_layer,i)
		space_parallax_0[i] = parallax_layer
	for(var/i in 1 to 9)
		var/obj/screen/parallax/parallax_layer = new /obj/screen/parallax()
		for(var/j in 0 to 224)
			var/image/I = image('icons/turf/space_parallax3.dmi',"[rand(26)]")
			I.pixel_x = 32 * (j%15)
			I.pixel_y = 32 * round(j/15)
			I.plane = PLANE_SPACE_PARALLAX
			parallax_layer.overlays += I
			parallax_layer.parallax_speed = 1
			parallax_layer.plane = PLANE_SPACE_PARALLAX
			calibrate_parallax(parallax_layer,i)
		space_parallax_1[i] = parallax_layer
	for(var/i in 1 to 9)
		var/obj/screen/parallax/parallax_layer = new /obj/screen/parallax()
		for(var/j in 0 to 224)
			var/image/I = image('icons/turf/space_parallax2.dmi',"[rand(26)]")
			I.pixel_x = 32 * (j%15)
			I.pixel_y = 32 * round(j/15)
			I.plane = PLANE_SPACE_PARALLAX
			parallax_layer.overlays += I
			parallax_layer.parallax_speed = 2
			parallax_layer.plane = PLANE_SPACE_PARALLAX
			calibrate_parallax(parallax_layer,i)
		space_parallax_2[i] = parallax_layer
	for(var/i in 1 to 9)
		var/obj/screen/parallax/parallax_layer = new /obj/screen/parallax()
		var/image/space_parallax_layer = space_parallax_0[i]
		for(var/j in 1 to space_parallax_layer.overlays.len)
			var/image/I = space_parallax_layer.overlays[j]
			var/image/J = image('icons/turf/space_parallax4.dmi',I.icon_state)
			J.plane = PLANE_SPACE_PARALLAX_DUST
			J.pixel_x = I.pixel_x
			J.pixel_y = I.pixel_y
			parallax_layer.overlays += J
			parallax_layer.parallax_speed = 0
			parallax_layer.plane = PLANE_SPACE_PARALLAX_DUST
			calibrate_parallax(parallax_layer,i)
		space_parallax_dust_0[i] = parallax_layer
	for(var/i in 1 to 9)
		var/obj/screen/parallax/parallax_layer = new /obj/screen/parallax()
		var/image/space_parallax_layer = space_parallax_1[i]
		for(var/j in 1 to space_parallax_layer.overlays.len)
			var/image/I = space_parallax_layer.overlays[j]
			var/image/J = image('icons/turf/space_parallax3.dmi',I.icon_state)
			J.plane = PLANE_SPACE_PARALLAX_DUST
			J.pixel_x = I.pixel_x
			J.pixel_y = I.pixel_y
			parallax_layer.overlays += J
			parallax_layer.parallax_speed = 1
			parallax_layer.plane = PLANE_SPACE_PARALLAX_DUST
			calibrate_parallax(parallax_layer,i)
		space_parallax_dust_1[i] = parallax_layer
	for(var/i in 1 to 9)
		var/obj/screen/parallax/parallax_layer = new /obj/screen/parallax()
		var/image/space_parallax_layer = space_parallax_2[i]
		for(var/j in 1 to space_parallax_layer.overlays.len)
			var/image/I = space_parallax_layer.overlays[j]
			var/image/J = image('icons/turf/space_parallax2.dmi',I.icon_state)
			J.plane = PLANE_SPACE_PARALLAX_DUST
			J.pixel_x = I.pixel_x
			J.pixel_y = I.pixel_y
			parallax_layer.overlays += J
			parallax_layer.parallax_speed = 2
			parallax_layer.plane = PLANE_SPACE_PARALLAX_DUST
			calibrate_parallax(parallax_layer,i)
		space_parallax_dust_2[i] = parallax_layer
	parallax_initialized = 1


/datum/subsystem/parallax/Initialize()
    cachespaceparallax()
