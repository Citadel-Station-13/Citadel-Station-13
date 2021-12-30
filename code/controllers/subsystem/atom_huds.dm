// Subsystem to track atom HUDs
SUBSYSTEM_DEF(atom_huds)
	name = "Atom HUDs"
	flags = SS_NO_FIRE
	/// all HUDs
	var/list/datum/atom_hud/huds
	/// hud by id
	var/list/hud_by_id
	/// all HUd suppliers
	var/list/datum/hud_supplier/suppliers
	/// hud suppliers by id
	var/list/supplier_by_id

/datum/controller/subsystem/atom_huds/proc/GetHUD(id_or_path)
	if(huds_by_id[id_or_path])
		return huds_by_id[id_or_path]
	if(ispath(id_or_path, /datum/atom_hud))
		var/datum/atom_hud/H = new id_or_path
		return huds_by_id[id_or_path]		// it should register on New() if it doesn't uhh skill issue on the coder's part

/datum/controller/subsystem/atom_huds/proc/RegisterHUD(datum/atom_hud/H)
	if(huds_by_id[H.id])
		stack_trace("Duplicate atom HUD id [H.id] detected ; refusing to register.")
		return FALSE
	huds += H
	huds_by_id[H.id] = H
	return TRUE

/datum/controller/subsystem/atom_huds/proc/UnregisterHUD(datum/atom_hud/H)
	hud_by_id -= H.id
	huds -= H
	return TRUE

/datum/controller/subsystem/atom_huds/proc/GetSupplier(id_or_path)
	if(suppliers_by_id[id_or_path])
		return suppliers_by_id[id_or_path]
	if(ispath(id_or_path, /datum/hud_supplier))
		var/datum/hud_supplier/H = new id_or_path
		return suppliers_by_id[id_or_path]		// it should register on New() if it doesn't uhh skill issue on the coder's part

/datum/controller/subsystem/atom_huds/proc/RegisterSupplier(datum/hud_supplier/H)
	if(suppliers_by_id[H.id])
		stack_trace("Duplicate HUD supplier id [H.id] detected ; refusing to register.")
		return FALSE
	huds += H
	suppliers_by_id[H.id] = H
	return TRUE

/datum/controller/subsystem/atom_huds/proc/UnregisterSupplier(datum/hud_supplier/H)
	suppliers_by_id -= H.id
	huds -= H
	return TRUE
