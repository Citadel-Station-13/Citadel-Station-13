/area/ai_monitored
	name = "AI Monitored Area"
	clockwork_warp_allowed = FALSE
	var/list/obj/machinery/camera/motioncameras = list()
	var/list/datum/weakref/motionTargets = list()

/area/ai_monitored/Initialize(mapload)
	. = ..()
	if(mapload)
		for (var/obj/machinery/camera/M in src)
			if(M.isMotion())
				motioncameras.Add(M)
				M.area_motion = src

//Only need to use one camera

/area/ai_monitored/Entered(atom/movable/O)
	..()
	if (ismob(O) && motioncameras.len)
		for(var/X in motioncameras)
			var/obj/machinery/camera/cam = X
			cam.newTarget(O)
			return

/area/ai_monitored/Exited(atom/movable/O)
	..()
	if (ismob(O) && motioncameras.len)
		for(var/X in motioncameras)
			var/obj/machinery/camera/cam = X
<<<<<<< HEAD
			cam.lostTarget(O)
			return
=======
			cam.lostTargetRef(WEAKREF(O))
			return
>>>>>>> 4edd802... Weak references + Cameras now use them (#32504)
