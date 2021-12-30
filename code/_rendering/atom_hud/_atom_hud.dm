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
	var/list/mob/viewing = list()
	/// Queued to show
	var/list/mob/queue_show = list()
	/// Queued to hide
	var/list/mob/queue_hide = list()
	/// Queued to add
	var/list/atom/queue_add = list()
	/// Queued to remove
	var/list/atom/queue_remove = list()
	/// Queued to update
	var/list/atom/queue_update = list()
	/// Queue flush queued?
	var/queued = FALSE
	/// unique ID
	var/id
	/// next automated ID
	var/static/id_next = 0
	/// Entry type - this affects what functions are called
	var/entry_type

/datum/atom_hud/New(id)
	if(isnull(src.id))
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
		queue_add |= A
		queue_remove -= A
		Queue()
		return
	RegisterSignal(A, COMSIG_PARENT_QDELETING, .proc/AtomDel, TRUE)
	LAZYINITLIST(A.hud_images)
	Update(A, TRUE)

/datum/atom_hud/proc/UnregisterAtom(atom/A, immediate)
	if(!immediate)
		queue_remove |= A
		queue_add -= A
		queue_update -= A
		Queue()
		return
	if(!(A in viewing))
		UnregisterSignal(A, COMSIG_PARENT_QDELETING)
	for(var/mob/M as anything in viewing)
		if(!M.client)
			continue
		M.client.images -= A.hud_images[id]
	LAZYREMOVE(A.hud_images, id)

/**
 * Called to update our entry in an atom's HUD images list.
 *
 * Only used if entry_type is HUD_ENTRY_IMAGE
 *
 * The return value is used as the new image.
 *
 * Note: This proc is very optimized if you act in-place on an image rather than return a new one.
 *
 * @params
 * - A - atom
 * - old - what was there before
 */
/datum/atom_hud/proc/UpdateImage(atom/A, image/old)

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
			var/image/existing = A.hud_images[id]
			var/image/use = UpdateImage(A, existing)
			if(existing == use)
				return
			for(var/mob/M as anything in viewing)
				if(!M.client)
					continue
				M.client.images -= existing
				M.client.images |= use
		if(HUD_ENTRY_LIST)
			var/list/existing = A.hud_images[id]
			var/list/use = UpdateList(A, existing)
			for(var/mob/M as anything in viewing)
				if(!M.client)
					continue
				M.client.images -= existing
				M.client.images |= use

/datum/atom_hud/proc/Show(mob/M, immediate)
	if(!immediate)
		LAZYOR(queue_show)
		LAZYREMOVE(queue_hide, M))
		Queue()
		return
	RegisterSignal(M, COMSIG_PARENT_QDELETING, .proc/AtomDel, TRUE)
	viewing |= M
	if(!M.client)
		return
	for(var/atom/A as anything in atoms)
		M.client.images |= A.hud_images[id]

/datum/atom_hud/proc/Hide(mob/M, immediate)
	if(!immediate)
		LAZYOR(queue_hide)
		LAZYREMOVE(queue_show, M)
		Queue()
		return
	if(!(M in atoms))
		UnregisterSignal(M, COMSIG_PARENT_QDELETING)
	viewing -= M
	if(!M.client)
		return
	for(var/atom/A as anything in atoms)
		M.client.images -= A.hud_images[id]

/datum/atom_hud/proc/Refresh(mob/M)
	if(!M.client)
		return
	for(var/atom/A as anything in atoms)
		M.client.images |= A.hud_images[id]

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
