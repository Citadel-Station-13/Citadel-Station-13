/**
 * Prefabs
 *
 * Map templates loaded in by prefab landmarks
 */
/datum/map_template/prefab
	/// prefab group/type id
	var/group_id

/**
 * Prefab landmarks
 *
 * Used to load in a prefab map template of a certain group with x probability
 */
/obj/effect/landmark/prefab_loader
	name = "prefab loader"
	/// group ID used to fetch what prefab templates we're using
	var/group_id
	/// load orientation
	var/orientation = SOUTH
	/// template id to number - preseed probabilities - MAPPERS ONLY
	VAR_FINAL/probability_paramslist
	/// annihilate bounds to pass in
	var/annihilate = FALSE

/obj/effect/landmark/prefab_loader/Initialize(mapload)
	name = "prefab loader: \"[group_id]\""
	if(!mapload)
		return ..()
	if(!loaded && !(flags_1 &))
		Load()

/**
 * returns template IDs in a list
 */
/obj/effect/landmark/prefab_loader/proc/GetTemplate()
	return SSmapping.prefab_groups[group_id] || list()

/obj/effect/landmark/prefab_loader/proc/Load()
	if(!group_id)
		return
	var/datum/map_template/template = SSmapping.TemplateByID(PickTemplate())
	template.load(get_turf(src), TRUE, orientation, annihilate, FALSE)

/obj/effect/landmark/prefab_loader/proc/PickTemplate()
	var/list/templates = GetTemplate()
	var/list/weighted = list()
	for(var/i in templates)
		weighted[i] = w
	if(probability_paramslist)
		var/list/prob = params2list(probability_paramslist)
		if(islist(prob))
			for(var/i in prob)
				i = lowertext(i)
				if(templates.Find(i))
					templates[i] = prob[i]
	return pickweight(weighted, 0)

/obj/effect/landmark/prefab_loader/proc/GetOrientation()
	return orientation
