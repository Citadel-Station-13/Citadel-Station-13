//Here are the organs and their subsequent functions that Citadel uses.
/obj/item/organ/stomach
	name = "stomach"
	icon_state = "stomach"
	zone = "chest"
	slot = "stomach"
	w_class = 3

/obj/item/organ/stomach/prepare_eat()
	var/obj/S = ..()
	S.reagents.add_reagent("sacid", 2)
	return S

/obj/item/organ/penis
	name = "penis"
	desc = "A male reproductive organ."
	icon_state = "penis"
	icon = 'icons/obj/penis.dmi'
	zone = "groin"
	slot = "penis"
	w_class = 3
	color = null
	var/mob/living/carbon/human/holder
	var/shape = "human"
	var/size = COCK_SIZE_NORMAL 				//arbitrary value derived from length for sprites and shit.
	var/length = 6								//inches
	var/girth  = 0
	var/girth_ratio = COCK_GIRTH_RATIO_DEF 		//0.73; check citadel_defines.dm
	var/obj/item/organ/testicles/balls

/obj/item/organ/penis/New()
	..()
	update()

/obj/item/organ/penis/proc/update()//master update proc for this organ, will probably duplicate it for each one
	update_size()
	update_appearance()

/obj/item/organ/penis/proc/update_size()
	switch(length)
		if(-INFINITY to 3)
			size = COCK_SIZE_SMALL
		if(4 to 8)
			size = COCK_SIZE_NORMAL
		if(9 to 11)
			size = COCK_SIZE_BIG
		if(12 to 14)
			size = COCK_SIZE_BIGGER
		if(15 to INFINITY)
			size = COCK_SIZE_BIGGEST
	girth = (length * girth_ratio)

/obj/item/organ/penis/proc/update_appearance()
	var/string = "penis_[shape]_[size]"
	icon_state = sanitize_text(string)
	name = "[shape] penis"

/obj/item/organ/testicles
	name = "testicles"
	desc = "A male reproductive organ."
	icon_state = "testicles"
	icon = 'icons/obj/penis.dmi'
	zone = "groin"
	slot = "testicles"
	w_class = 3
	var/internal = FALSE
	var/size = BALLS_SIZE_NORMAL
	var/cum_mult = DEFAULT_CUM_MULT
	var/cum_rate = DEFAULT_CUM_RATE
	var/cum_id = "semen"
	var/obj/item/organ/penis/penis

/obj/item/organ/testicles/New()
	..()
/*
/obj/item/organ/testicles/on_life()
	if(reagents.volume < (size * 10))
		reagents.add_reagent(cum_id, (cum_mult * cum_rate))
	if(reagents.volume > (size * 10))
		reagents.volume = (size * 10)
*/
/obj/item/organ/ovipositor
	name = "ovipositor"
	desc = "An egg laying reproductive organ."
	icon_state = "ovi_knotted_2"
	icon = 'icons/obj/ovipositor.dmi'
	zone = "groin"
	slot = "penis"
	w_class = 3
	var/shape = "knotted"
	var/size = 3
	var/obj/item/organ/eggsack/eggsack

/obj/item/organ/eggsack
	name = "egg sack"
	desc = "An egg producing reproductive organ."
	icon_state = "egg_sack"
	icon = 'icons/obj/ovipositor.dmi'
	zone = "groin"
	slot = "testicles"
	w_class = 3
	var/internal = TRUE
	var/egg_size = EGG_SIZE_NORMAL
	var/egg_mult = DEFAULT_CUM_MULT
	var/egg_rate = DEFAULT_CUM_RATE
	var/obj/item/organ/ovipositor/ovi

/obj/item/organ/vagina
	name = "vagina"
	desc = "A female reproductive organ."
	icon_state = "vagina"
	zone = "groin"
	slot = "vagina"
	w_class = 3
	var/shape = "human"
	var/obj/item/organ/womb/connected_womb

/obj/item/organ/womb
	name = "womb"
	desc = "A female reproductive organ."
	icon_state = "womb"
	zone = "groin"
	slot = "womb"
	w_class = 3
	var/cum_mult = DEFAULT_CUM_MULT
	var/cum_rate = DEFAULT_CUM_RATE
	var/cum_id = "femcum"
