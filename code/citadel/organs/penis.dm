/obj/item/organ/genital/penis
	name 		= "penis"
	desc 		= "A male reproductive organ."
	icon_state 	= "penis"
	icon 		= 'code/citadel/icons/penis.dmi'
	zone 		= "groin"
	slot 		= "penis"
	w_class 	= 3
	color 		= null
	can_masturbate_with = 1
	size 	= 2 //arbitrary value derived from length and girth for sprites.
	var/length 	= 6	//inches
	var/girth  	= 0
	var/girth_ratio = COCK_GIRTH_RATIO_DEF //0.73; check citadel_defines.dm
	var/knot_girth_ratio = KNOT_GIRTH_RATIO_DEF
	var/list/dickflags = list()
	var/list/knotted_types = list("", "barbknot")
	var/obj/item/organ/genital/testicles/linked_balls

/obj/item/organ/genital/penis/New()
	..()
	update()

/obj/item/organ/genital/penis/update()
	update_size()
	update_appearance()
	update_link()

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
//	name = "[shape] penis"
	desc = "That's a [lowertext(shape)] penis. You estimate it's about [round(length, 0.25)] inch[length > 1 ? "es" : ""] long and [round(girth, 0.25)] inch[length > 1 ? "es" : ""] around."
	if(!owner)
		return
	color = sanitize_hexcolor(owner.dna.features["cock_color"], 6, 0)

/obj/item/organ/genital/penis/update_link()
	if(owner)
		linked_balls = (owner.getorganslot("testicles"))
		if(linked_balls)
			linked_balls.linked_penis = src
	else
		if(linked_balls)
			linked_balls.linked_penis = null
		linked_balls = null
