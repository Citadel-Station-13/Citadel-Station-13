
/obj/machinery/syndicatebomb
	icon = 'icons/obj/assemblies.dmi'
	name = "syndicate bomb"
	icon_state = "syndicate-bomb"
	desc = "A large and menacing device. Can be bolted down with a wrench."

	anchored = 0
	density = 0
	layer = BELOW_MOB_LAYER //so people can't hide it and it's REALLY OBVIOUS
	unacidable = 1

	var/timer = 60
	var/open_panel = FALSE 	//are the wires exposed?
	var/active = FALSE		//is the bomb counting down?
	var/defused = FALSE		//is the bomb capable of exploding?
	var/obj/item/weapon/bombcore/payload = /obj/item/weapon/bombcore
	var/beepsound = 'sound/items/timer.ogg'
	var/delayedbig = FALSE	//delay wire pulsed?
	var/delayedlittle  = FALSE	//activation wire pulsed?
	var/obj/effect/countdown/syndicatebomb/countdown

/obj/machinery/syndicatebomb/process()
	if(active && !defused && (timer > 0)) 	//Tick Tock
		var/volume = (timer <= 5 ? 50 : 2) // Tick louder when the bomb is closer to being detonated.
		playsound(loc, beepsound, volume, 0)
		timer--
	if(active && !defused && (timer <= 0))	//Boom
		active = 0
		timer = initial(timer)
		update_icon()
		if(payload in src)
			payload.detonate()
		return
	if(!active || defused)					//Counter terrorists win
		if(defused && payload in src)
			payload.defuse()
			countdown.stop()

/obj/machinery/syndicatebomb/New()
	wires = new /datum/wires/syndicatebomb(src)
	if(src.payload)
		payload = new payload(src)
	update_icon()
	countdown = new(src)
	..()

/obj/machinery/syndicatebomb/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/syndicatebomb/examine(mob/user)
	..()
	user << "A digital display on it reads \"[timer]\"."

/obj/machinery/syndicatebomb/update_icon()
	icon_state = "[initial(icon_state)][active ? "-active" : "-inactive"][open_panel ? "-wires" : ""]"

/obj/machinery/syndicatebomb/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/wrench))
		if(!anchored)
			if(!isturf(src.loc) || istype(src.loc, /turf/open/space))
				user << "<span class='notice'>The bomb must be placed on solid ground to attach it.</span>"
			else
				user << "<span class='notice'>You firmly wrench the bomb to the floor.</span>"
				playsound(loc, 'sound/items/ratchet.ogg', 50, 1)
				anchored = 1
				if(active)
					user << "<span class='notice'>The bolts lock in place.</span>"
		else
			if(!active)
				user << "<span class='notice'>You wrench the bomb from the floor.</span>"
				playsound(loc, 'sound/items/ratchet.ogg', 50, 1)
				anchored = 0
			else
				user << "<span class='warning'>The bolts are locked down!</span>"

	else if(istype(I, /obj/item/weapon/screwdriver))
		open_panel = !open_panel
		update_icon()
		user << "<span class='notice'>You [open_panel ? "open" : "close"] the wire panel.</span>"

	else if(is_wire_tool(I) && open_panel)
		wires.interact(user)

	else if(istype(I, /obj/item/weapon/crowbar))
		if(open_panel && wires.is_all_cut())
			if(payload)
				user << "<span class='notice'>You carefully pry out [payload].</span>"
				payload.loc = user.loc
				payload = null
			else
				user << "<span class='warning'>There isn't anything in here to remove!</span>"
		else if (open_panel)
			user << "<span class='warning'>The wires connecting the shell to the explosives are holding it down!</span>"
		else
			user << "<span class='warning'>The cover is screwed on, it won't pry off!</span>"
	else if(istype(I, /obj/item/weapon/bombcore))
		if(!payload)
			if(!user.drop_item())
				return
			payload = I
			user << "<span class='notice'>You place [payload] into [src].</span>"
			payload.loc = src
		else
			user << "<span class='warning'>[payload] is already loaded into [src]! You'll have to remove it first.</span>"
	else if(istype(I, /obj/item/weapon/weldingtool))
		if(payload || !wires.is_all_cut() || !open_panel)
			return
		var/obj/item/weapon/weldingtool/WT = I
		if(!WT.isOn())
			return
		if(WT.get_fuel() < 5) //uses up 5 fuel.
			user << "<span class='warning'>You need more fuel to complete this task!</span>"
			return

		playsound(loc, pick('sound/items/Welder.ogg', 'sound/items/Welder2.ogg'), 50, 1)
		user << "<span class='notice'>You start to cut the [src] apart...</span>"
		if(do_after(user, 20/I.toolspeed, target = src))
			if(!WT.isOn() || !WT.remove_fuel(5, user))
				return
			user << "<span class='notice'>You cut the [src] apart.</span>"
			new /obj/item/stack/sheet/plasteel( loc, 5)
			qdel(src)
			return
	else
		return ..()

/obj/machinery/syndicatebomb/attack_hand(mob/user)
	interact(user)

/obj/machinery/syndicatebomb/attack_ai()
	return

/obj/machinery/syndicatebomb/interact(mob/user)
	wires.interact(user)
	if(!open_panel)
		if(!active)
			settings(user)
		else if(anchored)
			user << "<span class='warning'>The bomb is bolted to the floor!</span>"

/obj/machinery/syndicatebomb/proc/settings(mob/user)
	var/newtime = input(user, "Please set the timer.", "Timer", "[timer]") as num
	newtime = Clamp(newtime, initial(timer), 60000)
	if(in_range(src, user) && isliving(user)) //No running off and setting bombs from across the station
		timer = newtime
		src.loc.visible_message("<span class='notice'>\icon[src] timer set for [timer] seconds.</span>")
	if(alert(user,"Would you like to start the countdown now?",,"Yes","No") == "Yes" && in_range(src, user) && isliving(user))
		if(defused || active)
			if(defused)
				src.loc.visible_message("<span class='warning'>\icon[src] Device error: User intervention required.</span>")
			return
		else
			src.loc.visible_message("<span class='danger'>\icon[src] [timer] seconds until detonation, please clear the area.</span>")
			countdown.start()
			playsound(loc, 'sound/machines/click.ogg', 30, 1)
			active = 1
			update_icon()
			add_fingerprint(user)

			var/turf/bombturf = get_turf(src)
			var/area/A = get_area(bombturf)
			if(payload && !istype(payload, /obj/item/weapon/bombcore/training))
				message_admins("[key_name_admin(user)]<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A> (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) has primed a [name] ([payload]) for detonation at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[bombturf.x];Y=[bombturf.y];Z=[bombturf.z]'>[A.name] (JMP)</a>.")
				log_game("[key_name(user)] has primed a [name] ([payload]) for detonation at [A.name]([bombturf.x],[bombturf.y],[bombturf.z])")
				payload.adminlog = "The [src.name] that [key_name(user)] had primed detonated!"

///Bomb Subtypes///

/obj/machinery/syndicatebomb/training
	name = "training bomb"
	icon_state = "training-bomb"
	desc = "A salvaged syndicate device gutted of its explosives to be used as a training aid for aspiring bomb defusers."
	payload = /obj/item/weapon/bombcore/training/

/obj/machinery/syndicatebomb/badmin
	name = "generic summoning badmin bomb"
	desc = "Oh god what is in this thing?"
	payload = /obj/item/weapon/bombcore/badmin/summon/

/obj/machinery/syndicatebomb/badmin/clown
	name = "clown bomb"
	icon_state = "clown-bomb"
	desc = "HONK."
	payload = /obj/item/weapon/bombcore/badmin/summon/clown
	beepsound = 'sound/items/bikehorn.ogg'

/obj/machinery/syndicatebomb/badmin/varplosion
	payload = /obj/item/weapon/bombcore/badmin/explosion/

/obj/machinery/syndicatebomb/empty
	name = "bomb"
	icon_state = "base-bomb"
	desc = "An ominous looking device designed to detonate an explosive payload. Can be bolted down using a wrench."
	payload = null
	open_panel = TRUE
	timer = 120

/obj/machinery/syndicatebomb/empty/New()
	..()
	wires.cut_all()

///Bomb Cores///

/obj/item/weapon/bombcore
	name = "bomb payload"
	desc = "A powerful secondary explosive of syndicate design and unknown composition, it should be stable under normal conditions..."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "bombcore"
	item_state = "eshield0"
	w_class = 3
	origin_tech = "syndicate=5;combat=6"
	burn_state = FLAMMABLE //Burnable (but the casing isn't)
	var/adminlog = null

/obj/item/weapon/bombcore/ex_act(severity, target) // Little boom can chain a big boom.
	detonate()


/obj/item/weapon/bombcore/burn()
	detonate()
	..()

/obj/item/weapon/bombcore/proc/detonate()
	if(adminlog)
		message_admins(adminlog)
		log_game(adminlog)
	explosion(get_turf(src), 3, 9, 17, flame_range = 17)
	if(loc && istype(loc,/obj/machinery/syndicatebomb/))
		qdel(loc)
	qdel(src)

/obj/item/weapon/bombcore/proc/defuse()
//Note: 	Because of how var/defused is used you shouldn't override this UNLESS you intend to set the var to 0 or
//			otherwise remove the core/reset the wires before the end of defuse(). It will repeatedly be called otherwise.

///Bomb Core Subtypes///

/obj/item/weapon/bombcore/training
	name = "dummy payload"
	desc = "A nanotrasen replica of a syndicate payload. Its not intended to explode but to announce that it WOULD have exploded, then rewire itself to allow for more training."
	origin_tech = null
	var/defusals = 0
	var/attempts = 0

/obj/item/weapon/bombcore/training/proc/reset()
	var/obj/machinery/syndicatebomb/holder = loc
	if(istype(holder))
		if(holder.wires)
			holder.wires.repair()
			holder.wires.shuffle_wires()
		holder.defused = 0
		holder.open_panel = 0
		holder.delayedbig = FALSE
		holder.delayedlittle = FALSE
		holder.update_icon()
		holder.updateDialog()

/obj/item/weapon/bombcore/training/detonate()
	var/obj/machinery/syndicatebomb/holder = loc
	if(istype(holder))
		attempts++
		holder.loc.visible_message("<span class='danger'>\icon[holder] Alert: Bomb has detonated. Your score is now [defusals] for [attempts]. Resetting wires...</span>")
		reset()
	else
		qdel(src)

/obj/item/weapon/bombcore/training/defuse()
	var/obj/machinery/syndicatebomb/holder = loc
	if(istype(holder))
		attempts++
		defusals++
		holder.loc.visible_message("<span class='notice'>\icon[holder] Alert: Bomb has been defused. Your score is now [defusals] for [attempts]! Resetting wires in 5 seconds...</span>")
		sleep(50)	//Just in case someone is trying to remove the bomb core this gives them a little window to crowbar it out
		if(istype(holder))
			reset()

/obj/item/weapon/bombcore/badmin
	name = "badmin payload"
	desc = "If you're seeing this someone has either made a mistake or gotten dangerously savvy with var editing!"
	origin_tech = null

/obj/item/weapon/bombcore/badmin/defuse() //because we wouldn't want them being harvested by players
	var/obj/machinery/syndicatebomb/B = loc
	qdel(B)
	qdel(src)

/obj/item/weapon/bombcore/badmin/summon/
	var/summon_path = /obj/item/weapon/reagent_containers/food/snacks/cookie
	var/amt_summon = 1

/obj/item/weapon/bombcore/badmin/summon/detonate()
	var/obj/machinery/syndicatebomb/B = src.loc
	for(var/i = 0; i < amt_summon; i++)
		var/atom/movable/X = new summon_path
		X.loc = get_turf(src)
		if(prob(50))
			for(var/j = 1, j <= rand(1, 3), j++)
				step(X, pick(NORTH,SOUTH,EAST,WEST))
	qdel(B)
	qdel(src)

/obj/item/weapon/bombcore/badmin/summon/clown
	summon_path = /mob/living/simple_animal/hostile/retaliate/clown
	amt_summon 	= 100

/obj/item/weapon/bombcore/badmin/summon/clown/defuse()
	playsound(src.loc, 'sound/misc/sadtrombone.ogg', 50)
	..()

/obj/item/weapon/bombcore/badmin/explosion
	var/HeavyExplosion = 2
	var/MediumExplosion = 5
	var/LightExplosion = 11
	var/Flames = 11

/obj/item/weapon/bombcore/badmin/explosion/detonate()
	explosion(get_turf(src), HeavyExplosion, MediumExplosion, LightExplosion, flame_range = Flames)
	qdel(src)

/obj/item/weapon/bombcore/miniature
	name = "small bomb core"
	w_class = 2

/obj/item/weapon/bombcore/miniature/detonate()
	if(adminlog)
		message_admins(adminlog)
		log_game(adminlog)
	explosion(src.loc, 1, 2, 4, flame_range = 2) //Identical to a minibomb
	qdel(src)

/obj/item/weapon/bombcore/chemical
	name = "chemical payload"
	desc = "An explosive payload designed to spread chemicals, dangerous or otherwise, across a large area. It is able to hold up to four chemical containers, and must be loaded before use."
	origin_tech = "combat=4;materials=3"
	icon_state = "chemcore"
	var/list/beakers = list()
	var/max_beakers = 1
	var/spread_range = 5
	var/temp_boost = 50
	var/time_release = 0

/obj/item/weapon/bombcore/chemical/detonate()

	if(time_release > 0)
		var/total_volume = 0
		for(var/obj/item/weapon/reagent_containers/RC in beakers)
			total_volume += RC.reagents.total_volume

		if(total_volume < time_release) // If it's empty, the detonation is complete.
			if(loc && istype(loc,/obj/machinery/syndicatebomb/))
				qdel(loc)
			qdel(src)
			return

		var/fraction = time_release/total_volume
		var/datum/reagents/reactants = new(time_release)
		reactants.my_atom = src
		for(var/obj/item/weapon/reagent_containers/RC in beakers)
			RC.reagents.trans_to(reactants, RC.reagents.total_volume*fraction, 1, 1, 1)
		chem_splash(get_turf(src), spread_range, list(reactants), temp_boost)

		// Detonate it again in one second, until it's out of juice.
		addtimer(src, "detonate", 10)

	// If it's not a time release bomb, do normal explosion

	var/list/reactants = list()

	for(var/obj/item/weapon/reagent_containers/glass/G in beakers)
		reactants += G.reagents

	for(var/obj/item/slime_extract/S in beakers)
		if(S.Uses)
			for(var/obj/item/weapon/reagent_containers/glass/G in beakers)
				G.reagents.trans_to(S, G.reagents.total_volume)

			if(S && S.reagents && S.reagents.total_volume)
				reactants += S.reagents

	if(!chem_splash(get_turf(src), spread_range, reactants, temp_boost))
		playsound(loc, 'sound/items/Screwdriver2.ogg', 50, 1)
		return // The Explosion didn't do anything. No need to log, or disappear.

	if(adminlog)
		message_admins(adminlog)
		log_game(adminlog)

	playsound(loc, 'sound/effects/bamf.ogg', 75, 1, 5)

	if(loc && istype(loc,/obj/machinery/syndicatebomb/))
		qdel(loc)
	qdel(src)

/obj/item/weapon/bombcore/chemical/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/crowbar) && beakers.len > 0)
		playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
		for (var/obj/item/B in beakers)
			B.loc = get_turf(src)
			beakers -= B
		return
	else if(istype(I, /obj/item/weapon/reagent_containers/glass/beaker) || istype(I, /obj/item/weapon/reagent_containers/glass/bottle))
		if(beakers.len < max_beakers)
			if(!user.drop_item())
				return
			beakers += I
			user << "<span class='notice'>You load [src] with [I].</span>"
			I.loc = src
		else
			user << "<span class='warning'>The [I] wont fit! The [src] can only hold up to [max_beakers] containers.</span>"
			return
	..()

/obj/item/weapon/bombcore/chemical/CheckParts(list/parts_list)
	..()
	// Using different grenade casings, causes the payload to have different properties.
	var/obj/item/weapon/stock_parts/matter_bin/MB = locate(/obj/item/weapon/stock_parts/matter_bin) in src
	if(MB)
		max_beakers += MB.rating	// max beakers = 2-5.
		qdel(MB)
	for(var/obj/item/weapon/grenade/chem_grenade/G in src)

		if(istype(G, /obj/item/weapon/grenade/chem_grenade/large))
			var/obj/item/weapon/grenade/chem_grenade/large/LG = G
			max_beakers += 1 // Adding two large grenades only allows for a maximum of 7 beakers.
			spread_range += 2 // Extra range, reduced density.
			temp_boost += 50 // maximum of +150K blast using only large beakers. Not enough to self ignite.
			for(var/obj/item/slime_extract/S in LG.beakers) // And slime cores.
				if(beakers.len < max_beakers)
					beakers += S
					S.loc = src
				else
					S.loc = get_turf(src)

		if(istype(G, /obj/item/weapon/grenade/chem_grenade/cryo))
			spread_range -= 1 // Reduced range, but increased density.
			temp_boost -= 100 // minimum of -150K blast.

		if(istype(G, /obj/item/weapon/grenade/chem_grenade/pyro))
			temp_boost += 150 // maximum of +350K blast, which is enough to self ignite. Which means a self igniting bomb can't take advantage of other grenade casing properties. Sorry?

		if(istype(G, /obj/item/weapon/grenade/chem_grenade/adv_release))
			time_release += 50 // A typical bomb, using basic beakers, will explode over 2-4 seconds. Using two will make the reaction last for less time, but it will be more dangerous overall.

		for(var/obj/item/weapon/reagent_containers/glass/B in G)
			if(beakers.len < max_beakers)
				beakers += B
				B.loc = src
			else
				B.loc = get_turf(src)

		qdel(G)




///Syndicate Detonator (aka the big red button)///

/obj/item/device/syndicatedetonator
	name = "big red button"
	desc = "Nothing good can come of pressing a button this garish..."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "bigred"
	item_state = "electronic"
	w_class = 1
	origin_tech = "syndicate=3"
	var/cooldown = 0
	var/detonated =	0
	var/existant =	0

/obj/item/device/syndicatedetonator/attack_self(mob/user)
	if(!cooldown)
		for(var/obj/machinery/syndicatebomb/B in machines)
			if(B.active)
				B.timer = 0
				detonated++
			existant++
		playsound(user, 'sound/machines/click.ogg', 20, 1)
		user << "<span class='notice'>[existant] found, [detonated] triggered.</span>"
		if(detonated)
			var/turf/T = get_turf(src)
			var/area/A = get_area(T)
			detonated--
			var/log_str = "[key_name_admin(user)]<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A> (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) has remotely detonated [detonated ? "syndicate bombs" : "a syndicate bomb"] using a [name] at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>[A.name] (JMP)</a>."
			bombers += log_str
			message_admins(log_str)
			log_game("[key_name(user)] has remotely detonated [detonated ? "syndicate bombs" : "a syndicate bomb"] using a [name] at [A.name]([T.x],[T.y],[T.z])")
		detonated =	0
		existant =	0
		cooldown = 1
		spawn(30) cooldown = 0
