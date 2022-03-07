/datum/unit_test/map_levels/Run()
	var/list/datum/map_config/datums = list()
	for(var/id in SSmapping.map_datums)
		datums += SSmapping.map_datums[id]
	for(var/group in SSmapping.level_datums)
		for(var/id in SSmapping.level_datums[group])
			datums += SSmapping.level_datums[group][id]
	for(var/datum/map_datum/D as anything in datums)
		if(!istype(D))
			Fail("None datum [D]")
			continue
		if(D.errored)
			Fail("[D] ([D.original_path]) errored.")
			continue
		if(!D.id)
			Fail("[D] no ID ([D.original_path]).")
			continue
		for(var/datum/space_level/S as anything in D.levels)
			if(!istype(S))
				Fail("Unknown [S] in [D.id] levels.")
				continue
			if(!fexists(S.GetPath()))
				Fail("File not found: [S.GetPath()] on [D.original)path] [D.id].")
				continue
			var/datum/parse_map/map = new(S.GetPath())
			var/width = map.parsed_bounds[MAP_MAXX] - map.parsed_bounds[MAP_MINX] + 1
			var/height = map.parsed_bounds[MAP_MAXY] - map.parsed_bounds[MAP_MINY] + 1
			if(width != D.width)
				Fail("Mismatching width [width], expected [D.width].")
				continue
			if(height != D.height)
				Fail("Mismatching height [height], expected [D.height].")
				continue
