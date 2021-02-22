/datum/experiment/scanning/random/material
	name = "Material Scanning Experiment"
	description = "Base experiment for scanning atoms with materials"
	exp_tag = "Material Scan"
	total_requirement = 8
	possible_types = list(/obj/structure/chair, /obj/structure/toilet, /obj/structure/table, /turf/closed/wall, /turf/open/floor)
	///List of materials that can be required.
	var/possible_material_types = list()
	///List of materials actually required, indexed by the atom that is required.
	var/required_materials = list()

/datum/experiment/scanning/random/material/New()
	. = ..()
	for(var/i in required_atoms)
		var/chosen_material = pick(possible_material_types)
		required_materials[i] = chosen_material

/datum/experiment/scanning/random/material/final_contributing_index_checks(atom/target, typepath)
	return ..() && target.custom_materials && target.has_material_type(required_materials[typepath])

/datum/experiment/scanning/random/material/serialize_progress_stage(atom/target, list/seen_instances)
	var/datum/material/required_material = SSmaterials.GetMaterialRef(required_materials[target])
	return EXP_PROG_INT("Scan samples of \a [required_material.name] [initial(target.name)]", \
		traits & EXP_TRAIT_DESTRUCTIVE ? scanned[target] : seen_instances.len, required_atoms[target])