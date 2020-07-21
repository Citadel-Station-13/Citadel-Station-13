//similar to dog_fashion, but for beepsky, who has far more refined fashion tastes
/datum/beepsky_fashion
	var/name
	var/desc

	var/icon_file = 'icons/mob/secbot_head.dmi'
	var/obj_icon_state
	var/obj_alpha
	var/obj_color

	//emotes
	var/death_emote
	var/capture_one
	var/capture_two
	var/infraction
	var/taunt
	var/attack_one
	var/attack_two

/datum/beepsky_fashion/proc/get_overlay(var/dir)
	if(icon_file && obj_icon_state)
		var/image/beepsky_overlay = image(icon_file, obj_icon_state, dir = dir)
		beepsky_overlay.alpha = obj_alpha
		beepsky_overlay.color = obj_color
		return beepsky_overlay

/datum/beepsky_fashion/proc/apply(mob/living/simple_animal/bot/secbot/beepers) //set the emote depending on the fashion datum, if nothing set, turn it back to how it was initially
	//assume name and description is always set, because otherwise, what would be the point of beepsky fashion?
	src.name = name
	src.desc = desc
	if(death_emote)
		beepers.death_emote = death_emote
	else
		beepers.death_emote = initial(beepers.death_emote)

	if(capture_one)
		beepers.capture_one = capture_one
	else
		beepers.capture_one = initial(beepers.capture_one)

	if(capture_two)
		beepers.capture_two = capture_two
	else
		beepers.capture_two = initial(beepers.capture_two)

	if(infraction)
		beepers.infraction = infraction
	else
		beepers.infraction = initial(beepers.infraction)

	if(infraction)
		beepers.taunt = taunt
	else
		beepers.taunt = initial(beepers.taunt)

	if(attack_one)
		beepers.attack_one = attack_one
	else
		beepers.attack_one = initial(beepers.attack_one)

	if(attack_two)
		beepers.attack_two = attack_two
	else
		beepers.attack_two = initial(beepers.attack_two)

//actual fashions from here on out
/datum/beepsky_fashion/wizard
	name = "Archmage Beepsky"
	desc = "A secbot stolen from the wizard federation."
	death_emote = "BOT casts EI NATH on themselves!"
	capture_one = "BOT is casting cable ties on CRIMINAL!"
	capture_two = "BOT is casting cable ties on you!"
	infraction = "Magical disturbance of magnitude THREAT_LEVEL detected!"
	attack_one = "BOT casts magic missile on CRIMINAL!"
	attack_two = "BOT casts magic missile on you!"
