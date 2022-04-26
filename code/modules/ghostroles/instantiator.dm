/**
 * Handles mob creation, equip, and ckey transfer.
 */
/datum/ghostrole_instantiator
	/// traits to add to mob : will be made with GHOSTROLE_TRAIT source
	var/list/mob_traits

/datum/ghostrole_instantiator/proc/Run(client/C, atom/location, list/params)
	RETURN_TYPE(/mob)
	. = Create(C, location, params)
	if(!.)
		return
	Equip(C, ., params)

/datum/ghostrole_instantiator/proc/Create(client/C, atom/location, list/params)
	CRASH("Base Create() called on ghostrole instantiator datum.")

/datum/ghostrole_instantiator/proc/Equip(client/C, mob/M, list/params)
	CRASH("Base Equip() called on ghostrole instantiator datum.")

/datum/ghostrole_instantiator/simple
	var/mob_type

/datum/ghostrole_instantiator/simple/Create(client/C, atom/location, list/params)
	var/type_to_make = GetMobType(location)
	if(!ispath(type_to_make, /mob/living))
		CRASH("Invalid path: [type_to_make]")
	var/mob/living/L = new type_to_make(location)
	for(var/trait in mob_traits)
		ADD_TRAIT(L, trait, GHOSTROLE_TRAIT)
	return L

/datum/ghostrole_instantiator/simple/proc/GetMobType(client/C, atom/location, list/params)
	return params["mob"] || mob_type

/datum/ghostrole_instantiator/human
	/// outfit to equip
	var/equip_outfit

/datum/ghostrole_instantiator/human/Create(client/C, atom/location, list/params)
	var/mob/living/carbon/human/H = new(location)
	for(var/trait in mob_traits)
		ADD_TRAIT(H, trait, GHOSTROLE_TRAIT)
	return H

/datum/ghostrole_instantiator/human/Equip(client/C, mob/M, list/params)
	var/mob/living/carbon/human/H = M

	H.dna.species.before_equip_job(null, H)

	var/datum/outfit/O = GetOutfit(C, M, params)
	if(ispath(O, /datum/outfit))
		O = new O
	O.equip(M)

	H.dna.species.after_equip_job(null, H)

/**
 * Returns an outfit instance or a typepath
 */
/datum/ghostrole_instantiator/human/proc/GetOutfit(client/C, mob/M, list/params)
	// allow for outfit override
	if(params["outfit"])
		var/override = params["outfit"]
		if(istext(override))
			override = text2path(override)
		if(ispath(override, /datum/outfit))
			return override
		if(istype(override, /datum/outfit))
			return override
	if(ispath(equip_outfit, /datum/outfit))
		return equip_outfit
	if(istype(equip_outfit, /datum/outfit))
		return equip_outfit
	return new /datum/outfit

/datum/ghostrole_instantiator/human/random

/datum/ghostrole_instantiator/human/random/Create(client/C, atom/location, list/params)
	var/mob/living/carbon/human/H = ..()
	Randomize(H, params)
	return H

/datum/ghostrole_instantiator/human/random/proc/Randomize(mob/living/carbon/human/H, list/params)
	return			// tgcode does this automatically

/datum/ghostrole_instantiator/human/random/species
	/// allowed species types
	var/list/possible_species = list(
		/datum/species/human,
		/datum/species/lizard,
		/datum/species/plasmaman,
		/datum/species/jelly,
		/datum/species/ipc
	)

/datum/ghostrole_instantiator/human/random/species/proc/GetSpeciesPath(mob/living/carbon/human/H, list/params)
	var/override = params["species"]
	if(istext(override))
		override = text2path(override)
	if(ispath(override, /datum/species))
		return override
	return safepick(possible_species) || /datum/species/human

/datum/ghostrole_instantiator/human/random/species/Randomize(mob/living/carbon/human/H, list/params)
	. = ..()
	var/species = pick(GetSpeciesPath(H, params))
	H.set_species(new species)
	var/new_name
	switch(H.dna.species.type)
		if(/datum/species/lizard)
			new_name = random_unique_lizard_name()
		if(/datum/species/ethereal)
			new_name = random_unique_ethereal_name()
		if(/datum/species/plasmaman)
			new_name = random_unique_plasmaman_name()
		if(/datum/species/insect)
			new_name = random_unique_moth_name()
		if(/datum/species/arachnid)
			new_name = random_unique_arachnid_name()
		else
			new_name = random_unique_name()
	H.fully_replace_character_name(H.real_name, new_name)

/datum/ghostrole_instantiator/human/player_static
	/// equip loadout
	var/equip_loadout = TRUE
	/// equip traits
	var/equip_traits = TRUE

/datum/ghostrole_instantiator/human/player_static/Create(client/C, atom/location, list/params)
	var/mob/living/carbon/human/H = ..()
	LoadSavefile(C, H)
	return H

/datum/ghostrole_instantiator/human/player_static/proc/LoadSavefile(client/C, mob/living/carbon/human/H)
	C.prefs.copy_to(H)
	if(equip_loadout)
		SSjob.EquipLoadout(H, FALSE, null, C.prefs, C.ckey)
	if(equip_traits && CONFIG_GET(flag/roundstart_traits))
		SSquirks.AssignQuirks(H, C, TRUE, FALSE, null, FALSE, C)
