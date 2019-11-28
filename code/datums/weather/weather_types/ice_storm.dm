//Same as snow_storm basically, but cools outside turf temps. StreetStation only
/datum/weather/ice_storm
	name = "Icestorm"
	desc = "Harsh snowstorms roam the topside of this arctic planet, burying any area unfortunate enough to be in its path."
	probability = 90

	telegraph_message = "<span class='warning'>Drifting particles of snow begin to dust the surrounding area..</span>"
	telegraph_duration = 300
	telegraph_overlay = "light_snow"

	weather_message = "<span class='userdanger'><i>Harsh winds pick up as dense snow begins to fall from the sky! Seek shelter!</i></span>"
	weather_overlay = "snow_storm"
	weather_duration_lower = 600
	weather_duration_upper = 1500

	end_duration = 100
	end_message = "<span class='boldannounce'>The snowfall dies down, it should be safe to go outside again.</span>"

	area_type = /area/edina
	protected_areas = list(/area/edina/protected)
	target_trait = ZTRAIT_STATION

	immunity_type = "rad"

/datum/weather/ice_storm/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(10,20))

/datum/weather/ice_storm/update_areas()
	.=..()
	//could be done better but would need a rewrite of weather which is beyond scope.
	for(var/V in impacted_areas)
		var/area/N = V
		for(var/turf/open/T in N)
			var/datum/gas_mixture/turf/G = T.air
			G.temperature -= 50
