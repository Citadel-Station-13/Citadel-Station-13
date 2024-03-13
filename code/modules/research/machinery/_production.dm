/obj/machinery/rnd/production
	name = "technology fabricator"
	desc = "Makes researched and prototype items with materials and energy."
	layer = BELOW_OBJ_LAYER
	var/consoleless_interface = TRUE			//Whether it can be used without a console.
	var/print_cost_coeff = 1				//Materials needed * coeff = actual.
	var/list/categories = list()
	var/datum/component/remote_materials/materials
	var/allowed_department_flags = ALL
	var/production_animation				//What's flick()'d on print.
	var/allowed_buildtypes = NONE
	var/list/datum/design/cached_designs
	var/list/datum/design/matching_designs
	var/department_tag = "Unidentified"			//used for material distribution among other things.
	var/datum/techweb/stored_research
	var/datum/techweb/host_research

	var/screen = RESEARCH_FABRICATOR_SCREEN_MAIN
	var/selected_category

	var/offstation_security_levels

/obj/machinery/rnd/production/Initialize(mapload)
	if(mapload && offstation_security_levels)
		log_mapping("Depricated var named \"offstation_security_levels\" at ([x], [y], [z])!")
	. = ..()
	create_reagents(0, OPENCONTAINER)
	matching_designs = list()
	cached_designs = list()
	stored_research = new
	host_research = SSresearch.science_tech
	update_research()
	materials = AddComponent(/datum/component/remote_materials, "lathe", mapload, _after_insert=CALLBACK(src, PROC_REF(AfterMaterialInsert)))
	RefreshParts()

/obj/machinery/rnd/production/Destroy()
	materials = null
	cached_designs = null
	matching_designs = null
	QDEL_NULL(stored_research)
	host_research = null
	return ..()

/obj/machinery/rnd/production/proc/update_research()
	set waitfor = FALSE
	host_research.copy_research_to(stored_research, TRUE)
	update_designs()

/obj/machinery/rnd/production/proc/update_designs()
	cached_designs.Cut()
	for(var/i in stored_research.researched_designs)
		var/datum/design/d = SSresearch.techweb_design_by_id(i)
		if((isnull(allowed_department_flags) || (d.departmental_flags & allowed_department_flags)) && (d.build_type & allowed_buildtypes))
			cached_designs |= d

/obj/machinery/rnd/production/RefreshParts()
	calculate_efficiency()

/obj/machinery/rnd/production/ui_interact(mob/user)
	if(!consoleless_interface)
		return ..()
	user.set_machine(src)
	var/datum/browser/popup = new(user, "rndconsole", name, 460, 550)
	popup.set_content(generate_ui())
	popup.open()

/obj/machinery/rnd/production/proc/calculate_efficiency()
	var/total_manip_rating = 0
	var/manips = 0
	if(reagents)		//If reagents/materials aren't initialized, don't bother, we'll be doing this again after reagents init anyways.
		reagents.maximum_volume = 0
		for(var/obj/item/reagent_containers/glass/G in component_parts)
			reagents.maximum_volume += G.volume
			G.reagents.trans_to(src, G.reagents.total_volume)
	if(materials)
		var/total_storage = 0
		for(var/obj/item/stock_parts/matter_bin/M in component_parts)
			total_storage += M.rating * 75000
		materials.set_local_size(total_storage)
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		total_manip_rating += M.rating
		manips++
	print_cost_coeff = STANDARD_PART_LEVEL_LATHE_COEFFICIENT(total_manip_rating / (manips? manips : 1))

/obj/machinery/rnd/production/examine(mob/user)
	. = ..()
	var/datum/component/remote_materials/materials = GetComponent(/datum/component/remote_materials)
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Storing up to <b>[materials.local_size]</b> material units locally.<br>Material usage cost at <b>[print_cost_coeff*100]%</b>.</span>"

//we eject the materials upon deconstruction.
/obj/machinery/rnd/production/on_deconstruction()
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		reagents.trans_to(G, G.reagents.maximum_volume)
	return ..()

/obj/machinery/rnd/production/proc/do_print(path, amount, list/matlist, notify_admins, mob/user)
	if(notify_admins)
		message_admins("[ADMIN_LOOKUPFLW(user)] has built [amount] of [path] at a [src]([type]).")
	for(var/i in 1 to amount)
		var/obj/O = new path(get_turf(src))
		if(efficient_with(O.type))
			O.set_custom_materials(matlist)
			O.rnd_crafted(src)
	SSblackbox.record_feedback("nested tally", "item_printed", amount, list("[type]", "[path]"))
	investigate_log("[key_name(user)] built [amount] of [path] at [src]([type]).", INVESTIGATE_RESEARCH)

/obj/machinery/rnd/production/proc/check_mat(datum/design/being_built, var/mat)	// now returns how many times the item can be built with the material
	if (!materials.mat_container)  // no connected silo
		return FALSE
	var/list/all_materials = being_built.reagents_list + being_built.materials

	var/A = materials.mat_container.get_material_amount(mat)
	if(!A)
		A = reagents.get_reagent_amount(mat)

	// these types don't have their .materials set in do_print, so don't allow
	// them to be constructed efficiently
	var/ef = efficient_with(being_built.build_path) ? print_cost_coeff : 1
	return round(A / max(1, all_materials[mat] * ef))

/obj/machinery/rnd/production/proc/efficient_with(path)
	return !ispath(path, /obj/item/stack/sheet) && !ispath(path, /obj/item/stack/ore/bluespace_crystal) && !ispath(path, /obj/item/stack/ducts)

/obj/machinery/rnd/production/proc/user_try_print_id(id, amount)
	if((!istype(linked_console) && requires_console) || !id)
		return FALSE
	if(istext(amount))
		amount = text2num(amount)
	if(isnull(amount))
		amount = 1
	var/datum/design/D = (linked_console || requires_console)? (linked_console.stored_research.researched_designs[id]? SSresearch.techweb_design_by_id(id) : null) : SSresearch.techweb_design_by_id(id)
	if(!istype(D))
		return FALSE
	if(!(isnull(allowed_department_flags) || (D.departmental_flags & allowed_department_flags)))
		say("Warning: Printing failed: This fabricator does not have the necessary keys to decrypt design schematics. Please update the research data with the on-screen button and contact Nanotrasen Support!")
		return FALSE
	if(D.build_type && !(D.build_type & allowed_buildtypes))
		say("This machine does not have the necessary manipulation systems for this design. Please contact Nanotrasen Support!")
		return FALSE
	if(!(obj_flags & EMAGGED) && (offstation_security_levels || is_station_level(z)))
		if(GLOB.security_level < D.min_security_level)
			say("Minimum security alert level required to print this design not met, please contact the command staff.")
			return FALSE
		if(GLOB.security_level > D.max_security_level)
			say("Exceeded maximum security alert level required to print this design, please contact the command staff.")
	if(!materials.mat_container)
		say("No connection to material storage, please contact the quartermaster.")
		return FALSE
	if(materials.on_hold())
		say("Mineral access is on hold, please contact the quartermaster.")
		return FALSE
	var/power = 1000
	amount = clamp(amount, 1, 50)
	for(var/M in D.materials)
		power += round(D.materials[M] * amount / 35)
	power = min(3000, power)
	use_power(power)
	var/coeff = efficient_with(D.build_path) ? print_cost_coeff : 1
	var/list/efficient_mats = list()
	for(var/MAT in D.materials)
		efficient_mats[MAT] = D.materials[MAT] * coeff
	if(!materials.mat_container.has_materials(efficient_mats, amount))
		say("Not enough materials to complete prototype[amount > 1? "s" : ""].")
		return FALSE
	for(var/R in D.reagents_list)
		if(!reagents.has_reagent(R, D.reagents_list[R] * amount * coeff))
			say("Not enough reagents to complete prototype[amount > 1? "s" : ""].")
			return FALSE
	materials.mat_container.use_materials(efficient_mats, amount)
	materials.silo_log(src, "built", -amount, "[D.name]", efficient_mats)
	for(var/R in D.reagents_list)
		reagents.remove_reagent(R, D.reagents_list[R] * amount * coeff)
	busy = TRUE
	if(production_animation)
		flick(production_animation, src)
	var/timecoeff = D.lathe_time_factor * print_cost_coeff
	addtimer(CALLBACK(src, PROC_REF(reset_busy)), (20 * timecoeff * amount) ** 0.5)
	addtimer(CALLBACK(src, PROC_REF(do_print), D.build_path, amount, efficient_mats, D.dangerous_construction, usr), (20 * timecoeff * amount) ** 0.5)
	return TRUE

/obj/machinery/rnd/production/proc/search(string)
	matching_designs.Cut()
	for(var/v in stored_research.researched_designs)
		var/datum/design/D = SSresearch.techweb_design_by_id(v)
		if(!(D.build_type & allowed_buildtypes) || !(isnull(allowed_department_flags) || (D.departmental_flags & allowed_department_flags)))
			continue
		if(findtext(D.name,string))
			matching_designs.Add(D)

/obj/machinery/rnd/production/proc/generate_ui()
	var/list/ui = list()
	ui += ui_header()
	switch(screen)
		if(RESEARCH_FABRICATOR_SCREEN_MATERIALS)
			ui += ui_screen_materials()
		if(RESEARCH_FABRICATOR_SCREEN_CHEMICALS)
			ui += ui_screen_chemicals()
		if(RESEARCH_FABRICATOR_SCREEN_SEARCH)
			ui += ui_screen_search()
		if(RESEARCH_FABRICATOR_SCREEN_CATEGORYVIEW)
			ui += ui_screen_category_view()
		else
			ui += ui_screen_main()
	for(var/i in 1 to length(ui))
		if(!findtextEx(ui[i], RDSCREEN_NOBREAK))
			ui[i] += "<br>"
		ui[i] = replacetextEx(ui[i], RDSCREEN_NOBREAK, "")
	return ui.Join("")

/obj/machinery/rnd/production/proc/ui_header()
	var/list/l = list()
	l += "<div class='statusDisplay'><b>[host_research.organization] [department_tag] Department Lathe</b>"
	l += "Security protocols: [(obj_flags & EMAGGED)? "<font color='red'>Disabled</font>" : "<font color='green'>Enabled</font>"]"
	if (materials.mat_container)
		l += "<A href='?src=[REF(src)];switch_screen=[RESEARCH_FABRICATOR_SCREEN_MATERIALS]'><B>Material Amount:</B> [materials.format_amount()]</A>"
	else
		l += "<font color='red'>No material storage connected, please contact the quartermaster.</font>"
	l += "<A href='?src=[REF(src)];switch_screen=[RESEARCH_FABRICATOR_SCREEN_CHEMICALS]'><B>Chemical volume:</B> [reagents.total_volume] / [reagents.maximum_volume]</A>"
	l += "<a href='?src=[REF(src)];sync_research=1'>Synchronize Research</a>"
	l += "<a href='?src=[REF(src)];switch_screen=[RESEARCH_FABRICATOR_SCREEN_MAIN]'>Main Screen</a></div>[RDSCREEN_NOBREAK]"
	return l

/obj/machinery/rnd/production/proc/ui_screen_materials()
	if (!materials.mat_container)
		screen = RESEARCH_FABRICATOR_SCREEN_MAIN
		return ui_screen_main()
	var/list/l = list()
	l += "<div class='statusDisplay'><h3>Material Storage:</h3>"
	for(var/mat_id in materials.mat_container.materials)
		var/datum/material/M = mat_id
		var/amount = materials.mat_container.materials[mat_id]
		var/ref = REF(M)
		l += "* [amount] of [M.name]: "
		if(amount >= MINERAL_MATERIAL_AMOUNT) l += "<A href='?src=[REF(src)];ejectsheet=[ref];eject_amt=1'>1x</A> [RDSCREEN_NOBREAK]"
		if(amount >= MINERAL_MATERIAL_AMOUNT*5) l += "<A href='?src=[REF(src)];ejectsheet=[ref];eject_amt=5'>5x</A> [RDSCREEN_NOBREAK]"
		if(amount >= MINERAL_MATERIAL_AMOUNT*10) l += "<A href='?src=[REF(src)];ejectsheet=[ref];eject_amt=10'>10x</A> [RDSCREEN_NOBREAK]"
		if(amount >= MINERAL_MATERIAL_AMOUNT*20) l += "<A href='?src=[REF(src)];ejectsheet=[ref];eject_amt=20'>20x</A> [RDSCREEN_NOBREAK]"
		if(amount >= MINERAL_MATERIAL_AMOUNT*50) l += "<A href='?src=[REF(src)];ejectsheet=[ref];eject_amt=50'>50x</A> [RDSCREEN_NOBREAK]"
		if(amount >= MINERAL_MATERIAL_AMOUNT) l += "<A href='?src=[REF(src)];ejectsheet=[ref];eject_amt=50'>Max Stack</A>[RDSCREEN_NOBREAK]"
		l += ""
	l += "</div>[RDSCREEN_NOBREAK]"
	return l

/obj/machinery/rnd/production/proc/ui_screen_chemicals()
	var/list/l = list()
	l += "<div class='statusDisplay'><A href='?src=[REF(src)];disposeall=1'>Disposal All Chemicals in Storage</A>"
	l += "<h3>Chemical Storage:</h3>"
	for(var/datum/reagent/R in reagents.reagent_list)
		l += "[R.name]: [R.volume]"
		l += "<A href='?src=[REF(src)];dispose=[R.type]'>Purge</A>"
	l += "</div>"
	return l

/obj/machinery/rnd/production/proc/ui_screen_search()
	var/list/l = list()
	var/coeff = print_cost_coeff
	l += "<h2>Search Results:</h2>"
	l += "<form name='search' action='?src=[REF(src)]'>\
	<input type='hidden' name='src' value='[REF(src)]'>\
	<input type='hidden' name='search' value='to_search'>\
	<input type='text' name='to_search'>\
	<input type='submit' value='Search'>\
	</form><HR>"
	for(var/datum/design/D in matching_designs)
		l += design_menu_entry(D, coeff)
	l += "</div>"
	return l

/obj/machinery/rnd/production/proc/design_menu_entry(datum/design/D, coeff)
	if(!istype(D))
		return
	if(!coeff)
		coeff = print_cost_coeff
	if(!efficient_with(D.build_path))
		coeff = 1
	var/list/l = list()
	var/temp_material
	var/c = 50
	var/t
	var/all_materials = D.materials + D.reagents_list
	for(var/M in all_materials)
		t = check_mat(D, M)
		temp_material += " | "
		if (t < 1)
			temp_material += "<span class='bad'>[all_materials[M] * coeff] [CallMaterialName(M)]</span>"
		else
			temp_material += " [all_materials[M] * coeff] [CallMaterialName(M)]"
		c = min(c,t)

	var/clearance = !(obj_flags & EMAGGED) && (offstation_security_levels || is_station_level(z))
	var/sec_text = ""
	if(clearance && (D.min_security_level > SEC_LEVEL_GREEN || D.max_security_level < SEC_LEVEL_DELTA))
		sec_text = " (Allowed security levels: "
		for(var/n in D.min_security_level to D.max_security_level)
			sec_text += NUM2SECLEVEL(n)
			if(n + 1 <= D.max_security_level)
				sec_text += ", "
		sec_text += ")"

	clearance = !clearance || ISINRANGE(GLOB.security_level, D.min_security_level, D.max_security_level)
	if (c >= 1 && clearance)
		l += "<A href='?src=[REF(src)];build=[D.id];amount=1'>[D.name]</A>[RDSCREEN_NOBREAK]"
		if(c >= 5)
			l += "<A href='?src=[REF(src)];build=[D.id];amount=5'>x5</A>[RDSCREEN_NOBREAK]"
		if(c >= 10)
			l += "<A href='?src=[REF(src)];build=[D.id];amount=10'>x10</A>[RDSCREEN_NOBREAK]"
		l += "[temp_material][sec_text][RDSCREEN_NOBREAK]"
	else
		l += "<span class='linkOff'>[D.name]</span>[temp_material][sec_text][RDSCREEN_NOBREAK]"
	l += ""
	return l

/obj/machinery/rnd/production/Topic(raw, ls)
	if(..())
		return
	add_fingerprint(usr)
	usr.set_machine(src)
	if(ls["switch_screen"])
		screen = text2num(ls["switch_screen"])
	if(ls["build"]) //Causes the Protolathe to build something.
		if(busy)
			say("Warning: Fabricators busy!")
		else
			user_try_print_id(ls["build"], ls["amount"])
	if(ls["search"]) //Search for designs with name matching pattern
		search(ls["to_search"])
		screen = RESEARCH_FABRICATOR_SCREEN_SEARCH
	if(ls["sync_research"])
		update_research()
		say("Synchronizing research with host technology database.")
	if(ls["category"])
		selected_category = ls["category"]
	if(ls["dispose"])  //Causes the protolathe to dispose of a single reagent (all of it)
		reagents.del_reagent(ls["dispose"])
	if(ls["disposeall"]) //Causes the protolathe to dispose of all it's reagents.
		reagents.clear_reagents()
	if(ls["ejectsheet"]) //Causes the protolathe to eject a sheet of material
		var/datum/material/M = locate(ls["ejectsheet"])
		eject_sheets(M, ls["eject_amt"])
	updateUsrDialog()

/obj/machinery/rnd/production/proc/eject_sheets(eject_sheet, eject_amt)
	var/datum/component/material_container/mat_container = materials.mat_container
	if (!mat_container)
		say("No access to material storage, please contact the quartermaster.")
		return FALSE
	if (materials.on_hold())
		say("Mineral access is on hold, please contact the quartermaster.")
		return FALSE
	var/count = mat_container.retrieve_sheets(text2num(eject_amt), eject_sheet, drop_location())
	var/list/matlist = list()
	matlist[eject_sheet] = MINERAL_MATERIAL_AMOUNT
	materials.silo_log(src, "ejected", -count, "sheets", matlist)
	return count

/obj/machinery/rnd/production/proc/ui_screen_main()
	var/list/l = list()
	l += "<form name='search' action='?src=[REF(src)]'>\
	<input type='hidden' name='src' value='[REF(src)]'>\
	<input type='hidden' name='search' value='to_search'>\
	<input type='hidden' name='type' value='proto'>\
	<input type='text' name='to_search'>\
	<input type='submit' value='Search'>\
	</form><HR>"

	l += list_categories(categories, RESEARCH_FABRICATOR_SCREEN_CATEGORYVIEW)

	return l

/obj/machinery/rnd/production/proc/ui_screen_category_view()
	if(!selected_category)
		return ui_screen_main()
	var/list/l = list()
	l += "<div class='statusDisplay'><h3>Browsing [selected_category]:</h3>"
	var/coeff = print_cost_coeff
	for(var/v in stored_research.researched_designs)
		var/datum/design/D = SSresearch.techweb_design_by_id(v)
		if(!(selected_category in D.category)|| !(D.build_type & allowed_buildtypes))
			continue
		if(!(isnull(allowed_department_flags) || (D.departmental_flags & allowed_department_flags)))
			continue
		l += design_menu_entry(D, coeff)
	l += "</div>"
	return l

/obj/machinery/rnd/production/proc/list_categories(list/categories, menu_num)
	if(!categories)
		return

	var/line_length = 1
	var/list/l = "<table style='width:100%' align='center'><tr>"

	for(var/C in categories)
		if(line_length > 2)
			l += "</tr><tr>"
			line_length = 1

		l += "<td><A href='?src=[REF(src)];category=[C];switch_screen=[menu_num]'>[C]</A></td>"
		line_length++

	l += "</tr></table></div>"
	return l
