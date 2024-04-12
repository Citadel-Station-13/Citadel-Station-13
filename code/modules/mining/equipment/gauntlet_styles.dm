/datum/gauntlet_style
	var/name = "Baseline"
	var/desc = "Somehow, you sense two things; one, that there's no combos on this, and two, that you should probably have someone address this."
	var/obj/item/kinetic_crusher/glaive/gauntlets/hands // catch these

/datum/gauntlet_style/proc/on_apply(obj/item/kinetic_crusher/glaive/gauntlets/theseNewHands)
	hands = theseNewHands
	return // todo: changing variables per style

/datum/gauntlet_style/proc/check_streak(mob/living/carbon/human/attacker, mob/living/defender)
	return FALSE

/datum/gauntlet_style/proc/reset_streak(mob/living/carbon/user)
	hands.streak = ""
	user?.hud_used?.combo_display.update_icon_state(hands.streak)

/datum/gauntlet_style/proc/examine_more_info()
	return desc

#define BRAWLER_COMBO_CROSS "DH"
/datum/gauntlet_style/brawler
	name = "Rough and Tumble"
	desc = "Throwing a punch is simple. Throwing a punch with a destabilizing module strapped to your hand is less so, but still doable."

/datum/gauntlet_style/brawler/examine_more_info()
	var/msg = list(span_notice(desc))
	msg += "Techniques:"
	msg += "Cross Punch - Disarm, Harm. In addition to being a regular strike, deals an extra third of a regular detonation's damage." // this wording kinda sucks i think
	return msg

/datum/gauntlet_style/brawler/check_streak(mob/living/carbon/human/attacker, mob/living/defender)
	if(findtext(hands.streak, BRAWLER_COMBO_CROSS))
		crossCombo(attacker, defender)
		return TRUE
	return FALSE

/datum/gauntlet_style/brawler/proc/crossCombo(mob/living/carbon/attacker, mob/living/defender)
	reset_streak(attacker)
	playsound(attacker, 'sound/weapons/punch4.ogg', 100, FALSE)
	var/bonus_damage = (hands.force + hands.detonation_damage) / 3
	defender.apply_damage(bonus_damage, BRUTE, blocked = defender.getarmor(type = BOMB))
	var/datum/status_effect/crusher_damage/cd_tracker = defender.has_status_effect(STATUS_EFFECT_CRUSHERDAMAGETRACKING)
	if(!QDELETED(defender) && !QDELETED(cd_tracker))
		cd_tracker.total_damage += bonus_damage //we did some damage, but let's not assume how much we did
	defender.visible_message("<span class='warning'>[attacker] delivers a solid one-two punch to [defender]!</span>", \
							"<span class='userdanger'>[attacker] hits you with a solid one-two punch!</span>")
	return TRUE


#undef BRAWLER_COMBO_CROSS
