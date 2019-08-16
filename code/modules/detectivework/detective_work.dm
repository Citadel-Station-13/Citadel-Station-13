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
	B.update_icon()
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
		AddComponent(/datum/component/forensics, null, null, blood_dna)
		bloody_hands = rand(2, 4)
	if(head)
		head.add_blood_DNA(blood_dna)
		update_inv_head()
	else if(wear_mask)
		wear_mask.add_blood_DNA(blood_dna)
		update_inv_wear_mask()
	if(wear_neck)
		wear_neck.add_blood_DNA(blood_dna)
		update_inv_neck()
	update_inv_gloves()	//handles bloody hands overlays and updating
	return TRUE

/atom/proc/transfer_fingerprints_to(atom/A)
	A.add_fingerprint_list(return_fingerprints())
	A.add_hiddenprint_list(return_hiddenprints())
	A.fingerprintslast = fingerprintslast

//to add blood dna info to the object's blood_DNA list
/atom/proc/transfer_blood_dna(list/blood_dna)
	var/list/blood_DNA = return_blood_DNA()
	if(!blood_DNA)
		blood_DNA = list()
	var/old_length = blood_DNA.len
	blood_DNA |= blood_dna
	if(blood_DNA.len > old_length)
		return TRUE//some new blood DNA was added

/atom/proc/blood_DNA_to_color()
	return

/obj/effect/decal/cleanable/blood/blood_DNA_to_color()
	to_chat(world, "blood dna to color called by [src]")
	var/list/colors = list()//first we make a list of all bloodtypes present
	for(var/bloop in Blood_DNA)
		if(colors[Blood_DNA[bloop]])
			colors[Blood_DNA[bloop]]++
		else
			colors[Blood_DNA[bloop]] = 1

	var/final_rgb = BLOOD_COLOR_HUMAN

	to_chat(world, "colors has [colors.len] bloodtypes in it")
	if(colors.len)
		var/sum = 0 //this is all shitcode, but it works; trust me
		final_rgb = bloodtype_to_color(colors[1])
		sum = colors[colors[1]]
		if(colors.len > 1)
			var/i = 2
			while(i <= colors.len)
				var/tmp = colors[colors[i]]
				final_rgb = BlendRGB(final_rgb, bloodtype_to_color(colors[i]), tmp/(tmp+sum))
				sum += tmp
				i++

	return final_rgb

/obj/item/clothing/blood_DNA_to_color()
	var/final_rgb = BLOOD_COLOR_HUMAN
	if(last_bloodtype)
		final_rgb = bloodtype_to_color(last_bloodtype)
	return final_rgb
