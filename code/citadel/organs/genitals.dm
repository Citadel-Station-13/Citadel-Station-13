/obj/item/organ/genital
	color = "#fcccb3"
	var/shape = "human"
	var/sensitivity = 1
	var/list/genital_flags = list()
	var/can_masturbate_with = 0
	var/size = 2 //can vary between num or text, just used in icon_state strings
	var/fluid_id = null
	var/fluid_max_volume = 50
	var/fluid_efficiency = 1
	var/fluid_rate = 1
	var/fluid_mult = 1
	var/producing = FALSE

/obj/item/organ/genital/Initialize()
	..()
	reagents = create_reagents(fluid_max_volume)

/obj/item/organ/genital/Destroy()
	if(owner)
		Remove(owner, 1)//this should remove references to it, so it can be GCd correctly
	update_link()
	return ..()

/obj/item/organ/genital/proc/update()
	update_size()
	update_appearance()
	update_link()

/obj/item/organ/genital/proc/update_size()

/obj/item/organ/genital/proc/update_appearance()

/obj/item/organ/genital/proc/update_link()

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
	if(dna.features["has_cock"])
		give_penis()
		if(dna.features["has_balls"])
			give_balls()
	else if(dna.features["has_ovi"])
		give_ovipositor()
		if(dna.features["has_eggsack"])
			give_eggsack()
	if(dna.features["has_breasts"])
		give_breasts()
	if(dna.features["has_vag"])
		give_vagina()
		if(dna.features["has_womb"])
			give_womb()

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
				P.color = skintone2hex(skin_tone)
			else
				P.color = "#[dna.features["cock_color"]]"
			P.length = dna.features["cock_length"]
			P.girth_ratio = dna.features["cock_girth_ratio"]
			P.shape = dna.features["cock_shape"]
			P.update()

/mob/living/carbon/human/proc/give_balls()
	if(!dna)
		return FALSE
	if(NOGENITALS in dna.species.species_traits)
		return FALSE
	if(!getorganslot("testicles"))
		var/obj/item/organ/genital/testicles/T = new
		T.Insert(src)
//		if(dna.species.use_skintones && dna.features["genitals_use_skintone"])
//			T.color = skintone2hex(skin_tone)
//		else
//			T.color = "#[dna.features["balls_color"]]"
		T.size = dna.features["bals_size"]
		T.sack_size = dna.features["balls_sack_size"]
		T.fluid_id = dna.features["balls_fluid"]
		T.fluid_rate = dna.features["balls_cum_rate"]
		T.fluid_mult = dna.features["balls_cum_mult"]
		T.fluid_efficiency = dna.features["balls_efficiency"]
		T.update()

/mob/living/carbon/human/proc/give_breasts()
	if(!has_dna())
		return FALSE
	if(NOGENITALS in dna.species.species_traits)
		return FALSE
	if(!getorganslot("breasts"))
		var/obj/item/organ/genital/breasts/B = new
		B.Insert(src)
		B.cup_size = dna.features["breasts_size"]
		B.fluid_id = dna.features["breasts_fluid"]
		B.update()


/mob/living/carbon/human/proc/give_ovipositor()
/mob/living/carbon/human/proc/give_eggsack()
/mob/living/carbon/human/proc/give_vagina()
	if(!has_dna())
		return FALSE
	if(NOGENITALS in dna.species.species_traits)
		return FALSE
	if(!getorganslot("vagina"))
		var/obj/item/organ/genital/vagina/V = new
		V.Insert(src)
		if(dna.species.use_skintones && dna.features["genitals_use_skintone"])
			V.color = skintone2hex(skin_tone)
		else
			V.color = dna.features["vag_color"]
		V.update()
/mob/living/carbon/human/proc/give_womb()
	if(!has_dna())
		return FALSE
	if(NOGENITALS in dna.species.species_traits)
		return FALSE
	if(!getorganslot("womb"))
		var/obj/item/organ/genital/womb/W = new
		W.Insert(src)
		W.update()


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
	..()

/mob/living/carbon/human/doUnEquip(obj/item/I, force)
	. = ..()
	if(!.)
		return
	update_genitals()

/mob/living/carbon/human/proc/update_genitals()
	dna.species.handle_genitals(src)

/datum/species/proc/handle_genitals(mob/living/carbon/human/H)
	if(!H)
		CRASH("H = null")
	if(!H.internal_organs.len)
		return
	if(NOGENITALS in species_traits)
		return

	var/list/genitals_to_add 	= list()
	var/list/relevent_layers 	= list(GENITALS_BEHIND_LAYER, GENITALS_ADJ_LAYER, GENITALS_FRONT_LAYER)
	var/list/standing 			= list()
	var/size

	H.remove_overlay(GENITALS_BEHIND_LAYER)
	H.remove_overlay(GENITALS_ADJ_LAYER)
	H.remove_overlay(GENITALS_FRONT_LAYER)

	if(H.disabilities & HUSK)
		return
	//start scanning for genitals
	if(H.has_penis() && H.is_groin_exposed())
		genitals_to_add += H.getorganslot("penis")
	if(H.has_breasts() && H.is_chest_exposed())
		genitals_to_add += H.getorganslot("breasts")
	if(H.has_vagina() && H.is_groin_exposed())
		genitals_to_add += H.getorganslot("vagina")
	var/image/I
	//start applying overlays
	for(var/layer in relevent_layers)
		var/layertext = genitals_layertext(layer)
		for(var/obj/item/organ/genital/G in genitals_to_add)
			var/datum/sprite_accessory/S
			switch(G.type)
				if(/obj/item/organ/genital/penis)
					S = cock_shapes_list[G.shape]
					size = G.size

			if(!S || S.icon_state == "none")
				continue
			var/icon_string
			icon_string = "[G.slot]_[S.icon_state]_[size]_[layertext]"
			I = image("icon" = S.icon, "icon_state" = icon_string, "layer" =- layer)
			if(S.center)
				I = center_image(I,S.dimension_x,S.dimension_y)
			switch(S.color_src)
				if("cock_color")
					I.color = "#[H.dna.features["cock_color"]]"
				if("breasts_color")
					I.color = "#[H.dna.features["breasts_color"]]"
				if(MUTCOLORS)
					if(fixed_mut_color)
						I.color = "#[fixed_mut_color]"
					else
						I.color = "#[H.dna.features["mcolor"]]"
				if(MUTCOLORS2)
					if(fixed_mut_color2)
						I.color = "#[fixed_mut_color2]"
					else
						I.color = "#[H.dna.features["mcolor2"]]"
				if(MUTCOLORS3)
					if(fixed_mut_color3)
						I.color = "#[fixed_mut_color3]"
					else
						I.color = "#[H.dna.features["mcolor3"]]"
			standing += I
		H.overlays_standing[layer] = standing.Copy()
		standing = list()

	H.apply_overlay(GENITALS_BEHIND_LAYER)
	H.apply_overlay(GENITALS_ADJ_LAYER)
	H.apply_overlay(GENITALS_FRONT_LAYER)