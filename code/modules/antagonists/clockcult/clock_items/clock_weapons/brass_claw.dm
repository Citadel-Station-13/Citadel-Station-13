//Brass claw, an armblade-like weapon used by a clock implant. Stealthy if retracted, very obvious if active.
//Bit weaker than an armblade strength-wise but gains combo on consecutive attacks against the same target, which causes bonus damage

/obj/item/clockwork/brass_claw
	name = "brass claw"
	desc = "A very sharp claw made out of brass."
	clockwork_desc = "A incredibly sharp claw made out of brass. It is quite effective at crippling enemies, though very obvious when extended.\nGains combo on consecutive attacks against a target, causing bonus damage."
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
	sharpness = SHARP_EDGED
	wound_bonus = 5
	bare_wound_bonus = 15
	total_mass = TOTAL_MASS_HAND_REPLACEMENT
	var/mob/living/last_attacked
	var/combo = 0
	var/damage_per_combo = 2
	var/maximum_combo_damage = 18 //33 damage on max stacks. Usually the target will already be dead by then but if they somehow aren't, better to have this capped

/obj/item/clockwork/brass_claw/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, 60, 80)

/obj/item/clockwork/brass_claw/examine(mob/user)
	if(is_servant_of_ratvar(user))
		clockwork_desc += "\n<span class='brass'>It has </span><span class='inathneq_small'><b>[combo]</span></b><span class='brass'> combo stacks built up against the current target, causing </span><span class='inathneq_small'><b>[min(maximum_combo_damage, combo * damage_per_combo)]</span></b><span class='brass'> bonus damage.</span>"
	. = ..()
	clockwork_desc = initial(clockwork_desc)

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
		target.adjustBruteLoss(min(maximum_combo_damage, combo * damage_per_combo))
