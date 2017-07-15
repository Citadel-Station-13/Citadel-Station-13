//generates a component in the global component cache, either random based on lowest or a specific component
/proc/generate_cache_component(specific_component_id, atom/A)
	if(!specific_component_id)
		specific_component_id = get_weighted_component_id()
	GLOB.clockwork_component_cache[specific_component_id]++
	if(A)
		var/component_animation_type = get_component_animation_type(specific_component_id)
		new component_animation_type(get_turf(A))
	update_slab_info()
	return specific_component_id

//returns a chosen component id based on the lowest amount of that component in the global cache, the global cache plus the slab if there are caches, or the slab if there are no caches.
/proc/get_weighted_component_id(obj/item/clockwork/slab/storage_slab)
	. = list()
	if(storage_slab)
		if(GLOB.clockwork_caches)
			for(var/i in GLOB.clockwork_component_cache)
				.[i] = max(MAX_COMPONENTS_BEFORE_RAND - LOWER_PROB_PER_COMPONENT*(GLOB.clockwork_component_cache[i] + storage_slab.stored_components[i]), 1)
		else
			for(var/i in GLOB.clockwork_component_cache)
				.[i] = max(MAX_COMPONENTS_BEFORE_RAND - LOWER_PROB_PER_COMPONENT*storage_slab.stored_components[i], 1)
	else
		for(var/i in GLOB.clockwork_component_cache)
			.[i] = max(MAX_COMPONENTS_BEFORE_RAND - LOWER_PROB_PER_COMPONENT*GLOB.clockwork_component_cache[i], 1)
	for(var/obj/structure/destructible/clockwork/massive/celestial_gateway/G in GLOB.all_clockwork_objects)
		if(G.still_needs_components())
			for(var/i in G.required_components)
				if(!G.required_components[i])
					. -= i
		break
	. = pickweight(.)

//returns a component name from a component id
/proc/get_component_name(id)
	switch(id)
		if(BELLIGERENT_EYE)
			return "Belligerent Eye"
		if(VANGUARD_COGWHEEL)
			return "Vanguard Cogwheel"
		if(GEIS_CAPACITOR)
			return "Geis Capacitor"
		if(REPLICANT_ALLOY)
			return "Replicant Alloy"
		if(HIEROPHANT_ANSIBLE)
			return "Hierophant Ansible"
		else
			return null

//returns a component acronym from a component id
/proc/get_component_acronym(id)
	switch(id)
		if(BELLIGERENT_EYE)
			return "BE"
		if(VANGUARD_COGWHEEL)
			return "VC"
		if(GEIS_CAPACITOR)
			return "GC"
		if(REPLICANT_ALLOY)
			return "RA"
		if(HIEROPHANT_ANSIBLE)
			return "HA"
		else
			return null

//returns a component icon from a component id
/proc/get_component_icon(id)
	var/static/list/tgui_component_icons = list(
		BELLIGERENT_EYE = icon2base64(icon('icons/obj/tgui_components.dmi', BELLIGERENT_EYE)),
		VANGUARD_COGWHEEL = icon2base64(icon('icons/obj/tgui_components.dmi', VANGUARD_COGWHEEL)),
		GEIS_CAPACITOR = icon2base64(icon('icons/obj/tgui_components.dmi', GEIS_CAPACITOR)),
		REPLICANT_ALLOY = icon2base64(icon('icons/obj/tgui_components.dmi', REPLICANT_ALLOY)),
		HIEROPHANT_ANSIBLE = icon2base64(icon('icons/obj/tgui_components.dmi', HIEROPHANT_ANSIBLE)))
	return "<img style='width:14px; height:14px' src='data:image/png;base64,[tgui_component_icons[id]]'/>"

//returns a component id from a component name
/proc/get_component_id(name)
	switch(name)
		if("Belligerent Eye")
			return BELLIGERENT_EYE
		if("Vanguard Cogwheel")
			return VANGUARD_COGWHEEL
		if("Geis Capacitor")
			return GEIS_CAPACITOR
		if("Replicant Alloy")
			return REPLICANT_ALLOY
		if("Hierophant Ansible")
			return HIEROPHANT_ANSIBLE
		else
			return null

//returns a component spanclass from a component id
/proc/get_component_span(id)
	switch(id)
		if(BELLIGERENT_EYE)
			return "neovgre"
		if(VANGUARD_COGWHEEL)
			return "inathneq"
		if(GEIS_CAPACITOR)
			return "sevtug"
		if(REPLICANT_ALLOY)
			return "nezbere"
		if(HIEROPHANT_ANSIBLE)
			return "nzcrentr"
		else
			return "brass"

//returns a component color from a component id, but with brighter colors for the darkest
/proc/get_component_color_bright(id)
	switch(id)
		if(BELLIGERENT_EYE)
			return "#880020"
		if(REPLICANT_ALLOY)
			return "#5A6068"
		else
			return get_component_color(id)

//returns a component color from a component id
/proc/get_component_color(id)
	switch(id)
		if(BELLIGERENT_EYE)
			return "#6E001A"
		if(VANGUARD_COGWHEEL)
			return "#1E8CE1"
		if(GEIS_CAPACITOR)
			return "#AF0AAF"
		if(REPLICANT_ALLOY)
			return "#42474D"
		if(HIEROPHANT_ANSIBLE)
			return "#DAAA18"
		else
			return "#BE8700"

//returns a type for a floating component animation from a component id
/proc/get_component_animation_type(id)
	switch(id)
		if(BELLIGERENT_EYE)
			return /obj/effect/temp_visual/ratvar/component
		if(VANGUARD_COGWHEEL)
			return /obj/effect/temp_visual/ratvar/component/cogwheel
		if(GEIS_CAPACITOR)
			return /obj/effect/temp_visual/ratvar/component/capacitor
		if(REPLICANT_ALLOY)
			return /obj/effect/temp_visual/ratvar/component/alloy
		if(HIEROPHANT_ANSIBLE)
			return /obj/effect/temp_visual/ratvar/component/ansible
		else
			return null

//returns a type for a component from a component id
/proc/get_component_type(id)
	switch(id)
		if(BELLIGERENT_EYE)
			return /obj/item/clockwork/component/belligerent_eye
		if(VANGUARD_COGWHEEL)
			return /obj/item/clockwork/component/vanguard_cogwheel
		if(GEIS_CAPACITOR)
			return /obj/item/clockwork/component/geis_capacitor
		if(REPLICANT_ALLOY)
			return /obj/item/clockwork/component/replicant_alloy
		if(HIEROPHANT_ANSIBLE)
			return /obj/item/clockwork/component/hierophant_ansible
		else
			return null