/datum/job/hos
	minimal_player_age = 30

/datum/outfit/job/hos/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(H.gender == MALE)
		if(!H.has_penis())
			H.give_penis()
		var/obj/item/organ/genital/penis/P = H.getorganslot("penis")
		P.length = 11.811 // 30 cm
		H.dna.features["cock_length"] = 11.811
		return
	if(H.has_penis()) // i hope they paid for dickgirl
		var/obj/item/organ/genital/penis/P = H.getorganslot("penis")
		P.length = 11.811
		H.dna.features["cock_length"] = 11.811
		return
	//imagine that they paid for trapapocalypse looool

/datum/outfit/job/warden
	suit_store = /obj/item/gun/energy/pumpaction/defender