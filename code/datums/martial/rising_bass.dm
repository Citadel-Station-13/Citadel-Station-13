#define REPULSE_PUNCH_COMBO "HDD"
#define SHOULDER_FLIP_COMBO "DHDHG"
#define FOOT_SMASH_COMBO "HH"
#define SIDE_KICK_COMBO "skick"
#define DEFT_SWITCH_COMBO "deft"

/datum/martial_art/the_rising_bass
	name = "The Rising Bass"
	id = MARTIALART_RISINGBASS
	allow_temp_override = FALSE
	help_verb = /mob/living/carbon/human/proc/rising_bass_help
	pugilist = TRUE
	var/datum/action/risingbassmove/sidekick = new/datum/action/risingbassmove/sidekick()
	var/datum/action/risingbassmove/deftswitch = new/datum/action/risingbassmove/deftswitch()
	var/repulsecool = 0
	display_combos = TRUE

/datum/martial_art/the_rising_bass/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(findtext(streak,SIDE_KICK_COMBO))
		streak = ""
		sideKick(A,D)
		return TRUE
	if(findtext(streak,SHOULDER_FLIP_COMBO))
		streak = ""
		shoulderFlip(A,D)
		return TRUE
	if(findtext(streak,REPULSE_PUNCH_COMBO))
		streak = ""
		repulsePunch(A,D)
		return TRUE
	if(findtext(streak,FOOT_SMASH_COMBO))
		streak = ""
		footSmash(A,D)
		return TRUE
	if(findtext(streak,DEFT_SWITCH_COMBO))
		streak = ""
		deftSwitch(A,D)
		return TRUE
	return FALSE


/datum/action/risingbassmove
	name = ""
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = ""
	var/movestreak = ""

/datum/action/risingbassmove/Trigger()
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't use [name] while you're incapacitated.</span>")
		return
	var/mob/living/carbon/human/H = owner
	if (H.mind.martial_art.streak == "[movestreak]")
		H.mind.martial_art.streak = ""
		to_chat(H,"<span class='danger'>You relax your muscles and return to a neutral position.</span>")
	else
		if(HAS_TRAIT(H, TRAIT_PACIFISM))
			to_chat(H, "<span class='warning'>You don't want to harm other people!</span>")
			return
		to_chat(H,"<span class='danger'>You get ready to use the [name] maneuver!</span>")
		H.mind.martial_art.streak = "[movestreak]"

/datum/action/risingbassmove/sidekick
	name = "Side Kick"
	button_icon_state = "sidekick"
	movestreak = "skick"

/datum/action/risingbassmove/deftswitch
	name = "Deft Switch"
	button_icon_state = "deftswitch"
	movestreak = "deft"

/datum/martial_art/the_rising_bass/proc/checkfordensity(turf/T,mob/M)
	if (T.density)
		return FALSE
	for(var/obj/O in T)
		if(!O.CanPass(M,T))
			return FALSE
	return TRUE

/datum/martial_art/the_rising_bass/proc/sideKick(mob/living/carbon/human/A, mob/living/carbon/human/D)
	var/damage = (damage_roll(A,D)*0.5)
	if(CHECK_MOBILITY(D, MOBILITY_STAND))
		var/dir = A.dir & (NORTH | SOUTH) ? pick(EAST, WEST) : pick(NORTH, SOUTH)
		var/oppdir = dir == NORTH ? SOUTH : dir == SOUTH ? NORTH : dir == EAST ? WEST : EAST
		var/turf/H = get_step(D, dir)
		var/turf/K = get_step(D, oppdir)
		A.do_attack_animation(D, ATTACK_EFFECT_KICK)
		D.visible_message("<span class='warning'>[A] kicks [D] in the side, sliding them over!</span>", \
						  "<span class='userdanger'>[A] kicks you in the side, forcing you to step away!</span>")
		playsound(get_turf(A), 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		D.apply_damage(damage, BRUTE, BODY_ZONE_CHEST)
		D.DefaultCombatKnockdown(60, override_hardstun = 1, override_stamdmg = damage)
		var/L = !checkfordensity(H,D) ? (!checkfordensity(K,D) ? D.loc : K) : H
		D.forceMove(L)
		log_combat(A, D, "side kicked (Rising Bass)")
		return TRUE
	return TRUE

/datum/martial_art/the_rising_bass/proc/shoulderFlip(mob/living/carbon/human/A, mob/living/carbon/human/D)
	var/damage = damage_roll(A,D)
	var/stunthreshold = A.dna.species.punchstunthreshold
	var/turf/H = get_step(A, get_dir(D,A))
	var/L = checkfordensity(H,D) ? H : A.loc
	A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
	D.visible_message("<span class='warning'>[A] flips [D] over their shoulder, slamming them into the ground!</span>", \
					  "<span class='userdanger'>[A] flips you over their shoulder, slamming you into the ground!</span>")
	playsound(get_turf(A), 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	D.emote("scream")
	D.apply_damage(damage + 10, BRUTE, BODY_ZONE_CHEST)
	D.apply_damage(damage + 10, BRUTE, BODY_ZONE_HEAD)
	if(damage >= stunthreshold)
		D.Sleeping(60)
	D.DefaultCombatKnockdown(300, override_hardstun = 1, override_stamdmg = 50)
	D.forceMove(L)
	log_combat(A, D, "shoulder flipped (Rising Bass)")
	return TRUE

//Repulse Punch - Slams the opponent far away from you.
/datum/martial_art/the_rising_bass/proc/repulsePunch(mob/living/carbon/human/A, mob/living/carbon/human/D)
	var/damage = damage_roll(A,D)
	if(CHECK_MOBILITY(D, MOBILITY_STAND) && repulsecool < world.time)
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		D.visible_message("<span class='warning'>[A] smashes [D] in the chest, throwing them away!</span>", \
						  "<span class='userdanger'>[A] smashes you in the chest, repelling you away!</span>")
		playsound(get_turf(A), 'sound/weapons/punch1.ogg', 50, 1, -1)
		var/atom/F = get_edge_target_turf(D, get_dir(A, get_step_away(D, A)))
		D.throw_at(F, 10, 1)
		D.apply_damage(damage, BRUTE, BODY_ZONE_CHEST)
		D.DefaultCombatKnockdown(90, override_hardstun = 1, override_stamdmg = damage*2)
		D.confused += min(damage, 20)
		log_combat(A, D, "repulse punched (Rising Bass)")
		repulsecool = world.time + 3 SECONDS
		return TRUE
	return FALSE

/datum/martial_art/the_rising_bass/proc/footSmash(mob/living/carbon/human/A, mob/living/carbon/human/D)
	var/damage = (damage_roll(A,D)*0.5)
	if(CHECK_MOBILITY(D, MOBILITY_STAND))
		A.do_attack_animation(D, ATTACK_EFFECT_KICK)
		D.visible_message("<span class='warning'>[A] smashes their foot down on [D]'s foot!</span>", \
						  "<span class='userdanger'>[A] smashes your foot!</span>")
		playsound(get_turf(A), 'sound/weapons/punch1.ogg', 50, 1, -1)
		D.apply_damage(damage, BRUTE, pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
		D.dropItemToGround(D.get_active_held_item())
		log_combat(A, D, "foot smashed (Rising Bass)")
		return TRUE
	return FALSE

/datum/martial_art/the_rising_bass/proc/deftSwitch(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(CHECK_MOBILITY(D, MOBILITY_STAND))
		if (D.get_active_held_item())
			var/obj/item/G = D.get_active_held_item()
			if (G && !(G.item_flags & (ABSTRACT|DROPDEL)) && D.temporarilyRemoveItemFromInventory(G))
				A.put_in_hands(G)
				D.visible_message("<span class='warning'>[A] slaps [D]'s hands, taking [G] from them!</span>", \
					"<span class='userdanger'>[A] slaps you, taking [G] from you!</span>")
				log_combat(A, D, "deft switched (Rising Bass)")
				return TRUE
			else
				to_chat(A, "<i>[G] can't be taken out of [D]'s hands!</i>")
	return FALSE

/datum/martial_art/the_rising_bass/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("D",D)
	if(check_streak(A,D))
		return TRUE
	var/damage = damage_roll(A,D)
	var/stunthreshold = A.dna.species.punchstunthreshold
	A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
	if(CHECK_MOBILITY(D, MOBILITY_STAND) && damage >= stunthreshold)
		D.visible_message("<span class='danger'>[A] trips [D]!</span>", \
					"<span class='userdanger'>You're tripped by [A]!</span>", "<span class='hear'>You hear something thump against the floor!</span>", COMBAT_MESSAGE_RANGE, A)
		to_chat(A, "<span class='danger'>You trip [D]!</span>")
		D.DefaultCombatKnockdown(10, override_hardstun = 0.01, override_stamdmg = damage)
		D.Dizzy(damage)
	else
		D.visible_message("<span class='danger'>[A] jabs [D] in the stomach!</span>", \
					"<span class='userdanger'>You're jabbed in the stomach by [A]!</span>", "<span class='hear'>You hear a sickening sound of flesh hitting flesh!</span>", COMBAT_MESSAGE_RANGE, A)
		to_chat(A, "<span class='danger'>You jab [D] in the stomach!</span>")
		D.apply_damage(damage*2 + 10, STAMINA)
		D.disgust = min(damage, 20)
	playsound(D, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	return TRUE

/datum/martial_art/the_rising_bass/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("H",D)
	if(check_streak(A,D))
		return TRUE
	return ..()

/datum/martial_art/the_rising_bass/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("G",D)
	if(check_streak(A,D))
		return TRUE
	return ..()

/datum/martial_art/the_rising_bass/add_to_streak(element,mob/living/carbon/human/D)
	if (streak == DEFT_SWITCH_COMBO || streak == SIDE_KICK_COMBO)
		return
	. = ..()

/datum/martial_art/the_rising_bass/on_projectile_hit(mob/living/carbon/human/A, obj/item/projectile/P, def_zone)
	. = ..()
	if(A.incapacitated(FALSE, TRUE)) //NO STUN
		return BULLET_ACT_HIT
	if(!CHECK_ALL_MOBILITY(A, MOBILITY_USE|MOBILITY_STAND)) //NO UNABLE TO USE, NO DODGING ON THE FLOOR
		return BULLET_ACT_HIT
	if(A.dna && A.dna.check_mutation(HULK)) //NO HULK
		return BULLET_ACT_HIT
	if(!isturf(A.loc)) //NO MOTHERFLIPPIN MECHS!
		return BULLET_ACT_HIT
	A.visible_message("<span class='danger'>[A] dodges the projectile cleanly, they're immune to ranged weapons!</span>", "<span class='userdanger'>You dodge out of the way of the projectile!</span>")
	playsound(get_turf(A), pick('sound/weapons/bulletflyby.ogg', 'sound/weapons/bulletflyby2.ogg', 'sound/weapons/bulletflyby3.ogg'), 75, TRUE)
	return BULLET_ACT_FORCE_PIERCE

/mob/living/carbon/human/proc/rising_bass_help()
	set name = "Recall Teachings"
	set desc = "Remember the martial techniques of the Rising Bass clan."
	set category = "Rising Bass"

	to_chat(usr, "<b><i>You retreat inward and recall the teachings of the Rising Bass...</i></b>")

	to_chat(usr, "<span class='notice'>Side Kick</span>: Forces opponent to step to the side.")
	to_chat(usr, "<span class='notice'>Shoulder Flip</span>: Disarm Harm Disarm Harm Grab. Flips opponent over your shoulder and stuns.")
	to_chat(usr, "<span class='notice'>Repulse Punch</span>: Harm Disarm Disarm. Slams the opponent far away from you.")
	to_chat(usr, "<span class='notice'>Foot Smash</span>: Harm Harm. Knocks opponent prone, minor damage.")
	to_chat(usr, "<span class='notice'>Deft Switch</span>: Switches the opponent's held item for your own. Most useful with nothing in your hand.")

/datum/martial_art/the_rising_bass/teach(mob/living/carbon/human/H, make_temporary = FALSE)
	. = ..()
	if(!.)
		return
	deftswitch.Grant(H)
	sidekick.Grant(H)
	ADD_TRAIT(H, TRAIT_NOGUNS, RISING_BASS_TRAIT)
	ADD_TRAIT(H, TRAIT_AUTO_CATCH_ITEM, RISING_BASS_TRAIT)

/datum/martial_art/the_rising_bass/on_remove(mob/living/carbon/human/H)
	. = ..()
	deftswitch.Remove(H)
	sidekick.Remove(H)
	REMOVE_TRAIT(H, TRAIT_NOGUNS, RISING_BASS_TRAIT)
	REMOVE_TRAIT(H, TRAIT_AUTO_CATCH_ITEM, RISING_BASS_TRAIT)
