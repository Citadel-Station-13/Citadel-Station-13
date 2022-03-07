/datum/unit_test/map_template_paths/Run()
	for(var/path in subtypesof(/datum/map_template))
		var/datum/map_template/T = path
		if(initial(T.abstract_type) == path)
			continue
		var/potential_path
		if(initial(T.mappath))
			potential_path = initial(T.mappath)
		else if(initial(T.prefix) && initial(T.suffix))
			potential_path = initial(T.prefix) + initial(T.suffix)
		if(!potential_path)
			continue
		if(!fexists(potential_path))
			Fail("[path]'s path, [potential_path], could not be found.")
