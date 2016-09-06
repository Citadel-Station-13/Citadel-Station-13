/mob/living/carbon/human/getarmor(def_zone, type)
	var/armorval = 0
	var/organnum = 0

	if(def_zone)
		if(islimb(def_zone))
			return checkarmor(def_zone, type)
		var/obj/item/bodypart/affecting = get_bodypart(ran_zone(def_zone))
		return checkarmor(affecting, type)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		armorval += checkarmor(BP, type)
		organnum++
	return (armorval/max(organnum, 1))


/mob/living/carbon/human/proc/checkarmor(obj/item/bodypart/def_zone, type)
	if(!type)
		return 0
	var/protection = 0
	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform, back, gloves, shoes, belt, s_store, glasses, ears, wear_id) //Everything but pockets. Pockets are l_store and r_store. (if pockets were allowed, putting something armored, gloves or hats for example, would double up on the armor)
	for(var/bp in body_parts)
		if(!bp)
			continue
		if(bp && istype(bp ,/obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & def_zone.body_part)
				protection += C.armor[type]
	return protection

/mob/living/carbon/human/on_hit(proj_type)
	dna.species.on_hit(proj_type, src)

/mob/living/carbon/human/bullet_act(obj/item/projectile/P, def_zone)
	if(!(P.original == src && P.firer == src)) //can't block or reflect when shooting yourself
		if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam))
			if(check_reflect(def_zone)) // Checks if you've passed a reflection% check
				visible_message("<span class='danger'>The [P.name] gets reflected by [src]!</span>", \
								"<span class='userdanger'>The [P.name] gets reflected by [src]!</span>")
				// Find a turf near or on the original location to bounce to
				if(P.starting)
					var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/turf/curloc = get_turf(src)

					// redirect the projectile
					P.original = locate(new_x, new_y, P.z)
					P.starting = curloc
					P.current = curloc
					P.firer = src
					P.yo = new_y - curloc.y
					P.xo = new_x - curloc.x
					P.Angle = null

				return -1 // complete projectile permutation

		if(check_shields(P.damage, "the [P.name]", P, PROJECTILE_ATTACK, P.armour_penetration))
			P.on_hit(src, 100, def_zone)
			return 2
	return (..(P , def_zone))

/mob/living/carbon/human/proc/check_reflect(def_zone) //Reflection checks for anything in your l_hand, r_hand, or wear_suit based on the reflection chance of the object
	if(wear_suit)
		if(wear_suit.IsReflect(def_zone) == 1)
			return 1
	if(l_hand)
		if(l_hand.IsReflect(def_zone) == 1)
			return 1
	if(r_hand)
		if(r_hand.IsReflect(def_zone) == 1)
			return 1
	return 0

/mob/living/carbon/human/proc/check_shields(damage = 0, attack_text = "the attack", atom/movable/AM, attack_type = MELEE_ATTACK, armour_penetration = 0)
	var/block_chance_modifier = round(damage / -3)

	if(l_hand && !istype(l_hand, /obj/item/clothing))
		var/final_block_chance = l_hand.block_chance - (Clamp((armour_penetration-l_hand.armour_penetration)/2,0,100)) + block_chance_modifier //So armour piercing blades can still be parried by other blades, for example
		if(l_hand.hit_reaction(src, attack_text, final_block_chance, damage, attack_type))
			return 1
	if(r_hand && !istype(r_hand, /obj/item/clothing))
		var/final_block_chance = r_hand.block_chance - (Clamp((armour_penetration-r_hand.armour_penetration)/2,0,100)) + block_chance_modifier //Need to reset the var so it doesn't carry over modifications between attempts
		if(r_hand.hit_reaction(src, attack_text, final_block_chance, damage, attack_type))
			return 1
	if(wear_suit)
		var/final_block_chance = wear_suit.block_chance - (Clamp((armour_penetration-wear_suit.armour_penetration)/2,0,100)) + block_chance_modifier
		if(wear_suit.hit_reaction(src, attack_text, final_block_chance, damage, attack_type))
			return 1
	if(w_uniform)
		var/final_block_chance = w_uniform.block_chance - (Clamp((armour_penetration-w_uniform.armour_penetration)/2,0,100)) + block_chance_modifier
		if(w_uniform.hit_reaction(src, attack_text, final_block_chance, damage, attack_type))
			return 1
	return 0


/mob/living/carbon/human/attacked_by(obj/item/I, mob/living/user)
	if(!I || !user)
		return 0

	var/obj/item/bodypart/affecting = get_bodypart(ran_zone(user.zone_selected))
	var/target_area = parse_zone(check_zone(user.zone_selected))
	feedback_add_details("item_used_for_combat","[I.type]|[I.force]")
	feedback_add_details("zone_targeted","[target_area]")

	// the attacked_by code varies among species
	return dna.species.spec_attacked_by(I, user, affecting, a_intent, target_area, src)

/mob/living/carbon/human/emp_act(severity)
	var/informed = 0
	for(var/obj/item/bodypart/L in src.bodyparts)
		if(L.status == ORGAN_ROBOTIC)
			if(!informed)
				src << "<span class='userdanger'>You feel a sharp pain as your robotic limbs overload.</span>"
				informed = 1
			switch(severity)
				if(1)
					L.take_damage(0,10)
					src.Stun(10)
				if(2)
					L.take_damage(0,5)
					src.Stun(5)
	..()

/mob/living/carbon/human/acid_act(acidpwr, toxpwr, acid_volume)
	var/list/damaged = list()
	var/list/inventory_items_to_kill = list()
	var/acidity = min(acidpwr*acid_volume/200, toxpwr)
	var/acid_volume_left = acid_volume
	var/acid_decay = 100/acidpwr // how much volume we lose per item we try to melt. 5 for fluoro, 10 for sulphuric

	//HEAD//
	var/obj/item/clothing/head_clothes = null
	if(glasses)
		head_clothes = glasses
	if(wear_mask)
		head_clothes = wear_mask
	if(head)
		head_clothes = head
	if(head_clothes)
		if(!head_clothes.unacidable)
			head_clothes.acid_act(acidpwr, acid_volume_left)
			acid_volume_left = max(acid_volume_left - acid_decay, 0) //We remove some of the acid volume.
			update_inv_glasses()
			update_inv_wear_mask()
			update_inv_head()
		else
			src << "<span class='notice'>Your [head_clothes.name] protects your head and face from the acid!</span>"
	else
		. = get_bodypart("head")
		if(.)
			damaged += .
		if(ears)
			inventory_items_to_kill += ears

	//CHEST//
	var/obj/item/clothing/chest_clothes = null
	if(w_uniform)
		chest_clothes = w_uniform
	if(wear_suit)
		chest_clothes = wear_suit
	if(chest_clothes)
		if(!chest_clothes.unacidable)
			chest_clothes.acid_act(acidpwr, acid_volume_left)
			acid_volume_left = max(acid_volume_left - acid_decay, 0)
			update_inv_w_uniform()
			update_inv_wear_suit()
		else
			src << "<span class='notice'>Your [chest_clothes.name] protects your body from the acid!</span>"
	else
		. = get_bodypart("chest")
		if(.)
			damaged += .
		if(wear_id)
			inventory_items_to_kill += wear_id
		if(r_store)
			inventory_items_to_kill += r_store
		if(l_store)
			inventory_items_to_kill += l_store
		if(s_store)
			inventory_items_to_kill += s_store


	//ARMS & HANDS//
	var/obj/item/clothing/arm_clothes = null
	if(gloves)
		arm_clothes = gloves
	if(w_uniform && (w_uniform.body_parts_covered & HANDS) || w_uniform && (w_uniform.body_parts_covered & ARMS))
		arm_clothes = w_uniform
	if(wear_suit && (wear_suit.body_parts_covered & HANDS) || wear_suit && (wear_suit.body_parts_covered & ARMS))
		arm_clothes = wear_suit
	if(arm_clothes)
		if(!arm_clothes.unacidable)
			arm_clothes.acid_act(acidpwr, acid_volume_left)
			acid_volume_left = max(acid_volume_left - acid_decay, 0)
			update_inv_gloves()
			update_inv_w_uniform()
			update_inv_wear_suit()
		else
			src << "<span class='notice'>Your [arm_clothes.name] protects your arms and hands from the acid!</span>"
	else
		. = get_bodypart("r_arm")
		if(.)
			damaged += .
		. = get_bodypart("l_arm")
		if(.)
			damaged += .


	//LEGS & FEET//
	var/obj/item/clothing/leg_clothes = null
	if(shoes)
		leg_clothes = shoes
	if(w_uniform && (w_uniform.body_parts_covered & FEET) || w_uniform && (w_uniform.body_parts_covered & LEGS))
		leg_clothes = w_uniform
	if(wear_suit && (wear_suit.body_parts_covered & FEET) || wear_suit && (wear_suit.body_parts_covered & LEGS))
		leg_clothes = wear_suit
	if(leg_clothes)
		if(!leg_clothes.unacidable)
			leg_clothes.acid_act(acidpwr, acid_volume_left)
			acid_volume_left = max(acid_volume_left - acid_decay, 0)
			update_inv_shoes()
			update_inv_w_uniform()
			update_inv_wear_suit()
		else
			src << "<span class='notice'>Your [leg_clothes.name] protects your legs and feet from the acid!</span>"
	else
		. = get_bodypart("r_leg")
		if(.)
			damaged += .
		. = get_bodypart("l_leg")
		if(.)
			damaged += .


	//DAMAGE//
	for(var/obj/item/bodypart/affecting in damaged)
		affecting.take_damage(acidity, 2*acidity)

		if(affecting.name == "head")
			if(prob(min(acidpwr*acid_volume/10, 90))) //Applies disfigurement
				affecting.take_damage(acidity, 2*acidity)
				emote("scream")
				facial_hair_style = "Shaved"
				hair_style = "Bald"
				update_hair()
				status_flags |= DISFIGURED

		update_damage_overlays()

	//MELTING INVENTORY ITEMS//
	//these items are all outside of armour visually, so melt regardless.
	if(back)
		inventory_items_to_kill += back
	if(belt)
		inventory_items_to_kill += belt
	if(r_hand)
		inventory_items_to_kill += r_hand
	if(l_hand)
		inventory_items_to_kill += l_hand

	for(var/obj/item/I in inventory_items_to_kill)
		I.acid_act(acidpwr, acid_volume_left)
		acid_volume_left = max(acid_volume_left - acid_decay, 0)


/mob/living/carbon/human/attack_animal(mob/living/simple_animal/M)
	if(..())
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		if(check_shields(damage, "the [M.name]", null, MELEE_ATTACK, M.armour_penetration))
			return 0
		var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
		var/obj/item/bodypart/affecting = get_bodypart(ran_zone(dam_zone))
		var/armor = run_armor_check(affecting, "melee")
		apply_damage(damage, M.melee_damage_type, affecting, armor, "", "", M.armour_penetration)
		updatehealth()


/mob/living/carbon/human/attack_larva(mob/living/carbon/alien/larva/L)

	if(..()) //successful larva bite.
		var/damage = rand(1, 3)
		if(check_shields(damage, "the [L.name]"))
			return 0
		if(stat != DEAD)
			L.amount_grown = min(L.amount_grown + damage, L.max_grown)
			var/obj/item/bodypart/affecting = get_bodypart(ran_zone(L.zone_selected))
			var/armor_block = run_armor_check(affecting, "melee")
			apply_damage(damage, BRUTE, affecting, armor_block)
			updatehealth()


/mob/living/carbon/human/attack_slime(mob/living/simple_animal/slime/M)
	if(..()) //successful slime attack
		var/damage = rand(5, 25)
		if(M.is_adult)
			damage = rand(10, 35)

		if(check_shields(damage, "the [M.name]"))
			return 0

		var/dam_zone = pick("head", "chest", "l_arm", "r_arm", "l_leg", "r_leg", "groin")

		var/obj/item/bodypart/affecting = get_bodypart(ran_zone(dam_zone))
		var/armor_block = run_armor_check(affecting, "melee")
		apply_damage(damage, BRUTE, affecting, armor_block)

/mob/living/carbon/human/mech_melee_attack(obj/mecha/M)

	if(M.occupant.a_intent == "harm")
		M.do_attack_animation(src)
		if(M.damtype == "brute")
			step_away(src,M,15)
		var/obj/item/bodypart/temp = get_bodypart(pick("chest", "chest", "chest", "head"))
		if(temp)
			var/update = 0
			switch(M.damtype)
				if("brute")
					if(M.force > 20)
						Paralyse(1)
					update |= temp.take_damage(rand(M.force/2, M.force), 0)
					playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
				if("fire")
					update |= temp.take_damage(0, rand(M.force/2, M.force))
					playsound(src, 'sound/items/Welder.ogg', 50, 1)
				if("tox")
					M.mech_toxin_damage(src)
				else
					return
			if(update)
				update_damage_overlays(0)
			updatehealth()

		visible_message("<span class='danger'>[M.name] has hit [src]!</span>", \
								"<span class='userdanger'>[M.name] has hit [src]!</span>")
		add_logs(M.occupant, src, "attacked", M, "(INTENT: [uppertext(M.occupant.a_intent)]) (DAMTYPE: [uppertext(M.damtype)])")

	else
		..()

/mob/living/carbon/human/hitby(atom/movable/AM, skipcatch = 0, hitpush = 1, blocked = 0)
	var/obj/item/I
	var/throwpower = 30
	if(istype(AM, /obj/item))
		I = AM
		throwpower = I.throwforce
		if(I.thrownby == src) //No throwing stuff at yourself to trigger hit reactions
			return ..()
	if(check_shields(throwpower, "\the [AM.name]", AM, THROWN_PROJECTILE_ATTACK))
		hitpush = 0
		skipcatch = 1
		blocked = 1
	else if(I)
		if(I.throw_speed >= EMBED_THROWSPEED_THRESHOLD)
			if(can_embed(I))
				if(prob(I.embed_chance) && !(dna && (PIERCEIMMUNE in dna.species.specflags)))
					throw_alert("embeddedobject", /obj/screen/alert/embeddedobject)
					var/obj/item/bodypart/L = pick(bodyparts)
					L.embedded_objects |= I
					I.add_mob_blood(src)//it embedded itself in you, of course it's bloody!
					I.loc = src
					L.take_damage(I.w_class*I.embedded_impact_pain_multiplier)
					visible_message("<span class='danger'>\the [I.name] embeds itself in [src]'s [L.name]!</span>","<span class='userdanger'>\the [I.name] embeds itself in your [L.name]!</span>")
					hitpush = 0
					skipcatch = 1 //can't catch the now embedded item

	return ..()

/mob/living/carbon/human/grabbedby(mob/living/carbon/user, supress_message = 0)
	if(user == src && pulling && !pulling.anchored && grab_state >= GRAB_AGGRESSIVE && iscarbon(pulling))
		vore_attack()
		world << "vore attack grab triggered"
	else
		world << "vore attack grab not triggered"
		..()

/mob/living/carbon/human/grippedby(mob/living/user)
	if(w_uniform)
		w_uniform.add_fingerprint(user)
	..()

/mob/living/carbon/human/Stun(amount, updating_canmove = 1)
	amount = dna.species.spec_stun(src,amount)
	..()