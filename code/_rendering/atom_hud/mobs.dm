/**
 * Add HUD
 */
/mob/proc/AddAtomHUD(id, source = HUD_SOURCE_ADMINBUS)
	if(atom_huds[id])
		atom_huds[id] |= source
		return
	atom_huds[id] = list(source)
	var/datum/atom_hud/H = SSatom_huds.GetHUD(id)
	if(!H)
		return
	H.Show(src)

/**
 * Remove HUD
 */
/mob/proc/RemoveAtomHUD(id, source)
	if(!atom_huds[id])
		return
	atom_huds[id] -= source
	if(length(atom_huds[id]))
		return
	atom_huds -= id
	var/datum/atom_hud/H = SSatom_huds.GetHUD(id)
	if(!H)
		return
	H.Hide(src)

/**
 * Reapply HUD images, usually done on login
 */
/mob/proc/ReloadAtomHUDs()
	for(var/id in atom_huds)
		var/datum/atom_hud/H = SSatom_huds.GetHUD(id)
		if(!H)
			continue
		H.Refresh(src)

/**
 * Wipe HUD images without removing the HUDs, usually done on logout
 *
 * This directly targets the client because removal logic checks for HUD being on the mob, and we aren't actually removing the HUDs.
 */
/mob/proc/CleanupAtomHUDs()
	if(!client)
		return
	for(var/id in client.hud_suppliers_shown)
		var/datum/hud_supplier/H = SSatom_huds.GetSupplier(id)
		if(!H)
			continue
		H.Hide(client)

/**
 * Check what HUD suppliers we need
 */
/mob/proc/NeededHUDSuppliers()
	. = list()
	for(var/id in atom_huds)
		var/datum/atom_hud/H = SSatom_huds.GetHUD(id)
		if(!H)
			continue
		. |= H.suppliers

/**
 * Add innate atom HUDs
 */
/mob/proc/initialize_innate_atom_huds()
	for(var/id in innate_atom_huds)
		AddAtomHUD(id, HUD_SOURCE_INNATE)
