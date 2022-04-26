GLOBAL_DATUM_INIT(ghostrole_menu, /datum/ghostrole_menu, new)

/datum/ghostrole_menu

/datum/ghostrole_menu/ui_state(mob/user)
	return GLOB.observer_state

/datum/ghostrole_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GhostRoleMenu")
		ui.open()

/datum/ghostrole_menu/ui_static_data(mob/user)
	. = ..()
	var/list/spawners = list()
	.["spawners"] = spawners
	for(var/id in GLOB.ghostroles)
		var/datum/ghostrole/role = GLOB.ghostroles[id]
		if(!istype(role))
			stack_trace("non ghostrole [role] ([id]) pruned from ghostroles list.")
			GLOB.ghostroles -= id
			continue
		var/list/data = list()
		data["id"] = role.id || role.type
		data["name"] = role.name
		data["short_desc"] = role.desc
		data["flavor_text"] = role.spawntext
		data["important_info"] = role.ImportantInfo()
		var/slots = role.SpawnsLeft(user)
		data["amount_left"] = slots == INFINITY? -1 : slots
		spawners += list(data)	// wrap

/datum/ghostrole_menu/ui_act(action, params)
	if(..())
		return
	if(!isobserver(usr))
		return
	var/id = params["id"]
	var/datum/ghostrole/role = get_ghostrole_datum(id)
	if(!role)
		return
	switch(action)
		if("jump")
			if(role.spawnerless)
				to_chat(usr, "<span class='warning'>[role] is spawnerless! You won't be able to find out where you spawn until you actually spawn in!</span>")
				return
			var/atom/A = role.GetSpawnLoc(usr.client, role.GetSpawnpoint(usr.client))
			if(!A)
				to_chat(usr, "<span class='warning'>Could not find a spawnpoint for [role]. This sometimes mean it isn't loaded in until someone attempts to spawn. Alternatively, you didn't pick one!</span>")
				return
			if(!A.loc)
				to_chat(usr, "<span class='danger'>BUG: Spawnpoint was nullspace.</span>")
				return
			usr.forceMove(get_turf(A))
		if("spawn")
			var/client/C = usr.client
			var/error = role.AttemptSpawn(C)
			if(istext(error))
				to_chat(C, span_danger(error))

/**
 * Call this whenever ghostrole data changes, we don't keep resending to save performance.
 */
/datum/ghostrole_menu/proc/queue_update()
	addtimer(CALLBACK(src, /datum/proc/update_static_data), 0, TIMER_UNIQUE | TIMER_OVERRIDE)
