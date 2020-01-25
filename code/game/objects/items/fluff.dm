/*		FLUFFY FUN
//
//	Includes:-
//		1) Tennis balls, lines 10 - 108
//		2) Rubber bones, lines 112 - 199
//		3) Frisbees, lines 203 - 277
//
*/

/obj/item/ammo_casing/caseless/tennis
	name = " classic tennis ball"
	desc = "A classical tennis ball. It appears to have faint bite marks scattered all over its surface."
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "tennis_classic"
	lefthand_file = 'icons/mob/inhands/misc/fluff_left.dmi'
	righthand_file = 'icons/mob/inhands/misc/fluff_right.dmi'
	item_state = "tennis_classic"
	alternate_worn_icon = 'icons/mob/mouthfluff.dmi'
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_NECK | ITEM_SLOT_EARS	//Fluff item, put it wherever you want!
	throw_range = 14
	w_class = WEIGHT_CLASS_SMALL
	projectile_type = /obj/item/projectile/bullet/reusable/ball/classic
	caliber = "ball"
	throwforce = 0
	throw_speed = 3

/obj/item/ammo_casing/caseless/tennis/pre_altattackby(atom/A, mob/living/user, params)	//checks if it can do right click memes
	altafterattack(A, user, TRUE, params)
	return TRUE

/obj/item/ammo_casing/caseless/tennis/altafterattack(atom/target, mob/living/carbon/user, proximity_flag, click_parameters)	//does right click memes
	if(istype(user))
		user.visible_message("<span class='notice'>[user] waggles [src] at [target].</span>", "<span class='notice'>You waggle [src] at [target].</span>")
	return TRUE

/obj/item/ammo_casing/caseless/tennis/rainbow
	name = "pseudo-euclidean interdimensional tennis sphere"
	desc = "A tennis ball from another plane of existance. Really groovy."
	icon_state = "tennis_rainbow"
	item_state = "tennis_rainbow"
	projectile_type = /obj/item/projectile/bullet/reusable/ball/rainbow
	actions_types = list(/datum/action/item_action/squeeze)		//Giving the masses easy access to unlimited honks would be annoying

/obj/item/ammo_casing/caseless/tennis/rainbow/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak)

/obj/item/ammo_casing/caseless/tennis/rainbow/izzy	//izzyinbox's donator item
	name = "Katlin's Ball"
	desc = "A tennis ball that's seen a good bit of love, being covered in a few black and white hairs and slobber."
	icon_state = "tennis_izzy"
	item_state = "tennis_izzy"
	projectile_type = /obj/item/projectile/bullet/reusable/ball/izzy

/obj/item/ammo_casing/caseless/tennis/red	//da red wuns go fasta
	name = "red tennis ball"
	desc = "A red tennis ball. It goes three times faster!"
	icon_state = "tennis_red"
	item_state = "tennis_red"
	projectile_type = /obj/item/projectile/bullet/reusable/ball/red
	throw_speed = 9

/obj/item/ammo_casing/caseless/tennis/yellow	//because yellow is hot I guess
	name = "yellow tennis ball"
	desc = "A yellow tennis ball. It seems to have a flame-retardant coating."
	icon_state = "tennis_yellow"
	item_state = "tennis_yellow"
	projectile_type = /obj/item/projectile/bullet/reusable/ball/yellow
	resistance_flags = FIRE_PROOF

/obj/item/ammo_casing/caseless/tennis/green	//pestilence
	name = "green tennis ball"
	desc = "A green tennis ball. It seems to have an impermeable coating."
	icon_state = "tennis_green"
	item_state = "tennis_green"
	projectile_type = /obj/item/projectile/bullet/reusable/ball/green
	permeability_coefficient = 0.9

/obj/item/ammo_casing/caseless/tennis/cyan	//electric
	name = "cyan tennis ball"
	desc = "A cyan tennis ball. It seems to have odd electrical properties."
	icon_state = "tennis_cyan"
	item_state = "tennis_cyan"
	projectile_type = /obj/item/projectile/bullet/reusable/ball/cyan
	siemens_coefficient = 0.9

/obj/item/ammo_casing/caseless/tennis/blue	//reliability
	name = "blue tennis ball"
	desc = "A blue tennis ball. It seems ever so slightly more robust than normal."
	icon_state = "tennis_blue"
	item_state = "tennis_blue"
	projectile_type = /obj/item/projectile/bullet/reusable/ball/blue
	max_integrity = 300

/obj/item/ammo_casing/caseless/tennis/purple	//because purple dyes have high pH and would neutralize acids I guess
	name = "purple tennis ball"
	desc = "A purple tennis ball. It seems to have an acid-resistant coating."
	icon_state = "tennis_purple"
	item_state = "tennis_purple"
	projectile_type = /obj/item/projectile/bullet/reusable/ball/purple
	resistance_flags = ACID_PROOF

/obj/item/ammo_casing/caseless/tennis/death		//wheres the fun in not having a death ball badmins can kill people with
	name = "death ball"
	desc = "An ominous tennis ball. This thing really doesn't look right..."
	icon_state = "tennis_death"
	item_state = "tennis_death"
	projectile_type = /obj/item/projectile/bullet/reusable/ball/death

//Honkin' Bonkin' Bones

/obj/item/toy/bone
	name = "classic rubber bone"
	desc = "A rubber bone, a basic chew toy."
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "bone_classic"
	lefthand_file = 'icons/mob/inhands/misc/fluff_left.dmi'
	righthand_file = 'icons/mob/inhands/misc/fluff_right.dmi'
	item_state = "bone_red"
	alternate_worn_icon = 'icons/mob/mouthfluff.dmi'
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_NECK | ITEM_SLOT_EARS	//Fluff item, put it wherever you want!
	throw_range = 14
	w_class = WEIGHT_CLASS_SMALL

/obj/item/toy/bone/pre_altattackby(atom/A, mob/living/user, params)	//checks if it can do right click memes
	altafterattack(A, user, TRUE, params)
	return TRUE

/obj/item/toy/bone/altafterattack(atom/target, mob/living/carbon/user, proximity_flag, click_parameters)	//does right click memes
	if(istype(user))
		user.visible_message("<span class='notice'>[user] waggles [src] at [target].</span>", "<span class='notice'>You waggle [src] at [target].</span>")
	return TRUE

/obj/item/toy/bone/white	//Maybe just a few unlimited honks
	name = "white rubber bone"
	desc = "A white rubber, hi-tech looking. It isn't actually hi-tech, just has a cheap squeaker on it."
	icon_state = "bone_white"
	item_state = "bone_white"
	actions_types = list(/datum/action/item_action/squeeze)

/obj/item/toy/bone/white/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak)

/obj/item/toy/bone/rainbow	//Maybe just a few unlimited honks
	name = "pseudo-euclidean interdimensional chew-toy"
	desc = "A rubber bone from another plane of existance. Really groovy."
	icon_state = "bone_rainbow"
	item_state = "bone_rainbow"
	actions_types = list(/datum/action/item_action/squeeze)		//Giving the masses easy access to unlimited honks would be annoying

/obj/item/toy/bone/rainbow/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak)

/obj/item/toy/bone/red	//da red wuns go fasta
	name = "red rubber bone"
	desc = "A yellow tennis ball. It goes three times faster!"
	icon_state = "bone_red"
	item_state = "bone_red"
	throw_speed = 9

/obj/item/toy/bone/yellow	//because yellow is hot I guess
	name = "yellow rubber bone"
	desc = "A black rubber bone. It seems to have a flame-retardant coating."
	icon_state = "bone_yellow"
	item_state = "bone_yellow"
	resistance_flags = FIRE_PROOF

/obj/item/toy/bone/green	//pestilence
	name = "green rubber bone"
	desc = "A green rubber bone. It seems to have an impermeable coating."
	icon_state = "bone_green"
	item_state = "bone_green"
	permeability_coefficient = 0.9

/obj/item/toy/bone/cyan	//electric
	name = "cyan rubber bone"
	desc = "A cyan rubber bone. It seems to have odd electrical properties."
	icon_state = "bone_cyan"
	item_state = "bone_cyan"
	siemens_coefficient = 0.9

/obj/item/toy/bone/blue	//reliability
	name = "blue rubber bone"
	desc = "A blue rubber bone. It seems ever so slightly more robust than normal."
	icon_state = "bone_blue"
	item_state = "bone_blue"
	max_integrity = 300

/obj/item/toy/bone/purple	//because purple dyes have high pH and would neutralize acids I guess
	name = "purple rubber bone"
	desc = "A purple rubber bone. It seems to have an acid-resistant coating."
	icon_state = "bone_purple"
	item_state = "bone_purple"
	resistance_flags = ACID_PROOF

/datum/action/item_action/squeeze
	name = "Squeak!"

//Fun Frickin' Freakin' Frisbee's

/obj/item/ammo_casing/caseless/frisbee
	name = "classic frisbee"
	desc = "I would throw it to Edna and she would throw is back to me and I would throw it to Edna and she would throw is back to me and I would throw it to Edna and she would throw is back to me and I would throw it to Edna and she would throw is back to me and- alright you get the point."
	icon = 'icons/obj/fluff_items.dmi'
	icon_state = "frisbee_classic"
	lefthand_file = 'icons/mob/inhands/misc/fluff_left.dmi'
	righthand_file = 'icons/mob/inhands/misc/fluff_right.dmi'
	item_state = "frisbee_classic"
	alternate_worn_icon = 'icons/mob/mouthfluff.dmi'
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_NECK | ITEM_SLOT_EARS	//Fluff item, put it wherever you want!
	throw_range = 14
	w_class = WEIGHT_CLASS_SMALL
	projectile_type = /obj/item/projectile/bullet/reusable/frisbee/classic
	caliber = "frisbee"
	throwforce = 0
	throw_speed = 3

/obj/item/ammo_casing/caseless/frisbee/pre_altattackby(atom/A, mob/living/user, params)	//checks if it can do right click memes
	altafterattack(A, user, TRUE, params)
	return TRUE

/obj/item/ammo_casing/caseless/frisbee/altafterattack(atom/target, mob/living/carbon/user, proximity_flag, click_parameters)	//does right click memes
	if(istype(user))
		user.visible_message("<span class='notice'>[user] waggles [src] at [target].</span>", "<span class='notice'>You waggle [src] at [target].</span>")
	return TRUE

/obj/item/ammo_casing/caseless/frisbee/rainbow
	name = "pseudo-euclidean interdimensional disc"
	desc = "A frisbee from another plane of existance. Really groovy."
	icon_state = "frisbee_rainbow"
	item_state = "frisbee_rainbow"
	projectile_type = /obj/item/projectile/bullet/reusable/frisbee/rainbow

/obj/item/ammo_casing/caseless/frisbee/white
	name = "white frisbee"
	desc = "A frisbee, hi-tech looking. It isn't actually hi-tech."
	icon_state = "frisbee_white"
	item_state = "frisbee_white"
	projectile_type = /obj/item/projectile/bullet/reusable/frisbee/white

/obj/item/ammo_casing/caseless/frisbee/red	//da red wuns go fasta
	name = "red frisbee"
	desc = "A frisbee. It goes three times faster!"
	icon_state = "frisbee_red"
	item_state = "frisbee_red"
	projectile_type = /obj/item/projectile/bullet/reusable/frisbee/red
	throw_speed = 9

/obj/item/ammo_casing/caseless/frisbee/yellow	//because yellow is hot I guess
	name = "yellow frisbee"
	desc = "A yellow frisbee. It seems to have a flame-retardant coating."
	icon_state = "frisbee_yellow"
	item_state = "frisbee_yellow"
	projectile_type = /obj/item/projectile/bullet/reusable/frisbee/yellow
	resistance_flags = FIRE_PROOF

/obj/item/ammo_casing/caseless/frisbee/green	//pestilence
	name = "green frisbee"
	desc = "A green frisbee. It seems to have an impermeable coating."
	icon_state = "frisbee_green"
	item_state = "frisbee_green"
	projectile_type = /obj/item/projectile/bullet/reusable/frisbee/green
	permeability_coefficient = 0.9

/obj/item/ammo_casing/caseless/frisbee/cyan	//electric
	name = "cyan frisbee"
	desc = "A cyan frisbee. It seems to have odd electrical properties."
	icon_state = "frisbee_cyan"
	item_state = "frisbee_cyan"
	projectile_type = /obj/item/projectile/bullet/reusable/frisbee/cyan
	siemens_coefficient = 0.9

/obj/item/ammo_casing/caseless/frisbee/blue	//reliability
	name = "blue frisbee"
	desc = "A blue frisbee. It seems ever so slightly more robust than normal."
	icon_state = "frisbee_blue"
	item_state = "frisbee_blue"
	projectile_type = /obj/item/projectile/bullet/reusable/frisbee/blue
	max_integrity = 300

/obj/item/ammo_casing/caseless/frisbee/purple	//because purple dyes have high pH and would neutralize acids I guess
	name = "purple frisbee"
	desc = "A purple frisbee. It seems to have an acid-resistant coating."
	icon_state = "frisbee_purple"
	item_state = "frisbee_purple"
	projectile_type = /obj/item/projectile/bullet/reusable/frisbee/purple
	resistance_flags = ACID_PROOF

/obj/item/ammo_casing/caseless/frisbee/death	//just a little more badmin fun here
	name = "death frisbee"
	desc = "An ominous looking frisbee. It looks REALLY sharp, like seriously, do not throw this at people."
	icon_state = "frisbee_death"
	item_state = "frisbee_death"
	projectile_type = /obj/item/projectile/bullet/reusable/frisbee/death