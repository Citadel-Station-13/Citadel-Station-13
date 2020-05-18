
#define REGISTER_NESTED_LOCS(source, list, comsig, proc) \
	for(var/k in get_nested_locs(source)){\
		var/atom/_A = k;\
		RegisterSignal(_A, comsig, proc);\
		list += _A\
	}

#define UNREGISTER_NESTED_LOCS(list, comsig, index) \
	for(var/k in index to length(list)){\
		var/atom/_A = list[k];\
		UnregisterSignal(_A, comsig);\
		list -= _A\
	}

/datum/component/area_of_effect
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/distance = 5
	var/range_or_view = "range"
	var/comsig_value
	var/return_value
	var/range_view_list
	var/range_view_turf_list = list()
	var/list/whitelist_typecache
	var/list/blacklist_typecache
	var/protect_self = TRUE
	var/list/nested_locs = list() //list of nested locations the parent atom is in, just like a matrioska doll.
	var/atom/topmost_atom //topmost atom we should be tracking.

/datum/component/area_of_effect/Initialize(dist = 3, r_or_v = "range", comsig, value, whitelist, blacklist, self = TRUE)
	. = ..()
	if(!isatom(parent) || isarea(parent) || !comsig)
		return COMPONENT_INCOMPATIBLE

	var/atom/P = parent
	distance = dist
	range_or_view = r_or_v
	comsig_value = comsig
	return_value = value
	whitelist_typecache = whitelist
	blacklist_typecache = blacklist
	protect_self = self

	var/turf/L = get_turf(P)
	if(L != P.loc && L != P)
		REGISTER_NESTED_LOCS(P.loc, nested_locs, COMSIG_ATOM_EXITED, .proc/on_content_exited)
	else
		topmost_atom = P

	range_view_list = (range_or_view == "range" ? range(distance, L) : view(distance, L))
	if(!protect_self)
		range_view_list -= P

	for(var/turf/T in range_view_list)
		RegisterSignal(T, COMSIG_ATOM_ENTERED, .proc/on_atom_entered)
		RegisterSignal(T, COMSIG_ATOM_EXITED, .proc/on_atom_exited)
		RegisterSignal(T, COMSIG_TURF_CHANGE, .proc/transfer_sigs)
		RegisterSignal(T, COMSIG_ATOM_NEW_CONTENT, .proc/on_new_content)
		range_view_turf_list += T

	for(var/k in range_view_list)
		var/atom/A = k
		if((whitelist_typecache && !whitelist_typecache[A.type]) || (blacklist_typecache && blacklist_typecache[A.type]))
			range_view_list -= A
			continue
		RegisterSignal(A,  comsig_value, .proc/return_value)

	SEND_SIGNAL(parent, COMSIG_AOE_RANGE_CALCULATED, null, null, range_view_list, range_view_turf_list)

/datum/component/area_of_effect/proc/on_atom_entered(turf/T, atom/movable/entered, atom/oldloc)
	if(entered == parent || entered == topmost_atom)
		return
	if(oldloc in range_view_turf_list)
		return
	if((whitelist_typecache && !whitelist_typecache[entered.type]) || (blacklist_typecache && blacklist_typecache[entered.type]))
		return
	RegisterSignal(entered,  comsig_value, .proc/return_value)
	range_view_list += entered

/datum/component/area_of_effect/proc/on_content_exited(atom/movable/source, atom/movable/exited, atom/newloc)
	var/index = nested_locs.Find(source)
	if(index == 1 ? exited == parent : exited == nested_locs[index-1])
		UNREGISTER_NESTED_LOCS(nested_locs, COMSIG_ATOM_EXITED, index)
		UnregisterSignal(topmost_atom, COMSIG_MOVABLE_MOVED)
		topmost_atom = exited
		recalculate_aoe(exited, newloc)

/datum/component/area_of_effect/proc/on_atom_exited(turf/source, atom/movable/exited, atom/newloc)
	if(exited != topmost_atom)
		if((exited in range_view_list) && !(newloc in range_view_turf_list))
			UnregisterSignal(exited, comsig_value)
		return
	recalculate_aoe(exited, newloc)

/datum/component/area_of_effect/proc/on_nullspace_moved(atom/movable/source, atom/oldloc, dir)
	if(source.loc)
		recalculate_aoe(source, source.loc)
		UnregisterSignal(source, COMSIG_MOVABLE_MOVED)

/datum/component/area_of_effect/proc/recalculate_aoe(atom/movable/exited, atom/newloc)
	var/list/L
	if(newloc) //not nullspaced.
		var/turf/T = get_turf(newloc)
		if(newloc != T)
			REGISTER_NESTED_LOCS(newloc, nested_locs, COMSIG_ATOM_EXITED, .proc/on_content_exited)
			topmost_atom = nested_locs[length(nested_locs)]
		if(T)
			L = range_or_view == "range" ? range(distance, T) : view(distance, T)
		else
			RegisterSignal(topmost_atom, COMSIG_MOVABLE_MOVED, .proc/on_nullspace_moved)
		if(!protect_self)
			L -= parent
	else
		RegisterSignal(exited, COMSIG_MOVABLE_MOVED, .proc/on_nullspace_moved)
	var/list/old_diff = range_view_list - L
	var/list/old_turf_diff = range_view_turf_list - L
	if(range_view_list) //old loc wasn't nullspace
		old_diff = range_view_list - L
		old_turf_diff = range_view_turf_list - L
		var/list/turf_sigs = list(COMSIG_ATOM_ENTERED, COMSIG_ATOM_EXITED, COMSIG_TURF_CHANGE, COMSIG_ATOM_NEW_CONTENT)
		for(var/k in old_turf_diff)
			var/turf/T = k
			UnregisterSignal(T, turf_sigs)
			range_view_turf_list -= T
		for(var/k in old_diff)
			var/atom/A = k
			UnregisterSignal(A, comsig_value)
	var/list/new_diff
	var/list/new_turfs
	if(L) //newloc isn't nullspace
		new_diff = L - range_view_list
		new_turfs = list()
		for(var/turf/T in new_diff)
			RegisterSignal(T, COMSIG_ATOM_ENTERED, .proc/on_atom_entered)
			RegisterSignal(T, COMSIG_ATOM_EXITED, .proc/on_atom_exited)
			RegisterSignal(T, COMSIG_TURF_CHANGE, .proc/transfer_sigs)
			RegisterSignal(T, COMSIG_ATOM_NEW_CONTENT, .proc/on_new_content)
			range_view_turf_list += T
			new_turfs += T
		for(var/k in new_diff)
			var/atom/A = k
			if((whitelist_typecache && !whitelist_typecache[A.type]) || (blacklist_typecache && blacklist_typecache[A.type]))
				L -= A
				continue
			RegisterSignal(A,  comsig_value, .proc/return_value)
	range_view_list = L
	SEND_SIGNAL(parent, COMSIG_AOE_RANGE_CALCULATED, old_diff, old_turf_diff, new_diff, new_turfs)

#undef REGISTER_NESTED_LOCS
#undef UNREGISTER_NESTED_LOCS

/datum/component/area_of_effect/proc/on_new_content(turf/T, atom/movable/A)
	if((whitelist_typecache && !whitelist_typecache[A.type]) || (blacklist_typecache && blacklist_typecache[A.type]) || A == parent)
		return
	RegisterSignal(A,  comsig_value, .proc/return_value)
	range_view_list += A

/datum/component/area_of_effect/proc/transfer_sigs(turf/T, path, list/new_baseturfs, flags, list/transferring_comps, list/callbacks)
	callbacks += CALLBACK(src, .proc/register_changed_turf, CHANGETURF_PROTOTYPE)
	range_view_turf_list -= T

/datum/component/area_of_effect/proc/register_changed_turf(turf/T)
	RegisterSignal(T, COMSIG_ATOM_ENTERED, .proc/on_atom_entered)
	RegisterSignal(T, COMSIG_ATOM_EXITED, .proc/on_atom_exited)
	RegisterSignal(T, COMSIG_TURF_CHANGE, .proc/transfer_sigs)
	RegisterSignal(T, COMSIG_ATOM_NEW_CONTENT, .proc/on_new_content)
	range_view_turf_list += T
	SEND_SIGNAL(parent, COMSIG_AOE_TURF_CHANGED, T)

/datum/component/area_of_effect/proc/return_value(atom/source)
	if(!(SEND_SIGNAL(parent, COMSIG_AOE_TRIGGERED, source) & AOE_PREVENT_TRIGGER))
		return return_value

/datum/component/area_of_effect/proc/del_if_unanchored(atom/source, value)
	if(value)
		qdel(src)

/obj/machinery/emp_protector
	name = "\improper EMP dissipator"
	desc = "A special rod machinery meant to dissipate electromagnetic pulses over a large area."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shieldon"
	anchored = TRUE
	density = TRUE
	var/obj/effect/overlay/tile_visual
	var/charges = 100
	var/max_charges = 100

/obj/machinery/emp_protector/ComponentInitialize()
	. = ..()
	tile_visual = new
	tile_visual.icon = 'icons/effects/effects.dmi'
	tile_visual.icon_state = "tile_shield"
	tile_visual.color = "#0000FF64" //Blue with 100 alpha.
	RegisterSignal(src, COMSIG_AOE_RANGE_CALCULATED, .proc/apply_visual)
	RegisterSignal(src, COMSIG_AOE_TURF_CHANGED, .proc/aoe_turf_change)
	RegisterSignal(src, COMSIG_AOE_TRIGGERED, .proc/on_aoe_triggered)
	if(anchored)
		var/datum/component/area_of_effect/C = AddComponent(/datum/component/area_of_effect, dist = 2, comsig = COMSIG_ATOM_EMP_ACT, value = EMP_PROTECT_CONTENTS|EMP_PROTECT_WIRES|EMP_PROTECT_SELF)
		C.RegisterSignal(src, COMSIG_OBJ_SETANCHORED, /datum/component/area_of_effect.proc/del_if_unanchored)
		START_PROCESSING(SSobj, src)

/obj/machinery/emp_protector/Destroy()
	QDEL_NULL(tile_visual)
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/machinery/emp_protector/proc/apply_visual(atom/source, list/old_targets, list/old_turfs, list/new_targets, list/new_turfs)
	for(var/A in old_turfs)
		var/turf/T = A
		T.vis_contents -= tile_visual
	for(var/A in new_turfs)
		var/turf/T = A
		T.vis_contents += tile_visual

/obj/machinery/emp_protector/proc/aoe_turf_change(atom/source, turf/T)
	T.vis_contents += tile_visual

/obj/machinery/emp_protector/proc/on_aoe_triggered(atom/source)
	if(!charges)
		return AOE_PREVENT_TRIGGER
	charges--
	var/blue_amount = 255 * (charges/max_charges)
	tile_visual.color = rgb(255 - blue_amount, 0, blue_amount)

/obj/machinery/emp_protector/process()
	if(charges < max_charges)
		charges++
		var/blue_amount = 255 * (charges/max_charges)
		tile_visual.color = rgb(255 - blue_amount, 0, blue_amount)

/obj/machinery/emp_protector/examine(mob/user)
	. = ..()
	var/slow = FALSE
	if(!malf_check(user))
		slow = TRUE
	. += "<span class='notice'>You can use a <b>wrench</b> to toggle the anchors[slow ? ", albeit it takes some time" : ", fast"].</span>"

/obj/machinery/emp_protector/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	var/time = 10 SECONDS
	if(malf_check(user))
		time = 2 SECONDS
	return (default_unfasten_wrench(user, I, time) != CANT_UNFASTEN)

/obj/machinery/emp_protector/setAnchored(anchorvalue)
	var/old_anchored = anchored
	. = ..()
	if(anchored && !old_anchored)
		var/datum/component/area_of_effect/C = AddComponent(/datum/component/area_of_effect, dist = 2, comsig = COMSIG_ATOM_EMP_ACT, value = EMP_PROTECT_CONTENTS|EMP_PROTECT_WIRES|EMP_PROTECT_SELF)
		C.RegisterSignal(src, COMSIG_OBJ_SETANCHORED, /datum/component/area_of_effect.proc/del_if_unanchored)
		START_PROCESSING(SSobj, src)
	else if(!anchored)
		STOP_PROCESSING(SSobj, src)

/obj/machinery/emp_protector/proc/malf_check(mob/living/user)
	if(!iscyborg(user))
		return FALSE
	var/mob/living/silicon/robot/R = user
	var/datum/antagonist/traitor/T = user.mind.has_antag_datum(/datum/antagonist/traitor)
	if(!T && R.connected_ai?.mind)
		T = R.connected_ai.mind.has_antag_datum(/datum/antagonist/traitor)
	if(T && T.traitor_kind == TRAITOR_AI)
		return TRUE
