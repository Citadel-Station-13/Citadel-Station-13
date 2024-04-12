//Just some alt-uniforms themed around Star Trek - Pls don't sue, Mr Roddenberry ;_;


/obj/item/clothing/under/trek
	name = "Section 31 Uniform"
	desc = "Oooh... right."
	item_state = ""
	can_adjust = FALSE	//to prevent you from "wearing it casually"


//TOS
/obj/item/clothing/under/trek/command
	name = "command uniform"
	desc = "The uniform worn by command officers in the mid 2260s."
	icon_state = "trek_command"
	item_state = "y_suit"

/obj/item/clothing/under/trek/engsec
	name = "operations uniform"
	desc = "The uniform worn by operations officers of the mid 2260s. You feel strangely vulnerable just seeing this..."
	icon_state = "trek_engsec"
	item_state = "r_suit"
	strip_delay = 50

/obj/item/clothing/under/trek/medsci
	name = "medsci uniform"
	desc = "The uniform worn by medsci officers in the mid 2260s."
	icon_state = "trek_medsci"
	item_state = "b_suit"
	permeability_coefficient = 0.50


//TNG
/obj/item/clothing/under/trek/command/next
	desc = "The uniform worn by command officers. This one's from the mid 2360s."
	icon_state = "trek_next_command"
	item_state = "r_suit"

/obj/item/clothing/under/trek/engsec/next
	desc = "The uniform worn by operation officers. This one's from the mid 2360s."
	icon_state = "trek_next_engsec"
	item_state = "y_suit"

/obj/item/clothing/under/trek/medsci/next
	desc = "The uniform worn by medsci officers. This one's from the mid 2360s."
	icon_state = "trek_next_medsci"
	item_state = "b_suit"


//ENT
/obj/item/clothing/under/trek/command/ent
	desc = "The uniform worn by command officers of the 2140s."
	icon_state = "trek_ent_command"
	item_state = "bl_suit"

/obj/item/clothing/under/trek/engsec/ent
	desc = "The uniform worn by operations officers of the 2140s."
	icon_state = "trek_ent_engsec"
	item_state = "bl_suit"

/obj/item/clothing/under/trek/medsci/ent
	desc = "The uniform worn by medsci officers of the 2140s."
	icon_state = "trek_ent_medsci"
	item_state = "bl_suit"


//VOY
/obj/item/clothing/under/trek/command/voy
	desc = "The uniform worn by command officers of the 2370s."
	icon_state = "trek_voy_command"
	item_state = "r_suit"

/obj/item/clothing/under/trek/engsec/voy
	desc = "The uniform worn by operations officers of the 2370s."
	icon_state = "trek_voy_engsec"
	item_state = "y_suit"

/obj/item/clothing/under/trek/medsci/voy
	desc = "The uniform worn by medsci officers of the 2370s."
	icon_state = "trek_voy_medsci"
	item_state = "b_suit"


//DS9
/obj/item/clothing/under/trek/command/ds9
	desc = "The uniform worn by command officers of the 2380s."
	icon_state = "trek_ds9_command"
	item_state = "r_suit"

/obj/item/clothing/under/trek/engsec/ds9
	desc = "The uniform worn by operations officers of the 2380s."
	icon_state = "trek_ds9_engsec"
	item_state = "y_suit"

/obj/item/clothing/under/trek/medsci/ds9
	desc = "The uniform undershirt worn by medsci officers of the 2380s."
	icon_state = "trek_ds9_medsci"
	item_state = "b_suit"

//Orvilike (Orville-inspired clothing with TOS-like color code)
/obj/item/clothing/under/trek/command/orv
	desc = "An uniform worn by command officers since 2420s."
	icon_state = "orv_com"

/obj/item/clothing/under/trek/eng/orv
	desc = "An uniform worn by operations officers since 2420s."
	icon_state = "orv_eng"

/obj/item/clothing/under/trek/sec/orv
	desc = "An uniform worn by security officers since 2420s."
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 30, ACID = 30, WOUND = 10)
	icon_state = "orv_sec"

/obj/item/clothing/under/trek/medsci/orv
	desc = "An uniform worn by medsci officers since 2420s."
	icon_state = "orv_medsci"

//Orvilike Extra (Ditto, but expands it for Civilian department with SS13 colors and gives specified command uniform)
//honestly no idea why i added specified comm. uniforms but w/e
/obj/item/clothing/under/trek/command/orv/captain
	name = "captain uniform"
	desc = "An uniform worn by captains and commanders since 2550s."
	icon_state = "orv_com_capt"

/obj/item/clothing/under/trek/command/orv/eng
	name = "engineering command uniform"
	desc = "An uniform worn by Chief Engineers since 2550s."
	icon_state = "orv_com_eng"

/obj/item/clothing/under/trek/command/orv/sec
	name = "security command uniform"
	armor = list(MELEE = 10, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 10)
	desc = "An uniform worn by Heads of Security since 2550s."
	icon_state = "orv_com_sec"


/obj/item/clothing/under/trek/command/orv/medsci
	name = "medsci command uniform"
	desc = "An uniform worn by medsci command officers since 2550s."
	icon_state = "orv_com_medsci"

/obj/item/clothing/under/trek/orv
	name = "adjutant uniform"
	desc = "An uniform worn by adjutants <i>(assistants)</i> since 2550s."
	icon_state = "orv_ass"

/obj/item/clothing/under/trek/orv/service
	name = "service uniform"
	desc = "An uniform worn by service officers since 2550s."
	icon_state = "orv_srv"

//The Motion Picture
/obj/item/clothing/under/trek/fedutil
	name = "federation utility uniform"
	desc = "The uniform worn by United Federation enlisted crew members in 2285s."
	icon_state = "trek_tmp_enlist"
	item_state = "r_suit"

/obj/item/clothing/under/trek/fedutil/trainee
	name = "federation trainee utility uniform"
	desc = "The uniform worn by United Federation enlisted trainees in 2285s."
	icon_state = "trek_tmp_trainee"

/obj/item/clothing/under/trek/fedutil/service
	name = "federation service uniform"
	desc = "The uniform worn by United Federation enlists for service work in 2285s."
	icon_state = "trek_tmp_service"

//Q
/obj/item/clothing/under/trek/Q
	name = "french marshall's uniform"
	desc = "Something about it feels off..."
	icon_state = "trek_Q"
	item_state = "r_suit"
