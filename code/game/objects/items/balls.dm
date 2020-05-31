/*		BALLS - GLORIOUS BALLS
//
//	Includes:-
//		1) Tennis balls, lines 10 - 92
//
//
//
*/

/obj/item/toy/tennis
	name = "tennis ball"
	desc = "A classical tennis ball. It appears to have faint bite marks scattered all over its surface."
	icon = 'modular_citadel/icons/obj/balls.dmi'
	icon_state = "tennis_classic"
	lefthand_file = 'modular_citadel/icons/mob/inhands/balls_left.dmi'
	righthand_file = 'modular_citadel/icons/mob/inhands/balls_right.dmi'
	item_state = "tennis_classic"
	mob_overlay_icon = 'modular_citadel/icons/mob/mouthball.dmi'
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_NECK | ITEM_SLOT_EARS	//Fluff item, put it wherever you want!
	throw_range = 14
	w_class = WEIGHT_CLASS_SMALL

/obj/item/toy/tennis/alt_pre_attack(atom/A, mob/living/user, params)	//checks if it can do right click memes
	altafterattack(A, user, TRUE, params)
	return TRUE

/obj/item/toy/tennis/altafterattack(atom/target, mob/living/carbon/user, proximity_flag, click_parameters)	//does right click memes
	if(istype(user))
		user.visible_message("<span class='notice'>[user] waggles [src] at [target].</span>", "<span class='notice'>You waggle [src] at [target].</span>")
	return TRUE

/obj/item/toy/tennis/rainbow
	name = "pseudo-euclidean interdimensional tennis sphere"
	desc = "A tennis ball from another plane of existance. Really groovy."
	icon_state = "tennis_rainbow"
	item_state = "tennis_rainbow"
	actions_types = list(/datum/action/item_action/squeeze)		//Giving the masses easy access to unilimted honks would be annoying

/obj/item/toy/tennis/rainbow/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak)

/obj/item/toy/tennis/rainbow/izzy	//izzyinbox's donator item
	name = "Katlin's Ball"
	desc = "A tennis ball that's seen a good bit of love, being covered in a few black and white hairs and slobber."
	icon_state = "tennis_izzy"
	item_state = "tennis_izzy"

/obj/item/toy/tennis/red	//da red wuns go fasta
	name = "red tennis ball"
	desc = "A red tennis ball. It goes three times faster!"
	icon_state = "tennis_red"
	item_state = "tennis_red"
	throw_speed = 9

/obj/item/toy/tennis/yellow	//because yellow is hot I guess
	name = "yellow tennis ball"
	desc = "A yellow tennis ball. It seems to have a flame-retardant coating."
	icon_state = "tennis_yellow"
	item_state = "tennis_yellow"
	resistance_flags = FIRE_PROOF

/obj/item/toy/tennis/green	//pestilence
	name = "green tennis ball"
	desc = "A green tennis ball. It seems to have an impermeable coating."
	icon_state = "tennis_green"
	item_state = "tennis_green"
	permeability_coefficient = 0.9

/obj/item/toy/tennis/cyan	//electric
	name = "cyan tennis ball"
	desc = "A cyan tennis ball. It seems to have odd electrical properties."
	icon_state = "tennis_cyan"
	item_state = "tennis_cyan"
	siemens_coefficient = 0.9

/obj/item/toy/tennis/blue	//reliability
	name = "blue tennis ball"
	desc = "A blue tennis ball. It seems ever so slightly more robust than normal."
	icon_state = "tennis_blue"
	item_state = "tennis_blue"
	max_integrity = 300

/obj/item/toy/tennis/purple	//because purple dyes have high pH and would neutralize acids I guess
	name = "purple tennis ball"
	desc = "A purple tennis ball. It seems to have an acid-resistant coating."
	icon_state = "tennis_purple"
	item_state = "tennis_purple"
	resistance_flags = ACID_PROOF

/datum/action/item_action/squeeze
	name = "Squeak!"
