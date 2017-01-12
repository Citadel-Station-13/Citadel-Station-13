/datum/chemical_reaction/reagent_explosion
	name = "Generic explosive"
	id = "reagent_explosion"
	result = null
	var/strengthdiv = 10
	var/modifier = 0

/datum/chemical_reaction/reagent_explosion/on_reaction(datum/reagents/holder, created_volume)
	var/turf/T = get_turf(holder.my_atom)
	var/inside_msg
	if(ismob(holder.my_atom))
		var/mob/M = holder.my_atom
		inside_msg = " inside [key_name_admin(M)]"
	var/lastkey = holder.my_atom.fingerprintslast
	var/touch_msg = "N/A"
	if(lastkey)
		var/mob/toucher = get_mob_by_key(lastkey)
		touch_msg = "[key_name_admin(lastkey)]<A HREF='?_src_=holder;adminmoreinfo=\ref[toucher]'>?</A> (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[toucher]'>FLW</A>)"
	message_admins("Reagent explosion reaction occured at <a href='?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>[T.loc.name] (JMP)</a>[inside_msg]. Last Fingerprint: [touch_msg].")
	log_game("Reagent explosion reaction occured at [T.loc.name] ([T.x],[T.y],[T.z]). Last Fingerprint: [lastkey ? lastkey : "N/A"]." )
	var/datum/effect_system/reagents_explosion/e = new()
	e.set_up(modifier + round(created_volume/strengthdiv, 1), T, 0, 0)
	e.start()
	holder.clear_reagents()


/datum/chemical_reaction/reagent_explosion/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	result = "nitroglycerin"
	required_reagents = list("glycerol" = 1, "facid" = 1, "sacid" = 1)
	result_amount = 2
	strengthdiv = 2

/datum/chemical_reaction/reagent_explosion/nitroglycerin/on_reaction(datum/reagents/holder, created_volume)
	if(holder.has_reagent("stabilizing_agent"))
		return
	holder.remove_reagent("nitroglycerin", created_volume)
	..()

/datum/chemical_reaction/reagent_explosion/nitroglycerin_explosion
	name = "Nitroglycerin explosion"
	id = "nitroglycerin_explosion"
	required_reagents = list("nitroglycerin" = 1)
	result_amount = 1
	required_temp = 474
	strengthdiv = 2


/datum/chemical_reaction/reagent_explosion/potassium_explosion
	name = "Explosion"
	id = "potassium_explosion"
	required_reagents = list("water" = 1, "potassium" = 1)
	result_amount = 2
	strengthdiv = 10

/datum/chemical_reaction/reagent_explosion/potassium_explosion/holyboom
	name = "Holy Explosion"
	id = "holyboom"
	required_reagents = list("holywater" = 1, "potassium" = 1)

/datum/chemical_reaction/reagent_explosion/potassium_explosion/holyboom/on_reaction(datum/reagents/holder, created_volume)
	if(created_volume >= 150)
		playsound(get_turf(holder.my_atom), 'sound/effects/pray.ogg', 80, 0, round(created_volume/48))
		strengthdiv = 8
		for(var/mob/living/simple_animal/revenant/R in get_hearers_in_view(7,get_turf(holder.my_atom)))
			var/diety = ticker.Bible_deity_name
			if(!ticker.Bible_deity_name)
				diety = "Christ"
			R << "<span class='userdanger'>The power of [diety] compels you!</span>"
			R.stun(20)
			R.reveal(100)
			R.adjustHealth(50)
		sleep(20)
		for(var/mob/living/carbon/C in get_hearers_in_view(round(created_volume/48,1),get_turf(holder.my_atom)))
			if(iscultist(C) || is_handofgod_cultist(C))
				C << "<span class='userdanger'>The divine explosion sears you!</span>"
				C.Weaken(2)
				C.adjust_fire_stacks(5)
				C.IgniteMob()
	..()


/datum/chemical_reaction/blackpowder
	name = "Black Powder"
	id = "blackpowder"
	result = "blackpowder"
	required_reagents = list("saltpetre" = 1, "charcoal" = 1, "sulfur" = 1)
	result_amount = 3

/datum/chemical_reaction/reagent_explosion/blackpowder_explosion
	name = "Black Powder Kaboom"
	id = "blackpowder_explosion"
	required_reagents = list("blackpowder" = 1)
	result_amount = 1
	required_temp = 474
	strengthdiv = 6
	modifier = 1
	mix_message = "<span class='boldannounce'>Sparks start flying around the black powder!</span>"

/datum/chemical_reaction/reagent_explosion/blackpowder_explosion/on_reaction(datum/reagents/holder, created_volume)
	sleep(rand(50,100))
	..()

/datum/chemical_reaction/thermite
	name = "Thermite"
	id = "thermite"
	result = "thermite"
	required_reagents = list("aluminium" = 1, "iron" = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/emp_pulse
	name = "EMP Pulse"
	id = "emp_pulse"
	result = null
	required_reagents = list("uranium" = 1, "iron" = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense
	result_amount = 2

/datum/chemical_reaction/emp_pulse/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	// 100 created volume = 4 heavy range & 7 light range. A few tiles smaller than traitor EMP grandes.
	// 200 created volume = 8 heavy range & 14 light range. 4 tiles larger than traitor EMP grenades.
	empulse(location, round(created_volume / 24), round(created_volume / 14), 1)
	holder.clear_reagents()

/datum/chemical_reaction/stabilizing_agent
	name = "stabilizing_agent"
	id = "stabilizing_agent"
	result = "stabilizing_agent"
	required_reagents = list("iron" = 1, "oxygen" = 1, "hydrogen" = 1)
	result_amount = 3


/datum/chemical_reaction/clf3
	name = "Chlorine Trifluoride"
	id = "clf3"
	result = "clf3"
	required_reagents = list("chlorine" = 1, "fluorine" = 3)
	result_amount = 4
	required_temp = 424

/datum/chemical_reaction/clf3/on_reaction(datum/reagents/holder, created_volume)
	var/turf/T = get_turf(holder.my_atom)
	for(var/turf/turf in range(1,T))
		PoolOrNew(/obj/effect/hotspot, turf)
	holder.chem_temp = 1000 // hot as shit


/datum/chemical_reaction/reagent_explosion/methsplosion/
	name = "Meth explosion"
	id = "methboom1"
	result = "methboom1"
	result_amount = 1
	required_temp = 380 //slightly above the meth mix time.
	required_reagents = list("methamphetamine" = 1)
	strengthdiv = 6
	modifier = 1

/datum/chemical_reaction/reagent_explosion/methsplosion/on_reaction(datum/reagents/holder, created_volume)
	var/turf/T = get_turf(holder.my_atom)
	for(var/turf/turf in range(1,T))
		PoolOrNew(/obj/effect/hotspot, turf)
	holder.chem_temp = 1000 // hot as shit
	..()

/datum/chemical_reaction/reagent_explosion/methsplosion/methboom2
	required_reagents = list("diethylamine" = 1, "iodine" = 1, "phosphorus" = 1, "hydrogen" = 1) //diethylamine is often left over from mixing the ephedrine.
	required_temp = 300 //room temperature, chilling it even a little will prevent the explosion
	result_amount = 4

/datum/chemical_reaction/sorium
	name = "Sorium"
	id = "sorium"
	result = "sorium"
	required_reagents = list("mercury" = 1, "oxygen" = 1, "nitrogen" = 1, "carbon" = 1)
	result_amount = 4

/datum/chemical_reaction/sorium/on_reaction(datum/reagents/holder, created_volume)
	if(holder.has_reagent("stabilizing_agent"))
		return
	holder.remove_reagent("sorium", created_volume)
	var/turf/T = get_turf(holder.my_atom)
	var/range = Clamp(sqrt(created_volume), 1, 6)
	goonchem_vortex(T, 1, range)

/datum/chemical_reaction/sorium_vortex
	name = "sorium_vortex"
	id = "sorium_vortex"
	result = null
	result_amount = 1
	required_reagents = list("sorium" = 1)
	required_temp = 474

/datum/chemical_reaction/sorium_vortex/on_reaction(datum/reagents/holder, created_volume)
	var/turf/T = get_turf(holder.my_atom)
	var/range = Clamp(sqrt(created_volume), 1, 6)
	goonchem_vortex(T, 1, range)


/datum/chemical_reaction/liquid_dark_matter
	name = "Liquid Dark Matter"
	id = "liquid_dark_matter"
	result = "liquid_dark_matter"
	required_reagents = list("stable_plasma" = 1, "radium" = 1, "carbon" = 1)
	result_amount = 3

/datum/chemical_reaction/liquid_dark_matter/on_reaction(datum/reagents/holder, created_volume)
	if(holder.has_reagent("stabilizing_agent"))
		return
	holder.remove_reagent("liquid_dark_matter", created_volume)
	var/turf/T = get_turf(holder.my_atom)
	var/range = Clamp(sqrt(created_volume), 1, 6)
	goonchem_vortex(T, 0, range)

/datum/chemical_reaction/ldm_vortex
	name = "LDM Vortex"
	id = "ldm_vortex"
	result = null
	result_amount = 1
	required_reagents = list("liquid_dark_matter" = 1)
	required_temp = 474

/datum/chemical_reaction/ldm_vortex/on_reaction(datum/reagents/holder, created_volume)
	var/turf/T = get_turf(holder.my_atom)
	var/range = Clamp(sqrt(created_volume/2), 1, 6)
	goonchem_vortex(T, 0, range)

/datum/chemical_reaction/flash_powder
	name = "Flash powder"
	id = "flash_powder"
	result = "flash_powder"
	required_reagents = list("aluminium" = 1, "potassium" = 1, "sulfur" = 1 )
	result_amount = 3

/datum/chemical_reaction/flash_powder/on_reaction(datum/reagents/holder, created_volume)
	if(holder.has_reagent("stabilizing_agent"))
		return
	var/location = get_turf(holder.my_atom)
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(2, 1, location)
	s.start()
	for(var/mob/living/carbon/C in get_hearers_in_view(created_volume/10, location))
		if(C.flash_eyes())
			if(get_dist(C, location) < 4)
				C.Weaken(5)
			else
				C.Stun(5)
	holder.remove_reagent("flash_powder", created_volume)

/datum/chemical_reaction/flash_powder_flash
	name = "Flash powder activation"
	id = "flash_powder_flash"
	result = null
	required_reagents = list("flash_powder" = 1)
	result_amount = 1
	required_temp = 374

/datum/chemical_reaction/flash_powder_flash/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(2, 1, location)
	s.start()
	for(var/mob/living/carbon/C in get_hearers_in_view(created_volume/10, location))
		if(C.flash_eyes())
			if(get_dist(C, location) < 4)
				C.Weaken(5)
			else
				C.Stun(5)

/datum/chemical_reaction/smoke_powder
	name = "smoke_powder"
	id = "smoke_powder"
	result = "smoke_powder"
	required_reagents = list("potassium" = 1, "sugar" = 1, "phosphorus" = 1)
	result_amount = 3

/datum/chemical_reaction/smoke_powder/on_reaction(datum/reagents/holder, created_volume)
	if(holder.has_reagent("stabilizing_agent"))
		return
	holder.remove_reagent("smoke_powder", created_volume)
	var/smoke_radius = round(sqrt(created_volume / 2), 1)
	var/location = get_turf(holder.my_atom)
	var/datum/effect_system/smoke_spread/chem/S = new
	S.attach(location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	if(S)
		S.set_up(holder, smoke_radius, 0, location)
		S.start()
	if(holder && holder.my_atom)
		holder.clear_reagents()

/datum/chemical_reaction/smoke_powder_smoke
	name = "smoke_powder_smoke"
	id = "smoke_powder_smoke"
	result = null
	required_reagents = list("smoke_powder" = 1)
	required_temp = 374
	result_amount = 1
	secondary = 1
	mob_react = 1

/datum/chemical_reaction/smoke_powder_smoke/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	var/smoke_radius = round(sqrt(created_volume / 2), 1)
	var/datum/effect_system/smoke_spread/chem/S = new
	S.attach(location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	if(S)
		S.set_up(holder, smoke_radius, 0, location)
		S.start()
	if(holder && holder.my_atom)
		holder.clear_reagents()



/datum/chemical_reaction/sonic_powder
	name = "sonic_powder"
	id = "sonic_powder"
	result = "sonic_powder"
	required_reagents = list("oxygen" = 1, "cola" = 1, "phosphorus" = 1)
	result_amount = 3

/datum/chemical_reaction/sonic_powder/on_reaction(datum/reagents/holder, created_volume)
	if(holder.has_reagent("stabilizing_agent"))
		return
	holder.remove_reagent("sonic_powder", created_volume)
	var/location = get_turf(holder.my_atom)
	playsound(location, 'sound/effects/bang.ogg', 25, 1)
	for(var/mob/living/carbon/C in get_hearers_in_view(created_volume/10, location))
		if(C.check_ear_prot())
			continue
		C.show_message("<span class='warning'>BANG</span>", 2)
		C.Stun(5)
		C.Weaken(5)
		C.setEarDamage(C.ear_damage + rand(0, 5), max(C.ear_deaf,15))
		if(C.ear_damage >= 15)
			C << "<span class='warning'>Your ears start to ring badly!</span>"
		else if(C.ear_damage >= 5)
			C << "<span class='warning'>Your ears start to ring!</span>"

/datum/chemical_reaction/sonic_powder_deafen
	name = "sonic_powder_deafen"
	id = "sonic_powder_deafen"
	result = null
	required_reagents = list("sonic_powder" = 1)
	required_temp = 374
	result_amount = 1

/datum/chemical_reaction/sonic_powder_deafen/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	playsound(location, 'sound/effects/bang.ogg', 25, 1)
	for(var/mob/living/carbon/C in get_hearers_in_view(created_volume/10, location))
		if(C.check_ear_prot())
			continue
		C.show_message("<span class='warning'>BANG</span>", 2)
		C.Stun(5)
		C.Weaken(5)
		C.setEarDamage(C.ear_damage + rand(0, 5), max(C.ear_deaf,15))
		if(C.ear_damage >= 15)
			C << "<span class='warning'>Your ears start to ring badly!</span>"
		else if(C.ear_damage >= 5)
			C << "<span class='warning'>Your ears start to ring!</span>"


/datum/chemical_reaction/phlogiston
	name = "phlogiston"
	id = "phlogiston"
	result = "phlogiston"
	required_reagents = list("phosphorus" = 1, "sacid" = 1, "stable_plasma" = 1)
	result_amount = 3

/datum/chemical_reaction/phlogiston/on_reaction(datum/reagents/holder, created_volume)
	if(holder.has_reagent("stabilizing_agent"))
		return
	var/turf/open/T = get_turf(holder.my_atom)
	if(istype(T))
		T.atmos_spawn_air("plasma=[created_volume];TEMP=1000")
	holder.clear_reagents()
	return


/datum/chemical_reaction/napalm
	name = "Napalm"
	id = "napalm"
	result = "napalm"
	required_reagents = list("oil" = 1, "welding_fuel" = 1, "ethanol" = 1 )
	result_amount = 3


/datum/chemical_reaction/cryostylane
	name = "cryostylane"
	id = "cryostylane"
	result = "cryostylane"
	required_reagents = list("water" = 1, "stable_plasma" = 1, "nitrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/cryostylane/on_reaction(datum/reagents/holder, created_volume)
	holder.chem_temp = 20 // cools the fuck down
	return


/datum/chemical_reaction/pyrosium
	name = "pyrosium"
	id = "pyrosium"
	result = "pyrosium"
	required_reagents = list("stable_plasma" = 1, "radium" = 1, "phosphorus" = 1)
	result_amount = 3

/datum/chemical_reaction/pyrosium/on_reaction(datum/reagents/holder, created_volume)
	holder.chem_temp = 20 // also cools the fuck down
	return
