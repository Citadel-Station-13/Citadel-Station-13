//Fun Frickin' Freakin' Frisbee's

/obj/item/toy/frisbee
	name = "frisbee"
	desc = "I would throw it to Edna and she would throw is back to me and I would throw it to Edna and she would throw is back to me and I would throw it to Edna and she would throw is back to me and I would throw it to Edna and she would throw is back to me and- alright you get the point."
	icon = 'modular_citadel/icons/obj/frisbees.dmi'
	icon_state = "frisbee_classic"
	lefthand_file = 'modular_citadel/icons/mob/inhands/frisbees_left.dmi'
	righthand_file = 'modular_citadel/icons/mob/inhands/frisbees_right.dmi'
	item_state = "frisbee_classic"
	alternate_worn_icon = 'modular_citadel/icons/mob/mouthfrisbee.dmi'
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_NECK | ITEM_SLOT_EARS	//Fluff item, put it wherever you want!
	throw_range = 14
	w_class = WEIGHT_CLASS_SMALL

/obj/item/toy/frisbee/pre_altattackby(atom/A, mob/living/user, params)	//checks if it can do right click memes
	altafterattack(A, user, TRUE, params)
	return TRUE

/obj/item/toy/frisbee/altafterattack(atom/target, mob/living/carbon/user, proximity_flag, click_parameters)	//does right click memes
	if(istype(user))
		user.visible_message("<span class='notice'>[user] waggles [src] at [target].</span>", "<span class='notice'>You waggle [src] at [target].</span>")
	return TRUE

/obj/item/toy/frisbee/rainbow
	name = "pseudo-euclidean interdimensional frisbee disc"
	desc = "A frisbee from another plane of existance. Really groovy."
	icon_state = "frisbee_rainbow"
	item_state = "frisbee_rainbow"

/obj/item/toy/frisbee/red	//da red wuns go fasta
	name = "red frisbee"
	desc = "A frisbee. It goes three times faster!"
	icon_state = "frisbee_red"
	item_state = "frisbee_red"
	throw_speed = 9

/obj/item/toy/frisbee/yellow	//because yellow is hot I guess
	name = "yellow frisbee"
	desc = "A yellow frisbee. It seems to have a flame-retardant coating."
	icon_state = "frisbee_yellow"
	item_state = "frisbee_yellow"
	resistance_flags = FIRE_PROOF

/obj/item/toy/frisbee/green	//pestilence
	name = "green frisbee"
	desc = "A green frisbee. It seems to have an impermeable coating."
	icon_state = "frisbee_green"
	item_state = "frisbee_green"
	permeability_coefficient = 0.9

/obj/item/toy/frisbee/cyan	//electric
	name = "cyan frisbee"
	desc = "A cyan frisbee. It seems to have odd electrical properties."
	icon_state = "frisbee_cyan"
	item_state = "frisbee_cyan"
	siemens_coefficient = 0.9

/obj/item/toy/frisbee/blue	//reliability
	name = "blue frisbee"
	desc = "A blue frisbee. It seems ever so slightly more robust than normal."
	icon_state = "frisbee_blue"
	item_state = "frisbee_blue"
	max_integrity = 300

/obj/item/toy/frisbee/purple	//because purple dyes have high pH and would neutralize acids I guess
	name = "purple frisbee"
	desc = "A purple frisbee. It seems to have an acid-resistant coating."
	icon_state = "frisbee_purple"
	item_state = "frisbee_purple"
	resistance_flags = ACID_PROOF