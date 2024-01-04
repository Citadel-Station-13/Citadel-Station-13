
/datum/action/innate/ability/slime_blobform
	name = "Puddle Transformation"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "slimepuddle"
	icon_icon = 'icons/mob/actions/actions_slime.dmi'
	background_icon_state = "bg_alien"
	required_mobility_flags = MOBILITY_STAND
	var/is_puddle = FALSE
	var/in_transformation_duration = 12
	var/out_transformation_duration = 7
	var/puddle_into_effect = /obj/effect/temp_visual/slime_puddle
	var/puddle_from_effect = /obj/effect/temp_visual/slime_puddle/reverse
	var/puddle_icon = 'icons/mob/mob.dmi'
	var/puddle_state = "puddle"
	var/mutable_appearance/tracked_overlay
	var/datum/component/squeak/squeak
	var/transforming = FALSE
	var/last_use

/datum/action/innate/ability/slime_blobform/IsAvailable()
	if(!transforming)
		return ..()
	else
		return FALSE

/datum/action/innate/ability/slime_blobform/Remove(mob/M)
	if(is_puddle)
		detransform()
	return ..()

/datum/action/innate/ability/slime_blobform/Activate()
	var/mob/living/carbon/human/H = owner
	//if they have anything stuck to their hands, we immediately say 'no' and return
	for(var/obj/item/I in H.held_items)
		if(HAS_TRAIT(I, TRAIT_NODROP))
			to_chat(owner, "There's something stuck to your hand, stopping you from transforming!")
			return
	if(IsAvailable())
		UpdateButtons()
		var/mutcolor = owner.get_ability_property(INNATE_ABILITY_SLIME_BLOBFORM, PROPERTY_BLOBFORM_COLOR) || ("#" + H.dna.features["mcolor"])
		if(!is_puddle)
			if(CHECK_MOBILITY(H, MOBILITY_USE)) //if we can use items, we can turn into a puddle
				transforming = TRUE
				is_puddle = TRUE //so we know which transformation to use when its used
				ADD_TRAIT(H, TRAIT_HUMAN_NO_RENDER, SLIMEPUDDLE_TRAIT)
				owner.cut_overlays() //we dont show our normal sprite, we show a puddle sprite
				var/obj/effect/puddle_effect = new puddle_into_effect(get_turf(owner), owner.dir)
				puddle_effect.color = mutcolor
				puddle_effect.transform = H.transform //copy mob size for consistent meltdown appearance
				H.Stun(in_transformation_duration, ignore_canstun = TRUE) //cant move while transforming

				//series of traits that make up the puddle behaviour
				ADD_TRAIT(H, TRAIT_PARALYSIS_L_ARM, SLIMEPUDDLE_TRAIT)
				ADD_TRAIT(H, TRAIT_PARALYSIS_R_ARM, SLIMEPUDDLE_TRAIT)
				ADD_TRAIT(H, TRAIT_MOBILITY_NOPICKUP, SLIMEPUDDLE_TRAIT)
				ADD_TRAIT(H, TRAIT_MOBILITY_NOUSE, SLIMEPUDDLE_TRAIT)
				ADD_TRAIT(H, TRAIT_SPRINT_LOCKED, SLIMEPUDDLE_TRAIT)
				ADD_TRAIT(H, TRAIT_MOBILITY_NOREST, SLIMEPUDDLE_TRAIT)
				ADD_TRAIT(H, TRAIT_ARMOR_BROKEN, SLIMEPUDDLE_TRAIT)
				H.update_disabled_bodyparts(silent = TRUE)	//silently update arms to be paralysed

				H.add_movespeed_modifier(/datum/movespeed_modifier/slime_puddle)

				H.pass_flags |= PASSMOB //this actually lets people pass over you
				squeak = H.AddComponent(/datum/component/squeak, custom_sounds = list('sound/effects/blobattack.ogg')) //blorble noise when people step on you

				//if the user is a changeling, retract their sting
				H.unset_sting()

				sleep(in_transformation_duration) //wait for animation to end

				//set the puddle overlay up
				var/mutable_appearance/puddle_overlay = mutable_appearance(icon = puddle_icon, icon_state = puddle_state)
				puddle_overlay.color = mutcolor
				tracked_overlay = puddle_overlay
				owner.add_overlay(puddle_overlay)
				owner.update_antag_overlays()

				transforming = FALSE
				UpdateButtons()
		else
			detransform()
	else
		to_chat(owner, "<span class='warning'>You need to be standing up to do this!") //just assume they're a slime because it's such a weird edgecase to have it and not be one (it shouldn't even be possible)

/datum/action/innate/ability/slime_blobform/proc/detransform()
	var/mob/living/carbon/human/H = owner
	//like the above, but reverse everything done!
	H.cut_overlay(tracked_overlay)
	var/obj/effect/puddle_effect = new puddle_from_effect(get_turf(owner), owner.dir)
	puddle_effect.color = tracked_overlay.color
	puddle_effect.transform = H.transform //copy mob size for consistent transform size
	H.Stun(out_transformation_duration, ignore_canstun = TRUE)
	sleep(out_transformation_duration)
	REMOVE_TRAIT(H, TRAIT_PARALYSIS_L_ARM, SLIMEPUDDLE_TRAIT)
	REMOVE_TRAIT(H, TRAIT_PARALYSIS_R_ARM, SLIMEPUDDLE_TRAIT)
	REMOVE_TRAIT(H, TRAIT_MOBILITY_NOPICKUP, SLIMEPUDDLE_TRAIT)
	REMOVE_TRAIT(H, TRAIT_MOBILITY_NOUSE, SLIMEPUDDLE_TRAIT)
	REMOVE_TRAIT(H, TRAIT_SPRINT_LOCKED, SLIMEPUDDLE_TRAIT)
	REMOVE_TRAIT(H, TRAIT_MOBILITY_NOREST, SLIMEPUDDLE_TRAIT)
	REMOVE_TRAIT(H, TRAIT_ARMOR_BROKEN, SLIMEPUDDLE_TRAIT)
	REMOVE_TRAIT(H, TRAIT_HUMAN_NO_RENDER, SLIMEPUDDLE_TRAIT)
	H.update_disabled_bodyparts(silent = TRUE)
	H.remove_movespeed_modifier(/datum/movespeed_modifier/slime_puddle)
	H.pass_flags &= ~(PASSMOB)
	is_puddle = FALSE
	if(squeak)
		squeak.RemoveComponent()
	H.regenerate_icons()
	transforming = FALSE
	UpdateButtons()
