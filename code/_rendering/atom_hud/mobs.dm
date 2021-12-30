/**
 * Add HUD
 */
/mob/proc/AddAtomHUD(id, source = HUD_SOURCE_ADMINBUS)
	if(atom_huds_shown[id])
		atom_huds_shown[id] |= source
		return
	atom_huds_shown[id] = list(source)
	var/datum/atom_hud/H = SSatom_huds.Get(id)
	if(!H)
		return
	H.Show(src)

/**
 * Remove HUD
 */
/mob/proc/RemoveAtomHUD(id, source)
	if(!atom_huds_shown[id])
		return
	atom_huds_shown[id] -= source
	if(length(atom_huds_shown[id]))
		return
	atom_huds_shown -= id
	var/datum/atom_hud/H = SSatom_huds.Get(id)
	if(!H)
		return
	H.Hide(src)

/**
 * Reapply HUD images, usually done on login
 */
/mob/proc/ReloadAtomHUDs()
	for(var/id in atom_huds_shown)
		var/datum/atom_hud/H = SSatom_huds.Get(id)
		if(!H)
			continue
		H.Refresh(src)
