/obj/item/organ/genital
	color = "#fcccb3"
	w_class 					= WEIGHT_CLASS_NORMAL
	var/shape					= "Human" //Changed to be uppercase, let me know if this breaks everything..!!
	var/sensitivity				= AROUSAL_START_VALUE
	var/list/genital_flags		= list()
	var/can_masturbate_with 	= FALSE
	var/masturbation_verb		= "masturbate"
	var/can_climax				= FALSE
	var/fluid_transfer_factor	= 0.0 //How much would a partner get in them if they climax using this?
	var/size					= 2 //can vary between num or text, just used in icon_state strings
	var/fluid_id				= null
	var/fluid_max_volume		= 15
	var/fluid_efficiency		= 1
	var/fluid_rate				= 1
	var/fluid_mult				= 1
	var/producing				= FALSE
	var/aroused_state			= FALSE //Boolean used in icon_state strings
	var/aroused_amount			= 50 //This is a num from 0 to 100 for arousal percentage for when to use arousal state icons.
	var/obj/item/organ/genital/linked_organ
	var/through_clothes			= FALSE
	var/internal				= FALSE
	var/hidden					= FALSE

/obj/item/organ/genital/Initialize()
	. = ..()
	if(!reagents)
		create_reagents(fluid_max_volume)
	update()

/obj/item/organ/genital/Destroy()
	remove_ref()
	if(owner)
		Remove(owner, 1)//this should remove references to it, so it can be GCd correctly
	update_link()//this should remove any other links it has
	return ..()

/obj/item/organ/genital/proc/update()
	if(QDELETED(src))
		return
	update_size()
	update_appearance()
	update_link()

//exposure and through-clothing code
/mob/living/carbon
	var/list/exposed_genitals = list() //Keeping track of them so we don't have to iterate through every genitalia and see if exposed

/obj/item/organ/genital/proc/is_exposed()
	if(!owner)
		return FALSE
	if(hidden)
		return FALSE
	if(internal)
		return FALSE
	if(through_clothes)
		return TRUE

	switch(zone) //update as more genitals are added
		if("chest")
			return owner.is_chest_exposed()
		if("groin")
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
	return

/obj/item/organ/genital/proc/update_link()
	return

/obj/item/organ/genital/proc/remove_ref()
	if(linked_organ)
		linked_organ.linked_organ = null
		linked_organ = null

/obj/item/organ/genital/Insert(mob/living/carbon/M, special = 0)
	..()
	update()

/obj/item/organ/genital/Remove(mob/living/carbon/M, special = 0)
	..()
	update()

//proc to give a player their genitals and stuff when they log in
/mob/living/carbon/human/proc/give_genitals(clean=0)//clean will remove all pre-existing genitals. proc will then give them any genitals that are enabled in their DNA
	if(clean)
		var/obj/item/organ/genital/GtoClean
		for(GtoClean in internal_organs)
			qdel(GtoClean)
	if (NOGENITALS in dna.species.species_traits)
		return
	//Order should be very important. FIRST vagina, THEN testicles, THEN penis, as this affects the order they are rendered in.
	if(dna.features["has_vag"])
		give_vagina()
	if(dna.features["has_womb"])
		give_womb()
	if(dna.features["has_balls"])
		give_balls()
	if(dna.features["has_breasts"]) // since we have multi-boobs as a thing, we'll want to at least draw over these. but not over the pingas.
		give_breasts()
	if(dna.features["has_cock"])
		give_penis()
	if(dna.features["has_ovi"])
		give_ovipositor()
	if(dna.features["has_eggsack"])
		give_eggsack()

/mob/living/carbon/human/proc/give_penis()
	if(!dna)
		return FALSE
	if(NOGENITALS in dna.species.species_traits)
		return FALSE
	if(!getorganslot("penis"))
		var/obj/item/organ/genital/penis/P = new
		P.Insert(src)
		if(P)
			if(dna.species.use_skintones && dna.features["genitals_use_skintone"])
				P.color = "#[skintone2hex(skin_tone)]"
			else
				P.color = "#[dna.features["cock_color"]]"
			P.length = dna.features["cock_length"]
			P.girth_ratio = dna.features["cock_girth_ratio"]
			P.shape = dna.features["cock_shape"]
			P.prev_length = P.length
			P.cached_length = P.length
			P.update()

/mob/living/carbon/human/proc/give_balls()
	if(!dna)
		return FALSE
	if(NOGENITALS in dna.species.species_traits)
		return FALSE
	if(!getorganslot("testicles"))
		var/obj/item/organ/genital/testicles/T = new
		T.Insert(src)
		if(T)
			if(dna.species.use_skintones && dna.features["genitals_use_skintone"])
				T.color = "#[skintone2hex(skin_tone)]"
			else
				T.color = "#[dna.features["balls_color"]]"
			T.size = dna.features["balls_size"]
			T.sack_size = dna.features["balls_sack_size"]
			T.shape = dna.features["balls_shape"]
			if(dna.features["balls_shape"] == "Hidden")
				T.internal = TRUE
			else
				T.internal = FALSE
			T.fluid_id = dna.features["balls_fluid"]
			T.fluid_rate = dna.features["balls_cum_rate"]
			T.fluid_mult = dna.features["balls_cum_mult"]
			T.fluid_efficiency = dna.features["balls_efficiency"]
			T.update()

/mob/living/carbon/human/proc/give_breasts()
	if(!dna)
		return FALSE
	if(NOGENITALS in dna.species.species_traits)
		return FALSE
	if(!getorganslot("breasts"))
		var/obj/item/organ/genital/breasts/B = new
		B.Insert(src)
		if(B)
			if(dna.species.use_skintones && dna.features["genitals_use_skintone"])
				B.color = "#[skintone2hex(skin_tone)]"
			else
				B.color = "#[dna.features["breasts_color"]]"
			B.size = dna.features["breasts_size"]
			if(!isnum(B.size))
				if(B.size == "flat")
					B.cached_size = 0
					B.prev_size = 0
				else if (B.cached_size == "huge")
					B.prev_size = "huge"
				else
					B.cached_size = B.breast_values[B.size]
					B.prev_size = B.size
			else
				B.cached_size = B.size
				B.prev_size = B.size
			B.shape = dna.features["breasts_shape"]
			B.fluid_id = dna.features["breasts_fluid"]
			B.producing = dna.features["breasts_producing"]
			B.update()


/mob/living/carbon/human/proc/give_ovipositor()
	return
/mob/living/carbon/human/proc/give_eggsack()
	return

/mob/living/carbon/human/proc/give_vagina()
	if(!dna)
		return FALSE
	if(NOGENITALS in dna.species.species_traits)
		return FALSE
	if(!getorganslot("vagina"))
		var/obj/item/organ/genital/vagina/V = new
		V.Insert(src)
		if(V)
			if(dna.species.use_skintones && dna.features["genitals_use_skintone"])
				V.color = "#[skintone2hex(skin_tone)]"
			else
				V.color = "[dna.features["vag_color"]]"
			V.shape = "[dna.features["vag_shape"]]"
			V.update()

/mob/living/carbon/human/proc/give_womb()
	if(!dna)
		return FALSE
	if(NOGENITALS in dna.species.species_traits)
		return FALSE
	if(!getorganslot("womb"))
		var/obj/item/organ/genital/womb/W = new
		W.Insert(src)
		if(W)
			W.update()


/datum/species/proc/genitals_layertext(layer)
	switch(layer)
		if(GENITALS_BEHIND_LAYER)
			return "BEHIND"
		/*if(GENITALS_ADJ_LAYER)
			return "ADJ"*/
		if(GENITALS_FRONT_LAYER)
			return "FRONT"

//procs to handle sprite overlays being applied to humans

/obj/item/equipped(mob/user, slot)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_genitals()
	..()

/mob/living/carbon/human/doUnEquip(obj/item/I, force)
	. = ..()
	if(!.)
		return
	update_genitals()

/mob/living/carbon/human/proc/update_genitals()
	if(src && !QDELETED(src))
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
	for(var/obj/item/organ/O in internal_organs)
		if(istype(O, /obj/item/organ/genital))
			organCheck = TRUE
			if(/obj/item/organ/genital/penis)
				//dna.features["has_cock"] = TRUE
				willyCheck = TRUE
			if(/obj/item/organ/genital/breasts)
				//dna.features["has_breasts"] = TRUE//Goddamnit get in there.
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
	if(!LAZYLEN(H.internal_organs))//if they have no organs, we're done
		return
	if((NOGENITALS in species_traits) && (H.genital_override = FALSE))//golems and such - things that shouldn't
		return
	if(HAS_TRAIT(H, TRAIT_HUSK))
		return
	var/list/genitals_to_add = list()
	var/list/relevant_layers = list(GENITALS_BEHIND_LAYER, GENITALS_FRONT_LAYER) //GENITALS_ADJ_LAYER removed
	var/list/standing = list()
	var/size
	var/aroused_state

	for(var/L in relevant_layers) //Less hardcode
		H.remove_overlay(L)
	//start scanning for genitals
	for(var/obj/item/organ/O in H.internal_organs)
		if(isgenital(O))
			var/obj/item/organ/genital/G = O
			if(G.hidden)
				return	//we're gunna just hijack this for updates.
			if(G.is_exposed()) //Checks appropriate clothing slot and if it's through_clothes
				genitals_to_add += H.getorganslot(G.slot)
	//Now we added all genitals that aren't internal and should be rendered
	//start applying overlays
	for(var/layer in relevant_layers)
		var/layertext = genitals_layertext(layer)
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
