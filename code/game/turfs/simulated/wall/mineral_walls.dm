/turf/closed/wall/mineral
	name = "mineral wall"
	desc = "This shouldn't exist"
	icon_state = ""
	var/last_event = 0
	var/active = null
	canSmoothWith = null
	smoothing_flags = SMOOTH_CORNERS

/turf/closed/wall/mineral/gold
	name = "gold wall"
	desc = "A wall with gold plating. Swag!"
	icon = 'icons/turf/walls/gold_wall.dmi'
	icon_state = "gold"
	sheet_type = /obj/item/stack/sheet/mineral/gold
	explosion_block = 0 //gold is a soft metal you dingus.
	can_smooth_with = list(SMOOTH_GROUP_WALL_GOLD)
	smoothing_groups = list(SMOOTH_GROUP_WALL_GOLD, SMOOTH_GROUP_WALL)

/turf/closed/wall/mineral/silver
	name = "silver wall"
	desc = "A wall with silver plating. Shiny!"
	icon = 'icons/turf/walls/silver_wall.dmi'
	icon_state = "silver"
	sheet_type = /obj/item/stack/sheet/mineral/silver
	can_smooth_with = list(SMOOTH_GROUP_WALL_SILVER)
	smoothing_groups = list(SMOOTH_GROUP_WALL, SMOOTH_GROUP_WALL_SILVER)
/turf/closed/wall/mineral/diamond
	name = "diamond wall"
	desc = "A wall with diamond plating. You monster."
	icon = 'icons/turf/walls/diamond_wall.dmi'
	icon_state = "diamond"
	sheet_type = /obj/item/stack/sheet/mineral/diamond
	slicing_duration = 200   //diamond wall takes twice as much time to slice
	explosion_block = 3
	can_smooth_with = list(SMOOTH_GROUP_WALL_DIAMOND)
	smoothing_groups = list(SMOOTH_GROUP_WALL, SMOOTH_GROUP_WALL_DIAMOND)
/turf/closed/wall/mineral/bananium
	name = "bananium wall"
	desc = "A wall with bananium plating. Honk!"
	icon = 'icons/turf/walls/bananium_wall.dmi'
	icon_state = "bananium"
	sheet_type = /obj/item/stack/sheet/mineral/bananium
	can_smooth_with = list(SMOOTH_GROUP_WALL_BANANIUM)
	smoothing_groups = list(SMOOTH_GROUP_WALL, SMOOTH_GROUP_WALL_BANANIUM)
/turf/closed/wall/mineral/sandstone
	name = "sandstone wall"
	desc = "A wall with sandstone plating. Rough."
	icon = 'icons/turf/walls/sandstone_wall.dmi'
	icon_state = "sandstone"
	sheet_type = /obj/item/stack/sheet/mineral/sandstone
	explosion_block = 0
	can_smooth_with = list(SMOOTH_GROUP_WALL_SANDSTONE)
	smoothing_groups = list(SMOOTH_GROUP_WALL, SMOOTH_GROUP_WALL_SANDSTONE)
/turf/closed/wall/mineral/uranium
	article = "a"
	name = "uranium wall"
	desc = "A wall with uranium plating. This is probably a bad idea."
	icon = 'icons/turf/walls/uranium_wall.dmi'
	icon_state = "uranium"
	sheet_type = /obj/item/stack/sheet/mineral/uranium
	can_smooth_with = list(SMOOTH_GROUP_WALL_URANIUM)
	smoothing_groups = list(SMOOTH_GROUP_WALL, SMOOTH_GROUP_WALL_URANIUM)
/turf/closed/wall/mineral/uranium/proc/radiate()
	if(!active)
		if(world.time > last_event+15)
			active = 1
			radiation_pulse(src, 40)
			for(var/turf/closed/wall/mineral/uranium/T in orange(1,src))
				T.radiate()
			last_event = world.time
			active = null
			return
	return

/turf/closed/wall/mineral/uranium/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	radiate()
	. = ..()

/turf/closed/wall/mineral/uranium/attackby(obj/item/W, mob/user, params)
	radiate()
	..()

/turf/closed/wall/mineral/uranium/Bumped(atom/movable/AM)
	radiate()
	..()

/turf/closed/wall/mineral/plasma
	name = "plasma wall"
	desc = "A wall with plasma plating. This is definitely a bad idea."
	icon = 'icons/turf/walls/plasma_wall.dmi'
	icon_state = "plasma"
	sheet_type = /obj/item/stack/sheet/mineral/plasma
	thermal_conductivity = 0.04
	can_smooth_with = list(SMOOTH_GROUP_WALL_PLASMA)
	smoothing_groups = list(SMOOTH_GROUP_WALL, SMOOTH_GROUP_WALL_PLASMA)
/turf/closed/wall/mineral/plasma/attackby(obj/item/W, mob/user, params)
	if(W.get_temperature() > 300)//If the temperature of the object is over 300, then ignite
		message_admins("Plasma wall ignited by [ADMIN_LOOKUPFLW(user)] in [ADMIN_VERBOSEJMP(src)]")
		log_game("Plasma wall ignited by [key_name(user)] in [AREACOORD(src)]")
		ignite(W.get_temperature())
		return
	..()

/turf/closed/wall/mineral/plasma/proc/PlasmaBurn(temperature)
	new girder_type(src)
	ScrapeAway()
	var/turf/open/T = src
	T.atmos_spawn_air("plasma=400;TEMP=[temperature]")

/turf/closed/wall/mineral/plasma/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)//Doesn't fucking work because walls don't interact with air :(
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/turf/closed/wall/mineral/plasma/proc/ignite(exposed_temperature)
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/turf/closed/wall/mineral/plasma/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/beam))
		PlasmaBurn(2500)
	else if(istype(Proj, /obj/item/projectile/ion))
		PlasmaBurn(500)
	return ..()


/turf/closed/wall/mineral/wood
	name = "wooden wall"
	desc = "A wall with wooden plating. Stiff."
	icon = 'icons/turf/walls/wood_wall.dmi'
	icon_state = "wood"
	sheet_type = /obj/item/stack/sheet/mineral/wood
	hardness = 70
	explosion_block = 0
	smoothing_groups = list(SMOOTH_GROUP_WALL, SMOOTH_GROUP_WALL_WOOD)
	can_smooth_with = list(SMOOTH_GROUP_WALL_WOOD)

/turf/closed/wall/mineral/wood/attackby(obj/item/W, mob/user)
	if(W.sharpness && W.force)
		var/duration = (48/W.force) * 2 //In seconds, for now.
		if(istype(W, /obj/item/hatchet) || istype(W, /obj/item/fireaxe))
			duration /= 4 //Much better with hatchets and axes.
		var/src_type = type
		if(do_after(user, duration*10, target=src) && type == src_type) //Into deciseconds.
			dismantle_wall(FALSE,FALSE)
			return
	return ..()

/turf/closed/wall/mineral/wood/nonmetal
	desc = "A solidly wooden wall. It's a bit weaker than a wall made with metal."
	girder_type = /obj/structure/barricade/wooden
	hardness = 50

/turf/closed/wall/mineral/iron
	name = "rough metal wall"
	desc = "A wall with rough metal plating."
	icon = 'icons/turf/walls/iron_wall.dmi'
	icon_state = "iron"
	sheet_type = /obj/item/stack/rods
	can_smooth_with = list(SMOOTH_GROUP_WALL_IRON)
	smoothing_groups = list(SMOOTH_GROUP_WALL, SMOOTH_GROUP_WALL_IRON)
/turf/closed/wall/mineral/snow
	name = "packed snow wall"
	desc = "A wall made of densely packed snow blocks."
	icon = 'icons/turf/walls/snow_wall.dmi'
	icon_state = "snow"
	hardness = 80
	explosion_block = 0
	slicing_duration = 30
	sheet_type = /obj/item/stack/sheet/mineral/snow
	canSmoothWith = null
	girder_type = null
	bullet_sizzle = TRUE
	bullet_bounce_sound = null

/turf/closed/wall/mineral/abductor
	name = "alien wall"
	desc = "A wall with alien alloy plating."
	icon = 'icons/turf/walls/abductor_wall.dmi'
	icon_state = "abductor"
	smoothing_flags = SMOOTH_CORNERS | SMOOTH_DIAGONAL_CORNERS
	sheet_type = /obj/item/stack/sheet/mineral/abductor
	slicing_duration = 200   //alien wall takes twice as much time to slice
	explosion_block = 3
	can_smooth_with = list(SMOOTH_GROUP_WALL_ABDUCTOR)
	smoothing_groups = list(SMOOTH_GROUP_WALL, SMOOTH_GROUP_WALL_ABDUCTOR)
/////////////////////Titanium walls/////////////////////

/turf/closed/wall/mineral/titanium //has to use this path due to how building walls works
	name = "wall"
	desc = "A light-weight titanium wall used in shuttles."
	icon = 'icons/turf/walls/shuttle_wall.dmi'
	icon_state = "map-shuttle"
	explosion_block = 3
	flags_1 = CAN_BE_DIRTY_1 | DEFAULT_RICOCHET_1
	flags_ricochet = RICOCHET_SHINY | RICOCHET_HARD
	sheet_type = /obj/item/stack/sheet/mineral/titanium
	smoothing_flags = SMOOTH_CORNERS | SMOOTH_DIAGONAL_CORNERS
	canSmoothWith = list(/turf/closed/wall/mineral/titanium, /obj/machinery/door/airlock/shuttle, /obj/machinery/door/airlock, /obj/structure/window/shuttle, /obj/structure/shuttle/engine/heater, /obj/structure/falsewall/titanium)

/turf/closed/wall/mineral/titanium/nodiagonal
	smoothing_flags = SMOOTH_CORNERS
	icon_state = "map-shuttle_nd"

/turf/closed/wall/mineral/titanium/nosmooth
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall"
	smoothing_flags = NONE

/turf/closed/wall/mineral/titanium/overspace
	icon_state = "map-overspace"
	fixed_underlay = list("space"=1)

//sub-type to be used for interior shuttle walls
//won't get an underlay of the destination turf on shuttle move
/turf/closed/wall/mineral/titanium/interior/copyTurf(turf/T)
	if(T.type != type)
		T.ChangeTurf(type)
		if(underlays.len)
			T.underlays = underlays
	if(T.icon_state != icon_state)
		T.icon_state = icon_state
	if(T.icon != icon)
		T.icon = icon
	if(color)
		T.atom_colours = atom_colours.Copy()
		T.update_atom_colour()
	if(T.dir != dir)
		T.setDir(dir)
	T.transform = transform
	return T

/turf/closed/wall/mineral/titanium/copyTurf(turf/T)
	. = ..()
	T.transform = transform

/turf/closed/wall/mineral/titanium/survival
	name = "pod wall"
	desc = "An easily-compressable wall used for temporary shelter."
	icon = 'icons/turf/walls/survival_pod_walls.dmi'
	icon_state = "smooth"
	smoothing_flags = SMOOTH_CORNERS | SMOOTH_DIAGONAL_CORNERS
	smoothing_groups = list(SMOOTH_GROUP_SURVIVAL_POD_EXTERIOR)
	can_smooth_with = list(SMOOTH_GROUP_SURVIVAL_POD_EXTERIOR)

/turf/closed/wall/mineral/titanium/survival/nodiagonal
	smoothing_flags = SMOOTH_CORNERS

/turf/closed/wall/mineral/titanium/survival/pod

/////////////////////Plastitanium walls/////////////////////

/turf/closed/wall/mineral/plastitanium
	name = "wall"
	desc = "An evil wall of plasma and titanium."
	icon = 'icons/turf/walls/plastitanium_wall.dmi'
	icon_state = "map-shuttle"
	explosion_block = 4
	sheet_type = /obj/item/stack/sheet/mineral/plastitanium
	smoothing_flags = SMOOTH_CORNERS | SMOOTH_DIAGONAL_CORNERS
	canSmoothWith = list(/turf/closed/wall/mineral/plastitanium, /obj/machinery/door/airlock/shuttle, /obj/machinery/door/airlock, /obj/structure/window/plastitanium, /obj/structure/shuttle/engine, /obj/structure/falsewall/plastitanium)

/turf/closed/wall/mineral/plastitanium/nodiagonal
	smoothing_flags = SMOOTH_CORNERS
	icon_state = "map-shuttle_nd"

/turf/closed/wall/mineral/plastitanium/nosmooth
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall"
	smoothing_flags = NONE

/turf/closed/wall/mineral/plastitanium/overspace
	icon_state = "map-overspace"
	fixed_underlay = list("space"=1)

/turf/closed/wall/mineral/plastitanium/explosive/ex_act(severity, target, origin)
	var/datum/explosion/acted_explosion = null
	if(istype(origin, /datum/explosion))
		acted_explosion = origin
	if(acted_explosion && istype(acted_explosion.explosion_source, /obj/item/bombcore))
		var/obj/item/bombcore/large/bombcore = new(get_turf(src))
		bombcore.detonate()
	..()

//have to copypaste this code
/turf/closed/wall/mineral/plastitanium/interior/copyTurf(turf/T)
	if(T.type != type)
		T.ChangeTurf(type)
		if(underlays.len)
			T.underlays = underlays
	if(T.icon_state != icon_state)
		T.icon_state = icon_state
	if(T.icon != icon)
		T.icon = icon
	if(color)
		T.atom_colours = atom_colours.Copy()
		T.update_atom_colour()
	if(T.dir != dir)
		T.setDir(dir)
	T.transform = transform
	return T

/turf/closed/wall/mineral/plastitanium/copyTurf(turf/T)
	. = ..()
	T.transform = transform
