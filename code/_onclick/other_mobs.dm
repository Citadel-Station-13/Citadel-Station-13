/*
	Humans:
	Adds an exception for gloves, to allow special glove types like the ninja ones.

	Otherwise pretty standard.
*/
/mob/living/carbon/human/UnarmedAttack(atom/A, proximity)

	if(!has_active_hand()) //can't attack without a hand.
		src << "<span class='notice'>You look at your arm and sigh.</span>"
		return

	// Special glove functions:
	// If the gloves do anything, have them return 1 to stop
	// normal attack_hand() here.
	var/obj/item/clothing/gloves/G = gloves // not typecast specifically enough in defines
	if(proximity && istype(G) && G.Touch(A,1))
		return

	var/override = 0

	for(var/datum/mutation/human/HM in dna.mutations)
		override += HM.on_attack_hand(src, A)

	if(override)
		return

	A.attack_hand(src)

/atom/proc/attack_hand(mob/user)
	return

/atom/proc/interact(mob/user)
	return

/*
/mob/living/carbon/human/RestrainedClickOn(var/atom/A) ---carbons will handle this
	return
*/

/mob/living/carbon/RestrainedClickOn(atom/A)
	return 0

/mob/living/carbon/human/RangedAttack(atom/A)
	if(gloves)
		var/obj/item/clothing/gloves/G = gloves
		if(istype(G) && G.Touch(A,0)) // for magic gloves
			return

	for(var/datum/mutation/human/HM in dna.mutations)
		HM.on_ranged_attack(src, A)

	var/turf/T = A
	if(istype(T) && get_dist(src,T) <= 1)
		src.Move_Pulled(T)

/*
	Animals & All Unspecified
*/
/mob/living/UnarmedAttack(atom/A)
	A.attack_animal(src)

/mob/living/simple_animal/hostile/UnarmedAttack(atom/A)
	target = A
	AttackingTarget()

/atom/proc/attack_animal(mob/user)
	return
/mob/living/RestrainedClickOn(atom/A)
	return

/*
	Monkeys
*/
/mob/living/carbon/monkey/UnarmedAttack(atom/A)
	A.attack_paw(src)
/atom/proc/attack_paw(mob/user)
	return

/*
	Monkey RestrainedClickOn() was apparently the
	one and only use of all of the restrained click code
	(except to stop you from doing things while handcuffed);
	moving it here instead of various hand_p's has simplified
	things considerably
*/
/mob/living/carbon/monkey/RestrainedClickOn(atom/A)
	if(..())
		return
	if(a_intent != "harm" || !ismob(A))
		return
	if(is_muzzled())
		return
	var/mob/living/carbon/ML = A
	var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
	var/obj/item/bodypart/affecting = null
	if(ishuman(ML))
		var/mob/living/carbon/human/H = ML
		affecting = H.get_bodypart(ran_zone(dam_zone))
	var/armor = ML.run_armor_check(affecting, "melee")
	if(prob(75))
		ML.apply_damage(rand(1,3), BRUTE, affecting, armor)
		ML.visible_message("<span class='danger'>[name] bites [ML]!</span>", \
						"<span class='userdanger'>[name] bites [ML]!</span>")
		if(armor >= 2)
			return
		for(var/datum/disease/D in viruses)
			ML.ForceContractDisease(D)
	else
		ML.visible_message("<span class='danger'>[src] has attempted to bite [ML]!</span>")

/*
	Aliens
	Defaults to same as monkey in most places
*/
/mob/living/carbon/alien/UnarmedAttack(atom/A)
	A.attack_alien(src)
/atom/proc/attack_alien(mob/user)
	attack_paw(user)
	return
/mob/living/carbon/alien/RestrainedClickOn(atom/A)
	return

// Babby aliens
/mob/living/carbon/alien/larva/UnarmedAttack(atom/A)
	A.attack_larva(src)
/atom/proc/attack_larva(mob/user)
	return


/*
	Slimes
	Nothing happening here
*/
/mob/living/simple_animal/slime/UnarmedAttack(atom/A)
	A.attack_slime(src)
/atom/proc/attack_slime(mob/user)
	return
/mob/living/simple_animal/slime/RestrainedClickOn(atom/A)
	return

/*
	New Players:
	Have no reason to click on anything at all.
*/
/mob/new_player/ClickOn()
	return
