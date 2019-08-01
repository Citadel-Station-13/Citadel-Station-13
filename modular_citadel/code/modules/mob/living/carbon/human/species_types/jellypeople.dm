/datum/species/jelly/slime
	name = "Xenobiological Slimeperson"

//##########SLIMEPEOPLE##########

/datum/species/jelly/roundstartslime
	name = "Slimeperson"
	id = "slimeperson"
	limbs_id = "slime"
	default_color = "00FFFF"
	species_traits = list(MUTCOLORS,EYECOLOR,HAIR,FACEHAIR,NOBLOOD)
	inherent_traits = list(TRAIT_TOXINLOVER)
	mutant_bodyparts = list("mam_tail", "mam_ears", "mam_body_markings", "mam_snouts", "taur")
	default_features = list("mcolor" = "FFF", "mcolor2" = "FFF","mcolor3" = "FFF", "mam_tail" = "None", "mam_ears" = "None", "mam_body_markings" = "Plain", "mam_snouts" = "None", "taur" = "None")
	say_mod = "says"
	hair_color = "mutcolor"
	hair_alpha = 160 //a notch brighter so it blends better.
	coldmod = 3
	heatmod = 1
	burnmod = 1

/datum/species/jelly/roundstartslime/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		stop_wagging_tail(H)

/datum/species/jelly/roundstartslime/spec_stun(mob/living/carbon/human/H,amount)
	if(H)
		stop_wagging_tail(H)
	. = ..()

/datum/species/jelly/roundstartslime/can_wag_tail(mob/living/carbon/human/H)
	return ("mam_tail" in mutant_bodyparts) || ("mam_waggingtail" in mutant_bodyparts)

/datum/species/jelly/roundstartslime/is_wagging_tail(mob/living/carbon/human/H)
	return ("mam_waggingtail" in mutant_bodyparts)

/datum/species/jelly/roundstartslime/start_wagging_tail(mob/living/carbon/human/H)
	if("mam_tail" in mutant_bodyparts)
		mutant_bodyparts -= "mam_tail"
		mutant_bodyparts |= "mam_waggingtail"
	H.update_body()

/datum/species/jelly/roundstartslime/stop_wagging_tail(mob/living/carbon/human/H)
	if("mam_waggingtail" in mutant_bodyparts)
		mutant_bodyparts -= "mam_waggingtail"
		mutant_bodyparts |= "mam_tail"
	H.update_body()


/datum/action/innate/slime_change
	name = "Alter Form"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "alter_form" //placeholder
	icon_icon = 'modular_citadel/icons/mob/actions/actions_slime.dmi'
	background_icon_state = "bg_alien"

/datum/action/innate/slime_change/Activate()
	var/mob/living/carbon/human/H = owner
	if(!isjellyperson(H))
		return
	else
		H.visible_message("<span class='notice'>[owner] gains a look of \
		concentration while standing perfectly still.\
		 Their body seems to shift and starts getting more goo-like.</span>",
		"<span class='notice'>You focus intently on altering your body while \
		standing perfectly still...</span>")
		change_form()

/datum/action/innate/slime_change/proc/change_form()
	var/mob/living/carbon/human/H = owner
	var/select_alteration = input(owner, "Select what part of your form to alter", "Form Alteration", "cancel") in list("Hair Style", "Genitals", "Tail", "Snout", "Markings", "Ears", "Taur body", "Penis", "Vagina", "Penis Length", "Breast Size", "Breast Shape", "Cancel")
	if(select_alteration == "Hair Style")
		if(H.gender == MALE)
			var/new_style = input(owner, "Select a facial hair style", "Hair Alterations")  as null|anything in GLOB.facial_hair_styles_list
			if(new_style)
				H.facial_hair_style = new_style
		else
			H.facial_hair_style = "Shaved"
		//handle normal hair
		var/new_style = input(owner, "Select a hair style", "Hair Alterations")  as null|anything in GLOB.hair_styles_list
		if(new_style)
			H.hair_style = new_style
			H.update_hair()
	else if (select_alteration == "Genitals")
		var/list/organs = list()
		var/operation = input("Select organ operation.", "Organ Manipulation", "cancel") in list("add sexual organ", "remove sexual organ", "cancel")
		switch(operation)
			if("add sexual organ")
				var/new_organ = input("Select sexual organ:", "Organ Manipulation") in list("Penis", "Testicles", "Breasts", "Vagina", "Womb", "Cancel")
				if(new_organ == "Penis")
					H.give_penis()
				else if(new_organ == "Testicles")
					H.give_balls()
				else if(new_organ == "Breasts")
					H.give_breasts()
				else if(new_organ == "Vagina")
					H.give_vagina()
				else if(new_organ == "Womb")
					H.give_womb()
				else
					return
			if("remove sexual organ")
				for(var/obj/item/organ/genital/X in H.internal_organs)
					var/obj/item/organ/I = X
					organs["[I.name] ([I.type])"] = I
				var/obj/item/organ = input("Select sexual organ:", "Organ Manipulation", null) in organs
				organ = organs[organ]
				if(!organ)
					return
				var/obj/item/organ/genital/O
				if(isorgan(organ))
					O = organ
					O.Remove(H)
				organ.forceMove(get_turf(H))
				qdel(organ)
				H.update_genitals()

	else if (select_alteration == "Ears")
		var/list/snowflake_ears_list = list("Normal" = null)
		for(var/path in GLOB.mam_ears_list)
			var/datum/sprite_accessory/mam_ears/instance = GLOB.mam_ears_list[path]
			if(istype(instance, /datum/sprite_accessory))
				var/datum/sprite_accessory/S = instance
				if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(H.client.ckey)))
					snowflake_ears_list[S.name] = path
		var/new_ears
		new_ears = input(owner, "Choose your character's ears:", "Ear Alteration") as null|anything in snowflake_ears_list
		if(new_ears)
			H.dna.features["mam_ears"] = new_ears
		H.update_body()

	else if (select_alteration == "Snout")
		var/list/snowflake_snouts_list = list("Normal" = null)
		for(var/path in GLOB.mam_snouts_list)
			var/datum/sprite_accessory/mam_snouts/instance = GLOB.mam_snouts_list[path]
			if(istype(instance, /datum/sprite_accessory))
				var/datum/sprite_accessory/S = instance
				if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(H.client.ckey)))
					snowflake_snouts_list[S.name] = path
		var/new_snout
		new_snout = input(owner, "Choose your character's face:", "Face Alteration") as null|anything in snowflake_snouts_list
		if(new_snout)
			H.dna.features["mam_snouts"] = new_snout
		H.update_body()

	else if (select_alteration == "Markings")
		var/list/snowflake_markings_list = list()
		for(var/path in GLOB.mam_body_markings_list)
			var/datum/sprite_accessory/mam_body_markings/instance = GLOB.mam_body_markings_list[path]
			if(istype(instance, /datum/sprite_accessory))
				var/datum/sprite_accessory/S = instance
				if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(H.client.ckey)))
					snowflake_markings_list[S.name] = path
		var/new_mam_body_markings
		new_mam_body_markings = input(H, "Choose your character's body markings:", "Marking Alteration") as null|anything in snowflake_markings_list
		if(new_mam_body_markings)
			H.dna.features["mam_body_markings"] = new_mam_body_markings
			if(new_mam_body_markings == "None")
				H.dna.features["mam_body_markings"] = "Plain"
		for(var/X in H.bodyparts) //propagates the markings changes
			var/obj/item/bodypart/BP = X
			BP.update_limb(FALSE, H)
		H.update_body()

	else if (select_alteration == "Tail")
		var/list/snowflake_tails_list = list("Normal" = null)
		for(var/path in GLOB.mam_tails_list)
			var/datum/sprite_accessory/mam_tails/instance = GLOB.mam_tails_list[path]
			if(istype(instance, /datum/sprite_accessory))
				var/datum/sprite_accessory/S = instance
				if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(H.client.ckey)))
					snowflake_tails_list[S.name] = path
		var/new_tail
		new_tail = input(owner, "Choose your character's Tail(s):", "Tail Alteration") as null|anything in snowflake_tails_list
		if(new_tail)
			H.dna.features["mam_tail"] = new_tail
			if(new_tail != "None")
				H.dna.features["taur"] = "None"
		H.update_body()

	else if (select_alteration == "Taur body")
		var/list/snowflake_taur_list = list("Normal" = null)
		for(var/path in GLOB.taur_list)
			var/datum/sprite_accessory/taur/instance = GLOB.taur_list[path]
			if(istype(instance, /datum/sprite_accessory))
				var/datum/sprite_accessory/S = instance
				if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(H.client.ckey)))
					snowflake_taur_list[S.name] = path
		var/new_taur
		new_taur = input(owner, "Choose your character's tauric body:", "Tauric Alteration") as null|anything in snowflake_taur_list
		if(new_taur)
			H.dna.features["taur"] = new_taur
			if(new_taur != "None")
				H.dna.features["mam_tail"] = "None"
		H.update_body()

	else if (select_alteration == "Penis")
		for(var/obj/item/organ/genital/penis/X in H.internal_organs)
			qdel(X)
		var/new_shape
		new_shape = input(owner, "Choose your character's dong", "Genital Alteration") as null|anything in GLOB.cock_shapes_list
		if(new_shape)
			H.dna.features["cock_shape"] = new_shape
		H.update_genitals()
		H.give_balls()
		H.give_penis()
		H.apply_overlay()


	else if (select_alteration == "Vagina")
		for(var/obj/item/organ/genital/vagina/X in H.internal_organs)
			qdel(X)
		var/new_shape
		new_shape = input(owner, "Choose your character's pussy", "Genital Alteration") as null|anything in GLOB.vagina_shapes_list
		if(new_shape)
			H.dna.features["vag_shape"] = new_shape
		H.update_genitals()
		H.give_womb()
		H.give_vagina()
		H.apply_overlay()

	else if (select_alteration == "Penis Length")
		for(var/obj/item/organ/genital/penis/X in H.internal_organs)
			qdel(X)
		var/new_length
		new_length = input(owner, "Penis length in inches:\n([COCK_SIZE_MIN]-[COCK_SIZE_MAX])", "Genital Alteration") as num|null
		if(new_length)
			H.dna.features["cock_length"] = max(min( round(text2num(new_length)), COCK_SIZE_MAX),COCK_SIZE_MIN)
		H.update_genitals()
		H.apply_overlay()
		H.give_balls()
		H.give_penis()

	else if (select_alteration == "Breast Size")
		for(var/obj/item/organ/genital/breasts/X in H.internal_organs)
			qdel(X)
		var/new_size
		new_size = input(owner, "Breast Size", "Genital Alteration") as null|anything in GLOB.breasts_size_list
		if(new_size)
			H.dna.features["breasts_size"] = new_size
		H.update_genitals()
		H.apply_overlay()
		H.give_breasts()

	else if (select_alteration == "Breast Shape")
		for(var/obj/item/organ/genital/breasts/X in H.internal_organs)
			qdel(X)
		var/new_shape
		new_shape = input(owner, "Breast Shape", "Genital Alteration") as null|anything in GLOB.breasts_shapes_list
		if(new_shape)
			H.dna.features["breasts_shape"] = new_shape
		H.update_genitals()
		H.apply_overlay()
		H.give_breasts()

	else
		return
