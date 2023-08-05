//CONTAINS: Suit fibers and Detective's Scanning Computer

/atom/proc/add_fibers(mob/living/carbon/human/M)
	if(M.gloves && istype(M.gloves, /obj/item/clothing/))
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.transfer_blood > 1) //bloodied gloves transfer blood to touched objects
			if(add_blood_DNA(G.blood_DNA)) //only reduces the bloodiness of our gloves if the item wasn't already bloody
				G.transfer_blood--
	else if(M.bloody_hands > 1)
		if(add_blood_DNA(M.blood_DNA, M.diseases))
			M.bloody_hands--
	LAZYINITLIST(suit_fibers)
	var/fibertext
	var/item_multiplier = isitem(src)?1.2:1
	if(M.wear_suit)
		fibertext = "Material from \a [M.wear_suit]."
		if(prob(10*item_multiplier) && !(fibertext in suit_fibers))
			suit_fibers += fibertext
		if(!(M.wear_suit.body_parts_covered & CHEST))
			if(M.w_uniform)
				fibertext = "Fibers from \a [M.w_uniform]."
				if(prob(12*item_multiplier) && !(fibertext in suit_fibers)) //Wearing a suit means less of the uniform exposed.
					suit_fibers += fibertext
		if(!(M.wear_suit.body_parts_covered & HANDS))
			if(M.gloves)
				fibertext = "Material from a pair of [M.gloves.name]."
				if(prob(20*item_multiplier) && !(fibertext in suit_fibers))
					suit_fibers += fibertext
	else if(M.w_uniform)
		fibertext = "Fibers from \a [M.w_uniform]."
		if(prob(15*item_multiplier) && !(fibertext in suit_fibers))
			// "Added fibertext: [fibertext]"
			suit_fibers += fibertext
		if(M.gloves)
			fibertext = "Material from a pair of [M.gloves.name]."
			if(prob(20*item_multiplier) && !(fibertext in suit_fibers))
				suit_fibers += "Material from a pair of [M.gloves.name]."
	else if(M.gloves)
		fibertext = "Material from a pair of [M.gloves.name]."
		if(prob(20*item_multiplier) && !(fibertext in suit_fibers))
			suit_fibers += "Material from a pair of [M.gloves.name]."


/atom/proc/add_hiddenprint(mob/living/M)
	if(!M || !M.key)
		return

	if(!fingerprintshidden) //Add the list if it does not exist
		fingerprintshidden = list()

	var/hasgloves = ""
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.gloves)
			hasgloves = "(gloves)"

	var/current_time = TIME_STAMP("hh:mm:ss", FALSE)
	if(!fingerprintshidden[M.key])
		fingerprintshidden[M.key] = "First: [M.real_name]\[[current_time]\][hasgloves]. Ckey: [M.ckey]"
	else
		var/laststamppos = findtext(fingerprintshidden[M.key], " Last: ")
		if(laststamppos)
			fingerprintshidden[M.key] = copytext(fingerprintshidden[M.key], 1, laststamppos)
		fingerprintshidden[M.key] += " Last: [M.real_name]\[[current_time]\][hasgloves]. Ckey: [M.ckey]"

	fingerprintslast = M.ckey

//Set ignoregloves to add prints irrespective of the mob having gloves on.
/atom/proc/add_fingerprint(mob/living/M, ignoregloves = FALSE)
	if(!istype(M))
		return

	add_hiddenprint(M)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		add_fibers(H)

		if(H.gloves) //Check if the gloves (if any) hide fingerprints
			var/obj/item/clothing/gloves/G = H.gloves
			if(G.transfer_prints)
				ignoregloves = TRUE

			if(!ignoregloves)
				H.gloves.add_fingerprint(H, TRUE) //ignoregloves = TRUE to avoid infinite loop.
				return

		LAZYINITLIST(fingerprints) //Add the list if it does not exist
		var/full_print = md5(H.dna.uni_identity)
		fingerprints[full_print] = full_print

/atom/proc/transfer_fingerprints_to(atom/A)
	if(fingerprints)
		LAZYINITLIST(A.fingerprints)
		A.fingerprints |= fingerprints            //detective
	if(fingerprintshidden)
		LAZYINITLIST(A.fingerprintshidden)
		A.fingerprintshidden |= fingerprintshidden    //admin
	A.fingerprintslast = fingerprintslast
