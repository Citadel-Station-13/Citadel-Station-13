/obj/item/organ/genital/butt
	name 					= "butt"
	desc 					= "You see a pair of asscheeks."
	icon_state 				= "butt"
	icon 					= 'icons/obj/genitals/butt.dmi'
	zone 					= BODY_ZONE_PRECISE_GROIN
	slot 					= ORGAN_SLOT_BUTT
	w_class 				= 3
	size 					= 0
	var/size_name			= "nonexistent"
	shape					= "Pair" //turn this into a default constant if for some inexplicable reason we get more than one butt type but I doubt it.
	genital_flags = UPDATE_OWNER_APPEARANCE|GENITAL_UNDIES_HIDDEN
	masturbation_verb 		= "massage"
	var/size_cached			= 0
	var/prev_size //former size value, to allow update_size() to early return should be there no significant changes.
	layer_index = BUTT_LAYER_INDEX

/obj/item/organ/genital/butt/on_life()
	if(QDELETED(src))
		return
	if(!owner)
		return

/obj/item/organ/genital/butt/modify_size(modifier, min = -INFINITY, max = BUTT_SIZE_MAX)
	var/new_value = clamp(size_cached + modifier, min, max)
	if(new_value == size_cached)
		return
	prev_size = size_cached
	size_cached = new_value
	size = round(size_cached)
	update()
	..()

/obj/item/organ/genital/butt/update_size()//wah
	var/rounded_size = round(size)
	if(size < 0)//I don't actually know what round() does to negative numbers, so to be safe!!fixed
		if(owner)
			to_chat(owner, "<span class='warning'>You feel your asscheeks shrink down to an ordinary size.</span>")
		QDEL_IN(src, 1)
		return

	if(owner) //Because byond doesn't count from 0, I have to do this.
		var/mob/living/carbon/human/H = owner
		var/r_prev_size = round(prev_size)
		if (rounded_size > r_prev_size)
			to_chat(H, "<span class='warning'>Your buttcheeks [pick("swell up to", "flourish into", "expand into", "plump up into", "grow eagerly into", "amplify into")] a larger pair.</span>")
		else if (rounded_size < r_prev_size)
			to_chat(H, "<span class='warning'>Your buttcheeks [pick("shrink down to", "decrease into", "wobble down into", "diminish into", "deflate into", "contracts into")] a smaller pair.</span>")


/obj/item/organ/genital/butt/update_appearance()
	var/lowershape = lowertext(shape)

	//Reflect the size of dat ass on examine.
	switch(round(size))
		if(1)
			size_name = "average"
		if(2)
			size_name = "sizable"
		if(3)
			size_name = "squeezable"
		if(4)
			size_name = "hefty"
		if(5)
			size_name = pick("massive","extreme","enormous","very generous","humongous","big bubbly","dummy thicc")
		else
			size_name = "nonexistent"

	desc = "You see a [lowershape] of [size_name] asscheeks."

	var/icon_size = size
	icon_state = "butt_[lowershape]_[icon_size]"
	if(owner)
		if(owner.dna.species.use_skintones && owner.dna.features["genitals_use_skintone"])
			if(ishuman(owner)) // Check before recasting type, although someone fucked up if you're not human AND have use_skintones somehow...
				var/mob/living/carbon/human/H = owner // only human mobs have skin_tone, which we need.
				color = SKINTONE2HEX(H.skin_tone)
				if(!H.dna.skin_tone_override)
					icon_state += "_s"
		else
			color = "#[owner.dna.features["butt_color"]]"


/obj/item/organ/genital/butt/get_features(mob/living/carbon/human/H)
	var/datum/dna/D = H.dna
	if(D.species.use_skintones && D.features["genitals_use_skintone"])
		color = SKINTONE2HEX(H.skin_tone)
	else
		color = "#[D.features["butt_color"]]"
	size = D.features["butt_size"]
	prev_size = size
	toggle_visibility(D.features["butt_visibility"], FALSE)
