
//Reminders-
// If you add something to this list, please group it by type and sort it alphabetically instead of just jamming it in like an animal
// cost = 700- Minimum cost, or infinite points are possible.
//////////////////////////////////////////////////////////////////////////////
/////////////////////// Canisters & Materials ////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/materials
	group = "Canisters & Materials"

//////////////////////////////////////////////////////////////////////////////
///////////////////////////// Materials //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/materials/cardboard50
	name = "50 Cardboard Sheets"
	desc = "Create a bunch of boxes."
	cost = 1000
	contains = list(/obj/item/stack/sheet/cardboard/fifty)
	crate_name = "cardboard sheets crate"

/datum/supply_pack/materials/glass50
	name = "50 Glass Sheets"
	desc = "Let some nice light in with fifty glass sheets!"
	cost = 850
	contains = list(/obj/item/stack/sheet/glass/fifty)
	crate_name = "glass sheets crate"

/datum/supply_pack/materials/metal50
	name = "50 Metal Sheets"
	desc = "Any construction project begins with a good stack of fifty metal sheets!"
	cost = 850
	contains = list(/obj/item/stack/sheet/metal/fifty)
	crate_name = "metal sheets crate"

/datum/supply_pack/materials/plasteel20
	name = "20 Plasteel Sheets"
	desc = "Reinforce the station's integrity with twenty plasteel sheets!"
	cost = 4700
	contains = list(/obj/item/stack/sheet/plasteel/twenty)
	crate_name = "plasteel sheets crate"

/datum/supply_pack/materials/plasteel50
	name = "50 Plasteel Sheets"
	desc = "For when you REALLY have to reinforce something."
	cost = 9050
	contains = list(/obj/item/stack/sheet/plasteel/fifty)
	crate_name = "plasteel sheets crate"

/datum/supply_pack/materials/plastic50
	name = "50 Plastic Sheets"
	desc = "Build a limitless amount of toys with fifty plastic sheets!"
	cost = 950
	contains = list(/obj/item/stack/sheet/plastic/fifty)
	crate_name = "plastic sheets crate"

/datum/supply_pack/materials/sandstone30
	name = "30 Sandstone Blocks"
	desc = "Neither sandy nor stoney, these thirty blocks will still get the job done."
	cost = 800
	contains = list(/obj/item/stack/sheet/mineral/sandstone/thirty)
	crate_name = "sandstone blocks crate"

/datum/supply_pack/materials/rawlumber
	name = "50 Towercap Logs"
	desc = "Raw logs from towercaps. Contains fifty logs."
	cost = 1000
	contains = list(/obj/item/grown/log)
	crate_name = "lumber crate"

/datum/supply_pack/materials/rawlumber/generate()
	. = ..()
	for(var/i in 1 to 49)
		new /obj/item/grown/log(.)

/datum/supply_pack/materials/wood50
	name = "50 Wood Planks"
	desc = "Turn cargo's boring metal groundwork into beautiful panelled flooring and much more with fifty wooden planks!"
	cost = 1450
	contains = list(/obj/item/stack/sheet/mineral/wood/fifty)
	crate_name = "wood planks crate"

/datum/supply_pack/materials/rawcotton
	name = "Raw Cotton Crate"
	desc = "Plushies have been on the down in the market, and now due to a flood of raw cotton the price of it is so cheap, its a steal! Contains 40 raw cotton sheets."
	cost = 800 // 100 net cost, 20 x 20 = 400. 300 profit if turned into cloth sheets or more if turned to silk then 10 x 200 = 2000
	contains = list(/obj/item/stack/sheet/cotton/thirty,
					/obj/item/stack/sheet/cotton/ten
					)
	crate_name = "cotton crate"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/materials/rawcottonbulk
	name = "Raw Cotton Crate (Bulk)"
	desc = "We have so much of this stuff we need to get rid of it in -bulk- now. This crate contains 240 raw cotton sheets."
	cost = 1300 // 600 net cost 20 x 120 = 2400 profit if turned into cloth sheets or if turned into silk 200 x 60 = 12000
	contains = list(/obj/item/stack/sheet/cotton/thirty,
					/obj/item/stack/sheet/cotton/thirty,
					/obj/item/stack/sheet/cotton/thirty,
					/obj/item/stack/sheet/cotton/thirty,
					/obj/item/stack/sheet/cotton/thirty,
					/obj/item/stack/sheet/cotton/thirty,
					/obj/item/stack/sheet/cotton/thirty,
					/obj/item/stack/sheet/cotton/thirty,
					)
	crate_name = "bulk cotton crate"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/materials/rcdammo
	name = "Spare RCD ammo"
	desc = "This crate contains sixteen RCD compressed matter packs, to help with any holes or projects people might be working on."
	cost = 3750
	contains = list(/obj/item/rcd_ammo,
					/obj/item/rcd_ammo,
					/obj/item/rcd_ammo,
					/obj/item/rcd_ammo,
					/obj/item/rcd_ammo,
					/obj/item/rcd_ammo,
					/obj/item/rcd_ammo,
					/obj/item/rcd_ammo,
					/obj/item/rcd_ammo,
					/obj/item/rcd_ammo,
					/obj/item/rcd_ammo,
					/obj/item/rcd_ammo,
					/obj/item/rcd_ammo,
					/obj/item/rcd_ammo,
					/obj/item/rcd_ammo,
					/obj/item/rcd_ammo)
	crate_name = "rcd ammo"

//////////////////////////////////////////////////////////////////////////////
///////////////////////////// Canisters //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/materials/bz
	name = "BZ Canister Crate"
	desc = "Contains a canister of BZ. Requires Toxins access to open."
	cost = 7500 // Costs 3 credits more than what you can get for selling it.
	access = ACCESS_TOX_STORAGE
	contains = list(/obj/machinery/portable_atmospherics/canister/bz)
	crate_name = "BZ canister crate"
	crate_type = /obj/structure/closet/crate/secure/science

/datum/supply_pack/materials/carbon_dio
	name = "Carbon Dioxide Canister"
	desc = "Contains a canister of Carbon Dioxide."
	cost = 3000
	contains = list(/obj/machinery/portable_atmospherics/canister/carbon_dioxide)
	crate_name = "carbon dioxide canister crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/nitrogen
	name = "Nitrogen Canister"
	desc = "Contains a canister of Nitrogen."
	cost = 2000
	contains = list(/obj/machinery/portable_atmospherics/canister/nitrogen)
	crate_name = "nitrogen canister crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/nitrous_oxide_canister
	name = "Nitrous Oxide Canister"
	desc = "Contains a canister of Nitrous Oxide. Requires Atmospherics access to open."
	cost = 3000
	access = ACCESS_ATMOSPHERICS
	contains = list(/obj/machinery/portable_atmospherics/canister/nitrous_oxide)
	crate_name = "nitrous oxide canister crate"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/materials/oxygen
	name = "Oxygen Canister"
	desc = "Contains a canister of Oxygen. Canned in Druidia."
	cost = 1500
	contains = list(/obj/machinery/portable_atmospherics/canister/oxygen)
	crate_name = "oxygen canister crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/water_vapor
	name = "Water Vapor Canister"
	desc = "Contains a canister of Water Vapor. I swear to god if you open this in the halls..."
	cost = 2500
	contains = list(/obj/machinery/portable_atmospherics/canister/water_vapor)
	crate_name = "water vapor canister crate"
	crate_type = /obj/structure/closet/crate/large

//////////////////////////////////////////////////////////////////////////////
/////////////////////////////// Tanks ////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/materials/fueltank
	name = "Fuel Tank Crate"
	desc = "Contains a welding fuel tank. Caution, highly flammable."
	cost = 800
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	crate_name = "fuel tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/watertank
	name = "Water Tank Crate"
	desc = "Contains a tank of dihydrogen monoxide... sounds dangerous."
	cost = 600
	contains = list(/obj/structure/reagent_dispensers/watertank)
	crate_name = "water tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/foamtank
	name = "Firefighting Foam Tank Crate"
	desc = "Contains a tank of firefighting foam. Also known as \"plasmaman's bane\"."
	cost = 1500
	contains = list(/obj/structure/reagent_dispensers/foamtank)
	crate_name = "foam tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/hightank
	name = "Large Water Tank Crate"
	desc = "Contains a high-capacity water tank. Useful for botany or other service jobs."
	cost = 1200
	contains = list(/obj/structure/reagent_dispensers/watertank/high)
	crate_name = "high-capacity water tank crate"
	crate_type = /obj/structure/closet/crate/large


