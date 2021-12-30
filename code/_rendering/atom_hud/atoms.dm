/**
 * Registers us to all of our default HUD suppliers.
 */
/atom/proc/InitailizeHUDSuppliers()
	for(var/id in initial_hud_suppliers)
		var/datum/hud_supplier/H = SSatom_huds.GetSupplier(id)
		H.RegisterAtom(src)

/**
 * Create a blank HUD image slate - used by suppliers
 */
/atom/proc/MakeBlankHUDImage(icon_file = 'icons/screen/atom_hud.dmi', icon_state = "")
	var/image/I = image(icon_file, src, icon_state)
	I.appearance_flags = RESET_COLOR | RESET_TRANSFORM
	return I

/**
 * Manually queue HUD supplier updates
 */
/atom/proc/QueueHUDSuppliers(list/ids)
	if(!islist(ids))
		SSatom_huds.GetSupplier(ids)?.Update(src)
	else
		for(var/id in ids)
			var/datum/hud_supplier/H = SSatom_huds.GetSupplier(id)
			H.Update(src)
