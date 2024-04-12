
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
	crate_type = /obj/structure/closet/secure_closet/cargo
	name = "50 Cardboard Sheets"
	desc = "Create a bunch of boxes."
	cost = 300 //thrice their export value
	contains = list(/obj/item/stack/sheet/cardboard/fifty)

/datum/supply_pack/materials/license50
	name = "50 Empty License Plates"
	desc = "Create a bunch of boxes."
	cost = 1000  // 50 * 25 + 700 - 1000 = 950 credits profit
	contains = list(/obj/item/stack/license_plates/empty/fifty)
	crate_name = "empty license plate crate"

/datum/supply_pack/materials/glass50
	crate_type = /obj/structure/closet/secure_closet/cargo
	name = "50 Glass Sheets"
	desc = "Let some nice light in with fifty glass sheets!"
	cost = 300 //double their export value
	contains = list(/obj/item/stack/sheet/glass/fifty)

/datum/supply_pack/materials/metal50
	crate_type = /obj/structure/closet/secure_closet/cargo
	name = "50 Metal Sheets"
	desc = "Any construction project begins with a good stack of fifty metal sheets!"
	cost = 300 //double their export value
	contains = list(/obj/item/stack/sheet/metal/fifty)

/datum/supply_pack/materials/plasteel20
	crate_type = /obj/structure/closet/secure_closet/cargo
	name = "20 Plasteel Sheets"
	desc = "Reinforce the station's integrity with twenty plasteel sheets!"
	cost = 4000
	contains = list(/obj/item/stack/sheet/plasteel/twenty)

/datum/supply_pack/materials/plastic20
	crate_type = /obj/structure/closet/secure_closet/cargo
	name = "20 Plastic Sheets"
	desc = "Build a limitless amount of toys with fifty plastic sheets!"
	cost = 200 // double their export
	contains = list(/obj/item/stack/sheet/plastic/twenty)

/datum/supply_pack/materials/sandstone30
	crate_type = /obj/structure/closet/secure_closet/cargo
	name = "30 Sandstone Blocks"
	desc = "Neither sandy nor stoney, these thirty blocks will still get the job done."
	cost = 150 // five times their export
	contains = list(/obj/item/stack/sheet/mineral/sandstone/thirty)

/datum/supply_pack/materials/wood20
	crate_type = /obj/structure/closet/secure_closet/cargo
	name = "20 Wood Planks"
	desc = "Turn cargo's boring metal groundwork into beautiful panelled flooring and much more with twenty wooden planks!"
	cost = 400 // 6-7 planks shy from having equal import/export prices
	contains = list(/obj/item/stack/sheet/mineral/wood/twenty)

/datum/supply_pack/materials/rcdammo
	crate_type = /obj/structure/closet/secure_closet/cargo
	name = "Large RCD ammo Single-Pack"
	desc = "A single large compressed RCD matter pack, to help with any holes or projects people might be working on."
	cost = 600
	contains = list(/obj/item/rcd_ammo/large)

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

/datum/supply_pack/materials/hightankfuel
	name = "Large Fuel Tank Crate"
	desc = "Contains a high-capacity fuel tank. Keep contents away from open flame."
	cost = 2000
	contains = list(/obj/structure/reagent_dispensers/fueltank/high)
	crate_name = "high-capacity fuel tank crate"
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


