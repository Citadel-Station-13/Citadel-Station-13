/datum/round_event_control/spacevine
	name = "Spacevine"
	typepath = /datum/round_event/spacevine
	weight = 15
	max_occurrences = 3
	min_players = 10

/datum/round_event/spacevine/start()
	var/list/turfs = list() //list of all the empty floor turfs in the hallway areas

	var/obj/effect/spacevine/SV = new()

	for(var/area/hallway/A in world)
		for(var/turf/F in A)
			if(F.Enter(SV))
				turfs += F

	qdel(SV)

	if(turfs.len) //Pick a turf to spawn at if we can
		var/turf/T = pick(turfs)
		new/obj/effect/spacevine_controller(T) //spawn a controller at turf


/datum/spacevine_mutation
	var/name = ""
	var/severity = 1
	var/hue
	var/quality

/datum/spacevine_mutation/proc/process_mutation(obj/effect/spacevine/holder)
	return

/datum/spacevine_mutation/proc/process_temperature(obj/effect/spacevine/holder, temp, volume)
	return

/datum/spacevine_mutation/proc/on_birth(obj/effect/spacevine/holder)
	return

/datum/spacevine_mutation/proc/on_grow(obj/effect/spacevine/holder)
	return

/datum/spacevine_mutation/proc/on_death(obj/effect/spacevine/holder)
	return

/datum/spacevine_mutation/proc/on_hit(obj/effect/spacevine/holder, mob/hitter, obj/item/I, expected_damage)
	. = expected_damage

/datum/spacevine_mutation/proc/on_cross(obj/effect/spacevine/holder, mob/crosser)
	return

/datum/spacevine_mutation/proc/on_chem(obj/effect/spacevine/holder, datum/reagent/R)
	return

/datum/spacevine_mutation/proc/on_eat(obj/effect/spacevine/holder, mob/living/eater)
	return

/datum/spacevine_mutation/proc/on_spread(obj/effect/spacevine/holder, turf/target)
	return

/datum/spacevine_mutation/proc/on_buckle(obj/effect/spacevine/holder, mob/living/buckled)
	return

/datum/spacevine_mutation/proc/on_explosion(severity, target, obj/effect/spacevine/holder)
	return


/datum/spacevine_mutation/space_covering
	name = "space protective"
	hue = "#aa77aa"
	quality = POSITIVE

/turf/open/floor/vines
	color = "#aa77aa"
	icon_state = "vinefloor"
	broken_states = list()


//All of this shit is useless for vines

/turf/open/floor/vines/attackby()
	return

/turf/open/floor/vines/burn_tile()
	return

/turf/open/floor/vines/break_tile()
	return

/turf/open/floor/vines/make_plating()
	return

/turf/open/floor/vines/break_tile_to_plating()
	return

/turf/open/floor/vines/ex_act(severity, target)
	if(severity < 3 || target == src)
		ChangeTurf(src.baseturf)

/turf/open/floor/vines/narsie_act()
	if(prob(20))
		ChangeTurf(src.baseturf) //nar sie eats this shit

/turf/open/floor/vines/singularity_pull(S, current_size)
	if(current_size >= STAGE_FIVE)
		if(prob(50))
			ChangeTurf(src.baseturf)

/turf/open/floor/vines/ChangeTurf(turf/open/floor/T)
	for(var/obj/effect/spacevine/SV in src)
		qdel(SV)
	..()
	reconsider_lights()

/datum/spacevine_mutation/space_covering/on_grow(obj/effect/spacevine/holder)
	if(istype(holder.loc, /turf/open/space))
		var/turf/open/spaceturf = holder.loc
		spaceturf.ChangeTurf(/turf/open/floor/vines)

/datum/spacevine_mutation/space_covering/process_mutation(obj/effect/spacevine/holder)
	if(istype(holder.loc, /turf/open/space))
		var/turf/open/spaceturf = holder.loc
		spaceturf.ChangeTurf(/turf/open/floor/vines)

/datum/spacevine_mutation/space_covering/on_death(obj/effect/spacevine/holder)
	if(istype(holder.loc, /turf/open/floor/vines))
		var/turf/open/spaceturf = holder.loc
		spaceturf.ChangeTurf(/turf/open/space)

/datum/spacevine_mutation/bluespace
	name = "bluespace"
	hue = "#3333ff"
	quality = MINOR_NEGATIVE

/datum/spacevine_mutation/bluespace/on_spread(obj/effect/spacevine/holder, turf/target)
	if(holder.energy > 1 && !locate(/obj/effect/spacevine) in target)
		holder.master.spawn_spacevine_piece(target, holder)

/datum/spacevine_mutation/light
	name = "light"
	hue = "#ffff00"
	quality = POSITIVE
	severity = 4

/datum/spacevine_mutation/light/on_grow(obj/effect/spacevine/holder)
	if(holder.energy)
		holder.set_light(severity, 3)

/datum/spacevine_mutation/toxicity
	name = "toxic"
	hue = "#ff00ff"
	severity = 10
	quality = NEGATIVE

/datum/spacevine_mutation/toxicity/on_cross(obj/effect/spacevine/holder, mob/living/crosser)
	if(issilicon(crosser))
		return
	if(prob(severity) && istype(crosser))
		crosser << "<span class='alert'>You accidently touch the vine and feel a strange sensation.</span>"
		crosser.adjustToxLoss(5)

/datum/spacevine_mutation/toxicity/on_eat(obj/effect/spacevine/holder, mob/living/eater)
	eater.adjustToxLoss(5)

/datum/spacevine_mutation/explosive  //OH SHIT IT CAN CHAINREACT RUN!!!
	name = "explosive"
	hue = "#ff0000"
	quality = NEGATIVE
	severity = 2

/datum/spacevine_mutation/explosive/on_explosion(explosion_severity, target, obj/effect/spacevine/holder)
	if(explosion_severity < 3)
		qdel(src)
	else
		. = 1
		spawn(5)
			qdel(src)

/datum/spacevine_mutation/explosive/on_death(obj/effect/spacevine/holder, mob/hitter, obj/item/I)
	explosion(holder.loc, 0, 0, severity, 0, 0)

/datum/spacevine_mutation/fire_proof
	name = "fire proof"
	hue = "#ff8888"
	quality = MINOR_NEGATIVE

/datum/spacevine_mutation/fire_proof/process_temperature(obj/effect/spacevine/holder, temp, volume)
	return 1

/datum/spacevine_mutation/fire_proof/on_hit(obj/effect/spacevine/holder, mob/hitter, obj/item/I, expected_damage)
	if(I && I.damtype == "fire")
		. = 0

/datum/spacevine_mutation/vine_eating
	name = "vine eating"
	hue = "#ff7700"
	quality = MINOR_NEGATIVE

/datum/spacevine_mutation/vine_eating/on_spread(obj/effect/spacevine/holder, turf/target)
	var/obj/effect/spacevine/prey = locate() in target
	if(prey && !prey.mutations.Find(src))  //Eat all vines that are not of the same origin
		qdel(prey)

/datum/spacevine_mutation/aggressive_spread  //very OP, but im out of other ideas currently
	name = "aggressive spreading"
	hue = "#333333"
	severity = 3
	quality = NEGATIVE

/datum/spacevine_mutation/aggressive_spread/on_spread(obj/effect/spacevine/holder, turf/target)
	target.ex_act(severity, src)

/datum/spacevine_mutation/aggressive_spread/on_buckle(obj/effect/spacevine/holder, mob/living/buckled)
	buckled.ex_act(severity)

/datum/spacevine_mutation/transparency
	name = "transparent"
	hue = ""
	quality = POSITIVE

/datum/spacevine_mutation/transparency/on_grow(obj/effect/spacevine/holder)
	holder.set_opacity(0)
	holder.alpha = 125

/datum/spacevine_mutation/oxy_eater
	name = "oxygen consuming"
	hue = "#ffff88"
	severity = 3
	quality = NEGATIVE

/datum/spacevine_mutation/oxy_eater/process_mutation(obj/effect/spacevine/holder)
	var/turf/open/floor/T = holder.loc
	if(istype(T))
		var/datum/gas_mixture/GM = T.air
		if(!GM.gases["o2"])
			return
		GM.gases["o2"][MOLES] -= severity * holder.energy
		GM.garbage_collect()

/datum/spacevine_mutation/nitro_eater
	name = "nitrogen consuming"
	hue = "#8888ff"
	severity = 3
	quality = NEGATIVE

/datum/spacevine_mutation/nitro_eater/process_mutation(obj/effect/spacevine/holder)
	var/turf/open/floor/T = holder.loc
	if(istype(T))
		var/datum/gas_mixture/GM = T.air
		if(!GM.gases["n2"])
			return
		GM.gases["n2"][MOLES] -= severity * holder.energy
		GM.garbage_collect()

/datum/spacevine_mutation/carbondioxide_eater
	name = "CO2 consuming"
	hue = "#00ffff"
	severity = 3
	quality = POSITIVE

/datum/spacevine_mutation/carbondioxide_eater/process_mutation(obj/effect/spacevine/holder)
	var/turf/open/floor/T = holder.loc
	if(istype(T))
		var/datum/gas_mixture/GM = T.air
		if(!GM.gases["co2"])
			return
		GM.gases["co2"][MOLES] -= severity * holder.energy
		GM.garbage_collect()

/datum/spacevine_mutation/plasma_eater
	name = "toxins consuming"
	hue = "#ffbbff"
	severity = 3
	quality = POSITIVE

/datum/spacevine_mutation/plasma_eater/process_mutation(obj/effect/spacevine/holder)
	var/turf/open/floor/T = holder.loc
	if(istype(T))
		var/datum/gas_mixture/GM = T.air
		if(!GM.gases["plasma"])
			return
		GM.gases["plasma"][MOLES] -= severity * holder.energy
		GM.garbage_collect()

/datum/spacevine_mutation/thorns
	name = "thorny"
	hue = "#666666"
	severity = 10
	quality = NEGATIVE

/datum/spacevine_mutation/thorns/on_cross(obj/effect/spacevine/holder, mob/living/crosser)
	if(prob(severity) && istype(crosser))
		var/mob/living/M = crosser
		M.adjustBruteLoss(5)
		M << "<span class='alert'>You cut yourself on the thorny vines.</span>"

/datum/spacevine_mutation/thorns/on_hit(obj/effect/spacevine/holder, mob/living/hitter)
	if(prob(severity) && istype(hitter))
		var/mob/living/M = hitter
		M.adjustBruteLoss(5)
		M << "<span class='alert'>You cut yourself on the thorny vines.</span>"

/datum/spacevine_mutation/woodening
	name = "hardened"
	hue = "#997700"
	quality = NEGATIVE

/datum/spacevine_mutation/woodening/on_grow(obj/effect/spacevine/holder)
	if(holder.energy)
		holder.density = 1

/datum/spacevine_mutation/woodening/on_hit(obj/effect/spacevine/holder, mob/hitter, obj/item/I, expected_damage)
	if(!expected_damage)
		return
	if(hitter)
		if(I)
			. = I.force * 2
		else
			. = 8

/datum/spacevine_mutation/flowering
	name = "flowering"
	hue = "#0A480D"
	quality = NEGATIVE
	severity = 10

/datum/spacevine_mutation/flowering/on_grow(obj/effect/spacevine/holder)
	if(holder.energy == 2 && prob(severity) && !locate(/obj/structure/alien/resin/flower_bud_enemy) in range(5,holder))
		new/obj/structure/alien/resin/flower_bud_enemy(get_turf(holder))

/datum/spacevine_mutation/flowering/on_cross(obj/effect/spacevine/holder, mob/living/crosser)
	holder.entangle(crosser)


// SPACE VINES (Note that this code is very similar to Biomass code)
/obj/effect/spacevine
	name = "space vines"
	desc = "An extremely expansionistic species of vine."
	icon = 'icons/effects/spacevines.dmi'
	icon_state = "Light1"
	anchored = 1
	density = 0
	layer = SPACEVINE_LAYER
	mouse_opacity = 2 //Clicking anywhere on the turf is good enough
	pass_flags = PASSTABLE | PASSGRILLE
	var/energy = 0
	var/obj/effect/spacevine_controller/master = null
	var/list/mutations = list()

/obj/effect/spacevine/Destroy()
	for(var/datum/spacevine_mutation/SM in mutations)
		SM.on_death(src)
	if(master)
		master.vines -= src
		master.growth_queue -= src
		if(!master.vines.len)
			var/obj/item/seeds/kudzu/KZ = new(loc)
			KZ.mutations |= mutations
			KZ.potency = min(100, master.mutativness * 10)
			KZ.production = (master.spread_cap / initial(master.spread_cap)) * 50
	mutations = list()
	set_opacity(0)
	if(has_buckled_mobs())
		unbuckle_all_mobs(force=1)
	return ..()

/obj/effect/spacevine/proc/on_chem_effect(datum/reagent/R)
	var/override = 0
	for(var/datum/spacevine_mutation/SM in mutations)
		override += SM.on_chem(src, R)
	if(!override && istype(R, /datum/reagent/toxin/plantbgone))
		if(prob(50))
			qdel(src)

/obj/effect/spacevine/proc/eat(mob/eater)
	var/override = 0
	for(var/datum/spacevine_mutation/SM in mutations)
		override += SM.on_eat(src, eater)
	if(!override)
		if(prob(10))
			eater.say("Nom")
		qdel(src)

/obj/effect/spacevine/attackby(obj/item/weapon/W, mob/user, params)
	if (!W || !user || !W.type)
		return
	user.changeNext_move(CLICK_CD_MELEE)

	var/override = W.force
	if(W.is_sharp())
		override = 100
	if(istype(W, /obj/item/weapon/scythe))
		var/local_override = override
		for(var/obj/effect/spacevine/B in orange(1,src))
			for(var/datum/spacevine_mutation/SM in mutations)
				local_override = SM.on_hit(src, user, W, local_override)
				if(prob(local_override))
					qdel(B)

	for(var/datum/spacevine_mutation/SM in mutations)
		override = SM.on_hit(src, user, W, override) //on_hit now takes override damage as arg and returns new value for other mutations to permutate further

	if(prob(override))
		qdel(src)

	..()

/obj/effect/spacevine/Crossed(mob/crosser)
	if(isliving(crosser))
		for(var/datum/spacevine_mutation/SM in mutations)
			SM.on_cross(src, crosser)

/obj/effect/spacevine/attack_hand(mob/user)
	for(var/datum/spacevine_mutation/SM in mutations)
		SM.on_hit(src, user)
	user_unbuckle_mob(user, user)


/obj/effect/spacevine/attack_paw(mob/living/user)
	user.do_attack_animation(src)
	for(var/datum/spacevine_mutation/SM in mutations)
		SM.on_hit(src, user)
	user_unbuckle_mob(user,user)

/obj/effect/spacevine/attack_alien(mob/living/user)
	eat(user)

/obj/effect/spacevine_controller
	invisibility = INVISIBILITY_ABSTRACT
	var/list/obj/effect/spacevine/vines = list()
	var/list/growth_queue = list()
	var/spread_multiplier = 5
	var/spread_cap = 30
	var/list/mutations_list = list()
	var/mutativness = 1

/obj/effect/spacevine_controller/New(loc, list/muts, mttv, spreading)
	spawn_spacevine_piece(loc, , muts)
	START_PROCESSING(SSobj, src)
	init_subtypes(/datum/spacevine_mutation/, mutations_list)
	if(mttv != null)
		mutativness = mttv / 10
	if(spreading != null)
		spread_cap *= spreading / 50
		spread_multiplier /= spreading / 50

/obj/effect/spacevine_controller/ex_act() //only killing all vines will end this suffering
	return

/obj/effect/spacevine_controller/singularity_act()
	return

/obj/effect/spacevine_controller/singularity_pull()
	return

/obj/effect/spacevine_controller/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/spacevine_controller/proc/spawn_spacevine_piece(turf/location, obj/effect/spacevine/parent, list/muts)
	var/obj/effect/spacevine/SV = new(location)
	growth_queue += SV
	vines += SV
	SV.master = src
	if(muts && muts.len)
		SV.mutations |= muts
	if(parent)
		SV.mutations |= parent.mutations
		SV.color = parent.color
		SV.desc = parent.desc
		if(prob(mutativness))
			SV.mutations |= pick(mutations_list)
			var/datum/spacevine_mutation/randmut = pick(SV.mutations)
			SV.color = randmut.hue
			SV.desc = "An extremely expansionistic species of vine. These are "
			for(var/datum/spacevine_mutation/M in SV.mutations)
				SV.desc += "[M.name] "
			SV.desc += "vines."

	for(var/datum/spacevine_mutation/SM in SV.mutations)
		SM.on_birth(SV)

/obj/effect/spacevine_controller/process()
	if(!vines)
		qdel(src) //space  vines exterminated. Remove the controller
		return
	if(!growth_queue)
		qdel(src) //Sanity check
		return

	var/length = 0

	length = min( spread_cap , max( 1 , vines.len / spread_multiplier ) )
	var/i = 0
	var/list/obj/effect/spacevine/queue_end = list()

	for( var/obj/effect/spacevine/SV in growth_queue )
		if(qdeleted(SV))
			continue
		i++
		queue_end += SV
		growth_queue -= SV
		for(var/datum/spacevine_mutation/SM in SV.mutations)
			SM.process_mutation(SV)
		if(SV.energy < 2) //If tile isn't fully grown
			if(prob(20))
				SV.grow()
		else //If tile is fully grown
			SV.entangle_mob()

		//if(prob(25))
		SV.spread()
		if(i >= length)
			break

	growth_queue = growth_queue + queue_end

/obj/effect/spacevine/proc/grow()
	if(!energy)
		src.icon_state = pick("Med1", "Med2", "Med3")
		energy = 1
		set_opacity(1)
	else
		src.icon_state = pick("Hvy1", "Hvy2", "Hvy3")
		energy = 2

	for(var/datum/spacevine_mutation/SM in mutations)
		SM.on_grow(src)

/obj/effect/spacevine/proc/entangle_mob()
	if(!has_buckled_mobs() && prob(25))
		for(var/mob/living/V in src.loc)
			entangle(V)
			if(buckled_mobs.len)
				break //only capture one mob at a time


/obj/effect/spacevine/proc/entangle(mob/living/V)
	if(!V)
		return
	for(var/datum/spacevine_mutation/SM in mutations)
		SM.on_buckle(src, V)
	if((V.stat != DEAD) && (V.buckled != src)) //not dead or captured
		V << "<span class='danger'>The vines [pick("wind", "tangle", "tighten")] around you!</span>"
		buckle_mob(V)

/obj/effect/spacevine/proc/spread()
	var/direction = pick(cardinal)
	var/turf/stepturf = get_step(src,direction)
	for(var/datum/spacevine_mutation/SM in mutations)
		SM.on_spread(src, stepturf)
		stepturf = get_step(src,direction) //in case turf changes, to make sure no runtimes happen
	if(!locate(/obj/effect/spacevine, stepturf))
		if(stepturf.Enter(src))
			if(master)
				master.spawn_spacevine_piece(stepturf, src)

/obj/effect/spacevine/ex_act(severity, target)
	if(istype(target, type)) //if its agressive spread vine dont do anything
		return
	var/i
	for(var/datum/spacevine_mutation/SM in mutations)
		i += SM.on_explosion(severity, target, src)
	if(!i && prob(100/severity))
		qdel(src)

/obj/effect/spacevine/temperature_expose(null, temp, volume)
	var/override = 0
	for(var/datum/spacevine_mutation/SM in mutations)
		override += SM.process_temperature(src, temp, volume)
	if(!override)
		qdel(src)
