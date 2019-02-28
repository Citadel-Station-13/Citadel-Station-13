/*/////////////////////////////////////////////////////////////////////////////////
///////																		///////
///////			Cit's exclusive suits, armor, etc. go here			///////
///////																		///////
*//////////////////////////////////////////////////////////////////////////////////


/obj/item/clothing/suit/armor/hos/trenchcoat/cloak
	name = "armored trenchcloak"
	desc = "A trenchcoat enchanced with a special lightweight kevlar. This one appears to be designed to be draped over one's shoulders rather than worn normally.."
	alternate_worn_icon = 'modular_citadel/icons/mob/citadel/suit.dmi'
	icon_state = "hostrench"
	item_state = "hostrench"
	mutantrace_variation = NO_MUTANTRACE_VARIATION

/obj/item/clothing/suit/hooded/cloak/david
	name = "red cloak"
	icon_state = "goliath_cloak"
	desc = "Ever wanted to look like a badass without ANY effort? Try this nanotrasen brand red cloak, perfect for kids"
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/david
	body_parts_covered = CHEST|GROIN|ARMS
	mutantrace_variation = NO_MUTANTRACE_VARIATION

/obj/item/clothing/head/hooded/cloakhood/david
	name = "red cloak hood"
	icon_state = "golhood"
	desc = "conceal your face in shame with this nanotrasen brand hood"
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR
	mutantrace_variation = NO_MUTANTRACE_VARIATION

/obj/item/clothing/suit/flakjack
	name = "flak jacket"
	desc = "A dilapidated jacket made of a supposedly bullet-proof material (Hint: It isn't.). Smells faintly of napalm."
	icon = 'modular_citadel/icons/obj/clothing/space_nam.dmi'
	alternate_worn_icon = 'modular_citadel/icons/mob/clothing/space_nam.dmi'
	icon_state = "flakjack"
	item_state = "redtag"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST
	resistance_flags = NONE
	mutantrace_variation = NO_MUTANTRACE_VARIATION
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 5, "bio" = 0, "rad" = 0, "fire" = -5, "acid" = -15) //nylon sucks against acid

/obj/item/clothing/suit/sneaking
	name = "sneaking suit"
	desc = "Kept you waiting, huh?"
	icon = 'icons/mob/suit.dmi'
	icon_state = "sneaking_suit"
	item_state = "sneaking_suit"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	strip_delay = 80
	equip_delay_other = 120
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	clothing_flags = THICKMATERIAL
	armor = list("melee" = 60, "bullet" = 30, "laser" = -5, "energy" = -5, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 20, "acid" = -5)

/obj/item/clothing/suit/classic_wintercoat
	name = "classic wintercoat"
	desc = ""
	icon = 'icons/mob/suit.dmi'
	icon_state = "classic_wintersuit"
	item_state = "classic_wintersuit"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|HANDS
	cold_protection = CHEST|GROIN|LEGS|ARMS|HANDS
	clothing_flags = THICKMATERIAL
	resistance_flags = FLAMMABLE
	armor = list("melee" = 5, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = -5, "acid" = 0)

/obj/item/clothing/suit/jotaro_jacket
	name = "Jotaro's jacket"
	desc = ""
	icon = 'icons/mob/suit.dmi'
	icon_state = "jotaro_jacket"
	item_state = "jotaro_jacket"
	body_parts_covered = GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	clothing_flags = THICKMATERIAL
	resistance_flags = FLAMMABLE
	armor = list("melee" = 50, "bullet" = 10, "laser" = 5, "energy" = 5, "bomb" = 10, "bio" = 5, "rad" = 5, "fire" = 5, "acid" = 5)