/datum/species/jelly
	// Entirely alien beings that seem to be made entirely out of gel. They have three eyes and a skeleton visible within them.
	name = "Xenobiological Jelly Entity"
	id = SPECIES_JELLY
	default_color = "00FF90"
	say_mod = "chirps"
	species_traits = list(MUTCOLORS,EYECOLOR,HAIR,FACEHAIR,WINGCOLOR,HAS_FLESH)
	mutantlungs = /obj/item/organ/lungs/slime
	mutant_heart = /obj/item/organ/heart/slime
	mutantstomach = /obj/item/organ/stomach/slime
	mutantliver = /obj/item/organ/liver/slime
	mutant_brain = /obj/item/organ/brain/slime
	mutant_bodyparts = list("mcolor" = "FFFFFF", "mam_tail" = "None", "mam_ears" = "None", "mam_snouts" = "None", "taur" = "None", "deco_wings" = "None", "legs" = "Plantigrade")
	inherent_traits = list(TRAIT_TOXINLOVER)
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/slime
	gib_types = list(/obj/effect/gibspawner/slime, /obj/effect/gibspawner/slime/bodypartless)
	exotic_blood = /datum/reagent/blood/jellyblood
	exotic_bloodtype = "GEL"
	exotic_blood_color = "BLOOD_COLOR_SLIME"
	damage_overlay_type = ""
	liked_food = TOXIC | MEAT
	disliked_food = null
	toxic_food = ANTITOXIC
	coldmod = 6   // = 3x cold damage
	heatmod = 0.5 // = 1/4x heat damage
	burnmod = 0.5 // = 1/2x generic burn damage
	species_language_holder = /datum/language_holder/jelly

	tail_type = "mam_tail"
	wagging_type = "mam_waggingtail"
	species_category = SPECIES_CATEGORY_JELLY
	ass_image = 'icons/ass/assslime.png'

/datum/species/jelly/on_species_loss(mob/living/carbon/C)
	C.faction -= "slime"
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.remove_ability_from_source(list(INNATE_ABILITY_SLIME_BLOBFORM, INNATE_ABILITY_LIMB_REGROWTH, INNATE_ABILITY_HUMANOID_CUSTOMIZATION), ABILITY_SOURCE_SPECIES)
	..()
	C.faction -= "slime"

/datum/species/jelly/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.grant_ability_from_source(list(INNATE_ABILITY_SLIME_BLOBFORM, INNATE_ABILITY_LIMB_REGROWTH, INNATE_ABILITY_HUMANOID_CUSTOMIZATION), ABILITY_SOURCE_SPECIES)
		H.set_ability_property(INNATE_ABILITY_LIMB_REGROWTH, PROPERTY_LIMB_REGROWTH_USAGE_TYPE, REGROWTH_USES_BLOOD)
	C.faction |= "slime"

/datum/species/jelly/handle_body(mob/living/carbon/human/H)
	. = ..()
	//update blood color to body color
	exotic_blood_color = "#" + H.dna.features["mcolor"]

/datum/species/jelly/spec_life(mob/living/carbon/human/H)
	if(H.stat == DEAD || HAS_TRAIT(H, TRAIT_NOMARROW)) //can't farm slime jelly from a dead slime/jelly person indefinitely, and no regeneration for blooduskers
		return
	if(!H.blood_volume)
		H.blood_volume += 5
		H.adjustBruteLoss(5)
		to_chat(H, "<span class='danger'>You feel empty!</span>")

	if(H.blood_volume < (BLOOD_VOLUME_NORMAL * H.blood_ratio))
		if(H.nutrition >= NUTRITION_LEVEL_STARVING)
			H.blood_volume += 3
			H.nutrition -= 2.5
	if(H.blood_volume < (BLOOD_VOLUME_OKAY*H.blood_ratio))
		if(prob(5))
			to_chat(H, "<span class='danger'>You feel drained!</span>")
	if(H.blood_volume < (BLOOD_VOLUME_BAD*H.blood_ratio))
		Cannibalize_Body(H)

/datum/species/jelly/proc/Cannibalize_Body(mob/living/carbon/human/H)
	var/list/limbs_to_consume = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG) - H.get_missing_limbs()
	var/obj/item/bodypart/consumed_limb
	if(!limbs_to_consume.len)
		H.losebreath++
		return
	if(H.get_num_legs(FALSE)) //Legs go before arms
		limbs_to_consume -= list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM)
	consumed_limb = H.get_bodypart(pick(limbs_to_consume))
	consumed_limb.drop_limb()
	to_chat(H, "<span class='userdanger'>Your [consumed_limb] is drawn back into your body, unable to maintain its shape!</span>")
	qdel(consumed_limb)
	H.blood_volume += 20

////////////////////////////////////////////////////////SLIMEPEOPLE///////////////////////////////////////////////////////////////////

//Slime people are able to split like slimes, retaining a single mind that can swap between bodies at will, even after death.

/datum/species/jelly/slime
	name = "Xenobiological Slime Entity"
	id = SPECIES_SLIME
	default_color = "00FFFF"
	species_traits = list(MUTCOLORS,EYECOLOR,HAIR,FACEHAIR,HAS_FLESH)
	say_mod = "says"
	hair_color = "mutcolor"
	hair_alpha = 150
	ignored_by = list(/mob/living/simple_animal/slime)
	var/datum/action/innate/split_body/slime_split
	var/list/mob/living/carbon/bodies
	var/datum/action/innate/swap_body/swap_body

/datum/species/jelly/slime/on_species_loss(mob/living/carbon/C)
	if(slime_split)
		slime_split.Remove(C)
	if(swap_body)
		swap_body.Remove(C)
	bodies -= C // This means that the other bodies maintain a link
	// so if someone mindswapped into them, they'd still be shared.
	bodies = null
	C.blood_volume = min(C.blood_volume, (BLOOD_VOLUME_NORMAL*C.blood_ratio))
	..()

/datum/species/jelly/slime/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	if(ishuman(C))
		slime_split = new
		slime_split.Grant(C)
		swap_body = new
		swap_body.Grant(C)

		if(!bodies || !bodies.len)
			bodies = list(C)
		else
			bodies |= C

/datum/species/jelly/slime/spec_death(gibbed, mob/living/carbon/human/H)
	if(slime_split)
		if(!H.mind || !H.mind.active)
			return

		var/list/available_bodies = (bodies - H)
		for(var/mob/living/L in available_bodies)
			if(!swap_body.can_swap(L))
				available_bodies -= L

		if(!LAZYLEN(available_bodies))
			return

		swap_body.swap_to_dupe(H.mind, pick(available_bodies))

//If you're cloned you get your body pool back
/datum/species/jelly/slime/copy_properties_from(datum/species/jelly/slime/old_species)
	bodies = old_species.bodies

/datum/species/jelly/slime/spec_life(mob/living/carbon/human/H)
	if((HAS_TRAIT(H, TRAIT_NOMARROW)))
		return
	if(H.blood_volume >= BLOOD_VOLUME_SLIME_SPLIT)
		if(prob(5))
			to_chat(H, "<span class='notice'>You feel very bloated!</span>")
	else if(H.nutrition >= NUTRITION_LEVEL_WELL_FED)
		H.blood_volume += 3
		H.nutrition -= 2.5

	..()

/datum/action/innate/split_body
	name = "Split Body"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "slimesplit"
	icon_icon = 'icons/mob/actions/actions_slime.dmi'
	background_icon_state = "bg_alien"

/datum/action/innate/split_body/IsAvailable(silent = FALSE)
	if(..())
		var/mob/living/carbon/human/H = owner
		if(H.blood_volume >= BLOOD_VOLUME_SLIME_SPLIT)
			return 1
		return 0

/datum/action/innate/split_body/Activate()
	var/mob/living/carbon/human/H = owner
	if(!isslimeperson(H))
		return
	CHECK_DNA_AND_SPECIES(H)
	H.visible_message("<span class='notice'>[owner] gains a look of \
		concentration while standing perfectly still.</span>",
		"<span class='notice'>You focus intently on moving your body while \
		standing perfectly still...</span>")

	H.mob_transforming = TRUE

	if(do_after(owner, delay=60, needhand=FALSE, target=owner, progress=TRUE))
		if(H.blood_volume >= BLOOD_VOLUME_SLIME_SPLIT)
			make_dupe()
		else
			to_chat(H, "<span class='warning'>...but there is not enough of you to go around! You must attain more mass to split!</span>")
	else
		to_chat(H, "<span class='warning'>...but fail to stand perfectly still!</span>")

	H.mob_transforming = FALSE

/datum/action/innate/split_body/proc/make_dupe()
	var/mob/living/carbon/human/H = owner
	CHECK_DNA_AND_SPECIES(H)

	var/mob/living/carbon/human/spare = new /mob/living/carbon/human(H.loc)

	spare.underwear = "Nude"
	spare.undershirt = "Nude"
	spare.socks = "Nude"
	H.dna.transfer_identity(spare, transfer_SE=1)
	spare.dna.features["mcolor"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
	spare.real_name = spare.dna.real_name
	spare.name = spare.dna.real_name
	spare.updateappearance(mutcolor_update=1)
	spare.domutcheck()
	spare.Move(get_step(H.loc, pick(NORTH,SOUTH,EAST,WEST)))

	H.blood_volume *= 0.45
	H.mob_transforming = 0

	var/datum/species/jelly/slime/origin_datum = H.dna.species
	origin_datum.bodies |= spare

	var/datum/species/jelly/slime/spare_datum = spare.dna.species
	spare_datum.bodies = origin_datum.bodies

	H.transfer_trait_datums(spare)
	H.mind.transfer_to(spare)
	spare.visible_message("<span class='warning'>[H] distorts as a new body \
		\"steps out\" of [H.p_them()].</span>",
		"<span class='notice'>...and after a moment of disorentation, \
		you're besides yourself!</span>")
	if(H != spare && isslimeperson(spare) && isslimeperson(H))
		// transfer the swap-body ui if it's open
		var/datum/action/innate/swap_body/this_swap = origin_datum.swap_body
		var/datum/action/innate/swap_body/other_swap = spare_datum.swap_body
		var/datum/tgui/ui = SStgui.get_open_ui(H, this_swap, "main") || SStgui.get_open_ui(spare, this_swap, "main")
		if(ui)
			SStgui.on_close(ui) // basically removes it from lists is all this proc does.
			ui.user = spare
			ui.src_object = other_swap
			SStgui.on_open(ui) // stick it back on the lists
			ui.process(force = TRUE)

/datum/action/innate/swap_body
	name = "Swap Body"
	check_flags = NONE
	button_icon_state = "slimeswap"
	icon_icon = 'icons/mob/actions/actions_slime.dmi'
	background_icon_state = "bg_alien"

/datum/action/innate/swap_body/Activate()
	if(!isslimeperson(owner))
		to_chat(owner, "<span class='warning'>You are not a slimeperson.</span>")
		Remove(owner)
	else
		ui_interact(owner)

/datum/action/innate/swap_body/ui_host(mob/user)
	return owner

/datum/action/innate/swap_body/ui_state(mob/user)
	return GLOB.not_incapacitated_state

/datum/action/innate/swap_body/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SlimeBodySwapper", name)
		ui.open()

/datum/action/innate/swap_body/ui_data(mob/user)
	var/mob/living/carbon/human/H = owner
	if(!isslimeperson(H))
		return

	var/datum/species/jelly/slime/SS = H.dna.species

	var/list/data = list()
	data["bodies"] = list()
	for(var/b in SS.bodies)
		var/mob/living/carbon/human/body = b
		if(!body || QDELETED(body) || !isslimeperson(body))
			SS.bodies -= b
			continue

		var/list/L = list()
		// HTML colors need a # prefix
		L["htmlcolor"] = "#[body.dna.features["mcolor"]]"
		L["area"] = get_area_name(body, TRUE)
		var/stat = "error"
		switch(body.stat)
			if(CONSCIOUS)
				stat = "Conscious"
			if(UNCONSCIOUS)
				stat = "Unconscious"
			if(SOFT_CRIT)
				stat = "Barely Conscious"
			if(DEAD)
				stat = "Dead"
		var/occupied
		if(body == H)
			occupied = "owner"
		else if(body.mind && body.mind.active)
			occupied = "stranger"
		else
			occupied = "available"

		L["status"] = stat
		L["exoticblood"] = body.blood_volume
		L["name"] = body.name
		L["ref"] = "[REF(body)]"
		L["occupied"] = occupied
		var/button
		if(occupied == "owner")
			button = "selected"
		else if(occupied == "stranger")
			button = "danger"
		else if(can_swap(body))
			button = null
		else
			button = "disabled"

		L["swap_button_state"] = button
		L["swappable"] = (occupied == "available") && can_swap(body)

		data["bodies"] += list(L)

	return data

/datum/action/innate/swap_body/ui_act(action, params)
	if(..())
		return
	var/mob/living/carbon/human/H = owner
	if(!isslimeperson(owner))
		return
	if(!H.mind || !H.mind.active)
		return
	switch(action)
		if("swap")
			var/datum/species/jelly/slime/SS = H.dna.species
			var/mob/living/carbon/human/selected = locate(params["ref"]) in SS.bodies
			if(!can_swap(selected))
				return
			swap_to_dupe(H.mind, selected)

/datum/action/innate/swap_body/proc/can_swap(mob/living/carbon/human/dupe)
	var/mob/living/carbon/human/H = owner
	if(!isslimeperson(H))
		return FALSE
	var/datum/species/jelly/slime/SS = H.dna.species

	if(QDELETED(dupe)) 					//Is there a body?
		SS.bodies -= dupe
		return FALSE

	if(!isslimeperson(dupe)) 			//Is it a slimeperson?
		SS.bodies -= dupe
		return FALSE

	if(dupe.stat == DEAD) 				//Is it alive?
		return FALSE

	if(dupe.stat != CONSCIOUS) 			//Is it awake?
		return FALSE

	if(dupe.mind && dupe.mind.active) 	//Is it unoccupied?
		return FALSE

	if(!(dupe in SS.bodies))			//Do we actually own it?
		return FALSE

	return TRUE

/datum/action/innate/swap_body/proc/swap_to_dupe(datum/mind/M, mob/living/carbon/human/dupe)
	if(!can_swap(dupe)) //sanity check
		return
	var/mob/living/carbon/human/old = M.current
	if(M.current.stat == CONSCIOUS)
		M.current.visible_message("<span class='notice'>[M.current] \
			stops moving and starts staring vacantly into space.</span>",
			"<span class='notice'>You stop moving this body...</span>")
	else
		to_chat(M.current, "<span class='notice'>You abandon this body...</span>")
	M.current.transfer_trait_datums(dupe)
	M.transfer_to(dupe)
	dupe.visible_message("<span class='notice'>[dupe] blinks and looks \
		around.</span>",
		"<span class='notice'>...and move this one instead.</span>")
	if(old != M.current && dupe == M.current && isslimeperson(dupe))
		var/datum/species/jelly/slime/other_spec = dupe.dna.species
		var/datum/action/innate/swap_body/other_swap = other_spec.swap_body
		// theoretically the transfer_to proc is supposed to transfer the ui from the mob.
		// so I try to get the UI from one of the two mobs and schlump it over to the new action button
		var/datum/tgui/ui = SStgui.get_open_ui(old, src, "main") || SStgui.get_open_ui(dupe, src, "main")
		if(ui)
			// transfer the UI over. This code is slightly hacky but it fixes the problem
			// I'd use SStgui.on_transfer but that doesn't let you transfer the src_object as well s
			SStgui.on_close(ui) // basically removes it from lists is all this proc does.
			ui.user = dupe
			ui.src_object = other_swap
			SStgui.on_open(ui) // stick it back on the lists
			ui.process(force = TRUE)

////////////////////////////////////////////////////////Round Start Slimes///////////////////////////////////////////////////////////////////

/datum/species/jelly/roundstartslime
	name = "Xenobiological Slime Hybrid"
	id = SPECIES_SLIME_HYBRID
	limbs_id = SPECIES_SLIME
	default_color = "00FFFF"
	species_traits = list(MUTCOLORS,EYECOLOR,HAIR,FACEHAIR,HAS_FLESH)
	inherent_traits = list(TRAIT_TOXINLOVER)
	mutant_bodyparts = list("mcolor" = "FFFFFF", "mcolor2" = "FFFFFF","mcolor3" = "FFFFFF", "mam_tail" = "None", "mam_ears" = "None", "mam_body_markings" = "Plain", "mam_snouts" = "None", "taur" = "None", "legs" = "Plantigrade")
	say_mod = "says"
	hair_color = "mutcolor"
	hair_alpha = 160 //a notch brighter so it blends better.
	coldmod = 3
	heatmod = 1
	burnmod = 1

	allowed_limb_ids = list(SPECIES_SLIME,SPECIES_STARGAZER,SPECIES_SLIME_LUMI)

///////////////////////////////////LUMINESCENTS//////////////////////////////////////////

//Luminescents are able to consume and use slime extracts, without them decaying.

/datum/species/jelly/luminescent
	name = "Luminescent Slime Entity"
	id = SPECIES_SLIME_LUMI
	say_mod = "says"
	var/glow_intensity = LUMINESCENT_DEFAULT_GLOW
	var/obj/effect/dummy/luminescent_glow/glow
	var/obj/item/slime_extract/current_extract
	var/datum/action/innate/integrate_extract/integrate_extract
	var/datum/action/innate/use_extract/extract_minor
	var/datum/action/innate/use_extract/major/extract_major
	var/extract_cooldown = 0

/datum/species/jelly/luminescent/on_species_loss(mob/living/carbon/C)
	..()
	if(current_extract)
		current_extract.forceMove(C.drop_location())
		current_extract = null
	qdel(glow)
	if(integrate_extract)
		integrate_extract.Remove(C)
	if(extract_minor)
		extract_minor.Remove(C)
	if(extract_major)
		extract_major.Remove(C)

/datum/species/jelly/luminescent/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	glow = new(C)
	update_glow(C)
	integrate_extract = new(src)
	integrate_extract.Grant(C)
	extract_minor = new(src)
	extract_minor.Grant(C)
	extract_major = new(src)
	extract_major.Grant(C)

/datum/species/jelly/luminescent/proc/update_slime_actions()
	integrate_extract.update_name()
	integrate_extract.UpdateButtonIcon()
	extract_minor.UpdateButtonIcon()
	extract_major.UpdateButtonIcon()

/datum/species/jelly/luminescent/proc/update_glow(mob/living/carbon/C, intensity)
	if(intensity)
		glow_intensity = intensity
	glow.set_light(glow_intensity, glow_intensity, C.dna.features["mcolor"])

/obj/effect/dummy/luminescent_glow
	name = "luminescent glow"
	desc = "Tell a coder if you're seeing this."
	icon_state = "nothing"
	light_color = "#FFFFFF"
	light_range = LUMINESCENT_DEFAULT_GLOW

/obj/effect/dummy/luminescent_glow/Initialize()
	. = ..()
	if(!isliving(loc))
		return INITIALIZE_HINT_QDEL

/datum/action/innate/integrate_extract
	name = "Integrate Extract"
	desc = "Eat a slime extract to use its properties."
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "slimeconsume"
	icon_icon = 'icons/mob/actions/actions_slime.dmi'
	background_icon_state = "bg_alien"
	var/datum/species/jelly/luminescent/species

/datum/action/innate/integrate_extract/New(_species)
	..()
	species = _species

/datum/action/innate/integrate_extract/proc/update_name()
	if(!species || !species.current_extract)
		name = "Integrate Extract"
		desc = "Eat a slime extract to use its properties."
	else
		name = "Eject Extract"
		desc = "Eject your current slime extract."

/datum/action/innate/integrate_extract/UpdateButtonIcon(status_only, force)
	if(!species || !species.current_extract)
		button_icon_state = "slimeconsume"
	else
		button_icon_state = "slimeeject"
	..()

/datum/action/innate/integrate_extract/ApplyIcon(obj/screen/movable/action_button/current_button, force)
	..(current_button, TRUE)
	if(species && species.current_extract)
		current_button.add_overlay(mutable_appearance(species.current_extract.icon, species.current_extract.icon_state))

/datum/action/innate/integrate_extract/Activate()
	var/mob/living/carbon/human/H = owner
	if(!is_species(H, /datum/species/jelly/luminescent) || !species)
		return
	CHECK_DNA_AND_SPECIES(H)

	if(species.current_extract)
		var/obj/item/slime_extract/S = species.current_extract
		if(!H.put_in_active_hand(S))
			S.forceMove(H.drop_location())
		species.current_extract = null
		to_chat(H, "<span class='notice'>You eject [S].</span>")
		species.update_slime_actions()
	else
		var/obj/item/I = H.get_active_held_item()
		if(istype(I, /obj/item/slime_extract))
			var/obj/item/slime_extract/S = I
			if(!S.Uses)
				to_chat(H, "<span class='warning'>[I] is spent! You cannot integrate it.</span>")
				return
			if(!H.temporarilyRemoveItemFromInventory(S))
				return
			S.forceMove(H)
			species.current_extract = S
			to_chat(H, "<span class='notice'>You consume [I], and you feel it pulse within you...</span>")
			species.update_slime_actions()
		else
			to_chat(H, "<span class='warning'>You need to hold an unused slime extract in your active hand!</span>")

/datum/action/innate/use_extract
	name = "Extract Minor Activation"
	desc = "Pulse the slime extract with energized jelly to activate it."
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "slimeuse1"
	icon_icon = 'icons/mob/actions/actions_slime.dmi'
	background_icon_state = "bg_alien"
	var/activation_type = SLIME_ACTIVATE_MINOR
	var/datum/species/jelly/luminescent/species

/datum/action/innate/use_extract/New(_species)
	..()
	species = _species

/datum/action/innate/use_extract/IsAvailable(silent = FALSE)
	if(..())
		if(species && species.current_extract && (world.time > species.extract_cooldown))
			return TRUE
		return FALSE

/datum/action/innate/use_extract/ApplyIcon(obj/screen/movable/action_button/current_button, force)
	..(current_button, TRUE)
	if(species && species.current_extract)
		current_button.add_overlay(mutable_appearance(species.current_extract.icon, species.current_extract.icon_state))

/datum/action/innate/use_extract/Activate()
	var/mob/living/carbon/human/H = owner
	if(!is_species(H, /datum/species/jelly/luminescent) || !species)
		return
	CHECK_DNA_AND_SPECIES(H)

	if(species.current_extract)
		species.extract_cooldown = world.time + 100
		var/cooldown = species.current_extract.activate(H, species, activation_type)
		species.extract_cooldown = world.time + cooldown

/datum/action/innate/use_extract/major
	name = "Extract Major Activation"
	desc = "Pulse the slime extract with plasma jelly to activate it."
	button_icon_state = "slimeuse2"
	activation_type = SLIME_ACTIVATE_MAJOR

///////////////////////////////////STARGAZERS//////////////////////////////////////////

//Stargazers are the telepathic branch of jellypeople, able to project psychic messages and to link minds with willing participants.

/datum/species/jelly/stargazer
	name = "Stargazer Slime Entity"
	id = SPECIES_STARGAZER
	var/datum/action/innate/project_thought/project_thought
	var/datum/action/innate/link_minds/link_minds
	var/list/mob/living/linked_mobs = list()
	var/list/datum/action/innate/linked_speech/linked_actions = list()
	var/mob/living/carbon/human/slimelink_owner
	var/current_link_id = 0

/datum/species/jelly/stargazer/on_species_loss(mob/living/carbon/C)
	..()
	for(var/M in linked_mobs)
		unlink_mob(M)
	if(project_thought)
		project_thought.Remove(C)
	if(link_minds)
		link_minds.Remove(C)

/datum/species/jelly/stargazer/spec_death(gibbed, mob/living/carbon/human/H)
	..()
	for(var/M in linked_mobs)
		unlink_mob(M)

/datum/species/jelly/stargazer/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	project_thought = new(src)
	project_thought.Grant(C)
	link_minds = new(src)
	link_minds.Grant(C)
	slimelink_owner = C
	link_mob(C, TRUE)

/datum/species/jelly/stargazer/proc/link_mob(mob/living/M, selflink = FALSE)
	if(QDELETED(M) || (M in linked_mobs))
		return FALSE
	if(!selflink && (M.stat == DEAD || HAS_TRAIT(M, TRAIT_MINDSHIELD) || M.anti_magic_check(FALSE, FALSE, TRUE, 0)))
		return FALSE
	linked_mobs.Add(M)
	if(!selflink)
		to_chat(M, "<span class='notice'>You are now connected to [slimelink_owner.real_name]'s Slime Link.</span>")
		RegisterSignal(M, COMSIG_MOB_DEATH , .proc/unlink_mob)
		RegisterSignal(M, COMSIG_PARENT_QDELETING, .proc/unlink_mob)
	var/datum/action/innate/linked_speech/action = new(src)
	linked_actions.Add(action)
	action.Grant(M)
	return TRUE

/datum/species/jelly/stargazer/proc/unlink_mob(mob/living/M)
	var/link_id = linked_mobs.Find(M)
	if(!(link_id))
		return
	UnregisterSignal(M, list(COMSIG_MOB_DEATH, COMSIG_PARENT_QDELETING))
	var/datum/action/innate/linked_speech/action = linked_actions[link_id]
	action.Remove(M)
	to_chat(M, "<span class='notice'>You are no longer connected to [slimelink_owner.real_name]'s Slime Link.</span>")
	linked_mobs[link_id] = null
	linked_actions[link_id] = null

/datum/action/innate/linked_speech
	name = "Slimelink"
	desc = "Send a psychic message to everyone connected to your slime link."
	button_icon_state = "link_speech"
	icon_icon = 'icons/mob/actions/actions_slime.dmi'
	background_icon_state = "bg_alien"
	var/datum/species/jelly/stargazer/species

/datum/action/innate/linked_speech/New(_species)
	..()
	species = _species

/datum/action/innate/linked_speech/Activate()
	var/mob/living/carbon/human/H = owner
	if(!species || !(H in species.linked_mobs))
		to_chat(H, "<span class='warning'>The link seems to have been severed...</span>")
		Remove(H)
		return

	var/message = sanitize(input("Message:", "Slime Telepathy") as text|null)

	if(!species || !(H in species.linked_mobs))
		to_chat(H, "<span class='warning'>The link seems to have been severed...</span>")
		Remove(H)
		return

	if(message)
		var/msg = "<i><font color=#008CA2>\[[species.slimelink_owner.real_name]'s Slime Link\] <b>[H]:</b> [message]</font></i>"
		log_directed_talk(H, species.slimelink_owner, msg, LOG_SAY, "slime link")
		for(var/X in species.linked_mobs)
			var/mob/living/M = X
			to_chat(M, msg)

		for(var/X in GLOB.dead_mob_list)
			var/mob/M = X
			var/link = FOLLOW_LINK(M, H)
			to_chat(M, "[link] [msg]")

/datum/action/innate/project_thought
	name = "Send Thought"
	desc = "Send a private psychic message to someone you can see."
	button_icon_state = "send_mind"
	icon_icon = 'icons/mob/actions/actions_slime.dmi'
	background_icon_state = "bg_alien"

/datum/action/innate/project_thought/Activate()
	var/mob/living/carbon/human/H = owner
	if(H.stat == DEAD)
		return
	if(!is_species(H, /datum/species/jelly/stargazer))
		return
	CHECK_DNA_AND_SPECIES(H)

	var/list/options = list()
	for(var/mob/living/Ms in oview(H))
		options += Ms
	var/mob/living/M = input("Select who to send your message to:","Send thought to?",null) as null|mob in options
	if(!M)
		return
	if(M.anti_magic_check(FALSE, FALSE, TRUE, 0))
		to_chat(H, "<span class='notice'>As you try to communicate with [M], you're suddenly stopped by a vision of a massive tinfoil wall that streches beyond visible range. It seems you've been foiled.</span>")
		return
	var/msg = sanitize(input("Message:", "Telepathy") as text|null)
	if(msg)
		if(M.anti_magic_check(FALSE, FALSE, TRUE, 0))
			to_chat(H, "<span class='notice'>As you try to communicate with [M], you're suddenly stopped by a vision of a massive tinfoil wall that streches beyond visible range. It seems you've been foiled.</span>")
			return
		log_directed_talk(H, M, msg, LOG_SAY, "slime telepathy")
		to_chat(M, "<span class='notice'>You hear an alien voice in your head... </span><font color=#008CA2>[msg]</font>")
		to_chat(H, "<span class='notice'>You telepathically said: \"[msg]\" to [M]</span>")
		for(var/dead in GLOB.dead_mob_list)
			if(!isobserver(dead))
				continue
			var/follow_link_user = FOLLOW_LINK(dead, H)
			var/follow_link_target = FOLLOW_LINK(dead, M)
			to_chat(dead, "[follow_link_user] <span class='name'>[H]</span> <span class='alertalien'>Slime Telepathy --> </span> [follow_link_target] <span class='name'>[M]</span> <span class='noticealien'>[msg]</span>")

/datum/action/innate/link_minds
	name = "Link Minds"
	desc = "Link someone's mind to your Slime Link, allowing them to communicate telepathically with other linked minds."
	button_icon_state = "mindlink"
	icon_icon = 'icons/mob/actions/actions_slime.dmi'
	background_icon_state = "bg_alien"
	var/datum/species/jelly/stargazer/species

/datum/action/innate/link_minds/New(_species)
	..()
	species = _species

/datum/action/innate/link_minds/Activate()
	var/mob/living/carbon/human/H = owner
	if(!is_species(H, /datum/species/jelly/stargazer))
		return
	CHECK_DNA_AND_SPECIES(H)

	if(!H.pulling || !isliving(H.pulling) || H.grab_state < GRAB_AGGRESSIVE)
		to_chat(H, "<span class='warning'>You need to aggressively grab someone to link minds!</span>")
		return

	var/mob/living/target = H.pulling

	to_chat(H, "<span class='notice'>You begin linking [target]'s mind to yours...</span>")
	to_chat(target, "<span class='warning'>You feel a foreign presence within your mind...</span>")
	if(do_after(H, 60, target = target))
		if(H.pulling != target || H.grab_state < GRAB_AGGRESSIVE)
			return
		if(species.link_mob(target))
			to_chat(H, "<span class='notice'>You connect [target]'s mind to your slime link!</span>")
		else
			to_chat(H, "<span class='warning'>You can't seem to link [target]'s mind...</span>")
			to_chat(target, "<span class='warning'>The foreign presence leaves your mind.</span>")
