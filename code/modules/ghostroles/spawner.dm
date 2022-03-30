/**
 * Default implementation for ghost role spawners
 */
/obj/structure/ghost_role_spawner
	name = "Ghost Role Spawner"
	desc = "if you're seeing this a coder fucked up"
	resistance_flags = INDESTRUCTIBLE
	density = TRUE
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"

	/// automatic handling - role type
	var/role_type
	/// automatic handling - allowed spawn count
	var/role_spawns = 1
	/// automatic handling - params. If this is a string at Init, it'll be json_decoded.
	var/list/role_params
	/// automatic handling - qdel on running out
	var/qdel_on_deplete = FALSE
	/// automatic handling - special spawntext
	var/special_spawntext

/obj/structure/ghost_role_spawner/Initialize(mapload, params, type, spawns, spawntext)
	. = ..()
	if(type)
		src.role_type = type
	if(params)
		role_params = params
	else if(istext(role_params))
		role_params = json_decode(role_params)
	if(spawns)
		role_spawns = spawns
	if(spawntext)
		special_spawntext = spawntext
	if(!src.role_type)
		if(mapload)
			stack_trace("No role type")
	else
		AddComponent(/datum/component/ghostrole_spawnpoint, role_type, role_spawns, role_params, /obj/structure/ghost_role_spawner/proc/on_spawn, null, special_spawntext)

/obj/structure/ghost_role_spawner/proc/on_spawn(mob/created, datum/ghostrole/role, list/params, datum/component/ghostrole_spawnpoint/spawnpoint)
	if(qdel_on_deplete && !spawnpoint.SpawnsLeft())
		qdel(src)

/**
 * for mappers
 */
/obj/structure/ghost_role_spawner/custom
	/// json to convert to params
	var/role_params_json
	/// next id
	var/static/id_next = 0
	/// forced id
	var/forced_id
	/// mob path
	var/mob_path = /mob/living/carbon/human
	/// forced instantiator path
	var/instantiator_path

/obj/structure/ghost_role_spawner/custom/Initialize(mapload, params, type, spawns, spawntext)
	role_type = "[forced_id]" || "[++id_next]"
	GenerateRole(role_type, mob_path)
	role_params = GenerateParams()
	return ..()

/obj/structure/ghost_role_spawner/custom/proc/GenerateRole(id = role_type, mob_path = src.mob_path)
	var/datum/ghostrole/G = get_ghostrole_datum(id)
	if(G)
		return
	G = new(id)
	if(instantiator_path)
		G.instantiator = new instantiator_path
	else
		G.instantiator = ispath(mob_path, /mob/living/carbon/human)? new /datum/ghostrole_instantiator/human/random/species : new /datum/ghostrole_instantiator/simple
	return G

/obj/structure/ghost_role_spawner/custom/proc/GenerateParams()
	. = list()
	if(istext(role_params_json))
		var/list/L = safe_json_decode(role_params_json)
		if(L)
			. = L
	.["mob"] = mob_path

/obj/structure/ghost_role_spawner/custom/human
	mob_path = /mob/living/carbon/human
	/// outfit path
	var/outfit_path = /datum/outfit/job/assistant
	/// species path
	var/species_path = /datum/species/human

/obj/structure/ghost_role_spawner/custom/human/GenerateParams()
	. = ..()
	.["outfit"] = outfit_path
	.["species"] = species_path
