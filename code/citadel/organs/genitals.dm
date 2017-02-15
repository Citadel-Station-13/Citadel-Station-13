/obj/item/organ/genital
	var/shape = "human"
	var/sensitivity = 1
	var/list/genital_flags = list()

/obj/item/organ/genital/proc/update()
	return

/obj/item/organ/genital/proc/update_size()
	return

/obj/item/organ/genital/proc/update_appearance()
	return


//proc to give a player their genitals and stuff when they log in
/mob/living/carbon/human/proc/update_genitals()
	update_penis()
	/*
	update_balls()
	update_ovipositor()
	update_eggsack()
	update_breasts()
	update_vagina()
	update_womb()
	*/

/mob/living/carbon/human/proc/update_penis()
	if(!has_dna())
		return FALSE
	if(NOGENITALS in dna.species.species_traits)
		return FALSE
	if(!getorganslot("penis"))
		var/obj/item/organ/genital/penis/P = new
		P.Insert(src)
		if(P)
			if(dna.species.use_skintones && dna.features["genitals_use_skintone"])
				P.color = skintone2hex(skin_tone)
			else
				P.color 			= dna.features["cock_color"]
			P.length 			= dna.features["cock_length"]
			P.girth_ratio 		= dna.features["cock_girth_ratio"]
			P.shape 			= dna.features["cock_shape"]

/mob/living/carbon/human/proc/update_balls(force=FALSE)
	if(!has_dna())
		return FALSE
	if(NOGENITALS in dna.species.species_traits)
		return FALSE
	if(!getorganslot("testicles"))
		var/obj/item/organ/genital/testicles/T = new
		T.Insert(src)
		if(T)
			if(dna.species.use_skintones && dna.features["genitals_use_skintone"])
				T.color = skintone2hex(skin_tone)
			else
				T.color = dna.features["balls_color"]
			T.size		= dna.features["bals_size"]
			T.sack_size = dna.features["balls_sack_size"]

