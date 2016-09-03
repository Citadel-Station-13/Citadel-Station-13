/mob/living/carbon/alien/spawn_gibs()
	xgibs(loc, viruses)

/mob/living/carbon/alien/gib_animation()
	PoolOrNew(/obj/effect/overlay/temp/gib_animation, list(loc, "gibbed-a"))

/mob/living/carbon/alien/spawn_dust()
	new /obj/effect/decal/remains/xeno(loc)

/mob/living/carbon/alien/dust_animation()
	PoolOrNew(/obj/effect/overlay/temp/dust_animation, list(loc, "dust-a"))

/mob/living/carbon/alien/proc/deathNotice(var/area/AR, var/turf/T)
	if(src.z == 2) //Admin fuckery can continue without giving false death rattles to aliens on station or elsewhere.
		return
	src.deathNotified = 1
	T = get_turf(src)
	var/mob/living/carbon/alien/A
	for(A in world)
		A << "<span class='userdanger'>[src.name] has died at [T.loc.name]! </span>"

/mob/living/carbon/alien/death(gibbed)
	if(!deathNotified)
		deathNotice()
	..()
