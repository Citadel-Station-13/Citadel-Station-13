// This code handles different species in the game.

#define HEAT_DAMAGE_LEVEL_1 2
#define HEAT_DAMAGE_LEVEL_2 3
#define HEAT_DAMAGE_LEVEL_3 8

#define COLD_DAMAGE_LEVEL_1 0.5
#define COLD_DAMAGE_LEVEL_2 1.5
#define COLD_DAMAGE_LEVEL_3 3


/datum/species
	var/id = null		// if the game needs to manually check your race to do something not included in a proc here, it will use this
	var/limbs_id = null	//this is used if you want to use a different species limb sprites. Mainly used for angels as they look like humans.
	var/name = null		// this is the fluff name. these will be left generic (such as 'Lizardperson' for the lizard race) so servers can change them to whatever
	var/roundstart = 0	// can this mob be chosen at roundstart? (assuming the config option is checked?)
	var/default_color = "#FFF"	// if alien colors are disabled, this is the color that will be used by that race

	var/eyes = "eyes"	// which eyes the race uses. at the moment, the only types of eyes are "eyes" (regular eyes) and "jelleyes" (three eyes)
	var/sexes = 1		// whether or not the race has sexual characteristics. at the moment this is only 0 for skeletons and shadows
	var/hair_color = null	// this allows races to have specific hair colors... if null, it uses the H's hair/facial hair colors. if "mutcolor", it uses the H's mutant_color
	var/hair_alpha = 255	// the alpha used by the hair. 255 is completely solid, 0 is transparent.
	var/use_skintones = 0	// does it use skintones or not? (spoiler alert this is only used by humans)
	var/exotic_blood = ""	// If your race wants to bleed something other than bog standard blood, change this to reagent id.
	var/exotic_bloodtype = "" //If your race uses a non standard bloodtype (A+, O-, AB-, etc)
	var/meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human //What the species drops on gibbing
	var/skinned_type = /obj/item/stack/sheet/animalhide/generic
	var/list/no_equip = list()	// slots the race can't equip stuff to
	var/nojumpsuit = 0	// this is sorta... weird. it basically lets you equip stuff that usually needs jumpsuits without one, like belts and pockets and ids
	var/blacklisted = 0 //Flag to exclude from green slime core species.
	var/dangerous_existence = null //A flag for transformation spells that tells them "hey if you turn a person into one of these without preperation, they'll probably die!"
	var/say_mod = "says"	// affects the speech message
	var/list/default_features = list() // Default mutant bodyparts for this species. Don't forget to set one for every mutant bodypart you allow this species to have.
	var/list/mutant_bodyparts = list() 	// Parts of the body that are diferent enough from the standard human model that they cause clipping with some equipment
	var/list/mutant_organs = list(/obj/item/organ/tongue)		//Internal organs that are unique to this race.
	var/speedmod = 0	// this affects the race's speed. positive numbers make it move slower, negative numbers make it move faster
	var/armor = 0		// overall defense for the race... or less defense, if it's negative.
	var/brutemod = 1	// multiplier for brute damage
	var/burnmod = 1		// multiplier for burn damage
	var/coldmod = 1		// multiplier for cold damage
	var/heatmod = 1		// multiplier for heat damage
	var/stunmod = 1		// multiplier for stun duration
	var/punchdamagelow = 0       //lowest possible punch damage
	var/punchdamagehigh = 9      //highest possible punch damage
	var/punchstunthreshold = 9//damage at which punches from this race will stun //yes it should be to the attacked race but it's not useful that way even if it's logical
	var/siemens_coeff = 1 //base electrocution coefficient
	var/damage_overlay_type = "human" //what kind of damage overlays (if any) appear on our species when wounded?
	var/fixed_mut_color = "" //to use MUTCOLOR with a fixed color that's independent of dna.feature["mcolor"]

	var/invis_sight = SEE_INVISIBLE_LIVING
	var/darksight = 2

	// species flags. these can be found in flags.dm
	var/list/species_traits = list()

	var/attack_verb = "punch"	// punch-specific attack verb
	var/sound/attack_sound = 'sound/weapons/punch1.ogg'
	var/sound/miss_sound = 'sound/weapons/punchmiss.ogg'

	var/mob/living/list/ignored_by = list()	// list of mobs that will ignore this species
	//Breathing!
	var/obj/item/organ/lungs/mutantlungs = null
	var/breathid = "o2"

	//Flight and floating
	var/override_float = 0

	///////////
	// PROCS //
	///////////


/datum/species/New()

	if(!limbs_id)	//if we havent set a limbs id to use, just use our own id
		limbs_id = id
	..()


/datum/species/proc/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_name(gender)

	var/randname
	if(gender == MALE)
		randname = pick(first_names_male)
	else
		randname = pick(first_names_female)

	if(lastname)
		randname += " [lastname]"
	else
		randname += " [pick(last_names)]"

	return randname


//Please override this locally if you want to define when what species qualifies for what rank if human authority is enforced.
/datum/species/proc/qualifies_for_rank(rank, list/features)
	if(rank in command_positions)
		return 0
	return 1

/datum/species/proc/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	// Drop the items the new species can't wear
	for(var/slot_id in no_equip)
		var/obj/item/thing = C.get_item_by_slot(slot_id)
		if(thing && (!thing.species_exception || !is_type_in_list(src,thing.species_exception)))
			C.unEquip(thing)

	var/obj/item/organ/heart/heart = C.getorganslot("heart")
	var/obj/item/organ/lungs/lungs = C.getorganslot("lungs")
	var/obj/item/organ/appendix/appendix = C.getorganslot("appendix")

	if((NOBLOOD in species_traits) && heart)
		heart.Remove(C)
		qdel(heart)
	else if((!(NOBLOOD in species_traits)) && (!heart))
		heart = new()
		heart.Insert(C)

	if(lungs)
		lungs.Remove(C)
		qdel(lungs)
		lungs = null
	if((!(NOBREATH in species_traits)) && !lungs)
		if(mutantlungs)
			lungs = new mutantlungs()
		else
			lungs = new()
		lungs.Insert(C)

	if((NOHUNGER in species_traits) && appendix)
		appendix.Remove(C)
		qdel(appendix)
	else if((!(NOHUNGER in species_traits)) && (!appendix))
		appendix = new()
		appendix.Insert(C)

	for(var/path in mutant_organs)
		var/obj/item/organ/I = new path()
		I.Insert(C)

	if(exotic_bloodtype && C.dna.blood_type != exotic_bloodtype)
		C.dna.blood_type = exotic_bloodtype
	if(("legs" in C.dna.species.mutant_bodyparts) && C.dna.features["legs"] == "Digitigrade Legs")
		species_traits += DIGITIGRADE
	if(DIGITIGRADE in species_traits)
		C.Digitigrade_Leg_Swap(FALSE)

/datum/species/proc/on_species_loss(mob/living/carbon/C)
	if(C.dna.species.exotic_bloodtype)
		C.dna.blood_type = random_blood_type()
	if(DIGITIGRADE in species_traits)
		C.Digitigrade_Leg_Swap(TRUE)

/datum/species/proc/handle_hair(mob/living/carbon/human/H, forced_colour)
	H.remove_overlay(HAIR_LAYER)

	var/obj/item/bodypart/head/HD = H.get_bodypart("head")
	if(!HD) //Decapitated
		return

	if(H.disabilities & HUSK)
		return
	var/datum/sprite_accessory/S
	var/list/standing = list()
	var/hair_hidden = 0
	var/facialhair_hidden = 0
	//we check if our hat or helmet hides our facial hair.
	if(H.head)
		var/obj/item/I = H.head
		if(I.flags_inv & HIDEFACIALHAIR)
			facialhair_hidden = 1
	if(H.wear_mask)
		var/obj/item/clothing/mask/M = H.wear_mask
		if(M.flags_inv & HIDEFACIALHAIR)
			facialhair_hidden = 1

	if(H.facial_hair_style && (FACEHAIR in species_traits) && !facialhair_hidden)
		S = facial_hair_styles_list[H.facial_hair_style]
		if(S)
			var/image/img_facial_s = image("icon" = S.icon, "icon_state" = "[S.icon_state]_s", "layer" = -HAIR_LAYER)

			if(!forced_colour)
				if(hair_color)
					if(hair_color == "mutcolor")
						img_facial_s.color = "#" + H.dna.features["mcolor"]
					else
						img_facial_s.color = "#" + hair_color
				else
					img_facial_s.color = "#" + H.facial_hair_color
			else
				img_facial_s.color = forced_colour

			img_facial_s.alpha = hair_alpha

			standing += img_facial_s

	//we check if our hat or helmet hides our hair.
	if(H.head)
		var/obj/item/I = H.head
		if(I.flags_inv & HIDEHAIR)
			hair_hidden = 1
	if(H.wear_mask)
		var/obj/item/clothing/mask/M = H.wear_mask
		if(M.flags_inv & HIDEHAIR)
			hair_hidden = 1
	if(!hair_hidden)
		if(!H.getorgan(/obj/item/organ/brain)) //Applies the debrained overlay if there is no brain
			if(!(NOBLOOD in species_traits))
				standing += image("icon"='icons/mob/human_face.dmi', "icon_state" = "debrained_s", "layer" = -HAIR_LAYER)

		else if(H.hair_style && (HAIR in species_traits))
			S = hair_styles_list[H.hair_style]
			if(S)
				var/image/img_hair_s = image("icon" = S.icon, "icon_state" = "[S.icon_state]_s", "layer" = -HAIR_LAYER)

				img_hair_s = image("icon" = S.icon, "icon_state" = "[S.icon_state]_s", "layer" = -HAIR_LAYER)

				if(!forced_colour)
					if(hair_color)
						if(hair_color == "mutcolor")
							img_hair_s.color = "#" + H.dna.features["mcolor"]
						else
							img_hair_s.color = "#" + hair_color
					else
						img_hair_s.color = "#" + H.hair_color
				else
					img_hair_s.color = forced_colour
				img_hair_s.alpha = hair_alpha

				standing += img_hair_s

	if(standing.len)
		H.overlays_standing[HAIR_LAYER]	= standing

	H.apply_overlay(HAIR_LAYER)

/datum/species/proc/handle_body(mob/living/carbon/human/H)
	H.remove_overlay(BODY_LAYER)

	var/list/standing	= list()

	var/obj/item/bodypart/head/HD = H.get_bodypart("head")

	if(!(H.disabilities & HUSK))
		// lipstick
		if(H.lip_style && (LIPS in species_traits) && HD)
			var/image/lips = image("icon"='icons/mob/human_face.dmi', "icon_state"="lips_[H.lip_style]_s", "layer" = -BODY_LAYER)
			lips.color = H.lip_color
			standing	+= lips

		// eyes
		if((EYECOLOR in species_traits) && HD)
			var/image/img_eyes_s = image("icon" = 'icons/mob/human_face.dmi', "icon_state" = "[eyes]_s", "layer" = -BODY_LAYER)
			img_eyes_s.color = "#" + H.eye_color
			standing	+= img_eyes_s

	//Underwear, Undershirts & Socks
	if(H.underwear)
		var/datum/sprite_accessory/underwear/U = underwear_list[H.underwear]
		if(U)
			standing	+= image("icon"=U.icon, "icon_state"="[U.icon_state]_s", "layer"=-BODY_LAYER)

	if(H.undershirt)
		var/datum/sprite_accessory/undershirt/U2 = undershirt_list[H.undershirt]
		if(U2)
			if(H.dna.species.sexes && H.gender == FEMALE)
				standing	+=	wear_female_version("[U2.icon_state]_s", U2.icon, BODY_LAYER)
			else
				standing	+= image("icon"=U2.icon, "icon_state"="[U2.icon_state]_s", "layer"=-BODY_LAYER)

	if(H.socks && H.get_num_legs() >= 2 && !(DIGITIGRADE in species_traits))
		var/datum/sprite_accessory/socks/U3 = socks_list[H.socks]
		if(U3)
			standing	+= image("icon"=U3.icon, "icon_state"="[U3.icon_state]_s", "layer"=-BODY_LAYER)

	if(standing.len)
		H.overlays_standing[BODY_LAYER] = standing

	H.apply_overlay(BODY_LAYER)
	handle_mutant_bodyparts(H)

/datum/species/proc/handle_mutant_bodyparts(mob/living/carbon/human/H, forced_colour)
	var/list/bodyparts_to_add = mutant_bodyparts.Copy()
	var/list/relevent_layers = list(BODY_BEHIND_LAYER, BODY_ADJ_LAYER, BODY_FRONT_LAYER)
	var/list/standing	= list()

	H.remove_overlay(BODY_BEHIND_LAYER)
	H.remove_overlay(BODY_ADJ_LAYER)
	H.remove_overlay(BODY_FRONT_LAYER)

	if(!mutant_bodyparts)
		return

	var/obj/item/bodypart/head/HD = H.get_bodypart("head")

	if("tail_lizard" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "tail_lizard"

	if("waggingtail_lizard" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "waggingtail_lizard"
		else if ("tail_lizard" in mutant_bodyparts)
			bodyparts_to_add -= "waggingtail_lizard"

	if("tail_human" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "tail_human"


	if("waggingtail_human" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "waggingtail_human"
		else if ("tail_human" in mutant_bodyparts)
			bodyparts_to_add -= "waggingtail_human"

	if("spines" in mutant_bodyparts)
		if(!H.dna.features["spines"] || H.dna.features["spines"] == "None" || H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "spines"

	if("waggingspines" in mutant_bodyparts)
		if(!H.dna.features["spines"] || H.dna.features["spines"] == "None" || H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT))
			bodyparts_to_add -= "waggingspines"
		else if ("tail" in mutant_bodyparts)
			bodyparts_to_add -= "waggingspines"

	if("snout" in mutant_bodyparts) //Take a closer look at that snout!
		if((H.wear_mask && (H.wear_mask.flags_inv & HIDEFACE)) || (H.head && (H.head.flags_inv & HIDEFACE)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "snout"

	if("frills" in mutant_bodyparts)
		if(!H.dna.features["frills"] || H.dna.features["frills"] == "None" || H.head && (H.head.flags_inv & HIDEEARS) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "frills"

	if("horns" in mutant_bodyparts)
		if(!H.dna.features["horns"] || H.dna.features["horns"] == "None" || H.head && (H.head.flags_inv & HIDEHAIR) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "horns"

	if("ears" in mutant_bodyparts)
		if(!H.dna.features["ears"] || H.dna.features["ears"] == "None" || H.head && (H.head.flags_inv & HIDEHAIR) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD || HD.status == BODYPART_ROBOTIC)
			bodyparts_to_add -= "ears"

	if("wings" in mutant_bodyparts)
		if(!H.dna.features["wings"] || H.dna.features["wings"] == "None" || (H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT) && (!H.wear_suit.species_exception || !is_type_in_list(src, H.wear_suit.species_exception))))
			bodyparts_to_add -= "wings"

	if("wings_open" in mutant_bodyparts)
		if(H.wear_suit && (H.wear_suit.flags_inv & HIDEJUMPSUIT) && (!H.wear_suit.species_exception || !is_type_in_list(src, H.wear_suit.species_exception)))
			bodyparts_to_add -= "wings_open"
		else if ("wings" in mutant_bodyparts)
			bodyparts_to_add -= "wings_open"

	//Digitigrade legs are stuck in the phantom zone between true limbs and mutant bodyparts. Mainly it just needs more agressive updating than most limbs.
	var/update_needed = FALSE
	var/not_digitigrade = TRUE
	for(var/X in H.bodyparts)
		var/obj/item/bodypart/O = X
		if(!O.use_digitigrade)
			continue
		not_digitigrade = FALSE
		if(!(DIGITIGRADE in species_traits)) //Someone cut off a digitigrade leg and tacked it on
			species_traits += DIGITIGRADE
		var/should_be_squished = FALSE
		if(H.wear_suit && ((H.wear_suit.flags_inv & HIDEJUMPSUIT) || (H.wear_suit.body_parts_covered & LEGS)) || (H.w_uniform && (H.w_uniform.body_parts_covered & LEGS)))
			should_be_squished = TRUE
		if(O.use_digitigrade == FULL_DIGITIGRADE && should_be_squished)
			O.use_digitigrade = SQUISHED_DIGITIGRADE
			update_needed = TRUE
		else if(O.use_digitigrade == SQUISHED_DIGITIGRADE && !should_be_squished)
			O.use_digitigrade = FULL_DIGITIGRADE
			update_needed = TRUE
	if(update_needed)
		H.update_body_parts()
	if(not_digitigrade && (DIGITIGRADE in species_traits)) //Curse is lifted
		species_traits -= DIGITIGRADE

	if(!bodyparts_to_add)
		return

	var/g = (H.gender == FEMALE) ? "f" : "m"

	var/image/I

	for(var/layer in relevent_layers)
		var/layertext = mutant_bodyparts_layertext(layer)

		for(var/bodypart in bodyparts_to_add)
			var/datum/sprite_accessory/S
			switch(bodypart)
				if("tail_lizard")
					S = tails_list_lizard[H.dna.features["tail_lizard"]]
				if("waggingtail_lizard")
					S.= animated_tails_list_lizard[H.dna.features["tail_lizard"]]
				if("tail_human")
					S = tails_list_human[H.dna.features["tail_human"]]
				if("waggingtail_human")
					S.= animated_tails_list_human[H.dna.features["tail_human"]]
				if("spines")
					S = spines_list[H.dna.features["spines"]]
				if("waggingspines")
					S.= animated_spines_list[H.dna.features["spines"]]
				if("snout")
					S = snouts_list[H.dna.features["snout"]]
				if("frills")
					S = frills_list[H.dna.features["frills"]]
				if("horns")
					S = horns_list[H.dna.features["horns"]]
				if("ears")
					S = ears_list[H.dna.features["ears"]]
				if("body_markings")
					S = body_markings_list[H.dna.features["body_markings"]]
				if("wings")
					S = wings_list[H.dna.features["wings"]]
				if("wingsopen")
					S = wings_open_list[H.dna.features["wings"]]
				if("legs")
					S = legs_list[H.dna.features["legs"]]

			if(!S || S.icon_state == "none")
				continue

			//A little rename so we don't have to use tail_lizard or tail_human when naming the sprites.
			if(bodypart == "tail_lizard" || bodypart == "tail_human")
				bodypart = "tail"
			else if(bodypart == "waggingtail_lizard" || bodypart == "waggingtail_human")
				bodypart = "waggingtail"


			var/icon_string

			if(S.gender_specific)
				icon_string = "[g]_[bodypart]_[S.icon_state]_[layertext]"
			else
				icon_string = "m_[bodypart]_[S.icon_state]_[layertext]"

			I = image("icon" = S.icon, "icon_state" = icon_string, "layer" =- layer)

			if(S.center)
				I = center_image(I,S.dimension_x,S.dimension_y)

			if(!(H.disabilities & HUSK))
				if(!forced_colour)
					switch(S.color_src)
						if(MUTCOLORS)
							if(fixed_mut_color)
								I.color = "#[fixed_mut_color]"
							else
								I.color = "#[H.dna.features["mcolor"]]"
						if(HAIR)
							if(hair_color == "mutcolor")
								I.color = "#[H.dna.features["mcolor"]]"
							else
								I.color = "#[H.hair_color]"
						if(FACEHAIR)
							I.color = "#[H.facial_hair_color]"
						if(EYECOLOR)
							I.color = "#[H.eye_color]"
				else
					I.color = forced_colour
			standing += I

			if(S.hasinner)
				if(S.gender_specific)
					icon_string = "[g]_[bodypart]inner_[S.icon_state]_[layertext]"
				else
					icon_string = "m_[bodypart]inner_[S.icon_state]_[layertext]"

				I = image("icon" = S.icon, "icon_state" = icon_string, "layer" =- layer)

				if(S.center)
					I = center_image(I,S.dimension_x,S.dimension_y)

				standing += I

		H.overlays_standing[layer] = standing.Copy()
		standing = list()

	H.apply_overlay(BODY_BEHIND_LAYER)
	H.apply_overlay(BODY_ADJ_LAYER)
	H.apply_overlay(BODY_FRONT_LAYER)


//This exists so sprite accessories can still be per-layer without having to include that layer's
//number in their sprite name, which causes issues when those numbers change.
/datum/species/proc/mutant_bodyparts_layertext(layer)
	switch(layer)
		if(BODY_BEHIND_LAYER)
			return "BEHIND"
		if(BODY_ADJ_LAYER)
			return "ADJ"
		if(BODY_FRONT_LAYER)
			return "FRONT"


/datum/species/proc/spec_life(mob/living/carbon/human/H)
	if(NOBREATH in species_traits)
		H.setOxyLoss(0)
		H.losebreath = 0

		var/takes_crit_damage = (!(NOCRITDAMAGE in species_traits))
		if((H.health < HEALTH_THRESHOLD_CRIT) && takes_crit_damage)
			H.adjustBruteLoss(1)

/datum/species/proc/spec_death(gibbed, mob/living/carbon/human/H)
	return

/datum/species/proc/auto_equip(mob/living/carbon/human/H)
	// handles the equipping of species-specific gear
	return

/datum/species/proc/can_equip(obj/item/I, slot, disable_warning, mob/living/carbon/human/H)
	if(slot in no_equip)
		if(!I.species_exception || !is_type_in_list(src, I.species_exception))
			return 0

	var/num_arms = H.get_num_arms()
	var/num_legs = H.get_num_legs()

	switch(slot)
		if(slot_hands)
			if(H.get_empty_held_indexes())
				return TRUE
			return FALSE
		if(slot_wear_mask)
			if(H.wear_mask)
				return 0
			if( !(I.slot_flags & SLOT_MASK) )
				return 0
			if(!H.get_bodypart("head"))
				return 0
			return 1
		if(slot_neck)
			if(H.wear_neck)
				return 0
			if( !(I.slot_flags & SLOT_NECK) )
				return 0
			return 1
		if(slot_back)
			if(H.back)
				return 0
			if( !(I.slot_flags & SLOT_BACK) )
				return 0
			return 1
		if(slot_wear_suit)
			if(H.wear_suit)
				return 0
			if( !(I.slot_flags & SLOT_OCLOTHING) )
				return 0
			return 1
		if(slot_gloves)
			if(H.gloves)
				return 0
			if( !(I.slot_flags & SLOT_GLOVES) )
				return 0
			if(num_arms < 2)
				return 0
			return 1
		if(slot_shoes)
			if(H.shoes)
				return 0
			if( !(I.slot_flags & SLOT_FEET) )
				return 0
			if(num_legs < 2)
				return 0
			if(DIGITIGRADE in species_traits)
				if(!disable_warning)
					H << "<span class='warning'>The footwear around here isn't compatible with your feet!</span>"
				return 0
			return 1
		if(slot_belt)
			if(H.belt)
				return 0
			if(!H.w_uniform && !nojumpsuit)
				if(!disable_warning)
					H << "<span class='warning'>You need a jumpsuit before you can attach this [I.name]!</span>"
				return 0
			if( !(I.slot_flags & SLOT_BELT) )
				return
			return 1
		if(slot_glasses)
			if(H.glasses)
				return 0
			if( !(I.slot_flags & SLOT_EYES) )
				return 0
			if(!H.get_bodypart("head"))
				return 0
			return 1
		if(slot_head)
			if(H.head)
				return 0
			if( !(I.slot_flags & SLOT_HEAD) )
				return 0
			if(!H.get_bodypart("head"))
				return 0
			return 1
		if(slot_ears)
			if(H.ears)
				return 0
			if( !(I.slot_flags & SLOT_EARS) )
				return 0
			if(!H.get_bodypart("head"))
				return 0
			return 1
		if(slot_w_uniform)
			if(H.w_uniform)
				return 0
			if( !(I.slot_flags & SLOT_ICLOTHING) )
				return 0
			return 1
		if(slot_wear_id)
			if(H.wear_id)
				return 0
			if(!H.w_uniform && !nojumpsuit)
				if(!disable_warning)
					H << "<span class='warning'>You need a jumpsuit before you can attach this [I.name]!</span>"
				return 0
			if( !(I.slot_flags & SLOT_ID) )
				return 0
			return 1
		if(slot_l_store)
			if(I.flags & NODROP) //Pockets aren't visible, so you can't move NODROP items into them.
				return 0
			if(H.l_store)
				return 0
			if(!H.w_uniform && !nojumpsuit)
				if(!disable_warning)
					H << "<span class='warning'>You need a jumpsuit before you can attach this [I.name]!</span>"
				return 0
			if(I.slot_flags & SLOT_DENYPOCKET)
				return
			if( I.w_class <= WEIGHT_CLASS_SMALL || (I.slot_flags & SLOT_POCKET) )
				return 1
		if(slot_r_store)
			if(I.flags & NODROP)
				return 0
			if(H.r_store)
				return 0
			if(!H.w_uniform && !nojumpsuit)
				if(!disable_warning)
					H << "<span class='warning'>You need a jumpsuit before you can attach this [I.name]!</span>"
				return 0
			if(I.slot_flags & SLOT_DENYPOCKET)
				return 0
			if( I.w_class <= WEIGHT_CLASS_SMALL || (I.slot_flags & SLOT_POCKET) )
				return 1
			return 0
		if(slot_s_store)
			if(I.flags & NODROP)
				return 0
			if(H.s_store)
				return 0
			if(!H.wear_suit)
				if(!disable_warning)
					H << "<span class='warning'>You need a suit before you can attach this [I.name]!</span>"
				return 0
			if(!H.wear_suit.allowed)
				if(!disable_warning)
					H << "You somehow have a suit with no defined allowed items for suit storage, stop that."
				return 0
			if(I.w_class > WEIGHT_CLASS_BULKY)
				if(!disable_warning)
					H << "The [I.name] is too big to attach."  //should be src?
				return 0
			if( istype(I, /obj/item/device/pda) || istype(I, /obj/item/weapon/pen) || is_type_in_list(I, H.wear_suit.allowed) )
				return 1
			return 0
		if(slot_handcuffed)
			if(H.handcuffed)
				return 0
			if(!istype(I, /obj/item/weapon/restraints/handcuffs))
				return 0
			if(num_arms < 2)
				return 0
			return 1
		if(slot_legcuffed)
			if(H.legcuffed)
				return 0
			if(!istype(I, /obj/item/weapon/restraints/legcuffs))
				return 0
			if(num_legs < 2)
				return 0
			return 1
		if(slot_in_backpack)
			if(H.back && istype(H.back, /obj/item/weapon/storage))
				var/obj/item/weapon/storage/B = H.back
				if(B.can_be_inserted(I, 1, H))
					return 1
			return 0
	return 0 //Unsupported slot

/datum/species/proc/before_equip_job(datum/job/J, mob/living/carbon/human/H)
	return

/datum/species/proc/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	H.update_mutant_bodyparts()

/datum/species/proc/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == exotic_blood)
		H.blood_volume = min(H.blood_volume + round(chem.volume, 0.1), BLOOD_VOLUME_MAXIMUM)
		H.reagents.remove_reagent(chem.id)
		return 1
	return 0

/datum/species/proc/handle_speech(message, mob/living/carbon/human/H)
	return message

//return a list of spans or an empty list
/datum/species/proc/get_spans()
	return list()

/datum/species/proc/check_weakness(obj/item/weapon, mob/living/attacker)
	return 0

////////
	//LIFE//
	////////

/datum/species/proc/handle_chemicals_in_body(mob/living/carbon/human/H)

	//The fucking FAT mutation is the dumbest shit ever. It makes the code so difficult to work with
	if(H.disabilities & FAT)
		if(H.overeatduration < 100)
			H << "<span class='notice'>You feel fit again!</span>"
			H.disabilities &= ~FAT
			H.update_inv_w_uniform()
			H.update_inv_wear_suit()
	else
		if(H.overeatduration > 500)
			H << "<span class='danger'>You suddenly feel blubbery!</span>"
			H.disabilities |= FAT
			H.update_inv_w_uniform()
			H.update_inv_wear_suit()

	// nutrition decrease and satiety
	if (H.nutrition > 0 && H.stat != DEAD && \
		H.dna && H.dna.species && (!(NOHUNGER in H.dna.species.species_traits)))
		// THEY HUNGER
		var/hunger_rate = HUNGER_FACTOR
		if(H.satiety > 0)
			H.satiety--
		if(H.satiety < 0)
			H.satiety++
			if(prob(round(-H.satiety/40)))
				H.Jitter(5)
			hunger_rate = 3 * HUNGER_FACTOR
		H.nutrition = max(0, H.nutrition - hunger_rate)


	if (H.nutrition > NUTRITION_LEVEL_FULL)
		if(H.overeatduration < 600) //capped so people don't take forever to unfat
			H.overeatduration++
	else
		if(H.overeatduration > 1)
			H.overeatduration -= 2 //doubled the unfat rate

	//metabolism change
	if(H.nutrition > NUTRITION_LEVEL_FAT)
		H.metabolism_efficiency = 1
	else if(H.nutrition > NUTRITION_LEVEL_FED && H.satiety > 80)
		if(H.metabolism_efficiency != 1.25 && (H.dna && H.dna.species && !(NOHUNGER in H.dna.species.species_traits)))
			H << "<span class='notice'>You feel vigorous.</span>"
			H.metabolism_efficiency = 1.25
	else if(H.nutrition < NUTRITION_LEVEL_STARVING + 50)
		if(H.metabolism_efficiency != 0.8)
			H << "<span class='notice'>You feel sluggish.</span>"
		H.metabolism_efficiency = 0.8
	else
		if(H.metabolism_efficiency == 1.25)
			H << "<span class='notice'>You no longer feel vigorous.</span>"
		H.metabolism_efficiency = 1

	switch(H.nutrition)
		if(NUTRITION_LEVEL_FULL to INFINITY)
			H.throw_alert("nutrition", /obj/screen/alert/fat)
		if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FULL)
			H.clear_alert("nutrition")
		if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
			H.throw_alert("nutrition", /obj/screen/alert/hungry)
		else
			H.throw_alert("nutrition", /obj/screen/alert/starving)


/datum/species/proc/update_sight(mob/living/carbon/human/H)
	H.sight = initial(H.sight)
	H.see_in_dark = darksight
	H.see_invisible = invis_sight

	if(H.client.eye != H)
		var/atom/A = H.client.eye
		if(A.update_remote_sight(H)) //returns 1 if we override all other sight updates.
			return

	for(var/obj/item/organ/cyberimp/eyes/E in H.internal_organs)
		H.sight |= E.sight_flags
		if(E.dark_view)
			H.see_in_dark = E.dark_view
		if(E.see_invisible)
			H.see_invisible = min(H.see_invisible, E.see_invisible)

	if(H.glasses)
		var/obj/item/clothing/glasses/G = H.glasses
		H.sight |= G.vision_flags
		H.see_in_dark = max(G.darkness_view, H.see_in_dark)
		if(G.invis_override)
			H.see_invisible = G.invis_override
		else
			H.see_invisible = min(G.invis_view, H.see_invisible)

	for(var/X in H.dna.mutations)
		var/datum/mutation/M = X
		if(M.name == XRAY)
			H.sight |= (SEE_TURFS|SEE_MOBS|SEE_OBJS)
			H.see_in_dark = max(H.see_in_dark, 8)

	if(H.see_override)	//Override all
		H.see_invisible = H.see_override

/datum/species/proc/update_health_hud(mob/living/carbon/human/H)
	return 0

/datum/species/proc/handle_mutations_and_radiation(mob/living/carbon/human/H)

	if(!(RADIMMUNE in species_traits))
		if(H.radiation)
			if (H.radiation > 100)
				if(!H.weakened)
					H.emote("collapse")
				H.Weaken(10)
				H << "<span class='danger'>You feel weak.</span>"
			switch(H.radiation)
				if(50 to 75)
					if(prob(5))
						if(!H.weakened)
							H.emote("collapse")
						H.Weaken(3)
						H << "<span class='danger'>You feel weak.</span>"

					if(prob(15))
						if(!( H.hair_style == "Shaved") || !(H.hair_style == "Bald") || (HAIR in species_traits))
							H << "<span class='danger'>Your hair starts to \
								fall out in clumps...<span>"
							addtimer(src, "go_bald", 50, TIMER_UNIQUE, H)

				if(75 to 100)
					if(prob(1))
						H << "<span class='danger'>You mutate!</span>"
						H.randmutb()
						H.emote("gasp")
						H.domutcheck()
		return 0
	return 1

/datum/species/proc/go_bald(mob/living/carbon/human/H)
	H.facial_hair_style = "Shaved"
	H.hair_style = "Bald"
	H.update_hair()

////////////////
// MOVE SPEED //
////////////////

/datum/species/proc/movement_delay(mob/living/carbon/human/H)
	. = 0	//We start at 0.
	var/flight = 0	//Check for flight and flying items
	var/flightpack = 0
	var/ignoreslow = 0
	var/gravity = 0
	var/obj/item/device/flightpack/F = H.get_flightpack()
	if(istype(F) && F.flight)
		flightpack = 1
	if(H.movement_type & FLYING)
		flight = 1

	if(!flightpack)	//Check for chemicals and innate speedups and slowdowns if we're moving using our body and not a flying suit
		if(H.status_flags & GOTTAGOFAST)
			. -= 1
		if(H.status_flags & GOTTAGOREALLYFAST)
			. -= 2
		. += speedmod

	if(H.status_flags & IGNORESLOWDOWN)
		ignoreslow = 1

	if(H.has_gravity())
		gravity = 1

	if(!gravity)
		var/obj/item/weapon/tank/jetpack/J = H.back
		var/obj/item/clothing/suit/space/hardsuit/C = H.wear_suit
		var/obj/item/organ/cyberimp/chest/thrusters/T = H.getorganslot("thrusters")
		if(!istype(J) && istype(C))
			J = C.jetpack
		if(istype(J) && J.allow_thrust(0.01, H))	//Prevents stacking
			. -= 2
		else if(istype(T) && T.allow_thrust(0.01, H))
			. -= 2
		else if(flightpack && F.allow_thrust(0.01, src))
			. -= 1

	if(flightpack && F.boost)
		. -= F.boost_speed
	else if(flightpack && F.brake)
		. += 2

	if(!ignoreslow && !flightpack && gravity)
		if(H.wear_suit)
			. += H.wear_suit.slowdown
		if(H.shoes)
			. += H.shoes.slowdown
		if(H.back)
			. += H.back.slowdown
		for(var/obj/item/I in H.held_items)
			if(I.flags & HANDSLOW)
				. += I.slowdown
		var/health_deficiency = (100 - H.health + H.staminaloss)
		var/hungry = (500 - H.nutrition) / 5 // So overeat would be 100 and default level would be 80
		if(health_deficiency >= 40)
			if(flight)
				. += (health_deficiency / 75)
			else
				. += (health_deficiency / 25)
		if((hungry >= 70) && !flight)		//Being hungry won't stop you from using flightpack controls/flapping your wings although it probably will in the wing case but who cares.
			. += hungry / 50
		if(H.disabilities & FAT)
			. += (1.5 - flight)
		if(H.bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT)
			. += (BODYTEMP_COLD_DAMAGE_LIMIT - H.bodytemperature) / COLD_SLOWDOWN_FACTOR
	return .

//////////////////
// ATTACK PROCS //
//////////////////

//////////////////
// ATTACK PROCS //
//////////////////

/datum/species/proc/help(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(target.health >= 0 && !(target.status_flags & FAKEDEATH))
		target.help_shake_act(user)
		if(target != user)
			add_logs(user, target, "shaked")
		return 1
	else
		var/we_breathe = (!(NOBREATH in user.dna.species.species_traits))
		var/we_lung = user.getorganslot("lungs")

		if(we_breathe && we_lung)
			user.do_cpr(target)
		else if(we_breathe && !we_lung)
			user << "<span class='warning'>You have no lungs to breathe with, so you cannot peform CPR.</span>"
		else
			user << "<span class='notice'>You do not breathe, so you cannot perform CPR.</span>"

/datum/species/proc/grab(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(target.check_block())
		target.visible_message("<span class='warning'>[target] blocks [user]'s grab attempt!</span>")
		return 0
	if(attacker_style && attacker_style.grab_act(user,target))
		return 1
	else
		target.grabbedby(user)
		return 1





/datum/species/proc/harm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(target.check_block())
		target.visible_message("<span class='warning'>[target] blocks [user]'s attack!</span>")
		return 0
	if(attacker_style && attacker_style.harm_act(user,target))
		return 1
	else

		var/atk_verb = user.dna.species.attack_verb
		if(target.lying)
			atk_verb = "kick"

		switch(atk_verb)
			if("kick")
				user.do_attack_animation(target, ATTACK_EFFECT_KICK)
			if("slash")
				user.do_attack_animation(target, ATTACK_EFFECT_CLAW)
			if("smash")
				user.do_attack_animation(target, ATTACK_EFFECT_SMASH)
			else
				user.do_attack_animation(target, ATTACK_EFFECT_PUNCH)

		var/damage = rand(user.dna.species.punchdamagelow, user.dna.species.punchdamagehigh)

		var/obj/item/bodypart/affecting = target.get_bodypart(ran_zone(user.zone_selected))

		if(!damage || !affecting)
			playsound(target.loc, user.dna.species.miss_sound, 25, 1, -1)
			target.visible_message("<span class='danger'>[user] has attempted to [atk_verb] [target]!</span>",\
			"<span class='userdanger'>[user] has attempted to [atk_verb] [target]!</span>", null, COMBAT_MESSAGE_RANGE)
			return 0


		var/armor_block = target.run_armor_check(affecting, "melee")

		playsound(target.loc, user.dna.species.attack_sound, 25, 1, -1)

		target.visible_message("<span class='danger'>[user] has [atk_verb]ed [target]!</span>", \
					"<span class='userdanger'>[user] has [atk_verb]ed [target]!</span>", null, COMBAT_MESSAGE_RANGE)

		if(user.limb_destroyer)
			target.dismembering_strike(user, affecting.body_zone)
		target.apply_damage(damage, BRUTE, affecting, armor_block)
		add_logs(user, target, "punched")
		if((target.stat != DEAD) && damage >= user.dna.species.punchstunthreshold)
			target.visible_message("<span class='danger'>[user] has weakened [target]!</span>", \
							"<span class='userdanger'>[user] has weakened [target]!</span>")
			target.apply_effect(4, WEAKEN, armor_block)
			target.forcesay(hit_appends)
		else if(target.lying)
			target.forcesay(hit_appends)



/datum/species/proc/disarm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(target.check_block())
		target.visible_message("<span class='warning'>[target] blocks [user]'s disarm attempt!</span>")
		return 0
	if(attacker_style && attacker_style.disarm_act(user,target))
		return 1
	else
		user.do_attack_animation(target, ATTACK_EFFECT_DISARM)
		add_logs(user, target, "disarmed")

		if(target.w_uniform)
			target.w_uniform.add_fingerprint(user)
		var/obj/item/bodypart/affecting = target.get_bodypart(ran_zone(user.zone_selected))
		var/randn = rand(1, 100)
		if(randn <= 25)
			playsound(target, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			target.visible_message("<span class='danger'>[user] has pushed [target]!</span>",
				"<span class='userdanger'>[user] has pushed [target]!</span>", null, COMBAT_MESSAGE_RANGE)
			target.apply_effect(2, WEAKEN, target.run_armor_check(affecting, "melee", "Your armor prevents your fall!", "Your armor softens your fall!"))
			target.forcesay(hit_appends)
			return

		var/talked = 0	// BubbleWrap

		if(randn <= 60)
			//BubbleWrap: Disarming breaks a pull
			if(target.pulling)
				target << "<span class='warning'>[user] has broken [target]'s grip on [target.pulling]!</span>"
				talked = 1
				target.stop_pulling()
			//End BubbleWrap

			if(!talked)	//BubbleWrap
				if(target.drop_item())
					target.visible_message("<span class='danger'>[user] has disarmed [target]!</span>", \
						"<span class='userdanger'>[user] has disarmed [target]!</span>", null, COMBAT_MESSAGE_RANGE)
			playsound(target, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			return


		playsound(target, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
		target.visible_message("<span class='danger'>[user] attempted to disarm [target]!</span>", \
						"<span class='userdanger'>[user] attemped to disarm [target]!</span>", null, COMBAT_MESSAGE_RANGE)



/datum/species/proc/spec_hitby(atom/movable/AM, mob/living/carbon/human/H)
	return

/datum/species/proc/spec_attack_hand(mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style = M.martial_art)
	if(!istype(M))
		return
	CHECK_DNA_AND_SPECIES(M)
	CHECK_DNA_AND_SPECIES(H)

	if(!istype(M)) //sanity check for drones.
		return
	if((M != H) && M.a_intent != INTENT_HELP && H.check_shields(0, M.name, attack_type = UNARMED_ATTACK))
		add_logs(M, H, "attempted to touch")
		H.visible_message("<span class='warning'>[M] attempted to touch [H]!</span>")
		return 0
	switch(M.a_intent)
		if("help")
			help(M, H, attacker_style)

		if("grab")
			grab(M, H, attacker_style)

		if("harm")
			harm(M, H, attacker_style)

		if("disarm")
			disarm(M, H, attacker_style)

/datum/species/proc/spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/carbon/human/H)
	// Allows you to put in item-specific reactions based on species
	if(user != H)
		if(H.check_shields(I.force, "the [I.name]", I, MELEE_ATTACK, I.armour_penetration))
			return 0
	if(H.check_block())
		H.visible_message("<span class='warning'>[H] blocks [I]!</span>")
		return 0

	var/hit_area
	if(!affecting) //Something went wrong. Maybe the limb is missing?
		affecting = H.bodyparts[1]

	hit_area = affecting.name
	var/def_zone = affecting.body_zone

	var/armor_block = H.run_armor_check(affecting, "melee", "<span class='notice'>Your armor has protected your [hit_area].</span>", "<span class='notice'>Your armor has softened a hit to your [hit_area].</span>",I.armour_penetration)
	armor_block = min(90,armor_block) //cap damage reduction at 90%
	var/Iforce = I.force //to avoid runtimes on the forcesay checks at the bottom. Some items might delete themselves if you drop them. (stunning yourself, ninja swords)

	var/weakness = H.check_weakness(I, user)
	apply_damage(I.force * weakness, I.damtype, def_zone, armor_block, H)
	H.damage_clothes(I.force, I.damtype, "melee", affecting.body_zone)

	H.send_item_attack_message(I, user, hit_area)

	if(!I.force)
		return 0 //item force is zero

	//dismemberment
	var/probability = I.get_dismemberment_chance(affecting)
	if(prob(probability) || ((EASYDISMEMBER in species_traits) && prob(2*probability)))
		if(affecting.dismember(I.damtype))
			I.add_mob_blood(H)
			playsound(get_turf(H), I.get_dismember_sound(), 80, 1)

	var/bloody = 0
	if(((I.damtype == BRUTE) && I.force && prob(25 + (I.force * 2))))
		if(affecting.status == BODYPART_ORGANIC)
			I.add_mob_blood(H)	//Make the weapon bloody, not the person.
			if(prob(I.force * 2))	//blood spatter!
				bloody = 1
				var/turf/location = H.loc
				if(istype(location))
					H.add_splatter_floor(location)
				if(get_dist(user, H) <= 1)	//people with TK won't get smeared with blood
					user.add_mob_blood(H)

		switch(hit_area)
			if("head")
				if(H.stat == CONSCIOUS && armor_block < 50)
					if(prob(I.force))
						H.visible_message("<span class='danger'>[H] has been knocked senseless!</span>", \
										"<span class='userdanger'>[H] has been knocked senseless!</span>")
						H.confused = max(H.confused, 20)
						H.adjust_blurriness(10)

					if(prob(I.force + ((100 - H.health)/2)) && H != user)
						ticker.mode.remove_revolutionary(H.mind)

				if(bloody)	//Apply blood
					if(H.wear_mask)
						H.wear_mask.add_mob_blood(H)
						H.update_inv_wear_mask()
					if(H.head)
						H.head.add_mob_blood(H)
						H.update_inv_head()
					if(H.glasses && prob(33))
						H.glasses.add_mob_blood(H)
						H.update_inv_glasses()

			if("chest")
				if(H.stat == CONSCIOUS && armor_block < 50)
					if(prob(I.force))
						H.visible_message("<span class='danger'>[H] has been knocked down!</span>", \
									"<span class='userdanger'>[H] has been knocked down!</span>")
						H.apply_effect(3, WEAKEN, armor_block)

				if(bloody)
					if(H.wear_suit)
						H.wear_suit.add_mob_blood(H)
						H.update_inv_wear_suit()
					if(H.w_uniform)
						H.w_uniform.add_mob_blood(H)
						H.update_inv_w_uniform()

		if(Iforce > 10 || Iforce >= 5 && prob(33))
			H.forcesay(hit_appends)	//forcesay checks stat already.
	return TRUE

/datum/species/proc/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/H)
	var/hit_percent = (100-(blocked+armor))/100
	if(!damage || hit_percent <= 0)
		return 0

	var/obj/item/bodypart/BP = null
	if(islimb(def_zone))
		BP = def_zone
	else
		if(!def_zone)
			def_zone = ran_zone(def_zone)
		BP = H.get_bodypart(check_zone(def_zone))
		if(!BP)
			BP = H.bodyparts[1]

	switch(damagetype)
		if(BRUTE)
			H.damageoverlaytemp = 20
			if(BP)
				if(BP.receive_damage(damage * hit_percent * brutemod, 0))
					H.update_damage_overlays()
			else//no bodypart, we deal damage with a more general method.
				H.adjustBruteLoss(damage * hit_percent * brutemod)
		if(BURN)
			H.damageoverlaytemp = 20
			if(BP)
				if(BP.receive_damage(0, damage * hit_percent * burnmod))
					H.update_damage_overlays()
			else
				H.adjustFireLoss(damage * hit_percent* burnmod)
		if(TOX)
			H.adjustToxLoss(damage * hit_percent)
		if(OXY)
			H.adjustOxyLoss(damage * hit_percent)
		if(CLONE)
			H.adjustCloneLoss(damage * hit_percent)
		if(STAMINA)
			H.adjustStaminaLoss(damage * hit_percent)
	return 1

/datum/species/proc/on_hit(obj/item/projectile/P, mob/living/carbon/human/H)
	// called when hit by a projectile
	switch(P.type)
		if(/obj/item/projectile/energy/floramut) // overwritten by plants/pods
			H.show_message("<span class='notice'>The radiation beam dissipates harmlessly through your body.</span>")
		if(/obj/item/projectile/energy/florayield)
			H.show_message("<span class='notice'>The radiation beam dissipates harmlessly through your body.</span>")
	return

/datum/species/proc/bullet_act(obj/item/projectile/P, mob/living/carbon/human/H)
	// called before a projectile hit
	return 0

/////////////
//BREATHING//
/////////////

/datum/species/proc/breathe(mob/living/carbon/human/H)
	if(NOBREATH in species_traits)
		return TRUE

/datum/species/proc/handle_environment(datum/gas_mixture/environment, mob/living/carbon/human/H)
	if(!environment)
		return
	if(istype(H.loc, /obj/machinery/atmospherics/components/unary/cryo_cell))
		return

	var/loc_temp = H.get_temperature(environment)

	//Body temperature is adjusted in two steps. First, your body tries to stabilize itself a bit.
	if(H.stat != DEAD)
		H.natural_bodytemperature_stabilization()

	//Then, it reacts to the surrounding atmosphere based on your thermal protection
	if(!H.on_fire) //If you're on fire, you do not heat up or cool down based on surrounding gases
		if(loc_temp < H.bodytemperature)
			//Place is colder than we are
			var/thermal_protection = H.get_cold_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 1)
				H.bodytemperature += min((1-thermal_protection) * ((loc_temp - H.bodytemperature) / BODYTEMP_COLD_DIVISOR), BODYTEMP_COOLING_MAX)
		else
			//Place is hotter than we are
			var/thermal_protection = H.get_heat_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 1)
				H.bodytemperature += min((1-thermal_protection) * ((loc_temp - H.bodytemperature) / BODYTEMP_HEAT_DIVISOR), BODYTEMP_HEATING_MAX)

	// +/- 50 degrees from 310.15K is the 'safe' zone, where no damage is dealt.
	if(H.bodytemperature > BODYTEMP_HEAT_DAMAGE_LIMIT && !(RESISTHOT in species_traits))
		//Body temperature is too hot.
		switch(H.bodytemperature)
			if(360 to 400)
				H.throw_alert("temp", /obj/screen/alert/hot, 1)
				H.apply_damage(HEAT_DAMAGE_LEVEL_1*heatmod, BURN)
			if(400 to 460)
				H.throw_alert("temp", /obj/screen/alert/hot, 2)
				H.apply_damage(HEAT_DAMAGE_LEVEL_2*heatmod, BURN)
			if(460 to INFINITY)
				H.throw_alert("temp", /obj/screen/alert/hot, 3)
				if(H.on_fire)
					H.apply_damage(HEAT_DAMAGE_LEVEL_3*heatmod, BURN)
				else
					H.apply_damage(HEAT_DAMAGE_LEVEL_2*heatmod, BURN)
	else if(H.bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT && !(mutations_list[COLDRES] in H.dna.mutations))
		switch(H.bodytemperature)
			if(200 to 260)
				H.throw_alert("temp", /obj/screen/alert/cold, 1)
				H.apply_damage(COLD_DAMAGE_LEVEL_1*coldmod, BURN)
			if(120 to 200)
				H.throw_alert("temp", /obj/screen/alert/cold, 2)
				H.apply_damage(COLD_DAMAGE_LEVEL_2*coldmod, BURN)
			if(-INFINITY to 120)
				H.throw_alert("temp", /obj/screen/alert/cold, 3)
				H.apply_damage(COLD_DAMAGE_LEVEL_3*coldmod, BURN)
			else
				H.clear_alert("temp")

	else
		H.clear_alert("temp")

	// Account for massive pressure differences.  Done by Polymorph
	// Made it possible to actually have something that can protect against high pressure... Done by Errorage. Polymorph now has an axe sticking from his head for his previous hardcoded nonsense!

	var/pressure = environment.return_pressure()
	var/adjusted_pressure = H.calculate_affecting_pressure(pressure) //Returns how much pressure actually affects the mob.
	switch(adjusted_pressure)
		if(HAZARD_HIGH_PRESSURE to INFINITY)
			if(!(RESISTPRESSURE in species_traits))
				H.adjustBruteLoss( min( ( (adjusted_pressure / HAZARD_HIGH_PRESSURE) -1 )*PRESSURE_DAMAGE_COEFFICIENT , MAX_HIGH_PRESSURE_DAMAGE) )
				H.throw_alert("pressure", /obj/screen/alert/highpressure, 2)
			else
				H.clear_alert("pressure")
		if(WARNING_HIGH_PRESSURE to HAZARD_HIGH_PRESSURE)
			H.throw_alert("pressure", /obj/screen/alert/highpressure, 1)
		if(WARNING_LOW_PRESSURE to WARNING_HIGH_PRESSURE)
			H.clear_alert("pressure")
		if(HAZARD_LOW_PRESSURE to WARNING_LOW_PRESSURE)
			H.throw_alert("pressure", /obj/screen/alert/lowpressure, 1)
		else
			if(H.dna.check_mutation(COLDRES) || (RESISTPRESSURE in species_traits))
				H.clear_alert("pressure")
			else
				H.adjustBruteLoss( LOW_PRESSURE_DAMAGE )
				H.throw_alert("pressure", /obj/screen/alert/lowpressure, 2)

//////////
// FIRE //
//////////

/datum/species/proc/handle_fire(mob/living/carbon/human/H)
	if(NOFIRE in species_traits)
		return 1

/datum/species/proc/CanIgniteMob(mob/living/carbon/human/H)
	if(NOFIRE in species_traits)
		return FALSE
	return TRUE

/datum/species/proc/ExtinguishMob(mob/living/carbon/human/H)
	return


////////
//Stun//
////////

/datum/species/proc/spec_stun(mob/living/carbon/human/H,amount)
	. = stunmod * amount

//////////////
//Space Move//
//////////////

/datum/species/proc/space_move(mob/living/carbon/human/H)
	return 0

/datum/species/proc/negates_gravity(mob/living/carbon/human/H)
	return 0


#undef HEAT_DAMAGE_LEVEL_1
#undef HEAT_DAMAGE_LEVEL_2
#undef HEAT_DAMAGE_LEVEL_3

#undef COLD_DAMAGE_LEVEL_1
#undef COLD_DAMAGE_LEVEL_2
#undef COLD_DAMAGE_LEVEL_3
