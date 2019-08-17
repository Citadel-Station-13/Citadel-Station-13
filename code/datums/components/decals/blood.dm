/datum/component/decal/blood
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/decal/blood/Initialize(_icon, _icon_state, _dir, _cleanable=CLEAN_STRENGTH_BLOOD, _color, _layer=ABOVE_OBJ_LAYER)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_GET_EXAMINE_NAME, .proc/get_examine_name)

/datum/component/decal/blood/proc/get_examine_name(datum/source, mob/user, list/override)
	var/atom/A = parent

	return COMPONENT_EXNAME_CHANGED
