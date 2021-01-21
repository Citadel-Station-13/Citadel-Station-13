



/datum/action/bloodsucker/fortitude
	name = "Fortitude"//"Cellular Emporium"
	desc = "Withstand egregious physical wounds and walk away from attacks that would stun, pierce, and dismember lesser beings. You cannot run while active."
	button_icon_state = "power_fortitude"
	bloodcost = 30
	cooldown = 80
	bloodsucker_can_buy = TRUE
	amToggle = TRUE
	warn_constant_cost = TRUE
	ability_traits = list(TRAIT_PIERCEIMMUNE, TRAIT_NODISMEMBER, TRAIT_STUNIMMUNE, TRAIT_NORUNNING)
	var/was_running

	var/this_resist // So we can raise and lower your brute resist based on what your level_current WAS.

/datum/action/bloodsucker/fortitude/ActivatePower()
	..()
	var/datum/antagonist/bloodsucker/bloodsuckerdatum = owner.mind.has_antag_datum(ANTAG_DATUM_BLOODSUCKER)
	var/mob/living/user = owner
	to_chat(user, "<span class='notice'>Your flesh, skin, and muscles become as steel.</span>")
	// Traits & Effects
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		this_resist = max(0.3, 0.7 - level_current * 0.1)
		H.physiology.brute_mod *= this_resist//0.5
		H.physiology.burn_mod *= this_resist//0.5
	// Stop Running   (Taken from /datum/quirk/nyctophobia in negative.dm)
	var/was_running = (user.m_intent == MOVE_INTENT_RUN)
	if(was_running)
		user.toggle_move_intent()
	while(bloodsuckerdatum && ContinueActive(user) || user.m_intent == MOVE_INTENT_RUN)
		// Pay Blood Toll (if awake)
		if(user.stat == CONSCIOUS)
			bloodsuckerdatum.AddBloodVolume(-0.5) // Used to be 0.3 blood per 2 seconds, but we're making it more expensive to keep on.
		sleep(20) // Check every few ticks that we haven't disabled this power
	// Return to Running (if you were before)

/datum/action/bloodsucker/fortitude/DeactivatePower(mob/living/user = owner, mob/living/target)
	..()
	// Restore Traits & Effects
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.physiology.brute_mod /= this_resist//0.5
	H.physiology.burn_mod /= this_resist//0.5
	if(was_running && user.m_intent == MOVE_INTENT_WALK)
		user.toggle_move_intent()
