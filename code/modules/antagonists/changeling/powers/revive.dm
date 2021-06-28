/obj/effect/proc_holder/changeling/revive
	name = "Revive"
	desc = "We regenerate, healing all damage from our form."
	helptext = "Does not regrow lost organs or a missing head."
	req_stat = DEAD
	always_keep = TRUE
	ignores_fakedeath = TRUE
	action_icon = 'icons/mob/actions/actions_changeling.dmi'
	action_icon_state = "ling_revive"
	action_background_icon_state = "bg_ling"

//Revive from revival stasis
/obj/effect/proc_holder/changeling/revive/sting_action(mob/living/carbon/user)
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	if(!changeling)
		return
	if(changeling.hostile_absorbed)
		to_chat(user, "<span class='notice'>We cannot muster up the strength to revive ourselves!</span>")
		changeling.purchasedpowers -= src
		src.action.Remove(user)
		return
	user.cure_fakedeath("changeling")
	user.revive(full_heal = 1)
	var/list/missing = user.get_missing_limbs()
	missing -= BODY_ZONE_HEAD // headless changelings are funny
	if(missing.len)
		playsound(user, 'sound/magic/demon_consume.ogg', 50, 1)
		user.visible_message("<span class='warning'>[user]'s missing limbs \
			reform, making a loud, grotesque sound!</span>",
			"<span class='userdanger'>Your limbs regrow, making a \
			loud, crunchy sound and giving you great pain!</span>",
			"<span class='italics'>You hear organic matter ripping \
			and tearing!</span>")
		user.emote("scream")
		user.regenerate_limbs(0, list(BODY_ZONE_HEAD))
	user.regenerate_organs()
	to_chat(user, "<span class='notice'>We have revived ourselves.</span>")
	changeling.purchasedpowers -= src
	src.action.Remove(user)
	return TRUE

/obj/effect/proc_holder/changeling/revive/can_be_used_by(mob/living/user)
	. = ..()
	if(!.)
		return
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	if(!changeling)
		return FALSE
	if(changeling.hostile_absorbed || ((user.stat != DEAD) && !(HAS_TRAIT(user, TRAIT_DEATHCOMA))))
		changeling.purchasedpowers -= src
		return FALSE

