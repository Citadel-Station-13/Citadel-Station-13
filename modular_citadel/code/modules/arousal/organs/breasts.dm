/obj/item/organ/genital/breasts
	name = "breasts"
	desc = "Female milk producing organs."
	icon_state = "breasts"
	icon = 'modular_citadel/icons/obj/genitals/breasts.dmi'
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_BREASTS
	size = BREASTS_SIZE_DEF
	fluid_id = "milk"
	var/amount = 2
	producing = TRUE
	shape = "pair"
	can_masturbate_with = TRUE
	masturbation_verb = "massage"
	orgasm_verb = "leaking"
	can_climax = TRUE
	fluid_transfer_factor = 0.5

/obj/item/organ/genital/breasts/update_appearance()
	. = ..()
	var/lowershape = lowertext(shape)
	switch(lowershape)
		if("pair")
			desc = "You see a pair of breasts."
		if("quad")
			desc = "You see two pairs of breast, one just under the other."
		if("sextuple")
			desc = "You see three sets of breasts, running from their chest to their belly."
		else
			desc = "You see some breasts, they seem to be quite exotic."
	if (size)
		desc += " You estimate that they're [uppertext(size)]-cups."
	else
		desc += " You wouldn't measure them in cup sizes."
	if(producing && aroused_state)
		desc += " They're leaking [fluid_id]."
	var/string
	if(owner)
		if(owner.dna.species.use_skintones && owner.dna.features["genitals_use_skintone"])
			if(ishuman(owner)) // Check before recasting type, although someone fucked up if you're not human AND have use_skintones somehow...
				var/mob/living/carbon/human/H = owner // only human mobs have skin_tone, which we need.
				color = "#[skintone2hex(H.skin_tone)]"
				string = "breasts_[GLOB.breasts_shapes_icons[shape]]_[size]-s"
		else
			color = "#[owner.dna.features["breasts_color"]]"
			string = "breasts_[GLOB.breasts_shapes_icons[shape]]_[size]"
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			icon_state = sanitize_text(string)
			H.update_genitals()

/obj/item/organ/genital/breasts/get_features(mob/living/carbon/human/H)
	var/datum/dna/D = H.dna
	if(D.species.use_skintones && D.features["genitals_use_skintone"])
		color = "#[skintone2hex(H.skin_tone)]"
	else
		color = "#[D.features["breasts_color"]]"
	size = D.features["breasts_size"]
	shape = D.features["breasts_shape"]
	fluid_id = D.features["breasts_fluid"]
