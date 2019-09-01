/obj/item/organ/genital
	color = "#fcccb3"
	w_class = WEIGHT_CLASS_NORMAL
	var/shape = "human"
	var/sensitivity = AROUSAL_START_VALUE
	var/genital_flags //see citadel_defines.dm
	var/masturbation_verb = "masturbate"
	var/orgasm_verb = "cumming" //present continous
	var/fluid_transfer_factor = 0 //How much would a partner get in them if they climax using this?
	var/size = 2 //can vary between num or text, just used in icon_state strings
	var/fluid_id = null
	var/fluid_max_volume = 50
	var/fluid_efficiency = 1
	var/fluid_rate = CUM_RATE
	var/fluid_mult = 1
	var/aroused_state = FALSE //Boolean used in icon_state strings
	var/aroused_amount = 50 //This is a num from 0 to 100 for arousal percentage for when to use arousal state icons.
	var/obj/item/organ/genital/linked_organ
	var/linked_organ_slot //only one of the two organs needs this to be set up. update_link() will handle linking the rest.
	var/layer_index = GENITAL_LAYER_INDEX //Order should be very important. FIRST vagina, THEN testicles, THEN penis, as this affects the order they are rendered in.

/obj/item/organ/genital/Initialize(mapload, mob/living/carbon/human/H)
	. = ..()
	if(fluid_id)
		create_reagents(fluid_max_volume)
		if(CHECK_BITFIELD(genital_flags, GENITAL_FUID_PRODUCTION))
			reagents.add_reagent(fluid_id, fluid_max_volume)
	if(H)
		get_features(H)
		Insert(H)
	else
		update()

/obj/item/organ/genital/Destroy()
	if(linked_organ)
		update_link(TRUE)//this should remove any other links it has
	if(owner)
		Remove(owner, TRUE)//this should remove references to it, so it can be GCd correctly
	return ..()

/obj/item/organ/genital/proc/update(removing = FALSE)
	if(QDELETED(src))
		return
	update_size()
	update_appearance()
	if(linked_organ_slot || (linked_organ && removing))
		update_link(removing)

//exposure and through-clothing code
/mob/living/carbon
	var/list/exposed_genitals = list() //Keeping track of them so we don't have to iterate through every genitalia and see if exposed

/obj/item/organ/genital/proc/is_exposed()
	if(!owner || CHECK_BITFIELD(genital_flags, GENITAL_INTERNAL) || CHECK_BITFIELD(genital_flags, GENITAL_HIDDEN))
		return FALSE
	if(CHECK_BITFIELD(genital_flags, GENITAL_THROUGH_CLOTHES))
		return TRUE

	switch(zone) //update as more genitals are added
		if(BODY_ZONE_CHEST)
			return owner.is_chest_exposed()
		if(BODY_ZONE_PRECISE_GROIN)
			return owner.is_groin_exposed()

/obj/item/organ/genital/proc/toggle_visibility(visibility)
	switch(visibility)
		if("Always visible")
			ENABLE_BITFIELD(genital_flags, GENITAL_THROUGH_CLOTHES)
			DISABLE_BITFIELD(genital_flags, GENITAL_HIDDEN)
			if(!(src in owner.exposed_genitals))
				owner.exposed_genitals += src
		if("Hidden by clothes")
			DISABLE_BITFIELD(genital_flags, GENITAL_THROUGH_CLOTHES)
			DISABLE_BITFIELD(genital_flags, GENITAL_HIDDEN)
			if(src in owner.exposed_genitals)
				owner.exposed_genitals -= src
		if("Always hidden")
			DISABLE_BITFIELD(genital_flags, GENITAL_THROUGH_CLOTHES)
			ENABLE_BITFIELD(genital_flags, GENITAL_HIDDEN)
			if(src in owner.exposed_genitals)
				owner.exposed_genitals -= src

	if(ishuman(owner)) //recast to use update genitals proc
		var/mob/living/carbon/human/H = owner
		H.update_genitals()

/mob/living/carbon/verb/toggle_genitals()
	set category = "IC"
	set name = "Expose/Hide genitals"
	set desc = "Allows you to toggle which genitals should show through clothes or not."

	var/list/genital_list = list()
	for(var/obj/item/organ/O in internal_organs)
		if(isgenital(O))
			var/obj/item/organ/genital/G = O
			if(!CHECK_BITFIELD(G.genital_flags, GENITAL_INTERNAL))
				genital_list += G
	if(!genital_list.len) //There is nothing to expose
		return
	//Full list of exposable genitals created
	var/obj/item/organ/genital/picked_organ
	picked_organ = input(src, "Choose which genitalia to expose/hide", "Expose/Hide genitals", null) in genital_list
	if(picked_organ)
		var/picked_visibility = input(src, "Choose visibility setting", "Expose/Hide genitals", "Hidden by clothes") in list("Always visible", "Hidden by clothes", "Always hidden")
		picked_organ.toggle_visibility(picked_visibility)
	return

/obj/item/organ/genital/proc/update_size()
	return

/obj/item/organ/genital/proc/update_appearance()
	if(!owner || owner.stat == DEAD)
		aroused_state = FALSE
	return

/obj/item/organ/genital/on_life()
	if(!reagents || !owner)
		return
	reagents.maximum_volume = fluid_max_volume
	if(fluid_id && CHECK_BITFIELD(genital_flags, GENITAL_FUID_PRODUCTION))
		generate_fluid()

/obj/item/organ/genital/proc/generate_fluid()
	var/amount = fluid_rate
	if(!reagents.total_volume && amount < 0.1) // Apparently, 0.015 gets rounded down to zero and no reagents are created if we don't start it with 0.1 in the tank.
		amount += 0.1
	var/multiplier = fluid_mult
	if(reagents.total_volume >= 5)
		multiplier *= 0.5
	if(reagents.total_volume < reagents.maximum_volume)
		reagents.isolate_reagent(fluid_id)//remove old reagents if it changed and just clean up generally
		reagents.add_reagent(fluid_id, (amount * multiplier))//generate the cum
		return TRUE
	return FALSE

/obj/item/organ/genital/proc/update_link(removing = FALSE)
	if(!removing && owner)
		linked_organ = owner.getorganslot(linked_organ_slot)
		if(linked_organ)
			linked_organ.linked_organ = src
			return TRUE
	else
		if(linked_organ)
			linked_organ.linked_organ = null
		linked_organ = null
	return FALSE

/obj/item/organ/genital/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	if(.)
		update()
		RegisterSignal(owner, COMSIG_MOB_DEATH, .proc/update)

/obj/item/organ/genital/Remove(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	if(.)
		update(TRUE)
		UnregisterSignal(M, COMSIG_MOB_DEATH)

//proc to give a player their genitals and stuff when they log in
/mob/living/carbon/human/proc/give_genitals(clean = FALSE)//clean will remove all pre-existing genitals. proc will then give them any genitals that are enabled in their DNA
	if(clean)
		for(var/obj/item/organ/genital/G in internal_organs)
			qdel(G)
	if (NOGENITALS in dna.species.species_traits)
		return
	if(dna.features["has_vag"])
		give_genital(/obj/item/organ/genital/vagina)
	if(dna.features["has_womb"])
		give_genital(/obj/item/organ/genital/womb)
	if(dna.features["has_balls"])
		give_genital(/obj/item/organ/genital/testicles)
	if(dna.features["has_breasts"])
		give_genital(/obj/item/organ/genital/breasts)
	if(dna.features["has_cock"])
		give_genital(/obj/item/organ/genital/penis)
	/*
	if(dna.features["has_ovi"])
		give_genital(/obj/item/organ/genital/ovipositor)
	if(dna.features["has_eggsack"])
		give_genital(/obj/item/organ/genital/eggsack)
	*/

/mob/living/carbon/human/proc/give_genital(obj/item/organ/genital/G)
	if(!dna || (NOGENITALS in dna.species.species_traits) || getorganslot(initial(G.slot)))
		return FALSE
	G = new G(null, src)
	return G

/obj/item/organ/genital/proc/get_features(mob/living/carbon/human/H)
	return

/datum/species/proc/genitals_layertext(layer)
	switch(layer)
		if(GENITALS_BEHIND_LAYER)
			return "BEHIND"
		if(GENITALS_FRONT_LAYER)
			return "FRONT"

//procs to handle sprite overlays being applied to humans

/obj/item/equipped(mob/user, slot)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_genitals()
	. = ..()

/mob/living/carbon/human/doUnEquip(obj/item/I, force)
	. = ..()
	if(!.)
		return
	update_genitals()

/mob/living/carbon/human/proc/update_genitals()
	if(!QDELETED(src))
		dna.species.handle_genitals(src)

//fermichem procs
/mob/living/carbon/human/proc/Force_update_genitals(mob/living/carbon/human/H) //called in fermiChem
	dna.species.handle_genitals(src)//should work.
	//dna.species.handle_breasts(src)

//Checks to see if organs are new on the mob, and changes their colours so that they don't get crazy colours.
/mob/living/carbon/human/proc/emergent_genital_call()
	var/organCheck = FALSE
	var/breastCheck = FALSE
	var/willyCheck = FALSE
	if(!canbearoused)
		ADD_TRAIT(src, TRAIT_PHARMA, "pharma")//Prefs prevent unwanted organs.
		return
	for(var/O in internal_organs)
		if(istype(O, /obj/item/organ/genital))
			organCheck = TRUE
			if(istype(O, /obj/item/organ/genital/penis))
				willyCheck = TRUE
			if(istype(O, /obj/item/organ/genital/breasts))
				breastCheck = TRUE
	if(organCheck == FALSE)
		if(ishuman(src) && dna.species.id == "human")
			dna.features["genitals_use_skintone"] = TRUE
			dna.species.use_skintones = TRUE
		if(MUTCOLORS)
			if(src.dna.species.fixed_mut_color)
				dna.features["cock_color"] = "[src.dna.species.fixed_mut_color]"
				dna.features["breasts_color"] = "[src.dna.species.fixed_mut_color]"
				return
		//So people who haven't set stuff up don't get rainbow surprises.
		dna.features["cock_color"] = "[dna.features["mcolor"]]"
		dna.features["breasts_color"] = "[dna.features["mcolor"]]"
	else //If there's a new organ, make it the same colour.
		if(breastCheck == FALSE)
			dna.features["breasts_color"] = dna.features["cock_color"]
		else if (willyCheck == FALSE)
			dna.features["cock_color"] = dna.features["breasts_color"]
	return

/datum/species/proc/handle_genitals(mob/living/carbon/human/H)//more like handle sadness
	if(!H)//no args
		CRASH("H = null")
	if(!LAZYLEN(H.internal_organs) || ((NOGENITALS in species_traits) && !H.genital_override) || HAS_TRAIT(H, TRAIT_HUSK))
		return
	var/list/relevant_layers = list(GENITALS_BEHIND_LAYER, GENITALS_FRONT_LAYER)

	for(var/L in relevant_layers) //Less hardcode
		H.remove_overlay(L)
	//start scanning for genitals

	var/list/gen_index[GENITAL_LAYER_INDEX_LENGTH]
	var/list/genitals_to_add
	var/list/fully_exposed
	for(var/obj/item/organ/genital/G in H.internal_organs)
		if(G.is_exposed()) //Checks appropriate clothing slot and if it's through_clothes
			LAZYADD(gen_index[G.layer_index], G)
	for(var/L in gen_index)
		if(L) //skip nulls
			LAZYADD(genitals_to_add, L)
	if(!genitals_to_add)
		return
	//Now we added all genitals that aren't internal and should be rendered
	//start applying overlays
	for(var/layer in relevant_layers)
		var/list/standing = list()
		var/layertext = genitals_layertext(layer)
		for(var/A in genitals_to_add)
			var/obj/item/organ/genital/G = A
			var/datum/sprite_accessory/S
			var/size = G.size
			var/aroused_state = G.aroused_state
			switch(G.type)
				if(/obj/item/organ/genital/penis)
					S = GLOB.cock_shapes_list[G.shape]
				if(/obj/item/organ/genital/testicles)
					S = GLOB.balls_shapes_list[G.shape]
				if(/obj/item/organ/genital/vagina)
					S = GLOB.vagina_shapes_list[G.shape]
				if(/obj/item/organ/genital/breasts)
					S = GLOB.breasts_shapes_list[G.shape]

			if(!S || S.icon_state == "none")
				continue

			var/mutable_appearance/genital_overlay = mutable_appearance(S.icon, layer = -layer)
			genital_overlay.icon_state = "[G.slot]_[S.icon_state]_[size]_[aroused_state]_[layertext]"

			if(S.center)
				genital_overlay = center_image(genital_overlay, S.dimension_x, S.dimension_y)

			if(use_skintones && H.dna.features["genitals_use_skintone"])
				genital_overlay.color = "#[skintone2hex(H.skin_tone)]"
				genital_overlay.icon_state = "[G.slot]_[S.icon_state]_[size]-s_[aroused_state]_[layertext]"
			else
				switch(S.color_src)
					if("cock_color")
						genital_overlay.color = "#[H.dna.features["cock_color"]]"
					if("balls_color")
						genital_overlay.color = "#[H.dna.features["balls_color"]]"
					if("breasts_color")
						genital_overlay.color = "#[H.dna.features["breasts_color"]]"
					if("vag_color")
						genital_overlay.color = "#[H.dna.features["vag_color"]]"

			if(layer == GENITALS_FRONT_LAYER && CHECK_BITFIELD(G.genital_flags, GENITAL_THROUGH_CLOTHES))
				LAZYADD(fully_exposed, genital_overlay) // to be added to a layer with higher priority than clothes, hence the name of the bitflag.
			else
				standing += genital_overlay

		if(LAZYLEN(standing))
			H.overlays_standing[layer] = standing

	if(LAZYLEN(fully_exposed))
		H.overlays_standing[GENITALS_EXPOSED_LAYER] = fully_exposed

	for(var/L in relevant_layers)
		H.apply_overlay(L)

