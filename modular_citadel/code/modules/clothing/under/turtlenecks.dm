/*
 *	Turtlenecks in general go here!
 */

//CMO's Turtleneck, because they don't have any unique clothes!

/obj/item/clothing/under/rank/chief_medical_officer/turtleneck
	desc = "It's a turtleneck worn by those with the experience to be \"Chief Medical Officer\". It provides minor biological protection, for an officer with a superior sense of style and practicality."
	name = "chief medical officer's turtleneck"
	alternate_worn_icon = 'modular_citadel/icons/mob/clothing/turtlenecks.dmi'
	icon = 'modular_citadel/icons/obj/clothing/turtlenecks.dmi'
	icon_state = "cmoturtle"
	item_state = "w_suit"
	item_color = "cmoturtle"
	permeability_coefficient = 0.5
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0, fire = 0, acid = 0)
	can_adjust = TRUE
	alt_covers_chest = TRUE

/obj/structure/closet/secure_closet/CMO/PopulateContents()	//This is placed here because it's a very specific addition for a very specific niche
	..()
	new /obj/item/clothing/under/rank/chief_medical_officer/turtleneck(src)