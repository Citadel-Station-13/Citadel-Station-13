/obj/item/bodypart/head
	name = "head"
	desc = "Didn't make sense not to live for fun, your brain gets smart but your head gets dumb."
	icon = 'icons/mob/human_parts.dmi'
	icon_state = "default_human_head"
	max_damage = 200
	body_zone = "head"
	body_part = HEAD
	w_class = WEIGHT_CLASS_BULKY //Quite a hefty load
	slowdown = 1 //Balancing measure
	throw_range = 2 //No head bowling
	px_x = 0
	px_y = -8

	var/mob/living/brain/brainmob = null //The current occupant.
	var/obj/item/organ/brain/brain = null //The brain organ

	//Limb appearance info:
	var/real_name = "" //Replacement name
	//Hair colour and style
	var/hair_color = "000"
	var/hair_style = "Bald"
	var/hair_alpha = 255
	//Facial hair colour and style
	var/facial_hair_color = "000"
	var/facial_hair_style = "Shaved"
	//Eye Colouring
	var/eyes = "eyes"
	var/eye_color = ""
	var/lip_style = null
	var/lip_color = "white"

/obj/item/bodypart/head/drop_organs(mob/user)
	var/turf/T = get_turf(src)
	if(status != BODYPART_ROBOTIC)
		playsound(T, 'sound/misc/splort.ogg', 50, 1, -1)
	for(var/obj/item/I in src)
		if(I == brain)
			if(user)
				user.visible_message("<span class='warning'>[user] saws [src] open and pulls out a brain!</span>", "<span class='notice'>You saw [src] open and pull out a brain.</span>")
			if(brainmob)
				brainmob.container = null
				brainmob.loc = brain
				brain.brainmob = brainmob
				brainmob = null
			brain.loc = T
			brain = null
			update_icon_dropped()
		else
			I.loc = T

/obj/item/bodypart/head/update_limb(dropping_limb, mob/living/carbon/source)
	var/mob/living/carbon/C
	if(source)
		C = source
	else
		C = owner

	real_name = C.real_name
	if(C.disabilities & HUSK)
		real_name = "Unknown"
		hair_style = "Bald"
		facial_hair_style = "Shaved"
		eyes = "eyes"
		eye_color = ""
		lip_style = null

	else if(!animal_origin)
		var/mob/living/carbon/human/H = C
		var/datum/species/S = H.dna.species

		//Facial hair
		if(H.facial_hair_style && (FACEHAIR in S.species_traits))
			facial_hair_style = H.facial_hair_style
			if(S.hair_color)
				if(S.hair_color == "mutcolor")
					facial_hair_color = H.dna.features["mcolor"]
				else
					facial_hair_color = S.hair_color
			else
				facial_hair_color = H.facial_hair_color
			hair_alpha = S.hair_alpha
		else
			facial_hair_style = "Shaved"
			facial_hair_color = "000"
			hair_alpha = 255
		//Hair
		if(H.hair_style && (HAIR in S.species_traits))
			hair_style = H.hair_style
			if(S.hair_color)
				if(S.hair_color == "mutcolor")
					hair_color = H.dna.features["mcolor"]
				else
					hair_color = S.hair_color
			else
				hair_color = H.hair_color
			hair_alpha = S.hair_alpha
		else
			hair_style = "Bald"
			hair_color = "000"
			hair_alpha = initial(hair_alpha)
		// lipstick
		if(H.lip_style && (LIPS in S.species_traits))
			lip_style = H.lip_style
			lip_color = H.lip_color
		else
			lip_style = null
			lip_color = "white"
		// eyes
		if(EYECOLOR in S.species_traits)
			eyes = S.eyes
			eye_color = H.eye_color
		else
			eyes = "eyes"
			eye_color = ""

	..()

/obj/item/bodypart/head/update_icon_dropped()
	var/list/standing = get_limb_icon(1)
	if(!standing.len)
		icon_state = initial(icon_state)//no overlays found, we default back to initial icon.
		return
	for(var/image/I in standing)
		I.pixel_x = px_x
		I.pixel_y = px_y
	add_overlay(standing)

/obj/item/bodypart/head/get_limb_icon(dropped)
	cut_overlays()
	var/list/standing = ..()
	if(dropped) //certain overlays only appear when the limb is being detached from its owner.
		var/datum/sprite_accessory/S

		if(status != BODYPART_ROBOTIC) //having a robotic head hides certain features.
			//facial hair
			if(facial_hair_style)
				S = facial_hair_styles_list[facial_hair_style]
				if(S)
					var/image/img_facial_s = image("icon" = S.icon, "icon_state" = "[S.icon_state]_s", "layer" = -HAIR_LAYER, "dir"=SOUTH)
					img_facial_s.color = "#" + facial_hair_color
					img_facial_s.alpha = hair_alpha
					standing += img_facial_s

			//Applies the debrained overlay if there is no brain
			if(!brain)
				if(animal_origin == ALIEN_BODYPART)
					standing += image("icon"='icons/mob/animal_parts.dmi', "icon_state" = "debrained_alien_s", "layer" = -HAIR_LAYER, "dir"=SOUTH)
				else if(animal_origin == LARVA_BODYPART)
					standing += image("icon"='icons/mob/animal_parts.dmi', "icon_state" = "debrained_larva_s", "layer" = -HAIR_LAYER, "dir"=SOUTH)
				else if(!(NOBLOOD in species_flags_list))
					standing += image("icon"='icons/mob/human_face.dmi', "icon_state" = "debrained_s", "layer" = -HAIR_LAYER, "dir"=SOUTH)
			else
				if(hair_style)
					S = hair_styles_list[hair_style]
					if(S)
						var/image/img_hair_s = image("icon" = S.icon, "icon_state" = "[S.icon_state]_s", "layer" = -HAIR_LAYER, "dir"=SOUTH)
						img_hair_s.color = "#" + hair_color
						img_hair_s.alpha = hair_alpha
						standing += img_hair_s


		// lipstick
		if(lip_style)
			var/image/lips = image("icon"='icons/mob/human_face.dmi', "icon_state"="lips_[lip_style]_s", "layer" = -BODY_LAYER, "dir"=SOUTH)
			lips.color = lip_color
			standing += lips

		// eyes
		if(eye_color)
			var/image/img_eyes_s = image("icon" = 'icons/mob/human_face.dmi', "icon_state" = "[eyes]_s", "layer" = -BODY_LAYER, "dir"=SOUTH)
			img_eyes_s.color = "#" + eye_color
			standing += img_eyes_s

	return standing

/obj/item/bodypart/head/monkey
	icon = 'icons/mob/animal_parts.dmi'
	icon_state = "default_monkey_head"
	animal_origin = MONKEY_BODYPART

/obj/item/bodypart/head/alien
	icon = 'icons/mob/animal_parts.dmi'
	icon_state = "alien_head_s"
	px_x = 0
	px_y = 0
	dismemberable = 0
	max_damage = 500
	animal_origin = ALIEN_BODYPART

/obj/item/bodypart/head/devil
	dismemberable = 0
	max_damage = 5000
	animal_origin = DEVIL_BODYPART

/obj/item/bodypart/head/larva
	icon = 'icons/mob/animal_parts.dmi'
	icon_state = "larva_head_s"
	px_x = 0
	px_y = 0
	dismemberable = 0
	max_damage = 50
	animal_origin = LARVA_BODYPART
