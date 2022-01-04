/**
 * # HUD Suppliers
 *
 * HUD suppliers manage the actual HUD images for atom HUDs.
 * An atom HUD may show multiple suppliers.
 *
 * Each has an unique ID.
 * This ID is used to store its images in an atom's hud_images.
 */
/datum/hud_supplier
	/// Atoms that show this HUD
	var/list/atom/atoms = list()
	/// Clients that we're currently rendering to
	var/list/client/clients = list()
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

/datum/hud_supplier/New(id)
	if(isnull(src.id))
		src.id = id || ++id_next
	SSatom_huds.RegisterSupplier(src)

/datum/hud_supplier/Destroy()
	for(var/client/C as anything in clients)
		Hide(C, TRUE)
	for(var/atom/A in atoms)
		UnregisterAtom(A, TRUE)
	SSatom_huds.UnregisterSupplier(src)
	return ..()

/datum/hud_supplier/proc/RegisterAtom(atom/A, immediate)
	if(!A || (A in atoms))
		return
	if(!immediate)
		queue_add |= A
		queue_remove -= A
		Queue()
		return
	RegisterSignal(A, COMSIG_PARENT_QDELETING, .proc/AtomDel)
	LAZYINITLIST(A.hud_images)
	Update(A, TRUE)

/datum/hud_supplier/proc/UnregisterAtom(atom/A, immediate)
	if(!A || !(A in atoms))
		return
	if(!immediate)
		queue_remove |= A
		queue_add -= A
		queue_update -= A
		Queue()
		return
	UnregisterSignal(A, COMSIG_PARENT_QDELETING)
	for(var/client/C as anything in clients)
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
/datum/hud_supplier/proc/UpdateImage(atom/A, image/old)

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
/datum/hud_supplier/proc/UpdateList(atom/A, list/old)

/**
 * Updates an atom
 */
/datum/hud_supplier/proc/Update(atom/A, immediate)
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
			for(var/client/C as anything in clients)
				C.images -= existing
				C.images |= use
		if(HUD_ENTRY_LIST)
			var/list/existing = A.hud_images[id]
			var/list/use = UpdateList(A, islist(existing) && existing.Copy())
			for(var/client/C as anything in clients)
				C.images -= existing
				C.images |= use

/datum/hud_supplier/proc/Show(client/C, immediate)
	if(!C || (C in clients))
		return
	RegisterSignal(C, COMSIG_PARENT_QDELETING, .proc/ClientDel)
	clients |= C
	C.hud_suppliers_shown |= id
	for(var/atom/A as anything in atoms)
		C.images |= A.hud_images[id]

/datum/hud_supplier/proc/Hide(client/C, immediate)
	if(!M || !(C in clients))
		return
	UnregisterSignal(C, COMSIG_PARENT_QDELETING)
	clients -= C
	C.hud_suppliers_shown -= id
	for(var/atom/A as anything in atoms)
		C.images -= A.hud_images[id]

/datum/hud_supplier/proc/Refresh(client/C)
	if(!C || (!C in clients))
		return
	for(var/atom/A as anything in atoms)
		C.images |= A.hud_images[id]

/datum/hud_supplier/proc/Queue()
	if(queued)
		return
	addtimer(CALLBACK(src, .proc/Process), 0, TIMER_UNIQUE)
	queued = TRUE

/datum/hud_supplier/proc/Process()
	queued = FALSE
	if(queue_add)
		for(var/i in queue_add)
			RegisterAtom(i)
		queue_add.len = 0
	if(queue_remove)
		for(var/i in queue_remove)
			UnregisterAtom(i)
		queue_remove.len = 0
	if(queue_update.len)
		for(var/i in queue_update)
			Update(i, TRUE)
		queue_update.len = 0

/datum/hud_supplier/proc/AtomDel(atom/A)
	UnregisterAtom(A, TRUE)

/datum/hud_supplier/proc/ClientDel(client/C)
	Hide(C)
