// contains crayon equipment that the graffiti artist can create
/obj/item/crayon_equipment
	icon = 'icons/effects/crayondecal.dmi'
	w_class = WEIGHT_CLASS_NORMAL

// low force claymore for basic self defense
/obj/item/crayon_equipment/claymore
	name = "paint claymore"
	desc = "A sword made out of paint which is somehow wieldable."
	icon_state = "claymore"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	hitsound = 'sound/weapons/bladeslice.ogg'
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharpness = SHARP_EDGED
	max_integrity = 200
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	total_mass = TOTAL_MASS_MEDIEVAL_WEAPON
	armour_penetration = 50
	force = 20

// low force throwing star, doesn't embed, just explodes into paint
/obj/item/crayon_equipment/throwing_star
	name = "paint throwing star"
	desc = "A throwing star made out of paint. It explodes on contact showering the target in paint!"
	icon_state = "throwingstar"
	item_state = "eshield0"
	lefthand_file = 'icons/mob/inhands/equipment/shields_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/shields_righthand.dmi'
	force = 2
	throwforce = 15
	throw_speed = 4
	armour_penetration = 25
	w_class = WEIGHT_CLASS_SMALL
	sharpness = SHARP_EDGED
	resistance_flags = FIRE_PROOF
	var/static/list/random_color_list = list("#00aedb","#a200ff","#f47835","#d41243","#d11141","#00b159","#00aedb","#f37735","#ffc425","#008744","#0057e7","#d62d20","#ffa700")

/obj/item/crayon_equipment/throwing_star/throw_impact(atom/hit_atom)
	. = ..()
	hit_atom.add_atom_colour(pick(random_color_list), WASHABLE_COLOUR_PRIORITY)
	qdel(src)

// crayon toolbox, just a resprite of the toolbox
/obj/item/storage/toolbox/crayon
	name = "paint toolbox"
	desc = "A toolbox made entirely out of paint!"
	icon = 'icons/effects/crayondecal.dmi'
	icon_state = "toolbox"
	item_state = "toolbox"
	custom_materials = null
