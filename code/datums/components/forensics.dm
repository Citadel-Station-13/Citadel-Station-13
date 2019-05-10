/datum/component/forensics
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/list/fingerprints		//assoc print = print
	var/list/hiddenprints		//assoc ckey = realname/gloves/ckey
	var/list/blood_DNA			//assoc dna = bloodtype
	var/list/fibers				//assoc print = print
	var/list/blood_mix_types	// data("[blood_type]" = sting list

/datum/component/forensics/InheritComponent(datum/component/forensics/F, original)		//Use of | and |= being different here is INTENTIONAL.
	fingerprints = fingerprints | F.fingerprints
	hiddenprints = hiddenprints | F.hiddenprints
	blood_DNA = blood_DNA | F.blood_DNA
	fibers = fibers | F.fibers
	blood_mix_types = blood_mix_types | F.blood_mix_types
	check_blood()
	return ..()

/datum/component/forensics/Initialize(new_fingerprints, new_hiddenprints, new_blood_DNA, new_fibers, new_blood_mix_types)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	fingerprints = new_fingerprints
	hiddenprints = new_hiddenprints
	blood_DNA = new_blood_DNA
	fibers = new_fibers
	blood_mix_types = new_blood_mix_types
	check_blood()
	RegisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT, .proc/clean_act)

/datum/component/forensics/proc/wipe_fingerprints()
	fingerprints = null
	return TRUE

/datum/component/forensics/proc/wipe_hiddenprints()
	return	//no.

/datum/component/forensics/proc/wipe_blood_DNA()
	blood_DNA = null
	blood_mix_types = null
	return TRUE

/datum/component/forensics/proc/wipe_fibers()
	fibers = null
	return TRUE

/datum/component/forensics/proc/clean_act(datum/source, strength)
	if(strength >= CLEAN_STRENGTH_FINGERPRINTS)
		wipe_fingerprints()
	if(strength >= CLEAN_STRENGTH_BLOOD)
		wipe_blood_DNA()
	if(strength >= CLEAN_STRENGTH_FIBERS)
		wipe_fibers()

/datum/component/forensics/proc/add_fingerprint_list(list/_fingerprints)	//list(text)
	if(!length(_fingerprints))
		return
	LAZYINITLIST(fingerprints)
	for(var/i in _fingerprints)	//We use an associative list, make sure we don't just merge a non-associative list into ours.
		fingerprints[i] = i
	return TRUE

/datum/component/forensics/proc/add_fingerprint(mob/living/M, ignoregloves = FALSE)
	if(!M)
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
				H.gloves.add_fingerprint(H, TRUE) //ignoregloves = 1 to avoid infinite loop.
				return
		var/full_print = md5(H.dna.uni_identity)
		LAZYSET(fingerprints, full_print, full_print)
	return TRUE

/datum/component/forensics/proc/add_fiber_list(list/_fibertext)		//list(text)
	if(!length(_fibertext))
		return
	LAZYINITLIST(fibers)
	for(var/i in _fibertext)	//We use an associative list, make sure we don't just merge a non-associative list into ours.
		fibers[i] = i
	return TRUE

/datum/component/forensics/proc/add_fibers(mob/living/carbon/human/M)
	var/fibertext
	var/item_multiplier = isitem(src)?1.2:1
	if(M.wear_suit)
		fibertext = "Material from \a [M.wear_suit]."
		if(prob(10*item_multiplier) && !LAZYACCESS(fibers, fibertext))
			LAZYSET(fibers, fibertext, fibertext)
		if(!(M.wear_suit.body_parts_covered & CHEST))
			if(M.w_uniform)
				fibertext = "Fibers from \a [M.w_uniform]."
				if(prob(12*item_multiplier) && !LAZYACCESS(fibers, fibertext)) //Wearing a suit means less of the uniform exposed.
					LAZYSET(fibers, fibertext, fibertext)
		if(!(M.wear_suit.body_parts_covered & HANDS))
			if(M.gloves)
				fibertext = "Material from a pair of [M.gloves.name]."
				if(prob(20*item_multiplier) && !LAZYACCESS(fibers, fibertext))
					LAZYSET(fibers, fibertext, fibertext)
	else if(M.w_uniform)
		fibertext = "Fibers from \a [M.w_uniform]."
		if(prob(15*item_multiplier) && !LAZYACCESS(fibers, fibertext))
			// "Added fibertext: [fibertext]"
			LAZYSET(fibers, fibertext, fibertext)
		if(M.gloves)
			fibertext = "Material from a pair of [M.gloves.name]."
			if(prob(20*item_multiplier) && !LAZYACCESS(fibers, fibertext))
				LAZYSET(fibers, fibertext, fibertext)
	else if(M.gloves)
		fibertext = "Material from a pair of [M.gloves.name]."
		if(prob(20*item_multiplier) && !LAZYACCESS(fibers, fibertext))
			LAZYSET(fibers, fibertext, fibertext)
	return TRUE

/datum/component/forensics/proc/add_hiddenprint_list(list/_hiddenprints)	//list(ckey = text)
	if(!length(_hiddenprints))
		return
	LAZYINITLIST(hiddenprints)
	for(var/i in _hiddenprints)	//We use an associative list, make sure we don't just merge a non-associative list into ours.
		hiddenprints[i] = _hiddenprints[i]
	return TRUE

/datum/component/forensics/proc/add_hiddenprint(mob/living/M)
	if(!M || !M.key)
		return
	var/hasgloves = ""
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.gloves)
			hasgloves = "(gloves)"
	var/current_time = TIME_STAMP("hh:mm:ss", FALSE)
	if(!LAZYACCESS(hiddenprints, M.key))
		LAZYSET(hiddenprints, M.key, "First: [M.real_name]\[[current_time]\][hasgloves]. Ckey: [M.ckey]")
	else
		var/laststamppos = findtext(LAZYACCESS(hiddenprints, M.key), " Last: ")
		if(laststamppos)
			LAZYSET(hiddenprints, M.key, copytext(hiddenprints[M.key], 1, laststamppos))
		hiddenprints[M.key] += " Last: [M.real_name]\[[current_time]\][hasgloves]. Ckey: [M.ckey]"	//made sure to be existing by if(!LAZYACCESS);else
	var/atom/A = parent
	A.fingerprintslast = M.ckey
	return TRUE

/datum/component/forensics/proc/add_blood_DNA(list/dna)		//list(dna_enzymes = type)
	if(!length(dna))
		return
	LAZYINITLIST(blood_DNA)
	for(var/i in dna)
		blood_DNA[i] = dna[i]
	check_blood()
	return TRUE

/datum/component/forensics/proc/check_blood()
	if(!isitem(parent) || !ismob(parent))
		return
	if(!length(blood_DNA))
		return

/datum/component/forensics/proc/add_blood_list_check(list/_blood_mix_types)
	if(!length(_blood_mix_types))
		return
	LAZYINITLIST(blood_mix_types)
	for(var/i in _blood_mix_types)	//We use an associative list, because all the other cool kids are doing it
		blood_mix_types[i] = i
	return TRUE

/datum/component/forensics/proc/blood_list_checks(Atom/A, var/blood_type) //This is a messy attempt at trying to reduce lists of items and mobs with blood colors on them
	if(blood_type in GLOB.regular_bloods)
		blood_type = "A+" //generic so we don't have 8 different types of human blood
	if(is_cleanable(src))
		var/obj/effect/decal/cleanable/CL = src
		if(blood_type in CL.blood_mix_types)
			return
		else
			LAZYSET(blood_type,CL.blood_mix_types, CL.blood_mix_types)
			CL.blood_color = blood_DNA_to_color(CL.blood_mix_types)
	else if(isitem(src))
		var/obj/item/I = src
		if(blood_type in I.blood_mix_types)
			return
		else
			LAZYSET(blood_type,I.blood_mix_types, I.blood_mix_types)
			I.blood_color = blood_DNA_to_color(I.blood_mix_types)
	else if(iscarbon(src))
		var/mob/living/carbon/C = src
		if(blood_type in C.blood_mix_types)
			return
		else
			LAZYSET(blood_type,C.blood_mix_types, C.blood_mix_types)
			C.blood_color = blood_DNA_to_color(C.blood_mix_types)
	return TRUE

/datum/component/forensics/proc/blood_DNA_to_color(list/bloods)
	var/final_rgb = "#940000" //We default to red just in case
	if(bloods.len)
		var/sum = 0 //this is all shitcode, but it works; trust me
		final_rgb = bloodtype_to_color(bloods[1])
		sum = bloods[bloods[1]]
		if(bloods.len > 1)
			var/i = 2
			while(i <= bloods.len)
				var/tmp = bloods[bloods[i]]
				final_rgb = BlendRGB(final_rgb, bloodtype_to_color(bloods[i]), tmp/(tmp+sum))
				sum += tmp
				i++
		else
			final_rgb = BlendRGB(final_rgb, bloodtype_to_color(bloods))
	return final_rgb
