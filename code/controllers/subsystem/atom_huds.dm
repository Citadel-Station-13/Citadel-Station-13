// Subsystem to track atom HUDs
SUBSYSTEM_DEF(atom_huds)
	name = "Atom HUDs"
	flags = SS_NO_FIRE
	/// all HUDs
	var/list/datum/atom_hud/huds
	/// hud by id
	var/list/hud_by_id

/datum/controller/subsystem
