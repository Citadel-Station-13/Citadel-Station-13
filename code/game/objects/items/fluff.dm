/*	Balls, Bones, and Bountiful Fun
//
//	Includes:-
//		1) Fluff Content, lines 12 - 131
//
//			1) Tennis balls, lines 39 - 99
//			2) Chew bones, lines 101 - 138
//			3) Frisbee, lines 140 - 166
*/		

/obj/item/toy/fluff
	name = "Fluff Item"
	desc = "You shouldn't be seeing this."
	icon = 'icons/obj/barkbox_fluff.dmi'
	icon_state = "poly_tennis"
	item_state = "poly_tennis"
	lefthand_file = 'icons/mob/inhands/fluff_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/fluff_righthand.dmi'
	mob_overlay_icon = 'icons/mob/mouthfluff.dmi'
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_NECK | ITEM_SLOT_EARS
	var/poly_states = 0
	var/poly_colors = list()

/obj/item/toy/fluff/alt_pre_attack(atom/A, mob/living/user, params)	//checks if it can do right click memes
	altafterattack(A, user, TRUE, params)
	return TRUE

/obj/item/toy/fluff/altafterattack(atom/target, mob/living/carbon/user, proximity_flag, click_parameters)	//does right click memes
	if(istype(user))
		user.visible_message("<span class='notice'>[user] waggles [src] at [target].</span>", "<span class='notice'>You waggle [src] at [target].</span>")
	return TRUE

/obj/item/toy/fluff/ComponentInitialize()
	. = ..()
	if(!poly_states)
		return
	AddElement(/datum/element/polychromic, poly_colors, poly_states, _flags = POLYCHROMIC_ACTION)

/obj/item/toy/fluff/tennis_poly
	name = "polychromic tennis ball"
	desc = "A polychromic tennis ball. There's a half torn tag read: WARNIN-, surely it means nothing. Right?"
	throw_range = 14
	w_class = WEIGHT_CLASS_SMALL
	poly_states = 2
	poly_colors = list("#CCFF00", "#FFFFFF")

/obj/item/toy/fluff/tennis_poly/red
	poly_colors = list("#FF4C00", "#FFFFFF")

/obj/item/toy/fluff/tennis_poly/yellow
	poly_colors = list("#FFCC00", "#FFFFFF")

/obj/item/toy/fluff/tennis_poly/green
	poly_colors = list("#99FF00", "#FFFFFF")

/obj/item/toy/fluff/tennis_poly/cyan
	poly_colors = list("#00FFB2", "#FFFFFF")

/obj/item/toy/fluff/tennis_poly/blue
	poly_colors = list("#007FFF", "#FFFFFF")

/obj/item/toy/fluff/tennis_poly/purple
	poly_colors = list("#CC00FF", "#FFFFFF")

/obj/item/toy/fluff/tennis_poly/tri
	name = "tricolor-polychromic tennis ball"
	desc = "A tricolor-polychromic tennis ball. Triple the shocking!"
	icon_state = "tripoly_tennis"
	item_state = "tripoly_tennis"
	poly_states = 3
	poly_colors = list("#FFFFFF", "#FFFFFF", "#FFFFFF")

/obj/item/toy/fluff/tennis_poly/tri/squeak
	name = "tricolor-polychromic tennis sphere"
	desc = "A tricolor-polychromic tennis ball. This one seems to emit a squeak when squeezed."
	actions_types = list(/datum/action/item_action/squeeze)

/obj/item/toy/fluff/tennis_poly/tri/squeak/izzy 	//izzyinbox's donator item
	name = "Katlin's Ball"
	desc = "A tennis ball that's seen a good bit of love, being covered in a few black and white hairs and slobber."
	poly_colors = list("#8FED56", "#51cfde", "#FFFFFF")

/obj/item/toy/fluff/tennis_poly/tri/squeak/rainbow
	name = "pseudo-euclidean interdimensional tennis sphere"
	desc = "A tennis ball from another plane of existance. Really groovy."
	icon_state = "tennis_rainbow"
	item_state = "tennis_rainbow"
	poly_states = 0
	actions_types = list(/datum/action/item_action/squeeze)

/obj/item/toy/fluff/tennis_poly/tri/squeak/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak)

/obj/item/toy/fluff/bone_poly
	name = "polychromic bone"
	desc = "A polychromic chew bone. Nothing like a good bone to chew on."
	icon_state = "poly_bone"
	item_state = "poly_bone"
	throw_range = 7
	w_class = WEIGHT_CLASS_SMALL
	poly_states = 1
	poly_colors = list("#FFFFFF")

/obj/item/toy/fluff/bone_poly/red
	poly_colors = list("#FF4C00")

/obj/item/toy/fluff/bone_poly/yellow
	poly_colors = list("#FFCC00")

/obj/item/toy/fluff/bone_poly/green
	poly_colors = list("#99FF00")

/obj/item/toy/fluff/bone_poly/cyan
	poly_colors = list("#00FFB2")

/obj/item/toy/fluff/bone_poly/blue
	poly_colors = list("#007FFF")

/obj/item/toy/fluff/bone_poly/purple
	poly_colors = list("#CC00FF")

/obj/item/toy/fluff/bone_poly/squeak
	name = "polychromic bone"
	desc = "A polychromic chew bone. Makes a small squeak when squeezed."

/obj/item/toy/fluff/bone_poly/squeak/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak)

/datum/action/item_action/squeeze
	name = "Squeak!"

/obj/item/toy/fluff/frisbee_poly
	name = "polychromic frisbee"
	desc = "A polychromic frisbee. Warning: May induce shock."
	icon_state = "poly_frisbee"
	item_state = "poly_frisbee"
	throw_range = 14
	w_class = WEIGHT_CLASS_NORMAL
	poly_states = 2
	poly_colors = list("#CCFF00", "#FFFFFF")

/obj/item/toy/fluff/frisbee_poly/red
	poly_colors = list("#FF4C00", "#FFFFFF")

/obj/item/toy/fluff/frisbee_poly/yellow
	poly_colors = list("#FFCC00", "#FFFFFF")

/obj/item/toy/fluff/frisbee_poly/green
	poly_colors = list("#99FF00", "#FFFFFF")

/obj/item/toy/fluff/frisbee_poly/cyan
	poly_colors = list("#00FFB2", "#FFFFFF")

/obj/item/toy/fluff/frisbee_poly/blue
	poly_colors = list("#007FFF", "#FFFFFF")

/obj/item/toy/fluff/frisbee_poly/purple
	poly_colors = list("#CC00FF", "#FFFFFF")
