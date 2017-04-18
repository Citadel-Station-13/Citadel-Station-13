/obj/item/organ/genital/penis
	name 		= "penis"
	desc 		= "A male reproductive organ."
	icon_state 	= "penis"
	icon 		= 'code/citadel/icons/penis.dmi'
	zone 		= "groin"
	slot 		= "penis"
	w_class 	= 3
	can_masturbate_with = 1
	size 	= 2 //arbitrary value derived from length and girth for sprites.
	var/length 	= 6	//inches
	var/cached_length //used to detect a change in length
	var/girth  	= 0
	var/girth_ratio = COCK_GIRTH_RATIO_DEF //0.73; check citadel_defines.dm
	var/knot_girth_ratio = KNOT_GIRTH_RATIO_DEF
	var/list/dickflags = list()
	var/list/knotted_types = list("knotted", "barbknot")
	var/obj/item/organ/genital/testicles/linked_balls

/obj/item/organ/genital/penis/Initialize()
	update()

/obj/item/organ/genital/penis/update_size()
	if(length == cached_length)
		return
	switch(length)
		if(-INFINITY to 5)
			size = 1
		if(5 to 9)
			size = 2
		if(9 to INFINITY)
			size = 3//no new sprites for anything larger yet
/*		if(9 to 15)
			size = 3
		if(15 to INFINITY)
			size = 3*/
	girth = (length * girth_ratio)
	cached_length = length

/obj/item/organ/genital/penis/update_appearance()
	var/string = "penis_[lowertext(shape)]_[size]"
	icon_state = sanitize_text(string)
	var/lowershape = lowertext(shape)
	if(lowershape in knotted_types)
		if(lowershape == "barbknot")
			lowershape = "barbed, knotted"
		desc = "That's a [lowershape] penis. You estimate it's about [round(length, 0.25)] inch[length > 1 ? "es" : ""] long, [round(girth, 0.25)] inch[girth > 1 ? "es" : ""] around the shaft \
		and [round(length * knot_girth_ratio, 0.25)] inch[length > 1 ? "es" : ""] around the knot."
	else
		desc = "That's a [lowershape] penis. You estimate it's about [round(length, 0.25)] inch[length > 1 ? "es" : ""] long and [round(girth, 0.25)] inch[length > 1 ? "es" : ""] around."
	if(owner)
		if(owner.dna.species.use_skintones && owner.dna.features["genitals_use_skintone"])
			if(ishuman(owner)) // Check before recasting type, although someone fucked up if you're not human AND have use_skintones somehow...
				var/mob/living/carbon/human/H = owner // only human mobs have skin_tone, which we need.
				color = "#[skintone2hex(H.skin_tone)]"
		else
			color = "#[owner.dna.features["cock_color"]]"

/obj/item/organ/genital/penis/update_link()
	if(owner)
		linked_balls = (owner.getorganslot("testicles"))
		if(linked_balls)
			linked_balls.linked_penis = src
	else
		if(linked_balls)
			linked_balls.linked_penis = null
		linked_balls = null

/obj/item/organ/genital/penis/remove_ref()
	if(linked_balls)
		linked_balls.linked_penis = null
		linked_balls = null

/obj/item/organ/genital/penis/AdjustSize(amt)
	..()
	var/old_length = length
	length = Clamp(length + amt, COCK_SIZE_MIN, COCK_SIZE_MAX)
	. = (old_length != length)
	return

/obj/item/organ/genital/penis/SetSize(new_length)
	..()
	. = (new_length != length)
	length = Clamp(new_length, COCK_SIZE_MIN, COCK_SIZE_MAX)
	return