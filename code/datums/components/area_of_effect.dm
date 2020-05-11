/datum/component/area_of_effect
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/distance = 5
	var/range_or_view = "range"
	var/comsig_value
	var/return_value
	var/datum/callback/callback
	var/range_view_list
	var/range_view_turf_list = list()
	var/list/whitelist_typecache
	var/list/blacklist_typecache
	var/protect_self = TRUE

/datum/component/area_of_effect/Initialize(dist, r_or_v, comsig, value, _callback, whitelist, blacklist)
	. = ..()
	if(!isatom(parent) || isarea(parent) || !comsig || !(value || _callback))
		return COMPONENT_INCOMPATIBLE

	var/atom/source = parent
	distance = dist
	range_or_view = r_or_v
	comsig_value = comsig
	return_value = value
	callback = _callback
	whitelist_typecache = whitelist
	blacklist_typecache = blacklist

	range_view_list = (range_or_view == "range" ? range(distance, source) : view(distance, source))
	if(!protect_self)
		range_view_list -= src

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

/datum/component/area_of_effect/proc/on_atom_entered(turf/T, atom/movable/entered, atom/oldloc)
	if(entered == parent || (oldloc in range_view_turf_list))
		return
	if((whitelist_typecache && !whitelist_typecache[entered.type]) || (blacklist_typecache && blacklist_typecache[entered.type]))
		return
	RegisterSignal(entered,  comsig_value, .proc/return_value)
	range_view_list += entered

/datum/component/area_of_effect/proc/on_atom_exited(turf/source, atom/movable/exited, atom/newloc)
	if(exited == parent) //Reorganize the list of "protected" atoms
		var/list/L
		if(newloc && isturf(newloc)) //not nullspaced or bagged. Yea, quite a limitation for the latter, for now..
			L = (range_or_view == "range" ? range(distance, newloc) : view(distance, newloc))
			if(!protect_self)
				L -= src
		var/list/old_diff = range_view_list - L
		var/list/old_turf_diff = range_view_turf_list - L
		range_view_turf_list = list()
		var/list/turf_sigs = list(COMSIG_ATOM_ENTERED, COMSIG_ATOM_EXITED, COMSIG_TURF_CHANGE, COMSIG_ATOM_NEW_CONTENT)
		for(var/k in old_turf_diff)
			var/turf/T = k
			UnregisterSignal(T, turf_sigs)
		for(var/k in old_diff)
			var/atom/A = k
			UnregisterSignal(A, comsig_value)
		if(L) //not nullspaced
			var/list/new_diff = L - range_view_list
			for(var/turf/T in new_diff)
				RegisterSignal(T, COMSIG_ATOM_ENTERED, .proc/on_atom_entered)
				RegisterSignal(T, COMSIG_ATOM_EXITED, .proc/on_atom_exited)
				RegisterSignal(T, COMSIG_TURF_CHANGE, .proc/transfer_sigs)
				RegisterSignal(T, COMSIG_ATOM_NEW_CONTENT, .proc/on_new_content)
				range_view_turf_list += T
			for(var/k in new_diff)
				var/atom/A = k
				if((whitelist_typecache && !whitelist_typecache[A.type]) || (blacklist_typecache && blacklist_typecache[A.type]))
					L -= A
					continue
				RegisterSignal(A,  comsig_value, .proc/return_value)
		range_view_list = L
		return
	if(!(exited in range_view_list) || (newloc in range_view_turf_list))
		return
	UnregisterSignal(exited, comsig_value)

/datum/component/area_of_effect/proc/on_new_content(turf/T, atom/movable/A)
	if((whitelist_typecache && !whitelist_typecache[A.type]) || (blacklist_typecache && blacklist_typecache[A.type]))
		return
	RegisterSignal(new_mov,  comsig_value, .proc/return_value)
	range_view_list += new_mov

/datum/component/area_of_effect/proc/transfer_sigs(turf/T, path, list/new_baseturfs, flags, list/transferring_comps, list/callbacks)
	callbacks += CALLBACK(src, .proc/register_changed_turf, CHANGETURF_PROTOTYPE)
	range_view_turf_list -= T

/datum/component/area_of_effect/proc/register_changed_turf(turf/T)
	RegisterSignal(T, COMSIG_ATOM_ENTERED, .proc/on_atom_entered)
	RegisterSignal(T, COMSIG_ATOM_EXITED, .proc/on_atom_exited)
	RegisterSignal(T, COMSIG_TURF_CHANGE, .proc/transfer_sigs)
	RegisterSignal(T, COMSIG_ATOM_NEW_CONTENT, .proc/on_new_content)
	range_view_turf_list += T

/datum/component/area_of_effect/proc/return_value(atom/source)
	callback?.Invoke(source)
	return return_value

/obj/structure/range_test
	name = "Work in progress"
	desc = "AAAAAAAAAAAAAAAA!!"
	icon = 'icons/obj/objects.dmi'
	icon_state = "shieldon"

/obj/structure/range_test/LateInitialize()
	. = ..()
	AddComponent(/datum/component/area_of_effect, comsig = COMSIG_ATOM_EMP_ACT, value = EMP_PROTECT_CONTENTS|EMP_PROTECT_WIRES|EMP_PROTECT_SELF)
