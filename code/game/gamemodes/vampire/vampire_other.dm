/*
	In this file:
		various vampire interactions and items
*/


/obj/item/clothing/suit/dracula/vamp_coat
	name = "vampire Coat"
	desc = "What is a man? A miserable little pile of secrets."
	alternate_worn_icon = 'icons/mob/suit.dmi'
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "draculacoat"
	item_state = "draculacoat"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	armor = list("melee" = 50, "bullet" = 40, "laser" = 30, "energy" = 40, "bomb" = 100, "bio" = 0, "rad" = 0) //Hey, if we are going totally ditch our disguise, why not have decent armor, and not get cheesed by explosions?
	//todo, give it a hood or something and make it more special.
