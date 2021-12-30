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
	var/list/mob/queue_add = list()
	/// Queued to hide
	var/list/mob/queue_remove = list()
	/// Supplier IDs
	var/list/suppliers = list()
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
	SSatom_huds.RegisterHUD(src)

/datum/atom_hud/Destroy()
	queue_show = null
	queue_hide = null
	for(var/mob/M in users)
		Remove(M, TRUE)
	SSatom_huds.UnregisterHUD(src)
	return ..()

/datum/atom_hud/proc/Add(mob/M, immediate)
	if(!M || (M in viewing))
		return
	if(!immediate)
		queue_add += M
		queue_remove -= M
		Queue()
		return
	RegisterSignal(M, COMSIG_PARENT_QDELETING, .proc/MobDel)
	viewing |= M
	if(!M.client)
		return
	for(var/id in suppliers)
		if(id in M.client.hud_suppliers_shown)
			continue
		var/datum/hud_supplier/H = SSatom_huds.GetSupplier(id)
		H.Show(M.client)

/datum/atom_hud/proc/Remove(mob/M, immediate)
	if(!M || !(M in viewing))
		return
	if(!immediate)
		queue_remove += M
		queue_add -= M
		Queue()
		return
	UnregisterSignal(M, COMSIG_PARENT_QDELETING)
	viewing -= M
	if(!M.client)
		return
	var/list/removing = suppliers - M.NeededHUDSuppliers()
	for(var/id in removing)
		if(!(id in M.client.hud_suppliers_shown))
			continue
		var/datum/hud_supplier/H = SSatom_huds.GetSupplier(id)
		H.Hide(M.client)

/datum/atom_hud/proc/Refresh(mob/M)
	if(!M?.client || !(M in viewing))
		return
	for(var/id in suppliers)
		if(id in M.client.hud_suppliers_shown)
			continue
		var/datum/hud_supplier/H = SSatom_huds.GetSupplier(id)
		H.Show(M.client)

/datum/atom_hud/proc/Queue()
	if(queued)
		return
	addtimer(CALLBACK(src, .proc/Process), 0, TIMER_UNIQUE)
	queued = TRUE

/datum/atom_hud/proc/Process()
	queued = FALSE
	if(queue_add.len)
		for(var/i in queue_add)
			Add(i, TRUE)
		queue_add.len = 0
	if(queue_remove.len)
		for(var/i in queue_remove)
			Remove(i, TRUE)
		queue_remove.len = 0
