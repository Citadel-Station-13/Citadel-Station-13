/obj/item/zombie_hand
	name = "zombie claw"
	desc = "A zombie's claw is its primary tool, capable of infecting \
		humans, butchering all other living things to \
		sustain the zombie, smashing open airlock doors and opening \
		child-safe caps on bottles."
	item_flags = ABSTRACT | DROPDEL
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	icon = 'icons/effects/blood.dmi'
	icon_state = "bloodhand_left"
	var/icon_left = "bloodhand_left"
	var/icon_right = "bloodhand_right"
	hitsound = 'sound/hallucinations/growl1.ogg'
	force = 18
	sharpness = SHARP_POINTY //it's a claw, they're sharp.
	damtype = "brute"
	total_mass = TOTAL_MASS_HAND_REPLACEMENT
	sharpness = SHARP_EDGED
	wound_bonus = -30
	bare_wound_bonus = 15

/obj/item/zombie_hand/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)

/obj/item/zombie_hand/equipped(mob/user, slot)
	. = ..()
	//these are intentionally inverted
	var/i = user.get_held_index_of_item(src)
	if(!(i % 2))
		icon_state = icon_left
	else
		icon_state = icon_right

/obj/item/zombie_hand/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(!proximity_flag)
		return
	else
		if(istype(target, /obj)) //do far more damage to non mobs so we can get through airlocks
			var/obj/target_object = target
			target_object.take_damage(force * 3, BRUTE, "melee", 0)
		else if(isliving(target))
			if(ishuman(target))
				try_to_zombie_infect(target)
			else
				check_feast(target, user)

/proc/try_to_zombie_infect(mob/living/carbon/human/target)
	CHECK_DNA_AND_SPECIES(target)

	if(NOZOMBIE in target.dna.species.species_traits)
		// cannot infect any NOZOMBIE subspecies (such as high functioning
		// zombies)
		return

	var/obj/item/organ/zombie_infection/infection
	infection = target.getorganslot(ORGAN_SLOT_ZOMBIE)
	if(!infection)
		infection = new()
		infection.Insert(target)

/obj/item/zombie_hand/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is ripping [user.p_their()] brains out! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	if(isliving(user))
		var/mob/living/L = user
		var/obj/item/bodypart/O = L.get_bodypart(BODY_ZONE_HEAD)
		if(O)
			O.dismember()
	return (BRUTELOSS)

/obj/item/zombie_hand/proc/check_feast(mob/living/target, mob/living/user)
	if(target.stat == DEAD)
		var/hp_gained = target.maxHealth
		target.gib()
		// zero as argument for no instant health update
		user.adjustBruteLoss(-hp_gained, 0)
		user.adjustToxLoss(-hp_gained, 0)
		user.adjustFireLoss(-hp_gained, 0)
		user.adjustCloneLoss(-hp_gained, 0)
		user.updatehealth()
		user.adjustOrganLoss(ORGAN_SLOT_BRAIN, -hp_gained) // Zom Bee gibbers "BRAAAAISNSs!1!"
		user.adjust_nutrition(hp_gained, NUTRITION_LEVEL_FULL)

/obj/item/paper/guides/antag/romerol_instructions
	info = "How to do necromancy with chemicals:<br>\
	<ul>\
	<li>Use a dropper or syringe (provided) to inject the Romerol (provided) into a target (not provided)</li>\
	<li>Wait for said target to die, or speed the process up by doing it yourself</li>\
	<li>Run away from the target, as they will be hostile when rising back up</li>\
	<li>Optionally: Inject chemical into foods and drinks to further spread possible infection</li>\
	<li>???</li>\
	<li>Complete assigned objectives amidst the chaos</li>\
	</ul>"