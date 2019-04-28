/obj/item/organ/genital/breasts
	name 					= "breasts"
	desc 					= "Female milk producing organs."
	icon_state 				= "breasts"
	icon 					= 'modular_citadel/icons/obj/genitals/breasts.dmi'
	zone 					= "chest"
	slot 					= "breasts"
	w_class 				= 3
	size 					= BREASTS_SIZE_DEF
	var/cached_size			= 3//for enlargement
	var/prev_size			= 3//For flavour texts
	var/breast_sizes 		= list ("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "huge", "flat")
	var/breast_values 		= list ("A" =  1, "B" = 2, "C" = 3, "D" = 4, "E" = 5, "F" = 6, "G" = 7, "H" = 8, "I" = 9, "J" = 10, "K" = 11, "L" = 12, "M" = 13, "N" = 14, "O" = 15, "huge" = 16, "flat" = 0)
	fluid_id				= "milk"
	var/amount				= 2
	producing				= TRUE
	shape					= "pair"
	can_masturbate_with		= TRUE
	masturbation_verb 		= "massage"
	can_climax				= TRUE
	fluid_transfer_factor 	=0.5

/obj/item/organ/genital/breasts/Initialize()
	. = ..()
	reagents.add_reagent(fluid_id, fluid_max_volume)
	prev_size = size

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
	var/string = "breasts_[lowertext(shape)]_[size]"
	icon_state = sanitize_text(string)
	var/lowershape = lowertext(shape)
	switch(lowershape)
		if("pair")
			desc = "You see a pair of breasts."
		else
			desc = "You see some breasts, they seem to be quite exotic."
	if(isnum(size))
		desc = "You see [pick("some serious honkers", "a real set of badonkers", "some dobonhonkeros", "massive dohoonkabhankoloos", "big old tonhongerekoogers", "giant bonkhonagahoogs", "humongous hungolomghnonoloughongous")]. Their volume is way beyond cupsize now, measuring in about [size]cm in diameter."
	else if (!isnum(size))
		if (size == "flat")
			desc += " They're very small and flatchested, however."
		else
			desc += " You estimate that they're [uppertext(size)]-cups."

	if(producing && aroused_state)
		desc += " They're leaking [fluid_id]."
	if(owner)
		if(owner.dna.species.use_skintones && owner.dna.features["genitals_use_skintone"])
			if(ishuman(owner)) // Check before recasting type, although someone fucked up if you're not human AND have use_skintones somehow...
				var/mob/living/carbon/human/H = owner // only human mobs have skin_tone, which we need.
				color = "#[skintone2hex(H.skin_tone)]"
		else
			color = "#[owner.dna.features["breasts_color"]]"


//Allows breasts to grow and change size, with sprite changes too.
//maximum wah
//Comical sizes slow you down in movement and actions.
//Rediculous sizes remove hands.
//Should I turn someone with meter wide... assets into a blob?
//this is far too lewd wah
/obj/item/organ/genital/breasts/update_size()//wah
	var/mob/living/carbon/human/H = owner
	message_admins("Breast size at start: [size], [cached_size], [owner]")
	//var/sprite_accessory/breasts = mob/living/carbon/M
	if(cached_size < 0)//I don't actually know what round() does to negative numbers, so to be safe!!
		var/obj/item/organ/genital/breasts/B = owner.getorganslot("breasts")
		to_chat(owner, "<span class='warning'>You feel your breasts shrinking away from your body as your chest flattens out.</b></span>")
		B.Remove(owner)
	switch(round(cached_size))
		if(0)
			size = "flat"
			//if(H.has_status_effect(/datum/status_effect/chem/BElarger))
			H.remove_status_effect(/datum/status_effect/chem/BElarger)
		if(1 to 8)
			size = breast_sizes[round(cached_size)]
			//if(H.has_status_effect(/datum/status_effect/chem/BElarger))
			H.remove_status_effect(/datum/status_effect/chem/BElarger)
		if(9 to 15)
			size = breast_sizes[round(cached_size)]
			if(!H.has_status_effect(/datum/status_effect/chem/BElarger))
				H.apply_status_effect(/datum/status_effect/chem/BElarger)
			message_admins("Attempting to apply.")
		if(16 to INFINITY)
			size = cached_size

	if(round(cached_size) < 16)//Because byond doesn't count from 0, I have to do this.
		if (prev_size == 0)
			prev_size = "flat"
		message_admins("Breast size: [size], [cached_size], [owner]")
		if(size == 0)//Bloody byond with it's counting from 1
			size = "flat"
		message_admins("[prev_size] vs [breast_values[size]]")
				message_admins("breast_values[size] vs [breast_values[prev_size]]")
				if (breast_values[size] > breast_values[prev_size])
					to_chat(owner, "<span class='warning'>Your breasts [pick("swell up to", "flourish into", "expand into", "burst forth into", "grow eagerly into", "amplify into")] a [uppertext(size)]-cup.</b></span>")
					//prev_size = cached_size
				else if (breast_values[size] < breast_values[prev_size])
					to_chat(owner, "<span class='warning'>Your breasts [pick("shrink down to", "decrease into", "diminish into", "deflate into", "shrivel regretfully into", "shrivels into")] a [uppertext(size)]-cup.</b></span>")
					//prev_size = cached_size
		prev_size = size
		icon_state = "breasts_[shape]_[size]"
		H.update_body()
	else
		if(!isnum(prev_size))
			prev_size = breast_values[prev_size]
		if(size > prev_size)
			to_chat(owner, "<span class='warning'>Your breasts [pick("swell up to", "flourish into", "expand into", "burst forth into", "grow eagerly into", "amplify into")] a hefty [uppertext(size)]cm diameter bosom, taking both of your hands to hold!.</b></span>")
		else if (size < prev_size)
			to_chat(owner, "<span class='warning'>Your breasts do something crazy that the big Fermis in the sky didn't account for.</b></span>")
	//breasts.icon_state = "breasts_[shape]_[size]_0_FRONT"
