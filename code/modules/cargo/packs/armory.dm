
//Reminders-
// If you add something to this list, please group it by type and sort it alphabetically instead of just jamming it in like an animal
// cost = 700- Minimum cost, or infinite points are possible.
//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Armory //////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/security/armory
	group = "Armory"
	access = ACCESS_ARMORY
	crate_type = /obj/structure/closet/crate/secure/weapon

/datum/supply_pack/security/armory/bulletarmor
	name = "Bulletproof Armor Crate"
	desc = "Contains three sets of bulletproof armor. Guaranteed to reduce a bullet's stopping power by over half. Requires Armory access to open."
	cost = 1250
	contains = list(/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/suit/armor/bulletproof)
	crate_name = "bulletproof armor crate"

/datum/supply_pack/security/armory/bullethelmets
	name = "Bulletproof Helmet Crate"
	desc = "Contains three sets of bulletproof helmets. Guaranteed to reduce a bullet's stopping power by over half. Requires Armory access to open."
	cost = 1250
	contains = list(/obj/item/clothing/head/helmet/alt,
					/obj/item/clothing/head/helmet/alt,
					/obj/item/clothing/head/helmet/alt)
	crate_name = "bulletproof helmet crate"

/datum/supply_pack/security/armory/chemimp
	name = "Chemical Implants Crate"
	desc = "Contains five Remote Chemical implants. Requires Armory access to open."
	cost = 1700
	contains = list(/obj/item/storage/box/chemimp)
	crate_name = "chemical implant crate"

/datum/supply_pack/security/armory/combatknives
	name = "Combat Knives Crate"
	desc = "Contains three sharpened combat knives. Each knife guaranteed to fit snugly inside any Nanotrasen-standard boot. Requires Armory access to open."
	cost = 3200
	contains = list(/obj/item/kitchen/knife/combat,
					/obj/item/kitchen/knife/combat,
					/obj/item/kitchen/knife/combat)
	crate_name = "combat knife crate"

/datum/supply_pack/security/armory/ballistic
	name = "Combat Shotguns Crate"
	desc = "For when the enemy absolutely needs to be replaced with lead. Contains three Aussec-designed Combat Shotguns, with three Shotgun Bandoliers, as well as seven buchshot and 12g shotgun slugs. Requires Armory access to open."
	cost = 8000
	contains = list(/obj/item/gun/ballistic/shotgun/automatic/combat,
					/obj/item/gun/ballistic/shotgun/automatic/combat,
					/obj/item/gun/ballistic/shotgun/automatic/combat,
					/obj/item/storage/belt/bandolier,
					/obj/item/storage/belt/bandolier,
					/obj/item/storage/belt/bandolier,
					/obj/item/storage/box/lethalshot,
					/obj/item/storage/box/lethalslugs)
	crate_name = "combat shotguns crate"

/datum/supply_pack/security/armory/dragnetgun
	name = "DRAGnet gun Crate"
	desc = "Contains two DRAGnet guns. A Dynamic Rapid-Apprehension of the Guilty net the revolution in law enforcement technology that YOU Want! Requires Armory access to open."
	cost = 3250
	contains = list(/obj/item/gun/energy/e_gun/dragnet,
					/obj/item/gun/energy/e_gun/dragnet)
	crate_name = "anti riot net guns crate"

/datum/supply_pack/security/armory/energy
	name = "Energy Guns Crate"
	desc = "Contains three Energy Guns, capable of firing both nonlethal and lethal blasts of light. Requires Armory access to open."
	cost = 3250
	contains = list(/obj/item/gun/energy/e_gun,
					/obj/item/gun/energy/e_gun,
					/obj/item/gun/energy/e_gun)
	crate_name = "energy gun crate"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/security/armory/exileimp // Theres boxes in 2 lockers as well as gateway never realy being used sad
	name = "Exile Implants Crate"
	desc = "Contains five Exile implants. Requires Armory access to open."
	cost = 1050 //stops endless points
	contains = list(/obj/item/storage/box/exileimp)
	crate_name = "exile implant crate"

/datum/supply_pack/security/armory/mindshield
	name = "Mindshield Implants Crate"
	desc = "Prevent against radical thoughts with three Mindshield implants. Requires Armory access to open."
	cost = 4000
	contains = list(/obj/item/storage/lockbox/loyalty)
	crate_name = "mindshield implant crate"

/datum/supply_pack/security/armory/trackingimp
	name = "Tracking Implants Crate"
	desc = "Contains four tracking implants and three tracking speedloaders of tracing .38 ammo. Requires Armory access to open."
	cost = 1100
	contains = list(/obj/item/storage/box/trackimp,
					/obj/item/ammo_box/c38/trac,
					/obj/item/ammo_box/c38/trac,
					/obj/item/ammo_box/c38/trac)
	crate_name = "tracking implant crate"

/datum/supply_pack/security/armory/fire
	name = "Incendiary Weapons Crate"
	desc = "Burn, baby burn. Contains three incendiary grenades, seven incendiary slugs, three plasma canisters, and a flamethrower. Requires Brige access to open."
	cost = 1750
	access = ACCESS_HEADS
	contains = list(/obj/item/flamethrower/full,
					/obj/item/tank/internals/plasma,
					/obj/item/tank/internals/plasma,
					/obj/item/tank/internals/plasma,
					/obj/item/grenade/chem_grenade/incendiary,
					/obj/item/grenade/chem_grenade/incendiary,
					/obj/item/grenade/chem_grenade/incendiary,
					/obj/item/storage/box/fireshot)
	crate_name = "incendiary weapons crate"
	crate_type = /obj/structure/closet/crate/secure/plasma
	dangerous = TRUE

/datum/supply_pack/security/armory/miniguns
	name = "Personal Miniature Energy Guns"
	desc = "Contains three miniature energy guns. Each gun has a disabler and a lethal option. Requires Armory access to open."
	cost = 3000
	contains = list(/obj/item/gun/energy/e_gun/mini,
					/obj/item/gun/energy/e_gun/mini,
					/obj/item/gun/energy/e_gun/mini)
	crate_name = "personal energy guns crate"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/security/armory/laserarmor
	name = "Reflector Vest Crate"
	desc = "Contains two vests of highly reflective material. Each armor piece diffuses a laser's energy by over half, as well as offering a good chance to reflect the laser entirely. Requires Armory access to open."
	cost = 2000
	contains = list(/obj/item/clothing/suit/armor/laserproof,
					/obj/item/clothing/suit/armor/laserproof)
	crate_name = "reflector vest crate"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/security/armory/riotarmor
	name = "Riot Armor Crate"
	desc = "Contains three sets of heavy body armor. Advanced padding protects against close-ranged weaponry, making melee attacks feel only half as potent to the user. Requires Armory access to open."
	cost = 1750
	contains = list(/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/suit/armor/riot)
	crate_name = "riot armor crate"

/datum/supply_pack/security/armory/riothelmets
	name = "Riot Helmets Crate"
	desc = "Contains three riot helmets. Requires Armory access to open."
	cost = 1750
	contains = list(/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/head/helmet/riot)
	crate_name = "riot helmets crate"

/datum/supply_pack/security/armory/riotshields
	name = "Riot Shields Crate"
	desc = "For when the greytide gets really uppity. Contains three riot shields. Requires Armory access to open."
	cost = 2200
	contains = list(/obj/item/shield/riot,
					/obj/item/shield/riot,
					/obj/item/shield/riot)
	crate_name = "riot shields crate"

/datum/supply_pack/security/armory/russian
	name = "Russian Surplus Crate"
	desc = "Hello Comrade, we have the most modern russian military equipment the black market can offer, for the right price of course. Sadly we couldnt remove the lock so it requires Armory access to open."
	cost = 7500
	contraband = TRUE
	contains = list(/obj/item/reagent_containers/food/snacks/rationpack,
					/obj/item/ammo_box/a762,
					/obj/item/storage/toolbox/ammo,
					/obj/item/clothing/suit/armor/vest/russian,
					/obj/item/clothing/head/helmet/rus_helmet,
					/obj/item/clothing/shoes/russian,
					/obj/item/clothing/gloves/combat,
					/obj/item/clothing/under/syndicate/rus_army,
					/obj/item/clothing/under/costume/soviet,
					/obj/item/clothing/mask/russian_balaclava,
					/obj/item/clothing/head/helmet/rus_ushanka,
					/obj/item/clothing/suit/armor/vest/russian_coat,
					/obj/item/gun/ballistic/shotgun/boltaction)
	crate_name = "surplus military crate"

/datum/supply_pack/security/armory/russian/fill(obj/structure/closet/crate/C)
	for(var/i in 1 to 5)
		var/item = pick(contains)
		new item(C)

/datum/supply_pack/security/armory/swat
	name = "SWAT Crate"
	desc = "Contains two fullbody sets of tough, fireproof, pressurized suits designed in a joint effort by IS-ERI and Nanotrasen. Each set contains a suit, helmet, mask, combat belt, and combat gloves. Requires Armory access to open."
	cost = 6000
	contains = list(/obj/item/clothing/head/helmet/swat/nanotrasen,
					/obj/item/clothing/head/helmet/swat/nanotrasen,
					/obj/item/clothing/suit/space/swat,
					/obj/item/clothing/suit/space/swat,
					/obj/item/clothing/mask/gas/sechailer/swat,
					/obj/item/clothing/mask/gas/sechailer/swat,
					/obj/item/storage/belt/military/assault,
					/obj/item/storage/belt/military/assault,
					/obj/item/clothing/gloves/combat,
					/obj/item/clothing/gloves/combat)
	crate_name = "swat crate"

/datum/supply_pack/security/armory/wt550
	name = "WT-550 Semi-Auto Rifle Crate"
	desc = "Contains two high-powered, semiautomatic rifles chambered in 4.6x30mm. Requires Armory access to open."
	cost = 2550
	contains = list(/obj/item/gun/ballistic/automatic/wt550,
					/obj/item/gun/ballistic/automatic/wt550)
	crate_name = "auto rifle crate"

/datum/supply_pack/security/armory/wt550ammo
	name = "WT-550 Semi-Auto SMG Ammo Crate"
	desc = "Contains four 20-round magazines for the WT-550 Semi-Auto SMG. Each magazine is designed to facilitate rapid tactical reloads. Requires Armory access to open."
	cost = 1750
	contains = list(/obj/item/ammo_box/magazine/wt550m9,
					/obj/item/ammo_box/magazine/wt550m9,
					/obj/item/ammo_box/magazine/wt550m9,
					/obj/item/ammo_box/magazine/wt550m9)
	crate_name = "auto rifle ammo crate"

/datum/supply_pack/security/armory/wt550ammo_nonlethal // Takes around 12 shots to stamcrit someone
	name = "WT-550 Semi-Auto SMG Non-Lethal Ammo Crate"
	desc = "Contains four 20-round magazines for the WT-550 Semi-Auto SMG. Each magazine is designed to facilitate rapid tactical reloads. Requires Armory access to open."
	cost = 1000
	contains = list(/obj/item/ammo_box/magazine/wt550m9/wtrubber,
					/obj/item/ammo_box/magazine/wt550m9/wtrubber,
					/obj/item/ammo_box/magazine/wt550m9/wtrubber,
					/obj/item/ammo_box/magazine/wt550m9/wtrubber)
	crate_name = "auto rifle ammo crate"
