/**
 * # Atom HUDs
 *
 * Atom HUDs are used to overlay images on mobs.
 *
 * Each has an unique ID.
 * This ID is used to store its images in a mob's hud_images.
 */
/datum/atom_hud
	/// Users that see this HUD
	var/list/mob/viewing = list()
	/// Queued to show
	var/list/mob/queue_show = list()
	/// Queued to hide
	var/list/mob/queue_hide = list()
	/// Supplier IDs


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


/datum/atom_hud/proc/Show(mob/M, immediate)
	if(!M)
		return
	if(!immediate)
		queue_show += M
		queue_hide -= M
		Queue()
		return
	RegisterSignal(M, COMSIG_PARENT_QDELETING, .proc/AtomDel, TRUE)
	viewing |= M
	if(!M.client)
		return
	for(var/atom/A as anything in atoms)
		M.client.images |= A.hud_images[id]

/datum/atom_hud/proc/Hide(mob/M, immediate)
	if(!M)
		return
	if(!immediate)
		queue_hide += M
		queue_show -= M
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
	if(queue_show.len)
		for(var/i in queue_show)
			Show(i, TRUE)
		queue_show.len = 0
	if(queue_hide.len)
		for(var/i in queue_hide)
			Hide(i, TRUE)
		queue_hdie.len = 0
