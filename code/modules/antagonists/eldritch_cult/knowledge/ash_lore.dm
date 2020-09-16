/datum/eldritch_knowledge/base_ash
	name = "Nightwatcher's Secret"
	desc = "Inducts you into the Path of Ash. Allows you to transmute a match with an eldritch blade into an ashen blade."
	gain_text = "The City guard knows their watch. If you ask them at night they may tell you about the ashy lantern."
	banned_knowledge = list(/datum/eldritch_knowledge/base_rust,/datum/eldritch_knowledge/base_flesh,/datum/eldritch_knowledge/final/rust_final,/datum/eldritch_knowledge/final/flesh_final)
	next_knowledge = list(/datum/eldritch_knowledge/ashen_grasp)
	required_atoms = list(/obj/item/melee/sickly_blade,/obj/item/match)
	result_atoms = list(/obj/item/melee/sickly_blade/ash)
	cost = 1
	route = PATH_ASH

/datum/eldritch_knowledge/spell/ashen_shift
	name = "Ashen Shift"
	gain_text = "Ash is all the same, how can one man master it all?"
	desc = "A short range jaunt that will enable you to escape from danger."
	cost = 1
	spell_to_add = /obj/effect/proc_holder/spell/targeted/ethereal_jaunt/shift/ash
	next_knowledge = list(/datum/eldritch_knowledge/ash_mark,/datum/eldritch_knowledge/essence,/datum/eldritch_knowledge/ashen_eyes)
	route = PATH_ASH

/datum/eldritch_knowledge/ashen_grasp
	name = "Grasp of Ash"
	gain_text = "Gates have opened, minds have flooded, yet I remain."
	desc = "Empowers your mansus grasp to knock enemies down and throw them away."
	cost = 1
	next_knowledge = list(/datum/eldritch_knowledge/spell/ashen_shift)
	route = PATH_ASH

/datum/eldritch_knowledge/ashen_grasp/on_mansus_grasp(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!iscarbon(target))
		return

	var/mob/living/carbon/C = target
	var/datum/status_effect/eldritch/E = C.has_status_effect(/datum/status_effect/eldritch/rust) || C.has_status_effect(/datum/status_effect/eldritch/ash) || C.has_status_effect(/datum/status_effect/eldritch/flesh)
	if(E)
		. = TRUE
		E.on_effect()
		for(var/X in user.mind.spell_list)
			if(!istype(X,/obj/effect/proc_holder/spell/targeted/touch/mansus_grasp))
				continue
			var/obj/effect/proc_holder/spell/targeted/touch/mansus_grasp/MG = X
			MG.charge_counter = min(round(MG.charge_counter + MG.charge_max * 0.75),MG.charge_max) // refunds 75% of charge.
	var/atom/throw_target = get_edge_target_turf(C, user.dir)
	if(!C.anchored)
		. = TRUE
		C.throw_at(throw_target, rand(4,8), 14, user)
	return

/datum/eldritch_knowledge/ashen_eyes
	name = "Ashen Eyes"
	gain_text = "Piercing eyes may guide me through the mundane."
	desc = "Allows you to craft thermal vision amulet by transmutating eyes with a glass shard."
	cost = 1
	next_knowledge = list(/datum/eldritch_knowledge/spell/ashen_shift,/datum/eldritch_knowledge/flesh_ghoul)
	required_atoms = list(/obj/item/organ/eyes,/obj/item/shard)
	result_atoms = list(/obj/item/clothing/neck/eldritch_amulet)

/datum/eldritch_knowledge/ash_mark
	name = "Mark of Ash"
	gain_text = "Spread the famine."
	desc = "Your sickly blade now applies ash mark on hit. Use your mansus grasp to proc the mark. Mark of Ash causes stamina damage, and fire loss, and spreads to a nearby carbon. Damage decreases with how many times the mark has spread."
	cost = 2
	next_knowledge = list(/datum/eldritch_knowledge/curse/blindness)
	banned_knowledge = list(/datum/eldritch_knowledge/rust_mark,/datum/eldritch_knowledge/flesh_mark)
	route = PATH_ASH

/datum/eldritch_knowledge/ash_mark/on_eldritch_blade(target,user,proximity_flag,click_parameters)
	. = ..()
	if(isliving(target))
		var/mob/living/living_target = target
		living_target.apply_status_effect(/datum/status_effect/eldritch/ash,5)

/datum/eldritch_knowledge/curse/blindness
	name = "Curse of Blindness"
	gain_text = "The blind man walks through the world, unnoticed by the masses."
	desc = "Curse someone with 2 minutes of complete blindness by sacrificing a pair of eyes, a screwdriver and a pool of blood, with an object that the victim has touched with their bare hands."
	cost = 1
	required_atoms = list(/obj/item/organ/eyes,/obj/item/screwdriver,/obj/effect/decal/cleanable/blood)
	next_knowledge = list(/datum/eldritch_knowledge/curse/corrosion,/datum/eldritch_knowledge/ash_blade_upgrade,/datum/eldritch_knowledge/curse/paralysis)
	timer = 2 MINUTES
	route = PATH_ASH

/datum/eldritch_knowledge/curse/blindness/curse(mob/living/chosen_mob)
	. = ..()
	chosen_mob.become_blind(MAGIC_TRAIT)

/datum/eldritch_knowledge/curse/blindness/uncurse(mob/living/chosen_mob)
	. = ..()
	chosen_mob.cure_blind(MAGIC_TRAIT)

/datum/eldritch_knowledge/spell/flame_birth
	name = "Fiery Rebirth"
	gain_text = "Nightwatcher was a man of principles, and yet he arose from the chaos he vowed to protect from."
	desc = "Drains nearby alive people that are engulfed in flames. It heals 10 of each damage type per person. If a person is in critical condition it finishes them off."
	cost = 1
	spell_to_add = /obj/effect/proc_holder/spell/targeted/fiery_rebirth
	next_knowledge = list(/datum/eldritch_knowledge/spell/cleave,/datum/eldritch_knowledge/summon/ashy,/datum/eldritch_knowledge/final/ash_final)
	route = PATH_ASH

/datum/eldritch_knowledge/ash_blade_upgrade
	name = "Blazing Steel"
	gain_text = "May the sun burn the heretics."
	desc = "Your blade of choice will now add firestacks."
	cost = 2
	next_knowledge = list(/datum/eldritch_knowledge/spell/flame_birth)
	banned_knowledge = list(/datum/eldritch_knowledge/rust_blade_upgrade,/datum/eldritch_knowledge/flesh_blade_upgrade)
	route = PATH_ASH

/datum/eldritch_knowledge/ash_blade_upgrade/on_eldritch_blade(target,user,proximity_flag,click_parameters)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		C.adjust_fire_stacks(1)
		C.IgniteMob()

/datum/eldritch_knowledge/curse/corrosion
	name = "Curse of Corrosion"
	gain_text = "Cursed land, cursed man, cursed mind."
	desc = "Curse someone for 2 minutes of vomiting and major organ damage. Using a wirecutter, a spill of blood, a heart, left arm and a right arm, and an item that the victim touched  with their bare hands."
	cost = 1
	required_atoms = list(/obj/item/wirecutters,/obj/effect/decal/cleanable/blood,/obj/item/organ/heart,/obj/item/bodypart/l_arm,/obj/item/bodypart/r_arm)
	next_knowledge = list(/datum/eldritch_knowledge/curse/blindness,/datum/eldritch_knowledge/spell/area_conversion)
	timer = 2 MINUTES

/datum/eldritch_knowledge/curse/corrosion/curse(mob/living/chosen_mob)
	. = ..()
	chosen_mob.apply_status_effect(/datum/status_effect/corrosion_curse)

/datum/eldritch_knowledge/curse/corrosion/uncurse(mob/living/chosen_mob)
	. = ..()
	chosen_mob.remove_status_effect(/datum/status_effect/corrosion_curse)

/datum/eldritch_knowledge/curse/paralysis
	name = "Curse of Paralysis"
	gain_text = "Corrupt their flesh, make them bleed."
	desc = "Curse someone for 5 minutes of inability to walk. Using a knife, pool of blood, left leg, right leg, a hatchet and an item that the victim touched  with their bare hands. "
	cost = 1
	required_atoms = list(/obj/item/kitchen/knife,/obj/effect/decal/cleanable/blood,/obj/item/bodypart/l_leg,/obj/item/bodypart/r_leg,/obj/item/hatchet)
	next_knowledge = list(/datum/eldritch_knowledge/curse/blindness,/datum/eldritch_knowledge/summon/raw_prophet)
	timer = 5 MINUTES

/datum/eldritch_knowledge/curse/paralysis/curse(mob/living/chosen_mob)
	. = ..()
	ADD_TRAIT(chosen_mob,TRAIT_PARALYSIS_L_LEG,MAGIC_TRAIT)
	ADD_TRAIT(chosen_mob,TRAIT_PARALYSIS_R_LEG,MAGIC_TRAIT)
	chosen_mob.update_mobility()

/datum/eldritch_knowledge/curse/paralysis/uncurse(mob/living/chosen_mob)
	. = ..()
	REMOVE_TRAIT(chosen_mob,TRAIT_PARALYSIS_L_LEG,MAGIC_TRAIT)
	REMOVE_TRAIT(chosen_mob,TRAIT_PARALYSIS_R_LEG,MAGIC_TRAIT)
	chosen_mob.update_mobility()

/datum/eldritch_knowledge/spell/cleave
	name = "Blood Cleave"
	gain_text = "At first I was unfamiliar with these instruments of war, but the priest told me how to use them."
	desc = "Grants a spell that will inflict wounds and bleeding upon the target, as well as in a short radius around them."
	cost = 1
	spell_to_add = /obj/effect/proc_holder/spell/pointed/cleave
	next_knowledge = list(/datum/eldritch_knowledge/spell/entropic_plume,/datum/eldritch_knowledge/spell/flame_birth)

/datum/eldritch_knowledge/final/ash_final
	name = "Ashlord's Rite"
	gain_text = "The forgotten lords have spoken! The Lord of Ash has come! Fear the flame!"
	desc = "Bring three corpses onto a transmutation rune, after ascending you will become immune to fire, space, temperature and other environmental hazards. You will develop resistance to all other damages. You will be granted two spells, one which can bring forth a cascade of massive fire, and another which will surround your body in precious flames for a minute."
	required_atoms = list(/mob/living/carbon/human)
	cost = 5
	route = PATH_ASH
	var/list/trait_list = list(TRAIT_RESISTHEAT,TRAIT_NOBREATH,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_NOFIRE,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_PIERCEIMMUNE,TRAIT_NODISMEMBER,TRAIT_BOMBIMMUNE)

/datum/eldritch_knowledge/final/ash_final/on_finished_recipe(mob/living/user, list/atoms, loc)
	priority_announce("$^@&#*$^@(#&$(@&#^$&#^@# Fear the blaze, for Ashbringer [user.real_name] has come! $^@&#*$^@(#&$(@&#^$&#^@#","#$^@&#*$^@(#&$(@&#^$&#^@#", 'sound/announcer/classic/spanomalies.ogg')
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/fire_cascade/big)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/fire_sworn)
	var/mob/living/carbon/human/H = user
	H.physiology.brute_mod *= 0.5
	H.physiology.burn_mod *= 0.5
	var/datum/antagonist/heretic/ascension = H.mind.has_antag_datum(/datum/antagonist/heretic)
	ascension.ascended = TRUE
	for(var/X in trait_list)
		ADD_TRAIT(user,X,MAGIC_TRAIT)
	return ..()
