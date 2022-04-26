/atom/movable/landmark/spawnpoint
	name = "unknown spawnpoint"
	icon = 'icons/mapping/landmarks/spawnpoints.dmi'
	icon_state = ""
	/// prevent stacking of mobs
	var/prevent_mob_stack = TRUE
	/// Spawns left
	var/spawns_left = INFINITY
	/// Number of spawns currently
	var/spawned = 0
	/// Delete post-roundstart
	var/delete_after_roundstart = FALSE
	/// Delete on depletion
	var/delete_after_depleted = FALSE
	/// Priority - landmark is binary inserted on register/unregister. Lower numbers are higher priority.
	var/priority = 0

/atom/movable/landmark/spawnpoint/Initialize(mapload)
	Register()
	return ..()

/atom/movable/landmark/spawnpoint/Destroy()
	Unregister()
	return ..()

/atom/movable/landmark/spawnpoint/forceMove(atom/destination)
	Unregister()
	. = ..()
	Register()

/atom/movable/landmark/spawnpoint/vv_edit_var(var_name, var_value, massedit)
	if(var_name == NAMEOF(src, priority))
		Unregister()
	. = ..()
	if(var_name == NAMEOF(src, priority))
		Register()


/atom/movable/landmark/spawnpoint/proc/Register()
	return

/atom/movable/landmark/spawnpoint/proc/Unregister()
	return

/atom/movable/landmark/spawnpoint/proc/AutoListRegister(list/L)
	if(src in L)
		return
	BINARY_INSERT(src, L, /atom/movable/landmark/spawnpoint, src, priority, COMPARE_KEY)

/atom/movable/landmark/spawnpoint/proc/AutoListUnregister(list/L)
	if(!L)
		return
	L -= src

/**
 * Gets the spawn location of this spawnpoint
 * This should usually be underneath it, as this is where the mob will be created/moved.
 */
/atom/movable/landmark/spawnpoint/proc/GetSpawnLoc()
	if(!loc)
		stack_trace("Landmark: Null loc detected on GetSpawnLoc().")
	return loc

/**
 * Called after the mob is created/moved to the spawnpoint.
 *
 * @params
 * - M - the mob that was spawned
 * - C - (optional) - the client of the player
 */
/atom/movable/landmark/spawnpoint/proc/OnSpawn(mob/M, client/C)
	spawns_left = max(0, spawns_left - 1)
	++spawned

/**
 * Called to check if this spawnpoint is available for a certain mob and client
 *
 * @params
 * - M - (optional) - the mob being spawned. This is null during latejoins and other instances where the mob is
 * 		made when there is a spawnpoint, as opposed to roundstart creating all mobs at once
 * - C - (optional) - the client of the player
 * - harder - ignore checks like prevent_mob_stack
 */
/atom/movable/landmark/spawnpoint/proc/Available(mob/M, client/C, harder = FALSE)
	if(!spawns_left)
		return FALSE
	if(prevent_mob_stack && M && !harder)
		if(ishuman(M) && (locate(/mob/living/carbon/human) in GetSpawnLoc()))
			return FALSE
		else if(locate(M.type) in GetSpawnLoc())
			return FALSE
	return TRUE

/**
 * Used first priority for job spawning
 */
/atom/movable/landmark/spawnpoint/job
	name = "unknown job spawnpoint"
	icon = 'icons/mapping/landmarks/job_spawnpoints.dmi'
	spawns_left = 1
	/// Job path
	var/job_path
	/// Roundstart?
	var/roundstart = TRUE
	/// Latejoin?
	var/latejoin = FALSE
	/// Latejoin method - if there's more than one registered method available, a player may choose which one to use
	var/method = LATEJOIN_METHOD_DEFAULT
	/// Overrides all latejoin spawnpoints even if methods mismatch
	var/latejoin_override = FALSE

/atom/movable/landmark/spawnpoint/job/Register()
	. = ..()
	if(!job_path)
		return
	LAZYINITLIST(SSjob.job_spawnpoints)
	LAZYINITLIST(SSjob.job_spawnpoints[job_path])
	AutoListRegister(SSjob.job_spawnpoints[job_path])

/atom/movable/landmark/spawnpoint/job/Unregister()
	. = ..()
	if(!job_path)
		return
	AutoListUnregister(SSjob.job_spawnpoints[job_path])

/atom/movable/landmark/spawnpoint/job/vv_edit_var(var_name, var_value, massedit)
	if(var_name == NAMEOF(src, job_path))
		Register()
	. = ..()
	if(var_name == NAMEOF(src, job_path))
		Unregister()

/**
 * Used when there's no job specific latejoin spawnpoints
 */
/atom/movable/landmark/spawnpoint/latejoin
	name = "unknown latejoin spawnpoint"
	/// Faction
	var/faction
	/// Method - if there's more than one registered method available, a player may choose which one to use
	var/method = LATEJOIN_METHOD_DEFAULT

/atom/movable/landmark/spawnpoint/latejoin/Register()
	. = ..()
	if(!faction)
		return
	LAZYINITLIST(SSjob.latejoin_spawnpoints)
	LAZYINITLIST(SSjob.latejoin_spawnpoints[faction])
	AutoListRegister(SSjob.latejoin_spawnpoints[faction])

/atom/movable/landmark/spawnpoint/latejoin/Unregister()
	. = ..()
	if(!faction)
		return
	AutoListUnregister(SSjob.latejoin_spawnpoints[faction])

/atom/movable/landmark/spawnpoint/latejoin/vv_edit_var(var_name, var_value, massedit)
	if(var_name == NAMEOF(src, faction))
		Register()
	. = ..()
	if(var_name == NAMEOF(src, faction))
		Unregister()

/**
 * Used when all other spawnpoints are unavailable
 */
/atom/movable/landmark/spawnpoint/overflow
	name = "unknown overflow spawnpoint"
	/// Faction
	var/faction

/atom/movable/landmark/spawnpoint/overflow/Register()
	. = ..()
	if(!faction)
		return
	LAZYINITLIST(SSjob.overflow_spawnpoints)
	LAZYINITLIST(SSjob.overflow_spawnpoints[faction])
	AutoListRegister(SSjob.overflow_spawnpoints[faction])

/atom/movable/landmark/spawnpoint/overflow/Unregister()
	. = ..()
	if(!faction)
		return
	AutoListUnregister(SSjob.overflow_spawnpoints[faction])

/atom/movable/landmark/spawnpoint/overflow/vv_edit_var(var_name, var_value, massedit)
	if(var_name == NAMEOF(src, faction))
		Register()
	. = ..()
	if(var_name == NAMEOF(src, faction))
		Unregister()

/**
 * Custom keyed list spawnpoint supplier
 */
/atom/movable/landmark/spawnpoint/custom
	name = "unknown custom spawnpoint"
	/// Key
	var/key

/atom/movable/landmark/spawnpoint/custom/Register()
	. = ..()
	if(!key)
		return
	LAZYINITLIST(SSjob.custom_spawnpoints)
	LAZYINITLIST(SSjob.custom_spawnpoints[key])
	AutoListRegister(SSjob.custom_spawnpoints[key])

/atom/movable/landmark/spawnpoint/custom/Unregister()
	. = ..()
	if(!key)
		return
	AutoListUnregister(SSjob.custom_spawnpoints[key])

/atom/movable/landmark/spawnpoint/custom/vv_edit_var(var_name, var_value, massedit)
	if(var_name == NAMEOF(src, key))
		Register()
	. = ..()
	if(var_name == NAMEOF(src, key))
		Unregister()
