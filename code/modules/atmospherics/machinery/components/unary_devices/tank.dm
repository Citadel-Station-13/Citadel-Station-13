#define AIR_CONTENTS	((25*ONE_ATMOSPHERE)*(air_contents.volume)/(R_IDEAL_GAS_EQUATION*air_contents.temperature))
/obj/machinery/atmospherics/components/unary/tank
	icon = 'icons/obj/atmospherics/pipes/pressure_tank.dmi'
	icon_state = "generic"
	name = "pressure tank"
	desc = "A large vessel containing pressurized gas."
	max_integrity = 800
	density = TRUE
	layer = ABOVE_WINDOW_LAYER
	plane = GAME_PLANE
	pipe_flags = PIPING_ONE_PER_TURF
	var/volume = 10000 //in liters
	var/gas_type = 0

/obj/machinery/atmospherics/components/unary/tank/New()
	..()
	var/datum/gas_mixture/air_contents = airs[1]
	air_contents.volume = volume
	air_contents.temperature = T20C
	if(gas_type)
		air_contents.gases[gas_type] = AIR_CONTENTS
		name = "[name] ([GLOB.meta_gas_names[gas_type]])"

/obj/machinery/atmospherics/components/unary/tank/air
	icon_state = "grey"
	name = "pressure tank (Air)"

/obj/machinery/atmospherics/components/unary/tank/air/New()
	..()
	var/datum/gas_mixture/air_contents = airs[1]
	air_contents.gases[/datum/gas/oxygen] = AIR_CONTENTS * 0.2
	air_contents.gases[/datum/gas/nitrogen] = AIR_CONTENTS * 0.8

/obj/machinery/atmospherics/components/unary/tank/carbon_dioxide
	gas_type = /datum/gas/carbon_dioxide

/obj/machinery/atmospherics/components/unary/tank/toxins
	icon_state = "orange"
	gas_type = /datum/gas/plasma

/obj/machinery/atmospherics/components/unary/tank/oxygen
	icon_state = "blue"
	gas_type = /datum/gas/oxygen

/obj/machinery/atmospherics/components/unary/tank/nitrogen
	icon_state = "red"
	gas_type = /datum/gas/nitrogen

/obj/machinery/atmospherics/components/unary/tank/nitrous_oxide
	icon_state = "red_white"
	gas_type = /datum/gas/nitrous_oxide

