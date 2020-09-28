//check saymode.dm for message handling
/obj/item/organ/controller
	name = "system controller"
	desc = "A fist-sized lump of complex circuitry."
	icon = 'icons/obj/ascent/ascent_organs.dmi'
	icon_state = "controller"
	zone = BODY_ZONE_CHEST
	slot = "controller"

/mob/living/proc/controller_talk(message, shown_name = real_name)
	src.log_talk(message, LOG_SAY)
	message = trim(message)
	if(!message)
		return

	var/message_a = say_quote(message)
	var/rendered = "<i>Worldnet, <span class='name'>[shown_name]</span> <span class='message'>[message_a]</span></i>"
	for(var/mob/S in GLOB.player_list)
		if(!S.stat && S.controllercheck())
			to_chat(S, rendered)
		if(S in GLOB.dead_mob_list)
			var/link = FOLLOW_LINK(S, src)
			to_chat(S, "[link] [rendered]")

/mob/living/carbon/controllercheck()
	var/obj/item/organ/controller/A = getorgan(/obj/item/organ/controller)
	if(A)
		return A

/obj/item/organ/brain/kharmaani
	name = "ganglial junction"
	icon = 'icons/obj/ascent/ascent_organs.dmi'
	icon_state = "brain-k"

/obj/item/organ/eyes/kharmaani
	name = "compound ocelli"
	icon = 'icons/obj/ascent/ascent_organs.dmi'
	icon_state = "kharmaani_eyes"
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	flash_protect = -2
	see_in_dark = 8

/obj/item/organ/heart/kharmaani
	name = "hemolymph pump"
	icon = 'icons/obj/ascent/ascent_organs.dmi'
	icon_state = "heart-kharmaani-on"
	maxHealth = 1.1 * STANDARD_ORGAN_THRESHOLD

/obj/item/organ/liver/kharmaani
	name = "primary filters"
	icon = 'icons/obj/ascent/ascent_organs.dmi'
	icon_state = "liver-k"
	maxHealth = 1.1 * STANDARD_ORGAN_THRESHOLD
	toxTolerance = 5
	toxLethality = 0.008

/obj/item/organ/lungs/kharmaani
	name = "spiracle junction"
	icon = 'icons/obj/ascent/ascent_organs.dmi'
	icon_state = "lungs-k"
	safe_oxygen_min = 0
	safe_oxygen_max = 0
	safe_ch3br_min = 13
	safe_ch3br_max = 50

	maxHealth = 400

/obj/item/organ/stomach/kharmaani
	name = "digestive sac"
	icon = 'icons/obj/ascent/ascent_organs.dmi'
	icon_state = "stomach-k"


/obj/item/organ/tongue/kharmaani
	name = "kharmaani mouthparts"
	desc = "A complex collection of insectoid mouthparts."
	icon = 'icons/obj/ascent/ascent_organs.dmi'
	icon_state = "tonguexeno" //TODO: MANDIBLE SPRITE
	say_mod = "clicks"
	attack_verb = list("bit", "pinced", "chewed")
	taste_sensitivity = 10 //Not a tongue but they still taste in other ways
	maxHealth = 80 //Robust exoskeleton
	var/static/list/languages_possible_kharmaani = typecacheof(list(
		/datum/language/ascent_voc,
		/datum/language/xenocommon,
		/datum/language/common,
		/datum/language/codespeak,
		/datum/language/slime,
		/datum/language/draconic,
		/datum/language/voltaic,
		/datum/language/ratvar,
		/datum/language/narsie))

/obj/item/organ/tongue/kharmaani/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_kharmaani