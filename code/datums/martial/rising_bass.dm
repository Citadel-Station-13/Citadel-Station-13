#define SIDE_KICK_COMBO "DH"
#define SHOULDER_FLIP_COMBO "GHDGHH"
#define REPULSE_PUNCH_COMBO "GHGH"
#define FOOT_SMASH_COMBO "HH"
#define DEFT_SWITCH_COMBO "GDD"

/datum/martial_art/the_rising_bass
	name = "The Rising Bass"
	id = MARTIALART_RISINGBASS
	dodge_chance = 100
	no_guns = TRUE
	allow_temp_override = FALSE
	help_verb = /mob/living/carbon/human/proc/rising_bass_help

/datum/martial_art/the_rising_bass/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
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


/datum/martial_art/the_rising_bass/proc/sideKick(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.IsKnockdown() || D.lying == 0)
		var/turf/H = get_step(D, A.dir & (NORTH | SOUTH) ? pick(EAST, WEST) : pick(NORTH, SOUTH))
		A.do_attack_animation(D, ATTACK_EFFECT_KICK)
		D.visible_message("<span class='warning'>[A] kicks [D] in the side, sliding them over!</span>", \
						  "<span class='userdanger'>[A] kicks you in the side, forcing you to step away!</span>")
		playsound(get_turf(A), 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		D.apply_damage(5, BRUTE, BODY_ZONE_CHEST)
		D.Knockdown(60)
		if (H)
			D.Move(H, get_dir(D,H))
		log_combat(A, D, "side kicked (Rising Bass)")
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_rising_bass/proc/shoulderFlip(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.IsKnockdown() || !D.lying)
		var/turf/H
		switch(A.dir)
			if(NORTH)
				H = get_step(A,SOUTH)
			if(EAST)
				H = get_step(A,WEST)
			if(SOUTH)
				H = get_step(A,NORTH)
			if(WEST)
				H = get_step(A,EAST)
		var/L = H
		for(var/obj/i in H.contents)
			if(!istype(i,/mob) && i.density == 1)//(i.anchored == 1 && i.density == 1) || istype(i,/obj/structure) || istype(i,/turf/closed)
				L = A.loc
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		D.visible_message("<span class='warning'>[A] flips [D] over their shoulder, slamming them into the ground!</span>", \
						  "<span class='userdanger'>[A] flips you over their shoulder, slamming you into the ground!</span>")
		playsound(get_turf(A), 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		D.emote("scream")
		D.apply_damage(10, BRUTE, BODY_ZONE_CHEST)
		D.apply_damage(30, BRUTE, BODY_ZONE_HEAD)
		D.SetSleeping(60)
		D.Knockdown(300)
		D.forceMove(L)
		log_combat(A, D, "shoulder flipped (Rising Bass)")
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_rising_bass/proc/repulsePunch(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.IsKnockdown() || !D.lying)
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		D.visible_message("<span class='warning'>[A] smashes [D] in the chest, throwing them away!</span>", \
						  "<span class='userdanger'>[A] smashes you in the chest, repelling you away!</span>")
		playsound(get_turf(A), 'sound/weapons/punch1.ogg', 50, 1, -1)
		var/atom/F = get_edge_target_turf(D, get_dir(A, get_step_away(D, A)))
		D.throw_at(F, 10, 1)
		D.apply_damage(10, BRUTE, BODY_ZONE_CHEST)
		D.Knockdown(90)
		log_combat(A, D, "repulse punched (Rising Bass)")
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_rising_bass/proc/footSmash(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.IsKnockdown() || !D.lying)
		A.do_attack_animation(D, ATTACK_EFFECT_KICK)
		D.visible_message("<span class='warning'>[A] smashes their foot down on [D]'s foot!</span>", \
						  "<span class='userdanger'>[A] smashes your foot!</span>")
		playsound(get_turf(A), 'sound/weapons/punch1.ogg', 50, 1, -1)
		D.apply_damage(5, BRUTE, pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
		D.dropItemToGround(D.get_active_held_item())
		log_combat(A, D, "foot smashed (Rising Bass)")
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_rising_bass/proc/deftSwitch(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.IsKnockdown() || !D.lying)
		if (D.get_active_held_item())
			var/obj/item/G = D.get_active_held_item()
			D.visible_message("<span class='warning'>[A] slaps [D]'s hands, taking [G] from them!</span>", \
				"<span class='userdanger'>[A] slaps you, taking [G] from you!</span>")
			D.temporarilyRemoveItemFromInventory(G, TRUE)
			A.put_in_hands(G)
			log_combat(A, D, "deft switched (Rising Bass)")
			return 1
	return 0

/datum/martial_art/the_rising_bass/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("D",D)
	if(check_streak(A,D))
		return 1
	return ..()

/datum/martial_art/the_rising_bass/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("H",D)
	if(check_streak(A,D))
		return 1
	return ..()

/datum/martial_art/the_rising_bass/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("G",D)
	if(check_streak(A,D))
		return 1
	return ..()

/mob/living/carbon/human/proc/rising_bass_help()
	set name = "Recall Teachings"
	set desc = "Remember the martial techniques of the Rising Bass clan."
	set category = "Rising Bass"

	to_chat(usr, "<b><i>You retreat inward and recall the teachings of the Rising Bass...</i></b>")

	to_chat(usr, "<span class='notice'>Side Kick</span>: Disarm Harm. Forces opponent to step to the side.")
	to_chat(usr, "<span class='notice'>Shoulder Flip</span>: Grab Harm Disarm Grab Grab. Flips opponent over your shoulder and stuns.")
	to_chat(usr, "<span class='notice'>Repulse Punch</span>: Grab Harm Grab Harm. Slams the opponent far away from you.")
	to_chat(usr, "<span class='notice'>Foot Smash</span>: Harm Harm. Stuns opponent, minor damage.")
	to_chat(usr, "<span class='notice'>Deft Switch</span>: Grab Disarm Disarm. Switches the opponent's held item for your own. Most useful with nothing in your hand.")