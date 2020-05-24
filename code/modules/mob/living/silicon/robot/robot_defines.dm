
/mob/living/silicon/robot
	designation = "Default" //used for displaying the prefix & getting the current module of cyborg
	has_limbs = TRUE
	hud_type = /datum/hud/robot

	blocks_emissive = EMISSIVE_BLOCK_UNIQUE

	maxHealth = 100
	health = 100

	var/custom_name = ""
	var/braintype = "Cyborg"
	var/obj/item/robot_suit/robot_suit = null //Used for deconstruction to remember what the borg was constructed out of..
	var/obj/item/mmi/mmi = null

	var/shell = FALSE
	var/deployed = FALSE
	var/mob/living/silicon/ai/mainframe = null
	var/datum/action/innate/undeployment/undeployment_action = new

//Hud stuff

	var/obj/screen/inv1 = null
	var/obj/screen/inv2 = null
	var/obj/screen/inv3 = null
	var/obj/screen/lamp_button = null
	var/obj/screen/thruster_button = null
	var/obj/screen/hands = null

	var/shown_robot_modules = 0	//Used to determine whether they have the module menu shown or not
	var/obj/screen/robot_modules_background

//3 Modules can be activated at any one time.
	var/obj/item/robot_module/module = null
	var/obj/item/module_active = null
	held_items = list(null, null, null) //we use held_items for the module holding, because that makes sense to do!

	var/mutable_appearance/eye_lights

	var/mob/living/silicon/ai/connected_ai = null
	var/obj/item/stock_parts/cell/cell = null

	var/opened = 0
	var/emagged = FALSE
	var/emag_cooldown = 0
	var/wiresexposed = 0

	var/ident = 0
	var/locked = TRUE
	var/list/req_access = list(ACCESS_ROBOTICS)

	var/alarms = list("Motion"=list(), "Fire"=list(), "Atmosphere"=list(), "Power"=list(), "Camera"=list(), "Burglar"=list())

	var/speed = 0 // VTEC speed boost.
	var/magpulse = FALSE // Magboot-like effect.
	var/ionpulse = FALSE // Jetpack-like effect.
	var/ionpulse_on = FALSE // Jetpack-like effect.
	var/datum/effect_system/trail_follow/ion/ion_trail // Ionpulse effect.

	var/low_power_mode = 0 //whether the robot has no charge left.
	var/datum/effect_system/spark_spread/spark_system // So they can initialize sparks whenever/N

	var/lawupdate = 1 //Cyborgs will sync their laws with their AI by default
	var/scrambledcodes = 0 // Used to determine if a borg shows up on the robotics console.  Setting to one hides them.
	var/locked_down //Boolean of whether the borg is locked down or not

	var/toner = 0
	var/tonermax = 40

	var/lamp_max = 10 //Maximum brightness of a borg lamp. Set as a var for easy adjusting.
	var/lamp_intensity = 0 //Luminosity of the headlamp. 0 is off. Higher settings than the minimum require power.
	light_color = "#FFCC66"
	light_power = 0.8
	var/lamp_cooldown = 0 //Flag for if the lamp is on cooldown after being forcibly disabled.

	var/sight_mode = 0
	hud_possible = list(ANTAG_HUD, DIAG_STAT_HUD, DIAG_HUD, DIAG_BATT_HUD, DIAG_TRACK_HUD)

	var/list/upgrades = list()

	var/hasExpanded = FALSE
	var/obj/item/hat
	var/hat_offset = -3
	var/list/equippable_hats = list(/obj/item/clothing/head/caphat,
	/obj/item/clothing/head/hardhat,
	/obj/item/clothing/head/centhat,
	/obj/item/clothing/head/HoS,
	/obj/item/clothing/head/beret,
	/obj/item/clothing/head/kitty,
	/obj/item/clothing/head/hopcap,
	/obj/item/clothing/head/wizard,
	/obj/item/clothing/head/nursehat,
	/obj/item/clothing/head/sombrero,
	/obj/item/clothing/head/helmet/chaplain/witchunter_hat,
	/obj/item/clothing/head/soft/, //All baseball caps
	/obj/item/clothing/head/that, //top hat
	/obj/item/clothing/head/collectable/tophat, //Not sure where this one is found, but it looks the same so might as well include
	/obj/item/clothing/mask/bandana/, //All bandanas (which only work in hat mode)
	/obj/item/clothing/head/fedora,
	/obj/item/clothing/head/beanie/, //All beanies
	/obj/item/clothing/ears/headphones,
	/obj/item/clothing/head/helmet/skull,
	/obj/item/clothing/head/crown/fancy)

	can_buckle = TRUE
	buckle_lying = FALSE
	var/static/list/can_ride_typecache = typecacheof(/mob/living/carbon/human)

	var/sitting = 0
	var/bellyup = 0
	var/dogborg = FALSE

	var/cansprint = 1

	var/orebox = null

	//doggie borg stuff.
	var/disabler
	var/laser
	var/sleeper_g
	var/sleeper_r
	var/sleeper_nv