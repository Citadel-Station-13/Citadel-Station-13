/obj/item/organ/genital
	color = "#fcccb3"
	w_class = WEIGHT_CLASS_NORMAL
	var/shape = "human"
	var/sensitivity = AROUSAL_START_VALUE
	var/genital_flags
	var/can_masturbate_with = FALSE
	var/masturbation_verb = "masturbate"
	var/orgasm_verb = "cumming" //present continous
	var/can_climax = FALSE
	var/fluid_transfer_factor = 0 //How much would a partner get in them if they climax using this?
	var/size = 2 //can vary between num or text, just used in icon_state strings
	var/fluid_id = null
	var/fluid_max_volume = 50
	var/fluid_efficiency = 1
	var/fluid_rate = 1
	var/fluid_mult = 1
	var/producing = FALSE
	var/aroused_state = FALSE //Boolean used in icon_state strings
	var/aroused_amount = 50 //This is a num from 0 to 100 for arousal percentage for when to use arousal state icons.
	var/obj/item/organ/genital/linked_organ
	var/linked_organ_slot //only one of the two organs needs this to be set up. update_link() will handle linking the rest.
	var/through_clothes = FALSE
	var/internal = FALSE
	var/hidden = FALSE
	var/layer_index = GENITAL_LAYER_INDEX //Order should be very important. FIRST vagina, THEN testicles, THEN penis, as this affects the order they are rendered in.

/obj/item/organ/genital/Initialize()
	. = ..()
	if(fluid_id)
		create_reagents(fluid_max_volume)
		if(producing)
			reagents.add_reagent(fluid_id, fluid_max_volume)
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
	if(!owner || hidden || internal)
		return FALSE
	if(through_clothes)
		return TRUE

	switch(zone) //update as more genitals are added
		if(BODY_ZONE_CHEST)
			return owner.is_chest_exposed()
		if(BODY_ZONE_PRECISE_GROIN)
			return owner.is_groin_exposed()

	return FALSE

/obj/item/organ/genital/proc/toggle_visibility(visibility)
	switch(visibility)
		if("Always visible")
			through_clothes = TRUE
			hidden = FALSE
			if(!(src in owner.exposed_genitals))
				owner.exposed_genitals += src
		if("Hidden by clothes")
			through_clothes = FALSE
			hidden = TRUE
			if(src in owner.exposed_genitals)
				owner.exposed_genitals -= src
		if("Always hidden")
			through_clothes = FALSE
			hidden = TRUE
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
			if(!G.internal)
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
	if(fluid_id && producing)
		generate_fluid()

/obj/item/organ/genital/proc/generate_fluid()
	if(owner.stat != DEAD && reagents.total_volume < reagents.maximum_volume)
		reagents.isolate_reagent(fluid_id)//remove old reagents if it changed and just clean up generally
		reagents.add_reagent(fluid_id, (fluid_mult * fluid_rate))//generate the cum
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

/obj/item/organ/genital/Insert(mob/living/carbon/M, special = 0)
	. = ..()
	if(.)
		update()
		RegisterSignal(owner, COMSIG_MOB_DEATH, .proc/update_appearance)

/obj/item/organ/genital/Remove(mob/living/carbon/M, special = 0)
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
	if(dna.features["has_breasts"]) // since we have multi-boobs as a thing, we'll want to at least draw over these. but not over the pingas.
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
	G = new
	if(istype(G, /obj/item/organ/genital)) //badminnery-proofing.
		G.get_features(src)
	G.Insert(src)

/obj/item/organ/genital/proc/get_features(datum/dna/D)
	return

/datum/species/proc/genitals_layertext(layer)
	switch(layer)
		if(GENITALS_BEHIND_LAYER)
			return "BEHIND"
		if(GENITALS_ADJ_LAYER)
			return "ADJ"
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

/datum/species/proc/handle_genitals(mob/living/carbon/human/H)
	if(!H)//no args
		CRASH("H = null")
	if(!LAZYLEN(H.internal_organs) || (NOGENITALS in species_traits) || HAS_TRAIT(H, TRAIT_HUSK))
		return

	var/list/genitals_to_add[GENITAL_LAYER_INDEX_LENGTH]
	var/list/relevant_layers = list(GENITALS_BEHIND_LAYER, GENITALS_ADJ_LAYER, GENITALS_FRONT_LAYER)
	var/list/standing = list()
	var/size
	var/aroused_state

	for(var/L in relevant_layers) //Less hardcode
		H.remove_overlay(L)

	//start scanning for genitals
	//var/list/worn_stuff = H.get_equipped_items()//cache this list so it's not built again
	for(var/obj/item/organ/genital/G in H.internal_organs)
		if(G.hidden)
			return	//we're gunna just hijack this for updates.
		if(G.is_exposed()) //Checks appropriate clothing slot and if it's through_clothes
			LAZYADD(genitals_to_add[G.layer_index], G)
	//Now we added all genitals that aren't internal and should be rendered

	//start applying overlays
	for(var/layer in relevant_layers)
		var/layertext = flatten_list(genitals_layertext(layer))
		for(var/obj/item/organ/genital/G in genitals_to_add)
			var/datum/sprite_accessory/S
			size = G.size
			aroused_state = G.aroused_state
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

			standing += genital_overlay

		if(LAZYLEN(standing))
			H.overlays_standing[layer] = standing.Copy()
			standing = list()

	for(var/L in relevant_layers)
		H.apply_overlay(L)

