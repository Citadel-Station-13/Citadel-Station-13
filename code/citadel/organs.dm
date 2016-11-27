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
/obj/item/organ/genital
	var/shape = "human"
	var/sensitivity = 1
	var/list/gen_flags = list()

/obj/item/organ/genital/penis
	name = "penis"
	desc = "A male reproductive organ."
	icon_state = "penis"
	icon = 'icons/obj/penis.dmi'
	zone = "groin"
	slot = "penis"
	w_class = 3
	color = null
	var/mob/living/carbon/human/holder
	var/size = COCK_SIZE_NORMAL 				//arbitrary value derived from length for sprites and shit.
	var/length = 6								//inches
	var/girth  = 0
	var/girth_ratio = COCK_GIRTH_RATIO_DEF 		//0.73; check citadel_defines.dm
	var/knot_girth_ratio = KNOT_GIRTH_RATIO_DEF
	var/list/dickflags = list()
	var/obj/item/organ/testicles/linked_balls

/obj/item/organ/genital/penis/New()
	..()
	update()

/obj/item/organ/genital/penis/proc/update()//master update proc for this organ, will probably duplicate it for each one
	update_size()
	update_appearance()

/obj/item/organ/genital/penis/proc/update_size()
	switch(length)
		if(-INFINITY to (COCK_SIZE_SMALL * COCK_SIZE_BASE))
			size = COCK_SIZE_SMALL
		if(((COCK_SIZE_SMALL * COCK_SIZE_BASE) + 1) to ((COCK_SIZE_BIG * COCK_SIZE_BASE) - 1))
			size = COCK_SIZE_NORMAL
		if((COCK_SIZE_BIG * COCK_SIZE_BASE) to ((COCK_SIZE_BIG * COCK_SIZE_BASE) - 1))
			size = COCK_SIZE_BIG
		if((COCK_SIZE_BIGGER * COCK_SIZE_BASE) to ((COCK_SIZE_BIGGEST * COCK_SIZE_BASE) - 1))
			size = COCK_SIZE_BIGGER
		if((COCK_SIZE_BIGGEST * COCK_SIZE_BASE) to INFINITY)
			size = COCK_SIZE_BIGGEST
	girth = (length * girth_ratio)

/obj/item/organ/genital/penis/proc/update_appearance()
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
	var/size 				= BALLS_SIZE_NORMAL
	var/cum_mult 			= CUM_RATE_MULT
	var/cum_rate 			= CUM_RATE
	var/cum_efficiency		= CUM_EFFICIENCY
	var/cum_id 				= "semen"
	var/balls_volume		= BALLS_VOLUME_BASE
	var/producing			= TRUE
	var/obj/item/organ/genital/penis/linked_penis

/obj/item/organ/testicles/New()
	..()
	reagents.maximum_volume = balls_volume

/obj/item/organ/testicles/on_life()
	..()
	if(!owner)
		if(linked_penis)
			linked_penis = null
		return FALSE
	if(!reagents)
		return FALSE
	if(!linked_penis)
		if(istype(owner.getorganslot("penis"), /obj/item/organ/genital/penis))
			owner.getorganslot("penis")
	reagents.maximum_volume = balls_volume
	for(var/r in reagents.reagent_list)
		var/datum/reagent/R = r
		if(R.id != src.cum_id)
			src.reagents.del_reagent(R.id)
	if(reagents.total_volume < balls_volume)
		reagents.add_reagent(cum_id, (cum_mult * cum_rate))//generate the cum
		owner.nutrition = (owner.nutrition - cum_efficiency)//use some nutrition from the mob that's using it
	if(reagents.total_volume > reagents.maximum_volume)
		reagents.remove_reagent(cum_id, (reagents.total_volume - reagents.maximum_volume))

/obj/item/organ/genital/ovipositor
	name = "ovipositor"
	desc = "An egg laying reproductive organ."
	icon_state = "ovi_knotted_2"
	icon = 'icons/obj/ovipositor.dmi'
	zone = "groin"
	slot = "penis"
	w_class = 3
	shape = "knotted"
	var/size = 3
	var/length = 6								//inches
	var/girth  = 0
	var/girth_ratio = COCK_GIRTH_RATIO_DEF 		//0.73; check citadel_defines.dm
	var/knot_girth_ratio = KNOT_GIRTH_RATIO_DEF
	var/list/oviflags = list()

	var/obj/item/organ/eggsack/linked_eggsack

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
	var/cum_mult = CUM_RATE_MULT
	var/cum_rate = CUM_RATE
	var/cum_efficiency	= CUM_EFFICIENCY
	var/obj/item/organ/ovipositor/linked_ovi

/obj/item/organ/genital/vagina
	name = "vagina"
	desc = "A female reproductive organ."
	icon_state = "vagina"
	zone = "groin"
	slot = "vagina"
	w_class = 3
	var/wetness				= 1
	var/tightness 			= VAG_NORMAL
	var/capacity_length		= 8
	var/capacity_girth		= 8
	var/clits				= 1
	var/clit_size 			= 0.25
	var/obj/item/organ/womb/linked_womb

/obj/item/organ/womb
	name = "womb"
	desc = "A female reproductive organ."
	icon_state = "womb"
	zone = "groin"
	slot = "womb"
	w_class = 3
	var/cum_mult 			= CUM_RATE_MULT
	var/cum_rate 			= CUM_RATE
	var/cum_efficiency		= CUM_EFFICIENCY
	var/cum_id 				= "femcum"
	var/obj/item/organ/genital/vagina/linked_vag
