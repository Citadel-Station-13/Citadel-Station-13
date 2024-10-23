//Same as snow_storm basically, but cools outside turf temps. StreetStation only
#define ICY_SNOW_TEMP 200
/datum/weather/ice_storm
	name = "Icestorm"
	desc = "Harsh snowstorms roam the topside of this arctic planet, burying any area unfortunate enough to be in its path."
	probability = 90

	telegraph_message = "<span class='notice'>Drifting particles of snow begin to dust the surrounding area..</span>"
	telegraph_duration = 300
	telegraph_overlay = "light_snow"

	weather_message = "<span class='notice'><i>Dense snow begins to fall from the sky, how festive!</i></span>"
	weather_overlay = "snow_storm"
	weather_duration_lower = 600
	weather_duration_upper = 1500

	end_duration = 100
	end_message = "<span class='notice'>The snowfall dies down.</span>"

	area_type = /area/edina
	protected_areas = list(/area/edina/protected)
	target_trait = ZTRAIT_ICESTORM

	immunity_type = TRAIT_SNOWSTORM_IMMUNE

/datum/weather/ice_storm/weather_act(mob/living/L)
	//L.adjust_bodytemperature(-rand(10,20))

/datum/weather/ice_storm/weather_act_turf(area/N)
	.=..()
	//could be done better but would need a rewrite of weather which is beyond scope.
	/*
	for(var/turf/open/T in N)
		var/datum/gas_mixture/turf/G = T.air
		G.temperature = ICY_SNOW_TEMP
	*/
