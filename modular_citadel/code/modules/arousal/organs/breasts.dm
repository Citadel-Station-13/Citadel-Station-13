/obj/item/organ/genital/breasts
	name 					= "breasts"
	desc 					= "Female milk producing organs."
	icon_state 				= "breasts"
	icon 					= 'modular_citadel/icons/obj/genitals/breasts.dmi'
	zone 					= "chest"
	slot 					= "breasts"
	w_class 				= 3
	size 					= BREASTS_SIZE_DEF  //SHOULD BE A LETTER, starts as a number...???
	var/cached_size			= null //for enlargement SHOULD BE A NUMBER
	var/prev_size			//For flavour texts SHOULD BE A LETTER
	//var/breast_sizes 		= list ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "huge", "flat")
	var/breast_values 		= list ("a" =  1, "b" = 2, "c" = 3, "d" = 4, "e" = 5, "f" = 6, "g" = 7, "h" = 8, "i" = 9, "j" = 10, "k" = 11, "l" = 12, "m" = 13, "n" = 14, "o" = 15, "huge" = 16, "flat" = 0)
	var/statuscheck			= FALSE
	fluid_id				= "milk"
	var/amount				= 2
	producing				= TRUE
	shape					= "Pair"
	can_masturbate_with		= TRUE
	masturbation_verb 		= "massage"
	can_climax				= TRUE
	fluid_transfer_factor 	= 0.5

/obj/item/organ/genital/breasts/Initialize()
	. = ..()
	reagents.add_reagent(fluid_id, fluid_max_volume)

/obj/item/organ/genital/breasts/on_life()
	if(QDELETED(src))
		return
	if(!reagents || !owner)
		return
	reagents.maximum_volume = fluid_max_volume
	if(fluid_id && producing)
		generate_milk()

/obj/item/organ/genital/breasts/proc/generate_milk()
	if(owner.stat == DEAD)
		return FALSE
	reagents.isolate_reagent(fluid_id)
	reagents.add_reagent(fluid_id, (fluid_mult * fluid_rate))

/obj/item/organ/genital/breasts/update_appearance()
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
	if(cached_size > 16)
		desc = "You see [pick("some serious honkers", "a real set of badonkers", "some dobonhonkeros", "massive dohoonkabhankoloos", "two big old tonhongerekoogers", "a couple of giant bonkhonagahoogs", "a pair of humongous hungolomghnonoloughongous")]. Their volume is way beyond cupsize now, measuring in about [round(cached_size)]cm in diameter."
	else if (!isnum(size))
		if (size == "flat")
			desc += " They're very small and flatchested, however."
		else
			desc += " You estimate that they're [uppertext(size)]-cups."
			//string = "breasts_[lowertext(shape)]_[size]-s"

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

			icon_state = sanitize_text(string)


//Allows breasts to grow and change size, with sprite changes too.
//maximum wah
//Comical sizes slow you down in movement and actions.
//Rediculous sizes makes you more cumbersome.
//this is far too lewd wah

/obj/item/organ/genital/breasts/update_size()//wah

	if(!ishuman(owner) || !owner)
		return
	if(cached_size < 0)//I don't actually know what round() does to negative numbers, so to be safe!!fixed
		to_chat(owner, "<span class='warning'>You feel your breasts shrinking away from your body as your chest flattens out.</b></span>")
		src.Remove(owner)
	switch(round(cached_size))
		if(0) //If flatchested
			size = "flat"
			if(owner.has_status_effect(/datum/status_effect/chem/breast_enlarger))
				owner.remove_status_effect(/datum/status_effect/chem/breast_enlarger)
				statuscheck = FALSE
		if(1 to 8) //If modest size
			size = breast_values[round(cached_size)]
			if(owner.has_status_effect(/datum/status_effect/chem/breast_enlarger))
				owner.remove_status_effect(/datum/status_effect/chem/breast_enlarger)
				statuscheck = FALSE
		if(9 to 15) //If massive
			size = breast_values[round(cached_size)]
			if(!owner.has_status_effect(/datum/status_effect/chem/breast_enlarger))
				owner.apply_status_effect(/datum/status_effect/chem/breast_enlarger)
				statuscheck = TRUE
		if(16 to INFINITY) //if Rediculous
			size = cached_size

	if(round(cached_size) < 16)//Because byond doesn't count from 0, I have to do this.
		if (prev_size == 0)
			prev_size = "flat"
		if(size == 0)//Bloody byond with it's counting from 1
			size = "flat"
		if(isnum(prev_size))
			prev_size = breast_values[prev_size]
		if (breast_values[size] > breast_values[prev_size])
			to_chat(owner, "<span class='warning'>Your breasts [pick("swell up to", "flourish into", "expand into", "burst forth into", "grow eagerly into", "amplify into")] a [uppertext(size)]-cup.</b></span>")
			var/mob/living/carbon/human/H = owner
			H.Force_update_genitals()
		else if ((breast_values[size] < breast_values[prev_size]) && (breast_values[size] > 0.5))
			to_chat(owner, "<span class='warning'>Your breasts [pick("shrink down to", "decrease into", "diminish into", "deflate into", "shrivel regretfully into", "contracts into")] a [uppertext(size)]-cup.</b></span>")
			var/mob/living/carbon/human/H = owner
			H.Force_update_genitals()
		prev_size = size
	else if (cached_size >= 16)
		size = "huge"
