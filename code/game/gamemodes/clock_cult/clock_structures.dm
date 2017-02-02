//////////////////////////
// CLOCKWORK STRUCTURES //
//////////////////////////

/obj/structure/destructible/clockwork
	name = "meme structure"
	desc = "Some frog or something, the fuck?"
	var/clockwork_desc //Shown to servants when they examine
	icon = 'icons/obj/clockwork_objects.dmi'
	icon_state = "rare_pepe"
	anchored = 1
	density = 1
	var/repair_amount = 5 //how much a proselytizer can repair each cycle
	var/can_be_repaired = TRUE //if a proselytizer can repair it at all
	break_message = "<span class='warning'>The frog isn't a meme after all!</span>" //The message shown when a structure breaks
	break_sound = 'sound/magic/clockwork/anima_fragment_death.ogg' //The sound played when a structure breaks
	debris = list(/obj/item/clockwork/alloy_shards/large = 1, \
	/obj/item/clockwork/alloy_shards/medium = 2, \
	/obj/item/clockwork/alloy_shards/small = 3) //Parts left behind when a structure breaks
	var/construction_value = 0 //How much value the structure contributes to the overall "power" of the structures on the station

/obj/structure/destructible/clockwork/New()
	..()
	change_construction_value(construction_value)
	all_clockwork_objects += src

/obj/structure/destructible/clockwork/Destroy()
	change_construction_value(-construction_value)
	all_clockwork_objects -= src
	return ..()

/obj/structure/destructible/clockwork/narsie_act()
	if(take_damage(rand(25, 50), BRUTE) && src) //if we still exist
		var/previouscolor = color
		color = "#960000"
		animate(src, color = previouscolor, time = 8)

/obj/structure/destructible/clockwork/examine(mob/user)
	var/can_see_clockwork = is_servant_of_ratvar(user) || isobserver(user)
	if(can_see_clockwork && clockwork_desc)
		desc = clockwork_desc
	..()
	desc = initial(desc)
	if(takes_damage)
		var/servant_message = "It is at <b>[health]/[max_health]</b> integrity"
		var/other_message = "It seems pristine and undamaged"
		var/heavily_damaged = FALSE
		var/healthpercent = (health/max_health) * 100
		if(healthpercent >= 100)
			other_message = "It seems pristine and undamaged"
		else if(healthpercent >= 50)
			other_message = "It looks slightly dented"
		else if(healthpercent >= 25)
			other_message = "It appears heavily damaged"
			heavily_damaged = TRUE
		else if(healthpercent >= 0)
			other_message = "It's falling apart"
			heavily_damaged = TRUE
		user << "<span class='[heavily_damaged ? "alloy":"brass"]'>[can_see_clockwork ? "[servant_message]":"[other_message]"][heavily_damaged ? "!":"."]</span>"

/obj/structure/destructible/clockwork/cache //Tinkerer's cache: Stores components for later use.
	name = "tinkerer's cache"
	desc = "A large brass spire with a flaming hole in its center."
	clockwork_desc = "A brass container capable of storing a large amount of components.\n\
	Shares components with all other caches and will gradually generate components if near a Clockwork Wall."
	icon_state = "tinkerers_cache"
	construction_value = 10
	break_message = "<span class='warning'>The cache's fire winks out before it falls in on itself!</span>"
	max_health = 80
	health = 80
	var/wall_generation_cooldown
	var/turf/closed/wall/clockwork/linkedwall //if we've got a linked wall and are producing

/obj/structure/destructible/clockwork/cache/New()
	..()
	START_PROCESSING(SSobj, src)
	clockwork_caches++
	SetLuminosity(2,1)
	for(var/i in all_clockwork_mobs)
		cache_check(i)

/obj/structure/destructible/clockwork/cache/Destroy()
	clockwork_caches--
	STOP_PROCESSING(SSobj, src)
	if(linkedwall)
		linkedwall.linkedcache = null
		linkedwall = null
	for(var/i in all_clockwork_mobs)
		cache_check(i)
	return ..()

/obj/structure/destructible/clockwork/cache/destroyed()
	if(takes_damage)
		for(var/I in src)
			var/atom/movable/A = I
			A.forceMove(get_turf(src)) //drop any daemons we have
	return ..()

/obj/structure/destructible/clockwork/cache/process()
	for(var/turf/closed/wall/clockwork/C in view(4, src))
		if(!C.linkedcache && !linkedwall)
			C.linkedcache = src
			linkedwall = C
			wall_generation_cooldown = world.time + CACHE_PRODUCTION_TIME
			visible_message("<span class='warning'>[src] starts to whirr in the presence of [C]...</span>")
			break
		if(linkedwall && wall_generation_cooldown <= world.time)
			wall_generation_cooldown = world.time + CACHE_PRODUCTION_TIME
			generate_cache_component()
			playsound(C, 'sound/magic/clockwork/fellowship_armory.ogg', rand(15, 20), 1, -3, 1, 1)
			visible_message("<span class='warning'>Something clunks around inside of [src]...</span>")
			break

/obj/structure/destructible/clockwork/cache/attackby(obj/item/I, mob/living/user, params)
	if(!is_servant_of_ratvar(user))
		return ..()
	if(istype(I, /obj/item/clockwork/component))
		var/obj/item/clockwork/component/C = I
		clockwork_component_cache[C.component_id]++
		user << "<span class='notice'>You add [C] to [src].</span>"
		user.drop_item()
		qdel(C)
		return 1
	else if(istype(I, /obj/item/clockwork/slab))
		var/obj/item/clockwork/slab/S = I
		for(var/i in S.stored_components)
			clockwork_component_cache[i] += S.stored_components[i]
			S.stored_components[i] = 0
		user.visible_message("<span class='notice'>[user] empties [S] into [src].</span>", "<span class='notice'>You offload your slab's components into [src].</span>")
		return 1
	else if(istype(I, /obj/item/clockwork/daemon_shell))
		var/component_type
		switch(alert(user, "Will this daemon produce a specific type of component or produce randomly?.", , "Specific Type", "Random Component"))
			if("Specific Type")
				component_type = get_component_id(input(user, "Choose a component type.", name) as null|anything in list("Belligerent Eye", "Vanguard Cogwheel", "Guvax Capacitor", "Replicant Alloy", "Hierophant Ansible"))
				if(!component_type)
					user << "<span class='heavy_brass'>\"Indecisive, are you?\"</span>\n<span class='warning'>You decide not to place this daemon within the cache just yet.</span>"
					return 0
		if(!user || !user.canUseTopic(src) || !user.canUseTopic(I))
			return 0
		var/obj/item/clockwork/tinkerers_daemon/D = new(src)
		D.cache = src
		D.specific_component = component_type
		user.visible_message("<span class='notice'>[user] spins the cogwheel on [I] and puts it into [src].</span>", \
		"<span class='notice'>You activate the daemon and put it into [src]. It will now produce a component every twenty seconds.</span>")
		user.drop_item()
		qdel(I)
		return 1
	else
		return ..()

/obj/structure/destructible/clockwork/cache/attack_hand(mob/user)
	if(!is_servant_of_ratvar(user))
		return 0
	if(!clockwork_component_cache["replicant_alloy"])
		user << "<span class='warning'>There is no Replicant Alloy in the global component cache!</span>"
		return 0
	clockwork_component_cache["replicant_alloy"]--
	var/obj/item/clockwork/component/replicant_alloy/A = new(get_turf(src))
	user.visible_message("<span class='notice'>[user] withdraws [A] from [src].</span>", "<span class='notice'>You withdraw [A] from [src].</span>")
	user.put_in_hands(A)
	return 1

/obj/structure/destructible/clockwork/cache/examine(mob/user)
	..()
	if(is_servant_of_ratvar(user) || isobserver(user))
		if(linkedwall)
			user << "<span class='brass'>It is linked and will generate components!</span>"
		user << "<b>Stored components:</b>"
		for(var/i in clockwork_component_cache)
			user << "<span class='[get_component_span(i)]_small'><i>[get_component_name(i)]s:</i> <b>[clockwork_component_cache[i]]</b></span>"


/obj/structure/destructible/clockwork/ocular_warden //Ocular warden: Low-damage, low-range turret. Deals constant damage to whoever it makes eye contact with.
	name = "ocular warden"
	desc = "A large brass eye with tendrils trailing below it and a wide red iris."
	clockwork_desc = "A stalwart turret that will deal sustained damage to any non-faithful it sees."
	icon_state = "ocular_warden"
	health = 25
	max_health = 25
	construction_value = 15
	layer = HIGH_OBJ_LAYER
	break_message = "<span class='warning'>The warden's eye gives a glare of utter hate before falling dark!</span>"
	debris = list(/obj/item/clockwork/component/belligerent_eye/blind_eye = 1)
	burn_state = LAVA_PROOF
	var/damage_per_tick = 2.5
	var/sight_range = 3
	var/atom/movable/target
	var/list/idle_messages = list(" sulkily glares around.", " lazily drifts from side to side.", " looks around for something to burn.", " slowly turns in circles.")
	var/mech_damage_cycle = 0 //only hits every few cycles so mechs have a chance against it

/obj/structure/destructible/clockwork/ocular_warden/New()
	..()
	START_PROCESSING(SSfastprocess, src)

/obj/structure/destructible/clockwork/ocular_warden/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/structure/destructible/clockwork/ocular_warden/examine(mob/user)
	..()
	user << "<span class='brass'>[target ? "<b>It's fixated on [target]!</b>" : "Its gaze is wandering aimlessly."]</span>"

/obj/structure/destructible/clockwork/ocular_warden/process()
	var/list/validtargets = acquire_nearby_targets()
	if(ratvar_awakens && (damage_per_tick == initial(damage_per_tick) || sight_range == initial(sight_range))) //Massive buff if Ratvar has returned
		damage_per_tick = 10
		sight_range = 5
	if(target)
		if(!(target in validtargets))
			lose_target()
		else
			if(isliving(target))
				var/mob/living/L = target
				if(!L.null_rod_check())
					L.adjustFireLoss(!iscultist(L) ? damage_per_tick : damage_per_tick * 2) //Nar-Sian cultists take additional damage
					if(ratvar_awakens && L)
						L.adjust_fire_stacks(damage_per_tick)
						L.IgniteMob()
			else if(istype(target,/obj/mecha))
				if(mech_damage_cycle)
					var/obj/mecha/M = target
					M.take_directional_damage(damage_per_tick, "fire", get_dir(src, M), 0) //does about half of standard damage to mechs * whatever their fire armor is
					mech_damage_cycle--
				else
					mech_damage_cycle++
			setDir(get_dir(get_turf(src), get_turf(target)))
	if(!target)
		if(validtargets.len)
			target = pick(validtargets)
			visible_message("<span class='warning'>[src] swivels to face [target]!</span>")
			if(isliving(target))
				var/mob/living/L = target
				L << "<span class='heavy_brass'>\"I SEE YOU!\"</span>\n<span class='userdanger'>[src]'s gaze [ratvar_awakens ? "melts you alive" : "burns you"]!</span>"
			else if(istype(target,/obj/mecha))
				var/obj/mecha/M = target
				M.occupant << "<span class='heavy_brass'>\"I SEE YOU!\"</span>" //heeeellooooooo, person in mech.
		else if(prob(0.5)) //Extremely low chance because of how fast the subsystem it uses processes
			if(prob(50))
				visible_message("<span class='notice'>[src][pick(idle_messages)]</span>")
			else
				setDir(pick(cardinal))//Random rotation

/obj/structure/destructible/clockwork/ocular_warden/proc/acquire_nearby_targets()
	. = list()
	for(var/mob/living/L in viewers(sight_range, src)) //Doesn't attack the blind
		var/obj/item/weapon/storage/book/bible/B = L.bible_check()
		if(!is_servant_of_ratvar(L) && !L.stat && L.mind && !(L.disabilities & BLIND) && !L.null_rod_check() && !B)
			. += L
		else if(B)
			if(B.burn_state != ON_FIRE)
				L << "<span class='warning'>Your [B.name] bursts into flames!</span>"
			for(var/obj/item/weapon/storage/book/bible/BI in L.GetAllContents())
				if(BI.burn_state != ON_FIRE)
					BI.fire_act()
	for(var/N in mechas_list)
		var/obj/mecha/M = N
		if(get_dist(M, src) <= sight_range && M.occupant && !is_servant_of_ratvar(M.occupant) && (M in view(sight_range, src)))
			. += M

/obj/structure/destructible/clockwork/ocular_warden/proc/lose_target()
	if(!target)
		return 0
	mech_damage_cycle = 0
	target = null
	visible_message("<span class='warning'>[src] settles and seems almost disappointed.</span>")
	return 1


/obj/structure/destructible/clockwork/shell
	construction_value = 0
	anchored = 0
	density = 0
	takes_damage = FALSE
	burn_state = LAVA_PROOF
	var/mobtype = /mob/living/simple_animal/hostile/clockwork
	var/spawn_message = " is an error and you should yell at whoever spawned this shell."

/obj/structure/destructible/clockwork/shell/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/device/mmi/posibrain/soul_vessel))
		if(!is_servant_of_ratvar(user))
			..()
			return 0
		var/obj/item/device/mmi/posibrain/soul_vessel/S = I
		if(!S.brainmob)
			user << "<span class='warning'>[S] hasn't trapped a spirit! Turn it on first.</span>"
			return 0
		if(S.brainmob && (!S.brainmob.client || !S.brainmob.mind))
			user << "<span class='warning'>[S]'s trapped spirit appears inactive!</span>"
			return 0
		user.visible_message("<span class='notice'>[user] places [S] in [src], where it fuses to the shell.</span>", "<span class='brass'>You place [S] in [src], fusing it to the shell.</span>")
		var/mob/living/simple_animal/A = new mobtype(get_turf(src))
		A.visible_message("<span class='brass'>[src][spawn_message]</span>")
		remove_servant_of_ratvar(S.brainmob, TRUE)
		S.brainmob.mind.transfer_to(A)
		add_servant_of_ratvar(A, TRUE)
		user.drop_item()
		qdel(S)
		qdel(src)
		return 1
	else
		return ..()

/obj/structure/destructible/clockwork/shell/cogscarab
	name = "cogscarab shell"
	desc = "A small brass shell with a cube-shaped receptable in its center. It gives off an aura of obsessive perfectionism."
	clockwork_desc = "A dormant receptable that, when powered with a soul vessel, will become a weak construct with an inbuilt proselytizer."
	icon_state = "clockdrone_shell"
	mobtype = /mob/living/simple_animal/drone/cogscarab
	spawn_message = "'s eyes blink open, glowing bright red."

/obj/structure/destructible/clockwork/shell/fragment //Anima fragment: Useless on its own, but can accept an active soul vessel to create a powerful construct.
	name = "fragment shell"
	desc = "A massive brass shell with a small cube-shaped receptable in its center. It gives off an aura of contained power."
	clockwork_desc = "A dormant receptable that, when powered with a soul vessel, will become a powerful construct."
	icon_state = "anime_fragment"
	mobtype = /mob/living/simple_animal/hostile/clockwork/fragment
	spawn_message = " whirs and rises from the ground on a flickering jet of reddish fire."


/obj/structure/destructible/clockwork/wall_gear
	name = "massive gear"
	icon_state = "wall_gear"
	climbable = TRUE
	max_health = 50
	health = 50
	desc = "A massive brass gear. You could probably secure or unsecure it with a wrench, or just climb over it."
	clockwork_desc = "A massive brass gear. You could probably secure or unsecure it with a wrench, just climb over it, or proselytize it into replicant alloy."
	break_message = "<span class='warning'>The gear breaks apart into shards of alloy!</span>"
	debris = list(/obj/item/clockwork/alloy_shards/large = 1, \
	/obj/item/clockwork/alloy_shards/medium = 4, \
	/obj/item/clockwork/alloy_shards/small = 2) //slightly more debris than the default, totals 26 alloy

/obj/structure/destructible/clockwork/wall_gear/displaced
	anchored = FALSE

/obj/structure/destructible/clockwork/wall_gear/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/wrench))
		default_unfasten_wrench(user, I, 10)
		return 1
	else if(istype(I, /obj/item/stack/sheet/brass))
		var/obj/item/stack/sheet/brass/W = I
		if(W.get_amount() < 1)
			user << "<span class='warning'>You need one brass sheet to do this!</span>"
			return
		var/turf/T = get_turf(src)
		if(istype(T, /turf/closed/wall))
			user << "<span class='warning'>There is already a wall present!</span>"
			return
		if(!istype(T, /turf/open/floor))
			user << "<span class='warning'>A floor must be present to build a [anchored ? "false ":""]wall!</span>"
			return
		if(locate(/obj/structure/falsewall) in T.contents)
			user << "<span class='warning'>There is already a false wall present!</span>"
			return
		user << "<span class='notice'>You start adding [W] to [src]...</span>"
		if(do_after(user, 20, target = src))
			var/brass_floor = FALSE
			if(istype(T, /turf/open/floor/clockwork)) //if the floor is already brass, costs less to make(conservation of masssssss)
				brass_floor = TRUE
			if(W.use(2 - brass_floor))
				if(anchored)
					T.ChangeTurf(/turf/closed/wall/clockwork)
				else
					T.ChangeTurf(/turf/open/floor/clockwork)
					new /obj/structure/falsewall/brass(T)
				qdel(src)
			else
				user << "<span class='warning'>You need more brass to make a [anchored ? "false ":""]wall!</span>"
		return 1
	return ..()

/obj/structure/destructible/clockwork/wall_gear/examine(mob/user)
	..()
	user << "<span class='notice'>[src] is [anchored ? "":"not "]secured to the floor.</span>"

///////////////////////
// CLOCKWORK EFFECTS //
///////////////////////

/obj/effect/clockwork
	name = "meme machine"
	desc = "Still don't know what it is."
	var/clockwork_desc = "A fabled artifact from beyond the stars. Contains concentrated meme essence." //Shown to clockwork cultists instead of the normal description
	icon = 'icons/effects/clockwork_effects.dmi'
	icon_state = "ratvars_flame"
	anchored = 1
	density = 0
	opacity = 0
	burn_state = LAVA_PROOF

/obj/effect/clockwork/New()
	..()
	all_clockwork_objects += src

/obj/effect/clockwork/Destroy()
	all_clockwork_objects -= src
	return ..()

/obj/effect/clockwork/examine(mob/user)
	if((is_servant_of_ratvar(user) || isobserver(user)) && clockwork_desc)
		desc = clockwork_desc
	..()
	desc = initial(desc)

/obj/effect/clockwork/judicial_marker //Judicial marker: Created by the judicial visor. After three seconds, stuns any non-servants nearby and damages Nar-Sian cultists.
	name = "judicial marker"
	desc = "You get the feeling that you shouldn't be standing here."
	clockwork_desc = "A sigil that will soon erupt and smite any unenlightened nearby."
	icon = 'icons/effects/96x96.dmi'
	pixel_x = -32
	pixel_y = -32
	layer = BELOW_MOB_LAYER
	var/mob/user

/obj/effect/clockwork/judicial_marker/New(loc, caster)
	..()
	user = caster
	playsound(src, 'sound/magic/MAGIC_MISSILE.ogg', 50, 1, 1, 1)
	flick("judicial_marker", src)
	addtimer(src, "burstanim", 16, FALSE)

/obj/effect/clockwork/judicial_marker/proc/burstanim()
	layer = ABOVE_ALL_MOB_LAYER
	flick("judicial_explosion", src)
	addtimer(src, "judicialblast", 13, FALSE)

/obj/effect/clockwork/judicial_marker/proc/judicialblast()
	var/targetsjudged = 0
	playsound(src, 'sound/effects/explosionfar.ogg', 100, 1, 1, 1)
	for(var/mob/living/L in range(1, src))
		if(is_servant_of_ratvar(L))
			continue
		if(L.null_rod_check())
			var/obj/item/I = L.null_rod_check()
			L.visible_message("<span class='warning'>Strange energy flows into [L]'s [I.name]!</span>", \
			"<span class='userdanger'>Your [I.name] shields you from [src]!</span>")
			continue
		if(!iscultist(L))
			L.visible_message("<span class='warning'>[L] is struck by a judicial explosion!</span>", \
			"<span class='userdanger'>[!issilicon(L) ? "An unseen force slams you into the ground!" : "ERROR: Motor servos disabled by external source!"]</span>")
			L.Weaken(8)
		else
			L.visible_message("<span class='warning'>[L] is struck by a judicial explosion!</span>", \
			"<span class='heavy_brass'>\"Keep an eye out, filth.\"</span>\n<span class='userdanger'>A burst of heat crushes you against the ground!</span>")
			L.Weaken(4) //half the stun, but sets cultists on fire
			L.adjust_fire_stacks(2)
			L.IgniteMob()
		if(iscarbon(L))
			var/mob/living/carbon/C = L
			C.silent += 6
		targetsjudged++
		L.adjustBruteLoss(10)
		add_logs(user, L, "struck with a judicial blast")
	user << "<span class='brass'><b>[targetsjudged ? "Successfully judged <span class='neovgre'>[targetsjudged]</span>":"Judged no"] heretic[!targetsjudged || targetsjudged > 1 ? "s":""].</b></span>"
	QDEL_IN(src, 3) //so the animation completes properly

/obj/effect/clockwork/judicial_marker/ex_act(severity)
	return

/obj/effect/clockwork/spatial_gateway //Spatial gateway: A usually one-way rift to another location.
	name = "spatial gateway"
	desc = "A gently thrumming tear in reality."
	clockwork_desc = "A gateway in reality."
	icon_state = "spatial_gateway"
	density = 1
	var/sender = TRUE //If this gateway is made for sending, not receiving
	var/both_ways = FALSE
	var/lifetime = 25 //How many deciseconds this portal will last
	var/uses = 1 //How many objects or mobs can go through the portal
	var/obj/effect/clockwork/spatial_gateway/linked_gateway //The gateway linked to this one

/obj/effect/clockwork/spatial_gateway/New()
	..()
	spawn(1)
		if(!linked_gateway)
			qdel(src)
			return 0
		if(both_ways)
			clockwork_desc = "A gateway in reality. It can both send and receive objects."
		else
			clockwork_desc = "A gateway in reality. It can only [sender ? "send" : "receive"] objects."
		QDEL_IN(src, lifetime)

//set up a gateway with another gateway
/obj/effect/clockwork/spatial_gateway/proc/setup_gateway(obj/effect/clockwork/spatial_gateway/gatewayB, set_duration, set_uses, two_way)
	if(!gatewayB || !set_duration || !uses)
		return 0
	linked_gateway = gatewayB
	gatewayB.linked_gateway = src
	if(two_way)
		both_ways = TRUE
		gatewayB.both_ways = TRUE
	else
		sender = TRUE
		gatewayB.sender = FALSE
		gatewayB.density = FALSE
	lifetime = set_duration
	gatewayB.lifetime = set_duration
	uses = set_uses
	gatewayB.uses = set_uses
	return 1

/obj/effect/clockwork/spatial_gateway/examine(mob/user)
	..()
	if(is_servant_of_ratvar(user) || isobserver(user))
		user << "<span class='brass'>It has [uses] uses remaining.</span>"

/obj/effect/clockwork/spatial_gateway/attack_ghost(mob/user)
	if(linked_gateway)
		user.forceMove(get_turf(linked_gateway))
	..()

/obj/effect/clockwork/spatial_gateway/attack_hand(mob/living/user)
	if(!uses)
		return 0
	if(user.pulling && user.a_intent == "grab" && isliving(user.pulling))
		var/mob/living/L = user.pulling
		if(L.buckled || L.anchored || L.has_buckled_mobs())
			return 0
		user.visible_message("<span class='warning'>[user] shoves [L] into [src]!</span>", "<span class='danger'>You shove [L] into [src]!</span>")
		user.stop_pulling()
		pass_through_gateway(L)
		return 1
	if(!user.canUseTopic(src))
		return 0
	user.visible_message("<span class='warning'>[user] climbs through [src]!</span>", "<span class='danger'>You brace yourself and step through [src]...</span>")
	pass_through_gateway(user)
	return 1

/obj/effect/clockwork/spatial_gateway/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/weapon/nullrod))
		user.visible_message("<span class='warning'>[user] dispels [src] with [I]!</span>", "<span class='danger'>You close [src] with [I]!</span>")
		qdel(linked_gateway)
		qdel(src)
		return 1
	if(istype(I, /obj/item/clockwork/slab))
		user << "<span class='heavy_brass'>\"I don't think you want to drop your slab into that\".\n\"If you really want to, try throwing it.\"</span>"
		return 1
	if(user.drop_item() && uses)
		user.visible_message("<span class='warning'>[user] drops [I] into [src]!</span>", "<span class='danger'>You drop [I] into [src]!</span>")
		pass_through_gateway(I)
	..()

/obj/effect/clockwork/spatial_gateway/ex_act(severity)
	if(severity == 1 && uses)
		uses = 0
		visible_message("<span class='warning'>[src] is disrupted!</span>")
		animate(src, alpha = 0, transform = matrix()*2, time = 10)
		QDEL_IN(src, 10)
		linked_gateway.uses = 0
		linked_gateway.visible_message("<span class='warning'>[linked_gateway] is disrupted!</span>")
		animate(linked_gateway, alpha = 0, transform = matrix()*2, time = 10)
		QDEL_IN(linked_gateway, 10)
		return TRUE
	return FALSE

/obj/effect/clockwork/spatial_gateway/Bumped(atom/A)
	..()
	if(isliving(A) || istype(A, /obj/item))
		pass_through_gateway(A)

/obj/effect/clockwork/spatial_gateway/proc/pass_through_gateway(atom/movable/A)
	if(!linked_gateway)
		qdel(src)
		return 0
	if(!sender)
		visible_message("<span class='warning'>[A] bounces off of [src]!</span>")
		return 0
	if(!uses)
		return 0
	if(isliving(A))
		var/mob/living/user = A
		user << "<span class='warning'><b>You pass through [src] and appear elsewhere!</b></span>"
	linked_gateway.visible_message("<span class='warning'>A shape appears in [linked_gateway] before emerging!</span>")
	playsound(src, 'sound/effects/EMPulse.ogg', 50, 1)
	playsound(linked_gateway, 'sound/effects/EMPulse.ogg', 50, 1)
	transform = matrix() * 1.5
	animate(src, transform = matrix() / 1.5, time = 10)
	linked_gateway.transform = matrix() * 1.5
	animate(linked_gateway, transform = matrix() / 1.5, time = 10)
	A.forceMove(get_turf(linked_gateway))
	uses = max(0, uses - 1)
	linked_gateway.uses = max(0, linked_gateway.uses - 1)
	spawn(10)
		if(!uses)
			qdel(src)
			qdel(linked_gateway)
	return 1

/obj/effect/clockwork/overlay
	mouse_opacity = 0
	var/atom/linked

/obj/effect/clockwork/overlay/examine(mob/user)
	if(linked)
		linked.examine(user)

/obj/effect/clockwork/overlay/ex_act()
	return FALSE

/obj/effect/clockwork/overlay/singularity_pull(S, current_size)
	return

/obj/effect/clockwork/overlay/Destroy()
	if(linked)
		linked = null
	..()
	return QDEL_HINT_PUTINPOOL

/obj/effect/clockwork/overlay/wall
	name = "clockwork wall"
	icon = 'icons/turf/walls/clockwork_wall.dmi'
	icon_state = "clockwork_wall"
	canSmoothWith = list(/obj/effect/clockwork/overlay/wall, /obj/structure/falsewall/brass)
	smooth = SMOOTH_TRUE
	layer = CLOSED_TURF_LAYER

/obj/effect/clockwork/overlay/wall/New()
	..()
	queue_smooth_neighbors(src)
	addtimer(GLOBAL_PROC, "queue_smooth", 1, FALSE, src)

/obj/effect/clockwork/overlay/wall/Destroy()
	queue_smooth_neighbors(src)
	..()
	return QDEL_HINT_QUEUE

/obj/effect/clockwork/overlay/floor
	icon = 'icons/turf/floors.dmi'
	icon_state = "clockwork_floor"
	layer = TURF_LAYER

/obj/effect/clockwork/general_marker
	name = "general marker"
	desc = "Some big guy. For you."
	clockwork_desc = "One of Ratvar's generals."
	alpha = 200
	layer = MASSIVE_OBJ_LAYER

/obj/effect/clockwork/general_marker/New()
	..()
	animate(src, alpha = 0, time = 10)
	QDEL_IN(src, 10)

/obj/effect/clockwork/general_marker/ex_act()
	return FALSE

/obj/effect/clockwork/general_marker/nezbere
	name = "Nezbere, the Brass Eidolon"
	desc = "A towering colossus clad in nigh-impenetrable brass armor. Its gaze is stern yet benevolent, even upon you."
	clockwork_desc = "One of Ratvar's four generals. Nezbere is responsible for the design, testing, and creation of everything in Ratvar's domain."
	icon = 'icons/effects/340x428.dmi'
	icon_state = "nezbere"
	pixel_x = -154
	pixel_y = -198

/obj/effect/clockwork/general_marker/sevtug
	name = "Sevtug, the Formless Pariah"
	desc = "A sinister cloud of purple energy. Looking at it gives you a headache."
	clockwork_desc = "One of Ratvar's four generals. Sevtug taught him how to manipulate minds and is one of his oldest allies."
	icon = 'icons/effects/211x247.dmi'
	icon_state = "sevtug"
	pixel_x = -89
	pixel_y = -107

/obj/effect/clockwork/general_marker/nzcrentr
	name = "Nzcrentr, the Eternal Thunderbolt"
	desc = "A terrifying spiked construct crackling with limitless energy."
	clockwork_desc = "One of Ratvar's four generals. Before becoming one of Ratvar's generals, Nzcrentr sook out any and all sentient life to slaughter it for sport. \
	Nzcrentr was coerced by Ratvar into entering a shell constructed by Nezbere, ostensibly made to grant Nzcrentr more power. In reality, the shell was made to trap and control it. \
	Nzcrentr now serves loyally, though even one of Nezbere's finest creations was not enough to totally eliminate its will."
	icon = 'icons/effects/254x361.dmi'
	icon_state = "nzcrentr"
	pixel_x = -111
	pixel_y = -164

/obj/effect/clockwork/general_marker/inathneq
	name = "Inath-neq, the Resonant Cogwheel"
	desc = "A humanoid form blazing with blue fire. It radiates an aura of kindness and caring."
	clockwork_desc = "One of Ratvar's four generals. Before her current form, Inath-neq was a powerful warrior priestess commanding the Resonant Cogs, a sect of Ratvarian warriors renowned for \
	their prowess. After a lost battle with Nar-Sian cultists, Inath-neq was struck down and stated in her dying breath, \
	\"The Resonant Cogs shall not fall silent this day, but will come together to form a wheel that shall never stop turning.\" Ratvar, touched by this, granted Inath-neq an eternal body and \
	merged her soul with those of the Cogs slain with her on the battlefield."
	icon = 'icons/effects/187x381.dmi'
	icon_state = "inath-neq"
	pixel_x = -77
	pixel_y = -174


/obj/effect/clockwork/sigil //Sigils: Rune-like markings on the ground with various effects.
	name = "sigil"
	desc = "A strange set of markings drawn on the ground."
	clockwork_desc = "A sigil of some purpose."
	icon_state = "sigil"
	layer = LOW_OBJ_LAYER
	alpha = 50
	burn_state = FIRE_PROOF
	burntime = 1
	var/affects_servants = FALSE
	var/stat_affected = CONSCIOUS
	var/resist_string = "glows blinding white" //string for when a null rod blocks its effects, "glows [resist_string]"

/obj/effect/clockwork/sigil/attackby(obj/item/I, mob/living/user, params)
	if(I.force && !is_servant_of_ratvar(user))
		user.visible_message("<span class='warning'>[user] scatters [src] with [I]!</span>", "<span class='danger'>You scatter [src] with [I]!</span>")
		qdel(src)
		return 1
	..()

/obj/effect/clockwork/sigil/attack_hand(mob/user)
	if(iscarbon(user) && !user.stat && (!is_servant_of_ratvar(user) || (is_servant_of_ratvar(user) && user.a_intent == "harm")))
		user.visible_message("<span class='warning'>[user] stamps out [src]!</span>", "<span class='danger'>You stomp on [src], scattering it into thousands of particles.</span>")
		qdel(src)
		return 1
	..()

/obj/effect/clockwork/sigil/ex_act(severity)
	visible_message("<span class='warning'>[src] scatters into thousands of particles.</span>")
	qdel(src)

/obj/effect/clockwork/sigil/Crossed(atom/movable/AM)
	..()
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.stat <= stat_affected)
			if((!is_servant_of_ratvar(L) || (is_servant_of_ratvar(L) && affects_servants)) && L.mind)
				if(L.null_rod_check())
					var/obj/item/I = L.null_rod_check()
					L.visible_message("<span class='warning'>[L]'s [I.name] [resist_string], protecting them from [src]'s effects!</span>", \
					"<span class='userdanger'>Your [I.name] [resist_string], protecting you!</span>")
					return
				sigil_effects(L)
			return 1

/obj/effect/clockwork/sigil/proc/sigil_effects(mob/living/L)

/obj/effect/clockwork/sigil/transgression //Sigil of Transgression: Stuns and flashes the first non-servant to walk on it. Nar-Sian cultists are damaged and knocked down for a longer stun
	name = "dull sigil"
	desc = "A dull, barely-visible golden sigil. It's as though light was carved into the ground."
	icon = 'icons/effects/clockwork_effects.dmi'
	clockwork_desc = "A sigil that will stun the first non-servant to cross it. Nar-Sie's dogs will be knocked down."
	icon_state = "sigildull"
	color = "#FAE48C"

/obj/effect/clockwork/sigil/transgression/sigil_effects(mob/living/L)
	var/target_flashed = L.flash_act()
	for(var/mob/living/M in viewers(5, src))
		if(!is_servant_of_ratvar(M) && M != L)
			M.flash_act()
	if(iscultist(L))
		L << "<span class='heavy_brass'>\"Watch your step, wretch.\"</span>"
		L.adjustBruteLoss(10)
		L.Weaken(7)
	L.visible_message("<span class='warning'>[src] appears around [L] in a burst of light!</span>", \
	"<span class='userdanger'>[target_flashed ? "An unseen force":"The glowing sigil around you"] holds you in place!</span>")
	L.Stun(5)
	PoolOrNew(/obj/effect/overlay/temp/ratvar/sigil/transgression, get_turf(src))
	qdel(src)
	return 1

/obj/effect/clockwork/sigil/submission //Sigil of Submission: After a short time, converts any non-servant standing on it. Knocks down and silences them for five seconds afterwards.
	name = "ominous sigil"
	desc = "A luminous golden sigil. Something about it really bothers you."
	clockwork_desc = "A sigil that will enslave the first person to cross it, provided they remain on it for seven seconds."
	icon_state = "sigilsubmission"
	color = "#FAE48C"
	alpha = 125
	stat_affected = UNCONSCIOUS
	resist_string = "glows faintly yellow"
	var/convert_time = 70
	var/glow_light = 2 //soft light
	var/glow_falloff = 1
	var/delete_on_finish = TRUE
	var/sigil_name = "Sigil of Submission"
	var/glow_type

/obj/effect/clockwork/sigil/submission/New()
	..()
	SetLuminosity(glow_light,glow_falloff)

/obj/effect/clockwork/sigil/submission/proc/post_channel(mob/living/L)

/obj/effect/clockwork/sigil/submission/sigil_effects(mob/living/L)
	L.visible_message("<span class='warning'>[src] begins to glow a piercing magenta!</span>", "<span class='sevtug'>You feel something start to invade your mind...</span>")
	animate(src, color = "#AF0AAF", time = convert_time)
	var/obj/effect/overlay/temp/ratvar/sigil/glow
	if(glow_type)
		glow = PoolOrNew(glow_type, get_turf(src))
		animate(glow, alpha = 255, time = convert_time)
	var/I = 0
	while(I < convert_time && get_turf(L) == get_turf(src))
		I++
		sleep(1)
	if(get_turf(L) != get_turf(src))
		if(glow)
			qdel(glow)
		animate(src, color = initial(color), time = 20)
		visible_message("<span class='warning'>[src] slowly stops glowing!</span>")
		return 0
	post_channel(L)
	if(is_eligible_servant(L))
		L << "<span class='heavy_brass'>\"You belong to me now.\"</span>"
	add_servant_of_ratvar(L)
	L.Weaken(3) //Completely defenseless for about five seconds - mainly to give them time to read over the information they've just been presented with
	L.Stun(3)
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		C.silent += 5
	var/message = "[sigil_name] in [get_area(src)] <span class='sevtug'>[is_servant_of_ratvar(L) ? "successfully converted" : "failed to convert"]</span>"
	for(var/M in mob_list)
		if(isobserver(M))
			var/link = FOLLOW_LINK(M, L)
			M <<  "[link] <span class='heavy_brass'>[message] [L.real_name]!</span>"
		else if(is_servant_of_ratvar(M))
			if(M == L)
				M << "<span class='heavy_brass'>[message] you!</span>"
			else
				M << "<span class='heavy_brass'>[message] [L.real_name]!</span>"
	if(delete_on_finish)
		qdel(src)
	else
		animate(src, color = initial(color), time = 20)
		visible_message("<span class='warning'>[src] slowly stops glowing!</span>")
	return 1

/obj/effect/clockwork/sigil/submission/accession //Sigil of Accession: After a short time, converts any non-servant standing on it though implants. Knocks down and silences them for five seconds afterwards.
	name = "terrifying sigil"
	desc = "A luminous brassy sigil. Something about it makes you want to flee."
	clockwork_desc = "A sigil that will enslave any person who crosses it, provided they remain on it for seven seconds. \n\
	It can convert a mindshielded target once before disppearing, but can convert any number of non-implanted targets."
	icon_state = "sigiltransgression"
	color = "#A97F1B"
	alpha = 200
	glow_light = 4 //bright light
	glow_falloff = 3
	delete_on_finish = FALSE
	sigil_name = "Sigil of Accession"
	glow_type = /obj/effect/overlay/temp/ratvar/sigil/accession
	resist_string = "glows bright orange"

/obj/effect/clockwork/sigil/submission/accession/post_channel(mob/living/L)
	if(isloyal(L))
		delete_on_finish = TRUE
		L.visible_message("<span class='warning'>[L] visibly trembles!</span>", \
		"<span class='sevtug'>[text2ratvar("You will be mine and his. This puny trinket will not stop me.")]</span>")
		for(var/obj/item/weapon/implant/mindshield/M in L)
			if(M.implanted)
				qdel(M)

/obj/effect/clockwork/sigil/transmission
	name = "suspicious sigil"
	desc = "A glowing orange sigil. The air around it feels staticky."
	clockwork_desc = "A sigil that will serve as a battery for clockwork structures. Use Volt Void while standing on it to charge it."
	icon_state = "sigiltransmission"
	color = "#EC8A2D"
	alpha = 50
	resist_string = "glows faintly"
	var/power_charge = 2500 //starts with 2500W by default

/obj/effect/clockwork/sigil/transmission/ex_act(severity)
	if(severity == 3)
		modify_charge(-500)
		visible_message("<span class='warning'>[src] flares a brilliant orange!</span>")
	else
		..()

/obj/effect/clockwork/sigil/transmission/examine(mob/user)
	..()
	if(is_servant_of_ratvar(user) || isobserver(user))
		user << "<span class='[power_charge ? "brass":"alloy"]'>It is storing <b>[power_charge]W</b> of power.</span>"

/obj/effect/clockwork/sigil/transmission/sigil_effects(mob/living/L)
	if(power_charge)
		L << "<span class='brass'>You feel a slight, static shock.</span>"
	return 1

/obj/effect/clockwork/sigil/transmission/New()
	..()
	alpha = min(initial(alpha) + power_charge*0.02, 255)

/obj/effect/clockwork/sigil/transmission/proc/modify_charge(amount)
	if(power_charge - amount < 0)
		return 0
	power_charge -= amount
	alpha = min(initial(alpha) + power_charge*0.02, 255)
	return 1

/obj/effect/clockwork/sigil/vitality
	name = "comforting sigil"
	desc = "A faint blue sigil. Looking at it makes you feel protected."
	clockwork_desc = "A sigil that will drain non-servants that remain on it. Servants that remain on it will be healed if it has any vitality drained."
	icon_state = "sigilvitality"
	color = "#123456"
	alpha = 75
	affects_servants = TRUE
	stat_affected = DEAD
	resist_string = "glows shimmering yellow"
	var/vitality = 0
	var/base_revive_cost = 20
	var/sigil_active = FALSE
	var/animation_number = 3 //each cycle increments this by 1, at 4 it produces an animation and resets

/obj/effect/clockwork/sigil/vitality/examine(mob/user)
	..()
	if(is_servant_of_ratvar(user) || isobserver(user))
		user << "<span class='[vitality ? "inathneq_small":"alloy"]'>It is storing <b>[ratvar_awakens ? "INFINITE":"[vitality]"]</b> units of vitality.</span>"
		user << "<span class='inathneq_small'>It requires at least <b>[base_revive_cost]</b> units of vitality to revive dead servants, in addition to any damage the servant has.</span>"

/obj/effect/clockwork/sigil/vitality/sigil_effects(mob/living/L)
	if((is_servant_of_ratvar(L) && L.suiciding) || sigil_active)
		return 0
	visible_message("<span class='warning'>[src] begins to glow bright blue!</span>")
	animate(src, alpha = 255, time = 10)
	sleep(10)
	sigil_active = TRUE
//as long as they're still on the sigil and are either not a servant or they're a servant AND it has remaining vitality
	while(L && (!is_servant_of_ratvar(L) || (is_servant_of_ratvar(L) && vitality)) && get_turf(L) == get_turf(src))
		if(animation_number >= 4)
			PoolOrNew(/obj/effect/overlay/temp/ratvar/sigil/vitality, get_turf(src))
			animation_number = 0
		animation_number++
		if(!is_servant_of_ratvar(L))
			var/vitality_drained = 0
			if(L.stat == DEAD)
				vitality_drained = L.maxHealth
				var/obj/effect/overlay/temp/ratvar/sigil/vitality/V = PoolOrNew(/obj/effect/overlay/temp/ratvar/sigil/vitality, get_turf(src))
				animate(V, alpha = 0, transform = matrix()*2, time = 8)
				playsound(L, 'sound/magic/WandODeath.ogg', 50, 1)
				L.visible_message("<span class='warning'>[L] collapses in on themself as [src] flares bright blue!</span>")
				L << "<span class='inathneq_large'>\"[text2ratvar("Your life will not be wasted.")]\"</span>"
				for(var/obj/item/W in L)
					L.unEquip(W)
				L.dust()
			else
				vitality_drained = L.adjustToxLoss(1.5)
			if(vitality_drained)
				vitality += vitality_drained
			else
				break
		else
			var/clone_to_heal = L.getCloneLoss()
			var/tox_to_heal = L.getToxLoss()
			var/burn_to_heal = L.getFireLoss()
			var/brute_to_heal = L.getBruteLoss()
			var/oxy_to_heal = L.getOxyLoss()
			var/total_damage = clone_to_heal + tox_to_heal + burn_to_heal + brute_to_heal + oxy_to_heal
			if(L.stat == DEAD)
				var/revival_cost = base_revive_cost + total_damage - oxy_to_heal //ignores oxygen damage
				if(ratvar_awakens)
					revival_cost = 0
				var/mob/dead/observer/ghost = L.get_ghost(TRUE)
				if(ghost)
					if(vitality >= revival_cost)
						ghost.reenter_corpse()
						L.revive(1, 1)
						playsound(L, 'sound/magic/Staff_Healing.ogg', 50, 1)
						L.visible_message("<span class='warning'>[L] suddenly gets back up, their mouth dripping blue ichor!</span>", \
						"<span class='inathneq'>\"[text2ratvar("You will be okay, child.")]\"</span>")
						vitality -= revival_cost
						break
				else
					break
			if(!total_damage)
				break
			var/vitality_for_cycle = min(vitality, 3)
			var/vitality_used = 0
			if(ratvar_awakens)
				vitality_for_cycle = 3

			if(clone_to_heal && vitality_for_cycle)
				var/healing = min(vitality_for_cycle, clone_to_heal)
				vitality_for_cycle -= healing
				L.adjustCloneLoss(-healing)
				vitality_used += healing

			if(tox_to_heal && vitality_for_cycle)
				var/healing = min(vitality_for_cycle, tox_to_heal)
				vitality_for_cycle -= healing
				L.adjustToxLoss(-healing)
				vitality_used += healing

			if(burn_to_heal && vitality_for_cycle)
				var/healing = min(vitality_for_cycle, burn_to_heal)
				vitality_for_cycle -= healing
				L.adjustFireLoss(-healing)
				vitality_used += healing

			if(brute_to_heal && vitality_for_cycle)
				var/healing = min(vitality_for_cycle, brute_to_heal)
				vitality_for_cycle -= healing
				L.adjustBruteLoss(-healing)
				vitality_used += healing

			if(oxy_to_heal && vitality_for_cycle)
				var/healing = min(vitality_for_cycle, oxy_to_heal)
				vitality_for_cycle -= healing
				L.adjustOxyLoss(-healing)
				vitality_used += healing

			if(!ratvar_awakens)
				vitality -= vitality_used
		sleep(2)

	animation_number = initial(animation_number)
	sigil_active = FALSE
	animate(src, alpha = initial(alpha), time = 20)
	visible_message("<span class='warning'>[src] slowly stops glowing!</span>")
