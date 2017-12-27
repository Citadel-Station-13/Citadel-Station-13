<<<<<<< HEAD
//CONTAINS: Suit fibers and Detective's Scanning Computer

/atom/var/list/suit_fibers

/atom/proc/add_fibers(mob/living/carbon/human/M)
	if(M.gloves && istype(M.gloves, /obj/item/clothing/))
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.transfer_blood > 1) //bloodied gloves transfer blood to touched objects
			if(add_blood(G.blood_DNA)) //only reduces the bloodiness of our gloves if the item wasn't already bloody
				G.transfer_blood--
	else if(M.bloody_hands > 1)
		if(add_blood(M.blood_DNA))
			M.bloody_hands--
	if(!suit_fibers)
		suit_fibers = list()
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

	var/current_time = time_stamp()
	if(!fingerprintshidden[M.key])
		fingerprintshidden[M.key] = "First: [M.real_name]\[[current_time]\][hasgloves]. Ckey: [M.ckey]"
	else
		var/laststamppos = findtext(fingerprintshidden[M.key], " Last: ")
		if(laststamppos)
			fingerprintshidden[M.key] = copytext(fingerprintshidden[M.key], 1, laststamppos)
		fingerprintshidden[M.key] += " Last: [M.real_name]\[[current_time]\][hasgloves]. Ckey: [M.ckey]"

	fingerprintslast = M.ckey


//Set ignoregloves to add prints irrespective of the mob having gloves on.
/atom/proc/add_fingerprint(mob/living/M, ignoregloves = 0)
	if(!M || !M.key)
		return

	add_hiddenprint(M)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		add_fibers(H)

		if(H.gloves) //Check if the gloves (if any) hide fingerprints
			var/obj/item/clothing/gloves/G = H.gloves
			if(G.transfer_prints)
				ignoregloves = 1

			if(!ignoregloves)
				H.gloves.add_fingerprint(H, 1) //ignoregloves = 1 to avoid infinite loop.
				return

		if(!fingerprints) //Add the list if it does not exist
			fingerprints = list()
		var/full_print = md5(H.dna.uni_identity)
		fingerprints[full_print] = full_print




/atom/proc/transfer_fingerprints_to(atom/A)

	// Make sure everything are lists.
	if(!islist(A.fingerprints))
		A.fingerprints = list()
	if(!islist(A.fingerprintshidden))
		A.fingerprintshidden = list()

	if(!islist(fingerprints))
		fingerprints = list()
	if(!islist(fingerprintshidden))
		fingerprintshidden = list()

	// Transfer
	if(fingerprints)
		A.fingerprints |= fingerprints.Copy()            //detective
	if(fingerprintshidden)
		A.fingerprintshidden |= fingerprintshidden.Copy()    //admin
	A.fingerprintslast = fingerprintslast
=======
//CONTAINS: Suit fibers and Detective's Scanning Computer

/atom/proc/return_fingerprints()
	GET_COMPONENT(D, /datum/component/forensics)
	if(D)
		. = D.fingerprints

/atom/proc/return_hiddenprints()
	GET_COMPONENT(D, /datum/component/forensics)
	if(D)
		. = D.hiddenprints

/atom/proc/return_blood_DNA()
	GET_COMPONENT(D, /datum/component/forensics)
	if(D)
		. = D.blood_DNA

/atom/proc/blood_DNA_length()
	GET_COMPONENT(D, /datum/component/forensics)
	if(D)
		. = length(D.blood_DNA)

/atom/proc/return_fibers()
	GET_COMPONENT(D, /datum/component/forensics)
	if(D)
		. = D.fibers

/atom/proc/add_fingerprint_list(list/fingerprints)		//ASSOC LIST FINGERPRINT = FINGERPRINT
	if(length(fingerprints))
		. = AddComponent(/datum/component/forensics, fingerprints)

//Set ignoregloves to add prints irrespective of the mob having gloves on.
/atom/proc/add_fingerprint(mob/living/M, ignoregloves = FALSE)
	var/datum/component/forensics/D = AddComponent(/datum/component/forensics)
	. = D.add_fingerprint(M, ignoregloves)

/atom/proc/add_fiber_list(list/fibertext)				//ASSOC LIST FIBERTEXT = FIBERTEXT
	if(length(fibertext))
		. = AddComponent(/datum/component/forensics, null, null, null, fibertext)

/atom/proc/add_fibers(mob/living/carbon/human/M)
	var/old = 0
	if(M.gloves && istype(M.gloves, /obj/item/clothing))
		var/obj/item/clothing/gloves/G = M.gloves
		old = length(G.return_blood_DNA())
		if(G.transfer_blood > 1) //bloodied gloves transfer blood to touched objects
			if(add_blood_DNA(G.return_blood_DNA()) && length(G.return_blood_DNA()) > old) //only reduces the bloodiness of our gloves if the item wasn't already bloody
				G.transfer_blood--
	else if(M.bloody_hands > 1)
		old = length(M.return_blood_DNA())
		if(add_blood_DNA(M.return_blood_DNA()) && length(M.return_blood_DNA()) > old)
			M.bloody_hands--
	var/datum/component/forensics/D = AddComponent(/datum/component/forensics)
	. = D.add_fibers(M)

/atom/proc/add_hiddenprint_list(list/hiddenprints)	//NOTE: THIS IS FOR ADMINISTRATION FINGERPRINTS, YOU MUST CUSTOM SET THIS TO INCLUDE CKEY/REAL NAMES! CHECK FORENSICS.DM
	if(length(hiddenprints))
		. = AddComponent(/datum/component/forensics, null, hiddenprints)

/atom/proc/add_hiddenprint(mob/living/M)
	var/datum/component/forensics/D = AddComponent(/datum/component/forensics)
	. = D.add_hiddenprint(M)

/atom/proc/add_blood_DNA(list/dna)						//ASSOC LIST DNA = BLOODTYPE
	return FALSE

/obj/add_blood_DNA(list/dna)
	. = ..()
	if(length(dna))
		. = AddComponent(/datum/component/forensics, null, null, dna)

/obj/item/clothing/gloves/add_blood_DNA(list/blood_dna, list/datum/disease/diseases)
	. = ..()
	transfer_blood = rand(2, 4)

/turf/add_blood_DNA(list/blood_dna, list/datum/disease/diseases)
	var/obj/effect/decal/cleanable/blood/splatter/B = locate() in src
	if(!B)
		B = new /obj/effect/decal/cleanable/blood/splatter(src, diseases)
	B.add_blood_DNA(blood_dna) //give blood info to the blood decal.
	return TRUE //we bloodied the floor

/mob/living/carbon/human/add_blood_DNA(list/blood_dna, list/datum/disease/diseases)
	if(wear_suit)
		wear_suit.add_blood_DNA(blood_dna)
		update_inv_wear_suit()
	else if(w_uniform)
		w_uniform.add_blood_DNA(blood_dna)
		update_inv_w_uniform()
	if(gloves)
		var/obj/item/clothing/gloves/G = gloves
		G.add_blood_DNA(blood_dna)
	else if(length(blood_dna))
		AddComponent(/datum/component/forensics, null, null, dna)
		bloody_hands = rand(2, 4)
	update_inv_gloves()	//handles bloody hands overlays and updating
	return TRUE

/atom/proc/transfer_fingerprints_to(atom/A)
	A.add_fingerprint_list(return_fingerprints())
	A.add_hiddenprint_list(return_hiddenprints())
	A.fingerprintslast = fingerprintslast
>>>>>>> 9d0e97f... Merge pull request #32311 from kevinz000/component_forensics
