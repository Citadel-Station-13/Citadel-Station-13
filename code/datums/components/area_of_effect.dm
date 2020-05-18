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

/datum/component/area_of_effect/Initialize(dist = 5, r_or_v = "range", comsig, value, whitelist, blacklist, self = TRUE)
	. = ..()
	if(!isatom(parent) || isarea(parent) || !comsig)
		return COMPONENT_INCOMPATIBLE

	distance = dist
	range_or_view = r_or_v
	comsig_value = comsig
	return_value = value
	whitelist_typecache = whitelist
	blacklist_typecache = blacklist
	protect_self = self

	range_view_list = (range_or_view == "range" ? range(distance, parent) : view(distance, parent))
	if(!protect_self)
		range_view_list -= parent

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
	if(entered == parent || (oldloc in range_view_turf_list))
		return
	if((whitelist_typecache && !whitelist_typecache[entered.type]) || (blacklist_typecache && blacklist_typecache[entered.type]))
		return
	RegisterSignal(entered,  comsig_value, .proc/return_value)
	range_view_list += entered

/datum/component/area_of_effect/proc/on_atom_exited(turf/source, atom/movable/exited, atom/newloc)
	if(exited != parent)
		if((exited in range_view_list) && !(newloc in range_view_turf_list))
			UnregisterSignal(exited, comsig_value)
		return

	var/list/L
	if(newloc && isturf(newloc)) //not nullspaced or bagged. Yea, quite a limitation for the latter, as of now..
		L = (range_or_view == "range" ? range(distance, newloc) : view(distance, newloc))
		if(!protect_self)
			L -= src
	var/list/old_diff = range_view_list - L
	var/list/old_turf_diff = range_view_turf_list - L
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
	if(L)
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

/obj/structure/machinery/emp_protector
	name = "\improper EMP dissipator"
	desc = "A special rod machinery meant to dissipate electromagnetic pulses over a large area."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shieldon"
	anchored = TRUE
	density = TRUE
	var/obj/effect/overlay/tile_visual

/obj/structure/machinery/emp_protector/ComponentInitialize()
	. = ..()
	tile_visual = new
	tile_visual.icon = 'icons/effects/effects.dmi'
	tile_visual.icon_state = "tile_shield"
	tile_visual.color = "#0000FFAA" //Blue with 170 alpha.
	RegisterSignal(src, COMSIG_AOE_RANGE_CALCULATED, .proc/apply_visual)
	RegisterSignal(src, COMSIG_AOE_TURF_CHANGED, .proc/aoe_turf_change)
	if(anchored)
		AddComponent(/datum/component/area_of_effect, dist = 2, comsig = COMSIG_ATOM_EMP_ACT, value = EMP_PROTECT_CONTENTS|EMP_PROTECT_WIRES|EMP_PROTECT_SELF)

/obj/structure/machinery/emp_protector/proc/apply_visual(datum/component/area_of_effect/source, list/old_targets, list/old_turfs, list/new_targets, list/new_turfs)
	for(var/A in old_turfs)
		var/turf/T = A
		T.vis_contents -= tile_visual
	for(var/A in new_turfs)
		var/turf/T = A
		T.vis_contents += tile_visual

/obj/structure/machinery/emp_protector/proc/aoe_turf_change(datum/component/area_of_effect/source, turf/T)
	T.vis_contents += tile_visual

/obj/structure/machinery/emp_protector/examine(mob/user)
	. = ..()
	var/slow = FALSE
	if(!malf_check(user))
		slow = TRUE
	. += "<span class='notice'>You can use a <b>wrench</b> to toggle the anchors[slow ? ", albeit it takes some time" : ", fast"].</span>"

/obj/structure/machinery/emp_protector/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	var/time = 10 SECONDS
	if(malf_check(user))
		time = 2 SECONDS
	if(default_unfasten_wrench(user, I, time) != CANT_UNFASTEN)
		if(anchored)
			AddComponent(/datum/component/area_of_effect, dist = 2, comsig = COMSIG_ATOM_EMP_ACT, value = EMP_PROTECT_CONTENTS|EMP_PROTECT_WIRES|EMP_PROTECT_SELF)
		else
			var/datum/component/area_of_effect/AoE = GetComponent(/datum/component/area_of_effect)
			qdel(AoE)
		return TRUE

/obj/structure/machinery/emp_protector/proc/malf_check(mob/living/user)
	if(!iscyborg(user))
		return FALSE
	var/mob/living/silicon/robot/R = user
	var/datum/antagonist/traitor/T = user.mind.has_antag_datum(/datum/antagonist/traitor)
	if(!T && R.connected_ai?.mind)
		T = R.connected_ai.mind.has_antag_datum(/datum/antagonist/traitor)
	if(T && T.traitor_kind == TRAITOR_AI)
		return TRUE
