/datum/eldritch_knowledge/base_rust
	name = "Blacksmith's Tale"
	desc = "Inducts you into the Path of Rust. Allows you to transmute an eldritch blade with any trash item into a Blade of Rust."
	gain_text = "'Let me tell you a story,' The Blacksmith said as he gazed into his rusty blade."
	banned_knowledge = list(/datum/eldritch_knowledge/base_ash,/datum/eldritch_knowledge/base_flesh,/datum/eldritch_knowledge/final/ash_final,/datum/eldritch_knowledge/final/flesh_final)
	next_knowledge = list(/datum/eldritch_knowledge/rust_fist)
	required_atoms = list(/obj/item/melee/sickly_blade,/obj/item/trash)
	result_atoms = list(/obj/item/melee/sickly_blade/rust)
	cost = 1
	route = PATH_RUST

/datum/eldritch_knowledge/rust_fist
	name = "Grasp of Rust"
	desc = "Empowers your Mansus Grasp to deal 500 damage to non-living matter and rust any structure it touches. Destroys already rusted structures."
	gain_text = "Rust grows on the ceiling of the mansus."
	cost = 1
	next_knowledge = list(/datum/eldritch_knowledge/rust_regen)
	var/rust_force = 500
	var/static/list/blacklisted_turfs = typecacheof(list(/turf/closed,/turf/open/space,/turf/open/lava,/turf/open/chasm,/turf/open/floor/plating/rust))
	route = PATH_RUST

/datum/eldritch_knowledge/rust_fist/on_mansus_grasp(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/datum/status_effect/eldritch/E = H.has_status_effect(/datum/status_effect/eldritch/rust) || H.has_status_effect(/datum/status_effect/eldritch/ash) || H.has_status_effect(/datum/status_effect/eldritch/flesh)
		if(E)
			E.on_effect()
			H.adjustOrganLoss(pick(ORGAN_SLOT_BRAIN,ORGAN_SLOT_EARS,ORGAN_SLOT_EYES,ORGAN_SLOT_LIVER,ORGAN_SLOT_LUNGS,ORGAN_SLOT_STOMACH,ORGAN_SLOT_HEART),25)
	else
		for(var/X in user.mind.spell_list)
			if(!istype(X,/obj/effect/proc_holder/spell/targeted/touch/mansus_grasp))
				continue
			var/obj/effect/proc_holder/spell/targeted/touch/mansus_grasp/MG = X
			MG.charge_counter = min(round(MG.charge_counter + MG.charge_max * 0.75),MG.charge_max)
	target.rust_heretic_act()
	return TRUE

/datum/eldritch_knowledge/spell/area_conversion
	name = "Aggressive Spread"
	desc = "Spreads rust to nearby turfs. Destroys already rusted walls."
	gain_text = "All wise men know not to touch the bound king."
	cost = 1
	spell_to_add = /obj/effect/proc_holder/spell/aoe_turf/rust_conversion
	next_knowledge = list(/datum/eldritch_knowledge/rust_blade_upgrade,/datum/eldritch_knowledge/curse/corrosion,/datum/eldritch_knowledge/spell/blood_siphon,/datum/eldritch_knowledge/spell/rust_wave)
	route = PATH_RUST

/datum/eldritch_knowledge/spell/rust_wave
	name = "Patron's Reach"
	desc = "You can now send a bolt of rust that corrupts the immediate area, and poisons the first target hit."
	gain_text = "Messengers of hope fear the Rustbringer."
	cost = 1
	spell_to_add = /obj/effect/proc_holder/spell/aimed/rust_wave
	route = PATH_RUST

/datum/eldritch_knowledge/rust_regen
	name = "Leeching Walk"
	desc = "Passively heals you when you are on rusted tiles."
	gain_text = "'The strength was unparalleled, unnatural.' The Blacksmith was smiling."
	cost = 1
	next_knowledge = list(/datum/eldritch_knowledge/rust_mark,/datum/eldritch_knowledge/armor,/datum/eldritch_knowledge/essence)
	route = PATH_RUST

/datum/eldritch_knowledge/rust_regen/on_life(mob/user)
	. = ..()
	var/turf/user_loc_turf = get_turf(user)
	if(!istype(user_loc_turf, /turf/open/floor/plating/rust) || !isliving(user))
		return
	var/mob/living/living_user = user
	living_user.adjustBruteLoss(-3, FALSE)
	living_user.adjustFireLoss(-3, FALSE)
	living_user.adjustToxLoss(-3, FALSE, TRUE)
	living_user.adjustOxyLoss(-1, FALSE)
	living_user.adjustStaminaLoss(-6)

/datum/eldritch_knowledge/rust_mark
	name = "Mark of Rust"
	desc = "Your eldritch blade now applies a rust mark. Rust marks have a chance to deal between 0 to 200 damage to 75% of enemies items. To activate the mark use your Mansus Grasp on it."
	gain_text = "Lords of the depths help those in dire need at a cost."
	cost = 2
	next_knowledge = list(/datum/eldritch_knowledge/spell/area_conversion)
	banned_knowledge = list(/datum/eldritch_knowledge/ash_mark,/datum/eldritch_knowledge/flesh_mark)
	route = PATH_RUST

/datum/eldritch_knowledge/rust_mark/on_eldritch_blade(target,user,proximity_flag,click_parameters)
	. = ..()
	if(isliving(target))
		var/mob/living/living_target = target
		living_target.apply_status_effect(/datum/status_effect/eldritch/rust)

/datum/eldritch_knowledge/rust_blade_upgrade
	name = "Toxic Steel"
	gain_text = "Let the blade guide you through the flesh."
	desc = "Your blade of choice will now add toxin to enemies bloodstream."
	cost = 2
	next_knowledge = list(/datum/eldritch_knowledge/spell/entropic_plume)
	banned_knowledge = list(/datum/eldritch_knowledge/ash_blade_upgrade,/datum/eldritch_knowledge/flesh_blade_upgrade)
	route = PATH_RUST

/datum/eldritch_knowledge/rust_blade_upgrade/on_eldritch_blade(mob/target,user,proximity_flag,click_parameters)
	. = ..()
	if(!IS_HERETIC(target))
		if(iscarbon(target))
			var/mob/living/carbon/carbon_target = target
			carbon_target.reagents.add_reagent(/datum/reagent/eldritch, 5)

/datum/eldritch_knowledge/spell/entropic_plume
	name = "Entropic Plume"
	desc = "You can now send a befuddling plume that blinds, poisons and makes enemies strike each other, while also converting the immediate area into rust."
	gain_text = "If they knew, the truth would turn them against eachother."
	cost = 1
	spell_to_add = /obj/effect/proc_holder/spell/cone/staggered/entropic_plume
	next_knowledge = list(/datum/eldritch_knowledge/rust_fist_upgrade,/datum/eldritch_knowledge/spell/cleave,/datum/eldritch_knowledge/summon/rusty)
	route = PATH_RUST

/datum/eldritch_knowledge/armor
	name = "Armorer's Ritual"
	desc = "You can now create eldritch armor using a built table and a gas mask on top of a transmutation rune."
	gain_text = "For I am the heir to the throne of doom."
	cost = 1
	next_knowledge = list(/datum/eldritch_knowledge/rust_regen,/datum/eldritch_knowledge/flesh_ghoul)
	required_atoms = list(/obj/structure/table,/obj/item/clothing/mask/gas)
	result_atoms = list(/obj/item/clothing/suit/hooded/cultrobes/eldritch)

/datum/eldritch_knowledge/essence
	name = "Priest's Ritual"
	desc = "You can now transmute a tank of water into a bottle of eldritch fluid."
	gain_text = "This is an old recipe, I got it from an owl."
	cost = 1
	next_knowledge = list(/datum/eldritch_knowledge/rust_regen,/datum/eldritch_knowledge/spell/ashen_shift)
	required_atoms = list(/obj/structure/reagent_dispensers/watertank)
	result_atoms = list(/obj/item/reagent_containers/glass/beaker/eldritch)

/datum/eldritch_knowledge/rust_fist_upgrade
	name = "Vile Grip"
	desc = "Empowers your Mansus Grasp further, sickening your foes and making them vomit, while also strengthening the rate at which your hand decays objects."
	gain_text = "A sickly diseased touch that was, yet, so welcoming."
	cost = 2
	next_knowledge = list(/datum/eldritch_knowledge/spell/grasp_of_decay)
	var/rust_force = 750
	var/static/list/blacklisted_turfs = typecacheof(list(/turf/closed,/turf/open/space,/turf/open/lava,/turf/open/chasm,/turf/open/floor/plating/rust))
	route = PATH_RUST

/datum/eldritch_knowledge/rust_fist_upgrade/on_mansus_grasp(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.set_disgust(75)
	return TRUE

/datum/eldritch_knowledge/spell/grasp_of_decay
	name = "Grasp of Decay"
	desc = "Applying your knowledge of rust to the human body, a knowledge that could decay your foes from the inside out, resulting in organ failure, vomiting, or eventual death through peeling flesh."
	gain_text = "Decay, similar to Rust, yet so much more terribly uninviting."
	cost = 2
	spell_to_add = /obj/effect/proc_holder/spell/targeted/touch/grasp_of_decay
	next_knowledge = list(/datum/eldritch_knowledge/final/rust_final)
	route = PATH_RUST

/datum/eldritch_knowledge/final/rust_final
	name = "Rustbringer's Oath"
	desc = "Bring three corpses onto a transmutation rune. After you finish the ritual, rust will now automatically spread from the rune. Your healing on rust is also tripled, while you become more resilient overall."
	gain_text = "Champion of rust. Corruptor of steel. Fear the dark for Rustbringer has come!"
	cost = 5
	required_atoms = list(/mob/living/carbon/human)
	route = PATH_RUST

/datum/eldritch_knowledge/final/rust_final/on_finished_recipe(mob/living/user, list/atoms, loc)
	var/mob/living/carbon/human/H = user
	H.physiology.brute_mod *= 0.5
	H.physiology.burn_mod *= 0.5
	priority_announce("$^@&#*$^@(#&$(@&#^$&#^@# Fear the decay, for Rustbringer [user.real_name] has come! $^@&#*$^@(#&$(@&#^$&#^@#","#$^@&#*$^@(#&$(@&#^$&#^@#", 'sound/announcer/classic/spanomalies.ogg')
	new /datum/rust_spread(loc)
	var/datum/antagonist/heretic/ascension = H.mind.has_antag_datum(/datum/antagonist/heretic)
	ascension.ascended = TRUE
	return ..()


/datum/eldritch_knowledge/final/rust_final/on_life(mob/user)
	. = ..()
	if(!finished)
		return
	var/mob/living/carbon/human/human_user = user
	human_user.adjustBruteLoss(-6, FALSE)
	human_user.adjustFireLoss(-6, FALSE)
	human_user.adjustToxLoss(-6, FALSE)
	human_user.adjustOxyLoss(-6, FALSE)
	human_user.adjustStaminaLoss(-20)


/**
  * #Rust spread datum
  *
  * Simple datum that automatically spreads rust around it
  *
  * Simple implementation of automatically growing entity
  */
/datum/rust_spread
	var/list/edge_turfs = list()
	var/list/turfs = list()
	var/static/list/blacklisted_turfs = typecacheof(list(/turf/open/indestructible,/turf/closed/indestructible,/turf/open/space,/turf/open/lava,/turf/open/chasm))
	var/spread_per_tick = 6


/datum/rust_spread/New(loc)
	. = ..()
	var/turf/turf_loc = get_turf(loc)
	turf_loc.rust_heretic_act()
	turfs += turf_loc
	START_PROCESSING(SSprocessing,src)


/datum/rust_spread/Destroy(force, ...)
	STOP_PROCESSING(SSprocessing,src)
	return ..()

/datum/rust_spread/process()
	compile_turfs()
	var/turf/T
	for(var/i in 0 to spread_per_tick)
		T = pick(edge_turfs)
		T.rust_heretic_act()
		turfs += get_turf(T)

/**
  * Compile turfs
  *
  * Recreates all edge_turfs as well as normal turfs.
  */
/datum/rust_spread/proc/compile_turfs()
	edge_turfs = list()
	for(var/X in turfs)
		if(!istype(X,/turf/closed/wall/rust) && !istype(X,/turf/closed/wall/r_wall/rust) && !istype(X,/turf/open/floor/plating/rust))
			turfs -=X
			continue
		for(var/turf/T in range(1,X))
			if(T in turfs)
				continue
			if(is_type_in_typecache(T,blacklisted_turfs))
				continue
			edge_turfs += T
