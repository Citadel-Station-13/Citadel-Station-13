/obj/item/clothing/under/ascent
	name = "mantid undersuit"
	desc = "A ribbed, spongy undersuit of some sort. It has a big sleeve for a tail, so it probably isn't for humans."
	icon = 'icons/obj/ascent/ascent_clothing.dmi'
	mob_overlay_icon = 'icons/mob/ascent/alate_clothing.dmi'
	icon_state = "ascent_undersuit"
	species_restricted = list("Kharmaani Alate")

/obj/item/clothing/shoes/magboots/ascent
	name = "ascent magclaws"
	desc = "A pair of advanced lightweight magnetic claws of ascent design."
	icon = 'icons/obj/ascent/ascent_clothing.dmi'
	mob_overlay_icon = 'icons/mob/ascent/alate_clothing.dmi'
	icon_state = "ascent_magboots0"
	magboot_state = "ascent_magboots"
	slowdown_active = 0
	species_restricted = list("Kharmaani Alate")

/obj/item/clothing/mask/gas/ascent
	name = "mantid facemask"
	desc = "An alien facemask with chunky gas filters and a breathing valve."
	icon = 'icons/obj/ascent/ascent_clothing.dmi'
	mob_overlay_icon = 'icons/mob/ascent/alate_clothing.dmi'
	icon_state = "ascent_mask"
	item_state = "ascent_mask"
	w_class = WEIGHT_CLASS_SMALL
	flags_inv = HIDEFACIALHAIR|HIDEFACE
	flags_cover = MASKCOVERSMOUTH
	species_restricted = list("Kharmaani Alate")

/obj/item/clothing/head/helmet/space/hardsuit/ascent
	name = "ascent exohelmet"
	icon = 'icons/obj/ascent/ascent_clothing.dmi'
	mob_overlay_icon = 'icons/mob/ascent/alate_clothing.dmi'
	icon_state = "hardsuit0-ascent"
	item_state = "hardsuit0-ascent"
	hardsuit_type = "ascent"
	armor = list("melee" = 50, "bullet" = 25, "laser" = 30, "energy" = 30, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100, "wound" = 15)
	resistance_flags = ACID_PROOF | FIRE_PROOF
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT

/obj/item/clothing/head/helmet/space/hardsuit/ascent/attack_self()
	return //Preferably toggleable thermals

/obj/item/clothing/suit/space/hardsuit/ascent
	name = "ascent exosuit"
	desc = "an exosuit of ascent design that protects against nearly every hazardous environment that can be encountered in space."
	icon = 'icons/obj/ascent/ascent_clothing.dmi'
	mob_overlay_icon = 'icons/mob/ascent/alate_clothing.dmi'
	icon_state = "hardsuit-ascent"
	item_state = "hardsuit-ascent"
	slowdown = 0
	armor = list("melee" = 50, "bullet" = 25, "laser" = 30, "energy" = 30, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100, "wound" = 15)
	resistance_flags = ACID_PROOF | FIRE_PROOF
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/ascent
	jetpack = /obj/item/tank/jetpack/suit
	species_restricted = list("Kharmaani Alate")
