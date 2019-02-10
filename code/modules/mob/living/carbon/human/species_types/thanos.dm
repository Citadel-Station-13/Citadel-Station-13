/datum/species/thanos
	name = "Thanos"
	id = "thanos"
	say_mod = "perfectly balances"
	speedmod = 0.3
	brutemod = 0.2
	burnmod = 0.2
	coldmod = -0.5 // Frio heala dano de burn
	heatmod = 1
	punchdamagelow = 50
	punchdamagehigh = 80
	punchstunthreshold = 50
	attack_verb = "smash"
	attack_sound = 'sound/weapons/resonator_blast.ogg'
	blacklisted = FALSE
	use_skintones = FALSE
	species_traits = list(NOBLOOD,EYECOLOR)
	inherent_traits = list(TRAIT_RADIMMUNE,TRAIT_VIRUSIMMUNE,TRAIT_PIERCEIMMUNE,TRAIT_NODISMEMBER,TRAIT_NOHUNGER)
	sexes = TRUE
	default_color = "#663399"
	var/last_blast
	var/blast_cooldown = 20
	var/thanos_prob = 33
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
		thane(H)
	..()

/datum/species/thanos/spec_attack_hand(mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	..()
	if(world.time > last_blast + blast_cooldown &&  M.a_intent != INTENT_HELP)
		thane(H)

/datum/species/thanos/spec_hitby(atom/movable/AM, mob/living/carbon/human/H)
	..()
	if(world.time > last_blast + blast_cooldown &&  H.a_intent != INTENT_HELP)
		thane(H)


/datum/species/thanos/proc/thane(mob/living/carbon/human/H)
	last_blast = world.time
	for(var/mob/living/M in get_hearers_in_view(7,usr))
		M.show_message("<span class='narsiesmall'>SNAP!</span>", 2)
		if(M == src)
			M.playsound_local(H, 'modular_citadel/sound/misc/thanos.ogg', 100, TRUE)
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "thanged", /datum/mood_event/thaned)
			return
		if(M.stat == DEAD)
			M.gib()
			return
		else
			M.apply_effect(80, EFFECT_KNOCKDOWN)
			M.playsound_local(M, 'sound/effects/Explosion1.ogg', 100, TRUE)
			M.soundbang_act(2, 0, 100, 1)
			M.jitteriness += 10
			SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "thanged", /datum/mood_event/thaned)