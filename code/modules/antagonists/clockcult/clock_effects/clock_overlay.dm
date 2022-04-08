//an "overlay" used by clockwork walls and floors to appear normal to mesons.
/obj/effect/clockwork/overlay
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/atom/linked

/obj/effect/clockwork/overlay/examine(mob/user)
	if(linked)
		linked.examine(user)
	return ..()

/obj/effect/clockwork/overlay/ex_act(severity, target, origin)
	return FALSE

/obj/effect/clockwork/overlay/singularity_act()
	return
/obj/effect/clockwork/overlay/singularity_pull()
	return

/obj/effect/clockwork/overlay/singularity_pull(S, current_size)
	return

/obj/effect/clockwork/overlay/Destroy()
	if(linked)
		linked = null
	. = ..()

/obj/effect/clockwork/overlay/wall
	name = "clockwork wall"
	icon = 'icons/turf/walls/clockwork_wall.dmi'
	icon_state = "clockwork_wall"
	smooth_groups = list(SMOOTH_GROUP_CLOCKCULT, SMOOTH_GROUP_WALL_CLOCKWORK)
	smooth_with = list(SMOOTH_GROUP_WALL_CLOCKWORK)
	smooth_flags = SMOOTH_CORNERS
	layer = CLOSED_TURF_LAYER

/obj/effect/clockwork/overlay/wall/Initialize()
	. = ..()
	QUEUE_SMOOTH_NEIGHBORS(src)
	return INITIALIZE_HINT_LATELOAD

/obj/effect/clockwork/overlay/wall/LateInitialize()
	. = ..()
	QUEUE_SMOOTH(src)

/obj/effect/clockwork/overlay/wall/Destroy()
	QUEUE_SMOOTH_NEIGHBORS(src)
	return ..()

/obj/effect/clockwork/overlay/floor
	icon = 'icons/turf/floors.dmi'
	icon_state = "clockwork_floor"
	layer = TURF_LAYER
	plane = FLOOR_PLANE

/obj/effect/clockwork/overlay/floor/bloodcult //this is used by BLOOD CULT, it shouldn't use such a path...
	icon_state = "cult"
