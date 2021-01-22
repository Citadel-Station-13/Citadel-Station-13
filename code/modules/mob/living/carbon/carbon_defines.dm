/mob/living/carbon
	gender = MALE
	pressure_resistance = 15
	possible_a_intents = list(INTENT_HELP, INTENT_HARM)
	hud_possible = list(HEALTH_HUD,STATUS_HUD,ANTAG_HUD,GLAND_HUD,NANITE_HUD,DIAG_NANITE_FULL_HUD,RAD_HUD)
	has_limbs = 1
	held_items = list(null, null)
	var/list/stomach_contents		= list()
	var/list/internal_organs		= list()	//List of /obj/item/organ in the mob. They don't go in the contents for some reason I don't want to know.
	var/list/internal_organs_slot= list() //Same as above, but stores "slot ID" - "organ" pairs for easy access.
	var/silent = FALSE 		//Can't talk. Value goes down every life proc. //NOTE TO FUTURE CODERS: DO NOT INITIALIZE NUMERICAL VARS AS NULL OR I WILL MURDER YOU.
	var/dreaming = 0 //How many dream images we have left to send

	var/obj/item/restraints/handcuffed //Whether or not the mob is handcuffed
	var/obj/item/restraints/legcuffed //Same as handcuffs but for legs. Bear traps use this.

	var/disgust = 0

//inventory slots
	var/obj/item/back = null
	var/obj/item/clothing/mask/wear_mask = null
	var/obj/item/clothing/neck/wear_neck = null
	var/obj/item/tank/internal = null
	var/obj/item/head = null

	var/obj/item/gloves = null //only used by humans
	var/obj/item/clothing/shoes/shoes = null //only used by humans.
	var/obj/item/clothing/glasses/glasses = null //only used by humans.
	var/obj/item/ears = null //only used by humans.

	var/datum/dna/dna = null//Carbon
	var/datum/mind/last_mind = null //last mind to control this mob, for blood-based cloning

	var/failed_last_breath = 0 //This is used to determine if the mob failed a breath. If they did fail a brath, they will attempt to breathe each tick, otherwise just once per 4 ticks.

	var/co2overloadtime = null
	var/o2overloadtime = null	//for Ash walker's weaker lungs, and future atmosia hazards
	var/temperature_resistance = T0C+75
	var/obj/item/reagent_containers/food/snacks/meat/slab/type_of_meat = /obj/item/reagent_containers/food/snacks/meat/slab

	var/gib_type = /obj/effect/decal/cleanable/blood/gibs

	rotate_on_lying = TRUE

	var/tinttotal = 0	// Total level of visualy impairing items

	var/list/bodyparts = list(/obj/item/bodypart/chest, /obj/item/bodypart/head, /obj/item/bodypart/l_arm,
					 /obj/item/bodypart/r_arm, /obj/item/bodypart/r_leg, /obj/item/bodypart/l_leg)
	//Gets filled up in create_bodyparts()

	var/list/hand_bodyparts = list() //a collection of arms (or actually whatever the fug /bodyparts you monsters use to wreck my systems)

	var/icon_render_key = ""
	var/static/list/limb_icon_cache = list()

	//halucination vars
	var/image/halimage
	var/image/halbody
	var/obj/halitem
	var/hal_screwyhud = SCREWYHUD_NONE
	var/next_hallucination = 0
	var/cpr_time = 1 //CPR cooldown.
	var/damageoverlaytemp = 0

	var/drunkenness = 0 //Overall drunkenness - check handle_alcohol() in life.dm for effects
	var/tackling = FALSE //Whether or not we are tackling, this will prevent the knock into effects for carbons

	var/corruption_timer = 0 //Only relevant for robotpeople. A timer that ticks in handle_corruption() so stuff doesn't happen  every tick.

	/// All of the wounds a carbon has afflicted throughout their limbs
	var/list/all_wounds
	/// All of the scars a carbon has afflicted throughout their limbs
	var/list/all_scars

	/// Protection (insulation) from the heat, Value 0-1 corresponding to the percentage of protection
	var/heat_protection = 0 // No heat protection
	/// Protection (insulation) from the cold, Value 0-1 corresponding to the percentage of protection
	var/cold_protection = 0 // No cold protection

	/// Timer id of any transformation
	var/transformation_timer

