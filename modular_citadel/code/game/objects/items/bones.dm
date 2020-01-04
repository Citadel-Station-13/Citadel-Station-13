//Honkin' Bonkin' Bones

/obj/item/toy/bone
	name = "rubber bone"
	desc = "A rubber bone. It is quite flexible, and lets out an occasional squeak when squeezed enough."
	icon = 'modular_citadel/icons/obj/squeakybones.dmi'
	icon_state = "bone_red"
	lefthand_file = 'modular_citadel/icons/mob/inhands/bones_left.dmi'
	righthand_file = 'modular_citadel/icons/mob/inhands/bones_right.dmi'
	item_state = "bone_red"
	alternate_worn_icon = 'modular_citadel/icons/mob/mouthbone.dmi'
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
	desc = "A white rubber bone that seems to have a little intricate plastic hole behind it..."
	icon_state = "bone_white"
	item_state = "bone_white"
	actions_types = list(/datum/action/item_action/squeeze)

/obj/item/toy/bone/white/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak)

/obj/item/toy/bone/black	//the black ones hit harder, not a racism joke totally
	name = "black rubber bone"
	desc = "A black rubber bone that seems to have a little more weight than the others..."
	icon_state = "bone_black"
	item_state = "bone_black"
	throwforce = 2.5

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