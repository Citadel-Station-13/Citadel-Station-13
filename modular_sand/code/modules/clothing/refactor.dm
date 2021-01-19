/obj/item/clothing/suit/armor/vest/warden
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_ALL_TAURIC
	taur_mob_worn_overlay = 'modular_sand/icons/mob/suits_taur.dmi'

/obj/item/clothing/suit/hooded/techpriest
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_ALL_TAURIC
	taur_mob_worn_overlay = 'modular_sand/icons/mob/suits_taur.dmi'

/obj/item/clothing/suit/hooded/techpriest_t
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_ALL_TAURIC
	taur_mob_worn_overlay = 'modular_sand/icons/mob/suits_taur.dmi'

/obj/item/clothing/shoes/jackboots/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, list('modular_sand/sound/effects/jackboot1.ogg'=1, 'modular_sand/sound/effects/jackboot2.ogg'=1), 50)

/obj/item/clothing/shoes/jackboots/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_SHOES)
		ADD_TRAIT(user, TRAIT_SILENT_STEP, SHOES_TRAIT)

/obj/item/clothing/shoes/jackboots/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_SILENT_STEP, SHOES_TRAIT)

/obj/item/clothing/shoes/combat/Initialize()
	. = ..()
	var/obj/item/clothing/shoes/combat/sneakboots/B = src
	if(istype(B))
		return
	AddComponent(/datum/component/squeak, list('modular_sand/sound/effects/jackboot1.ogg'=1, 'modular_sand/sound/effects/jackboot2.ogg'=1), 50)

/obj/item/clothing/shoes/combat/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_SHOES)
		ADD_TRAIT(user, TRAIT_SILENT_STEP, SHOES_TRAIT)

/obj/item/clothing/shoes/combat/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_SILENT_STEP, SHOES_TRAIT)
