/obj/item/device/integrated_circuit_printer
	name = "integrated circuit printer"
	desc = "A portable(ish) machine made to print tiny modular circuitry out of metal."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "circuit_printer"
	w_class = WEIGHT_CLASS_BULKY
	var/upgraded = TRUE			// When hit with an upgrade disk, will turn true, allowing it to print the higher tier circuits.
	var/can_clone = FALSE		// Same for above, but will allow the printer to duplicate a specific assembly.
	var/current_category = null
	var/list/program			// Currently loaded save, in form of list

/obj/item/device/integrated_circuit_printer/proc/check_interactivity(mob/user)
	return user.canUseTopic(src, be_close = TRUE)

/obj/item/device/integrated_circuit_printer/upgraded
	upgraded = TRUE
	can_clone = TRUE

/obj/item/device/integrated_circuit_printer/Initialize()
	. = ..()
	AddComponent(/datum/component/material_container, list(MAT_METAL), MINERAL_MATERIAL_AMOUNT * 25, TRUE, list(/obj/item/stack, /obj/item/integrated_circuit))

/obj/item/device/integrated_circuit_printer/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/disk/integrated_circuit/upgrade/advanced))
		if(upgraded)
			to_chat(user, "<span class='warning'>\The [src] already has this upgrade. </span>")
			return TRUE
		to_chat(user, "<span class='notice'>You install \the [O] into \the [src]. </span>")
		upgraded = TRUE
		interact(user)
		return TRUE

	if(istype(O, /obj/item/disk/integrated_circuit/upgrade/clone))
		if(can_clone)
			to_chat(user, "<span class='warning'>\The [src] already has this upgrade. </span>")
			return TRUE
		to_chat(user, "<span class='notice'>You install \the [O] into \the [src]. </span>")
		can_clone = TRUE
		interact(user)
		return TRUE

	return ..()

/obj/item/device/integrated_circuit_printer/attack_self(var/mob/user)
	interact(user)

/obj/item/device/integrated_circuit_printer/interact(mob/user)
	if(isnull(current_category))
		current_category = SScircuit.circuit_fabricator_recipe_list[1]

	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)

	var/HTML = "<center><h2>Integrated Circuit Printer</h2></center><br>"
	HTML += "Metal: [materials.total_amount]/[materials.max_amount].<br><br>"

	if(CONFIG_GET(flag/ic_printing))
		HTML += "Assembly cloning: [can_clone ? "Available": "Unavailable"].<br>"

	HTML += "Circuits available: [upgraded ? "Advanced":"Regular"]."
	if(!upgraded)
		HTML += "<br>Crossed out circuits mean that the printer is not sufficiently upgraded to create that circuit."

	HTML += "<hr>"
	if(can_clone && CONFIG_GET(flag/ic_printing))
		HTML += "Here you can load script for your assembly.<br>"
		HTML += " <A href='?src=[REF(src)];print=load'>{Load Program}</a> "
		if(!program)
			HTML += " {Print Assembly}"
		else
			HTML += " <A href='?src=[REF(src)];print=print'>{Print Assembly}</a>"

		HTML += "<br><hr>"
	HTML += "Categories:"
	for(var/category in SScircuit.circuit_fabricator_recipe_list)
		if(category != current_category)
			HTML += " <a href='?src=[REF(src)];category=[category]'>\[[category]\]</a> "
		else // Bold the button if it's already selected.
			HTML += " <b>\[[category]\]</b> "
	HTML += "<hr>"
	HTML += "<center><h4>[current_category]</h4></center>"

	var/list/current_list = SScircuit.circuit_fabricator_recipe_list[current_category]
	for(var/path in current_list)
		var/obj/O = path
		var/can_build = TRUE
		if(ispath(path, /obj/item/integrated_circuit))
			var/obj/item/integrated_circuit/IC = path
			if((initial(IC.spawn_flags) & IC_SPAWN_RESEARCH) && (!(initial(IC.spawn_flags) & IC_SPAWN_DEFAULT)) && !upgraded)
				can_build = FALSE
		if(can_build)
			HTML += "<A href='?src=[REF(src)];build=[path]'>\[[initial(O.name)]\]</A>: [initial(O.desc)]<br>"
		else
			HTML += "<s>\[[initial(O.name)]\]</s>: [initial(O.desc)]<br>"

	user << browse(HTML, "window=integrated_printer;size=600x500;border=1;can_resize=1;can_close=1;can_minimize=1")

/obj/item/device/integrated_circuit_printer/Topic(href, href_list)
	if(!check_interactivity(usr))
		return
	if(..())
		return TRUE

	if(href_list["category"])
		current_category = href_list["category"]

	if(href_list["build"])
		var/build_type = text2path(href_list["build"])
		if(!build_type || !ispath(build_type))
			return TRUE

		var/cost = 1
		if(ispath(build_type, /obj/item/device/electronic_assembly))
			var/obj/item/device/electronic_assembly/E = build_type
			cost = round( (initial(E.max_complexity) + initial(E.max_components) ) / 4)
		else if(ispath(build_type, /obj/item/integrated_circuit))
			var/obj/item/integrated_circuit/IC = build_type
			cost = initial(IC.w_class)


		cost *= SScircuit.cost_multiplier

		var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)

		if(!materials.use_amount_type(cost, MAT_METAL))
			to_chat(usr, "<span class='warning'>You need [cost] metal to build that!</span>")
			return TRUE

		new build_type(get_turf(loc))

	if(href_list["print"])
		if(!CONFIG_GET(flag/ic_printing))
			to_chat(usr, "<span class='warning'>CentCom has disabled printing of custom circuitry due to recent allegations of copyright infringement.</span>")
			return
		switch(href_list["print"])
			if("load")
				var/input = input("Put your code there:", "loading", null, null) as message | null
				if(!check_interactivity(usr))
					return
				if(!input)
					program = null
					return

				var/validation = SScircuit.validate_electronic_assembly(input)

				// Validation error codes are returned as text.
				if(istext(validation))
					to_chat(usr, "<span class='warning'>Error: [validation]</span>")
					return
				else if(islist(validation))
					program = validation
					to_chat(usr, "<span class='notice'>This is a valid program for [program["assembly"]["type"]].</span>")
					if(program["requires_upgrades"])
						if(upgraded)
							to_chat(usr, "<span class='notice'>It uses advanced component designs.</span>")
						else
							to_chat(usr, "<span class='warning'>It uses unknown component designs. Printer upgrade is required to proceed.</span>")
					to_chat(usr, "<span class='notice'>Used space: [program["used_space"]]/[program["max_space"]].</span>")
					to_chat(usr, "<span class='notice'>Complexity: [program["complexity"]]/[program["max_complexity"]].</span>")
					to_chat(usr, "<span class='notice'>Metal cost: [program["metal_cost"]].</span>")

			if("print")
				if(!program)
					return

				if(program["requires_upgrades"] && !upgraded)
					to_chat(usr, "<span class='warning'>This program uses unknown component designs. Printer upgrade is required to proceed.</span>")
				else
					var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
					if(materials.use_amount_type(program["metal_cost"], MAT_METAL))
						SScircuit.load_electronic_assembly(get_turf(src), program)
						to_chat(usr,  "<span class='notice'>Assembly has been printed.</span>")
					else
						to_chat(usr, "<span class='warning'>You need [program["metal_cost"]] metal to build that!</span>")

	interact(usr)


// FUKKEN UPGRADE DISKS
/obj/item/disk/integrated_circuit/upgrade
	name = "integrated circuit printer upgrade disk"
	desc = "Install this into your integrated circuit printer to enhance it."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "upgrade_disk"
	item_state = "card-id"
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 4)

/obj/item/disk/integrated_circuit/upgrade/advanced
	name = "integrated circuit printer upgrade disk - advanced designs"
	desc = "Install this into your integrated circuit printer to enhance it.  This one adds new, advanced designs to the printer."

// To be implemented later.
/obj/item/disk/integrated_circuit/upgrade/clone
	name = "integrated circuit printer upgrade disk - circuit cloner"
	desc = "Install this into your integrated circuit printer to enhance it.  This one allows the printer to duplicate assemblies."
	icon_state = "upgrade_disk_clone"
<<<<<<< HEAD
	origin_tech = list(TECH_ENGINEERING = 4, TECH_DATA = 5)

/obj/item/device/integrated_circuit_printer/proc/sanity_check(var/program,var/mob/user)
	var/list/chap = splittext( program ,"{{*}}")
	if(chap.len != 6)
		return 0 //splitting incorrect
	var/list/elements = list()
	var/list/elements_input = list()
	var/list/element = list()
	var/obj/item/PA
	var/obj/item/device/electronic_assembly/PF
	var/datum/integrated_io/IO
	var/datum/integrated_io/IO2
	var/i = 0
	var/obj/item/integrated_circuit/comp
	var/list/ioa = list()
	var/list/as_samp = list()
	var/list/all_circuits = SScircuit.all_circuits // It's free. Performance. We're giving you cpu time. It's free. We're giving you time. It's performance, free. It's free cpu time for you jim!
	var/list/assembly_list = list(
			/obj/item/device/electronic_assembly,
			/obj/item/device/electronic_assembly/medium,
			/obj/item/device/electronic_assembly/large,
			/obj/item/device/electronic_assembly/drone,
		)
	var/compl = 0
	var/maxcomp = 0
	var/cap = 0
	var/maxcap = 0
	var/metalcost = 0
	for(var/k in 1 to assembly_list.len)
		var/obj/item/I = assembly_list[k]
		as_samp[initial(I.name)] = I
	if(debug)
		visible_message( "<span class='notice'>started successful</span>")
	if(chap[2] != "")
		if(debug)
			visible_message( "<span class='notice'>assembly</span>")
		element = splittext( chap[2] ,"=-=")
		PA = as_samp[element[1]]
		if(ispath(PA,/obj/item/device/electronic_assembly))
			PF = PA
			maxcap = initial(PF.max_components)
			maxcomp = initial(PF.max_complexity)
			metalcost = metalcost + round( (initial(PF.max_complexity) + initial(PF.max_components) ) / 4)
			if(debug)
				visible_message( "<span class='notice'>maxcap[maxcap]maxcomp[maxcomp]</span>")
		else
			return 0
		to_chat(usr, "<span class='notice'>This is program for [element[2]]</span>")

	else
		return 0 //what's the point if there is no assembly?
	if(chap[3] != "components")   //if there is only one word,there is no components.
		elements_input = splittext( chap[3] ,"^%^")
		if(debug)
			visible_message( "<span class='notice'>components[elements_input.len]</span>")
		i = 0
		elements = list()
		for(var/elem in elements_input)
			i=i+1
			if(i>1)
				elements.Add(elem)
		if(debug)
			visible_message( "<span class='notice'>components[elements.len]</span>")
		if(elements_input.len<1)
			return 0
		if(debug)
			visible_message( "<span class='notice'>inserting components[elements.len]</span>")
		i=0
		for(var/E in elements)
			i=i+1
			element = splittext( E ,"=-=")
			if(debug)
				visible_message( "<span class='notice'>[E]</span>")
			comp = all_circuits[element[1]]
			if(!comp)
				break
			if(!upgraded)
				var/obj/item/integrated_circuit/IC = comp
				if(!(initial(IC.spawn_flags) & IC_SPAWN_DEFAULT))
					return -1
			compl = compl + initial(comp.complexity)
			cap = cap + initial(comp.size)
			metalcost = metalcost + initial(initial(comp.w_class))
			var/obj/item/integrated_circuit/circuit = new comp
			var/list/ini = circuit.inputs
			if(length(ini))
				for(var/j in 1 to ini.len)
					var/datum/integrated_io/IN = ini[j]
					ioa["[i]i[j]"] = IN
					if(debug)
						visible_message( "<span class='notice'>[i]i[j]</span>")
			ini = circuit.outputs
			if(length(ini))
				for(var/j in 1 to ini.len)               //Also this block uses for setting all i/o id's
					var/datum/integrated_io/OUT = ini[j]
					ioa["[i]o[j]"] = OUT
					if(debug)
						visible_message( "<span class='notice'>[i]o[j]</span>")
			ini = circuit.activators
			if(length(ini))
				for(var/j in 1 to ini.len)
					var/datum/integrated_io/ACT = ini.[j]
					ioa["[i]a[j]"] = ACT
					if(debug)
						visible_message( "<span class='notice'>[i]a[j]</span>")
		if(i<elements.len)
			return 0
	else
		return 0
	if(debug)
		visible_message( "<span class='notice'>cap[cap]compl[compl]maxcompl[maxcomp]maxcap[maxcap]</span>")
	if(cap == 0)
		return 0
	if(cap>maxcap)
		return 0
	if(compl>maxcomp)
		return 0
	if(chap[4] != "values")   //if there is only one word,there is no values
		elements_input = splittext( chap[4] ,"^%^")
		if(debug)
			visible_message( "<span class='notice'>values[elements_input.len]</span>")
		i=0
		elements = list()
		for(var/elem in elements_input)
			i=i+1
			if(i>1)
				elements.Add(elem)
		if(debug)
			visible_message( "<span class='notice'>values[elements.len]</span>")
		if(elements.len>0)
			if(debug)
				visible_message( "<span class='notice'>setting values[elements.len]</span>")
			for(var/E in elements)
				element = splittext( E ,":+:")
				if(debug)
					visible_message( "<span class='notice'>[E]</span>")
				if(!ioa[element[1]])
					return 0
				if(element[2]=="text")
					continue
				else if(element[2]=="num")
					continue
				else if(element[2]=="list")
					continue
				else
					return 0

	if(chap[5] != "wires")   //if there is only one word,there is no wires
		elements_input = splittext( chap[5] ,"^%^")
		i=0
		elements = list()
		if(debug)
			visible_message( "<span class='notice'>wires[elements_input.len]</span>")
		for(var/elem in elements_input)
			i=i+1
			if(i>1)
				elements.Add(elem)
		if(debug)
			visible_message( "<span class='notice'>wires[elements.len]</span>")
		if(elements.len>0)
			if(debug)
				visible_message( "<span class='notice'>setting wires[elements.len]</span>")
			for(var/E in elements)
				element = splittext( E ,"=-=")
				if(debug)
					visible_message( "<span class='notice'>[E]</span>")
				IO = ioa[element[1]]
				IO2 = ioa[element[2]]
				if(!((element[2]+"=-="+element[1]) in elements))
					return 0
				if(!IO)
					return 0
				if(!IO2)
					return 0
				if(initial(IO.io_type) != initial(IO2.io_type))
					return 0
	return metalcost
=======
>>>>>>> b161b18... Integrated circuit fixes and code improvements (#32773)
