/datum/species/synth
	name = "Synthetic" //inherited from the real species, for health scanners and things
	id = SPECIES_SYNTH
	say_mod = "beep boops" //inherited from a user's real species
	sexes = 0
	species_traits = list(NOTRANSSTING,NOGENITALS,NOAROUSAL) //all of these + whatever we inherit from the real species
	inherent_traits = list(TRAIT_VIRUSIMMUNE,TRAIT_NODISMEMBER,TRAIT_NOLIMBDISABLE,TRAIT_NOHUNGER,TRAIT_NOBREATH)
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	dangerous_existence = 1
	blacklisted = 1
	meat = null
	gib_types = /obj/effect/gibspawner/robot
	damage_overlay_type = "synth"
	limbs_id = SPECIES_SYNTH
	var/list/initial_species_traits = list(NOTRANSSTING) //for getting these values back for assume_disguise()
	var/list/initial_inherent_traits = list(TRAIT_VIRUSIMMUNE,TRAIT_NODISMEMBER,TRAIT_NOLIMBDISABLE,TRAIT_NOHUNGER,TRAIT_NOBREATH)
	var/disguise_fail_health = 75 //When their health gets to this level their synthflesh partially falls off
	var/datum/species/fake_species = null //a species to do most of our work for us, unless we're damaged
	species_language_holder = /datum/language_holder/synthetic
	species_category = SPECIES_CATEGORY_ROBOT

/datum/species/synth/military
	name = "Military Synth"
	id = SPECIES_SYNTH_MIL
	armor = 25
	punchdamagelow = 10
	punchdamagehigh = 19
	punchstunthreshold = 14
	disguise_fail_health = 50

/datum/species/synth/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	..()
	assume_disguise(old_species, H)
	RegisterSignal(H, COMSIG_MOB_SAY, .proc/handle_speech)

/datum/species/synth/on_species_loss(mob/living/carbon/human/H)
	. = ..()
	UnregisterSignal(H, COMSIG_MOB_SAY)

/datum/species/synth/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.type == /datum/reagent/medicine/synthflesh)
		chem.reaction_mob(H, TOUCH, 2 ,0) //heal a little
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM)
		return TRUE
	return ..()

/datum/species/synth/proc/assume_disguise(datum/species/S, mob/living/carbon/human/H)
	if(S && !istype(S, type))
		name = S.name
		say_mod = S.say_mod
		sexes = S.sexes
		species_traits = initial_species_traits.Copy()
		inherent_traits = initial_inherent_traits.Copy()
		species_traits |= S.species_traits
		inherent_traits |= S.inherent_traits
		attack_verb = S.attack_verb
		attack_sound = S.attack_sound
		miss_sound = S.miss_sound
		meat = S.meat
		mutant_bodyparts = S.mutant_bodyparts.Copy()
		mutant_organs = S.mutant_organs.Copy()
		nojumpsuit = S.nojumpsuit
		no_equip = S.no_equip.Copy()
		limbs_id = S.mutant_bodyparts["limbs_id"]
		use_skintones = S.use_skintones
		fixed_mut_color = S.fixed_mut_color
		hair_color = S.hair_color
		fake_species = new S.type
	else
		name = initial(name)
		say_mod = initial(say_mod)
		species_traits = initial_species_traits.Copy()
		inherent_traits = initial_inherent_traits.Copy()
		attack_verb = initial(attack_verb)
		attack_sound = initial(attack_sound)
		miss_sound = initial(miss_sound)
		mutant_bodyparts = list()
		nojumpsuit = initial(nojumpsuit)
		no_equip = list()
		qdel(fake_species)
		fake_species = null
		meat = initial(meat)
		limbs_id = SPECIES_SYNTH
		use_skintones = FALSE
		sexes = 0
		fixed_mut_color = ""
		hair_color = ""

	for(var/X in H.bodyparts) //propagates the damage_overlay changes
		var/obj/item/bodypart/BP = X
		BP.update_limb()
	H.update_body_parts() //to update limb icon cache with the new damage overlays

//Proc redirects:
//Passing procs onto the fake_species, to ensure we look as much like them as possible

/datum/species/synth/handle_hair(mob/living/carbon/human/H, forced_colour)
	if(fake_species)
		fake_species.handle_hair(H, forced_colour)
	else
		return ..()

/datum/species/synth/handle_body(mob/living/carbon/human/H)
	if(fake_species)
		fake_species.handle_body(H)
	else
		return ..()

/datum/species/synth/handle_mutant_bodyparts(mob/living/carbon/human/H, forced_colour)
	if(fake_species)
		fake_species.handle_body(H,forced_colour)
	else
		return ..()

/datum/species/synth/proc/handle_speech(datum/source, list/speech_args)
	if (isliving(source)) // yeah it's gonna be living but just to be clean
		var/mob/living/L = source
		if(fake_species && L.health > disguise_fail_health)
			switch (fake_species.type)
				if (/datum/species/golem/bananium)
					speech_args[SPEECH_SPANS] |= SPAN_CLOWN
				if (/datum/species/golem/clockwork)
					speech_args[SPEECH_SPANS] |= SPAN_ROBOT
