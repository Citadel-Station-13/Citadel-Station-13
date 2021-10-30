GLOBAL_LIST_EMPTY(rig_themes)

/proc/get_rig_theme_datum(path)
	if(GLOB.rig_themes[path])
		return GLOB.rig_themes[path]
	if(ispath(path))
		GLOB.rig_themes[path] = new path
		return GLOB.rig_themes[path]
	return null			// yes, this intentionally allows text for adminbus purposes.

/proc/instantiate_all_rig_themes()
	. = list()
	for(var/path in typesof(/datum/rig_theme))
		.[path] = new path

/**
 * Baseline for what rigs are, in terms of their properties
 */
/datum/rig_theme
	/// name
	var/name = "Default"
	/// name appended to items
	var/name_prepend = "default rigsuit"



