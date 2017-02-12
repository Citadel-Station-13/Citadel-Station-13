/obj/item/organ/genital/penis
	name = "penis"
	desc = "A male reproductive organ."
	icon_state = "penis"
	icon = 'code/citadel/icons/penis.dmi'
	zone = "groin"
	slot = "penis"
	w_class = 3
	color = null
	var/mob/living/carbon/human/holder
	var/size 	= 2 //arbitrary value derived from length for sprites.
	var/length 	= 6	//inches
	var/girth  	= 0
	var/girth_ratio = COCK_GIRTH_RATIO_DEF //0.73; check citadel_defines.dm
	var/knot_girth_ratio = KNOT_GIRTH_RATIO_DEF
	var/list/dickflags = list()
	var/obj/item/organ/testicles/linked_balls

/obj/item/organ/genital/penis/New()
	..()
	update()

/obj/item/organ/genital/penis/update()
	update_size()
	update_appearance()

/obj/item/organ/genital/penis/update_size()
	switch(length)
		if(-INFINITY to 5)
			size = 1
		if(5 to 9)
			size = 2
		if(9 to 12)
			size = 3//no new sprites for anything larger
		if(9 to 15)
			size = 3
		if(15 to INFINITY)
			size = 3
	girth = (length * girth_ratio)

/obj/item/organ/genital/penis/update_appearance()
	var/string = "penis_[shape]_[size]"
	icon_state = sanitize_text(string)
	name = "[shape] penis"
	if(owner.has_dna())
		color = owner.dna.features["cock_color"]