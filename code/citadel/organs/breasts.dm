/obj/item/organ/genital/breasts
	name 					= "breasts"
	desc 					= "Female milk producing organs."
	icon_state 				= "breasts"
	icon 					= 'code/citadel/icons/breasts.dmi'
	zone 					= "chest"
	slot 					= "breasts"
	w_class 				= 3
	size 					= BREASTS_SIZE_DEF
	fluid_id				= "milk"
	var/amount				= 2
	producing				= TRUE
	shape					= "pair"

/obj/item/organ/genital/breasts/Initialize()
	create_reagents(fluid_max_volume)
	reagents.add_reagent(fluid_id, fluid_max_volume)
	update()

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
			desc = "That's a pair of breasts."
		else
			desc = "That's breasts, they seem to be quite exotic."
	if (size)
		desc += " You estimate they're about [breastsize2cupsize(size)]-cup size."
	else
		desc += " You wouldn't measure them in cup sizes."
	if(producing)
		desc += "\nThey're leaking [fluid_id]."
	else
		desc += "\nThey do not seem to be producing liquids."
	if(owner)
		if(owner.dna.species.use_skintones && owner.dna.features["genitals_use_skintone"])
			if(ishuman(owner)) // Check before recasting type, although someone fucked up if you're not human AND have use_skintones somehow...
				var/mob/living/carbon/human/H = owner // only human mobs have skin_tone, which we need.
				color = "#[skintone2hex(H.skin_tone)]"
		else
			color = "#[owner.dna.features["breasts_color"]]"


/obj/item/organ/genital/breasts/grow_size()
	..()
	. = (size != BREASTS_SIZE_MAX) //Only return true if we actually grew a size
	size = Clamp(size + 1, BREASTS_SIZE_MIN, BREASTS_SIZE_MAX)
	return

/obj/item/organ/genital/breasts/shrink_size()
	..()
	. = (size != BREASTS_SIZE_MIN)
	size = Clamp(size - 1, BREASTS_SIZE_MIN, BREASTS_SIZE_MAX)
	return
