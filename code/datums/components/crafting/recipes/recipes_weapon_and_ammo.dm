/datum/crafting_recipe/pin_removal
	name = "Pin Removal"
	result = /obj/item/gun
	reqs = list(/obj/item/gun = 1)
	parts = list(/obj/item/gun = 1)
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_OTHER

/datum/crafting_recipe/pin_removal/check_requirements(mob/user, list/collected_requirements)
	var/obj/item/gun/G = collected_requirements[/obj/item/gun][1]
	if (G.no_pin_required || !G.pin)
		return FALSE
	return TRUE

/datum/crafting_recipe/strobeshield
	name = "Strobe Shield"
	result = /obj/item/assembly/flash/shield
	reqs = list(/obj/item/wallframe/flasher = 1,
				/obj/item/assembly/flash/handheld = 1,
				/obj/item/shield/riot = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/strobeshield/New()
	..()
	blacklist |= subtypesof(/obj/item/shield/riot/)

/datum/crafting_recipe/makeshiftshield
	name = "Makeshift Metal Shield"
	result = /obj/item/shield/makeshift
	reqs = list(/obj/item/stack/cable_coil = 30,
				/obj/item/stack/sheet/metal = 10,
				/obj/item/stack/sheet/cloth = 2,
				/obj/item/stack/sheet/leather = 3)
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	time = 100
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/spear
	name = "Spear"
	result = /obj/item/spear
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/shard = 1,
				/obj/item/stack/rods = 1)
	parts = list(/obj/item/shard = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/stunprod
	name = "Stunprod"
	result = /obj/item/melee/baton/cattleprod
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/rods = 1,
				/obj/item/assembly/igniter = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/teleprod
	name = "Teleprod"
	result = /obj/item/melee/baton/cattleprod/teleprod
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/rods = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/stack/ore/bluespace_crystal = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/bola
	name = "Bola"
	result = /obj/item/restraints/legcuffs/bola
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/sheet/metal = 6)
	time = 20//15 faster than crafting them by hand!
	category= CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/tailclub
	name = "Tail Club"
	result = /obj/item/tailclub
	reqs = list(/obj/item/organ/tail/lizard = 1,
	            /obj/item/stack/sheet/metal = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/tailwhip
	name = "Liz O' Nine Tails"
	result = /obj/item/melee/chainofcommand/tailwhip
	reqs = list(/obj/item/organ/tail/lizard = 1,
				/obj/item/stack/cable_coil = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/catwhip
	name = "Cat O' Nine Tails"
	result = /obj/item/melee/chainofcommand/tailwhip/kitty
	reqs = list(/obj/item/organ/tail/cat = 1,
				/obj/item/stack/cable_coil = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

/datum/crafting_recipe/chainsaw
	name = "Chainsaw"
	result = /obj/item/chainsaw
	reqs = list(/obj/item/circular_saw = 1,
				/obj/item/stack/cable_coil = 3,
				/obj/item/stack/sheet/plasteel = 5)
	tools = list(TOOL_WELDER)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

//////////////////
///BOMB CRAFTING//
//////////////////

/datum/crafting_recipe/chemical_payload
	name = "Chemical Payload (C4)"
	result = /obj/item/bombcore/chemical
	reqs = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/grenade/plastic/c4 = 1,
		/obj/item/grenade/chem_grenade = 2
	)
	parts = list(/obj/item/stock_parts/matter_bin = 1, /obj/item/grenade/chem_grenade = 2)
	time = 30
	category = CAT_WEAPONRY
	subcategory = CAT_OTHER

/datum/crafting_recipe/chemical_payload2
	name = "Chemical Payload (Gibtonite)"
	result = /obj/item/bombcore/chemical
	reqs = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/gibtonite = 1,
		/obj/item/grenade/chem_grenade = 2
	)
	parts = list(/obj/item/stock_parts/matter_bin = 1, /obj/item/grenade/chem_grenade = 2)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_OTHER

/datum/crafting_recipe/molotov
	name = "Molotov"
	result = /obj/item/reagent_containers/food/drinks/bottle/molotov
	reqs = list(/obj/item/reagent_containers/rag = 1,
				/obj/item/reagent_containers/food/drinks/bottle = 1)
	parts = list(/obj/item/reagent_containers/food/drinks/bottle = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/IED
	name = "IED"
	result = /obj/item/grenade/iedcasing
	reqs = list(/datum/reagent/fuel = 50,
				/obj/item/stack/cable_coil = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/reagent_containers/food/drinks/soda_cans = 1)
	parts = list(/obj/item/reagent_containers/food/drinks/soda_cans = 1)
	time = 15
	category = CAT_WEAPONRY
	subcategory = CAT_OTHER

/datum/crafting_recipe/lance
	name = "Explosive Lance (Grenade)"
	result = /obj/item/spear
	reqs = list(/obj/item/spear = 1,
				/obj/item/grenade = 1)
	parts = list(/obj/item/spear = 1,
				/obj/item/grenade = 1)
	time = 15
	category = CAT_WEAPONRY
	subcategory = CAT_MELEE

//////////////////
///GUNS CRAFTING//
//////////////////


/datum/crafting_recipe/pipebow
	name = "Pipe Bow"
	result =  /obj/item/gun/ballistic/bow/pipe
	reqs = list(/obj/item/pipe = 5,
	/obj/item/stack/sheet/plastic = 15,
	/obj/item/weaponcrafting/string = 5)
	time = 150
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/smartdartgun
	name = "Smart dartgun"
	result =  /obj/item/gun/syringe/dart
	reqs = list(/obj/item/stack/sheet/metal = 10,
	/obj/item/stack/sheet/glass = 5,
	/obj/item/tank/internals = 1,
	/obj/item/reagent_containers/glass/beaker = 1,
	/obj/item/stack/sheet/plastic = 5,
	/obj/item/stack/cable_coil = 1)
	time = 150 //It's a gun
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/rapiddartgun
	name = "Rapid Smart dartgun"
	result = /obj/item/gun/syringe/dart/rapiddart
	reqs = list(
		/obj/item/gun/syringe/dart = 1,
		/obj/item/stack/sheet/plastic = 5,
		/obj/item/stack/cable_coil = 1,
		/obj/item/reagent_containers/glass/beaker = 1
	)
	parts = list(/obj/item/reagent_containers/glass/beaker = 1)
	time = 120 //Modifying your gun
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/improvised_pneumatic_cannon
	name = "Pneumatic Cannon"
	result = /obj/item/pneumatic_cannon/ghetto
	tools = list(TOOL_WELDER, TOOL_WRENCH)
	reqs = list(/obj/item/stack/sheet/metal = 4,
				/obj/item/stack/packageWrap = 8,
				/obj/item/pipe = 2)
	time = 300
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/flamethrower //Gun*
	name = "Flamethrower"
	result = /obj/item/flamethrower
	reqs = list(/obj/item/weldingtool = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/stack/rods = 1)
	parts = list(/obj/item/assembly/igniter = 1,
				/obj/item/weldingtool = 1)
	tools = list(TOOL_SCREWDRIVER)
	time = 10
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/ishotgun
	name = "Improvised Shotgun"
	result = /obj/item/gun/ballistic/revolver/doublebarrel/improvised
	reqs = list(/obj/item/weaponcrafting/improvised_parts/barrel_shotgun = 1,
				/obj/item/weaponcrafting/improvised_parts/shotgun_receiver = 1,
				/obj/item/weaponcrafting/improvised_parts/trigger_assembly = 1,
				/obj/item/weaponcrafting/improvised_parts/wooden_body = 1,
				/obj/item/weaponcrafting/stock = 1,
				/obj/item/stack/packageWrap = 5)
	tools = list(TOOL_SCREWDRIVER)
	time = 100
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/irifle
	name = "Improvised Rifle (7.62mm)"
	result = /obj/item/gun/ballistic/shotgun/boltaction/improvised
	reqs = list(/obj/item/weaponcrafting/improvised_parts/barrel_rifle = 1,
				/obj/item/weaponcrafting/improvised_parts/rifle_receiver = 1,
				/obj/item/weaponcrafting/improvised_parts/trigger_assembly = 1,
				/obj/item/weaponcrafting/improvised_parts/wooden_body = 1,
				/obj/item/weaponcrafting/stock = 1,
				/obj/item/stack/packageWrap = 5)
	tools = list(TOOL_SCREWDRIVER)
	time = 100
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/ipistol
	name = "Improvised Pistol (.32)"
	result = /obj/item/gun/ballistic/automatic/pistol/improvised/nomag
	reqs = list(/obj/item/weaponcrafting/improvised_parts/barrel_pistol = 1,
				/obj/item/weaponcrafting/improvised_parts/pistol_receiver = 1,
				/obj/item/weaponcrafting/improvised_parts/trigger_assembly = 1,
				/obj/item/weaponcrafting/improvised_parts/wooden_grip = 1,
				/obj/item/stack/sheet/plastic = 15,
				/obj/item/stack/sheet/plasteel = 1)
	tools = list(TOOL_SCREWDRIVER, TOOL_WELDER, TOOL_WIRECUTTER)
	time = 100
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/ilaser
	name = "Improvised Energy Gun"
	result = /obj/item/gun/energy/e_gun/old/improvised
	reqs = list(/obj/item/weaponcrafting/improvised_parts/laser_receiver = 1,
				/obj/item/weaponcrafting/improvised_parts/trigger_assembly = 1,
				/obj/item/weaponcrafting/improvised_parts/makeshift_lens = 1,
				/obj/item/stock_parts/cell = 1,
				/obj/item/stack/sheet/metal = 10,
				/obj/item/stack/sheet/plasteel = 5,
				/obj/item/stack/cable_coil = 10)
	tools = list(TOOL_SCREWDRIVER)
	time = 100
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/ilaser/upgraded
	name = "Improvised Energy Gun Upgrade"
	result = /obj/item/gun/energy/e_gun/old/improvised/upgraded
	reqs = list(/obj/item/gun/energy/e_gun/old/improvised = 1,
				/obj/item/glasswork/glass_base/lens = 1,
				/obj/item/stock_parts/capacitor/quadratic = 2,
				/obj/item/stock_parts/micro_laser/ultra = 1,
				/obj/item/stock_parts/cell/bluespace = 1,
				/obj/item/stack/cable_coil = 5)
	tools = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL)
	time = 100
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

//////////////////
///AMMO CRAFTING//
//////////////////

/datum/crafting_recipe/arrow
	name = "Arrow"
	result = /obj/item/ammo_casing/caseless/arrow/wood
	time = 5 // these only do 15 damage
	reqs = list(/obj/item/stack/sheet/mineral/wood = 1,
				 /obj/item/stack/sheet/cloth = 1,
				 /obj/item/stack/rods = 1) // 1 metal sheet = 2 rods = 2 arrows
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/bone_arrow
	name = "Bone Arrow"
	result = /obj/item/ammo_casing/caseless/arrow/bone
	time = 5
	always_availible = FALSE
	reqs = list(/obj/item/stack/sheet/bone = 1,
				 /obj/item/stack/sheet/sinew = 1,
				 /obj/item/ammo_casing/caseless/arrow/ash = 1)
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/ashen_arrow
	name = "Ashen Arrow"
	result = /obj/item/ammo_casing/caseless/arrow/ash
	tools = list(TOOL_WELDER)
	time = 10 // 1.5 seconds minimum per actually worthwhile arrow excluding interface lag
	always_availible = FALSE
	reqs = list(/obj/item/ammo_casing/caseless/arrow/wood = 1)
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/smartdart
	name = "Medical smartdart"
	result =  /obj/item/reagent_containers/syringe/dart
	reqs = list(/obj/item/stack/sheet/metal = 1,
				/obj/item/stack/sheet/glass = 1,
				/obj/item/stack/sheet/plastic = 1)
	time = 10
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/meteorslug
	name = "Meteorslug Shell"
	result = /obj/item/ammo_casing/shotgun/meteorslug
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/rcd_ammo = 1,
				/obj/item/stock_parts/manipulator = 2)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/pulseslug
	name = "Pulse Slug Shell"
	result = /obj/item/ammo_casing/shotgun/pulseslug
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stock_parts/capacitor/adv = 2,
				/obj/item/stock_parts/micro_laser/ultra = 1)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/dragonsbreath
	name = "Dragonsbreath Shell"
	result = /obj/item/ammo_casing/shotgun/dragonsbreath
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/datum/reagent/phosphorus = 5)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/frag12
	name = "FRAG-12 Shell"
	result = /obj/item/ammo_casing/shotgun/frag12
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/datum/reagent/glycerol = 5,
				/datum/reagent/toxin/acid = 5,
				/datum/reagent/toxin/acid/fluacid = 5)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/ionslug
	name = "Ion Scatter Shell"
	result = /obj/item/ammo_casing/shotgun/ion
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stock_parts/micro_laser/ultra = 1,
				/obj/item/stock_parts/subspace/crystal = 1)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/improvisedslug
	name = "Improvised Shotgun Shell"
	result = /obj/item/ammo_casing/shotgun/improvised
	reqs = list(/obj/item/grenade/chem_grenade = 1,
				/obj/item/stack/sheet/metal = 1,
				/obj/item/stack/cable_coil = 1,
				/datum/reagent/fuel = 10)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/laserslug
	name = "Scatter Laser Shell"
	result = /obj/item/ammo_casing/shotgun/laserslug
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/stock_parts/capacitor/adv = 1,
				/obj/item/stock_parts/micro_laser/high = 1)
	tools = list(TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/m32acp
	name = ".32ACP Empty Magazine"
	result = /obj/item/ammo_box/magazine/m32acp/empty
	reqs = list(/obj/item/stack/sheet/metal = 3,
				/obj/item/stack/sheet/plasteel = 1,
				/obj/item/stack/packageWrap = 1)
	tools = list(TOOL_WELDER,TOOL_SCREWDRIVER)
	time = 5
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

////////////////////
// PARTS CRAFTING //
////////////////////

// BARRELS

/datum/crafting_recipe/rifle_barrel
	name = "Improvised Rifle Barrel"
	result = /obj/item/weaponcrafting/improvised_parts/barrel_rifle
	reqs = list(/obj/item/pipe = 2)
	tools = list(TOOL_WELDER,TOOL_SAW)
	time = 150
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS

/datum/crafting_recipe/shotgun_barrel
	name = "Improvised Shotgun Barrel"
	result = /obj/item/weaponcrafting/improvised_parts/barrel_shotgun
	reqs = list(/obj/item/pipe = 2)
	tools = list(TOOL_WELDER,TOOL_SAW)
	time = 150
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS

/datum/crafting_recipe/pistol_barrel
	name = "Improvised Pistol Barrel"
	result = /obj/item/weaponcrafting/improvised_parts/barrel_pistol
	reqs = list(/obj/item/pipe = 1,
				/obj/item/stack/sheet/plasteel = 1)
	tools = list(TOOL_WELDER,TOOL_SAW)
	time = 150
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS

// RECEIVERS

/datum/crafting_recipe/rifle_receiver
	name = "Improvised Rifle Receiver"
	result = /obj/item/weaponcrafting/improvised_parts/rifle_receiver
	reqs = list(/obj/item/stack/sheet/metal = 10,
				/obj/item/stack/sheet/plasteel = 1)
	tools = list(TOOL_SCREWDRIVER, TOOL_WELDER)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS

/datum/crafting_recipe/shotgun_receiver
	name = "Improvised Shotgun Receiver"
	result = /obj/item/weaponcrafting/improvised_parts/shotgun_receiver
	reqs = list(/obj/item/stack/sheet/metal = 10,
				/obj/item/stack/sheet/plasteel = 1)
	tools = list(TOOL_SCREWDRIVER, TOOL_WELDER) // Dual wielding has been removed, plasteel is a soft timesink to obtain for most to make mass production harder.
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS

/datum/crafting_recipe/pistol_receiver
	name = "Improvised Pistol Receiver"
	result = /obj/item/weaponcrafting/improvised_parts/pistol_receiver
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/sheet/plasteel = 1)
	tools = list(TOOL_SCREWDRIVER, TOOL_WELDER, TOOL_SAW)
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS

/datum/crafting_recipe/laser_receiver
	name = "Energy Weapon Assembly"
	result = /obj/item/weaponcrafting/improvised_parts/laser_receiver
	reqs = list(/obj/item/stack/sheet/metal = 10,
				/obj/item/stock_parts/capacitor = 2,
				/obj/item/stock_parts/micro_laser = 1,
				/obj/item/assembly/prox_sensor = 1)
	tools = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WELDER) // Prox sensor and multitool for the circuit board, welder for extremely ghetto soldering.
	time = 150
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS

// MISC

/datum/crafting_recipe/trigger_assembly
	name = "Trigger Assembly"
	result = /obj/item/weaponcrafting/improvised_parts/trigger_assembly
	reqs = list(/obj/item/stack/sheet/metal = 3,
				/obj/item/assembly/igniter = 1)
	tools = list(TOOL_SCREWDRIVER, TOOL_WELDER)
	time = 150
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS

/datum/crafting_recipe/makeshift_lens
	name = "Makeshift Lens"
	result = /obj/item/weaponcrafting/improvised_parts/makeshift_lens
	reqs = list(/obj/item/stack/sheet/metal = 1,
				/obj/item/stack/sheet/glass = 2)
	tools = list(TOOL_WELDER) // Glassmaking lets you make non-makeshift lenses.
	time = 50
	category = CAT_WEAPONRY
	subcategory = CAT_PARTS
