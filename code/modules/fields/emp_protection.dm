/datum/proximity_monitor/advanced/flags
	name = "Generic Comsig Field"
	setup_field_turfs = TRUE
	field_shape = FIELD_SHAPE_RADIUS_SQUARE
	use_host_turf = TRUE
	var/flags = NONE
	var/comsig
	var/list/protected_atoms = list()
	var/obj/effect/overlay/tile_visual

/datum/proximity_monitor/advanced/flags/Destroy()
	if(tile_visual)
		QDEL_NULL(tile_visual)
	return ..()

/datum/proximity_monitor/advanced/flags/setup_field_turf(turf/T)
	. = ..()
	if(tile_visual)
		T.vis_contents += tile_visual
	RegisterSignal(T, COMSIG_ATOM_NEW_CONTENT, .proc/add_protected_atom)
	RegisterSignal(T, comsig, .proc/return_flags)
	for(var/k in T.contents)
		var/atom/movable/AM = k
		RegisterSignal(AM, comsig, .proc/return_flags)
		protected_atoms[AM] = TRUE

/datum/proximity_monitor/advanced/flags/cleanup_field_turf(turf/T)
	. = ..()
	if(tile_visual)
		T.vis_contents -= tile_visual
	UnregisterSignal(T, list(comsig, COMSIG_ATOM_NEW_CONTENT))
	for(var/k in T.contents)
		var/atom/movable/AM = k
		UnregisterSignal(AM, comsig)
		protected_atoms -= AM

/datum/proximity_monitor/advanced/flags/field_turf_crossed(atom/movable/AM, obj/effect/abstract/proximity_checker/advanced/field_turf/F)
	if(protected_atoms[AM])
		return
	RegisterSignal(AM, comsig, .proc/return_flags)
	protected_atoms |= AM

/datum/proximity_monitor/advanced/flags/field_turf_uncrossed(atom/movable/AM, obj/effect/abstract/proximity_checker/advanced/field_turf/F)
	if(AM.loc in field_turfs)
		return
	UnregisterSignal(AM, comsig)
	protected_atoms -= AM

/datum/proximity_monitor/advanced/flags/proc/return_flags()
	return flags

/datum/proximity_monitor/advanced/flags/proc/add_protected_atom(turf/T, atom/movable/new_content)
	RegisterSignal(new_content, comsig, .proc/return_flags)
	protected_atoms |= new_content

/obj/machinery/emp_protection
	name = "\improper EMP dissipator"
	desc = "A special rod machinery meant to dissipate electromagnetic pulses over a large area."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shieldon"
	anchored = TRUE
	density = TRUE
	var/datum/proximity_monitor/advanced/flags/shield
	var/obj/effect/overlay/tile_visual

/obj/machinery/emp_protection/Initialize()
	. = ..()
	tile_visual = new
	tile_visual.icon = 'icons/effects/effects.dmi'
	tile_visual.icon_state = "tile_shield"
	tile_visual.color = "#0000FF64" //Blue with 100 alpha.
	tile_visual.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	if(anchored)
		shield = make_field(/datum/proximity_monitor/advanced/flags, list("current_range" = 3, "host" = src,
							"name" = "EMP protection zone", "comsig" = COMSIG_ATOM_EMP_ACT,
							"flags" = EMP_PROTECT_SELF|EMP_PROTECT_CONTENTS|EMP_PROTECT_WIRES, "tile_visual" = tile_visual))

/obj/machinery/emp_protection/Destroy()
	QDEL_NULL(shield)
	return ..()

/obj/machinery/emp_protection/examine(mob/user)
	. = ..()
	var/slow = FALSE
	if(!malf_check(user))
		slow = TRUE
	. += "<span class='notice'>You can use a <b>wrench</b> to toggle the anchors[slow ? ", albeit it takes some time" : ", fast"].</span>"

/obj/machinery/emp_protection/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	var/time = 10 SECONDS
	if(malf_check(user))
		time = 2 SECONDS
	return (default_unfasten_wrench(user, I, time) != CANT_UNFASTEN)

/obj/machinery/emp_protection/setAnchored(anchorvalue)
	var/old_anchored = anchored
	. = ..()
	if(anchored && !old_anchored)
		shield = make_field(/datum/proximity_monitor/advanced/flags, list("current_range" = 3, "host" = src,
							"name" = "EMP protection zone", "comsig" = COMSIG_ATOM_EMP_ACT,
							"flags" = EMP_PROTECT_SELF|EMP_PROTECT_CONTENTS|EMP_PROTECT_WIRES, "tile_visual" = tile_visual))
	else if(!anchored)
		QDEL_NULL(shield)

/obj/machinery/emp_protection/proc/malf_check(mob/living/user)
	if(!iscyborg(user))
		return FALSE
	var/mob/living/silicon/robot/R = user
	var/datum/antagonist/traitor/T = user.mind.has_antag_datum(/datum/antagonist/traitor)
	if(!T && R.connected_ai?.mind)
		T = R.connected_ai.mind.has_antag_datum(/datum/antagonist/traitor)
	if(T && T.traitor_kind == TRAITOR_AI)
		return TRUE
