/// The limbgrower. Makes organd and limbs with synthflesh and chems.
/// See [limbgrower_designs.dm] for everything we can make.
/obj/machinery/limbgrower
	name = "limb grower"
	desc = "It grows new limbs using Synthflesh."
	icon = 'icons/obj/machines/limbgrower.dmi'
	icon_state = "limbgrower_idleoff"
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 10
	active_power_usage = 100
	circuit = /obj/item/circuitboard/machine/limbgrower

	/// The category of limbs we're browing in our UI.
	var/selected_category = "human"
	/// If we're currently printing something.
	var/busy = FALSE
	/// How efficient our machine is. Better parts = less chemicals used and less power used. Range of 1 to 0.25.
	var/production_coefficient = 1
	/// How long it takes for us to print a limb. Affected by production_coefficient.
	var/production_speed = 3 SECONDS
	/// The design we're printing currently.
	var/datum/design/being_built
	/// Our internal techweb for limbgrower designs.
	var/datum/techweb/stored_research
	/// All the categories of organs we can print.
	var/list/categories = list(
								"human",
								"lizard",
								"mammal",
								"insect",
								"fly",
								"plasmaman",
								"xeno",
								"other",
								)
	var/obj/item/disk/data/dna_disk

/obj/machinery/limbgrower/Initialize()
	create_reagents(100, OPENCONTAINER)
	stored_research = new /datum/techweb/specialized/autounlocking/limbgrower
	. = ..()
	AddComponent(/datum/component/plumbing/simple_demand)
	AddComponent(/datum/component/simple_rotation, ROTATION_WRENCH | ROTATION_CLOCKWISE, null, CALLBACK(src, .proc/can_be_rotated))

/obj/machinery/limbgrower/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Limbgrower", src)
		ui.open()

/obj/machinery/limbgrower/ui_data(mob/user)
	var/list/data = list()

	for(var/datum/reagent/reagent_id in reagents.reagent_list)
		var/list/reagent_data = list(
			reagent_name = reagent_id.name,
			reagent_amount = reagent_id.volume,
			reagent_type = reagent_id.type
		)
		data["reagents"] += list(reagent_data)

	data["total_reagents"] = reagents.total_volume
	data["max_reagents"] = reagents.maximum_volume
	data["busy"] = busy
	var/list/disk_data = list()
	disk_data["disk"] = dna_disk				//Do i, the machine, have a disk?
	disk_data["name"] = dna_disk?.fields["name"]	//Name for the human saved if there is one
	data["disk"] = disk_data

	return data

/obj/machinery/limbgrower/ui_static_data(mob/user)
	var/list/data = list()
	data["categories"] = list()

	var/species_categories = categories.Copy()
	for(var/species in species_categories)
		species_categories[species] = list()
	for(var/design_id in stored_research.researched_designs)
		var/datum/design/limb_design = SSresearch.techweb_design_by_id(design_id)
		for(var/found_category in species_categories)
			if(found_category in limb_design.category)
				species_categories[found_category] += limb_design

	for(var/category in species_categories)
		var/list/category_data = list(
			name = category,
			designs = list(),
		)
		for(var/datum/design/found_design in species_categories[category])
			var/list/all_reagents = list()
			for(var/reagent_typepath in found_design.reagents_list)
				var/datum/reagent/reagent_id = find_reagent_object_from_type(reagent_typepath)
				var/list/reagent_data = list(
					name = reagent_id.name,
					amount = (found_design.reagents_list[reagent_typepath] * production_coefficient),
				)
				all_reagents += list(reagent_data)

			category_data["designs"] += list(list(
				parent_category = category,
				name = found_design.name,
				id = found_design.id,
				needed_reagents = all_reagents,
			))

		data["categories"] += list(category_data)

	return data

/obj/machinery/limbgrower/on_deconstruction()
	for(var/obj/item/reagent_containers/glass/our_beaker in component_parts)
		reagents.trans_to(our_beaker, our_beaker.reagents.maximum_volume)
	..()

/obj/machinery/limbgrower/attackby(obj/item/user_item, mob/living/user, params)
	if (busy)
		to_chat(user, "<span class=\"alert\">\The [src] is busy. Please wait for completion of previous operation.</span>")
		return

	if(default_deconstruction_screwdriver(user, "limbgrower_panelopen", "limbgrower_idleoff", user_item))
		ui_close(user)
		return

	if(user_item.tool_behaviour == TOOL_WRENCH && panel_open)
		return ..()

	if(panel_open && default_deconstruction_crowbar(user_item))
		return

	if(istype(user_item, /obj/item/disk))
		if(dna_disk)
			to_chat(user, "<span class='warning'>\The [src] already has a dna disk, take it out first!</span>")
			return
		else
			user_item.forceMove(src)
			dna_disk = user_item
			to_chat(user, "<span class='notice'>You insert \the [user_item] into \the [src].</span>")
			playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, 0)
			return

	if(user.a_intent != INTENT_HELP)
		return ..()

/obj/machinery/limbgrower/proc/can_be_rotated()
	if(panel_open)
		return TRUE
	return FALSE

/obj/machinery/limbgrower/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	if (busy)
		to_chat(usr, "<span class='danger'>\The [src] is busy. Please wait for completion of previous operation.</span>")
		return

	switch(action)

		if("empty_reagent")
			reagents.del_reagent(text2path(params["reagent_type"]))
			. = TRUE

		if("eject_disk")
			eject_disk(usr)

		if("make_limb")
			being_built = stored_research.isDesignResearchedID(params["design_id"])
			if(!being_built)
				CRASH("[src] was passed an invalid design id!")

			/// All the reagents we're using to make our organ.
			var/list/consumed_reagents_list = being_built.reagents_list.Copy()
			/// The amount of power we're going to use, based on how much reagent we use.
			var/power = 0

			for(var/reagent_id in consumed_reagents_list)
				consumed_reagents_list[reagent_id] *= production_coefficient
				if(!reagents.has_reagent(reagent_id, consumed_reagents_list[reagent_id]))
					audible_message("<span class='notice'>\The [src] buzzes.</span>")
					playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
					return

				power = max(2000, (power + consumed_reagents_list[reagent_id]))

			busy = TRUE
			use_power(power)
			flick("limbgrower_fill",src)
			icon_state = "limbgrower_idleon"
			selected_category = params["active_tab"]
			addtimer(CALLBACK(src, .proc/build_item, consumed_reagents_list), production_speed * production_coefficient)
			. = TRUE

	return

/*
 * The process of beginning to build a limb or organ.
 * Goes through and sanity checks that we actually have enough reagent to build our item.
 * Then, remove those reagents from our reagents datum.
 *
 * After the reagents are handled, we can proceede with making the limb or organ. (Limbs are handled in a separate proc)
 *
 * modified_consumed_reagents_list - the list of reagents we will consume on build, modified by the production coefficient.
 */
/obj/machinery/limbgrower/proc/build_item(list/modified_consumed_reagents_list)
	for(var/reagent_id in modified_consumed_reagents_list)
		if(!reagents.has_reagent(reagent_id, modified_consumed_reagents_list[reagent_id]))
			audible_message("<span class='notice'>\The [src] buzzes.</span>")
			playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
			break

		reagents.remove_reagent(reagent_id, modified_consumed_reagents_list[reagent_id])

	var/built_typepath = being_built.build_path
	// If we have a bodypart, we need to initialize the limb on its own. Otherwise we can build it here.
	if(ispath(built_typepath, /obj/item/bodypart))
		build_limb(built_typepath)
	else if(ispath(built_typepath, /obj/item/organ/genital)) //genitals are uhh... customizable
		build_genital(built_typepath)
	else
		new built_typepath(loc)

	busy = FALSE
	flick("limbgrower_unfill", src)
	icon_state = "limbgrower_idleoff"

/*
 * The process of putting together a limb.
 * This is called from after we remove the reagents, so this proc is just initializing the limb type.
 *
 * This proc handles skin / mutant color, greyscaling, names and descriptions, and various other limb creation steps.
 *
 * built_typepath - the path of the bodypart we're building.
 */
/obj/machinery/limbgrower/proc/build_limb(built_typepath)
	//i need to create a body part manually using a set icon (otherwise it doesnt appear)
	var/obj/item/bodypart/limb
	var/datum/species/selected = GLOB.species_datums[selected_category]
	limb = new built_typepath(loc)
	limb.base_bp_icon = selected.icon_limbs || DEFAULT_BODYPART_ICON_ORGANIC
	limb.species_id = selected.limbs_id
	limb.color_src = (MUTCOLORS in selected.species_traits ? MUTCOLORS : (selected.use_skintones ? SKINTONE : FALSE))
	limb.should_draw_gender = (selected.sexes && (limb.body_zone in list(BODY_ZONE_HEAD, BODY_ZONE_CHEST)))
	limb.update_limb(TRUE)
	limb.update_icon_dropped()
	limb.name = "\improper synthetic [lowertext(selected.name)] [limb.name]"
	limb.desc = "A synthetic [selected_category] limb that will morph on its first use in surgery. This one is for the [parse_zone(limb.body_zone)]."
	limb.forcereplace = TRUE
	for(var/obj/item/bodypart/BP in limb)
		BP.base_bp_icon = selected.icon_limbs || DEFAULT_BODYPART_ICON_ORGANIC
		BP.species_id = selected.limbs_id
		BP.color_src = (MUTCOLORS in selected.species_traits ? MUTCOLORS : (selected.use_skintones ? SKINTONE : FALSE))
		BP.should_draw_gender = (selected.sexes && (limb.body_zone in list(BODY_ZONE_HEAD, BODY_ZONE_CHEST)))
		BP.update_limb(TRUE)
		BP.update_icon_dropped()
		BP.name = "\improper synthetic [lowertext(selected.name)] [limb.name]"
		BP.desc = "A synthetic [selected_category] limb that will morph on its first use in surgery. This one is for the [parse_zone(limb.body_zone)]."

/*
 * Builds genitals, modifies to be the same
 * as the person's cloning data on the data disk
 */
/obj/machinery/limbgrower/proc/build_genital(built_typepath)
	//i needed to create a way to customize gene tools using dna
	var/list/features = dna_disk?.fields["features"]
	if(length(features))
		switch(built_typepath)
			if(/obj/item/organ/genital/penis)
				var/obj/item/organ/genital/penis/penis = new(loc)
				if(features["has_cock"])
					penis.shape = features["cock_shape"]
					penis.length = features["cock_shape"]
					penis.diameter_ratio = features["cock_diameter_ratio"]
					penis.color = sanitize_hexcolor(features["cock_color"], 6, TRUE)
					penis.update()
			if(/obj/item/organ/genital/testicles)
				var/obj/item/organ/genital/testicles/balls = new(loc)
				if(features["has_balls"])
					balls.color = sanitize_hexcolor(features["balls_color"], 6, TRUE)
					balls.shape = features["balls_shape"]
					balls.size = features["balls_size"]
					balls.fluid_rate = features["balls_cum_rate"]
					balls.fluid_mult = features["balls_cum_mult"]
					balls.fluid_efficiency = features["balls_efficiency"]
					balls.update()
			if(/obj/item/organ/genital/vagina)
				var/obj/item/organ/genital/vagina/vegana = new(loc)
				if(features["has_vag"])
					vegana.color = sanitize_hexcolor(features["vag_color"], 6, TRUE)
					vegana.shape = features["vag_shape"]
					vegana.update()
			if(/obj/item/organ/genital/breasts)
				var/obj/item/organ/genital/breasts/boobs = new(loc)
				if(features["has_breasts"])
					boobs.color = sanitize_hexcolor(features["breasts_color"], 6, TRUE)
					boobs.size = features["breasts_size"]
					boobs.shape = features["breasts_shape"]
					if(!features["breasts_producing"])
						boobs.genital_flags &= ~(GENITAL_FUID_PRODUCTION|CAN_CLIMAX_WITH|CAN_MASTURBATE_WITH)
					boobs.update()
			else
				new built_typepath(loc)
	else
		new built_typepath(loc)

/obj/machinery/limbgrower/RefreshParts()
	reagents.maximum_volume = 0
	for(var/obj/item/reagent_containers/glass/our_beaker in component_parts)
		reagents.maximum_volume += our_beaker.volume
		our_beaker.reagents.trans_to(src, our_beaker.reagents.total_volume)
	production_coefficient = 1.2
	for(var/obj/item/stock_parts/manipulator/our_manipulator in component_parts)
		production_coefficient -= our_manipulator.rating * 0.2
	production_coefficient = clamp(production_coefficient, 0, 1) // coefficient goes from 1 -> 0.8 -> 0.6 -> 0.4

/obj/machinery/limbgrower/examine(mob/user)
	. = ..()
	if(!panel_open)
		. += "<span class='notice'>It looks like as if the panel were open you could rotate it with a <b>wrench</b>.</span>"
	else
		. += "<span class='notice'>The panel is open.</span>"
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Storing up to <b>[reagents.maximum_volume]u</b> of reagents.<br>Reagent consumption rate at <b>[production_coefficient * 100]%</b>.</span>"

/*
 * Checks our reagent list to see if a design can be built.
 *
 * limb_design - the design we're checking for buildability.
 *
 * returns TRUE if we have enough reagent to build it. Returns FALSE if we do not.
 */
/obj/machinery/limbgrower/proc/can_build(datum/design/limb_design)
	for(var/datum/reagent/reagent_id in limb_design.reagents_list)
		if(!reagents.has_reagent(reagent_id, limb_design.reagents_list[reagent_id] * production_coefficient))
			return FALSE
	return TRUE

/// Emagging a limbgrower allows you to build synthetic armblades.
/obj/machinery/limbgrower/emag_act(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		return
	for(var/design_id in SSresearch.techweb_designs)
		var/datum/design/found_design = SSresearch.techweb_design_by_id(design_id)
		if((found_design.build_type & LIMBGROWER) && ("emagged" in found_design.category))
			stored_research.add_design(found_design)
	to_chat(user, "<span class='warning'>A warning flashes onto the screen, stating that safety overrides have been deactivated!</span>")
	obj_flags |= EMAGGED
	update_static_data(user)

/obj/machinery/limbgrower/AltClick(mob/living/user)
	. = ..()
	eject_disk(user)

/obj/machinery/limbgrower/proc/eject_disk(mob/user)
	if(istype(user) && user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		if(busy)
			to_chat(user, "<span class=\"alert\">\The [src] is busy. Please wait for completion of previous operation.</span>")
		else
			if(dna_disk)
				dna_disk.forceMove(src.loc)
				user.put_in_active_hand(dna_disk)
				to_chat(user, "<span class='notice'>You remove \the [dna_disk] from \the [src].</span>")
				playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, 0)
				dna_disk = null
			else
				to_chat(user, "<span class='warning'>\The [src] has doesn't have a disk on it!")

//Defines some vars that makes limbs appears, TO-DO: define every single species.

/datum/species/human
	limbs_id = SPECIES_HUMAN
	icon_limbs = 'icons/mob/human_parts_greyscale.dmi'

/datum/species/lizard
	limbs_id = SPECIES_LIZARD
	icon_limbs = 'icons/mob/human_parts_greyscale.dmi'

/datum/species/mammal
	limbs_id = SPECIES_MAMMAL
	icon_limbs = 'icons/mob/human_parts_greyscale.dmi'

/datum/species/insect
	limbs_id = SPECIES_INSECT
	icon_limbs = 'icons/mob/human_parts_greyscale.dmi'

/datum/species/fly
	limbs_id = SPECIES_FLY
	icon_limbs = 'icons/mob/human_parts.dmi'

/datum/species/plasmaman
	limbs_id = SPECIES_PLASMAMAN
	icon_limbs = 'icons/mob/human_parts.dmi'

/datum/species/xeno
	limbs_id = SPECIES_XENOHYBRID
	icon_limbs = 'icons/mob/human_parts_greyscale.dmi'
