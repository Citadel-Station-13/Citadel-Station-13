GLOBAL_LIST_EMPTY(ghostrole_spawnpoints)

/**
 * Spawnpoint for a ghostrole
 */
/datum/component/ghostrole_spawnpoint
	dupe_mode = COMPONENT_DUPE_ALLOWED
	can_transfer = TRUE
	/// allowed spawns
	var/max_spawns
	/// current spawns
	var/spawns = 0
	/// role type
	var/role_type
	/// params list
	var/list/params
	/// callback or proc type
	var/datum/callback/proc_to_call_or_callback
	/// custom HTML spawntext to show, if any
	var/spawntext

/datum/component/ghostrole_spawnpoint/Initialize(role_type, allowed_spawns = INFINITY, list/params, datum/callback/proc_to_call_or_callback, notify_ghosts = TRUE, spawntext)
	if((. = ..()) & COMPONENT_INCOMPATIBLE)
		return
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	max_spawns = allowed_spawns
	src.role_type = role_type
	src.params = params
	src.spawntext = spawntext
	src.proc_to_call_or_callback = proc_to_call_or_callback
	if(notify_ghosts)
		var/datum/ghostrole/role = get_ghostrole_datum(role_type)
		if(!role)
			return
		notify_ghosts("Ghostrole spawner created: [role.name] - [parent] - [get_area(parent)]", source = parent, ignore_mapload = TRUE, flashwindow = FALSE)

/datum/component/ghostrole_spawnpoint/RegisterWithParent()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_GHOST, .proc/GhostInteract)
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/Examine)
	RegisterGlobal()

/datum/component/ghostrole_spawnpoint/UnregisterFromParent()
	. = ..()
	UnregisterGlobal()

/datum/component/ghostrole_spawnpoint/PostTransfer()
	if(ispath(proc_to_call_or_callback) && !hascall(parent, proc_to_call_or_callback))
		stack_trace("[src] [parent] had a proc to call, [proc_to_call_or_callback], that is no longer valid after a component transfer. It will be removed. Please fix this!")
		proc_to_call_or_callback = null

/datum/component/ghostrole_spawnpoint/proc/RegisterGlobal()
	if(!islist(GLOB.ghostrole_spawnpoints[role_type]))
		GLOB.ghostrole_spawnpoints[role_type] = list(src)
	else
		GLOB.ghostrole_spawnpoints[role_type] |= src

/datum/component/ghostrole_spawnpoint/proc/UnregisterGlobal()
	GLOB.ghostrole_spawnpoints[role_type] -= src

/datum/component/ghostrole_spawnpoint/proc/Atom()
	RETURN_TYPE(/atom)
	return parent

/datum/component/ghostrole_spawnpoint/proc/Turf()
	RETURN_TYPE(/turf)
	return Atom().loc

/datum/component/ghostrole_spawnpoint/proc/SpawnsLeft(client/C)
	return max(0, max_spawns - spawns)

/datum/component/ghostrole_spawnpoint/proc/OnSpawn(mob/created, datum/ghostrole/role)
	if(istype(proc_to_call_or_callback))
		proc_to_call_or_callback.Invoke(created, role, params, src)
	spawns++
	if(ispath(proc_to_call_or_callback))
		if(!hascall(parent, proc_to_call_or_callback))
			CRASH("Invalid proc [proc_to_call_or_callback] on [parent]")
		call(parent, proc_to_call_or_callback)(created, role, params, src)

/datum/component/ghostrole_spawnpoint/vv_edit_var(var_name, var_value, massedit)
	if(var_name == NAMEOF(src, proc_to_call_or_callback))
		if(ispath(var_value) || istext(var_value))
			return FALSE		// security reasons, unwrapped proccall
	. = ..()

/datum/component/ghostrole_spawnpoint/proc/Examine(datum/source, list/examine_list)
	if(isobserver(source))
		var/datum/ghostrole/role = get_ghostrole_datum(role_type)
		if(!role)
			return
		examine_list += "<b>Click</> this ghostrole spawner to become a [role.name]!"

/datum/component/ghostrole_spawnpoint/proc/GhostInteract(datum/source, mob/user)
	var/datum/ghostrole/role = get_ghostrole_datum(role_type)
	if(!role)
		to_chat(user, span_danger("No ghostrole datum found: [role_type]. Contact a coder!"))
		if(!(datum_flags & DF_VAR_EDITED))
			stack_trace("Couldn't find role. Deleting self.")
			qdel(src)
		return
	role.AttemptSpawn(user.client, src)

/datum/component/ghostrole_spawnpoint/vv_edit_var(var_name, var_value, massedit)
	. = ..()
	if(var_name == NAMEOF(src, proc_to_call_or_callback))
		if(!istype(proc_to_call_or_callback, /datum/callback))
			if(hascall(parent, proc_to_call_or_callback))
				proc_to_call_or_callback = CALLBACK(parent, proc_to_call_or_callback)
			else
				proc_to_call_or_callback = null
