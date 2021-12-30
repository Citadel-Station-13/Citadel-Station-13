// Subsystem to track atom HUDs
SUBSYSTEM_DEF(atom_huds)
	name = "Atom HUDs"
	flags = SS_NO_FIRE
	/// all HUDs
	var/list/datum/atom_hud/huds
	/// hud by id
	var/list/hud_by_id

/datum/controller/subsystem/atom_huds/proc/Get(id_or_path)
	if(huds_by_id[id_or_path])
		return huds_by_id[id_or_path]
	if(ispath(id_or_path, /datum/atom_hud))
		var/datum/atom_hud/H = new id_or_path
		return huds_by_id[id_or_path]		// it should register on New() if it doesn't uhh skill issue on the coder's part

/datum/controller/subsystem/atom_huds/proc/Register(datum/atom_hud/H)
	if(huds_by_id[H.id])
		stack_trace("Duplicate HUD id [H.id] detected ; refusing to register.")
		return FALSE
	huds += H
	huds_by_id[H.id] = H
	return TRUE

/datum/controller/subsystem/atom_huds/proc/Unregister(datum/atom_hud/H)
	hud_by_id -= H.id
	huds -= H
	return TRUE
