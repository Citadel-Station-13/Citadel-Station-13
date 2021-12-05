GLOBAL_LIST_INIT(digest_modes, list())

/datum/digest_mode
	var/id = DM_HOLD
	var/noise_chance = 0
	var/blacklisted = FALSE

/**
 * This proc has all the behavior for the given digestion mode.
 * It returns either null, or an associative list in the following format:
 * list("to_update" = TRUE/FALSE, "soundToPlay" = sound())
 * where to_update is whether or not a updateVorePanel() call is necessary,
 * and soundToPlay will play the given sound at the end of the process tick.
 */
/datum/digest_mode/proc/process_mob(obj/belly/B, mob/living/L)
	return null

/datum/digest_mode/proc/handle_atoms(obj/belly/B, list/touchable_atoms)
    return FALSE

/datum/digest_mode/digest
	id = DM_DIGEST
	noise_chance = 25

/datum/digest_mode/digest/process_mob(obj/belly/B, mob/living/L)
	var/oldstat = L.stat

	//Pref protection!
	if (!(L.vore_flags & DIGESTABLE) || L.vore_flags & ABSORBED)
		return null

	//Person just died in guts!
	if(L.stat == DEAD)
		B.owner.adjust_nutrition(400) // so eating dead mobs gives you *something*.
		if(L && L.client && L.client.prefs.cit_toggles & DIGESTION_NOISES)
			SEND_SOUND(L,get_sfx("prey_death"))
		L.stop_sound_channel(CHANNEL_PREYLOOP)
		B.owner.update_icons()
		B.handle_digestion_death(L)
		return list("to_update" = TRUE, "soundToPlay" = sound(get_sfx("death_pred")))

	if(B.reagent_mode_flags & DM_FLAG_REAGENTSDIGEST && B.reagents.total_volume < B.reagents.maximum_volume) //CHOMPedit start: digestion producing reagents
		B.GenerateBellyReagents_digesting()

	// Deal digestion damage (and feed the pred)
	if(!(L.status_flags & GODMODE))
		L.adjustFireLoss(B.digest_burn)
		B.owner.adjust_nutrition(1)

	if(L.stat != oldstat)
		return list("to_update" = TRUE)

/datum/digest_mode/heal
	id = DM_HEAL
	noise_chance = 25 //Wet heals! The secret is you can leave this on for gurgle noises for fun.

/datum/digest_mode/heal/process_mob(obj/belly/B, mob/living/L)
	var/oldstat = L.stat

	if(L.stat != DEAD)
		return null // Can't heal the dead with healbelly

	if(B.owner.nutrition >= NUTRITION_LEVEL_STARVING && (L.bruteloss > 0 || L.fireloss > 0)) // PLEASE DON'T SUBTRACT NUTRITION IF THERE'S SOMETHING I CAN'T HEAL
		L.adjustBruteLoss(-3)
		L.adjustFireLoss(-3)
		B.owner.adjust_nutrition(-5)

	if(L.stat != oldstat)
		return list("to_update" = TRUE)

/datum/digest_mode/noisy
	id = DM_NOISY
	noise_chance = 35

// Noisy don't get any procs

/datum/digest_mode/absorb
	id = DM_ABSORB
	noise_chance = 10

/datum/digest_mode/absorb/process_mob(obj/belly/B, mob/living/L)
	if(L.vore_flags & ABSORBED || !(L.vore_flags & ABSORBABLE)) //Negative.
		return null

	B.steal_nutrition(L)
	if(L.nutrition < 100) //When they're finally drained.
		B.absorb_living(L)
		if(B.reagent_mode_flags & DM_FLAG_REAGENTSABSORB && B.reagents.total_volume < B.reagents.maximum_volume) //CHOMPedit: absorption reagent production
			B.GenerateBellyReagents_absorbed() //CHOMPedit end: A bonus for pred, I know for a fact prey is usually at zero nutrition when absorption finally happens
		return list("to_update" = TRUE)

/datum/digest_mode/unabsorb
	id = DM_UNABSORB

/datum/digest_mode/unabsorb/process_mob(obj/belly/B, mob/living/L)
	if(L.vore_flags & ABSORBED && B.owner.nutrition >= 100)
		L.vore_flags &= ~(ABSORBED)
		to_chat(L,"<span class='notice'>You suddenly feel solid again </span>")
		to_chat(B.owner,"<span class='notice'>You feel like a part of you is missing.</span>")
		B.owner.adjust_nutrition(-100)
		return list("to_update" = TRUE)

/datum/digest_mode/dragon
	id = DM_DRAGON
	noise_chance = 55

/datum/digest_mode/dragon/handle_atoms(obj/belly/B, list/touchable_atoms)
	for (var/mob/living/M in touchable_atoms)

	//No digestion protection for megafauna.

	//Person just died in guts!
		if(M.stat == DEAD)
			B.handle_digestion_death(M)
			M.visible_message("<span class='notice'>You watch as [B.owner]'s guts loudly rumble as it finishes off a meal.</span>")
			if(M && M.client && M.client.prefs.cit_toggles & DIGESTION_NOISES)
				SEND_SOUND(M, get_sfx("prey_death"))
			M.spill_organs(FALSE,TRUE,TRUE)
			M.stop_sound_channel(CHANNEL_PREYLOOP)
			B.digestion_death(M)
			B.owner.update_icons()
			. = list("to_update" = TRUE, "soundToPlay" = sound(get_sfx("death_pred")))
			continue


		// Deal digestion damage (and feed the pred)
		if(!(M.status_flags & GODMODE))
			M.adjustFireLoss(B.digest_burn)
			M.adjustToxLoss(2) // something something plasma based acids
			M.adjustCloneLoss(1) // eventually this'll kill you if you're healing everything else, you nerds.

	//Contaminate or gurgle items
	var/obj/item/T = pick(touchable_atoms)
	if(istype(T))
		if(istype(T,/obj/item/reagent_containers/food) || istype(T,/obj/item/organ))
			B.digest_item(T)

/datum/digest_mode/drain
	id = DM_DRAIN
	noise_chance = 10

/datum/digest_mode/drain/process_mob(obj/belly/B, mob/living/L)
	B.steal_nutrition(L)

/datum/digest_mode/drain/shrink
	id = DM_SHRINK

/datum/digest_mode/drain/shrink/process_mob(obj/belly/B, mob/living/L)
	if(ishuman(L))
		var/mob/living/carbon/human/prey = L
		var/oldsize = prey.dna.features["body_size"]
		if(oldsize > B.shrink_grow_size)
			prey.dna.features["body_size"] = (oldsize - 0.01) // Shrink by 1% per tick
			prey.dna.update_body_size(oldsize)
	. = ..()

/datum/digest_mode/grow
	id = DM_GROW
	noise_chance = 10

/datum/digest_mode/grow/process_mob(obj/belly/B, mob/living/L)
	if(ishuman(L))
		var/mob/living/carbon/human/prey = L
		var/oldsize = prey.dna.features["body_size"]
		if(oldsize < B.shrink_grow_size)
			prey.dna.features["body_size"] = (oldsize + 0.01) // Grow by 1% per tick
			prey.dna.update_body_size(oldsize)
	. = ..()

/datum/digest_mode/drain/sizesteal
	id = DM_SIZE_STEAL

/datum/digest_mode/drain/sizesteal/process_mob(obj/belly/B, mob/living/L)
	if(!(ishuman(L) && ishuman(B.owner)))
		return null
	var/mob/living/carbon/human/prey = L
	var/mob/living/carbon/human/pred = B.owner
	var/oldsize_prey = prey.dna.features["body_size"]
	var/oldsize_pred = pred.dna.features["body_size"]
	if(oldsize_prey > B.shrink_grow_size && oldsize_pred < 2) //Grow until either pred is large or prey is small.
		prey.dna.features["body_size"] = (oldsize_prey - 0.01) // Shrink by 1% per tick
		prey.dna.update_body_size(oldsize_prey)
		pred.dna.features["body_size"] = (oldsize_pred + 0.01) // Grow by 1% per tick
		pred.dna.update_body_size(oldsize_pred)
	. = ..()

/*
// E G G
/datum/digest_mode/egg
	id = DM_EGG
/*
/datum/digest_mode/egg/process_mob(obj/belly/B, mob/living/carbon/human/H)
	if(!istype(H) || H.stat == DEAD || (H.vore_flags & ABSORBED))
		return null
	B.put_in_egg(H, 1)*/

/datum/digest_mode/egg/handle_atoms(obj/belly/B, list/touchable_atoms)
	var/list/egg_contents = list()
	for(var/E in touchable_atoms)
		if(istype(E, /obj/item/weapon/storage/vore_egg)) // Don't egg other eggs.
			continue
		if(isliving(E))
			var/mob/living/L = E
			if(L.vore_flags & ABSORBED)
				continue
			egg_contents += L
		if(isitem(E))
			egg_contents += E
	if(egg_contents.len)
		if(!B.ownegg)
			if(B.egg_type in tf_vore_egg_types)
				B.egg_path = tf_vore_egg_types[B.egg_type]
			B.ownegg = new B.egg_path(B)
		for(var/atom/movable/C in egg_contents)
			if(isitem(C) && egg_contents.len == 1) //Only egging one item
				var/obj/item/I = C
				B.ownegg.w_class = I.w_class
				B.ownegg.max_storage_space = B.ownegg.w_class
				I.forceMove(B.ownegg)
				B.ownegg.icon_scale_x = 0.2 * B.ownegg.w_class
				B.ownegg.icon_scale_y = 0.2 * B.ownegg.w_class
				B.ownegg.update_transform()
				egg_contents -= I
				B.ownegg = null
				return list("to_update" = TRUE)
			if(isliving(C))
				var/mob/living/M = C
				var/mob_holder_type = M.holder_type || /obj/item/weapon/holder
				B.ownegg.w_class = M.size_multiplier * 4 //Egg size and weight scaled to match occupant.
				var/obj/item/weapon/holder/H = new mob_holder_type(B.ownegg, M)
				B.ownegg.max_storage_space = H.w_class
				B.ownegg.icon_scale_x = 0.25 * B.ownegg.w_class
				B.ownegg.icon_scale_y = 0.25 * B.ownegg.w_class
				B.ownegg.update_transform()
				egg_contents -= M
				if(B.ownegg.w_class > 4)
					B.ownegg.slowdown = B.ownegg.w_class - 4
				B.ownegg = null
				return list("to_update" = TRUE)
			C.forceMove(B.ownegg)
			if(isitem(C))
				var/obj/item/I = C
				B.ownegg.w_class += I.w_class //Let's assume a regular outfit can reach total w_class of 16.
		B.ownegg.calibrate_size()
		B.ownegg.orient2hud()
		B.ownegg.w_class = clamp(B.ownegg.w_class * 0.25, 1, 8) //A total w_class of 16 will result in a backpack sized egg.
		B.ownegg.icon_scale_x = clamp(0.25 * B.ownegg.w_class, 0.25, 1)
		B.ownegg.icon_scale_y = clamp(0.25 * B.ownegg.w_class, 0.25, 1)
		B.ownegg.update_transform()
		if(B.ownegg.w_class > 4)
			B.ownegg.slowdown = B.ownegg.w_class - 4
		B.ownegg = null
		return list("to_update" = TRUE)
	return
*/
