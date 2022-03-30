// Base chasm, defaults to oblivion but can be overridden
/turf/open/chasm
	name = "chasm"
	desc = "Watch your step."
	baseturfs = /turf/open/chasm
	smooth = SMOOTH_TRUE | SMOOTH_BORDER | SMOOTH_MORE
	turf_construct_flags = TURF_CONSTRUCT_FLAGS_PLATING_OVER
	icon = 'icons/turf/floors/chasms.dmi'
	icon_state = "smooth"
	canSmoothWith = list(/turf/open/floor/fakepit, /turf/open/chasm)
	density = TRUE //This will prevent hostile mobs from pathing into chasms, while the canpass override will still let it function like an open turf
	bullet_bounce_sound = null //abandon all hope ye who enter
	dirt_buildup_allowed = FALSE

/turf/open/chasm/Initialize()
	. = ..()
	AddComponent(/datum/component/chasm, Below())

/turf/open/chasm/UpdateMultiZ()
	. = ..()
	set_target(Below())

/turf/open/chasm/proc/set_target(turf/target)
	var/datum/component/chasm/chasm_component = GetComponent(/datum/component/chasm)
	chasm_component.target_turf = target

/turf/open/chasm/proc/drop(atom/movable/AM)
	var/datum/component/chasm/chasm_component = GetComponent(/datum/component/chasm)
	chasm_component.drop(AM)

/turf/open/chasm/MakeSlippery(wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)
	return

/turf/open/chasm/MakeDry()
	return

/turf/open/chasm/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/floors.dmi'
	underlay_appearance.icon_state = "basalt"
	return TRUE

/turf/open/chasm/CanPass(atom/movable/mover, turf/target)
	return 1

// Chasms for Lavaland, with planetary atmos and lava glow
/turf/open/chasm/lavaland
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	planetary_atmos = TRUE
	baseturfs = /turf/open/chasm/lavaland
	light_range = 1.9 //slightly less range than lava
	light_power = 0.65 //less bright, too
	light_color = LIGHT_COLOR_LAVA //let's just say you're falling into lava, that makes sense right

// Chasms for Ice moon, with planetary atmos and glow
/turf/open/chasm/icemoon
	icon = 'icons/turf/floors/icechasms.dmi'
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	planetary_atmos = TRUE
	baseturfs = /turf/open/chasm/icemoon
	light_range = 1.9
	light_power = 0.65
	light_color = LIGHT_COLOR_PURPLE

// Chasms for the jungle, with planetary atmos and a different icon
/turf/open/chasm/jungle
	icon = 'icons/turf/floors/junglechasm.dmi'
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	planetary_atmos = TRUE
	baseturfs = /turf/open/chasm/jungle

/turf/open/chasm/jungle/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/floors.dmi'
	underlay_appearance.icon_state = "dirt"
	return TRUE

//For Bag of Holding Bombs

/turf/open/chasm/magic
	name = "tear in the fabric of reality"
	desc = "Where does it lead?"
	icon = 'icons/turf/floors/magic_chasm.dmi'
	baseturfs = /turf/open/chasm/magic
	light_range = 1.9
	light_power = 0.65

/turf/open/chasm/magic/Initialize()
	. = ..()
	var/turf/T = safepick(get_area_turfs(/area/fabric_of_reality))
	if(T)
		set_target(T)
