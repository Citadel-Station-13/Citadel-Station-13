/datum/species/vampire
	name = "Vampire"
	id = SPECIES_VAMPIRE
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,DRINKSBLOOD,HAS_FLESH,HAS_BONE)
	inherent_traits = list(TRAIT_NOHUNGER,TRAIT_NOBREATH,TRAIT_NOMARROW)
	inherent_biotypes = MOB_UNDEAD|MOB_HUMANOID
	mutant_bodyparts = list("mcolor" = "FFFFFF", "tail_human" = "None", "ears" = "None", "deco_wings" = "None")
	exotic_bloodtype = "U"
	use_skintones = USE_SKINTONES_GRAYSCALE_CUSTOM
	mutant_heart = /obj/item/organ/heart/vampire
	mutanttongue = /obj/item/organ/tongue/vampire
	blacklisted = TRUE
	limbs_id = SPECIES_HUMAN
	skinned_type = /obj/item/stack/sheet/animalhide/human
	var/info_text = "You are a <span class='danger'>Vampire</span>. You will slowly but constantly lose blood if outside of a coffin. If inside a coffin, you will slowly heal. You may gain more blood by grabbing a live victim and using your drain ability."
	species_category = SPECIES_CATEGORY_UNDEAD
	var/batform_enabled = TRUE

/datum/species/vampire/roundstart
	id = SPECIES_VAMPIRE_WEAK
	batform_enabled = FALSE

/datum/species/vampire/roundstart/check_roundstart_eligible()
	if(SSevents.holidays && SSevents.holidays[HALLOWEEN])
		return TRUE
	return FALSE

/datum/species/vampire/on_species_gain(mob/living/carbon/human/C, datum/species/old_species)
	. = ..()
	to_chat(C, "[info_text]")
	if(!C.dna.skin_tone_override)
		C.skin_tone = "albino"
	C.update_body(0)
	if(batform_enabled)
		var/obj/effect/proc_holder/spell/targeted/shapeshift/bat/B = new
		C.AddSpell(B)

/datum/species/vampire/on_species_loss(mob/living/carbon/C)
	. = ..()
	if(C.mind)
		for(var/S in C.mind.spell_list)
			var/obj/effect/proc_holder/spell/S2 = S
			if(S2.type == /obj/effect/proc_holder/spell/targeted/shapeshift/bat)
				C.mind.spell_list.Remove(S2)
				qdel(S2)

/datum/species/vampire/spec_life(mob/living/carbon/human/C)
	. = ..()
	if(istype(C.loc, /obj/structure/closet/crate/coffin))
		C.heal_overall_damage(4,4)
		C.adjustToxLoss(-4)
		C.adjustOxyLoss(-4)
		C.adjustCloneLoss(-4)
		return
	if(C.blood_volume > 0.5)
		C.blood_volume -= 0.5 //Will take roughly 19.5 minutes to die from standard blood volume, roughly 83 minutes to die from max blood volume.
	else
		C.dust(FALSE, TRUE)

	var/area/A = get_area(C)
	if(istype(A, /area/service/chapel) && C.mind?.assigned_role != "Chaplain")
		to_chat(C, "<span class='danger'>You don't belong here!</span>")
		C.adjustFireLoss(5)
		C.adjust_fire_stacks(6)
		C.IgniteMob()

/obj/item/organ/tongue/vampire
	name = "vampire tongue"
	actions_types = list(/datum/action/item_action/organ_action/vampire)
	color = "#1C1C1C"
	var/drain_cooldown = 0

#define VAMP_DRAIN_AMOUNT 50

/datum/action/item_action/organ_action/vampire
	name = "Drain Victim"
	desc = "Leech blood from any carbon victim you are passively grabbing."

/datum/action/item_action/organ_action/vampire/Trigger()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/H = owner
		var/obj/item/organ/tongue/vampire/V = target
		if(V.drain_cooldown >= world.time)
			to_chat(H, "<span class='notice'>You just drained blood, wait a few seconds.</span>")
			return
		if(H.pulling && iscarbon(H.pulling))
			var/mob/living/carbon/victim = H.pulling
			if(H.blood_volume >= BLOOD_VOLUME_MAXIMUM)
				to_chat(H, "<span class='notice'>You're already full!</span>")
				return
			//This checks whether or not they are wearing a garlic clove on their neck
			if(!blood_sucking_checks(victim, TRUE, FALSE))
				return
			if(victim.stat == DEAD)
				to_chat(H, "<span class='notice'>You need a living victim!</span>")
				return
			if(!victim.blood_volume || (victim.dna && ((NOBLOOD in victim.dna.species.species_traits) || victim.dna.species.exotic_blood)))
				to_chat(H, "<span class='notice'>[victim] doesn't have blood!</span>")
				return
			V.drain_cooldown = world.time + 30
			if(victim.anti_magic_check(FALSE, TRUE, FALSE, 0))
				to_chat(victim, "<span class='warning'>[H] tries to bite you, but stops before touching you!</span>")
				to_chat(H, "<span class='warning'>[victim] is blessed! You stop just in time to avoid catching fire.</span>")
				return
			//Here we check now for both the garlic cloves on the neck and for blood in the victims bloodstream.
			if(!blood_sucking_checks(victim, TRUE, TRUE))
				return
			if(!do_after(H, 30, target = victim))
				return
			var/blood_volume_difference = BLOOD_VOLUME_MAXIMUM - H.blood_volume //How much capacity we have left to absorb blood
			var/drained_blood = min(victim.blood_volume, VAMP_DRAIN_AMOUNT, blood_volume_difference)
			to_chat(victim, "<span class='danger'>[H] is draining your blood!</span>")
			to_chat(H, "<span class='notice'>You drain some blood!</span>")
			playsound(H, 'sound/items/drink.ogg', 30, 1, -2)
			victim.blood_volume = clamp(victim.blood_volume - drained_blood, 0, BLOOD_VOLUME_MAXIMUM)
			H.blood_volume = clamp(H.blood_volume + drained_blood, 0, BLOOD_VOLUME_MAXIMUM)
			if(!victim.blood_volume)
				to_chat(H, "<span class='warning'>You finish off [victim]'s blood supply!</span>")

#undef VAMP_DRAIN_AMOUNT


/mob/living/carbon/get_status_tab_items()
	. = ..()
	var/obj/item/organ/heart/vampire/darkheart = getorgan(/obj/item/organ/heart/vampire)
	if(darkheart)
		. += "Current blood level: [blood_volume]/[BLOOD_VOLUME_MAXIMUM]."


/obj/item/organ/heart/vampire
	name = "vampire heart"
	actions_types = list(/datum/action/item_action/organ_action/vampire_heart)
	color = "#1C1C1C"

/datum/action/item_action/organ_action/vampire_heart
	name = "Check Blood Level"
	desc = "Check how much blood you have remaining."

/datum/action/item_action/organ_action/vampire_heart/Trigger()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/H = owner
		to_chat(H, "<span class='notice'>Current blood level: [H.blood_volume]/[BLOOD_VOLUME_MAXIMUM].</span>")

/obj/effect/proc_holder/spell/targeted/shapeshift/bat
	name = "Bat Form"
	desc = "Take on the shape a space bat."
	invocation = "Squeak!"
	charge_max = 50
	cooldown_min = 50
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/bat
	var/ventcrawl_nude_only = TRUE
	var/transfer_name = TRUE

/obj/effect/proc_holder/spell/targeted/shapeshift/bat/Shapeshift(mob/living/caster)			//cit change
	var/obj/shapeshift_holder/H = locate() in caster
	if(H)
		to_chat(caster, "<span class='warning'>You're already shapeshifted!</span>")
		return

	if(!ishuman(caster))
		to_chat(caster, "<span class='warning'>You need to be humanoid to be able to do this!</span>")
		return

	var/mob/living/carbon/human/human_caster = caster
	var/mob/living/shape = new shapeshift_type(caster.loc)
	H = new(shape,src,human_caster)
	if(istype(H, /mob/living/simple_animal))
		var/mob/living/simple_animal/SA = H
		if((human_caster.blood_volume <= (BLOOD_VOLUME_BAD*human_caster.blood_ratio)) || (ventcrawl_nude_only && length(human_caster.get_equipped_items(include_pockets = TRUE))))
			SA.RemoveElement(/datum/element/ventcrawling, given_tier = VENTCRAWLER_ALWAYS)
	if(transfer_name)
		H.name = human_caster.name


	clothes_req = NONE
	mobs_whitelist = null
	mobs_blacklist = null

/obj/effect/proc_holder/spell/targeted/shapeshift/bat/cast(list/targets, mob/user = usr)
	if(!(locate(/obj/shapeshift_holder) in targets[1]))
		if(!ishuman(user))
			to_chat(user, "<span class='warning'>You need to be humanoid to be able to do this!</span>")
			return

		var/mob/living/carbon/human/human_user = user
		if(!(human_user.dna?.species?.id == SPECIES_VAMPIRE))
			to_chat(user, "<span class='warning'>You don't seem to be able to shapeshift..</span>")
			return
	return ..()
