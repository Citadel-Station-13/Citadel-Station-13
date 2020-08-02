//Brass claw, an armblade-like weapon used by a clock implant. Stealthy if retracted, very obvious if active.
//Bit weaker than an armblade strength-wise but gains combo on consecutive attacks against the same target, which causes bonus damage

/obj/item/clockwork/brass_claw
	name = "brass claw"
	desc = "A highly sharp claw made out of brass."
	clockwork_desc = "A incredibly sharp claw made out of brass. It is quite effective at crippling enemies, though incredibly obvious aswell. </n> Gains combo on consecutive attacks against a target, causing bonus damage."
	icon_state = "brass_claw" //Codersprite moment
	item_state = "brass_claw"
	lefthand_file = 'icons/mob/inhands/antag/clockwork_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/clockwork_righthand.dmi'
	w_class = WEIGHT_CLASS_HUGE
	force = 15 //Doesn't generate vitality like the spear does / has somewhat less damage, but quite good at wounding and gets through armor pretty well. Also gains 2 bonus damage per consecutive attack on the same target
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
	var/mob/living/last_attacked
	var/combo = 0

/obj/item/clockwork/brass_claw/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 60, 80)

/obj/item/clockwork/brass_claw/attack(mob/living/target, mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(target) || target.anti_magic_check(chargecost = 0) || is_servant_of_ratvar(target))
		return
	if(target != last_attacked) //Loses all combat on switching targets
		last_attacked = target
		combo = 0
	else
		if(!iscultist(target)) //Hostile cultists being hit stacks up combo far faster than usual
			combo++
		else
			combo += 3
		target.adjustBruteLoss(combo * 2)
