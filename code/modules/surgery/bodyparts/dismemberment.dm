
/obj/item/bodypart/proc/can_dismember(obj/item/I)
	if(dismemberable)
		return TRUE

//Dismember a limb
/obj/item/bodypart/proc/dismember(dam_type = BRUTE, silent=TRUE)
	if(!owner)
		return FALSE
	var/mob/living/carbon/C = owner
	if(!dismemberable)
		return FALSE
	if(C.status_flags & GODMODE)
		return FALSE
	if(HAS_TRAIT(C, TRAIT_NODISMEMBER))
		return FALSE
	var/obj/item/bodypart/affecting = C.get_bodypart(BODY_ZONE_CHEST)
	affecting.receive_damage(clamp(brute_dam/2 * affecting.body_damage_coeff, 15, 50), clamp(burn_dam/2 * affecting.body_damage_coeff, 0, 50), wound_bonus=CANT_WOUND) //Damage the chest based on limb's existing damage
	if(!silent)
		C.visible_message("<span class='danger'><B>[C]'s [name] is violently dismembered!</B></span>")
	C.emote("scream")
	SEND_SIGNAL(C, COMSIG_ADD_MOOD_EVENT, "dismembered", /datum/mood_event/dismembered)
	drop_limb()
	C.update_equipment_speed_mods() // Update in case speed affecting item unequipped by dismemberment

	C.bleed(40)

	if(QDELETED(src)) //Could have dropped into lava/explosion/chasm/whatever
		return TRUE
	if(dam_type == BURN)
		burn()
		return TRUE
	add_mob_blood(C)
	C.bleed(rand(20, 40))
	var/direction = pick(GLOB.cardinals)
	var/t_range = rand(2,max(throw_range/2, 2))
	var/turf/target_turf = get_turf(src)
	for(var/i in 1 to t_range-1)
		var/turf/new_turf = get_step(target_turf, direction)
		if(!new_turf)
			break
		target_turf = new_turf
		if(new_turf.density)
			break
	throw_at(target_turf, throw_range, throw_speed)
	return TRUE

/obj/item/bodypart/head/dismember()
	if(HAS_TRAIT(owner, TRAIT_NODECAP))
		return FALSE
	..()

/obj/item/bodypart/chest/dismember()
	if(!owner)
		return FALSE
	var/mob/living/carbon/C = owner
	if(!dismemberable)
		return FALSE
	if(HAS_TRAIT(C, TRAIT_NODISMEMBER))
		return FALSE
	if(HAS_TRAIT(C, TRAIT_NOGUT)) //Just for not allowing gutting
		return FALSE
	. = list()
	var/organ_spilled = 0
	var/turf/T = get_turf(C)
	C.bleed(50)
	playsound(get_turf(C), 'sound/misc/splort.ogg', 80, 1)
	for(var/X in C.internal_organs)
		var/obj/item/organ/O = X
		if(O.organ_flags & ORGAN_NO_DISMEMBERMENT || check_zone(O.zone) != BODY_ZONE_CHEST)
			continue
		O.Remove()
		O.forceMove(T)
		organ_spilled = 1
		. += X
	if(cavity_item)
		cavity_item.forceMove(T)
		. += cavity_item
		cavity_item = null
		organ_spilled = 1

	if(organ_spilled)
		C.visible_message("<span class='danger'><B>[C]'s internal organs spill out onto the floor!</B></span>")

//limb removal. The "special" argument is used for swapping a limb with a new one without the effects of losing a limb kicking in.
/obj/item/bodypart/proc/drop_limb(special, dismembered)
	if(!owner)
		return
	var/atom/Tsec = owner.drop_location()
	var/mob/living/carbon/C = owner
	SEND_SIGNAL(C, COMSIG_CARBON_REMOVE_LIMB, src, dismembered)
	update_limb(1)
	C.bodyparts -= src

	if(held_index)
		C.dropItemToGround(owner.get_item_for_held_index(held_index), 1)
		C.hand_bodyparts[held_index] = null

	for(var/thing in scars)
		var/datum/scar/S = thing
		S.victim = null
		LAZYREMOVE(owner.all_scars, S)

	for(var/thing in wounds)
		var/datum/wound/W = thing
		W.remove_wound(TRUE)

	owner = null

	for(var/X in C.surgeries) //if we had an ongoing surgery on that limb, we stop it.
		var/datum/surgery/S = X
		if(S.operated_bodypart == src)
			C.surgeries -= S
			qdel(S)
			break

	for(var/obj/item/I in embedded_objects)
		embedded_objects -= I
		I.forceMove(src)
		I.unembedded()
	if(!C.has_embedded_objects())
		C.clear_alert("embeddedobject")
		SEND_SIGNAL(C, COMSIG_CLEAR_MOOD_EVENT, "embedded")

	if(!special)
		if(C.dna)
			for(var/X in C.dna.mutations) //some mutations require having specific limbs to be kept.
				var/datum/mutation/human/MT = X
				if(MT.limb_req && MT.limb_req == body_zone)
					C.dna.force_lose(MT)

		for(var/X in C.internal_organs) //internal organs inside the dismembered limb are dropped.
			var/obj/item/organ/O = X
			var/org_zone = check_zone(O.zone)
			if(org_zone != body_zone)
				continue
			O.transfer_to_limb(src, C)

	update_icon_dropped()
	C.update_health_hud() //update the healthdoll
	C.update_body()
	C.update_hair()
	C.update_mobility()

	if(!Tsec)	// Tsec = null happens when a "dummy human" used for rendering icons on prefs screen gets its limbs replaced.
		qdel(src)
		return

	if(is_pseudopart)
		drop_organs(C)	//Psuedoparts shouldn't have organs, but just in case
		qdel(src)
		return

	forceMove(Tsec)

/**
  * get_mangled_state() is relevant for flesh and bone bodyparts, and returns whether this bodypart has mangled skin, mangled bone, or both (or neither i guess)
  *
  * Dismemberment for flesh and bone requires the victim to have the skin on their bodypart destroyed (either a critical cut or piercing wound), and at least a hairline fracture
  * (severe bone), at which point we can start rolling for dismembering. The attack must also deal at least 10 damage, and must be a brute attack of some kind (sorry for now, cakehat, maybe later)
  *
  * Returns: BODYPART_MANGLED_NONE if we're fine, BODYPART_MANGLED_FLESH if our skin is broken, BODYPART_MANGLED_BONE if our bone is broken, or BODYPART_MANGLED_BOTH if both are broken and we're up for dismembering
  */
/obj/item/bodypart/proc/get_mangled_state()
	. = BODYPART_MANGLED_NONE

	for(var/i in wounds)
		var/datum/wound/iter_wound = i
		if((iter_wound.wound_flags & MANGLES_BONE))
			. |= BODYPART_MANGLED_BONE
		if((iter_wound.wound_flags & MANGLES_FLESH))
			. |= BODYPART_MANGLED_FLESH

/**
  * try_dismember() is used, once we've confirmed that a flesh and bone bodypart has both the skin and bone mangled, to actually roll for it
  *
  * Mangling is described in the above proc, [/obj/item/bodypart/proc/get_mangled_state()]. This simply makes the roll for whether we actually dismember or not
  * using how damaged the limb already is, and how much damage this blow was for. If we have a critical bone wound instead of just a severe, we add +10% to the roll.
  * Lastly, we choose which kind of dismember we want based on the wounding type we hit with. Note we don't care about all the normal mods or armor for this
  *
  * Arguments:
  * * wounding_type: Either WOUND_BLUNT, WOUND_SLASH, or WOUND_PIERCE, basically only matters for the dismember message
  * * wounding_dmg: The damage of the strike that prompted this roll, higher damage = higher chance
  * * wound_bonus: Not actually used right now, but maybe someday
  * * bare_wound_bonus: ditto above
  */
/obj/item/bodypart/proc/try_dismember(wounding_type, wounding_dmg, wound_bonus, bare_wound_bonus)
	if(wounding_dmg < DISMEMBER_MINIMUM_DAMAGE)
		return

	var/base_chance = wounding_dmg + (get_damage() / max_damage * 50) // how much damage we dealt with this blow, + 50% of the damage percentage we already had on this bodypart
	if(locate(/datum/wound/blunt/critical) in wounds) // we only require a severe bone break, but if there's a critical bone break, we'll add 10% more
		base_chance += 10

	if(!prob(base_chance))
		return

	var/datum/wound/loss/dismembering = new
	dismembering.apply_dismember(src, wounding_type)

	return TRUE

//when a limb is dropped, the internal organs are removed from the mob and put into the limb
/obj/item/organ/proc/transfer_to_limb(obj/item/bodypart/LB, mob/living/carbon/C)
	Remove()
	forceMove(LB)

/obj/item/organ/brain/transfer_to_limb(obj/item/bodypart/head/LB, mob/living/carbon/human/C)
	Remove()	//Changeling brain concerns are now handled in Remove
	forceMove(LB)
	LB.brain = src
	if(brainmob)
		LB.brainmob = brainmob
		brainmob = null
		LB.brainmob.forceMove(LB)
		LB.brainmob.stat = DEAD

/obj/item/organ/eyes/transfer_to_limb(obj/item/bodypart/head/LB, mob/living/carbon/human/C)
	LB.eyes = src
	..()

/obj/item/bodypart/chest/drop_limb(special)
	if(special)
		..()

/obj/item/bodypart/r_arm/drop_limb(special)
	var/mob/living/carbon/C = owner
	..()
	if(C && !special)
		if(C.handcuffed)
			C.handcuffed.forceMove(drop_location())
			C.handcuffed.dropped(C)
			C.handcuffed = null
			C.update_handcuffed()
		if(C.hud_used)
			var/obj/screen/inventory/hand/R = C.hud_used.hand_slots["[held_index]"]
			if(R)
				R.update_icon()
		if(C.gloves)
			C.dropItemToGround(C.gloves, TRUE)
		C.update_inv_gloves() //to remove the bloody hands overlay


/obj/item/bodypart/l_arm/drop_limb(special)
	var/mob/living/carbon/C = owner
	..()
	if(C && !special)
		if(C.handcuffed)
			C.handcuffed.forceMove(drop_location())
			C.handcuffed.dropped(C)
			C.handcuffed = null
			C.update_handcuffed()
		if(C.hud_used)
			var/obj/screen/inventory/hand/L = C.hud_used.hand_slots["[held_index]"]
			if(L)
				L.update_icon()
		if(C.gloves)
			C.dropItemToGround(C.gloves, TRUE)
		C.update_inv_gloves() //to remove the bloody hands overlay


/obj/item/bodypart/r_leg/drop_limb(special)
	if(owner && !special)
		if(owner.legcuffed)
			owner.legcuffed.forceMove(owner.drop_location()) //At this point bodypart is still in nullspace
			owner.legcuffed.dropped(owner)
			owner.legcuffed = null
			owner.update_inv_legcuffed()
		if(owner.shoes)
			owner.dropItemToGround(owner.shoes, TRUE)
	..()

/obj/item/bodypart/l_leg/drop_limb(special) //copypasta
	if(owner && !special)
		if(owner.legcuffed)
			owner.legcuffed.forceMove(owner.drop_location())
			owner.legcuffed.dropped(owner)
			owner.legcuffed = null
			owner.update_inv_legcuffed()
		if(owner.shoes)
			owner.dropItemToGround(owner.shoes, TRUE)
	..()

/obj/item/bodypart/head/drop_limb(special)
	if(!special)
		//Drop all worn head items
		for(var/X in list(owner.glasses, owner.ears, owner.wear_mask, owner.head))
			var/obj/item/I = X
			owner.dropItemToGround(I, TRUE)

	owner.wash_cream() //clean creampie overlay

	//Handle dental implants
	for(var/datum/action/item_action/hands_free/activate_pill/AP in owner.actions)
		AP.Remove(owner)
		var/obj/pill = AP.target
		if(pill)
			pill.forceMove(src)

	//Make sure de-zombification happens before organ removal instead of during it
	var/obj/item/organ/zombie_infection/ooze = owner.getorganslot(ORGAN_SLOT_ZOMBIE)
	if(istype(ooze))
		ooze.transfer_to_limb(src, owner)

	name = "[owner.real_name]'s head"
	..()

//Attach a limb to a human and drop any existing limb of that type.
/obj/item/bodypart/proc/replace_limb(mob/living/carbon/C, special)
	if(!istype(C))
		return
	var/obj/item/bodypart/O = C.get_bodypart(body_zone)
	if(O)
		O.drop_limb(1)
	attach_limb(C, special)

/obj/item/bodypart/head/replace_limb(mob/living/carbon/C, special)
	if(!istype(C))
		return
	var/obj/item/bodypart/head/O = C.get_bodypart(body_zone)
	if(O)
		if(!special)
			return
		else
			O.drop_limb(1)
	attach_limb(C, special)

/obj/item/bodypart/proc/attach_limb(mob/living/carbon/C, special)
	moveToNullspace()
	owner = C
	C.bodyparts += src
	if(held_index)
		if(held_index > C.hand_bodyparts.len)
			C.hand_bodyparts.len = held_index
		C.hand_bodyparts[held_index] = src
		if(C.dna.species.mutanthands && !is_pseudopart)
			C.put_in_hand(new C.dna.species.mutanthands(), held_index)
		if(C.hud_used)
			var/obj/screen/inventory/hand/hand = C.hud_used.hand_slots["[held_index]"]
			if(hand)
				hand.update_icon()
		C.update_inv_gloves()

	if(special) //non conventional limb attachment
		for(var/X in C.surgeries) //if we had an ongoing surgery to attach a new limb, we stop it.
			var/datum/surgery/S = X
			var/surgery_zone = check_zone(S.location)
			if(surgery_zone == body_zone)
				C.surgeries -= S
				qdel(S)
				break

	for(var/obj/item/organ/O in contents)
		O.Insert(C)

	for(var/thing in scars)
		var/datum/scar/S = thing
		S.victim = C
		LAZYADD(C.all_scars, thing)

	for(var/i in wounds)
		var/datum/wound/W = i
		W.apply_wound(src, TRUE)

	update_bodypart_damage_state()
	update_disabled()

	C.updatehealth()
	C.update_body()
	C.update_hair()
	C.update_damage_overlays()
	C.update_mobility()

/obj/item/bodypart/head/attach_limb(mob/living/carbon/C, special)
	//Transfer some head appearance vars over
	if(brain)
		if(brainmob)
			brainmob.container = null //Reset brainmob head var.
			brainmob.forceMove(brain) //Throw mob into brain.
			brain.brainmob = brainmob //Set the brain to use the brainmob
			brainmob = null //Set head brainmob var to null
		brain.Insert(C) //Now insert the brain proper
		brain = null //No more brain in the head

	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.hair_color = hair_color
		H.hair_style = hair_style
		H.facial_hair_color = facial_hair_color
		H.facial_hair_style = facial_hair_style
		H.lip_style = lip_style
		H.lip_color = lip_color
	if(real_name)
		C.real_name = real_name
	real_name = ""
	name = initial(name)

	//Handle dental implants
	for(var/obj/item/reagent_containers/pill/P in src)
		for(var/datum/action/item_action/hands_free/activate_pill/AP in P.actions)
			P.forceMove(C)
			AP.Grant(C)
			break

	..()


//Regenerates all limbs. Returns amount of limbs regenerated
/mob/living/proc/regenerate_limbs(noheal = FALSE, list/excluded_limbs = list())
	SEND_SIGNAL(src, COMSIG_LIVING_REGENERATE_LIMBS, noheal, excluded_limbs)

/mob/living/carbon/regenerate_limbs(noheal = FALSE, list/excluded_limbs = list())
	. = ..()
	var/list/limb_list = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
	if(excluded_limbs.len)
		limb_list -= excluded_limbs
	for(var/Z in limb_list)
		. += regenerate_limb(Z, noheal)

/mob/living/proc/regenerate_limb(limb_zone, noheal)
	return

/mob/living/carbon/regenerate_limb(limb_zone, noheal)
	var/obj/item/bodypart/L
	if(get_bodypart(limb_zone))
		return FALSE
	L = newBodyPart(limb_zone, 0, 0)
	if(L)
		if(!noheal)
			L.brute_dam = 0
			L.burn_dam = 0
			L.brutestate = 0
			L.burnstate = 0
		var/datum/scar/scaries = new
		var/datum/wound/loss/phantom_loss = new // stolen valor, really
		scaries.generate(L, phantom_loss)
		L.attach_limb(src, 1)
		if(ROBOTIC_LIMBS in dna.species.species_traits) //Snowflake trait moment, but needed.
			L.change_bodypart_status(BODYPART_HYBRID, FALSE, TRUE) //Haha what if IPC-lings actually regenerated the right limbs instead of organic ones? That'd be pretty cool, right?
		return TRUE
