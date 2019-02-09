/datum/species/thanos
	name = "Thanos"
	id = "thanos"
	say_mod = "thanes"
	speedmod = -2
	brutemod = 0.01
	burnmod = 0.01
	coldmod = 0.01
	heatmod = 0.01
	punchdamagelow = 50
	punchdamagehigh = 80
	punchstunthreshold = 60
	attack_verb = "smash"
	attack_sound = 'sound/weapons/resonator_blast.ogg'
	blacklisted = FALSE
	use_skintones = FALSE
	species_traits = list(NOBLOOD,EYECOLOR)
	inherent_traits = list(TRAIT_RADIMMUNE,TRAIT_VIRUSIMMUNE,TRAIT_PIERCEIMMUNE,TRAIT_NODISMEMBER,TRAIT_NOHUNGER)
	sexes = TRUE
	var/last_blast
	var/blast_cooldown = 10
	var/thanos_prob = 80
	var/datum/action/innate/unstable_teleport/unstable_teleport

/datum/species/thanos/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	if(ishuman(C))
		unstable_teleport = new
		unstable_teleport.Grant(C)

/datum/species/thanos/on_species_loss(mob/living/carbon/C)
	if(unstable_teleport)
		unstable_teleport.Remove(C)
	..()

/datum/species/thanos/spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/carbon/human/H)
	if(world.time > last_blast + blast_cooldown && prob(thanos_prob))
		return FALSE
	..()
	if(world.time > last_blast + blast_cooldown)
		thane(H)

/datum/species/thanos/spec_attack_hand(mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	..()
	if(world.time > last_blast + blast_cooldown &&  M.a_intent != INTENT_HELP)
		thane(H)

/datum/species/thanos/spec_hitby(atom/movable/AM, mob/living/carbon/human/H)
	if(world.time > last_blast + blast_cooldown && prob(thanos_prob))
		return FALSE
	..()
	if(world.time > last_blast + blast_cooldown &&  M.a_intent != INTENT_HELP)
		thane(H)


/datum/species/thanos/proc/thane(mob/living/carbon/human/H)
	last_blast = world.time
	for(var/mob/living/M in get_hearers_in_view(7,H))
		if(M.stat == DEAD)
			return
		if(M == H)
			H.show_message("<span class='narsiesmall'>THANUSED</span>", 2)
			H.playsound_local(H, 'sound/effects/Explosion1.ogg', 100, TRUE)
			H.soundbang_act(2, 0, 100, 1)
			H.jitteriness += 7
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "thanged", /datum/mood_event/thaned)