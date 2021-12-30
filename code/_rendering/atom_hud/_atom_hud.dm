/**
 * # Atom HUDs
 *
 * Atom HUDs are used to overlay images on mobs.
 *
 * Each has an unique ID.
 * This ID is used to store its images in a mob's hud_images.
 */
/datum/atom_hud
	/// Atoms that show this HUD
	var/list/atom/atoms = list()
	/// Users that see this HUD
	var/list/mob/users = list()
	/// Queued to show
	var/list/mob/queue_show
	/// Queued to hide
	var/list/mob/queue_hide
	/// Queued to add
	var/list/atom/queue_add
	/// Queued to remove
	var/list/atom/queue_remove
	/// Queued to update
	var/list/atom/queue_update
	/// Queue flush queued?
	var/queued = FALSE
	/// unique ID
	var/id
	/// next automated ID
	var/static/id_next = 0
	/// Entry type - this affects what functions are called
	var/entry_type

/datum/atom_hud/New(id)
	src.id = id || ++id_next
	SSatom_huds.Register(src)

/datum/atom_hud/Destroy()
	queue_show = null
	queue_hide = null
	for(var/mob/M in users)
		Hide(M, TRUE)
	for(var/atom/A in atoms)
		UnregisterAtom(A, TRUE)
	SSatom_huds.Unregister(src)
	return ..()

/datum/atom_hud/proc/RegisterAtom(atom/A, immediate)
	if(!immediate)
		LAZYOR(queue_add, A)
		LAZYREMOVE(queue_remove, A)
		Queue()
		return
	RegisterSignal(A, COMSIG_PARENT_QDELETING, .proc/AtomDel, TRUE)

/datum/atom_hud/proc/UnregisterAtom(atom/A, immediate)
	if(!immediate)
		LAZYOR(queue_remove, A)
		LAZYREMOVE(queue_add, A)
		Queue()
		return
	UnregisterSignal(A, COMSIG_PARENT_QDELETING)


/**
 * Called to update our entry in an atom's HUD images list.
 *
 * Only used if entry_type is HUD_ENTRY_IMAGE
 *
 * The return value is used as the new image.
 *
 * @params
 * - A - atom
 * - old - what was there before
 */
/datum/atom_hud/proc/UpdateList(atom/A, image/old)

/**
 * Called to update our list in an atom's HUD images list.
 *
 * Only used if entry_type is HUD_ENTRY_LIST
 *
 * The return value is used as the new list
 *
 * @params
 * - A - atom
 * - old - what was there before
 */
/datum/atom_hud/proc/UpdateList(atom/A, list/old)

/**
 * Updates an atom
 */
/datum/atom_hud/proc/Update(atom/A, immediate)
	if(!immediate)
		LAZYOR(queue_add)
		Queue()
		return
	switch(entry_type)
		if(HUD_ENTRY_IMAGE)

		if(HUD_ENTRY_LIST)

/datum/atom_hud/proc/Show(mob/M, immediate)
	if(!immediate)
		LAZYOR(queue_show)
		LAZYREMOVE(queue_hide, M))
		Queue()
		return
	RegisterSignal(M, COMSIG_PARENT_QDELETING, .proc/AtomDel, TRUE)


/datum/atom_hud/proc/Hide(mob/M, immediate)
	if(!immediate)
		LAZYOR(queue_hide)
		LAZYREMOVE(queue_show, M)
		Queue()
		return
	UnregisterSignal(M, COMSIG_PARENT_QDELETING)
	for(var/atom/A as )

/datum/atom_hud/proc/Queue()
	if(queued)
		return
	addtimer(CALLBACK(src, .proc/Process), 0, TIMER_UNIQUE)
	queued = TRUE

/datum/atom_hud/proc/Process()
	queued = FALSE
	if(LAZYLEN(queue_show))
		for(var/i in queue_show)
			Show(i, TRUE)
	if(LAZYLEN(queue_hide))
		for(var/i in queue_hide)
			Hide(i, TRUE)
	if(LAZYLEN(queue_add))
		for(var/i in queue_add)
			RegisterAtom(i)
	if(LAZYLEN(queue_remove))
		for(var/i in queue_remove)
			UnregisterAtom(i)
	if(LAZYLEN(queue_update))
		for(var/i in queue_update)
			Update(i, TRUE)

/datum/atom_hud/proc/AtomDel(atom/A)
	Hide(A, TRUE)
	UnregisterAtom(A, TRUE)

/datum/atom_hud/proc/remove_hud_from(mob/M)
	if(!M || !hudusers[M])
		return
	if (!--hudusers[M])
		hudusers -= M
		if(queued_to_see[M])
			queued_to_see -= M
		else
			for(var/atom/A in hudatoms)
				remove_from_single_hud(M, A)

/datum/atom_hud/proc/remove_from_hud(atom/A)
	if(!A)
		return FALSE
	for(var/mob/M in hudusers)
		remove_from_single_hud(M, A)
	hudatoms -= A
	return TRUE

/datum/atom_hud/proc/remove_from_single_hud(mob/M, atom/A) //unsafe, no sanity apart from client
	if(!M || !M.client || !A)
		return
	for(var/i in hud_icons)
		M.client.images -= A.hud_list[i]

/datum/atom_hud/proc/add_hud_to(mob/M)
	if(!M)
		return
	if(!hudusers[M])
		hudusers[M] = 1
		if(next_time_allowed[M] > world.time)
			if(!queued_to_see[M])
				addtimer(CALLBACK(src, .proc/show_hud_images_after_cooldown, M), next_time_allowed[M] - world.time)
				queued_to_see[M] = TRUE
		else
			next_time_allowed[M] = world.time + ADD_HUD_TO_COOLDOWN
			for(var/atom/A in hudatoms)
				add_to_single_hud(M, A)
	else
		hudusers[M]++

/datum/atom_hud/proc/show_hud_images_after_cooldown(M)
	if(queued_to_see[M])
		queued_to_see -= M
		next_time_allowed[M] = world.time + ADD_HUD_TO_COOLDOWN
		for(var/atom/A in hudatoms)
			add_to_single_hud(M, A)

/datum/atom_hud/proc/add_to_hud(atom/A)
	if(!A)
		return FALSE
	hudatoms |= A
	for(var/mob/M in hudusers)
		if(!queued_to_see[M])
			add_to_single_hud(M, A)
	return TRUE

/datum/atom_hud/proc/add_to_single_hud(mob/M, atom/A) //unsafe, no sanity apart from client
	if(!M || !M.client || !A)
		return
	for(var/i in hud_icons)
		if(A.hud_list[i])
			M.client.images |= A.hud_list[i]

//MOB PROCS
/mob/proc/reload_huds()
	for(var/datum/atom_hud/hud in GLOB.all_huds)
		if(hud && hud.hudusers[src])
			for(var/atom/A in hud.hudatoms)
				hud.add_to_single_hud(src, A)

/mob/dead/new_player/reload_huds()
	return

