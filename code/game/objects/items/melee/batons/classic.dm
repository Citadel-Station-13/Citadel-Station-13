/obj/item/melee/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "baton"
	item_state = "classic_baton"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	force = 12 //9 hit crit
	w_class = WEIGHT_CLASS_NORMAL
	var/cooldown = 13
	var/on = TRUE
	var/last_hit = 0
	var/stun_stam_cost_coeff = 1.25
	var/hardstun_ds = 1
	var/softstun_ds = 0
	var/stam_dmg = 30

/obj/item/melee/classic_baton/attack(mob/living/target, mob/living/user)
	if(!on)
		return ..()

	if(user.getStaminaLoss() >= STAMINA_SOFTCRIT)//CIT CHANGE - makes batons unusuable in stamina softcrit
		to_chat(user, "<span class='warning'>You're too exhausted for that.</span>")//CIT CHANGE - ditto
		return //CIT CHANGE - ditto

	add_fingerprint(user)
	if((HAS_TRAIT(user, TRAIT_CLUMSY)) && prob(50))
		to_chat(user, "<span class ='danger'>You club yourself over the head.</span>")
		user.Knockdown(60 * force)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, BRUTE, BODY_ZONE_HEAD)
		else
			user.take_bodypart_damage(2*force)
		return
	if(iscyborg(target))
		..()
		return
	if(!isliving(target))
		return
	if (user.a_intent == INTENT_HARM)
		if(!..() || !iscyborg(target))
			return
	else
		if(last_hit < world.time)
			if(target.check_shields(src, 0, "[user]'s [name]", MELEE_ATTACK))
				playsound(target, 'sound/weapons/genhit.ogg', 50, 1)
				return
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				if(check_martial_counter(H, user))
					return
			playsound(get_turf(src), 'sound/effects/woodhit.ogg', 75, 1, -1)
			target.Knockdown(softstun_ds, TRUE, FALSE, hardstun_ds, stam_dmg)
			log_combat(user, target, "stunned", src)
			src.add_fingerprint(user)
			target.visible_message("<span class ='danger'>[user] has knocked down [target] with [src]!</span>", \
				"<span class ='userdanger'>[user] has knocked down [target] with [src]!</span>")
			if(!iscarbon(user))
				target.LAssailant = null
			else
				target.LAssailant = user
			last_hit = world.time + cooldown
			user.adjustStaminaLossBuffered(getweight())//CIT CHANGE - makes swinging batons cost stamina

/obj/item/melee/classic_baton/telescopic
	name = "telescopic baton"
	desc = "A compact yet robust personal defense weapon. Can be concealed when folded."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "telebaton_0"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	item_state = null
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	item_flags = NONE
	force = 0
	on = FALSE
	total_mass = TOTAL_MASS_NORMAL_ITEM

/obj/item/melee/classic_baton/telescopic/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/transforming, ATTACK_SELF_TRANSFORM, .proc/on_transform)

/obj/item/melee/classic_baton/telescopic/suicide_act(mob/user)
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/brain/B = H.getorgan(/obj/item/organ/brain)

	user.visible_message("<span class='suicide'>[user] stuffs [src] up [user.p_their()] nose and presses the 'extend' button! It looks like [user.p_theyre()] trying to clear [user.p_their()] mind.</span>")
	SEND_SIGNAL(src, COMSIG_TRANSFORM_ACTIVATE, user)
	add_fingerprint(user)
	sleep(3)
	if (H && !QDELETED(H))
		if (B && !QDELETED(B))
			H.internal_organs -= B
			qdel(B)
		H.spawn_gibs()
		return (BRUTELOSS)

/obj/item/melee/classic_baton/telescopic/proc/on_transform(obj/item/parent, new_active, mob/user, forced, datum/signal_source, checks_passed)
	if(user)
		if(new_active)
			to_chat(user, "<span class ='warning'>You extend the baton.</span>")
		else
			to_chat(user, "<span class ='notice'>You collapse the baton.</span>")
	if(new_active)
		w_class = WEIGHT_CLASS_BULKY //doesnt fit in backpack when its on for balance
		force = 10 //stunbaton damage
		attack_verb = list("smacked", "struck", "cracked", "beaten")
		slot_flags = NONE
	else
		slot_flags = ITEM_SLOT_BELT
		w_class = WEIGHT_CLASS_SMALL
		force = 0 //not so robust now
		attack_verb = list("prodded", "poked")
	update_icon()
	playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1)
	add_fingerprint(user)

/obj/item/melee/classic_baton/update_icon()
	. = ..()
	if(SEND_SIGNAL(src, COMSIG_IS_TRANSFORMED) & COMPONENT_IS_TRANSFORMED)
		icon_state = "telebaton_1"
		item_state = "nullrod"
	else
		icon_state = "telebaton_0"
		item_state = null //no sprite for concealment even when in hand
