/**********************Light************************/

//this item is intended to give the effect of entering the mine, so that light gradually fades
/obj/effect/light_emitter
	name = "Light-emtter"
	anchored = 1
	unacidable = 1
	luminosity = 8

/**********************Miner Lockers**************************/

/obj/structure/closet/wardrobe/miner
	name = "mining wardrobe"
	icon_door = "mixed"

/obj/structure/closet/wardrobe/miner/New()
	..()
	contents = list()
	new /obj/item/weapon/storage/backpack/dufflebag(src)
	new /obj/item/weapon/storage/backpack/explorer(src)
	new /obj/item/weapon/storage/backpack/satchel_explorer(src)
	new /obj/item/clothing/under/rank/miner/lavaland(src)
	new /obj/item/clothing/under/rank/miner/lavaland(src)
	new /obj/item/clothing/under/rank/miner/lavaland(src)
	new /obj/item/clothing/shoes/workboots/mining(src)
	new /obj/item/clothing/shoes/workboots/mining(src)
	new /obj/item/clothing/shoes/workboots/mining(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/gloves/color/black(src)

/obj/structure/closet/secure_closet/miner
	name = "miner's equipment"
	icon_state = "mining"
	req_access = list(access_mining)

/obj/structure/closet/secure_closet/miner/New()
	..()
	new /obj/item/stack/sheet/mineral/sandbags(src, 5)
	new /obj/item/weapon/storage/box/emptysandbags(src)
	new /obj/item/weapon/shovel(src)
	new /obj/item/weapon/pickaxe/mini(src)
	new /obj/item/device/radio/headset/headset_cargo/mining(src)
	new /obj/item/device/t_scanner/adv_mining_scanner/lesser(src)
	new /obj/item/weapon/storage/bag/ore(src)
	new /obj/item/weapon/gun/energy/kinetic_accelerator(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/weapon/survivalcapsule(src)


/**********************Shuttle Computer**************************/

/obj/machinery/computer/shuttle/mining
	name = "Mining Shuttle Console"
	desc = "Used to call and send the mining shuttle."
	circuit = /obj/item/weapon/circuitboard/computer/mining_shuttle
	shuttleId = "mining"
	possible_destinations = "mining_home;mining_away"
	no_destination_swap = 1

/*********************Pickaxe & Drills**************************/

/obj/item/weapon/pickaxe
	name = "pickaxe"
	icon = 'icons/obj/mining.dmi'
	icon_state = "pickaxe"
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 15
	throwforce = 10
	item_state = "pickaxe"
	w_class = 4
	materials = list(MAT_METAL=2000) //one sheet, but where can you make them?
	var/digspeed = 40
	var/list/digsound = list('sound/effects/picaxe1.ogg','sound/effects/picaxe2.ogg','sound/effects/picaxe3.ogg')
	origin_tech = "materials=2;engineering=3"
	attack_verb = list("hit", "pierced", "sliced", "attacked")

/obj/item/weapon/pickaxe/mini
	name = "compact pickaxe"
	desc = "A smaller, compact version of the standard pickaxe."
	icon_state = "minipick"
	force = 10
	throwforce = 7
	slot_flags = SLOT_BELT
	w_class = 3
	materials = list(MAT_METAL=1000)

/obj/item/weapon/pickaxe/proc/playDigSound()
	playsound(src, pick(digsound),50,1)

/obj/item/weapon/pickaxe/silver
	name = "silver-plated pickaxe"
	icon_state = "spickaxe"
	item_state = "spickaxe"
	digspeed = 20 //mines faster than a normal pickaxe, bought from mining vendor
	origin_tech = "materials=3;engineering=4"
	desc = "A silver-plated pickaxe that mines slightly faster than standard-issue."
	force = 17

/obj/item/weapon/pickaxe/diamond
	name = "diamond-tipped pickaxe"
	icon_state = "dpickaxe"
	item_state = "dpickaxe"
	digspeed = 14
	origin_tech = "materials=5;engineering=4"
	desc = "A pickaxe with a diamond pick head. Extremely robust at cracking rock walls and digging up dirt."
	force = 19

/obj/item/weapon/pickaxe/drill
	name = "mining drill"
	icon_state = "handdrill"
	item_state = "jackhammer"
	slot_flags = SLOT_BELT
	digspeed = 25 //available from roundstart, faster than a pickaxe.
	digsound = list('sound/weapons/drill.ogg')
	hitsound = 'sound/weapons/drill.ogg'
	origin_tech = "materials=2;powerstorage=2;engineering=3"
	desc = "An electric mining drill for the especially scrawny."

/obj/item/weapon/pickaxe/drill/cyborg
	name = "cyborg mining drill"
	desc = "An integrated electric mining drill."
	flags = NODROP

/obj/item/weapon/pickaxe/drill/diamonddrill
	name = "diamond-tipped mining drill"
	icon_state = "diamonddrill"
	digspeed = 7
	origin_tech = "materials=6;powerstorage=4;engineering=4"
	desc = "Yours is the drill that will pierce the heavens!"

/obj/item/weapon/pickaxe/drill/cyborg/diamond //This is the BORG version!
	name = "diamond-tipped cyborg mining drill" //To inherit the NODROP flag, and easier to change borg specific drill mechanics.
	icon_state = "diamonddrill"
	digspeed = 7

/obj/item/weapon/pickaxe/drill/jackhammer
	name = "sonic jackhammer"
	icon_state = "jackhammer"
	item_state = "jackhammer"
	digspeed = 5 //the epitome of powertools. extremely fast mining, laughs at puny walls
	origin_tech = "materials=6;powerstorage=4;engineering=5;magnets=4"
	digsound = list('sound/weapons/sonic_jackhammer.ogg')
	hitsound = 'sound/weapons/sonic_jackhammer.ogg'
	desc = "Cracks rocks with sonic blasts, and doubles as a demolition power tool for smashing walls."

/*****************************Shovel********************************/

/obj/item/weapon/shovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt."
	icon = 'icons/obj/mining.dmi'
	icon_state = "shovel"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 8
	var/digspeed = 20
	throwforce = 4
	item_state = "shovel"
	w_class = 3
	materials = list(MAT_METAL=50)
	origin_tech = "materials=2;engineering=2"
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	sharpness = IS_SHARP

/obj/item/weapon/shovel/spade
	name = "spade"
	desc = "A small tool for digging and moving dirt."
	icon_state = "spade"
	item_state = "spade"
	force = 5
	throwforce = 7
	w_class = 2

/obj/item/weapon/emptysandbag
	name = "empty sandbag"
	desc = "A bag to be filled with sand."
	icon = 'icons/obj/items.dmi'
	icon_state = "sandbag"
	w_class = 1

/obj/item/weapon/emptysandbag/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/weapon/ore/glass))
		user << "<span class='notice'>You fill the sandbag.</span>"
		var/obj/item/stack/sheet/mineral/sandbags/I = new /obj/item/stack/sheet/mineral/sandbags
		user.unEquip(src)
		user.put_in_hands(I)
		qdel(W)
		qdel(src)
		return
	else
		return ..()

/**********************Mining car (Crate like thing, not the rail car)**************************/

/obj/structure/closet/crate/miningcar
	desc = "A mining car. This one doesn't work on rails, but has to be dragged."
	name = "Mining car (not for rails)"
	icon_state = "miningcar"

/*****************************Survival Pod********************************/


/area/survivalpod
	name = "\improper Emergency Shelter"
	icon_state = "away"
	requires_power = 0
	has_gravity = 1

/obj/item/weapon/survivalcapsule
	name = "bluespace shelter capsule"
	desc = "An emergency shelter stored within a pocket of bluespace."
	icon_state = "capsule"
	icon = 'icons/obj/mining.dmi'
	w_class = 1
	origin_tech = "engineering=3;bluespace=3"
	var/template_id = "shelter_alpha"
	var/datum/map_template/shelter/template
	var/used = FALSE

/obj/item/weapon/survivalcapsule/proc/get_template()
	if(template)
		return
	template = shelter_templates[template_id]
	if(!template)
		throw EXCEPTION("Shelter template ([template_id]) not found!")
		qdel(src)

/obj/item/weapon/survivalcapsule/Destroy()
	template = null // without this, capsules would be one use. per round.
	. = ..()

/obj/item/weapon/survivalcapsule/examine(mob/user)
	. = ..()
	get_template()
	user << "This capsule has the [template.name] stored."
	user << template.description

/obj/item/weapon/survivalcapsule/attack_self()
	// Can't grab when capsule is New() because templates aren't loaded then
	get_template()
	if(used == FALSE)
		src.loc.visible_message("<span class='warning'>\The [src] begins \
			to shake. Stand back!</span>")
		used = TRUE
		sleep(50)
		var/turf/deploy_location = get_turf(src)
		var/status = template.check_deploy(deploy_location)
		switch(status)
			if(SHELTER_DEPLOY_BAD_AREA)
				src.loc.visible_message("<span class='warning'>\The [src] \
				will not function in this area.</span>")
			if(SHELTER_DEPLOY_BAD_TURFS, SHELTER_DEPLOY_ANCHORED_OBJECTS)
				var/width = template.width
				var/height = template.height
				src.loc.visible_message("<span class='warning'>\The [src] \
				doesn't have room to deploy! You need to clear a \
				[width]x[height] area!</span>")

		if(status != SHELTER_DEPLOY_ALLOWED)
			used = FALSE
			return

		playsound(get_turf(src), 'sound/effects/phasein.ogg', 100, 1)

		var/turf/T = deploy_location
		if(T.z != ZLEVEL_MINING && T.z != ZLEVEL_LAVALAND)//only report capsules away from the mining/lavaland level
			message_admins("[key_name_admin(usr)] (<A HREF='?_src_=holder;adminmoreinfo=\ref[usr]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[usr]'>FLW</A>) activated a bluespace capsule away from the mining level! (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>)")
			log_admin("[key_name(usr)] activated a bluespace capsule away from the mining level at [T.x], [T.y], [T.z]")
		template.load(deploy_location, centered = TRUE)
		PoolOrNew(/obj/effect/particle_effect/smoke, get_turf(src))
		qdel(src)

//Pod turfs and objects


//Floors
/turf/open/floor/pod
	name = "pod floor"
	icon_state = "podfloor"
	icon_regular_floor = "podfloor"
	floor_tile = /obj/item/stack/tile/pod

/turf/open/floor/pod/light
	icon_state = "podfloor_light"
	icon_regular_floor = "podfloor_light"
	floor_tile = /obj/item/stack/tile/pod/light

/turf/open/floor/pod/dark
	icon_state = "podfloor_dark"
	icon_regular_floor = "podfloor_dark"
	floor_tile = /obj/item/stack/tile/pod/dark

//Walls
/turf/closed/wall/shuttle/survival
	name = "pod wall"
	desc = "An easily-compressable wall used for temporary shelter."
	icon = 'icons/turf/walls/survival_pod_walls.dmi'
	icon_state = "smooth"
	walltype = "shuttle"
	smooth = SMOOTH_MORE|SMOOTH_DIAGONAL
	canSmoothWith = list(/turf/closed/wall/shuttle/survival, /obj/machinery/door/airlock/survival_pod, /obj/structure/window/shuttle/survival_pod, /obj/structure/shuttle/engine)

/turf/closed/wall/shuttle/survival/nodiagonal
	smooth = SMOOTH_MORE

/turf/closed/wall/shuttle/survival/pod
	canSmoothWith = list(/turf/closed/wall/shuttle/survival, /obj/machinery/door/airlock, /obj/structure/window/fulltile, /obj/structure/window/reinforced/fulltile, /obj/structure/window/reinforced/tinted/fulltile, /obj/structure/window/shuttle, /obj/structure/shuttle/engine)

//Window
/obj/structure/window/shuttle/survival_pod
	name = "pod window"
	icon = 'icons/obj/smooth_structures/pod_window.dmi'
	icon_state = "smooth"
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/wall/shuttle/survival, /obj/machinery/door/airlock/survival_pod, /obj/structure/window/shuttle/survival_pod)

//Door
/obj/machinery/door/airlock/survival_pod
	name = "airlock"
	icon = 'icons/obj/doors/airlocks/survival/horizontal/survival.dmi'
	overlays_file = 'icons/obj/doors/airlocks/survival/horizontal/survival_overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_pod
	opacity = 0
	glass = 1

/obj/machinery/door/airlock/survival_pod/vertical
	icon = 'icons/obj/doors/airlocks/survival/vertical/survival.dmi'
	overlays_file = 'icons/obj/doors/airlocks/survival/vertical/survival_overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_pod/vertical

/obj/structure/door_assembly/door_assembly_pod
	name = "pod airlock assembly"
	icon = 'icons/obj/doors/airlocks/survival/horizontal/survival.dmi'
	overlays_file = 'icons/obj/doors/airlocks/survival/horizontal/survival_overlays.dmi'
	airlock_type = /obj/machinery/door/airlock/survival_pod
	anchored = 1
	state = 1
	mineral = "glass"
	material = "glass"

/obj/structure/door_assembly/door_assembly_pod/vertical
	icon = 'icons/obj/doors/airlocks/survival/vertical/survival.dmi'
	overlays_file = 'icons/obj/doors/airlocks/survival/vertical/survival_overlays.dmi'
	airlock_type = /obj/machinery/door/airlock/survival_pod/vertical

//Table
/obj/structure/table/survival_pod
	icon = 'icons/obj/lavaland/survival_pod.dmi'
	icon_state = "table"
	smooth = SMOOTH_FALSE

//Sleeper
/obj/machinery/sleeper/survival_pod
	icon = 'icons/obj/lavaland/survival_pod.dmi'
	icon_state = "sleeper"

/obj/machinery/sleeper/survival_pod/update_icon()
	if(state_open)
		cut_overlays()
	else
		add_overlay("sleeper_cover")

//Computer
/obj/item/device/gps/computer
	name = "pod computer"
	icon_state = "pod_computer"
	icon = 'icons/obj/lavaland/pod_computer.dmi'
	anchored = 1
	density = 1
	pixel_y = -32

/obj/item/device/gps/computer/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/wrench) && !(flags&NODECONSTRUCT))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		user.visible_message("<span class='warning'>[user] disassembles the gps.</span>", \
						"<span class='notice'>You start to disassemble the gps...</span>", "You hear clanking and banging noises.")
		if(do_after(user, 20/W.toolspeed, target = src))
			new /obj/item/device/gps(src.loc)
			qdel(src)
			return ..()

/obj/item/device/gps/computer/attack_hand(mob/user)
	attack_self(user)

//Bed
/obj/structure/bed/pod
	icon = 'icons/obj/lavaland/survival_pod.dmi'
	icon_state = "bed"

//Survival Storage Unit
/obj/machinery/smartfridge/survival_pod
	name = "survival pod storage"
	desc = "A heated storage unit."
	icon_state = "donkvendor"
	icon = 'icons/obj/lavaland/donkvendor.dmi'
	icon_on = "donkvendor"
	icon_off = "donkvendor"
	luminosity = 8
	max_n_of_items = 10
	pixel_y = -4

/obj/machinery/smartfridge/survival_pod/empty
	name = "dusty survival pod storage"
	desc = "A heated storage unit. This one's seen better days."

/obj/machinery/smartfridge/survival_pod/empty/New()
	return()

/obj/machinery/smartfridge/survival_pod/accept_check(obj/item/O)
	if(istype(O, /obj/item))
		return 1
	return 0

/obj/machinery/smartfridge/survival_pod/New()
	..()
	for(var/i in 1 to 5)
		var/obj/item/weapon/reagent_containers/food/snacks/donkpocket/warm/W = new(src)
		load(W)
	if(prob(50))
		var/obj/item/weapon/storage/pill_bottle/dice/D = new(src)
		load(D)
	else
		var/obj/item/device/instrument/guitar/G = new(src)
		load(G)

//Fans
/obj/structure/fans
	icon = 'icons/obj/lavaland/survival_pod.dmi'
	icon_state = "fans"
	name = "environmental regulation system"
	desc = "A large machine releasing a constant gust of air."
	anchored = 1
	density = 1
	var/arbitraryatmosblockingvar = TRUE
	var/buildstacktype = /obj/item/stack/sheet/metal
	var/buildstackamount = 5

/obj/structure/fans/deconstruct()
	if(buildstacktype)
		new buildstacktype(loc,buildstackamount)
	..()

/obj/structure/fans/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/wrench) && !(flags&NODECONSTRUCT))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		user.visible_message("<span class='warning'>[user] disassembles the fan.</span>", \
						"<span class='notice'>You start to disassemble the fan...</span>", "You hear clanking and banging noises.")
		if(do_after(user, 20/W.toolspeed, target = src))
			deconstruct()
			return ..()

/obj/structure/fans/tiny
	name = "tiny fan"
	desc = "A tiny fan, releasing a thin gust of air."
	layer = ABOVE_NORMAL_TURF_LAYER
	density = 0
	icon_state = "fan_tiny"
	buildstackamount = 2

/obj/structure/fans/New(loc)
	..()
	air_update_turf(1)

/obj/structure/fans/Destroy()
	arbitraryatmosblockingvar = FALSE
	air_update_turf(1)
	return ..()

/obj/structure/fans/CanAtmosPass(turf/T)
	return !arbitraryatmosblockingvar

//Signs
/obj/structure/sign/mining
	name = "nanotrasen mining corps sign"
	desc = "A sign of relief for weary miners, and a warning for would-be competitors to Nanotrasen's mining claims."
	icon = 'icons/turf/walls/survival_pod_walls.dmi'
	icon_state = "ntpod"

/obj/structure/sign/mining/survival
	name = "shelter sign"
	desc = "A high visibility sign designating a safe shelter."
	icon = 'icons/turf/walls/survival_pod_walls.dmi'
	icon_state = "survival"

//Fluff
/obj/structure/tubes
	icon_state = "tubes"
	icon = 'icons/obj/lavaland/survival_pod.dmi'
	name = "tubes"
	anchored = 1
	layer = BELOW_MOB_LAYER
	density = 0

//////////////////////
////MOTION TRACKER////
//////////////////////

/obj/item/device/t_scanner/motiontracker
	name = "motion tracker"
	icon = 'icons/obj/mining.dmi'
	icon_state = "tracker"
	desc = "A nifty handheld motion tracker. Requires meson scanners to function properly."
	flags = CONDUCT
	slot_flags = SLOT_BELT
	var/cooldown = 35
	var/on_cooldown = 0
	var/range = 7
	var/meson = FALSE
	var/obj/item/weapon/stock_parts/cell/cell = new
	var/cellcharge
	var/cellmaxcharge
	var/soundDetect = 'sound/effects/trackFull.ogg'
	var/soundNoDetect = 'sound/effects/trackHalf.ogg'
	var/soundToggle = 'sound/effects/switch.ogg'
	var/powerReq = 10
	origin_tech = "engineering=3;magnets=4"

/obj/item/device/t_scanner/motiontracker/New()
	cellcharge = cell.charge
	cellmaxcharge = cell.maxcharge
	updateicon()

/obj/item/device/t_scanner/motiontracker/process()
	updateicon()
	if(!on || !cell)
		on = 0
		SSobj.processing.Remove(src)
		return
	if(cell.charge > powerReq)
		scan()
	cell.charge -= powerReq
	if(cell.charge < powerReq)
		playsound(get_turf(src),'sound/machines/twobeep.ogg', 15, 0 , -5)
		on = 0
		SSobj.processing.Remove(src)
		if(cell.charge <= 0)//In the event we have negative energy, somehow.
			cell.charge = 0
		updateicon()
	cellcharge = cell.charge
	cellmaxcharge = cell.maxcharge
	cell.updateicon()

/obj/item/device/t_scanner/motiontracker/attack_self(mob/user)
	add_fingerprint(usr)
	updateicon()
	if(!cell)
		user << text("<span class='warning'>[src] has no power supply.</span>")
		return
	playsound(get_turf(src), soundToggle, 100, 0, -5)
	if(cell.charge < powerReq)
		user << text("<span class='warning'>The power light on [src] flashes.</span>")
		return
	else if(cell.charge > powerReq)
		on = !on
		if(on)
			user << text("<span class='notice'>You turn on [src].</span>")
			SSobj.processing |= src
		if(!on)
			user << text("<span class='notice'>You turn off [src].</span>")

/obj/item/device/t_scanner/motiontracker/proc/updateicon()
	if(cell && cellcharge)
		if(cell && cell.charge < (cell.maxcharge/5))
			icon_state = "trackerLow"
		else if(cell && cell.charge < (cell.maxcharge/2))
			icon_state = "trackerHalf"
		else if(cell && cell.charge > (cell.maxcharge/2))
			icon_state = "trackerFull"
	if(!cellcharge || !cell || cellcharge < powerReq)
		icon_state = "trackerEmpty"
	..()
/obj/item/device/t_scanner/motiontracker/scan(mob/living/carbon/user)
	if(!on_cooldown)
		on_cooldown = 1
		spawn(cooldown)
			on_cooldown = 0
		var/turf/t = get_turf(src)
		var/list/mobs = recursive_mob_check(t, 1,0,0)
		if(!mobs.len)
			return
		motionTrackScan(mobs, range)


/obj/item/device/t_scanner/motiontracker/proc/motionTrackScan(var/list/mobs, var/range)
	var/mobsfar = 0
	for(var/turf/T in range(7, get_turf(src)) )
		for(var/mob/O in T.contents)
			var/mob/living/L = locate() in T
			if(L && (get_turf(L) != get_turf(src)) && !L.stat)
				flick_blip(O.loc)
				mobsfar = 1
	if(mobsfar)
		playsound(get_turf(src),'sound/effects/trackFull.ogg', 15, 0, -5)
	if(!mobsfar)
		playsound(get_turf(src),'sound/effects/trackHalf.ogg', 10, 0, -5)


/obj/item/device/t_scanner/motiontracker/proc/flick_blip(turf/T)
	var/image/B = image('icons/obj/mining.dmi', T, icon_state = "blip")
	B.mouse_opacity = 0
	B.layer = ABOVE_OPEN_TURF_LAYER
	var/list/nearby = list()
	for(var/mob/M in viewers(T))
		if(M.client)
			nearby |= M.client
			flick_overlay(B,nearby, 8)

/obj/item/device/t_scanner/motiontracker/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/screwdriver) && cell)
		user << text("<span class='notice'>You detach [cell] from [src].</span>")
		cell.updateicon()
		cell.loc = get_turf(src)
		cell = null
		cellcharge = 0
		cellmaxcharge = 0
		if(on)
			on = 0
		updateicon()
	if(istype(I, /obj/item/weapon/stock_parts/cell))
		if(cell)
			user << text("<span class='notice'>[src] already has a power supply installed.</span>")
		else
			if(!user.drop_item())//This is dumb. You should be able to move a held object without having to drop it.
				return
			I.loc = src
			cell = I
			user.visible_message(\
				"[user.name] has inserted the power cell into [src.name].",\
				"<span class='notice'>You install [cell.name] into [src]</span>")
			cellcharge = cell.charge
			cellmaxcharge = cell.maxcharge
			updateicon()
	else
		..()

/obj/item/device/t_scanner/motiontracker/examine(mob/user)
	..()
	if(cell)
		user << text("<span class='notice'>[src] has [cellcharge]/[cellmaxcharge] charge remaining.</span>")
	else
		user << text("<span class='notice'>[src] has no power supply installed.</span>")