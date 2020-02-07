/obj/item/projectile/gravity
	name = "gravity bolt"
	icon = 'icons/effects/effects.dmi'
	icon_state = "chronofield"
	hitsound = 'sound/weapons/wave.ogg'
	damage = 0
	damage_type = BRUTE
	nodamage = TRUE
	var/power = 4
	var/list/thrown = list()		//normally we wouldn't need this but incase on_hit is called multiple times, yeah.. this is a good idea.

/obj/item/projectile/gravity/Initialize(mapload)
	. = ..()
	var/obj/item/ammo_casing/energy/gravity/G = loc
	if(istype(G))
		power = min(G.gun.power, 15)

/obj/item/projectile/gravity/on_hit()
	. = ..()
	var/turf/T = get_turf(src)
	var/list/tothrow
	var/list/mobs = list()
	var/list/objs = list()
	var/list/cachedrange = range(T, power)
	for(var/mob/M in cachedrange)
		mobs += M
	for(var/obj/O in cachedrange)
		objs += O
	tothrow = mobs + objs		//mobs priority
	var/safety = 50
	for(var/i in tothrow)
		if(!safety)
			break
		var/atom/movable/AM = i
		if(can_throw(AM, thrown) && do_the_throw(T, AM, thrown))
			safety--
	for(var/turf/F in range(T,power))
		new /obj/effect/temp_visual/gravpush(F)

/obj/item/projectile/gravity/proc/can_throw(atom/movable/AM, list/thrown)
	return (AM != src) && (AM != firer) && !AM.anchored && !thrown[AM]

/obj/item/projectile/gravity/proc/do_the_throw(turf/origin, atom/movable/AM, list/thrown)
	thrown[AM] = TRUE
	var/target = get_target(origin, AM)
	if(!target)
		return FALSE
	AM.throw_at(target, power + 1, 1)
	return TRUE

/obj/item/projectile/gravity/proc/get_target(turf/origin, atom/movable/AM)
	return origin

/obj/item/projectile/gravity/repulse
	name = "repulsion bolt"
	color = "#33CCFF"

/obj/item/projectile/gravity/repulse/get_target(turf/origin, atom/movable/AM)
	return get_turf_in_angle(Get_Angle(origin, AM), origin, power)

/obj/item/projectile/gravity/attract
	name = "attraction bolt"
	color = "#FF6600"

/obj/item/projectile/gravity/attract/get_target(turf/origin, atom/movable/AM)
	return origin

/obj/item/projectile/gravity/chaos
	name = "gravitational blast"
	color = "#101010"

/obj/item/projectile/gravity/chaos/get_target(turf/origin, atom/movable/AM)
	return get_turf_in_angle(rand(0, 359), origin, power)
