

/datum/action/bloodsucker/lunge
	name = "Predatory Lunge"
	desc = "Spring at your target and aggressively grapple them without warning. Attacks from concealment or the rear may even knock them down."
	button_icon_state = "power_lunge"
	bloodcost = 10
	cooldown = 30
	bloodsucker_can_buy = TRUE
	warn_constant_cost = TRUE
	amToggle = TRUE

/datum/action/bloodsucker/lunge/ActivatePower()
	var/mob/living/user = owner
	var/datum/antagonist/bloodsucker/B = user.mind.has_antag_datum(ANTAG_DATUM_BLOODSUCKER)
	user.LoadComponent(/datum/component/tackler, stamina_cost = 50, base_knockdown = 3 SECONDS, range = 4, speed = 0.8, skill_mod = 5, min_distance = 2)
	active = TRUE
	while(B && ContinueActive(user) && CHECK_MOBILITY(user, MOBILITY_STAND))
		B.AddBloodVolume(-0.1)
		sleep(5)

/datum/action/bloodsucker/lunge/ContinueActive(mob/living/user)
	return ..()

/datum/action/bloodsucker/lunge/DeactivatePower(mob/living/user = owner)
	..() // activate = FALSE
	var/datum/component/tackler
	tackler.RemoveComponent()
