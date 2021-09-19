//Landmarks and other helpers which speed up the mapping process and reduce the number of unique instances/subtypes of items/turf/ect
/obj/effect/mapping_helpers
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = ""
	var/late = FALSE

/obj/effect/mapping_helpers/Initialize()
	..()
	return late ? INITIALIZE_HINT_LATELOAD : INITIALIZE_HINT_QDEL


//airlock helpers
/obj/effect/mapping_helpers/airlock
	layer = DOOR_HELPER_LAYER

/obj/effect/mapping_helpers/airlock/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return
	var/obj/machinery/door/airlock/airlock = locate(/obj/machinery/door/airlock) in loc
	if(!airlock)
		log_mapping("[src] failed to find an airlock at [AREACOORD(src)]")
	else
		payload(airlock)

/obj/effect/mapping_helpers/airlock/proc/payload(obj/machinery/door/airlock/payload)
	return

/obj/effect/mapping_helpers/airlock/cyclelink_helper
	name = "airlock cyclelink helper"
	icon_state = "airlock_cyclelink_helper"

/obj/effect/mapping_helpers/airlock/cyclelink_helper/payload(obj/machinery/door/airlock/airlock)
	if(airlock.cyclelinkeddir)
		log_mapping("[src] at [AREACOORD(src)] tried to set [airlock] cyclelinkeddir, but it's already set!")
	else
		airlock.cyclelinkeddir = dir

/obj/effect/mapping_helpers/airlock/cyclelink_helper_multi
	name = "airlock multi-cyclelink helper"
	icon_state = "airlock_multicyclelink_helper"
	var/cycle_id

/obj/effect/mapping_helpers/airlock/cyclelink_helper_multi/payload(obj/machinery/door/airlock/airlock)
	if(airlock.closeOtherId)
		log_mapping("[src] at [AREACOORD(src)] tried to set [airlock] closeOtherId, but it's already set!")
	else
		airlock.closeOtherId = cycle_id

/obj/effect/mapping_helpers/airlock/locked
	name = "airlock lock helper"
	icon_state = "airlock_locked_helper"

/obj/effect/mapping_helpers/airlock/locked/payload(obj/machinery/door/airlock/airlock)
	if(airlock.locked)
		log_mapping("[src] at [AREACOORD(src)] tried to bolt [airlock] but it's already locked!")
	else
		airlock.locked = TRUE


/obj/effect/mapping_helpers/airlock/unres
	name = "airlock unresctricted side helper"
	icon_state = "airlock_unres_helper"

/obj/effect/mapping_helpers/airlock/unres/payload(obj/machinery/door/airlock/airlock)
	airlock.unres_sides ^= dir

/obj/effect/mapping_helpers/airlock/abandoned
	name = "airlock abandoned helper"
	icon_state = "airlock_abandoned"

/obj/effect/mapping_helpers/airlock/abandoned/payload(obj/machinery/door/airlock/airlock)
	if(airlock.abandoned)
		log_mapping("[src] at [AREACOORD(src)] tried to make [airlock] abandoned but it's already abandoned!")
	else
		airlock.abandoned = TRUE


//needs to do its thing before spawn_rivers() is called
INITIALIZE_IMMEDIATE(/obj/effect/mapping_helpers/no_lava)

/obj/effect/mapping_helpers/no_lava
	icon_state = "no_lava"

/obj/effect/mapping_helpers/no_lava/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	T.flags_1 |= NO_LAVA_GEN_1

//This helper applies components to things on the map directly.
/obj/effect/mapping_helpers/component_injector
	name = "Component Injector"
	icon_state = "component"
	late = TRUE
	var/all = FALSE //Will inject into all fitting the criteria if true, otherwise first found
	var/target_type //Will inject into atoms of this type
	var/target_name //Will inject into atoms with this name
	var/component_type

//Late init so everything is likely ready and loaded (no warranty)
/obj/effect/mapping_helpers/component_injector/LateInitialize()
	if(!ispath(component_type,/datum/component))
		CRASH("Wrong component type in [type] - [component_type] is not a component")
	var/turf/T = get_turf(src)
	for(var/atom/A in T.GetAllContents())
		if(A == src)
			continue
		if(target_name && A.name != target_name)
			continue
		if(target_type && !istype(A,target_type))
			continue
		var/cargs = build_args()
		A._AddComponent(cargs)
		if(!all)
			qdel(src)
			return
	if(all)
		qdel(src)

/obj/effect/mapping_helpers/component_injector/proc/build_args()
	return list(component_type)

/obj/effect/mapping_helpers/component_injector/infective
	name = "Infective Injector"
	icon_state = "component_infective"
	component_type = /datum/component/infective
	var/disease_type

/obj/effect/mapping_helpers/component_injector/infective/build_args()
	if(!ispath(disease_type,/datum/disease))
		CRASH("Wrong disease type passed in.")
	var/datum/disease/D = new disease_type()
	return list(component_type,D)

// /obj/effect/mapping_helpers/component_injector/areabound
// 	name = "Areabound Injector"
// 	icon_state = "component_areabound"
// 	component_type = /datum/component/areabound
// 	target_type = /atom/movable

/obj/effect/mapping_helpers/dead_body_placer
	name = "Dead Body placer"
	late = TRUE
	icon_state = "deadbodyplacer"
	var/bodycount = 2 //number of bodies to spawn

/obj/effect/mapping_helpers/dead_body_placer/LateInitialize()
	var/area/a = get_area(src)
	var/list/trays = list()
	for (var/i in a.contents)
		if (istype(i, /obj/structure/bodycontainer/morgue))
			trays += i
	if(!trays.len)
		log_mapping("[src] at [x],[y] could not find any morgues.")
		return
	for (var/i = 1 to bodycount)
		var/obj/structure/bodycontainer/morgue/j = pick(trays)
		var/mob/living/carbon/human/h = new /mob/living/carbon/human(j, 1)
		h.death()
		for (var/part in h.internal_organs) //randomly remove organs from each body, set those we keep to be in stasis
			if (prob(40))
				qdel(part)
			else
				var/obj/item/organ/O = part
				O.organ_flags |= ORGAN_FROZEN
		j.update_appearance()
	qdel(src)


//On Ian's birthday, the hop's office is decorated.
/obj/effect/mapping_helpers/ianbirthday
	name = "Ian's Bday Helper"
	late = TRUE
	icon_state = "iansbdayhelper"
	var/balloon_clusters = 2

/obj/effect/mapping_helpers/ianbirthday/LateInitialize()
	if(locate(/datum/holiday/ianbirthday) in SSevents.holidays)
		birthday()
	qdel(src)

/obj/effect/mapping_helpers/ianbirthday/proc/birthday()
	var/area/a = get_area(src)
	var/list/table = list()//should only be one aka the front desk, but just in case...
	var/list/openturfs = list()

	//confetti and a corgi balloon! (and some list stuff for more decorations)
	for(var/thing in a.contents)
		if(istype(thing, /obj/structure/table/reinforced))
			table += thing
		if(isopenturf(thing))
			// new /obj/effect/decal/cleanable/confetti(thing)
			// if(locate(/obj/structure/bed/dogbed/ian) in thing)
			// 	new /obj/item/toy/balloon/corgi(thing)
			// else
			openturfs += thing

	//cake + knife to cut it!
	if(length(table))
		var/turf/food_turf = get_turf(pick(table))
		new /obj/item/kitchen/knife(food_turf)
		var/obj/item/reagent_containers/food/snacks/store/cake/birthday/iancake = new(food_turf)
		iancake.desc = "Happy birthday, Ian!"
	// remind me to give ian proper baloons!
	//some balloons! this picks an open turf and pops a few balloons in and around that turf, yay.
	// for(var/i in 1 to balloon_clusters)
	// 	var/turf/clusterspot = pick_n_take(openturfs)
	// 	new /obj/item/toy/balloon(clusterspot)
	// 	var/balloons_left_to_give = 3 //the amount of balloons around the cluster
	// 	var/list/dirs_to_balloon = GLOB.cardinals.Copy()
	// 	while(balloons_left_to_give > 0)
	// 		balloons_left_to_give--
	// 		var/chosen_dir = pick_n_take(dirs_to_balloon)
	// 		var/turf/balloonstep = get_step(clusterspot, chosen_dir)
	// 		var/placed = FALSE
	// 		if(isopenturf(balloonstep))
	// 			var/obj/item/toy/balloon/B = new(balloonstep)//this clumps the cluster together
	// 			placed = TRUE
	// 			if(chosen_dir == NORTH)
	// 				B.pixel_y -= 10
	// 			if(chosen_dir == SOUTH)
	// 				B.pixel_y += 10
	// 			if(chosen_dir == EAST)
	// 				B.pixel_x -= 10
	// 			if(chosen_dir == WEST)
	// 				B.pixel_x += 10
	// 		if(!placed)
	// 			new /obj/item/toy/balloon(clusterspot)
	//remind me to add wall decor!

/obj/effect/mapping_helpers/ianbirthday/admin//so admins may birthday any room
	name = "generic birthday setup"
	icon_state = "bdayhelper"

/obj/effect/mapping_helpers/ianbirthday/admin/LateInitialize()
	birthday()
	qdel(src)

//Ian, like most dogs, loves a good new years eve party.
/obj/effect/mapping_helpers/iannewyear
	name = "Ian's New Years Helper"
	late = TRUE
	icon_state = "iansnewyrshelper"

/obj/effect/mapping_helpers/iannewyear/LateInitialize()
	if(SSevents.holidays && SSevents.holidays[NEW_YEAR])
		fireworks()
	qdel(src)

/obj/effect/mapping_helpers/iannewyear/proc/fireworks()
	var/area/a = get_area(src)
	var/list/table = list()//should only be one aka the front desk, but just in case...
	var/list/openturfs = list()

	for(var/thing in a.contents)
		if(istype(thing, /obj/structure/table/reinforced))
			table += thing
		else if(isopenturf(thing))
			if(locate(/obj/structure/bed/dogbed/ian) in thing)
				new /obj/item/clothing/head/festive(thing)
				var/obj/item/reagent_containers/food/drinks/bottle/champagne/iandrink = new(thing)
				iandrink.name = "dog champagne"
				iandrink.pixel_y += 8
				iandrink.pixel_x += 8
			else
				openturfs += thing

	var/turf/fireworks_turf = get_turf(pick(table))
	var/obj/item/storage/box/matches/matchbox = new(fireworks_turf)
	matchbox.pixel_y += 8
	matchbox.pixel_x -= 3
	// new /obj/item/storage/box/fireworks/dangerous(fireworks_turf) //dangerous version for extra holiday memes.

//lets mappers place notes on airlocks with custom info or a pre-made note from a path
/obj/effect/mapping_helpers/airlock_note_placer
	name = "Airlock Note Placer"
	late = TRUE
	icon_state = "airlocknoteplacer"
	var/note_info //for writing out custom notes without creating an extra paper subtype
	var/note_name //custom note name
	var/note_path //if you already have something wrote up in a paper subtype, put the path here

/obj/effect/mapping_helpers/airlock_note_placer/LateInitialize()
	var/turf/turf = get_turf(src)
	if(note_path && !istype(note_path, /obj/item/paper)) //don't put non-paper in the paper slot thank you
		log_mapping("[src] at [x],[y] had an improper note_path path, could not place paper note.")
		qdel(src)
	if(locate(/obj/machinery/door/airlock) in turf)
		var/obj/machinery/door/airlock/found_airlock = locate(/obj/machinery/door/airlock) in turf
		if(note_path)
			found_airlock.note = note_path
			found_airlock.update_appearance()
			qdel(src)
		if(note_info)
			var/obj/item/paper/paper = new /obj/item/paper(src)
			if(note_name)
				paper.name = note_name
			paper.info = "[note_info]"
			found_airlock.note = paper
			paper.forceMove(found_airlock)
			found_airlock.update_appearance()
			qdel(src)
		log_mapping("[src] at [x],[y] had no note_path or note_info, cannot place paper note.")
		qdel(src)
	log_mapping("[src] at [x],[y] could not find an airlock on current turf, cannot place paper note.")
	qdel(src)

//This helper applies traits to things on the map directly.
/obj/effect/mapping_helpers/trait_injector
	name = "Trait Injector"
	icon_state = "trait"
	late = TRUE
	///Will inject into all fitting the criteria if false, otherwise first found.
	var/first_match_only = TRUE
	///Will inject into atoms of this type.
	var/target_type
	///Will inject into atoms with this name.
	var/target_name
	///Name of the trait, in the lower-case text (NOT the upper-case define) form.
	var/trait_name

//Late init so everything is likely ready and loaded (no warranty)
/obj/effect/mapping_helpers/trait_injector/LateInitialize()
	if(!GLOB.trait_name_map)
		GLOB.trait_name_map = generate_trait_name_map()
	if(!GLOB.trait_name_map.Find(trait_name))
		CRASH("Wrong trait in [type] - [trait_name] is not a trait")
	var/turf/target_turf = get_turf(src)
	var/matches_found = 0
	for(var/a in target_turf.GetAllContents())
		var/atom/atom_on_turf = a
		if(atom_on_turf == src)
			continue
		if(target_name && atom_on_turf.name != target_name)
			continue
		if(target_type && !istype(atom_on_turf,target_type))
			continue
		ADD_TRAIT(atom_on_turf, trait_name, MAPPING_HELPER_TRAIT)
		matches_found++
		if(first_match_only)
			qdel(src)
			return
	if(!matches_found)
		stack_trace("Trait mapper found no targets at ([x], [y], [z]). First Match Only: [first_match_only ? "true" : "false"] target type: [target_type] | target name: [target_name] | trait name: [trait_name]")
	qdel(src)

/// Fetches an external dmi and applies to the target object
/obj/effect/mapping_helpers/custom_icon
	name = "Custom Icon Helper"
	icon_state = "trait"
	late = TRUE
	///Will inject into all fitting the criteria if false, otherwise first found.
	var/first_match_only = TRUE
	///Will inject into atoms of this type.
	var/target_type
	///Will inject into atoms with this name.
	var/target_name
	/// This is the var tha will be set with the fetched icon. In case you want to set some secondary icon sheets like inhands and such.
	var/target_variable = "icon"
	/// This should return raw dmi in response to http get request. For example: "https://github.com/tgstation/SS13-sprites/raw/master/mob/medu.dmi?raw=true"
	var/icon_url

/obj/effect/mapping_helpers/custom_icon/LateInitialize()
	///TODO put this injector stuff under common root
	var/I = fetch_icon(icon_url)
	var/turf/target_turf = get_turf(src)
	var/matches_found = 0
	for(var/a in target_turf.GetAllContents())
		var/atom/atom_on_turf = a
		if(atom_on_turf == src)
			continue
		if(target_name && atom_on_turf.name != target_name)
			continue
		if(target_type && !istype(atom_on_turf,target_type))
			continue
		atom_on_turf.vars[target_variable] = I
		matches_found++
		if(first_match_only)
			qdel(src)
			return
	if(!matches_found)
		stack_trace("[src] found no targets at ([x], [y], [z]). First Match Only: [first_match_only ? "true" : "false"] target type: [target_type] | target name: [target_name]")
	qdel(src)

/obj/effect/mapping_helpers/custom_icon/proc/fetch_icon(url)
	var/static/icon_cache = list()
	var/static/query_in_progress = FALSE //We're using a single tmp file so keep it linear.
	if(query_in_progress)
		UNTIL(!query_in_progress)
	if(icon_cache[url])
		return icon_cache[url]
	log_asset("Custom Icon Helper fetching dmi from: [url]")
	var/datum/http_request/request = new()
	var/file_name = "tmp/custom_map_icon.dmi"
	request.prepare(RUSTG_HTTP_METHOD_GET, url , "", "", file_name)
	query_in_progress = TRUE
	request.begin_async()
	UNTIL(request.is_complete())
	var/datum/http_response/response = request.into_response()
	if(response.errored || response.status_code != 200)
		query_in_progress = FALSE
		CRASH("Failed to fetch mapped custom icon from url [url], code: [response.status_code], error: [response.error]")
	var/icon/I = new(file_name)
	icon_cache[url] = I
	query_in_progress = FALSE
	return I
