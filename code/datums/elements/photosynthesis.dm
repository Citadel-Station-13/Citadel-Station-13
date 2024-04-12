/datum/element/photosynthesis
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2
	///how much brute damage (or integrity, for objects) is healed (taken if positive) at maximum luminosity. (if lum_minus were 0)
	var/light_bruteheal = -1
	///how much burn damage is restored/taken at maximum luminosity. Mobs only.
	var/light_burnheal = -1
	///how much tox damage is restored/taken at maximum luminosity. Mobs only.
	var/light_toxheal = -1
	///how much oxy damage is restored/taken at maximum luminosity. Mobs only.
	var/light_oxyheal = -1
	///how nutrition recovery/expenses factor, not affected by bonus_lum and malus_lum. Mobs only.
	var/light_nutrition_gain = 4
	///A value subtracted to the lum count, which allows targets to wilt or heal in the darkness.
	var/lum_minus = 0.5
	///the minimum lum count over which where the target damage is adjusted.
	var/bonus_lum = 0.2
	///the maximum lum count under which the target damage is inversely adjusted.
	var/malus_lum = 0
	///List of atoms this element is attached to. Doubles as a multiplier if the same element is attached multiple times to a target multiple times.
	var/list/attached_atoms

/datum/element/photosynthesis/Attach(datum/target, brute = -1, burn = -1, tox = -1, oxy = -1, nutri = 4, minus = 0.2, bonus = 0.3, malus = -0.1)
	. = ..()
	if(. == ELEMENT_INCOMPATIBLE || !(isliving(target) || (isobj(target) && light_bruteheal)))
		return ELEMENT_INCOMPATIBLE
	light_bruteheal = brute
	light_burnheal = burn
	light_toxheal = tox
	light_oxyheal = oxy
	light_nutrition_gain = nutri
	lum_minus = minus
	bonus_lum = bonus
	malus_lum = malus

	if(!attached_atoms)
		attached_atoms = list()
		START_PROCESSING(SSobj, src)
	attached_atoms[target]++

/datum/element/photosynthesis/Detach(datum/target)
	if(LAZYLEN(attached_atoms))
		attached_atoms[target]--
		if(!attached_atoms[target])
			attached_atoms -= target
			if(!length(attached_atoms))
				STOP_PROCESSING(SSobj, src)
				attached_atoms = null
	return ..()

/datum/element/photosynthesis/process()
	for(var/A in attached_atoms)
		var/atom/movable/AM = A
		var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
		if(isturf(AM.loc)) //else, there's considered to be no light
			var/turf/T = AM.loc
			light_amount = (T.get_lumcount() - lum_minus)

		if(isliving(AM))
			var/mob/living/L = AM
			if(L.stat == DEAD)
				continue
			if(light_nutrition_gain && L.nutrition < NUTRITION_LEVEL_WELL_FED)
				L.adjust_nutrition(light_amount * light_nutrition_gain * attached_atoms[AM], NUTRITION_LEVEL_WELL_FED)
			if(light_amount > bonus_lum || light_amount < malus_lum)
				var/mult = ((light_amount > bonus_lum) ? 1 : -1) * attached_atoms[AM]
				if(light_bruteheal)
					L.adjustBruteLoss(light_bruteheal * mult)
				if(light_burnheal)
					L.adjustFireLoss(light_burnheal * mult)
				if(light_toxheal)
					L.adjustToxLoss(light_toxheal * mult)
				if(light_oxyheal)
					L.adjustOxyLoss(light_oxyheal * mult)

		else if(light_amount > bonus_lum || light_amount < malus_lum)
			var/obj/O = AM
			var/damage = light_bruteheal * ((light_amount > bonus_lum) ? 1 : -1) * attached_atoms[AM]
			if(damage < 0 && O.obj_integrity < O.max_integrity)
				O.obj_integrity = min(O.obj_integrity + damage, O.max_integrity) //Till we get a obj heal proc...
			else
				O.take_damage(damage, BRUTE, FALSE, FALSE, null, 100)
