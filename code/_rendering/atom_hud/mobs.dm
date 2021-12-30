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
 */
/mob/proc/CleanupAtomHUDs()
	for(var/id in atom_huds)
		var/datum/atom_hud/H = SSatom_huds.GetHUD(id)
		if(!H)
			continue
		H.Cleanup(src)
