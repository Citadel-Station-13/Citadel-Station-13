/turf/closed/wall/mineral/cult
	name = "runed metal wall"
	desc = "A cold metal wall engraved with indecipherable symbols. Studying them causes your head to pound."
	icon = 'icons/turf/walls/cult_wall.dmi'
	icon_state = "cult"
	builtin_sheet = null
	canSmoothWith = null

/turf/closed/wall/mineral/cult/New()
	PoolOrNew(/obj/effect/overlay/temp/cult/turf, src)
	..()

/turf/closed/wall/mineral/cult/break_wall()
	new/obj/item/stack/sheet/runed_metal(get_turf(src), 1)
	return (new /obj/structure/girder/cult(src))

/turf/closed/wall/mineral/cult/devastate_wall()
	new/obj/item/stack/sheet/runed_metal(get_turf(src), 1)

/turf/closed/wall/mineral/cult/narsie_act()
	return

/turf/closed/wall/mineral/cult/ratvar_act()
	..()
	if(istype(src, /turf/closed/wall/mineral/cult)) //if we haven't changed type
		var/previouscolor = color
		color = "#FAE48C"
		animate(src, color = previouscolor, time = 8)

/turf/closed/wall/mineral/cult/artificer
	name = "runed stone wall"
	desc = "A cold stone wall engraved with indecipherable symbols. Studying them causes your head to pound."

/turf/closed/wall/mineral/cult/artificer/break_wall()
	PoolOrNew(/obj/effect/overlay/temp/cult/turf, get_turf(src))
	return null //excuse me we want no runed metal here

/turf/closed/wall/mineral/cult/artificer/devastate_wall()
	PoolOrNew(/obj/effect/overlay/temp/cult/turf, get_turf(src))

//Clockwork wall: Causes nearby tinkerer's caches to generate components.
/turf/closed/wall/clockwork
	name = "clockwork wall"
	desc = "A huge chunk of warm metal. The clanging of machinery emanates from within."
	explosion_block = 2
	sheet_type = /obj/item/stack/sheet/brass
	var/obj/effect/clockwork/overlay/wall/realappearence
	var/obj/structure/destructible/clockwork/cache/linkedcache

/turf/closed/wall/clockwork/New()
	..()
	PoolOrNew(/obj/effect/overlay/temp/ratvar/wall, src)
	PoolOrNew(/obj/effect/overlay/temp/ratvar/beam, src)
	realappearence = PoolOrNew(/obj/effect/clockwork/overlay/wall, src)
	realappearence.linked = src
	change_construction_value(5)

/turf/closed/wall/clockwork/examine(mob/user)
	..()
	if((is_servant_of_ratvar(user) || isobserver(user)) && linkedcache)
		user << "<span class='brass'>It is linked, generating components in a cache!</span>"

/turf/closed/wall/clockwork/Destroy()
	be_removed()
	return ..()

/turf/closed/wall/clockwork/ChangeTurf(path, defer_change = FALSE)
	if(path != type)
		be_removed()
	return ..()

/turf/closed/wall/clockwork/proc/be_removed()
	if(linkedcache)
		linkedcache.linkedwall = null
		linkedcache = null
	change_construction_value(-5)
	qdel(realappearence)
	realappearence = null

/turf/closed/wall/clockwork/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = I
		if(!WT.remove_fuel(0,user))
			return 0
		playsound(src, 'sound/items/Welder.ogg', 100, 1)
		user.visible_message("<span class='notice'>[user] begins slowly breaking down [src]...</span>", "<span class='notice'>You begin painstakingly destroying [src]...</span>")
		if(!do_after(user, 120 / WT.toolspeed, target = src))
			return 0
		if(!WT.remove_fuel(1, user))
			return 0
		user.visible_message("<span class='notice'>[user] breaks apart [src]!</span>", "<span class='notice'>You break apart [src]!</span>")
		dismantle_wall()
		return 1
	return ..()

/turf/closed/wall/clockwork/ratvar_act()
	for(var/mob/M in src)
		M.ratvar_act()

/turf/closed/wall/clockwork/narsie_act()
	..()
	if(istype(src, /turf/closed/wall/clockwork)) //if we haven't changed type
		var/previouscolor = color
		color = "#960000"
		animate(src, color = previouscolor, time = 8)

/turf/closed/wall/clockwork/dismantle_wall(devastated=0, explode=0)
	if(devastated)
		devastate_wall()
		ChangeTurf(/turf/open/floor/plating)
	else
		playsound(src, 'sound/items/Welder.ogg', 100, 1)
		var/newgirder = break_wall()
		if(newgirder) //maybe we want a gear!
			transfer_fingerprints_to(newgirder)
		ChangeTurf(/turf/open/floor/clockwork)

	for(var/obj/O in src) //Eject contents!
		if(istype(O,/obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)
		else
			O.loc = src

/turf/closed/wall/clockwork/break_wall()
	new sheet_type(src)
	return new/obj/structure/destructible/clockwork/wall_gear(src)

/turf/closed/wall/clockwork/devastate_wall()
	for(var/i in 1 to 2)
		new/obj/item/clockwork/alloy_shards/large(src)
	for(var/i in 1 to 2)
		new/obj/item/clockwork/alloy_shards/medium(src)
	for(var/i in 1 to 3)
		new/obj/item/clockwork/alloy_shards/small(src)


/turf/closed/wall/vault
	icon = 'icons/turf/walls.dmi'
	icon_state = "rockvault"

/turf/closed/wall/ice
	icon = 'icons/turf/walls/icedmetal_wall.dmi'
	icon_state = "iced"
	desc = "A wall covered in a thick sheet of ice."
	canSmoothWith = null
	hardness = 35
	slicing_duration = 150 //welding through the ice+metal

/turf/closed/wall/rust
	name = "rusted wall"
	desc = "A rusted metal wall."
	icon = 'icons/turf/walls/rusty_wall.dmi'
	icon_state = "arust"
	hardness = 45

/turf/closed/wall/r_wall/rust
	name = "rusted reinforced wall"
	desc = "A huge chunk of rusted reinforced metal."
	icon = 'icons/turf/walls/rusty_reinforced_wall.dmi'
	icon_state = "rrust"
	hardness = 15

/turf/closed/wall/shuttle
	name = "wall"
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall"
	smooth = SMOOTH_FALSE

/turf/closed/wall/shuttle/syndie
	icon_state = "wall3"
	sheet_type = /obj/item/stack/sheet/mineral/plastitanium

/turf/closed/wall/shuttle/smooth
	name = "wall"
	icon = 'icons/turf/walls/shuttle_wall.dmi'
	icon_state = "shuttle"
	sheet_type = /obj/item/stack/sheet/mineral/titanium
	smooth = SMOOTH_MORE|SMOOTH_DIAGONAL
	canSmoothWith = list(/turf/closed/wall/shuttle/smooth, /obj/structure/window/shuttle, /obj/structure/shuttle, /obj/machinery/door/airlock/glass, /obj/machinery/door/airlock/shuttle)

/turf/closed/wall/shuttle/smooth/nodiagonal
	smooth = SMOOTH_MORE
	icon_state = "shuttle_nd"

/turf/closed/wall/shuttle/smooth/overspace
	icon_state = "overspace"
	fixed_underlay = list("space"=1)

//sub-type to be used for interior shuttle walls
//won't get an underlay of the destination turf on shuttle move
/turf/closed/wall/shuttle/interior/copyTurf(turf/T)
	if(T.type != type)
		T.ChangeTurf(type)
		if(underlays.len)
			T.underlays = underlays
	if(T.icon_state != icon_state)
		T.icon_state = icon_state
	if(T.icon != icon)
		T.icon = icon
	if(T.color != color)
		T.color = color
	if(T.dir != dir)
		T.setDir(dir)
	T.transform = transform
	return T

/turf/closed/wall/shuttle/copyTurf(turf/T)
	. = ..()
	T.transform = transform

