/obj/item/clothing/head/goatpelt
	name = "goat pelt hat"
	desc = "Fuzzy and Warm!"
	icon = 'modular_sand/icons/obj/clothing/hats.dmi'
	icon_state = "goatpelt"
	mob_overlay_icon = 'modular_sand/icons/mob/clothing/head.dmi'
	mutantrace_variation = STYLE_NO_ANTHRO_ICON
	item_state = "goatpelt"

/obj/item/clothing/head/goatpelt/king
	name = "king goat pelt hat"
	desc = "Fuzzy, Warm and Robust!"
	icon_state = "goatpelt"
	item_state = "goatpelt"
	color = "#ffd700"
	body_parts_covered = HEAD
	armor = list("melee" = 60, "bullet" = 55, "laser" = 55, "energy" = 45, "bomb" = 100, "bio" = 20, "rad" = 20, "fire" = 100, "acid" = 100)
	dog_fashion = null
	resistance_flags = FIRE_PROOF

/obj/item/clothing/head/goatpelt/king/equipped(mob/living/carbon/human/user, slot)
	..()
	if (slot == ITEM_SLOT_HEAD)
		user.faction |= "goat"

/obj/item/clothing/head/goatpelt/king/dropped(mob/living/carbon/human/user)
	if (user.head == src)
		user.faction -= "goat"
	..()

/obj/item/clothing/head/goatpope
	name = "goat pope hat"
	desc = "And on the seventh day King Goat said there will be cabbage!"
	mob_overlay_icon = 'modular_sand/icons/mob/large-worn-icons/64x64/head.dmi'
	mutantrace_variation = STYLE_NO_ANTHRO_ICON
	icon = 'modular_sand/icons/obj/clothing/hats.dmi'
	icon_state = "goatpope"
	item_state = "goatpope"
	worn_x_dimension = 64
	worn_y_dimension = 64
	resistance_flags = FLAMMABLE

/obj/item/clothing/head/goatpope/equipped(mob/living/carbon/human/user, slot)
	..()
	if (slot == ITEM_SLOT_HEAD)
		user.faction |= "goat"

/obj/item/clothing/head/goatpope/dropped(mob/living/carbon/human/user, slot)
	if (user.head == src)
		user.faction -= "goat"
	..()
