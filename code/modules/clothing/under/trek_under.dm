/*/////////////////////////////////////////////////////////////////////////////////
///////																		///////
///////								Star Trek Stuffs						///////
///////																		///////
*//////////////////////////////////////////////////////////////////////////////////
//  <3 Nienhaus && Joan.
// I made the Voy and DS9 stuff tho. - Poojy


/obj/item/clothing/under/trek
	name = "\improper Section 31 uniform"
	desc = "Oooh... right."
	item_state = ""
	can_adjust = FALSE	//to prevent you from "wearing it casually"

//TOS
/obj/item/clothing/under/trek/command
	name = "command uniform"
	desc = "The uniform worn by command officers in the mid 2260s."
	icon_state = "trek_command"
	item_state = "trek_command"
	armor = list("melee" = 10, "bullet" = 10, "laser" = 10,"energy" = 10, "bomb" = 0, "bio" = 10, "rad" = 10, "fire" = 0, "acid" = 0) // Considering only staff heads get to pick it

/obj/item/clothing/under/trek/engsec
	name = "operations uniform"
	desc = "The uniform worn by operations officers of the mid 2260s. You feel strangely vulnerable just seeing this..."
	icon_state = "trek_engsec"
	item_state = "trek_engsec"

/obj/item/clothing/under/trek/medsci
	name = "\improper MedSci uniform"
	desc = "The uniform worn by medsci officers in the mid 2260s."
	icon_state = "trek_medsci"
	item_state = "trek_medsci"
	permeability_coefficient = 0.50

//TNG
/obj/item/clothing/under/trek/command/next
	desc = "The uniform worn by command officers. This one's from the mid 2360s."
	icon_state = "trek_next_command"
	item_state = "trek_next_command"

/obj/item/clothing/under/trek/engsec/next
	desc = "The uniform worn by operation officers. This one's from the mid 2360s."
	icon_state = "trek_next_engsec"
	item_state = "trek_next_engsec"

/obj/item/clothing/under/trek/medsci/next
	desc = "The uniform worn by medsci officers. This one's from the mid 2360s."
	icon_state = "trek_next_medsci"
	item_state = "trek_next_medsci"

//ENT
/obj/item/clothing/under/trek/command/ent
	desc = "The uniform worn by command officers of the 2140s."
	icon_state = "trek_ent_command"
	item_state = "trek_ent_command"

/obj/item/clothing/under/trek/engsec/ent
	desc = "The uniform worn by operations officers of the 2140s."
	icon_state = "trek_ent_engsec"
	item_state = "trek_ent_engsec"

/obj/item/clothing/under/trek/medsci/ent
	desc = "The uniform worn by medsci officers of the 2140s."
	icon_state = "trek_ent_medsci"
	item_state = "trek_ent_medsci"

//VOY
/obj/item/clothing/under/trek/command/voy
	desc = "The uniform worn by command officers of the 2370s."
	icon_state = "trek_voy_command"
	item_state = "trek_voy_command"

/obj/item/clothing/under/trek/engsec/voy
	desc = "The uniform worn by operations officers of the 2370s."
	icon_state = "trek_voy_engsec"
	item_state = "trek_voy_engsec"

/obj/item/clothing/under/trek/medsci/voy
	desc = "The uniform worn by medsci officers of the 2370s."
	icon_state = "trek_voy_medsci"
	item_state = "trek_voy_medsci"

//DS9

/obj/item/clothing/under/trek/command/ds9
	desc = "The uniform worn by command officers of the 2380s."
	icon_state = "trek_ds9_command"
	item_state = "trek_ds9_command"

/obj/item/clothing/under/trek/engsec/ds9
	desc = "The uniform worn by operations officers of the 2380s."
	icon_state = "trek_ds9_engsec"
	item_state = "trek_ds9_engsec"

/obj/item/clothing/under/trek/medsci/ds9
	desc = "The uniform undershirt worn by medsci officers of the 2380s."
	icon_state = "trek_ds9_medsci"
	item_state = "trek_ds9_medsci"

//Q
/obj/item/clothing/under/trek/Q
	name = "french marshall's uniform"
	desc = "Something about it feels off..."
	icon_state = "trek_Q"
	item_color = "trek_Q"
	item_state = "r_suit"