/obj/vehicle/ridden/secway
	var/chargemax = 100
	var/chargerate = 0.35
	var/charge = 100
	var/chargespeed = 1
	var/normalspeed = 3.5
	var/last_tick = 0
	var/list/progressbars_by_rider = list()

/obj/vehicle/ridden/secway/Initialize()
    . = ..()
    START_PROCESSING(SSfastprocess, src)

/obj/vehicle/ridden/secway/process()
	var/diff = world.time - last_tick
	var/regen = chargerate * diff
	charge = CLAMP(charge + regen, 0, chargemax)
	last_tick = world.time

/obj/vehicle/ridden/secway/relaymove(mob/user, direction)
	var/new_speed = normalspeed
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.sprinting && charge)
			charge--
			new_speed = chargespeed
	GET_COMPONENT(D, /datum/component/riding)
	D.speed = new_speed
	return ..()

/obj/vehicle/ridden/secway/buckle_mob(mob/living/M, force, check_loc)
	. = ..(M, force, check_loc)
	if(.)
		if(progressbars_by_rider[M])
			qdel(progressbars_by_rider[M])
		var/datum/progressbar/D = new(M, chargemax, src)
		D.update(charge)
		progressbars_by_rider[M] = D

/obj/vehicle/ridden/secway/unbuckle_mob(mob/living/M, force)
	. = ..(M, force)
	if(.)
		qdel(progressbars_by_rider[M])
		progressbars_by_rider -= M

/obj/vehicle/ridden/secway/Destroy()
	for(var/i in progressbars_by_rider)
		qdel(progressbars_by_rider[i])
	progressbars_by_rider.Cut()
    STOP_PROCESSING(SSfastprocess, src)
	return ..()
