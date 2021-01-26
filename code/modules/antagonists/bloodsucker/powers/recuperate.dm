

/datum/action/bloodsucker/recuperate
	name = "Recuperate"
	desc = "Recover from debilitating effects quickly or wake up from torpor. Costs 100 more blood to wake you up."
	button_icon_state = "power_recup"
	bloodcost = 50
	cooldown = 30
	cooldown_static = TRUE
	can_use_in_torpor = TRUE

/datum/action/bloodsucker/recuperate/ActivatePower()
	var/datum/antagonist/bloodsucker/B = owner.mind.has_antag_datum(ANTAG_DATUM_BLOODSUCKER)
	if(!isliving(owner))
		return
	var/mob/living/L = owner
	if(HAS_TRAIT(owner, TRAIT_FAKEDEATH))
		var/insufficent_blood
		if(!L.blood_volume < 100)
			cooldown = 200
			L.confused = 50
			L.dizziness = 10
			insufficent_blood = TRUE
			to_chat(owner, "<span class='warning'>You try to dispel your Torpor, but it's difficult without enough blood.</span>")
			addtimer(CALLBACK(src, .proc/NormalizeCooldown), 201)
		addtimer(CALLBACK(B, /datum/antagonist/bloodsucker/.proc/Torpor_End), 20)
		owner.emote("twitch")
		if(!insufficent_blood)
			to_chat(owner, "<span class='notice'>You start to awaken from the horrid deep slumber of Torpor</span>")
			B.AddBloodVolume(-100)
		return
	L.adjustFireLoss(L.staminaloss * 0.2) //So we can't spam it forever
	L.do_adrenaline(healing_chems = null, stamina_buffer_boost = 50)
	to_chat(owner, "<span class='notice'>The power of your blood gives you newfound vitality!</span>")

/datum/action/bloodsucker/recuperate/proc/NormalizeCooldown()
	cooldown = 30
