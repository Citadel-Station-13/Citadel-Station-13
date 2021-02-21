#define RND_TECH_DISK	"tech"
#define RND_DESIGN_DISK	"design"

/*
Research and Development (R&D) Console

This is the main work horse of the R&D system. It contains the menus/controls for the Destructive Analyzer, Protolathe, and Circuit
imprinter.

Basic use: When it first is created, it will attempt to link up to related devices within 3 squares. It'll only link up if they
aren't already linked to another console. Any consoles it cannot link up with (either because all of a certain type are already
linked or there aren't any in range), you'll just not have access to that menu. In the settings menu, there are menu options that
allow a player to attempt to re-sync with nearby consoles. You can also force it to disconnect from a specific console.

The only thing that requires toxins access is locking and unlocking the console on the settings menu.
Nothing else in the console has ID requirements.

*/
/obj/machinery/computer/rdconsole
	name = "R&D Console"
	desc = "A console used to interface with R&D tools."
	icon_screen = "rdcomp"
	icon_keyboard = "rd_key"
	circuit = /obj/item/circuitboard/computer/rdconsole

	var/obj/machinery/rnd/destructive_analyzer/linked_destroy	//Linked Destructive Analyzer
	var/obj/machinery/rnd/production/protolathe/linked_lathe				//Linked Protolathe
	var/obj/machinery/rnd/production/circuit_imprinter/linked_imprinter	//Linked Circuit Imprinter

	req_access = list(ACCESS_TOX)	//lA AND SETTING MANIPULATION REQUIRES SCIENTIST ACCESS.

	//UI VARS
	var/screen = RDSCREEN_MENU
	var/back = RDSCREEN_MENU
	req_access = list(ACCESS_TOX) // Locking and unlocking the console requires science access
	/// Reference to global science techweb
	var/datum/techweb/stored_research
	/// The stored technology disk, if present
	var/obj/item/disk/tech_disk/t_disk
	/// The stored design disk, if present
	var/obj/item/disk/design_disk/d_disk
	/// Determines if the console is locked, and consequently if actions can be performed with it
	var/locked = FALSE

	/// Used for compressing data sent to the UI via static_data as payload size is of concern
	var/id_cache = list()
	/// Sequence var for the id cache
	var/id_cache_seq = 1

	/// Long action cooldown to prevent spam
	var/last_long_action = 0

	var/research_control = TRUE

/obj/machinery/computer/rdconsole/production
	circuit = /obj/item/circuitboard/computer/rdconsole/production
	research_control = FALSE

/proc/CallMaterialName(ID)
	if (istype(ID, /datum/material))
		var/datum/material/material = ID
		return material.name

	else if(GLOB.chemical_reagents_list[ID])
		var/datum/reagent/reagent = GLOB.chemical_reagents_list[ID]
		return reagent.name
	return ID

/obj/machinery/computer/rdconsole/proc/SyncRDevices() //Makes sure it is properly sync'ed up with the devices attached to it (if any).
	for(var/obj/machinery/rnd/D in oview(3,src))
		if(D.linked_console != null || D.disabled || D.panel_open)
			continue
		if(istype(D, /obj/machinery/rnd/destructive_analyzer))
			if(linked_destroy == null)
				linked_destroy = D
				D.linked_console = src
		else if(istype(D, /obj/machinery/rnd/production/protolathe))
			if(linked_lathe == null)
				var/obj/machinery/rnd/production/protolathe/P = D
				if(!P.console_link)
					continue
				linked_lathe = D
				D.linked_console = src
		else if(istype(D, /obj/machinery/rnd/production/circuit_imprinter))
			if(linked_imprinter == null)
				var/obj/machinery/rnd/production/circuit_imprinter/C = D
				if(!C.console_link)
					continue
				linked_imprinter = D
				D.linked_console = src

/obj/machinery/computer/rdconsole/Initialize()
	. = ..()
	stored_research = SSresearch.science_tech
	stored_research.consoles_accessing[src] = TRUE
	SyncRDevices()

/obj/machinery/computer/rdconsole/Destroy()
	if(stored_research)
		stored_research.consoles_accessing -= src
	if(linked_destroy)
		linked_destroy.linked_console = null
		linked_destroy = null
	if(linked_lathe)
		linked_lathe.linked_console = null
		linked_lathe = null
	if(linked_imprinter)
		linked_imprinter.linked_console = null
		linked_imprinter = null
	if(t_disk)
		t_disk.forceMove(get_turf(src))
		t_disk = null
	if(d_disk)
		d_disk.forceMove(get_turf(src))
		d_disk = null
	return ..()

/obj/machinery/computer/rdconsole/attackby(obj/item/D, mob/user, params)
	//Loading a disk into it.
	if(istype(D, /obj/item/disk))
		if(istype(D, /obj/item/disk/tech_disk))
			if(t_disk)
				to_chat(user, "<span class='danger'>A technology disk is already loaded!</span>")
				return
			if(!user.transferItemToLoc(D, src))
				to_chat(user, "<span class='danger'>[D] is stuck to your hand!</span>")
				return
			t_disk = D
		else if (istype(D, /obj/item/disk/design_disk))
			if(d_disk)
				to_chat(user, "<span class='danger'>A design disk is already loaded!</span>")
				return
			if(!user.transferItemToLoc(D, src))
				to_chat(user, "<span class='danger'>[D] is stuck to your hand!</span>")
				return
			d_disk = D
		else
			to_chat(user, "<span class='danger'>Machine cannot accept disks in that format.</span>")
			return
		to_chat(user, "<span class='notice'>You insert [D] into \the [src]!</span>")
	else if(!(linked_destroy && linked_destroy.busy) && !(linked_lathe && linked_lathe.busy) && !(linked_imprinter && linked_imprinter.busy))
		. = ..()

/obj/machinery/computer/rdconsole/proc/research_node(id, mob/user)
	if(!stored_research.available_nodes[id] || stored_research.researched_nodes[id])
		say("Node unlock failed: Either already researched or not available!")
		return FALSE
	var/datum/techweb_node/TN = SSresearch.techweb_node_by_id(id)
	if(!istype(TN))
		say("Node unlock failed: Unknown error.")
		return FALSE
	var/list/price = TN.get_price(stored_research)
	if(stored_research.can_afford(price))
		investigate_log("[key_name(user)] researched [id]([json_encode(price)]) on techweb id [stored_research.id].", INVESTIGATE_RESEARCH)
		if(stored_research == SSresearch.science_tech)
			SSblackbox.record_feedback("associative", "science_techweb_unlock", 1, list("id" = "[id]", "name" = TN.display_name, "price" = "[json_encode(price)]", "time" = SQLtime()))
		if(stored_research.research_node_id(id))
			say("Successfully researched [TN.display_name].")
			var/logname = "Unknown"
			if(isAI(user))
				logname = "AI: [user.name]"
			else if(iscyborg(user))
				logname = "Cyborg: [user.name]"
			else if(isliving(user))
				var/mob/living/L = user
				logname = L.get_visible_name()
			stored_research.research_logs += "[logname] researched node id [id] with cost [json_encode(price)] at [COORD(src)]."
			return TRUE
		else
			say("Failed to research node: Internal database error!")
			return FALSE
	say("Not enough research points...")
	return FALSE

/obj/machinery/computer/rdconsole/on_deconstruction()
	if(linked_destroy)
		linked_destroy.linked_console = null
		linked_destroy = null
	if(linked_lathe)
		linked_lathe.linked_console = null
		linked_lathe = null
	if(linked_imprinter)
		linked_imprinter.linked_console = null
		linked_imprinter = null
	..()

/obj/machinery/computer/rdconsole/emag_act(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		return
	to_chat(user, "<span class='notice'>You disable the security protocols[locked? " and unlock the console":""].</span>")
	playsound(src, "sparks", 75, 1)
	obj_flags |= EMAGGED
	locked = FALSE
	return TRUE

/obj/machinery/computer/rdconsole/multitool_act(mob/user, obj/item/multitool/I)
	var/lathe = linked_lathe && linked_lathe.multitool_act(user, I)
	var/print = linked_imprinter && linked_imprinter.multitool_act(user, I)
	return lathe || print

/obj/machinery/computer/rdconsole/proc/ui_device_linking()
	var/list/l = list()
	l += "<A href='?src=[REF(src)];switch_screen=[RDSCREEN_SETTINGS]'>Settings Menu</A><div class='statusDisplay'>"
	l += "<h3>R&D Console Device Linkage Menu:</h3>"
	l += "<A href='?src=[REF(src)];find_device=1'>Re-sync with Nearby Devices</A>"
	l += "<h3>Linked Devices:</h3>"
	l += linked_destroy? "* Destructive Analyzer <A href='?src=[REF(src)];disconnect=destroy'>Disconnect</A>" : "* No Destructive Analyzer Linked"
	l += linked_lathe? "* Protolathe <A href='?src=[REF(src)];disconnect=lathe'>Disconnect</A>" : "* No Protolathe Linked"
	l += linked_imprinter? "* Circuit Imprinter <A href='?src=[REF(src)];disconnect=imprinter'>Disconnect</A>" : "* No Circuit Imprinter Linked"
	l += "</div>"
	return l

/obj/machinery/computer/rdconsole/proc/ui_deconstruct()		//Legacy code
	RDSCREEN_UI_DECONSTRUCT_CHECK
	var/list/l = list()
	if(!linked_destroy.loaded_item)
		l += "<div class='statusDisplay'>No item loaded. Standing-by...</div>"
	else
		l += "<div class='statusDisplay'>[RDSCREEN_NOBREAK]"
		l += "<table><tr><td>[icon2html(linked_destroy.loaded_item, usr)]</td><td><b>[linked_destroy.loaded_item.name]</b> <A href='?src=[REF(src)];eject_item=1'>Eject</A></td></tr></table>[RDSCREEN_NOBREAK]"
		l += "Select a node to boost by deconstructing this item. This item can boost:"

		var/list/boostable_nodes = techweb_item_boost_check(linked_destroy.loaded_item)
		for(var/id in boostable_nodes)
			var/list/worth = boostable_nodes[id]
			var/datum/techweb_node/N = SSresearch.techweb_node_by_id(id)

			l += "<div class='statusDisplay'>[RDSCREEN_NOBREAK]"
			if (stored_research.researched_nodes[N.id])  // already researched
				l += "<span class='linkOff'>[N.display_name]</span>"
				l += "This node has already been researched."
			else if(!length(worth))  // reveal only
				if (stored_research.hidden_nodes[N.id])
					l += "<A href='?src=[REF(src)];deconstruct=[N.id]'>[N.display_name]</A>"
					l += "This node will be revealed."
				else
					l += "<span class='linkOff'>[N.display_name]</span>"
					l += "This node has already been revealed."
			else  // boost by the difference
				var/list/differences = list()
				var/list/already_boosted = stored_research.boosted_nodes[N.id]
				for(var/i in worth)
					var/already_boosted_amount = already_boosted? stored_research.boosted_nodes[N.id][i] : 0
					var/amt = min(worth[i], N.research_costs[i]) - already_boosted_amount
					if(amt > 0)
						differences[i] = amt
				if (length(differences))
					l += "<A href='?src=[REF(src)];deconstruct=[N.id]'>[N.display_name]</A>"
					l += "This node will be boosted with the following:<BR>[techweb_point_display_generic(differences)]"
				else
					l += "<span class='linkOff'>[N.display_name]</span>"
					l += "This node has already been boosted.</span>"
			l += "</div>[RDSCREEN_NOBREAK]"

		// point deconstruction and material reclamation use the same ID to prevent accidentally missing the points
		var/list/point_values = techweb_item_point_check(linked_destroy.loaded_item)
		if(point_values)
			l += "<div class='statusDisplay'>[RDSCREEN_NOBREAK]"
			if (stored_research.deconstructed_items[linked_destroy.loaded_item.type])
				l += "<span class='linkOff'>Point Deconstruction</span>"
				l += "This item's points have already been claimed."
			else
				l += "<A href='?src=[REF(src)];deconstruct=[RESEARCH_MATERIAL_RECLAMATION_ID]'>Point Deconstruction</A>"
				l += "This item is worth: <BR>[techweb_point_display_generic(point_values)]!"
			l += "</div>[RDSCREEN_NOBREAK]"

		if(!(linked_destroy.loaded_item.resistance_flags & INDESTRUCTIBLE))
			var/list/materials = linked_destroy.loaded_item.custom_materials
			l += "<div class='statusDisplay'><A href='?src=[REF(src)];deconstruct=[RESEARCH_MATERIAL_RECLAMATION_ID]'>[LAZYLEN(materials)? "Material Reclamation" : "Destroy Item"]</A>"
			for (var/M in materials)
				l += "* [CallMaterialName(M)] x [materials[M]]"
			l += "</div>[RDSCREEN_NOBREAK]"

		l += "<div class='statusDisplay'><A href='?src=[REF(src)];deconstruct=[RESEARCH_DEEP_SCAN_ID]'>Nondestructive Deep Scan</A></div>"

		l += "</div>"
	return l

/obj/machinery/computer/rdconsole/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Techweb")
		ui.open()

/obj/machinery/computer/rdconsole/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/research_designs)
	)

// heavy data from this proc should be moved to static data when possible
/obj/machinery/computer/rdconsole/ui_data(mob/user)
	. = list(
		"nodes" = list(),
		"experiments" = list(),
		"researched_designs" = stored_research.researched_designs,
		"points" = stored_research.research_points,
		"points_last_tick" = stored_research.last_bitcoins,
		"web_org" = stored_research.organization,
		"sec_protocols" = !(obj_flags & EMAGGED),
		"t_disk" = null,
		"d_disk" = null,
		"locked" = locked
	)

	if (t_disk)
		.["t_disk"] = list (
			"stored_research" = t_disk.stored_research.researched_nodes
		)
	if (d_disk)
		.["d_disk"] = list (
			"max_blueprints" = d_disk.max_blueprints,
			"blueprints" = list()
		)
		for (var/i in 1 to d_disk.max_blueprints)
			if (d_disk.blueprints[i])
				var/datum/design/D = d_disk.blueprints[i]
				.["d_disk"]["blueprints"] += D.id
			else
				.["d_disk"]["blueprints"] += null


	// Serialize all nodes to display
	for(var/v in stored_research.tiers)
		var/datum/techweb_node/n = SSresearch.techweb_node_by_id(v)

		// Ensure node is supposed to be visible
		if (stored_research.hidden_nodes[v])
			continue

		.["nodes"] += list(list(
			"id" = n.id,
			"can_unlock" = stored_research.can_unlock_node(n),
			"tier" = stored_research.tiers[n.id]
		))

	// Get experiments and serialize them
	var/list/exp_to_process = stored_research.available_experiments.Copy()
	for (var/e in stored_research.completed_experiments)
		exp_to_process += stored_research.completed_experiments[e]
	for (var/e in exp_to_process)
		var/datum/experiment/ex = e
		.["experiments"][ex.type] = list(
			"name" = ex.name,
			"description" = ex.description,
			"tag" = ex.exp_tag,
			"progress" = ex.check_progress(),
			"completed" = ex.completed,
			"performance_hint" = ex.performance_hint
		)

/**
 * Compresses an ID to an integer representation using the id_cache, used for deduplication
 * in sent JSON payloads
 *
 * Arguments:
 * * id - the ID to compress
 */
/obj/machinery/computer/rdconsole/proc/compress_id(id)
	if (!id_cache[id])
		id_cache[id] = id_cache_seq++
	return id_cache[id]

/obj/machinery/computer/rdconsole/ui_static_data(mob/user)
	. = list(
		"static_data" = list()
	)

	// Build node cache...
	// Note this looks a bit ugly but its to reduce the size of the JSON payload
	// by the greatest amount that we can, as larger JSON payloads result in
	// hanging when the user opens the UI
	var/node_cache = list()
	for (var/nid in SSresearch.techweb_nodes)
		var/datum/techweb_node/n = SSresearch.techweb_nodes[nid] || SSresearch.error_node
		var/cid = "[compress_id(n.id)]"
		node_cache[cid] = list(
			"name" = n.display_name,
			"description" = n.description
		)
		if (n.research_costs?.len)
			node_cache[cid]["costs"] = list()
			for (var/c in n.research_costs)
				node_cache[cid]["costs"]["[compress_id(c)]"] = n.research_costs[c]
		if (n.prereq_ids?.len)
			node_cache[cid]["prereq_ids"] = list()
			for (var/pn in n.prereq_ids)
				node_cache[cid]["prereq_ids"] += compress_id(pn)
		if (n.design_ids?.len)
			node_cache[cid]["design_ids"] = list()
			for (var/d in n.design_ids)
				node_cache[cid]["design_ids"] += compress_id(d)
		if (n.unlock_ids?.len)
			node_cache[cid]["unlock_ids"] = list()
			for (var/un in n.unlock_ids)
				node_cache[cid]["unlock_ids"] += compress_id(un)
		if (n.required_experiments?.len)
			node_cache[cid]["required_experiments"] = n.required_experiments
		if (n.discount_experiments?.len)
			node_cache[cid]["discount_experiments"] = n.discount_experiments

	// Build design cache
	var/design_cache = list()
	var/datum/asset/spritesheet/research_designs/ss = get_asset_datum(/datum/asset/spritesheet/research_designs)
	var/size32x32 = "[ss.name]32x32"
	for (var/did in SSresearch.techweb_designs)
		var/datum/design/d = SSresearch.techweb_designs[did] || SSresearch.error_design
		var/cid = "[compress_id(d.id)]"
		var/size = ss.icon_size_id(d.id)
		design_cache[cid] = list(
			d.name,
			"[size == size32x32 ? "" : "[size] "][d.id]"
		)

	// Ensure id cache is included for decompression
	var/flat_id_cache = list()
	for (var/id in id_cache)
		flat_id_cache += id

	.["static_data"] = list(
		"node_cache" = node_cache,
		"design_cache" = design_cache,
		"id_cache" = flat_id_cache
	)

/obj/machinery/computer/rdconsole/ui_act(action, list/params)
	. = ..()
	if (.)
		return
	add_fingerprint(usr)

	// Check if the console is locked to block any actions occuring
	if (locked && action != "toggleLock")
		say("Console is locked, cannot perform further actions.")
		return TRUE

	switch (action)
		if ("toggleLock")
			if(obj_flags & EMAGGED)
				to_chat(usr, "<span class='boldwarning'>Security protocol error: Unable to access locking protocols.</span>")
				return TRUE
			if(allowed(usr))
				locked = !locked
			else
				to_chat(usr, "<span class='boldwarning'>Unauthorized Access.</span>")
			return TRUE
		if ("researchNode")
			if(!SSresearch.science_tech.available_nodes[params["node_id"]])
				return TRUE
			research_node(params["node_id"], usr)
			return TRUE
		if ("ejectDisk")
			eject_disk(params["type"])
			return TRUE
		if ("writeDesign")
			if(QDELETED(d_disk))
				say("No Design Disk Inserted!")
				return TRUE
			var/slot = text2num(params["slot"])
			var/datum/design/D = SSresearch.techweb_design_by_id(params["selectedDesign"])
			if(D)
				var/autolathe_friendly = TRUE
				if(D.reagents_list.len)
					autolathe_friendly = FALSE
					D.category -= "Imported"
				else
					for(var/x in D.materials)
						if( !(x in list(/datum/material/iron, /datum/material/glass)))
							autolathe_friendly = FALSE
							D.category -= "Imported"

				if(D.build_type & (AUTOLATHE|PROTOLATHE)) // Specifically excludes circuit imprinter and mechfab
					D.build_type = autolathe_friendly ? (D.build_type | AUTOLATHE) : D.build_type
					D.category |= "Imported"
				d_disk.blueprints[slot] = D
			return TRUE
		if ("uploadDesignSlot")
			if(QDELETED(d_disk))
				say("No design disk found.")
				return TRUE
			var/n = text2num(params["slot"])
			stored_research.add_design(d_disk.blueprints[n], TRUE)
			return TRUE
		if ("clearDesignSlot")
			if(QDELETED(d_disk))
				say("No design disk inserted!")
				return TRUE
			var/n = text2num(params["slot"])
			var/datum/design/D = d_disk.blueprints[n]
			say("Wiping design [D.name] from design disk.")
			d_disk.blueprints[n] = null
			return TRUE
		if ("eraseDisk")
			if (params["type"] == RND_DESIGN_DISK)
				if(QDELETED(d_disk))
					say("No design disk inserted!")
					return TRUE
				say("Wiping design disk.")
				for(var/i in 1 to d_disk.max_blueprints)
					d_disk.blueprints[i] = null
			if (params["type"] == RND_TECH_DISK)
				if(QDELETED(t_disk))
					say("No tech disk inserted!")
					return TRUE
				qdel(t_disk.stored_research)
				t_disk.stored_research = new
				say("Wiping technology disk.")
			return TRUE
		if ("uploadDisk")
			if (params["type"] == RND_DESIGN_DISK)
				if(QDELETED(d_disk))
					say("No design disk inserted!")
					return TRUE
				for(var/D in d_disk.blueprints)
					if(D)
						stored_research.add_design(D, TRUE)
			if (params["type"] == RND_TECH_DISK)
				if (QDELETED(t_disk))
					say("No tech disk inserted!")
					return TRUE
				say("Uploading technology disk.")
				t_disk.stored_research.copy_research_to(stored_research)
			return TRUE
		if ("loadTech")
			if(QDELETED(t_disk))
				say("No tech disk inserted!")
				return
			stored_research.copy_research_to(t_disk.stored_research)
			say("Downloading to technology disk.")
			return TRUE

/obj/machinery/computer/rdconsole/proc/eject_disk(type)
	if(type == RND_DESIGN_DISK && d_disk)
		d_disk.forceMove(get_turf(src))
		d_disk = null
	if(type == RND_TECH_DISK && t_disk)
		t_disk.forceMove(get_turf(src))
		t_disk = null

/obj/machinery/computer/rdconsole/proc/check_canprint(datum/design/D, buildtype)
	var/amount = 50
	if(buildtype == IMPRINTER)
		if(QDELETED(linked_imprinter))
			return FALSE
		for(var/M in D.materials + D.reagents_list)
			amount = min(amount, linked_imprinter.check_mat(D, M))
			if(amount < 1)
				return FALSE
	else if(buildtype == PROTOLATHE)
		if(QDELETED(linked_lathe))
			return FALSE
		for(var/M in D.materials + D.reagents_list)
			amount = min(amount, linked_lathe.check_mat(D, M))
			if(amount < 1)
				return FALSE
	else
		return FALSE
	return amount

#undef RND_TECH_DISK
#undef RND_DESIGN_DISK

/obj/machinery/computer/rdconsole/robotics
	name = "Robotics R&D Console"
	req_access = null
	req_access_txt = "29"

/obj/machinery/computer/rdconsole/robotics/Initialize()
	. = ..()
	if(circuit)
		circuit.name = "R&D Console - Robotics (Computer Board)"
		circuit.build_path = /obj/machinery/computer/rdconsole/robotics

/obj/machinery/computer/rdconsole/core
	name = "Core R&D Console"

/obj/machinery/computer/rdconsole/experiment
	name = "E.X.P.E.R.I-MENTOR R&D Console"
