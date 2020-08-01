//Brass claw, a armbladelike weapon used by an clock implant. Stealthy if retracted, very obvious if active. Simillar to an armblade strength-wise but has some funky stuff

/obj/item/clockwork/brass_claw
	name = "brass claw"
	desc = "A highly sharp claw made out of brass."
	clockwork_desc = "A incredibly sharp claw made out of brass. It is quite effective at crippling enemies, though incredibly obvious aswell."
	icon_state = "brass_claw" //Codersprite moment
	item_state = "brass_claw"
	lefthand_file = 'icons/mob/inhands/antag/clockwork_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/clockwork_righthand.dmi'
	//item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	force = 15 //Doesn't generate vitality like the spear does / has somewhat less damage, but quite good at wounding and gets through armor pretty well.
	throwforce = 0 //haha yes lets be safe about this
	throw_range = 0
	throw_speed = 0
	armour_penetration = 20
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharpness = IS_SHARP
	wound_bonus = 5
	bare_wound_bonus = 15
	total_mass = TOTAL_MASS_HAND_REPLACEMENT
