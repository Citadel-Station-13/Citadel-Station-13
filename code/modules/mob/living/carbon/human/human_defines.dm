/mob/living/carbon/human
	hud_possible = list(HEALTH_HUD,STATUS_HUD,ID_HUD,WANTED_HUD,IMPLOYAL_HUD,IMPCHEM_HUD,IMPTRACK_HUD, NANITE_HUD, DIAG_NANITE_FULL_HUD,ANTAG_HUD,GLAND_HUD,SENTIENT_DISEASE_HUD,RAD_HUD)
	hud_type = /datum/hud/human
	possible_a_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, INTENT_HARM)
	pressure_resistance = 25
	can_buckle = TRUE
	buckle_lying = FALSE
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	/// Enable stamina combat
	combat_flags = COMBAT_FLAGS_DEFAULT
	status_flags = CANSTUN|CANKNOCKDOWN|CANUNCONSCIOUS|CANPUSH|CANSTAGGER

	//Hair colour and style
	var/hair_color = "000"
	var/hair_style = "Bald"

	//Facial hair colour and style
	var/facial_hair_color = "000"
	var/facial_hair_style = "Shaved"

	//Eye colour
	var/eye_color = "000"

	var/horn_color = "85615a"	//specific horn colors, because why not?

	var/wing_color = "fff"		//wings too

	var/skin_tone = "caucasian1"	//Skin tone

	var/lip_style = null	//no lipstick by default- arguably misleading, as it could be used for general makeup
	var/lip_color = "white"

	var/age = 30		//Player's age

	var/underwear = "Nude"	//Which underwear the player wants
	var/undie_color = "FFFFFF"
	var/undershirt = "Nude" //Which undershirt the player wants
	var/shirt_color = "FFFFFF"
	var/socks = "Nude" //Which socks the player wants
	var/socks_color = "FFFFFF"

	//Equipment slots
	var/obj/item/wear_suit = null
	var/obj/item/w_uniform = null
	var/obj/item/belt = null
	var/obj/item/wear_id = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/obj/item/s_store = null

	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/bleed_rate = 0 //how much are we bleeding
	var/bleedsuppress = 0 //for stopping bloodloss, eventually this will be limb-based like bleeding

	var/blood_state = BLOOD_STATE_NOT_BLOODY
	var/list/blood_smear = list(BLOOD_STATE_BLOOD = 0, BLOOD_STATE_OIL = 0, BLOOD_STATE_NOT_BLOODY = 0)

	var/name_override //For temporary visible name changes
	var/genital_override = FALSE //Force genitals on things incase of chems

	var/nameless = FALSE //For drones of both the insectoid and robotic kind. And other types of nameless critters.

	var/custom_species = null

	var/datum/physiology/physiology

	var/list/datum/bioware = list()

	var/creamed = FALSE //to use with creampie overlays
	var/static/list/can_ride_typecache = typecacheof(list(/mob/living/carbon/human, /mob/living/simple_animal/slime, /mob/living/simple_animal/parrot))
	var/lastpuke = 0
	var/last_fire_update
