/datum/eldritch_knowledge/base_ash
	name = "Nightwatcher's Secret"
	desc = "Inducts you into the Path of Ash. Allows you to transmute a match with a spear into an ashen blade."
	gain_text = "The City Guard know their watch. If you ask them at night, they may tell you about the ashy lantern."
	banned_knowledge = list(/datum/eldritch_knowledge/base_rust,/datum/eldritch_knowledge/base_flesh,/datum/eldritch_knowledge/final/rust_final,/datum/eldritch_knowledge/final/flesh_final,/datum/eldritch_knowledge/final/void_final,/datum/eldritch_knowledge/base_void)
	next_knowledge = list(/datum/eldritch_knowledge/ashen_grasp)
	required_atoms = list(/obj/item/spear,/obj/item/match)
	result_atoms = list(/obj/item/melee/sickly_blade/ash)
	cost = 0
	route = PATH_ASH

/datum/eldritch_knowledge/spell/ashen_shift
	name = "Ashen Shift"
	gain_text = "The Nightwatcher was the first of them, his treason started it all."
	desc = "A short range jaunt that can help you escape from bad situations."
	cost = 1
	spell_to_add = /obj/effect/proc_holder/spell/targeted/ethereal_jaunt/shift/ash
	next_knowledge = list(/datum/eldritch_knowledge/ash_mark,/datum/eldritch_knowledge/essence,/datum/eldritch_knowledge/ashen_eyes)
	route = PATH_ASH

/datum/eldritch_knowledge/ashen_grasp
	name = "Grasp of Ash"
	gain_text = "He knew how to walk between the planes."
	desc = "Empowers your mansus grasp to knock enemies down and throw them away."
	cost = 1
	next_knowledge = list(/datum/eldritch_knowledge/spell/ashen_shift)
	route = PATH_ASH

/datum/eldritch_knowledge/ashen_grasp/on_mansus_grasp(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!iscarbon(target))
		return

	var/mob/living/carbon/C = target
	var/datum/status_effect/eldritch/E = C.has_status_effect(/datum/status_effect/eldritch/rust) || C.has_status_effect(/datum/status_effect/eldritch/ash) || C.has_status_effect(/datum/status_effect/eldritch/flesh) || C.has_status_effect(/datum/status_effect/eldritch/void)
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
	gain_text = "Piercing eyes, guide me through the mundane."
	desc = "Allows you to craft thermal vision amulet by transmutating eyes with a glass shard."
	cost = 1
	next_knowledge = list(/datum/eldritch_knowledge/spell/ashen_shift,/datum/eldritch_knowledge/flesh_ghoul)
	required_atoms = list(/obj/item/organ/eyes,/obj/item/shard)
	result_atoms = list(/obj/item/clothing/neck/eldritch_amulet)

/datum/eldritch_knowledge/ash_mark
	name = "Mark of Ash"
	gain_text = "The Nightwatcher was a very particular man, always watching in the dead of night. But in spite of his duty, he regularly tranced through the manse with his blazing lantern held high."
	desc = "Your Mansus Grasp now applies the Mark of Ash on hit. Attack the afflicted with your Sickly Blade to detonate the mark. Upon detonation, the Mark of Ash causes stamina damage and burn damage, and spreads to an additional nearby opponent. The damage decreases with each spread."
	cost = 2
	next_knowledge = list(/datum/eldritch_knowledge/mad_mask)
	banned_knowledge = list(/datum/eldritch_knowledge/rust_mark,/datum/eldritch_knowledge/flesh_mark,/datum/eldritch_knowledge/void_mark)
	route = PATH_ASH

/datum/eldritch_knowledge/ash_mark/on_eldritch_blade(target,user,proximity_flag,click_parameters)
	. = ..()
	if(isliving(target))
		var/mob/living/living_target = target
		living_target.apply_status_effect(/datum/status_effect/eldritch/ash,5)

/datum/eldritch_knowledge/mad_mask
	name = "Mask of Madness"
	gain_text = "He walks the world, unnoticed by the masses."
	desc = "Allows you to transmute any mask, with a candle and a pair of eyes, to create a mask of madness, It causes passive stamina damage to everyone around the wearer and hallucinations, can be forced on a non believer to make him unable to take it off..."
	cost = 1
	result_atoms = list(/obj/item/clothing/mask/void_mask)
	required_atoms = list(/obj/item/organ/eyes,/obj/item/clothing/mask,/obj/item/candle)
	next_knowledge = list(/datum/eldritch_knowledge/curse/corrosion,/datum/eldritch_knowledge/ash_blade_upgrade,/datum/eldritch_knowledge/curse/paralysis)
	route = PATH_ASH

/datum/eldritch_knowledge/spell/flame_birth
	name = "Fiery Rebirth"
	gain_text = "The Nightwatcher was a man of principles, and yet his power arose from the chaos he vowed to combat."
	desc = "Drains nearby alive people that are engulfed in flames. It heals 10 of each damage type per person. If a target is in critical condition it drains the last of their vitality, killing them."
	cost = 1
	spell_to_add = /obj/effect/proc_holder/spell/targeted/fiery_rebirth
	next_knowledge = list(/datum/eldritch_knowledge/spell/cleave,/datum/eldritch_knowledge/summon/ashy,/datum/eldritch_knowledge/flame_immunity)
	route = PATH_ASH

/datum/eldritch_knowledge/flame_immunity
	name = "Nightwatcher's Blessing"
	gain_text = "The True Light will destroy and make something anew of any individual. If only they accepted it."
	desc = "Becoming one with the ash, you become immune to fire and heat, allowing you to thrive in a more extreme environment.."
	cost = 2
	next_knowledge = list(/datum/eldritch_knowledge/spell/nightwatchers_rite)
	route = PATH_ASH
	var/list/trait_list = list(TRAIT_RESISTHEAT,TRAIT_NOFIRE)

/datum/eldritch_knowledge/flame_immunity/on_gain(mob/living/user)
	to_chat(user, "<span class='warning'>[gain_text]</span>")
	for(var/X in trait_list)
		ADD_TRAIT(user,X,MAGIC_TRAIT)

/datum/eldritch_knowledge/spell/nightwatchers_rite
	name = "Nightwatcher's Rite"
	gain_text = "When the Glory of the Lantern scorches and sears their skin, nothing will protect them from the ashes."
	desc = "Fire off five streams of fire from your hand, each setting ablaze targets hit and scorching them upon contact."
	cost = 2
	sacs_needed = 3
	spell_to_add = /obj/effect/proc_holder/spell/pointed/nightwatchers_rite
	next_knowledge = list(/datum/eldritch_knowledge/final/ash_final)
	route = PATH_ASH

/datum/eldritch_knowledge/spell/nightwatchers_rite/on_gain(mob/user)
	. = ..()
	priority_announce("Large heat signatures discovered!  A swelling fiery horror is coming..", sound = 'sound/misc/notice1.ogg')

/datum/eldritch_knowledge/ash_blade_upgrade
	name = "Fiery Blade"
	gain_text = "Blade in hand, he swung and swung as the ash fell from the skies. His city, his people... all burnt to cinders, and yet life still remained in his charred body."
	desc = "Your blade of choice will now light your enemies ablaze."
	cost = 2
	next_knowledge = list(/datum/eldritch_knowledge/spell/flame_birth)
	banned_knowledge = list(/datum/eldritch_knowledge/rust_blade_upgrade,/datum/eldritch_knowledge/flesh_blade_upgrade,/datum/eldritch_knowledge/void_blade_upgrade)
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
	desc = "Curse someone for 2 minutes of vomiting and major organ damage. Using a wirecutter, a pool of blood, a heart, left arm and a right arm, and an item that the victim touched  with their bare hands."
	cost = 1
	required_atoms = list(/obj/item/wirecutters,/obj/effect/decal/cleanable/blood,/obj/item/organ/heart,/obj/item/bodypart/l_arm,/obj/item/bodypart/r_arm)
	next_knowledge = list(/datum/eldritch_knowledge/mad_mask,/datum/eldritch_knowledge/spell/area_conversion)
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
	desc = "Curse someone for 5 minutes of inability to walk. Sacrifice a knife, a pool of blood, a pair of legs, a hatchet and an item that the victim touched with their bare hands. "
	cost = 1
	required_atoms = list(/obj/item/kitchen/knife,/obj/effect/decal/cleanable/blood,/obj/item/bodypart/l_leg,/obj/item/bodypart/r_leg,/obj/item/hatchet)
	next_knowledge = list(/datum/eldritch_knowledge/mad_mask,/datum/eldritch_knowledge/summon/raw_prophet)
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
	gain_text = "At first I didn't understand these instruments of war, but the priest told me to use them regardless. Soon, he said, I would know them well."
	desc = "Grants a spell that will inflict wounds and bleeding upon the target, as well as in a short radius around them."
	cost = 1
	spell_to_add = /obj/effect/proc_holder/spell/pointed/cleave
	next_knowledge = list(/datum/eldritch_knowledge/spell/entropic_plume,/datum/eldritch_knowledge/spell/flame_birth)

/datum/eldritch_knowledge/final/ash_final
	name = "Ashlord's Rite"
	gain_text = "The Nightwatcher found the rite and shared it amongst mankind! For now I am one with the fire, WITNESS MY ASCENSION!"
	desc = "Bring 3 corpses onto a transmutation rune, you will become immune to fire, the vacuum of space, cold and other enviromental hazards and become overall sturdier to all other damages. You will gain a spell that passively creates ring of fire around you as well ,as you will gain a powerful ability that lets you create a wave of flames all around you."
	required_atoms = list(/mob/living/carbon/human)
	cost = 5
	sacs_needed = 8
	route = PATH_ASH
	var/list/trait_list = list(TRAIT_NOBREATH,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE)

/datum/eldritch_knowledge/final/ash_final/on_finished_recipe(mob/living/user, list/atoms, loc)
	priority_announce("$^@&#*$^@(#&$(@&#^$&#^@# Fear the blaze, for the Ashlord, [user.real_name] has ascended! The flames shall consume all! $^@&#*$^@(#&$(@&#^$&#^@#","#$^@&#*$^@(#&$(@&#^$&#^@#", 'sound/announcer/classic/spanomalies.ogg')
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/fire_cascade/big)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/fire_sworn)
	var/mob/living/carbon/human/H = user
	H.physiology.brute_mod *= 0.5
	H.physiology.burn_mod *= 0.5
	var/datum/antagonist/heretic/ascension = H.mind.has_antag_datum(/datum/antagonist/heretic)
	ascension.ascended = TRUE
	H.client?.give_award(/datum/award/achievement/misc/ash_ascension, H)
	for(var/X in trait_list)
		ADD_TRAIT(user,X,MAGIC_TRAIT)
	return ..()
