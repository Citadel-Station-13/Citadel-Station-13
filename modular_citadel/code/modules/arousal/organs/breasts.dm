/obj/item/organ/genital/breasts
	name = "breasts"
	desc = "Female milk producing organs."
	icon_state = "breasts"
	icon = 'modular_citadel/icons/obj/genitals/breasts.dmi'
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_BREASTS
	size = BREASTS_SIZE_DEF
	fluid_id = "milk"
	shape = "pair"
	genital_flags = CAN_MASTURBATE_WITH|CAN_CLIMAX_WITH|GENITAL_FUID_PRODUCTION
	masturbation_verb = "massage"
	orgasm_verb = "leaking"
	fluid_transfer_factor = 0.5
	var/list/static/breast_values = list("a" =  1, "b" = 2, "c" = 3, "d" = 4, "e" = 5, "f" = 6, "g" = 7, "h" = 8, "i" = 9, "j" = 10, "k" = 11, "l" = 12, "m" = 13, "n" = 14, "o" = 15, "huge" = 16, "flat" = 0)
	var/cached_size //for enlargement SHOULD BE A NUMBER
	var/prev_size //For flavour texts SHOULD BE A LETTER

/obj/item/organ/genital/breasts/Initialize(mapload, mob/living/carbon/human/H)
	if(!H)
		cached_size = size
		size = breast_values[size]
		prev_size = size
	return ..()

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
	if(size == "huge")
		desc = "You see [pick("some serious honkers", "a real set of badonkers", "some dobonhonkeros", "massive dohoonkabhankoloos", "two big old tonhongerekoogers", "a couple of giant bonkhonagahoogs", "a pair of humongous hungolomghnonoloughongous")]. Their volume is way beyond cupsize now, measuring in about [round(cached_size)]cm in diameter."
	else
		if (size == "flat")
			desc += " They're very small and flatchested, however."
		else
			desc += " You estimate that they're [uppertext(size)]-cups."

	if(CHECK_BITFIELD(genital_flags, GENITAL_FUID_PRODUCTION) && aroused_state)
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
			icon_state = sanitize_text(string)

//Allows breasts to grow and change size, with sprite changes too.
//maximum wah
//Comical sizes slow you down in movement and actions.
//Rediculous sizes makes you more cumbersome.
//this is far too lewd wah

/obj/item/organ/genital/breasts/update_size()//wah
	if(cached_size < 0)//I don't actually know what round() does to negative numbers, so to be safe!!fixed
		if(owner)
			to_chat(owner, "<span class='warning'>You feel your breasts shrinking away from your body as your chest flattens out.</span>")
		QDEL_IN(src, 1)
		return
	var/enlargement = FALSE
	switch(round(cached_size))
		if(0) //flatchested
			size = "flat"
		if(1 to 8) //modest
			size = breast_values[round(cached_size)]
		if(9 to 15) //massive
			size = breast_values[round(cached_size)]
			enlargement = TRUE
		if(16 to INFINITY) //rediculous
			size = "huge"
			enlargement = TRUE
	if(owner)
		var/status_effect = owner.has_status_effect(/datum/status_effect/chem/breast_enlarger)
		if(enlargement && !status_effect)
			owner.apply_status_effect(/datum/status_effect/chem/breast_enlarger)
		else if(status_effect)
			owner.remove_status_effect(/datum/status_effect/chem/breast_enlarger)

	if(round(cached_size) < 16)//Because byond doesn't count from 0, I have to do this.
		if(owner)
			var/mob/living/carbon/human/H = owner
			if (breast_values[size] > breast_values[prev_size])
				to_chat(H, "<span class='warning'>Your breasts [pick("swell up to", "flourish into", "expand into", "burst forth into", "grow eagerly into", "amplify into")] a [uppertext(size)]-cup.</span>")
				H.dna.species.handle_genitals(src)
			else if (breast_values[size] > 0.5)
				to_chat(H, "<span class='warning'>Your breasts [pick("shrink down to", "decrease into", "diminish into", "deflate into", "shrivel regretfully into", "contracts into")] a [uppertext(size)]-cup.</span>")
				H.dna.species.handle_genitals(src)
		prev_size = size

/obj/item/organ/genital/breasts/get_features(mob/living/carbon/human/H)
	var/datum/dna/D = H.dna
	if(D.species.use_skintones && D.features["genitals_use_skintone"])
		color = "#[skintone2hex(H.skin_tone)]"
	else
		color = "#[D.features["breasts_color"]]"
	size = D.features["breasts_size"]
	shape = D.features["breasts_shape"]
	fluid_id = D.features["breasts_fluid"]
	if(!isnum(size))
		if(size == "flat")
			cached_size = 0
		else if (size == "huge")
			cached_size = 16
		else
			cached_size = breast_values[size]
		prev_size = size
	else
		cached_size = size
		size = breast_values[size]
		prev_size = size
