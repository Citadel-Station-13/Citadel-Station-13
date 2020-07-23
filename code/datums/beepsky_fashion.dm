//similar to dog_fashion, but for beepsky, who has far more refined fashion tastes
/datum/beepsky_fashion
	var/name //not setting the name and desc makes them go to the default
	var/desc

	var/icon_file = 'icons/mob/secbot_accessories.dmi' //we sell secbots and secbot accessories
	var/obj_icon_state
	var/obj_alpha
	var/obj_color

	var/list/stun_sounds //sound that replaces the stun attack when set
	var/ignore_sound = FALSE //whether to ignore sounds entirely or not

	//emotes (don't set them if you want the default value)
	var/death_emote //what is said when beepsky dies
	var/capture_one //what is said when cuffing someone
	var/capture_two //what is said when cuffing someone, directly to the person being cuffed
	var/infraction //the level of threat detected
	var/taunt // beepsky pointing at a criminal
	var/attack_one //text when attacking criminal
	var/attack_two //text when attacking criminal, but directly to the criminal
	var/patrol_emote //engaging patrol text
	var/patrol_fail_emote //failing to engage patrol text
	var/list/arrest_texts //first is for not-cuffing, second is for cuffing
	var/arrest_emote //text stating that you're cuffing some criminal C with a threat of level X in location Y

	//for reference, the following words are replaced when processed before speech:
	//LOCATION = the location passed, if any (this is only used by arrest_emote)
	//CRIMINAL = the name of the criminal (this is used by everything but patrol_emote and infraction)
	//BOT = the name of the bot (this can be used on any of the emotes)
	//THREAT_LEVEL = the level of the threat detected (can be used on arrest_emote and infraction)

/datum/beepsky_fashion/proc/get_overlay(var/dir)
	if(icon_file && obj_icon_state)
		var/image/beepsky_overlay = image(icon_file, obj_icon_state, dir = dir)
		beepsky_overlay.alpha = obj_alpha
		beepsky_overlay.color = obj_color
		return beepsky_overlay

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
	taunt = "BOT points his staff towards CRIMINAL!"
	attack_one = "BOT casts magic missile on CRIMINAL!"
	attack_two = "BOT casts magic missile on you!"
	patrol_emote = "Beginning search for magical disturbances."
	patrol_fail_emote = "Failure to find magical disturbances. Recallibrating."
	arrest_emote = "ARREST_TYPE level THREAT_LEVEL magical practitioner CRIMINAL in LOCATION."
	stun_sounds = list('sound/magic/lightningbolt.ogg',
		'sound/magic/fireball.ogg',
		'sound/weapons/zapbang.ogg',
		'sound/magic/knock.ogg',
		'sound/magic/fleshtostone.ogg',
		'sound/effects/magic.ogg',
		'sound/magic/disintegrate.ogg')

/datum/beepsky_fashion/cowboy
	obj_icon_state = "cowboy"
	name = "Sheriff Beepsky"
	desc = "The sheriff of this here station."
	capture_one = "BOT is tying CRIMINAL up!"
	capture_two = "BOT is tying you up!"
	infraction = "Outlaws with a bounty of THREAT_LEVEL000 space dollars detected!"
	taunt = "BOT aims his revolver towards CRIMINAL!"
	attack_one = "BOT unloads his revolver onto CRIMINAL!"
	attack_two = "BOT unloads his revolver onto you!"
	patrol_emote = "Engaging bounty hunting protocols."
	patrol_fail_emote = "Unable to find any bounties due to error. Rebooting."
	arrest_emote = "ARREST_TYPE outlaw CRIMINAL with a bounty of THREAT_LEVEL000 in LOCATION."
	stun_sounds = list('sound/weapons/Gunshot.ogg',
		'sound/weapons/Gunshot2.ogg',
		'sound/weapons/Gunshot3.ogg',
		'sound/weapons/Gunshot4.ogg')

/datum/beepsky_fashion/chef
	obj_icon_state = "chef"
	name = "Chef Beepsky"
	desc = "Cooking up the finest foods the station has ever seen."
	death_emote = "Mamma-mia!"
	infraction = "Grade THREAT_LEVEL prosciutto detected!"
	taunt = "BOT glares at CRIMINAL."
	attack_one = "BOT CQCs CRIMINAL!"
	attack_two = "BOT CQCs you!"
	patrol_emote = "Beginning search for the bad prosciutto."
	patrol_fail_emote = "All prosciutto is stale. Rebooting."
	arrest_texts = list("Frying", "Grilling") //any good secoff knows the difference
	arrest_emote = "ARREST_TYPE grade THREAT_LEVEL prosciutto CRIMINAL in LOCATION."
	stun_sounds = list('sound/weapons/cqchit1.ogg',
		'sound/weapons/cqchit2.ogg')

/datum/beepsky_fashion/cat
	obj_icon_state = "cat"
	name = "OwOfficer Bweepskwee"
	desc = "A beepsky unit with cat ears. Catgirl science has gone too far."
	death_emote = "Nya!"
	capture_one = "BOT is tying CRIMINAL up!!"
	capture_two = "BOT is tying you up!"
	infraction = "Wevel THREAT_LEVEL infwactwion awert!!!"
	taunt = "BOT points at CRIMINAL and nyas!"
	attack_one = "BOT shoves CRIMINAL onto a table!"
	attack_two = "BOT shoves you onto a table!"
	patrol_emote = "Enwgagwing patwol mwodies.."
	patrol_fail_emote = "Unawbwle two stwawt patwollies. Nya."
	arrest_texts = list("Dwetwaining", "Awwesting")
	arrest_emote = "ARREST_TYPE wevel THREAT_LEVEL scwumbwag CRIMINAL in LOCATION. Nya."
	ignore_sound = TRUE //we instead make the stunned person fire the nya emote

/datum/beepsky_fashion/cat/stun_attack(var/mob/living/carbon/C) //makes a fake table under you on hit, makes cat people nya when hit
	if(iscatperson(C))
		C.emote("nya")
	var/turf/target_turf = get_turf(C)
	if(target_turf) //slams you on a fake table
		playsound(src, 'sound/weapons/sonic_jackhammer.ogg', 50, 1)
		var/obj/effect/overlay_holder = new(target_turf)
		overlay_holder.name = "Catboy Table"
		overlay_holder.desc = "Where bad catboys go."
		var/image/table_overlay = image('icons/obj/smooth_structures/table.dmi', "table")
		overlay_holder.add_overlay(table_overlay)
		QDEL_IN(overlay_holder, 10)

/datum/beepsky_fashion/cake //nothing else. it's just beepsky. with a cake on his head.
	obj_icon_state = "cake"
	name = "Cakesky"
	desc = "It's a secbot, wearing a cake on his head!"

/datum/beepsky_fashion/captain
	obj_icon_state = "captain"
	name = "Captainsky"
	desc = "The real captain of this station."
	capture_one = "BOT is lecturing CRIMINAL on why he is the captain!"
	capture_two = "BOT is lecturing you on why he is the captain!"
	infraction = "Level THREAT_LEVEL greytider detected."
	attack_one = "BOT beats CRIMINAL with the chain of command!"
	attack_two = "BOT beats you with the chain of command!"
	patrol_emote = "Uselessness protocols engaged."
	patrol_fail_emote = "Unit has been found as useless. Rebooting."
	arrest_texts = list("Demoting", "Firing")
	arrest_emote = "ARREST_TYPE level THREAT_LEVEL lesser crewmember CRIMINAL in LOCATION."
	stun_sounds = list('sound/weapons/chainhit.ogg')

/datum/beepsky_fashion/king
	obj_icon_state = "king"
	name = "King Beepsky"
	desc = "He who has ascended to bare the right of king, sits atop the throne."
	capture_one = "BOT is calling the guards onto CRIMINAL!"
	capture_two = "BOT is calling the guards onto you!"
	infraction = "Treason of level THREAT_LEVEL detected!"
	attack_one = "BOT strikes CRIMINAL with his kingly authority!"
	attack_two = "BOT strikes you with his kingly authority!"
	patrol_emote = "Searching for peasants to beat up."
	patrol_fail_emote = "Peasants are using dark magic. Recallibrating."
	arrest_texts = list("Knighting", "Executing")
	arrest_emote = "ARREST_TYPE level THREAT_LEVEL peasant CRIMINAL in LOCATION."
	stun_sounds = list('sound/weapons/punch1.ogg',
		'sound/weapons/punch2.ogg',
		'sound/weapons/punch3.ogg',
		'sound/weapons/punch4.ogg')

/datum/beepsky_fashion/pirate
	obj_icon_state = "pirate"
	name = "Beepsbeard the Pirate"
	desc = "Sailor of the seven seas, all sea-faring bots fear the one known as Beepsbeard."
	capture_one = "BOT is making CRIMINAL walk the plank!"
	capture_two = "BOT is making you walk the plank!"
	infraction = "Enemy vessel spotted with threat level THREAT_LEVEL!"
	attack_one = "BOT strikes CRIMINAL with his cutlass!"
	attack_two = "BOT strikes you with his cutlass!"
	patrol_emote = "Searching for enemy vessels to board."
	patrol_fail_emote = "No way to engage enemy vessels. Rebooting."
	arrest_texts = list("Boarding", "Sinking")
	arrest_emote = "ARREST_TYPE level THREAT_LEVEL vessel CRIMINAL in LOCATION."
	stun_sounds = list('sound/weapons/bladeslice.ogg')

/datum/beepsky_fashion/engineer
	obj_icon_state = "engineer"
	name = "Chief Engineer Beepsky"
	desc = "He fixes criminals with a wrench to the face."
	capture_one = "BOT is tying CRIMINAL up!"
	capture_two = "BOT is tying you up!"
	infraction = "Structural integrity issue spotted with threat level THREAT_LEVEL"
	attack_one = "BOT strikes CRIMINAL with his wrench!"
	attack_two = "BOT strikes you with his wrench!"
	arrest_texts = list("Fixing", "Repairing")
	arrest_emote = "ARREST_TYPE level THREAT_LEVEL structural issue in LOCATION"
	stun_sounds = list('sound/weapons/genhit.ogg')

/datum/beepsky_fashion/tophat
	obj_icon_state = "tophat"
	name = "Fancy Beepsky"
	desc = "It's a secbot, wearing a top hat! How fancy."

/datum/beepsky_fashion/fedora
	obj_icon_state = "fedora"
	name = "Fedorasky"
	desc = "It's a secbot, wearing a fedora!"

/datum/beepsky_fashion/sombrero
	obj_icon_state = "sombrero"
	name = "Sombrerosky"
	desc = "A secbot wearing a sombrero. Truly, a hombre to all."

/datum/beepsky_fashion/santa
	obj_icon_state = "santa"
	name = "Saint Beepsky"
	desc = "Have you been a level 7 infraction this holiday season?"
	capture_one = "BOT is tying CRIMINAL up with fairy lights!"
	capture_two = "BOT is tying you up with fairy lights!"
	infraction = "Level THREAT_LEVEL threat to holiday cheer spotted!"
	attack_one = "BOT crushes CRIMINAL with their holiday spirit!"
	attack_two = "BOT crushes you with their holiday spirit!"
	arrest_emote = "ARREST_TYPE level THREAT_LEVEL threat to holiday cheer in LOCATION"

