#define SIDE_KICK_COMBO "DH"
#define SHOULDER_FLIP_COMBO "GHDGHH"
#define FOOT_SMASH_COMBO "HH"

/datum/martial_art/the_rising_bass
	name = "The Rising Bass"
	id = MARTIALART_RISINGBASS
	dodge_chance = 100
	allow_temp_override = FALSE
	help_verb = /mob/living/carbon/human/proc/rising_bass_help
	var/datum/action/risingbassmove/repulsepunch = new/datum/action/risingbassmove/repulsepunch()
	var/datum/action/risingbassmove/deftswitch = new/datum/action/risingbassmove/deftswitch()
	var/repulsecool = 0

/datum/martial_art/the_rising_bass/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(findtext(streak,SIDE_KICK_COMBO))
		streak = ""
		sideKick(A,D)
		return 1
	if(findtext(streak,SHOULDER_FLIP_COMBO))
		streak = ""
		shoulderFlip(A,D)
		return 1
	if(findtext(streak,"rplse"))
		streak = ""
		repulsePunch(A,D)
		return 1
	if(findtext(streak,FOOT_SMASH_COMBO))
		streak = ""
		footSmash(A,D)
		return 1
	if(findtext(streak,"deft"))
		streak = ""
		deftSwitch(A,D)
		return 1
	return 0


//Repulse Punch - Slams the opponent far away from you.
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

/datum/action/risingbassmove/repulsepunch
	name = "Repulse Punch"
	button_icon_state = "repulsepunch"
	movestreak = "rplse"

/datum/action/risingbassmove/deftswitch
	name = "Deft Switch"
	button_icon_state = "deftswitch"
	movestreak = "deft"


/datum/martial_art/the_rising_bass/proc/sideKick(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.IsKnockdown() || D.lying == 0)
		var/turf/H = get_step(D, A.dir & (NORTH | SOUTH) ? pick(EAST, WEST) : pick(NORTH, SOUTH))
		A.do_attack_animation(D, ATTACK_EFFECT_KICK)
		D.visible_message("<span class='warning'>[A] kicks [D] in the side, sliding them over!</span>", \
						  "<span class='userdanger'>[A] kicks you in the side, forcing you to step away!</span>")
		playsound(get_turf(A), 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		D.apply_damage(5, BRUTE, BODY_ZONE_CHEST)
		D.Knockdown(60)
		var/L = H
		for(var/obj/i in H.contents)
			if(!istype(i,/mob) && i.density == 1)
				L = D.loc
		D.forceMove(L)
		log_combat(A, D, "side kicked (Rising Bass)")
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_rising_bass/proc/shoulderFlip(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.IsKnockdown() || !D.lying)
		var/turf/H = get_step(A, get_dir(D,A))
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
		D.Sleeping(60)
		D.Knockdown(300)
		D.forceMove(L)
		log_combat(A, D, "shoulder flipped (Rising Bass)")
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_rising_bass/proc/repulsePunch(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.IsKnockdown() || !D.lying || repulsecool > world.time)
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		D.visible_message("<span class='warning'>[A] smashes [D] in the chest, throwing them away!</span>", \
						  "<span class='userdanger'>[A] smashes you in the chest, repelling you away!</span>")
		playsound(get_turf(A), 'sound/weapons/punch1.ogg', 50, 1, -1)
		var/atom/F = get_edge_target_turf(D, get_dir(A, get_step_away(D, A)))
		D.throw_at(F, 10, 1)
		D.apply_damage(10, BRUTE, BODY_ZONE_CHEST)
		D.Knockdown(90)
		log_combat(A, D, "repulse punched (Rising Bass)")
		repulsecool = world.time + 3 SECONDS
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
			if (G && !(G.item_flags & (ABSTRACT|DROPDEL)) && D.temporarilyRemoveItemFromInventory(G))
				A.put_in_hands(G)
				D.visible_message("<span class='warning'>[A] slaps [D]'s hands, taking [G] from them!</span>", \
					"<span class='userdanger'>[A] slaps you, taking [G] from you!</span>")
				log_combat(A, D, "deft switched (Rising Bass)")
				return 1
			else
				to_chat(A, "<i>[G] can't be taken out of [D]'s hands!</i>")
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

/datum/martial_art/the_rising_bass/add_to_streak(element,mob/living/carbon/human/D)
	if (streak == "deft" || streak == "rplse")
		return
	. = ..()

/mob/living/carbon/human/proc/rising_bass_help()
	set name = "Recall Teachings"
	set desc = "Remember the martial techniques of the Rising Bass clan."
	set category = "Rising Bass"

	to_chat(usr, "<b><i>You retreat inward and recall the teachings of the Rising Bass...</i></b>")

	to_chat(usr, "<span class='notice'>Side Kick</span>: Disarm Harm. Forces opponent to step to the side.")
	to_chat(usr, "<span class='notice'>Shoulder Flip</span>: Grab Harm Disarm Grab Harm Harm. Flips opponent over your shoulder and stuns.")
	to_chat(usr, "<span class='notice'>Repulse Punch</span>: Grab Harm Grab Harm. Slams the opponent far away from you.")
	to_chat(usr, "<span class='notice'>Foot Smash</span>: Harm Harm. Stuns opponent, minor damage.")
	to_chat(usr, "<span class='notice'>Deft Switch</span>: Grab Disarm Disarm. Switches the opponent's held item for your own. Most useful with nothing in your hand.")

/datum/martial_art/the_rising_bass/teach(mob/living/carbon/human/H, make_temporary = FALSE)
	. = ..()
	if(!.)
		return
	deftswitch.Grant(H)
	repulsepunch.Grant(H)
	ADD_TRAIT(H, TRAIT_NOGUNS, RISING_BASS_TRAIT)
	ADD_TRAIT(H, TRAIT_AUTO_CATCH_ITEM, RISING_BASS_TRAIT)

/datum/martial_art/the_rising_bass/on_remove(mob/living/carbon/human/H)
	. = ..()
	deftswitch.Remove(H)
	repulsepunch.Remove(H)
	REMOVE_TRAIT(H, TRAIT_NOGUNS, RISING_BASS_TRAIT)
	REMOVE_TRAIT(H, TRAIT_AUTO_CATCH_ITEM, RISING_BASS_TRAIT)