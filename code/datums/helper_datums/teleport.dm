//wrapper
/proc/do_teleport(ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null)
	var/datum/teleport/instant/science/D = new
	if(D.start(arglist(args)))
		return 1
	return 0

/datum/teleport
	var/atom/movable/teleatom //atom to teleport
	var/atom/destination //destination to teleport to
	var/precision = 0 //teleport precision
	var/datum/effect_system/effectin //effect to show right before teleportation
	var/datum/effect_system/effectout //effect to show right after teleportation
	var/soundin //soundfile to play before teleportation
	var/soundout //soundfile to play after teleportation
	var/force_teleport = 1 //if false, teleport will use Move() proc (dense objects will prevent teleportation)


/datum/teleport/proc/start(ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null)
	if(!initTeleport(arglist(args)))
		return 0
	return 1

/datum/teleport/proc/initTeleport(ateleatom,adestination,aprecision,afteleport,aeffectin,aeffectout,asoundin,asoundout)
	if(!setTeleatom(ateleatom))
		return 0
	if(!setDestination(adestination))
		return 0
	if(!setPrecision(aprecision))
		return 0
	setEffects(aeffectin,aeffectout)
	setForceTeleport(afteleport)
	setSounds(asoundin,asoundout)
	return 1

//must succeed
/datum/teleport/proc/setPrecision(aprecision)
	if(isnum(aprecision))
		precision = aprecision
		return 1
	return 0

//must succeed
/datum/teleport/proc/setDestination(atom/adestination)
	if(istype(adestination))
		destination = adestination
		return 1
	return 0

//must succeed in most cases
/datum/teleport/proc/setTeleatom(atom/movable/ateleatom)
	if(istype(ateleatom, /obj/effect) && !istype(ateleatom, /obj/effect/dummy/chameleon))
		qdel(ateleatom)
		return 0
	if(istype(ateleatom))
		teleatom = ateleatom
		return 1
	return 0

//custom effects must be properly set up first for instant-type teleports
//optional
/datum/teleport/proc/setEffects(datum/effect_system/aeffectin=null,datum/effect_system/aeffectout=null)
	effectin = istype(aeffectin) ? aeffectin : null
	effectout = istype(aeffectout) ? aeffectout : null
	return 1

//optional
/datum/teleport/proc/setForceTeleport(afteleport)
	force_teleport = afteleport
	return 1

//optional
/datum/teleport/proc/setSounds(asoundin=null,asoundout=null)
	soundin = isfile(asoundin) ? asoundin : null
	soundout = isfile(asoundout) ? asoundout : null
	return 1

//placeholder
/datum/teleport/proc/teleportChecks()
	return 1

/datum/teleport/proc/playSpecials(atom/location,datum/effect_system/effect,sound)
	if(location)
		if(effect)
			addtimer(src, "do_effect", 0, FALSE, location, effect)
		if(sound)
			addtimer(src, "do_sound", 0, FALSE, location, sound)

/datum/teleport/proc/do_effect(atom/location, datum/effect_system/effect)
	src = null
	effect.attach(location)
	effect.start()

/datum/teleport/proc/do_sound(atom/location, sound)
	src = null
	playsound(location, sound, 60, 1)

//do the monkey dance
/datum/teleport/proc/doTeleport()

	var/turf/destturf
	var/turf/curturf = get_turf(teleatom)
	if(precision)
		var/list/posturfs = list()
		var/center = get_turf(destination)
		if(!center)
			center = destination
		for(var/turf/T in range(precision,center))
			var/area/A = T.loc
			if(!A.noteleport)
				posturfs.Add(T)

		destturf = safepick(posturfs)
	else
		destturf = get_turf(destination)

	if(!destturf || !curturf)
		return 0

	var/area/A = get_area(curturf)
	if(A.noteleport)
		return 0

	playSpecials(curturf,effectin,soundin)

	if(force_teleport)
		teleatom.forceMove(destturf)
		playSpecials(destturf,effectout,soundout)
	else
		if(teleatom.Move(destturf))
			playSpecials(destturf,effectout,soundout)
	return 1

/datum/teleport/proc/teleport()
	if(teleportChecks())
		return doTeleport()
	return 0

/datum/teleport/instant //teleports when datum is created

	start(ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null)
		if(..())
			if(teleport())
				return 1
		return 0


/datum/teleport/instant/science

/datum/teleport/instant/science/setEffects(datum/effect_system/aeffectin,datum/effect_system/aeffectout)
	if(aeffectin==null || aeffectout==null)
		var/datum/effect_system/spark_spread/aeffect = new
		aeffect.set_up(5, 1, teleatom)
		effectin = effectin || aeffect
		effectout = effectout || aeffect
		return 1
	else
		return ..()

/datum/teleport/instant/science/setPrecision(aprecision)
	..()
	if(istype(teleatom, /obj/item/weapon/storage/backpack/holding))
		precision = rand(1,100)

	var/list/bagholding = teleatom.search_contents_for(/obj/item/weapon/storage/backpack/holding)
	if(bagholding.len)
		precision = max(rand(1,100)*bagholding.len,100)
		if(istype(teleatom, /mob/living))
			var/mob/living/MM = teleatom
			MM << "<span class='warning'>The bluespace interface on your bag of holding interferes with the teleport!</span>"
	return 1

// Safe location finder

/proc/find_safe_turf(zlevel = ZLEVEL_STATION, list/zlevels)
	if(!zlevels)
		zlevels = list(zlevel)
	var/cycles = 1000
	for(var/cycle in 1 to cycles)
		// DRUNK DIALLING WOOOOOOOOO
		var/x = rand(1, world.maxx)
		var/y = rand(1, world.maxy)
		var/z = pick(zlevels)
		var/random_location = locate(x,y,z)

		if(!(istype(random_location, /turf/open/floor)))
			continue
		var/turf/open/floor/F = random_location
		if(!F.air)
			continue

		var/datum/gas_mixture/A = F.air
		var/list/A_gases = A.gases
		var/trace_gases
		for(var/id in A_gases)
			if(id in hardcoded_gases)
				continue
			trace_gases = TRUE
			break

		// Can most things breathe?
		if(trace_gases)
			continue
		if(!(A_gases["o2"] && A_gases["o2"][MOLES] >= 16))
			continue
		if(A_gases["plasma"])
			continue
		if(A_gases["co2"] && A_gases["co2"][MOLES] >= 10)
			continue

		// Aim for goldilocks temperatures and pressure
		if((A.temperature <= 270) || (A.temperature >= 360))
			continue
		var/pressure = A.return_pressure()
		if((pressure <= 20) || (pressure >= 550))
			continue

		// DING! You have passed the gauntlet, and are "probably" safe.
		return F
