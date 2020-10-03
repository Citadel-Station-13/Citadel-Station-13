/datum/chemical_reaction/reagent_explosion
	name = "Generic explosive"
	id = "reagent_explosion"
	var/strengthdiv = 10
	var/modifier = 0
	var/noexplosion = FALSE

/datum/chemical_reaction/reagent_explosion/on_reaction(datum/reagents/holder, multiplier, turf/override)
	if(!noexplosion)
		var/turf/T = override || get_turf(holder.my_atom)
		var/inside_msg
		if(ismob(holder.my_atom))
			var/mob/M = holder.my_atom
			inside_msg = " inside [ADMIN_LOOKUPFLW(M)]"
		var/lastkey = holder.my_atom.fingerprintslast
		var/touch_msg = "N/A"
		if(lastkey)
			var/mob/toucher = get_mob_by_key(lastkey)
			touch_msg = "[ADMIN_LOOKUPFLW(toucher)]"
		message_admins("Reagent explosion reaction occurred at [ADMIN_VERBOSEJMP(T)][inside_msg]. Last Fingerprint: [touch_msg].")
		log_game("Reagent explosion reaction occurred at [AREACOORD(T)]. Last Fingerprint: [lastkey ? lastkey : "N/A"]." )
		var/datum/effect_system/reagents_explosion/e = new()
		e.set_up(modifier + round(multiplier/strengthdiv, 1), T, 0, 0)
		e.start()
	holder.clear_reagents()


/datum/chemical_reaction/reagent_explosion/nitroglycerin
	name = "Nitroglycerin"
	id = /datum/reagent/nitroglycerin
	results = list(/datum/reagent/nitroglycerin = 2)
	required_reagents = list(/datum/reagent/glycerol = 1, /datum/reagent/toxin/acid/fluacid = 1, /datum/reagent/toxin/acid = 1)
	strengthdiv = 2

/datum/chemical_reaction/reagent_explosion/nitroglycerin/on_reaction(datum/reagents/holder, multiplier)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	holder.remove_reagent(/datum/reagent/nitroglycerin, multiplier*2)
	..()

/datum/chemical_reaction/reagent_explosion/nitroglycerin_explosion
	name = "Nitroglycerin explosion"
	id = "nitroglycerin_explosion"
	required_reagents = list(/datum/reagent/nitroglycerin = 1)
	required_temp = 474
	strengthdiv = 2


/datum/chemical_reaction/reagent_explosion/potassium_explosion
	name = "Explosion"
	id = "potassium_explosion"
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/potassium = 1)
	strengthdiv = 10

/datum/chemical_reaction/reagent_explosion/potassium_explosion/holyboom
	name = "Holy Explosion"
	id = "holyboom"
	required_reagents = list(/datum/reagent/water/holywater = 1, /datum/reagent/potassium = 1)

/datum/chemical_reaction/reagent_explosion/potassium_explosion/holyboom/on_reaction(datum/reagents/holder, multiplier)
	var/turf/T = get_turf(holder.my_atom)
	if(multiplier >= 150)
		playsound(get_turf(holder.my_atom), 'sound/effects/pray.ogg', 80, 0, round(multiplier/48))
		strengthdiv = 8
		for(var/mob/living/simple_animal/revenant/R in get_hearers_in_view(7,get_turf(holder.my_atom)))
			var/deity
			if(GLOB.deity)
				deity = GLOB.deity
			else
				deity = "Christ"
			to_chat(R, "<span class='userdanger'>The power of [deity] compels you!</span>")
			R.stun(20)
			R.reveal(100)
			R.adjustHealth(50)
		sleep(20)
		for(var/mob/living/carbon/C in get_hearers_in_view(round(multiplier/48,1),get_turf(holder.my_atom)))
			if(iscultist(C))
				to_chat(C, "<span class='userdanger'>The divine explosion sears you!</span>")
				C.DefaultCombatKnockdown(40)
				C.adjust_fire_stacks(5)
				C.IgniteMob()
	..(holder, multiplier, T)


/datum/chemical_reaction/blackpowder
	name = "Black Powder"
	id = /datum/reagent/blackpowder
	results = list(/datum/reagent/blackpowder = 3)
	required_reagents = list(/datum/reagent/saltpetre = 1, /datum/reagent/medicine/charcoal = 1, /datum/reagent/sulfur = 1)

/datum/chemical_reaction/reagent_explosion/blackpowder_explosion
	name = "Black Powder Kaboom"
	id = "blackpowder_explosion"
	required_reagents = list(/datum/reagent/blackpowder = 1)
	required_temp = 474
	strengthdiv = 6
	modifier = 1
	mix_message = "<span class='boldannounce'>Sparks start flying around the black powder!</span>"

/datum/chemical_reaction/reagent_explosion/blackpowder_explosion/on_reaction(datum/reagents/holder, multiplier)
	var/turf/T = get_turf(holder.my_atom)
	..(holder, multiplier, T)

/datum/chemical_reaction/thermite
	name = "Thermite"
	id = /datum/reagent/thermite
	results = list(/datum/reagent/thermite = 3)
	required_reagents = list(/datum/reagent/aluminium = 1, /datum/reagent/iron = 1, /datum/reagent/oxygen = 1)

/datum/chemical_reaction/emp_pulse
	name = "EMP Pulse"
	id = "emp_pulse"
	required_reagents = list(/datum/reagent/uranium = 1, /datum/reagent/iron = 1) // Yes, laugh, it's the best recipe I could think of that makes a little bit of sense

/datum/chemical_reaction/emp_pulse/on_reaction(datum/reagents/holder, multiplier)
	var/location = get_turf(holder.my_atom)
	// 100 multiplier = 4 heavy range & 7 light range. A few tiles smaller than traitor EMP grandes.
	// 200 multiplier = 8 heavy range & 14 light range. 4 tiles larger than traitor EMP grenades.
	empulse(location, round(multiplier / 12), round(multiplier / 7), 1)
	holder.clear_reagents()


/datum/chemical_reaction/beesplosion
	name = "Bee Explosion"
	id = "beesplosion"
	required_reagents = list(/datum/reagent/consumable/honey = 1, /datum/reagent/medicine/strange_reagent = 1, /datum/reagent/radium = 1)

/datum/chemical_reaction/beesplosion/on_reaction(datum/reagents/holder, multiplier)
	var/location = holder.my_atom.drop_location()
	if(multiplier < 5)
		playsound(location,'sound/effects/sparks1.ogg', 100, TRUE)
	else
		playsound(location,'sound/creatures/bee.ogg', 100, TRUE)
		var/list/beeagents = list()
		for(var/X in holder.reagent_list)
			var/datum/reagent/R = X
			if(required_reagents[R.type])
				continue
			beeagents += R
		var/bee_amount = round(multiplier * 0.2)
		for(var/i in 1 to bee_amount)
			var/mob/living/simple_animal/hostile/poison/bees/short/new_bee = new(location)
			if(LAZYLEN(beeagents))
				new_bee.assign_reagent(pick(beeagents))


/datum/chemical_reaction/stabilizing_agent
	name = "stabilizing_agent"
	id = /datum/reagent/stabilizing_agent
	results = list(/datum/reagent/stabilizing_agent = 3)
	required_reagents = list(/datum/reagent/iron = 1, /datum/reagent/oxygen = 1, /datum/reagent/hydrogen = 1)

/datum/chemical_reaction/clf3
	name = "Chlorine Trifluoride"
	id = /datum/reagent/clf3
	results = list(/datum/reagent/clf3 = 4)
	required_reagents = list(/datum/reagent/chlorine = 1, /datum/reagent/fluorine = 3)
	required_temp = 424

/datum/chemical_reaction/clf3/on_reaction(datum/reagents/holder, multiplier)
	var/turf/T = get_turf(holder.my_atom)
	for(var/turf/turf in range(1,T))
		new /obj/effect/hotspot(turf)
	holder.chem_temp = 1000 // hot as shit

/datum/chemical_reaction/reagent_explosion/methsplosion
	name = "Meth explosion"
	id = "methboom1"
	required_temp = 380 //slightly above the meth mix time.
	required_reagents = list(/datum/reagent/drug/methamphetamine = 1)
	strengthdiv = 6
	modifier = 1
	mob_react = FALSE

/datum/chemical_reaction/reagent_explosion/methsplosion/on_reaction(datum/reagents/holder, multiplier)
	var/turf/T = get_turf(holder.my_atom)
	for(var/turf/turf in range(1,T))
		new /obj/effect/hotspot(turf)
	holder.chem_temp = 1000 // hot as shit
	..()

/datum/chemical_reaction/reagent_explosion/methsplosion/methboom2
	id = "methboom2"
	required_reagents = list(/datum/reagent/diethylamine = 1, /datum/reagent/iodine = 1, /datum/reagent/phosphorus = 1, /datum/reagent/hydrogen = 1) //diethylamine is often left over from mixing the ephedrine.
	required_temp = 300 //room temperature, chilling it even a little will prevent the explosion

/datum/chemical_reaction/sorium
	name = "Sorium"
	id = /datum/reagent/sorium
	results = list(/datum/reagent/sorium = 4)
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/oxygen = 1, /datum/reagent/nitrogen = 1, /datum/reagent/carbon = 1)

/datum/chemical_reaction/sorium/on_reaction(datum/reagents/holder, multiplier)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	holder.remove_reagent(/datum/reagent/sorium, multiplier*4)
	var/turf/T = get_turf(holder.my_atom)
	var/range = clamp(sqrt(multiplier*4), 1, 6)
	goonchem_vortex(T, 1, range)

/datum/chemical_reaction/sorium_vortex
	name = "sorium_vortex"
	id = "sorium_vortex"
	required_reagents = list(/datum/reagent/sorium = 1)
	required_temp = 474

/datum/chemical_reaction/sorium_vortex/on_reaction(datum/reagents/holder, multiplier)
	var/turf/T = get_turf(holder.my_atom)
	var/range = clamp(sqrt(multiplier), 1, 6)
	goonchem_vortex(T, 1, range)

/datum/chemical_reaction/liquid_dark_matter
	name = "Liquid Dark Matter"
	id = /datum/reagent/liquid_dark_matter
	results = list(/datum/reagent/liquid_dark_matter = 3)
	required_reagents = list(/datum/reagent/stable_plasma = 1, /datum/reagent/radium = 1, /datum/reagent/carbon = 1)

/datum/chemical_reaction/liquid_dark_matter/on_reaction(datum/reagents/holder, multiplier)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	holder.remove_reagent(/datum/reagent/liquid_dark_matter, multiplier*3)
	var/turf/T = get_turf(holder.my_atom)
	var/range = clamp(sqrt(multiplier*3), 1, 6)
	goonchem_vortex(T, 0, range)

/datum/chemical_reaction/ldm_vortex
	name = "LDM Vortex"
	id = "ldm_vortex"
	required_reagents = list(/datum/reagent/liquid_dark_matter = 1)
	required_temp = 474

/datum/chemical_reaction/ldm_vortex/on_reaction(datum/reagents/holder, multiplier)
	var/turf/T = get_turf(holder.my_atom)
	var/range = clamp(sqrt(multiplier/2), 1, 6)
	goonchem_vortex(T, 0, range)

/datum/chemical_reaction/flash_powder
	name = "Flash powder"
	id = /datum/reagent/flash_powder
	results = list(/datum/reagent/flash_powder = 3)
	required_reagents = list(/datum/reagent/aluminium = 1, /datum/reagent/potassium = 1, /datum/reagent/sulfur = 1 )

/datum/chemical_reaction/flash_powder/on_reaction(datum/reagents/holder, multiplier)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	var/location = get_turf(holder.my_atom)
	do_sparks(2, TRUE, location)
	var/range = multiplier/3
	if(isatom(holder.my_atom))
		var/atom/A = holder.my_atom
		A.flash_lighting_fx(_range = (range + 2), _reset_lighting = FALSE)
	for(var/mob/living/carbon/C in get_hearers_in_view(range, location))
		if(C.flash_act())
			if(get_dist(C, location) < 4)
				C.DefaultCombatKnockdown(60)
			else
				C.Stun(100)
	holder.remove_reagent(/datum/reagent/flash_powder, multiplier*3)

/datum/chemical_reaction/flash_powder_flash
	name = "Flash powder activation"
	id = "flash_powder_flash"
	required_reagents = list(/datum/reagent/flash_powder = 1)
	required_temp = 374

/datum/chemical_reaction/flash_powder_flash/on_reaction(datum/reagents/holder, multiplier)
	var/location = get_turf(holder.my_atom)
	do_sparks(2, TRUE, location)
	var/range = multiplier/10
	if(isatom(holder.my_atom))
		var/atom/A = holder.my_atom
		A.flash_lighting_fx(_range = (range + 2), _reset_lighting = FALSE)
	for(var/mob/living/carbon/C in get_hearers_in_view(range, location))
		if(C.flash_act())
			if(get_dist(C, location) < 4)
				C.DefaultCombatKnockdown(60)
			else
				C.Stun(100)

/datum/chemical_reaction/smoke_powder
	name = "smoke_powder"
	id = /datum/reagent/smoke_powder
	results = list(/datum/reagent/smoke_powder = 3)
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/consumable/sugar = 1, /datum/reagent/phosphorus = 1)

/datum/chemical_reaction/smoke_powder/on_reaction(datum/reagents/holder, multiplier)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	holder.remove_reagent(/datum/reagent/smoke_powder, multiplier*3)
	var/smoke_radius = round(sqrt(multiplier * 1.5), 1)
	var/location = get_turf(holder.my_atom)
	var/datum/effect_system/smoke_spread/chem/S = new
	S.attach(location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	if(S)
		S.set_up(holder, smoke_radius, location, 0)
		S.start()
	if(holder && holder.my_atom)
		holder.clear_reagents()

/datum/chemical_reaction/smoke_powder_smoke
	name = "smoke_powder_smoke"
	id = "smoke_powder_smoke"
	required_reagents = list(/datum/reagent/smoke_powder = 1)
	required_temp = 374
	mob_react = FALSE

/datum/chemical_reaction/smoke_powder_smoke/on_reaction(datum/reagents/holder, multiplier)
	var/location = get_turf(holder.my_atom)
	var/smoke_radius = round(sqrt(multiplier / 2), 1)
	var/datum/effect_system/smoke_spread/chem/S = new
	S.attach(location)
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	if(S)
		S.set_up(holder, smoke_radius, location, 0)
		S.start()
	if(holder && holder.my_atom)
		holder.clear_reagents()

/datum/chemical_reaction/sonic_powder
	name = "sonic_powder"
	id = /datum/reagent/sonic_powder
	results = list(/datum/reagent/sonic_powder = 3)
	required_reagents = list(/datum/reagent/oxygen = 1, /datum/reagent/consumable/space_cola = 1, /datum/reagent/phosphorus = 1)

/datum/chemical_reaction/sonic_powder/on_reaction(datum/reagents/holder, multiplier)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	holder.remove_reagent(/datum/reagent/sonic_powder, multiplier*3)
	var/location = get_turf(holder.my_atom)
	playsound(location, 'sound/effects/bang.ogg', 25, 1)
	for(var/mob/living/carbon/C in get_hearers_in_view(multiplier/3, location))
		C.soundbang_act(1, 100, rand(0, 5))

/datum/chemical_reaction/sonic_powder_deafen
	name = "sonic_powder_deafen"
	id = "sonic_powder_deafen"
	required_reagents = list(/datum/reagent/sonic_powder = 1)
	required_temp = 374

/datum/chemical_reaction/sonic_powder_deafen/on_reaction(datum/reagents/holder, multiplier)
	var/location = get_turf(holder.my_atom)
	playsound(location, 'sound/effects/bang.ogg', 25, 1)
	for(var/mob/living/carbon/C in get_hearers_in_view(multiplier/10, location))
		C.soundbang_act(1, 100, rand(0, 5))

/datum/chemical_reaction/phlogiston
	name = "phlogiston"
	id = /datum/reagent/phlogiston
	results = list(/datum/reagent/phlogiston = 3)
	required_reagents = list(/datum/reagent/phosphorus = 1, /datum/reagent/toxin/acid = 1, /datum/reagent/stable_plasma = 1)

/datum/chemical_reaction/phlogiston/on_reaction(datum/reagents/holder, multiplier)
	if(holder.has_reagent(/datum/reagent/stabilizing_agent))
		return
	var/turf/open/T = get_turf(holder.my_atom)
	if(istype(T))
		T.atmos_spawn_air("plasma=[multiplier];TEMP=1000")
	holder.clear_reagents()
	return

/datum/chemical_reaction/napalm
	name = "Napalm"
	id = /datum/reagent/napalm
	results = list(/datum/reagent/napalm = 3)
	required_reagents = list(/datum/reagent/oil = 1, /datum/reagent/fuel = 1, /datum/reagent/consumable/ethanol = 1 )

/datum/chemical_reaction/cryostylane
	name = "cryostylane"
	id = /datum/reagent/cryostylane
	results = list(/datum/reagent/cryostylane = 3)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/stable_plasma = 1, /datum/reagent/nitrogen = 1)

/datum/chemical_reaction/cryostylane/on_reaction(datum/reagents/holder, multiplier)
	holder.chem_temp = 20 // cools the fuck down
	return

/datum/chemical_reaction/cryostylane_oxygen
	name = "ephemeral cryostylane reaction"
	id = "cryostylane_oxygen"
	results = list(/datum/reagent/cryostylane = 1)
	required_reagents = list(/datum/reagent/cryostylane = 1, /datum/reagent/oxygen = 1)
	mob_react = FALSE

/datum/chemical_reaction/cryostylane_oxygen/on_reaction(datum/reagents/holder, multiplier)
	holder.chem_temp = max(holder.chem_temp - 10*multiplier,0)

/datum/chemical_reaction/pyrosium_oxygen
	name = "ephemeral pyrosium reaction"
	id = "pyrosium_oxygen"
	results = list(/datum/reagent/pyrosium = 1)
	required_reagents = list(/datum/reagent/pyrosium = 1, /datum/reagent/oxygen = 1)
	mob_react = FALSE

/datum/chemical_reaction/pyrosium_oxygen/on_reaction(datum/reagents/holder, multiplier)
	holder.chem_temp += 10*multiplier

/datum/chemical_reaction/pyrosium
	name = "pyrosium"
	id = /datum/reagent/pyrosium
	results = list(/datum/reagent/pyrosium = 3)
	required_reagents = list(/datum/reagent/stable_plasma = 1, /datum/reagent/radium = 1, /datum/reagent/phosphorus = 1)

/datum/chemical_reaction/pyrosium/on_reaction(datum/reagents/holder, multiplier)
	holder.chem_temp = 20 // also cools the fuck down
	return

/datum/chemical_reaction/teslium
	name = "Teslium"
	id = /datum/reagent/teslium
	results = list(/datum/reagent/teslium = 3)
	required_reagents = list(/datum/reagent/stable_plasma = 1, /datum/reagent/silver = 1, /datum/reagent/blackpowder = 1)
	mix_message = "<span class='danger'>A jet of sparks flies from the mixture as it merges into a flickering slurry.</span>"
	required_temp = 400

/datum/chemical_reaction/energized_jelly
	name = "Energized Jelly"
	id = /datum/reagent/teslium/energized_jelly
	results = list(/datum/reagent/teslium/energized_jelly = 2)
	required_reagents = list(/datum/reagent/toxin/slimejelly = 1, /datum/reagent/teslium = 1)
	mix_message = "<span class='danger'>The slime jelly starts glowing intermittently.</span>"

/datum/chemical_reaction/reagent_explosion/teslium_lightning
	name = "Teslium Destabilization"
	id = "teslium_lightning"
	required_reagents = list(/datum/reagent/teslium = 1, /datum/reagent/water = 1)
	strengthdiv = 100
	modifier = -100
	noexplosion = TRUE
	mix_message = "<span class='boldannounce'>The teslium starts to spark as electricity arcs away from it!</span>"
	mix_sound = 'sound/machines/defib_zap.ogg'
	var/zap_flags = ZAP_MOB_DAMAGE | ZAP_OBJ_DAMAGE | ZAP_MOB_STUN

/datum/chemical_reaction/reagent_explosion/teslium_lightning/on_reaction(datum/reagents/holder, multiplier)
	var/T1 = multiplier * 20		//100 units : Zap 3 times, with powers 2000/5000/12000. Tesla revolvers have a power of 10000 for comparison.
	var/T2 = multiplier * 50
	var/T3 = multiplier * 120
	sleep(5)
	if(multiplier >= 75)
		tesla_zap(holder.my_atom, 7, T1, zap_flags)
		playsound(holder.my_atom, 'sound/machines/defib_zap.ogg', 50, 1)
		sleep(15)
	if(multiplier >= 40)
		tesla_zap(holder.my_atom, 7, T2, zap_flags)
		playsound(holder.my_atom, 'sound/machines/defib_zap.ogg', 50, 1)
		sleep(15)
	if(multiplier >= 10)			//10 units minimum for lightning, 40 units for secondary blast, 75 units for tertiary blast.
		tesla_zap(holder.my_atom, 7, T3, zap_flags)
		playsound(holder.my_atom, 'sound/machines/defib_zap.ogg', 50, 1)
	..()

/datum/chemical_reaction/reagent_explosion/teslium_lightning/heat
	id = "teslium_lightning2"
	required_temp = 474
	required_reagents = list(/datum/reagent/teslium = 1)

/datum/chemical_reaction/reagent_explosion/nitrous_oxide
	name = "N2O explosion"
	id = "n2o_explosion"
	required_reagents = list(/datum/reagent/nitrous_oxide = 1)
	strengthdiv = 7
	required_temp = 575
	modifier = 1

/datum/chemical_reaction/firefighting_foam
	name = "Firefighting Foam"
	id = /datum/reagent/firefighting_foam
	results = list(/datum/reagent/firefighting_foam = 3)
	required_reagents = list(/datum/reagent/stabilizing_agent = 1, /datum/reagent/fluorosurfactant = 1,/datum/reagent/carbon = 1)
	required_temp = 200
	is_cold_recipe = 1

/datum/chemical_reaction/reagent_explosion/lingblood
	name = "Changeling Blood Reaction"
	id = "ling_blood_reaction"
	results = list(/datum/reagent/ash = 1)
	required_reagents = list(/datum/reagent/blood = 1)
	strengthdiv = 4 //The explosion should be somewhat strong if a full 15u is heated within a syringe. !!fun!!
	required_temp = 666
	special_react = TRUE
	mix_sound = 'sound/effects/lingbloodhiss.ogg'
	mix_message = "The blood bubbles and sizzles violently!"

/datum/chemical_reaction/reagent_explosion/lingblood/check_special_react(datum/reagents/holder)
	if(!holder)
		return FALSE
	var/list/D = holder.get_data("blood")
	if(D && D["changeling_loudness"])
		return (D["changeling_loudness"] >= 4 ? D["changeling_loudness"] : FALSE)
	else
		return FALSE

/datum/chemical_reaction/reagent_explosion/lingblood/on_reaction(datum/reagents/holder, multiplier, specialreact)
	if(specialreact >= 10)
		return ..()
	else
		return FALSE
