/* In this file:
 * Wood floor
 * Grass floor
 * Fake Basalt
 * Carpet floor
 * Fake pits
 * Fake space
 */

/turf/open/floor/wood
	desc = "Stylish dark wood."
	icon_state = "wood"
	floor_tile = /obj/item/stack/tile/wood
	custom_materials = list(/datum/material/wood = MINERAL_MATERIAL_AMOUNT * 0.25)
	broken_states = list("wood-broken", "wood-broken2", "wood-broken3", "wood-broken4", "wood-broken5", "wood-broken6", "wood-broken7")
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_WOOD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE

/turf/open/floor/wood/examine(mob/user)
	. = ..()
	. += "<span class='notice'>There's a few <b>screws</b> and a <b>small crack</b> visible.</span>"

/turf/open/floor/wood/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	. = STOP_ATTACK_PROC_CHAIN
	pry_tile(I, user)

/turf/open/floor/wood/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	if(T.turf_type == type)
		return
	var/obj/item/tool = user.is_holding_item_of_type(/obj/item/screwdriver)
	if(!tool)
		tool = user.is_holding_item_of_type(/obj/item/crowbar)
	if(!tool)
		return
	var/turf/open/floor/plating/P = pry_tile(tool, user, TRUE)
	if(!istype(P))
		return
	P.attackby(T, user, params)

/turf/open/floor/wood/pry_tile(obj/item/C, mob/user, silent = FALSE)
	C.play_tool_sound(src, 80)
	return remove_tile(user, silent, (C.tool_behaviour == TOOL_SCREWDRIVER))

/turf/open/floor/wood/remove_tile(mob/user, silent = FALSE, make_tile = TRUE, forced = FALSE)
	if(broken || burnt)
		broken = 0
		burnt = 0
		if(user && !silent)
			to_chat(user, "<span class='notice'>You remove the broken planks.</span>")
	else
		if(make_tile)
			if(user && !silent)
				to_chat(user, "<span class='notice'>You unscrew the planks.</span>")
			if(floor_tile)
				new floor_tile(src)
		else
			if(user && !silent)
				to_chat(user, "<span class='notice'>You forcefully pry off the planks, destroying them in the process.</span>")
	return make_plating()

/turf/open/floor/wood/rust_heretic_act()
	if(prob(70))
		new /obj/effect/temp_visual/glowing_rune(src)
	ChangeTurf(/turf/open/floor/plating/rust)

/turf/open/floor/wood/cold
	temperature = 255.37

/turf/open/floor/wood/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/wood/wood_large
	desc = "Stylish dark wood."
	icon_state = "large_wood"
	floor_tile = /obj/item/stack/tile/wood/wood_large
	broken_states = list("large_wood-broken", "large_wood-broken2", "large_wood-broken3")

/turf/open/floor/wood/wood_tiled
	desc = "Stylish dark wood."
	icon_state = "wood_tile"
	floor_tile = /obj/item/stack/tile/wood/wood_tiled
	broken_states = list("wood_tile-broken", "wood_tile-broken2", "wood_tile-broken3")

/turf/open/floor/wood/wood_diagonal
	desc = "Stylish dark wood."
	icon_state = "diagonal_wood"
	floor_tile = /obj/item/stack/tile/wood/wood_diagonal
	broken_states = list("diagonal_wood-broken", "diagonal_wood-broken2", "diagonal_wood-broken3")

/turf/open/floor/grass
	name = "grass patch"
	desc = "You can't tell if this is real grass or just cheap plastic imitation."
	icon_state = "grass"
	floor_tile = /obj/item/stack/tile/grass
	broken_states = list("sand")
	flags_1 = NONE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	clawfootstep = FOOTSTEP_GRASS
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	var/ore_type = /obj/item/stack/ore/glass
	var/turfverb = "uproot"
	tiled_dirt = FALSE

/turf/open/floor/grass/Initialize()
	. = ..()
	update_icon()

/turf/open/floor/grass/attackby(obj/item/C, mob/user, params)
	if((C.tool_behaviour == TOOL_SHOVEL) && params)
		new ore_type(src, 2)
		user.visible_message("[user] digs up [src].", "<span class='notice'>You [turfverb] [src].</span>")
		playsound(src, 'sound/effects/shovel_dig.ogg', 50, 1)
		make_plating()
	if(..())
		return

/turf/open/floor/grass/fairy //like grass but fae-er
	name = "fairygrass patch"
	desc = "Something about this grass makes you want to frolic. Or get high."
	icon_state = "fairygrass"
	floor_tile = /obj/item/stack/tile/fairygrass
	light_range = 2
	light_power = 0.80
	light_color = "#33CCFF"
	color = "#33CCFF"

/turf/open/floor/grass/fairy/white
	name = "white fairygrass patch"
	light_color = "#FFFFFF"
	color = "#FFFFFF"
	floor_tile = /obj/item/stack/tile/fairygrass/white

/turf/open/floor/grass/fairy/red
	name = "red fairygrass patch"
	light_color = "#FF3333"
	color = "#FF3333"
	floor_tile = /obj/item/stack/tile/fairygrass/red

/turf/open/floor/grass/fairy/yellow
	name = "yellow fairygrass patch"
	light_color = "#FFFF66"
	color = "#FFFF66"
	floor_tile = /obj/item/stack/tile/fairygrass/yellow

/turf/open/floor/grass/fairy/green
	name = "green fairygrass patch"
	light_color = "#99FF99"
	color = "#99FF99"
	floor_tile = /obj/item/stack/tile/fairygrass/green

/turf/open/floor/grass/fairy/blue
	name = "blue fairygrass patch"
	floor_tile = /obj/item/stack/tile/fairygrass/blue

/turf/open/floor/grass/fairy/purple
	name = "purple fairygrass patch"
	light_color = "#D966FF"
	color = "#D966FF"
	floor_tile = /obj/item/stack/tile/fairygrass/purple

/turf/open/floor/grass/fairy/pink
	name = "pink fairygrass patch"
	light_color = "#FFB3DA"
	color = "#FFB3DA"
	floor_tile = /obj/item/stack/tile/fairygrass/pink

/turf/open/floor/grass/snow
	gender = PLURAL
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	desc = "Looks cold."
	icon_state = "snow"
	ore_type = /obj/item/stack/sheet/mineral/snow
	planetary_atmos = TRUE
	floor_tile = null
	initial_gas_mix = FROZEN_ATMOS
	slowdown = 1.5 //So digging it out paths are useful.
	bullet_sizzle = TRUE
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/grass/snow/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/grass/snow/crowbar_act(mob/living/user, obj/item/I)
	return

/turf/open/floor/grass/snow/basalt //By your powers combined, I am captain planet
	gender = NEUTER
	name = "volcanic floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "basalt"
	ore_type = /obj/item/stack/ore/glass/basalt
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	slowdown = 0

/turf/open/floor/grass/snow/basalt/Initialize()
	. = ..()
	if(prob(15))
		icon_state = "basalt[rand(0, 12)]"
		set_basalt_light(src)


/turf/open/floor/grass/fakebasalt //Heart is not a real planeteer power
	name = "aesthetic volcanic flooring"
	desc = "Safely recreated turf for your hellplanet-scaping."
	icon = 'icons/turf/floors.dmi'
	icon_state = "basalt"
	floor_tile = /obj/item/stack/tile/basalt
	ore_type = /obj/item/stack/ore/glass/basalt
	turfverb = "dig up"
	slowdown = 0
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/grass/fakebasalt/Initialize()
	. = ..()
	if(prob(15))
		icon_state = "basalt[rand(0, 12)]"
		set_basalt_light(src)


/turf/open/floor/carpet
	name = "carpet"
	desc = "Soft velvet carpeting. Feels good between your toes."
	icon = 'icons/turf/floors/carpet.dmi'
	icon_state = "carpet"
	floor_tile = /obj/item/stack/tile/carpet
	broken_states = list("damaged")
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/carpet, /turf/open/floor/carpet/airless)
	flags_1 = NONE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_CARPET
	barefootstep = FOOTSTEP_CARPET_BAREFOOT
	clawfootstep = FOOTSTEP_CARPET_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE

/turf/open/floor/carpet/examine(mob/user)
	. = ..()
	. += "<span class='notice'>There's a <b>small crack</b> on the edge of it.</span>"

/turf/open/floor/carpet/Initialize()
	. = ..()
	update_icon()

/turf/open/floor/carpet/update_icon()
	if(!..())
		return 0
	if(!broken && !burnt)
		if(smooth)
			queue_smooth(src)
	else
		make_plating()
		if(smooth)
			queue_smooth_neighbors(src)

/turf/open/floor/carpet/black
	icon = 'icons/turf/floors/carpet_black.dmi'
	floor_tile = /obj/item/stack/tile/carpet/black
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/carpet/black, /turf/open/floor/carpet/blackred, /turf/open/floor/carpet/monochrome)

/turf/open/floor/carpet/arcade
	icon = 'icons/turf/floors.dmi'
	icon_state = "arcade"
	floor_tile = /obj/item/stack/tile/carpet/arcade
	smooth = SMOOTH_FALSE
	canSmoothWith = list()

/turf/open/floor/carpet/blackred
	icon = 'icons/turf/floors/carpet_blackred.dmi'
	floor_tile = /obj/item/stack/tile/carpet/blackred
	icon_state = "tile-carpet-blackred"
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/carpet/black, /turf/open/floor/carpet/blackred, /turf/open/floor/carpet/monochrome)

/turf/open/floor/carpet/monochrome
	icon = 'icons/turf/floors/carpet_monochrome.dmi'
	floor_tile = /obj/item/stack/tile/carpet/monochrome
	icon_state = "tile-carpet-monochrome"
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/carpet/black, /turf/open/floor/carpet/blackred, /turf/open/floor/carpet/monochrome)

/turf/open/floor/carpet/blue
	icon = 'icons/turf/floors/carpet_blue.dmi'
	floor_tile = /obj/item/stack/tile/carpet/blue
	canSmoothWith = list(/turf/open/floor/carpet/blue, /turf/open/floor/carpet/blue/airless)

/turf/open/floor/carpet/cyan
	icon = 'icons/turf/floors/carpet_cyan.dmi'
	floor_tile = /obj/item/stack/tile/carpet/cyan
	canSmoothWith = list(/turf/open/floor/carpet/cyan, /turf/open/floor/carpet/cyan/airless)

/turf/open/floor/carpet/green
	icon = 'icons/turf/floors/carpet_green.dmi'
	floor_tile = /obj/item/stack/tile/carpet/green
	canSmoothWith = list(/turf/open/floor/carpet/green, /turf/open/floor/carpet/green/airless)

/turf/open/floor/carpet/orange
	icon = 'icons/turf/floors/carpet_orange.dmi'
	floor_tile = /obj/item/stack/tile/carpet/orange
	canSmoothWith = list(/turf/open/floor/carpet/orange, /turf/open/floor/carpet/orange/airless)

/turf/open/floor/carpet/purple
	icon = 'icons/turf/floors/carpet_purple.dmi'
	floor_tile = /obj/item/stack/tile/carpet/purple
	canSmoothWith = list(/turf/open/floor/carpet/purple, /turf/open/floor/carpet/purple/airless)

/turf/open/floor/carpet/red
	icon = 'icons/turf/floors/carpet_red.dmi'
	floor_tile = /obj/item/stack/tile/carpet/red
	canSmoothWith = list(/turf/open/floor/carpet/red, /turf/open/floor/carpet/red/airless)

/turf/open/floor/carpet/royalblack
	icon = 'icons/turf/floors/carpet_royalblack.dmi'
	floor_tile = /obj/item/stack/tile/carpet/royalblack
	canSmoothWith = list(/turf/open/floor/carpet/royalblack, /turf/open/floor/carpet/royalblack/airless)

/turf/open/floor/carpet/royalblue
	icon = 'icons/turf/floors/carpet_royalblue.dmi'
	floor_tile = /obj/item/stack/tile/carpet/royalblue
	canSmoothWith = list(/turf/open/floor/carpet/royalblue, /turf/open/floor/carpet/royalblue/airless)

//*****Airless versions of all of the above.*****
/turf/open/floor/carpet/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/carpet/black/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/carpet/blackred/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/carpet/monochrome/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/carpet/blue/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/carpet/cyan/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/carpet/green/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/carpet/orange/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/carpet/purple/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/carpet/red/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/carpet/royalblack/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/carpet/royalblue/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/carpet/narsie_act(force, ignore_mobs, probability = 20)
	. = (prob(probability) || force)
	for(var/I in src)
		var/atom/A = I
		if(ignore_mobs && ismob(A))
			continue
		if(ismob(A) || .)
			A.narsie_act()

/turf/open/floor/carpet/break_tile()
	broken = TRUE
	update_icon()

/turf/open/floor/carpet/burn_tile()
	burnt = TRUE
	update_icon()

/turf/open/floor/carpet/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	return FALSE


/turf/open/floor/fakepit
	desc = "A clever illusion designed to look like a bottomless pit."
	smooth = SMOOTH_TRUE | SMOOTH_BORDER | SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/fakepit)
	icon = 'icons/turf/floors/Chasms.dmi'
	icon_state = "smooth"
	tiled_dirt = FALSE

/turf/open/floor/fakepit/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/floors.dmi'
	underlay_appearance.icon_state = "basalt"
	return TRUE

/turf/open/floor/fakespace
	icon = 'icons/turf/space.dmi'
	icon_state = "0"
	floor_tile = /obj/item/stack/tile/fakespace
	broken_states = list("damaged")
	plane = PLANE_SPACE
	tiled_dirt = FALSE

/turf/open/floor/fakespace/Initialize()
	. = ..()
	icon_state = SPACE_ICON_STATE

/turf/open/floor/fakespace/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/space.dmi'
	underlay_appearance.icon_state = SPACE_ICON_STATE
	underlay_appearance.plane = PLANE_SPACE
	return TRUE
