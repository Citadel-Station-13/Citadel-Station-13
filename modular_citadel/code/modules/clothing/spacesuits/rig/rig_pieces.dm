/*
 * Defines the helmets, gloves and shoes for rigs.
 */

/obj/item/clothing/head/helmet/space/rig
	name = "helmet"
	item_flags = STOPSPRESSUREDMAGE_1|FIRE_PROOF|THICKMATERIAL_1
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	body_parts_covered = HEAD
	heat_protection = HEAD
	cold_protection = HEAD
	var/brightness_on = 4
/*	sprite_sheets = list(
		"Tajara" = 'icons/mob/species/tajaran/helmet.dmi',
		"Skrell" = 'icons/mob/species/skrell/helmet.dmi',
		"Unathi" = 'icons/mob/species/unathi/helmet.dmi',
		"Vox" = 'icons/mob/species/vox/head.dmi'
		)
	species_restricted = null*/

/obj/item/clothing/gloves/gauntlets/rig
	name = "gauntlets"
	item_flags = FIRE_PROOF|THICKMATERIAL_1
	body_parts_covered = HANDS
	heat_protection = HANDS
	cold_protection = HANDS
	//species_restricted = null
	gender = PLURAL

/obj/item/clothing/shoes/magboots/rig
	name = "boots"
	body_parts_covered = FEET
	cold_protection = FEET
	heat_protection = FEET
	//species_restricted = null
	gender = PLURAL
	icon_base = null
	item_flags = FIRE_PROOF

/obj/item/clothing/suit/space/rig
	name = "chestpiece"
	allowed = list(/obj/item/device/flashlight,/obj/item/tank/internals/*,/obj/item/device/suit_cooling_unit*/)
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	heat_protection = slot_wear_suit
	cold_protection = slot_wear_suit
	flags_inv = HIDEJUMPSUIT
	item_flags = STOPSPRESSUREDMAGE_1|FIRE_PROOF|THICKMATERIAL_1
	slowdown = 0
	//supporting_limbs = list()
	var/obj/item/weapon/material/knife/tacknife

/* /obj/item/clothing/suit/space/rig/attack_hand(var/mob/living/M)
	if(tacknife)
		tacknife.loc = get_turf(src)
		if(M.put_in_active_hand(tacknife))
			M << "<span class='notice'>You slide \the [tacknife] out of [src].</span>"
			playsound(M, 'sound/weapons/flipblade.ogg', 40, 1)
			tacknife = null
			update_icon()
		return
	..()

/obj/item/clothing/suit/space/rig/attackby(var/obj/item/I, var/mob/living/M)
	if(istype(I, /obj/item/weapon/material/knife/tacknife))
		if(tacknife)
			return
		M.drop_item()
		tacknife = I
		I.loc = src
		M << "<span class='notice'>You slide the [I] into [src].</span>"
		playsound(M, 'sound/weapons/flipblade.ogg', 40, 1)
		update_icon()
	..()*/

//TODO: move this to modules
/obj/item/clothing/head/helmet/space/rig/proc/prevent_track()
	return 0

/obj/item/clothing/gloves/gauntlets/rig/Touch(var/atom/A, var/proximity)

	if(!A || !proximity)
		return 0

	var/mob/living/carbon/human/H = loc
	if(!istype(H) || !H.back)
		return 0

	var/obj/item/weapon/rig/suit = H.back
	if(!suit || !istype(suit) || !suit.installed_modules.len)
		return 0

	for(var/obj/item/rig_module/module in suit.installed_modules)
		if(module.active && module.activates_on_touch)
			if(module.engage(A))
				return 1

	return 0

//Rig pieces for non-spacesuit based rigs

/obj/item/clothing/head/lightrig
	name = "mask"
	body_parts_covered = HEAD
	heat_protection = HEAD
	cold_protection = HEAD
	flags_1 = THICKMATERIAL_1

/obj/item/clothing/suit/lightrig
	name = "suit"
	allowed = list(/obj/item/device/flashlight)
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT
	flags_1 = THICKMATERIAL_1

/obj/item/clothing/shoes/lightrig
	name = "boots"
	body_parts_covered = FEET
	cold_protection = FEET
	heat_protection = FEET
	//species_restricted = null
	gender = PLURAL

/obj/item/clothing/gloves/gauntlets/lightrig
	name = "gloves"
	flags_1 = THICKMATERIAL_1
	body_parts_covered = HANDS
	heat_protection =    HANDS
	cold_protection =    HANDS
	//species_restricted = null
	gender = PLURAL
