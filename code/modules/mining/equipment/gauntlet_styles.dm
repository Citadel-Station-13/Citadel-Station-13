/datum/gauntlet_style
	var/name = "Baseline"
	var/desc = "There's no combos here, only bugs. Report this to a coder if you see this."
	var/list/examine_movesets /// you're manually filling this out btw

/datum/gauntlet_style/proc/on_apply(obj/item/kinetic_crusher/glaive/gauntlets/hands)
	return // todo: changing variables per style

/datum/gauntlet_style/proc/check_streak(mob/living/carbon/human/attacker, mob/living/defender, obj/item/kinetic_crusher/glaive/gauntlets/hands)
	return FALSE

#define BRAWLER_COMBO_CROSS "DH"
/datum/gauntlet_style/brawler
	name = "Brawler"
	desc = "Throwing a punch is, theoretically, simple. Throwing a punch with a destabilizing module strapped to your hand? ...A bit less simple."
	examine_movesets = list("Disarm, Harm" = "One-Two Cross: Bonus damage. Chance of stunning.")

/datum/gauntlet_style/brawler/check_streak(mob/living/carbon/human/attacker, mob/living/defender, obj/item/kinetic_crusher/glaive/gauntlets/hands)
	if(hands.streak.findtext(BRAWLER_COMBO_CROSS))
		hands.streak = ""
		crossCombo(attacker, defender)
		return TRUE
	return FALSE

/datum/gauntlet_style/brawler/proc/crossCombo(attacker, defender)
	defender.apply_damage(hands.detonation_damage/3, BRUTE, blocked = defender.getarmor(type = BOMB))
	playsound(attacker, 'sound/weapons/punch1.ogg', 100, 1)
	D.visible_message("<span class='warning'>[attacker] delivers a solid one-two punch to [defender]!</span>", \
							"<span class='userdanger'>[attacker] hits you with a solid one-two punch!</span>")

#undef BRAWLER_CROSS
