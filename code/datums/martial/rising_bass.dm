#define SIDE_KICK_COMBO "DH"
#define SHOULDER_FLIP_COMBO "GHDGG"
#define REPULSE_PUNCH_COMBO "GHGH"
#define FOOT_SMASH_COMBO "HH"
#define DEFT_SWITCH_COMBO "GDD"

/datum/martial_art/the_rising_bass
	name = "The Rising Bass"
	id = MARTIALART_RISINGBASS
	var/dodge_chance = 100
	no_guns = TRUE
	allow_temp_override = FALSE
	help_verb = /mob/living/carbon/human/proc/rising_bass_help

/datum/martial_art/the_sleeping_carp/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(findtext(streak,SIDE_KICK_COMBO))
		streak = ""
		sideKick(A,D)
		return 1
	if(findtext(streak,SHOULDER_FLIP_COMBO))
		streak = ""
		shoulderFlip(A,D)
		return 1
	if(findtext(streak,REPULSE_PUNCH_COMBO))
		streak = ""
		repulsePunch(A,D)
		return 1
	if(findtext(streak,FOOT_SMASH_COMBO))
		streak = ""
		footSmash(A,D)
		return 1
	if(findtext(streak,DEFT_SWITCH_COMBO))
		streak = ""
		deftSwitch(A,D)
		return 1
	return 0

/datum/martial_art/the_sleeping_carp/proc/sideKick(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.IsKnockdown())
		A.do_attack_animation(D, ATTACK_EFFECT_KICK)
		D.visible_message("<span class='warning'>[A] kicks [D] in the side, sliding them over!</span>", \
						  "<span class='userdanger'>[A] kicks you in the side, forcing you to step away!</span>")
		playsound(get_turf(A), 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		D.apply_damage(10, BRUTE, BODY_ZONE_CHEST)
		D.Knockdown(60)
		return 1
	log_combat(A, D, "side kicked (Rising Bass)")
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/proc/shoulderFlip(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.IsKnockdown())
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		D.visible_message("<span class='warning'>[A] flips [D] over their shoulder, slamming them into the ground!</span>", \
						  "<span class='userdanger'>[A] flips you over their shoulder, slamming you into the ground!</span>")
		playsound(get_turf(A), 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		D.emote("scream")
		D.apply_damage(10, BRUTE, BODY_ZONE_CHEST)
		D.apply_damage(30, BRUTE, BODY_ZONE_HEAD)
		D.Knockdown(300)
		return 1
	log_combat(A, D, "shoulder flipped (Rising Bass)")
	return basic_hit(A,D)






