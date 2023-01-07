/obj/item/clothing/head/helmet/space/mod
	name = "MOD helmet"
	desc = "A helmet for a MODsuit."
	icon = 'icons/obj/clothing/modsuit/mod_clothing.dmi'
	mob_overlay_icon = 'icons/mob/clothing/modsuit/mod_clothing.dmi'
	anthro_mob_worn_overlay = 'icons/mob/clothing/modsuit/mod_clothing_anthro.dmi'
	icon_state = "helmet"
	item_state = "helmet"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, FIRE = 25, ACID = 25, WOUND = 10)
	body_parts_covered = HEAD
	heat_protection = HEAD
	cold_protection = HEAD
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	clothing_flags = THICKMATERIAL
	resistance_flags = NONE
	flash_protect = 0
	clothing_flags = NONE
	flags_inv = HIDEFACIALHAIR
	flags_cover = NONE
	visor_flags = THICKMATERIAL|STOPSPRESSUREDAMAGE
	visor_flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	visor_flags_cover = HEADCOVERSMOUTH|HEADCOVERSEYES
	var/alternate_layer = NECK_LAYER
	var/obj/item/mod/control/mod
	mutantrace_variation = STYLE_MUZZLE

/obj/item/clothing/head/helmet/space/mod/Destroy()
	if(!QDELETED(mod))
		mod.helmet = null
		mod.mod_parts -= src
		QDEL_NULL(mod)
	return ..()

/obj/item/clothing/suit/space/mod
	name = "MOD chestplate"
	desc = "A chestplate for a MODsuit."
	icon = 'icons/obj/clothing/modsuit/mod_clothing.dmi'
	mob_overlay_icon = 'icons/mob/clothing/modsuit/mod_clothing.dmi'
	anthro_mob_worn_overlay = 'icons/mob/clothing/modsuit/mod_clothing_anthro.dmi'
	icon_state = "chestplate"
	item_state = "chestplate"
	blood_overlay_type = "armor"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, FIRE = 25, ACID = 25, WOUND = 10)
	body_parts_covered = CHEST|GROIN
	heat_protection = CHEST|GROIN
	cold_protection = CHEST|GROIN
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	clothing_flags = THICKMATERIAL
	flags_inv = HIDETAUR
	visor_flags = STOPSPRESSUREDAMAGE
	visor_flags_inv = HIDEJUMPSUIT
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals)
	resistance_flags = NONE
	var/obj/item/mod/control/mod
	mutantrace_variation = STYLE_DIGITIGRADE

/obj/item/clothing/suit/space/mod/Destroy()
	if(!QDELETED(mod))
		mod.chestplate = null
		mod.mod_parts -= src
		QDEL_NULL(mod)
	return ..()

/obj/item/clothing/gloves/mod
	name = "MOD gauntlets"
	desc = "A pair of gauntlets for a MODsuit."
	icon = 'icons/obj/clothing/modsuit/mod_clothing.dmi'
	mob_overlay_icon = 'icons/mob/clothing/modsuit/mod_clothing.dmi'
	icon_state = "gauntlets"
	item_state = "gauntlets"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, FIRE = 25, ACID = 25, WOUND = 10)
	body_parts_covered = HANDS|ARMS
	heat_protection = HANDS|ARMS
	cold_protection = HANDS|ARMS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	clothing_flags = THICKMATERIAL
	resistance_flags = NONE
	var/obj/item/mod/control/mod
	var/obj/item/clothing/overslot
	mutantrace_variation = STYLE_NO_ANTHRO_ICON

/obj/item/clothing/gloves/mod/Destroy()
	if(!QDELETED(mod))
		mod.gauntlets = null
		mod.mod_parts -= src
		QDEL_NULL(mod)
	return ..()

/// Replaces these gloves on the wearer with the overslot ones

/obj/item/clothing/gloves/mod/proc/show_overslot()
	if(!overslot)
		return
	if(!mod.wearer.equip_to_slot_if_possible(overslot, overslot.slot_flags, qdel_on_fail = FALSE, disable_warning = TRUE))
		mod.wearer.dropItemToGround(overslot, force = TRUE)
	overslot = null

/obj/item/clothing/shoes/mod
	name = "MOD boots"
	desc = "A pair of boots for a MODsuit."
	icon = 'icons/obj/clothing/modsuit/mod_clothing.dmi'
	mob_overlay_icon = 'icons/mob/clothing/modsuit/mod_clothing.dmi'
	anthro_mob_worn_overlay = 'icons/mob/clothing/modsuit/mod_clothing_anthro.dmi'
	icon_state = "boots"
	item_state = "boots"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, FIRE = 25, ACID = 25, WOUND = 10)
	body_parts_covered = FEET|LEGS
	heat_protection = FEET|LEGS
	cold_protection = FEET|LEGS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	clothing_flags = THICKMATERIAL
	resistance_flags = NONE
	item_flags = NONE
	var/obj/item/mod/control/mod
	var/obj/item/clothing/overslot
	mutantrace_variation = STYLE_DIGITIGRADE

/obj/item/clothing/shoes/mod/Destroy()
	if(!QDELETED(mod))
		mod.boots = null
		mod.mod_parts -= src
		QDEL_NULL(mod)
	return ..()

/// Replaces these shoes on the wearer with the overslot ones
/obj/item/clothing/shoes/mod/proc/show_overslot()
	if(!overslot)
		return
	if(!mod.wearer.equip_to_slot_if_possible(overslot, overslot.slot_flags, qdel_on_fail = FALSE, disable_warning = TRUE))
		mod.wearer.dropItemToGround(overslot, force = TRUE)
	overslot = null

/obj/item/clothing/shoes/mod/negates_gravity()
	return clothing_flags & NOSLIP
