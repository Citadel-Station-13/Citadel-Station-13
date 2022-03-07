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
