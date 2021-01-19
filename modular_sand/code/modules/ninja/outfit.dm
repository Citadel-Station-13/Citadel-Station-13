/datum/outfit/ninja/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE, client/preference_source)
	if(istype(H.wear_suit, suit))
		var/obj/item/clothing/suit/space/space_ninja/S = H.wear_suit
		if(istype(H.belt, belt))
			S.energyKatana = H.belt
		S.randomize_param()
	H.grant_language(/datum/language/modular_sand/neokanji, TRUE, TRUE, LANGUAGE_NINJA)
	var/datum/language_holder/LH = H.get_language_holder()
	LH.selected_language = /datum/language/modular_sand/neokanji
