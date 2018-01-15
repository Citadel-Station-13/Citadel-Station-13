// the disposal outlet machine
/obj/structure/disposaloutlet
	name = "disposal outlet"
	desc = "An outlet for the pneumatic disposal system."
	icon = 'icons/obj/atmospherics/pipes/disposal.dmi'
	icon_state = "outlet"
	density = TRUE
	anchored = TRUE
	var/active = FALSE
	var/turf/target	// this will be where the output objects are 'thrown' to.
	var/obj/structure/disposalpipe/trunk/trunk // the attached pipe trunk
	var/obj/structure/disposalconstruct/stored
	var/start_eject = 0
	var/eject_range = 2

/obj/structure/disposaloutlet/Initialize(mapload, obj/structure/disposalconstruct/make_from)
	. = ..()
	if(make_from)
		setDir(make_from.dir)
		make_from.forceMove(src)
		stored = make_from
	else
		stored = new /obj/structure/disposalconstruct(src, make_from = src)

	target = get_ranged_target_turf(src, dir, 10)

	trunk = locate() in loc
	if(trunk)
		trunk.linked = src	// link the pipe trunk to self

/obj/structure/disposaloutlet/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/rad_insulation, RAD_NO_INSULATION)

/obj/structure/disposaloutlet/Destroy()
	if(trunk)
		trunk.linked = null
		trunk = null
	QDEL_NULL(stored)
	return ..()

// expel the contents of the holder object, then delete it
// called when the holder exits the outlet
/obj/structure/disposaloutlet/proc/expel(obj/structure/disposalholder/H)
	H.active = FALSE
	flick("outlet-open", src)
	if((start_eject + 30) < world.time)
		start_eject = world.time
		playsound(src, 'sound/machines/warning-buzzer.ogg', 50, 0, 0)
		addtimer(CALLBACK(src, .proc/expel_holder, H, TRUE), 20)
	else
		addtimer(CALLBACK(src, .proc/expel_holder, H), 20)

/obj/structure/disposaloutlet/proc/expel_holder(obj/structure/disposalholder/H, playsound=FALSE)
	if(playsound)
		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)

	if(!H)
		return

	var/turf/T = get_turf(src)

	for(var/A in H)
		var/atom/movable/AM = A
		AM.forceMove(T)
		AM.pipe_eject(dir)
		AM.throw_at(target, eject_range, 1)

	H.vent_gas(T)
	qdel(H)


/obj/structure/disposaloutlet/attackby(obj/item/I, mob/user, params)
	add_fingerprint(user)
	if(istype(I, /obj/item/weldingtool))
		var/obj/item/weldingtool/W = I
		if(W.remove_fuel(0,user))
			playsound(src, 'sound/items/welder2.ogg', 100, 1)
			to_chat(user, "<span class='notice'>You start slicing the floorweld off [src]...</span>")
			if(do_after(user, 20*I.toolspeed, target = src))
				if(!W.isOn())
					return
				to_chat(user, "<span class='notice'>You slice the floorweld off [src].</span>")
				stored.forceMove(loc)
				transfer_fingerprints_to(stored)
				stored = null
				qdel(src)
	else
		return ..()
