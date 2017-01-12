/mob/camera/blob/proc/can_buy(cost = 15)
	if(blob_points < cost)
		src << "<span class='warning'>You cannot afford this, you need at least [cost] resources!</span>"
		return 0
	add_points(-cost)
	return 1

// Power verbs

/mob/camera/blob/proc/place_blob_core(point_rate, placement_override)
	if(placed && placement_override != -1)
		return 1
	if(!placement_override)
		for(var/mob/living/M in range(7, src))
			if("blob" in M.faction)
				continue
			if(M.client)
				src << "<span class='warning'>There is someone too close to place your blob core!</span>"
				return 0
		for(var/mob/living/M in view(13, src))
			if("blob" in M.faction)
				continue
			if(M.client)
				src << "<span class='warning'>Someone could see your blob core from here!</span>"
				return 0
		var/turf/T = get_turf(src)
		if(T.density)
			src << "<span class='warning'>This spot is too dense to place a blob core on!</span>"
			return 0
		for(var/obj/O in T)
			if(istype(O, /obj/effect/blob))
				if(istype(O, /obj/effect/blob/normal))
					qdel(O)
				else
					src << "<span class='warning'>There is already a blob here!</span>"
					return 0
			if(O.density)
				src << "<span class='warning'>This spot is too dense to place a blob core on!</span>"
				return 0
		if(world.time <= manualplace_min_time && world.time <= autoplace_max_time)
			src << "<span class='warning'>It is too early to place your blob core!</span>"
			return 0
	else if(placement_override == 1)
		var/turf/T = pick(blobstart)
		loc = T //got overrided? you're somewhere random, motherfucker
	if(placed && blob_core)
		blob_core.forceMove(loc)
	else
		var/obj/effect/blob/core/core = new(get_turf(src), null, point_rate, 1)
		core.overmind = src
		blob_core = core
		core.update_icon()
	update_health_hud()
	placed = 1
	return 1

/mob/camera/blob/verb/transport_core()
	set category = "Blob"
	set name = "Jump to Core"
	set desc = "Move your camera to your core."
	if(blob_core)
		src.loc = blob_core.loc

/mob/camera/blob/verb/jump_to_node()
	set category = "Blob"
	set name = "Jump to Node"
	set desc = "Move your camera to a selected node."
	if(blob_nodes.len)
		var/list/nodes = list()
		for(var/i = 1; i <= blob_nodes.len; i++)
			nodes["Blob Node #[i]"] = blob_nodes[i]
		var/node_name = input(src, "Choose a node to jump to.", "Node Jump") in nodes
		var/obj/effect/blob/node/chosen_node = nodes[node_name]
		if(chosen_node)
			src.loc = chosen_node.loc

/mob/camera/blob/proc/createSpecial(price, blobType, nearEquals, needsNode, turf/T)
	if(!T)
		T = get_turf(src)
	var/obj/effect/blob/B = (locate(/obj/effect/blob) in T)
	if(!B)
		src << "<span class='warning'>There is no blob here!</span>"
		return
	if(!istype(B, /obj/effect/blob/normal))
		src << "<span class='warning'>Unable to use this blob, find a normal one.</span>"
		return
	if(needsNode && nodes_required)
		if(!(locate(/obj/effect/blob/node) in orange(3, T)) && !(locate(/obj/effect/blob/core) in orange(4, T)))
			src << "<span class='warning'>You need to place this blob closer to a node or core!</span>"
			return //handholdotron 2000
	if(nearEquals)
		for(var/obj/effect/blob/L in orange(nearEquals, T))
			if(L.type == blobType)
				src << "<span class='warning'>There is a similar blob nearby, move more than [nearEquals] tiles away from it!</span>"
				return
	if(!can_buy(price))
		return
	var/obj/effect/blob/N = B.change_to(blobType, src)
	return N

/mob/camera/blob/verb/toggle_node_req()
	set category = "Blob"
	set name = "Toggle Node Requirement"
	set desc = "Toggle requiring nodes to place resource and factory blobs."
	nodes_required = !nodes_required
	if(nodes_required)
		src << "<span class='warning'>You now require a nearby node or core to place factory and resource blobs.</span>"
	else
		src << "<span class='warning'>You no longer require a nearby node or core to place factory and resource blobs.</span>"

/mob/camera/blob/verb/create_shield_power()
	set category = "Blob"
	set name = "Create Shield Blob (10)"
	set desc = "Create a shield blob, which will block fire and is hard to kill."
	create_shield()

/mob/camera/blob/proc/create_shield(turf/T)
	createSpecial(10, /obj/effect/blob/shield, 0, 0, T)

/mob/camera/blob/verb/create_resource()
	set category = "Blob"
	set name = "Create Resource Blob (40)"
	set desc = "Create a resource tower which will generate resources for you."
	createSpecial(40, /obj/effect/blob/resource, 4, 1)

/mob/camera/blob/verb/create_node()
	set category = "Blob"
	set name = "Create Node Blob (60)"
	set desc = "Create a node, which will power nearby factory and resource blobs."
	createSpecial(60, /obj/effect/blob/node, 5, 0)

/mob/camera/blob/verb/create_factory()
	set category = "Blob"
	set name = "Create Factory Blob (60)"
	set desc = "Create a spore tower that will spawn spores to harass your enemies."
	createSpecial(60, /obj/effect/blob/factory, 7, 1)

/mob/camera/blob/verb/create_blobbernaut()
	set category = "Blob"
	set name = "Create Blobbernaut (40)"
	set desc = "Create a powerful blobbernaut which is mildly smart and will attack enemies."
	var/turf/T = get_turf(src)
	var/obj/effect/blob/factory/B = locate(/obj/effect/blob/factory) in T
	if(!B)
		src << "<span class='warning'>You must be on a factory blob!</span>"
		return
	if(B.naut) //if it already made a blobbernaut, it can't do it again
		src << "<span class='warning'>This factory blob is already sustaining a blobbernaut.</span>"
		return
	if(B.health < B.maxhealth * 0.5)
		src << "<span class='warning'>This factory blob is too damaged to sustain a blobbernaut.</span>"
		return
	if(!can_buy(40))
		return
	B.maxhealth = initial(B.maxhealth) * 0.25 //factories that produced a blobbernaut have much lower health
	B.check_health()
	B.visible_message("<span class='warning'><b>The blobbernaut [pick("rips", "tears", "shreds")] its way out of the factory blob!</b></span>")
	playsound(B.loc, 'sound/effects/splat.ogg', 50, 1)
	var/mob/living/simple_animal/hostile/blob/blobbernaut/blobber = new /mob/living/simple_animal/hostile/blob/blobbernaut(get_turf(B))
	flick("blobbernaut_produce", blobber)
	B.naut = blobber
	blobber.factory = B
	blobber.overmind = src
	blobber.update_icons()
	blobber.notransform = 1 //stop the naut from moving around
	blobber.adjustHealth(blobber.maxHealth * 0.5)
	blob_mobs += blobber
	var/list/mob/dead/observer/candidates = pollCandidates("Do you want to play as a [blob_reagent_datum.name] blobbernaut?", ROLE_BLOB, null, ROLE_BLOB, 50) //players must answer rapidly
	var/client/C = null
	if(candidates.len) //if we got at least one candidate, they're a blobbernaut now.
		C = pick(candidates)
		blobber.notransform = 0
		blobber.key = C.key
		blobber << 'sound/effects/blobattack.ogg'
		blobber << 'sound/effects/attackblob.ogg'
		blobber << "<b>You are a blobbernaut!</b>"
		blobber << "You are powerful, hard to kill, and slowly regenerate near nodes and cores, but will slowly die if not near the blob or if the factory that made you is killed."
		blobber << "You can communicate with other blobbernauts and overminds via <b>:b</b>"
		blobber << "Your overmind's blob reagent is: <b><font color=\"[blob_reagent_datum.color]\">[blob_reagent_datum.name]</b></font>!"
		blobber << "The <b><font color=\"[blob_reagent_datum.color]\">[blob_reagent_datum.name]</b></font> reagent [blob_reagent_datum.shortdesc ? "[blob_reagent_datum.shortdesc]" : "[blob_reagent_datum.description]"]"
	else
		blobber.notransform = 0 //otherwise, just let it move

/mob/camera/blob/verb/relocate_core()
	set category = "Blob"
	set name = "Relocate Core (80)"
	set desc = "Swaps the locations of your core and the selected node."
	var/turf/T = get_turf(src)
	var/obj/effect/blob/node/B = locate(/obj/effect/blob/node) in T
	if(!B)
		src << "<span class='warning'>You must be on a blob node!</span>"
		return
	if(!can_buy(80))
		return
	var/turf/old_turf = blob_core.loc
	blob_core.loc = T
	B.loc = old_turf

/mob/camera/blob/verb/revert()
	set category = "Blob"
	set name = "Remove Blob"
	set desc = "Removes a blob, giving you back some resources."
	var/turf/T = get_turf(src)
	remove_blob(T)

/mob/camera/blob/proc/remove_blob(turf/T)
	var/obj/effect/blob/B = locate() in T
	if(!B)
		src << "<span class='warning'>There is no blob there!</span>"
		return
	if(B.point_return < 0)
		src << "<span class='warning'>Unable to remove this blob.</span>"
		return
	if(max_blob_points < B.point_return + blob_points)
		src << "<span class='warning'>You have too many resources to remove this blob!</span>"
		return
	if(B.point_return)
		add_points(B.point_return)
		src << "<span class='notice'>Gained [B.point_return] resources from removing \the [B].</span>"
	qdel(B)

/mob/camera/blob/verb/expand_blob_power()
	set category = "Blob"
	set name = "Expand/Attack Blob (5)"
	set desc = "Attempts to create a new blob in this tile. If the tile isn't clear, instead attacks it, damaging mobs and objects."
	var/turf/T = get_turf(src)
	expand_blob(T)

/mob/camera/blob/proc/expand_blob(turf/T)
	if(!can_attack())
		return
	var/obj/effect/blob/OB = locate() in circlerange(T, 1)
	if(!OB)
		src << "<span class='warning'>There is no blob adjacent to the target tile!</span>"
		return
	if(can_buy(5))
		var/attacksuccess = FALSE
		last_attack = world.time
		for(var/mob/living/L in T)
			if("blob" in L.faction) //no friendly/dead fire
				continue
			if(L.stat != DEAD)
				attacksuccess = TRUE
			var/mob_protection = L.get_permeability_protection()
			blob_reagent_datum.reaction_mob(L, VAPOR, 25, 1, mob_protection, src)
			blob_reagent_datum.send_message(L)
		var/obj/effect/blob/B = locate() in T
		if(B)
			if(attacksuccess) //if we successfully attacked a turf with a blob on it, don't refund shit
				B.blob_attack_animation(T, src)
			else
				src << "<span class='warning'>There is a blob there!</span>"
				add_points(5) //otherwise, refund all of the cost
			return
		else
			OB.expand(T, src)

/mob/camera/blob/verb/rally_spores_power()
	set category = "Blob"
	set name = "Rally Spores"
	set desc = "Rally your spores to move to a target location."
	var/turf/T = get_turf(src)
	rally_spores(T)

/mob/camera/blob/proc/rally_spores(turf/T)
	src << "You rally your spores."
	var/list/surrounding_turfs = block(locate(T.x - 1, T.y - 1, T.z), locate(T.x + 1, T.y + 1, T.z))
	if(!surrounding_turfs.len)
		return
	for(var/mob/living/simple_animal/hostile/blob/blobspore/BS in blob_mobs)
		if(isturf(BS.loc) && get_dist(BS, T) <= 35)
			BS.LoseTarget()
			BS.Goto(pick(surrounding_turfs), BS.move_to_delay)

/mob/camera/blob/verb/blob_broadcast()
	set category = "Blob"
	set name = "Blob Broadcast"
	set desc = "Speak with your blob spores and blobbernauts as your mouthpieces."
	var/speak_text = input(src, "What would you like to say with your minions?", "Blob Broadcast", null) as text
	if(!speak_text)
		return
	else
		src << "You broadcast with your minions, <B>[speak_text]</B>"
	for(var/BLO in blob_mobs)
		var/mob/living/simple_animal/hostile/blob/BM = BLO
		if(BM.stat == CONSCIOUS)
			BM.say(speak_text)

/mob/camera/blob/verb/chemical_reroll()
	set category = "Blob"
	set name = "Reactive Chemical Adaptation (40)"
	set desc = "Replaces your chemical with a random, different one."
	if(free_chem_rerolls || can_buy(40))
		set_chemical()
		if(free_chem_rerolls)
			free_chem_rerolls--

/mob/camera/blob/proc/set_chemical()
	var/datum/reagent/blob/BC = pick((subtypesof(/datum/reagent/blob) - blob_reagent_datum.type))
	blob_reagent_datum = new BC
	for(var/BL in blobs)
		var/obj/effect/blob/B = BL
		B.update_icon()
	for(var/BLO in blob_mobs)
		var/mob/living/simple_animal/hostile/blob/BM = BLO
		BM.update_icons() //If it's getting a new chemical, tell it what it does!
		BM << "Your overmind's blob reagent is now: <b><font color=\"[blob_reagent_datum.color]\">[blob_reagent_datum.name]</b></font>!"
		BM << "The <b><font color=\"[blob_reagent_datum.color]\">[blob_reagent_datum.name]</b></font> reagent [blob_reagent_datum.shortdesc ? "[blob_reagent_datum.shortdesc]" : "[blob_reagent_datum.description]"]"
	src << "Your reagent is now: <b><font color=\"[blob_reagent_datum.color]\">[blob_reagent_datum.name]</b></font>!"
	src << "The <b><font color=\"[blob_reagent_datum.color]\">[blob_reagent_datum.name]</b></font> reagent [blob_reagent_datum.description]"

/mob/camera/blob/verb/blob_help()
	set category = "Blob"
	set name = "*Blob Help*"
	set desc = "Help on how to blob."
	src << "<b>As the overmind, you can control the blob!</b>"
	src << "Your blob reagent is: <b><font color=\"[blob_reagent_datum.color]\">[blob_reagent_datum.name]</b></font>!"
	src << "The <b><font color=\"[blob_reagent_datum.color]\">[blob_reagent_datum.name]</b></font> reagent [blob_reagent_datum.description]"
	src << "<b>You can expand, which will attack people, damage objects, or place a Normal Blob if the tile is clear.</b>"
	src << "<i>Normal Blobs</i> will expand your reach and can be upgraded into special blobs that perform certain functions."
	src << "<b>You can upgrade normal blobs into the following types of blob:</b>"
	src << "<i>Shield Blobs</i> are strong and expensive blobs which take more damage. In additon, they are fireproof and can block air, use these to protect yourself from station fires."
	src << "<i>Resource Blobs</i> are blobs which produce more resources for you, build as many of these as possible to consume the station. This type of blob must be placed near node blobs or your core to work."
	src << "<i>Factory Blobs</i> are blobs that spawn blob spores which will attack nearby enemies. This type of blob must be placed near node blobs or your core to work."
	src << "<i>Blobbernauts</i> can be produced from factories for a cost, and are hard to kill, powerful, and moderately smart. The factory used to create one will become fragile and briefly unable to produce spores."
	src << "<i>Node Blobs</i> are blobs which grow, like the core. Like the core it can activate resource and factory blobs."
	src << "<b>In addition to the buttons on your HUD, there are a few click shortcuts to speed up expansion and defense.</b>"
	src << "<b>Shortcuts:</b> Click = Expand Blob <b>|</b> Middle Mouse Click = Rally Spores <b>|</b> Ctrl Click = Create Shield Blob <b>|</b> Alt Click = Remove Blob"
	src << "Attempting to talk will send a message to all other overminds, allowing you to coordinate with them."
	if(!placed && autoplace_max_time <= world.time)
		src << "<span class='big'><font color=\"#EE4000\">You will automatically place your blob core in [round((autoplace_max_time - world.time)/600, 0.5)] minutes.</font></span>"
		src << "<span class='big'><font color=\"#EE4000\">You [manualplace_min_time ? "will be able to":"can"] manually place your blob core by pressing the button in the bottom right corner of the screen.</font></span>"
