GLOBAL_LIST_INIT(hardcoded_gases, list(GAS_O2, GAS_N2, GAS_CO2, GAS_PLASMA)) //the main four gases, which were at one time hardcoded
GLOBAL_LIST_INIT(nonreactive_gases, typecacheof(list(GAS_O2, GAS_N2, GAS_CO2, GAS_PLUOXIUM, GAS_STIMULUM, GAS_NITRYL))) //unable to react amongst themselves

// Auxgm
// It's a send-up of XGM, like what baystation got.
// It's got the same architecture as XGM, but it's structured
// differently to make it more convenient for auxmos.

// Most important compared to TG is that it does away with hardcoded typepaths,
// which lead to problems on the auxmos end anyway. We cache the string value
// references on the Rust end, so no performance is lost here.

// Also allows you to add new gases at runtime

/proc/_auxtools_register_gas(datum/gas/gas) // makes sure auxtools knows stuff about this gas

/datum/auxgm
	var/list/datums = list()
	var/list/specific_heats = list()
	var/list/names = list()
	var/list/visibility = list()
	var/list/overlays = list()
	var/list/flags = list()
	var/list/ids = list()
	var/list/typepaths = list()
	var/list/fusion_powers = list()

/datum/auxgm/add_gas(datum/gas/gas)
	var/g = gas.id
	if(g)
		datums[g] = gas
		specific_heats[g] = gas.specific_heat
		names[g] = gas.name
		if(gas.moles_visible)
			visibility[g] = gas.moles_visible
			overlays[g] = new /list(FACTOR_GAS_VISIBLE_MAX)
			for(var/i in 1 to FACTOR_GAS_VISIBLE_MAX)
				overlays[g][i] = new /obj/effect/overlay/gas(gas.gas_overlay, i * 255 / FACTOR_GAS_VISIBLE_MAX)
		else
			visibility[g] = 0
			overlays[g] = 0
		flags[g] = gas.flags
		ids[g] = g
		typepaths[g] = gas_path
		fusion_powers[g] = gas.fusion_power
		_auxtools_register_gas(gas)

/datum/auxgm/New()
	for(var/gas_path in subtypesof(/datum/gas))
		var/datum/gas/gas = new gas_path
		add_gas(gas)

GLOBAL_DATUM_INIT(gas_data, /datum/auxgm, new)

/datum/breath_info
	var/breathing_power = 1 // how much this gas counts for good-breath
	var/breathing_class = null // what type of breath this is; lungs can also use gas IDs directly
	var/breath_results = GAS_CO2 // what breathing a mole of this results in

/datum/oxidation_info
	var/oxidation_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST // temperature above which this gas is an oxidizer
	var/list/oxidation_provides = list() // a list of elements this gas provides in combustion

/datum/gas
	var/id = ""
	var/specific_heat = 0
	var/name = ""
	var/gas_overlay = "" //icon_state in icons/effects/atmospherics.dmi
	var/moles_visible = null
	var/flags = NONE //currently used by canisters
	var/fusion_power = 0 // How much the gas destabilizes a fusion reaction
	var/breathing_power = 1 // how much this gas counts for good-breath
	var/breathing_class = null // what type of breath this is; lungs can also use gas IDs directly
	var/breath_results = GAS_CO2 // what breathing a mole of this results in
	var/oxidation_temperature = null // temperature above which this gas is an oxidizer; null for none
	var/oxidation_rate = 1 // how many moles of this can oxidize how many moles of material
	var/oxidation_energy_released = 0 // how many moles are released per mole burned
	var/list/oxidation_products = null // extra results from oxidizing this (per mole); null for none
	var/fire_temperature = null // temperature above which gas may catch fire; null for none
	var/list/fire_provides = null // what elements this gas provides as fuel for combustion; null for none
	var/fire_energy_released = 0 // how much energy is released per mole of fuel burned
	var/fire_burn_rate = 1 // how many moles are burned per product released

/datum/gas/oxygen
	id = GAS_O2
	specific_heat = 20
	name = "Oxygen"
	breathing_class = BREATH_OXY
	oxidation_temperature = T0C - 100 // it checks max of this and fire temperature, so rarely will things spontaneously combust

/datum/gas/nitrogen
	id = GAS_N2
	specific_heat = 20
	name = "Nitrogen"

/datum/gas/carbon_dioxide //what the fuck is this?
	id = GAS_CO2
	specific_heat = 30
	name = "Carbon Dioxide"
	fusion_power = 3

/datum/gas/plasma
	id = GAS_PLASMA
	specific_heat = 200
	name = "Plasma"
	gas_overlay = "plasma"
	moles_visible = MOLES_GAS_VISIBLE
	flags = GAS_FLAG_DANGEROUS
	breathing_class = BREATH_PLASMA
	// no fire info cause it has its own bespoke reaction for trit generation reasons

/datum/gas/water_vapor
	id = GAS_H2O
	specific_heat = 40
	name = "Water Vapor"
	gas_overlay = "water_vapor"
	moles_visible = MOLES_GAS_VISIBLE
	fusion_power = 8

/datum/gas/hypernoblium
	id = GAS_HYPERNOB
	specific_heat = 2000
	name = "Hyper-noblium"
	gas_overlay = "freon"
	moles_visible = MOLES_GAS_VISIBLE

/datum/gas/nitrous_oxide
	id = GAS_NITROUS
	specific_heat = 40
	name = "Nitrous Oxide"
	gas_overlay = "nitrous_oxide"
	moles_visible = MOLES_GAS_VISIBLE * 2
	flags = GAS_FLAG_DANGEROUS
	oxidation_products = list(GAS_N2 = 1)
	oxidation_rate = 0.5
	oxidation_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST + 100

/datum/gas/nitryl
	id = GAS_NITRYL
	specific_heat = 20
	name = "Nitryl"
	gas_overlay = "nitryl"
	moles_visible = MOLES_GAS_VISIBLE
	flags = GAS_FLAG_DANGEROUS
	fusion_power = 15
	oxidation_products = list(GAS_N2 = 0.5)
	oxidation_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST - 50

/datum/gas/tritium
	id = GAS_TRITIUM
	specific_heat = 10
	name = "Tritium"
	gas_overlay = "tritium"
	moles_visible = MOLES_GAS_VISIBLE
	flags = GAS_FLAG_DANGEROUS
	fusion_power = 1
	/*
	these are for when we add hydrogen, trit gets to keep its hardcoded fire for legacy reasons
	fire_provides = list(GAS_H2O = 2)
	fire_burn_rate = 2
	fire_energy_released = FIRE_HYDROGEN_ENERGY_RELEASED
	fire_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST - 50
	*/

/datum/gas/bz
	id = GAS_BZ
	specific_heat = 20
	name = "BZ"
	flags = GAS_FLAG_DANGEROUS
	fusion_power = 8

/datum/gas/stimulum
	id = GAS_STIMULUM
	specific_heat = 5
	name = "Stimulum"
	fusion_power = 7

/datum/gas/pluoxium
	id = GAS_PLUOXIUM
	specific_heat = 80
	name = "Pluoxium"
	fusion_power = 10
	breathing_power = 8
	breathing_class = CLASS_OXY
	oxidation_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST + 100
	oxidation_rate = 8

/datum/gas/miasma
	id = GAS_MIASMA
	specific_heat = 20
	fusion_power = 50
	name = "Miasma"
	gas_overlay = "miasma"
	moles_visible = MOLES_GAS_VISIBLE * 60

/datum/gas/methane
	id = GAS_METHANE
	specific_heat = 30
	name = "Methane"
	fire_provides = list(GAS_CO2 = 1, GAS_H2O = 2)
	fire_burn_rate = 0.5
	fire_energy_released = FIRE_CARBON_ENERGY_RELEASED
	fire_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST

/datum/gas/methyl_bromide
	id = GAS_METHYL_BROMIDE
	specific_heat = 42
	name = "Methyl Bromide"
	flags = GAS_FLAG_DANGEROUS
	fire_provides = list(GAS_CO2 = 1, GAS_H2O = 1.5, GAS_BZ = 0.5)
	fire_energy_released = FIRE_CARBON_ENERGY_RELEASED
	fire_burn_rate = 0.5
	fire_temperature = 808 // its autoignition, it apparently doesn't spark readily, so i don't put it lower


/obj/effect/overlay/gas
	icon = 'icons/effects/atmospherics.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE  // should only appear in vis_contents, but to be safe
	layer = FLY_LAYER
	appearance_flags = TILE_BOUND
	vis_flags = NONE

/obj/effect/overlay/gas/New(state, alph)
	. = ..()
	icon_state = state
	alpha = alph
