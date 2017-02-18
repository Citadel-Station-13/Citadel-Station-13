/obj/item/organ/genital
	var/shape = "human"
	var/sensitivity = 1
	var/list/genital_flags = list()
	var/can_masturbate_with = 0

/obj/item/organ/genital/proc/update()
	return

/obj/item/organ/genital/proc/update_size()
	return

/obj/item/organ/genital/proc/update_appearance()
	return

/obj/item/organ/genital/proc/update_link()

//proc to give a player their genitals and stuff when they log in
/mob/living/carbon/human/proc/give_genitals()
	if(dna.features["has_cock"])
		give_penis()
		if(dna.features["has_balls"])
			give_balls()
	else if(dna.features["has_ovi"])
		give_ovipositor()
		if(dna.features["has_eggsack"])
			give_eggsack()
	if(dna.features["has_breasts"])
		give_breasts()
	if(dna.features["has_vagina"])
		give_vagina()
	if(dna.features["has_womb"])
		give_womb()

/mob/living/carbon/human/proc/give_penis()
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
			P.update()

/mob/living/carbon/human/proc/give_balls(force=FALSE)
	if(!has_dna())
		return FALSE
	if(NOGENITALS in dna.species.species_traits)
		return FALSE
	if(!getorganslot("testicles"))
		var/obj/item/organ/genital/testicles/T = new
		T.Insert(src)
		if(dna.species.use_skintones && dna.features["genitals_use_skintone"])
			T.color = skintone2hex(skin_tone)
		else
			T.color = dna.features["balls_color"]
		T.size		= dna.features["bals_size"]
		T.sack_size = dna.features["balls_sack_size"]
		T.update()

/mob/living/carbon/human/proc/give_breasts()
	if(!has_dna())
		return FALSE
	if(NOGENITALS in dna.species.species_traits)
		return FALSE
	if(!getorganslot("breasts"))
		var/obj/item/organ/genital/breasts/B = new
		B.Insert(src)
		B.size = dna.features["breasts_size"]
		B.milk_id = dna.features["breasts_fluid"]
		B.update()


/mob/living/carbon/human/proc/give_ovipositor()
/mob/living/carbon/human/proc/give_eggsack()
/mob/living/carbon/human/proc/give_vagina()
/mob/living/carbon/human/proc/give_womb()