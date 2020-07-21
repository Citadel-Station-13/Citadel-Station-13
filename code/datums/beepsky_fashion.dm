//similar to dog_fashion, but for beepsky, who has far more refined fashion tastes
/datum/beepsky_fashion
	var/name
	var/desc

	var/icon_file = 'icons/mob/secbot_head.dmi'
	var/obj_icon_state
	var/obj_alpha
	var/obj_color

	var/stun_sound //sound that replaces the stun attack when set

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
	beepers.name = name
	beepers.desc = desc

	//set each variable in beepsky if its defined here, otherwise set it to its initial value just in case
	if(death_emote)
		beepers.death_emote = death_emote

	if(capture_one)
		beepers.capture_one = capture_one

	if(capture_two)
		beepers.capture_two = capture_two

	if(infraction)
		beepers.infraction = infraction

	if(infraction)
		beepers.taunt = taunt

	if(attack_one)
		beepers.attack_one = attack_one

	if(attack_two)
		beepers.attack_two = attack_two

/datum/beepsky_fashion/proc/stun_attack(mob/living/carbon/C) //fired when beepsky does a stun attack with the fashion worn, for sounds/overlays/etc
	return

//actual fashions from here on out
/datum/beepsky_fashion/wizard
	obj_icon_state = "wizard"
	name = "Archmage Beepsky"
	desc = "A secbot stolen from the wizard federation."
	death_emote = "BOT casts EI NATH on themselves!"
	capture_one = "BOT is casting cable ties on CRIMINAL!"
	capture_two = "BOT is casting cable ties on you!"
	infraction = "Magical disturbance of magnitude THREAT_LEVEL detected!"
	attack_one = "BOT casts magic missile on CRIMINAL!"
	attack_two = "BOT casts magic missile on you!"

/datum/beepsky_fashion/cowboy
	obj_icon_state = "cowboy"
	name = "Sheriff Beepsky"
	desc = "The sheriff of this here station."
	capture_one = "BOT is tying CRIMINAL up!"
	capture_two = "BOT is tying you up!"
	infraction = "Outlaws with a bounty of THREAT_LEVEL000 space dollars detected!"
	attack_one = "BOT unloads his revolver onto CRIMINAL!"
	attack_two = "BOT unloads his revolver onto you!"

/datum/beepsky_fashion/chef
	obj_icon_state = "chef"
	name = "Chef Beepsky"
	desc = "Cooking up the finest foods the station has ever seen."
	death_emote = "Mamma-mia!"
	infraction = "Grade THREAT_LEVEL prosciutto detected!"
	attack_one = "BOT slices wildly with a cleaver towards CRIMINAL!"
	attack_two = "BOT slices wildly with a cleaver towards you!"

/datum/beepsky_fashion/cat
	obj_icon_state = "cat"
	name = "OwOfficer Bweepskwee"
	desc = "A beepsky unit with cat ears. Why?"
	death_emote = "Nya!"
	capture_one = "BOT is tying CRIMINAL up!!"
	capture_two = "BOT is tying you up!"
	infraction = "Wevel THREAT_LEVEL infwactwion awert!!!"
	attack_one = "BOT shoves CRIMINAL onto a table!"
	attack_two = "BOT shoves you onto a table!"

/datum/beepsky_fashion/cake //nothing else. it's just beepsky. with a cake on his head.
	obj_icon_state = "cake"

/datum/beepsky_fashion/captain
	obj_icon_state = "captain"
	name = "Captainsky"
	desc = "The real captain of this station."
	capture_one = "BOT is lecturing CRIMINAL on why he is the captain!"
	capture_two = "BOT is lecturing you on why he is the captain!"
	infraction = "Level THREAT_LEVEL greytider detected."
	attack_one = "BOT beats CRIMINAL with the chain of command!"
	attack_two = "BOT beats you with the chain of command!"

/datum/beepsky_fashion/king
	obj_icon_state = "king"
	name = "King Beepsky"
	desc = "He who has ascended to bare the right of king, sits atop the throne."
	capture_one = "BOT is calling the guards onto CRIMINAL!"
	capture_two = "BOT is calling the guards onto you!"
	infraction = "Treason of level THREAT_LEVEL detected!"
	attack_one = "BOT strikes CRIMINAL with his kingly authority!"
	attack_two = "BOT strikes you with his kingly authority!"

/datum/beepsky_fashion/pirate
	obj_icon_state = "pirate"
	name = "Beepsbeard the Pirate"
	desc = "Sailor of the seven seas, all sea-faring bots fear the one known as Beepsbeard."
	capture_one = "BOT is making CRIMINAL walk the plank!"
	capture_two = "BOT is making you walk the plank!"
	infraction = "Enemy vessel spotted with threat level THREAT_LEVEL!"
	attack_one = "BOT strikes CRIMINAL with his cutlass!"
	attack_two = "BOT strikes you with his cutlass!"
