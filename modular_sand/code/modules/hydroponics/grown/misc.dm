/obj/item/seeds/bamboo
	mutatelist = list(/obj/item/seeds/bamboo/oxyboo, /obj/item/seeds/bamboo/nitroboo, /obj/item/seeds/bamboo/plasboo)
//Oxyboo
/obj/item/seeds/bamboo/oxyboo
	name = "pack of Oxyboo seeds"
	desc = "A species of bamboo that produces elevated levels of oxygen. The gas stops being produced in difficult atmospheric conditions."
	plantname = "Oxyboo"
	genes = list()
	mutatelist = list()

/obj/item/seeds/bamboo/oxyboo/pre_attack(obj/machinery/hydroponics/I)
	if(istype(I, /obj/machinery/hydroponics))
		if(!I.myseed)
			START_PROCESSING(SSobj, src)
	return ..()

/obj/item/seeds/bamboo/oxyboo/process()
	var/obj/machinery/hydroponics/parent = loc
	if(parent.age < maturation) // Start a little before it blooms
		return

	var/turf/open/T = get_turf(parent)
	if(abs(ONE_ATMOSPHERE - T.return_air().return_pressure()) > (potency/10 + 10)) // clouds can begin showing at around 50-60 potency in standard atmos
		return

	var/datum/gas_mixture/oxy = new
	oxy.adjust_moles(/datum/gas/oxygen, (yield + 6)*7*0.02) // this process is only being called about 2/7 as much as corpses so this is 12-32 times a corpses
	oxy.return_temperature(T20C) // without this the room would eventually freeze and miasma mining would be easier
	T.assume_air(oxy)
	T.air_update_turf()

/obj/item/seeds/bamboo/nitroboo
	name = "pack of Nitroboo seeds"
	desc = "A species of bamboo that produces elevated levels of nitrogen. The gas stops being produced in difficult atmospheric conditions."
	plantname = "Nitroboo"
	genes = list()
	mutatelist = list()

/obj/item/seeds/bamboo/nitroboo/pre_attack(obj/machinery/hydroponics/I)
	if(istype(I, /obj/machinery/hydroponics))
		if(!I.myseed)
			START_PROCESSING(SSobj, src)
	return ..()

/obj/item/seeds/bamboo/nitroboo/process()
	var/obj/machinery/hydroponics/parent = loc
	if(parent.age < maturation) // Start a little before it blooms
		return

	var/turf/open/T = get_turf(parent)
	if(abs(ONE_ATMOSPHERE - T.return_air().return_pressure()) > (potency/10 + 10)) // clouds can begin showing at around 50-60 potency in standard atmos
		return

	var/datum/gas_mixture/nitro = new
	nitro.adjust_moles(/datum/gas/nitrogen, (yield + 6)*7*0.02) // this process is only being called about 2/7 as much as corpses so this is 12-32 times a corpses
	nitro.return_temperature(T20C) // without this the room would eventually freeze and miasma mining would be easier
	T.assume_air(nitro)
	T.air_update_turf()

/obj/item/seeds/bamboo/plasboo
	name = "pack of Plasboo seeds"
	desc = "A species of bamboo that produces elevated levels of plasma. The gas stops being produced in difficult atmospheric conditions."
	plantname = "Plasboo"
	genes = list()
	mutatelist = list()

/obj/item/seeds/bamboo/plasboo/pre_attack(obj/machinery/hydroponics/I)
	if(istype(I, /obj/machinery/hydroponics))
		if(!I.myseed)
			START_PROCESSING(SSobj, src)
	return ..()

/obj/item/seeds/bamboo/plasboo/process()
	var/obj/machinery/hydroponics/parent = loc
	if(parent.age < maturation) // Start a little before it blooms
		return

	var/turf/open/T = get_turf(parent)
	if(abs(ONE_ATMOSPHERE - T.return_air().return_pressure()) > (potency/10 + 10)) // clouds can begin showing at around 50-60 potency in standard atmos
		return

	var/datum/gas_mixture/plas = new
	plas.adjust_moles(/datum/gas/plasma, (yield + 6)*7*0.02) // this process is only being called about 2/7 as much as corpses so this is 12-32 times a corpses
	plas.return_temperature(T20C) // without this the room would eventually freeze and miasma mining would be easier
	T.assume_air(plas)
	T.air_update_turf()

//I actually have no idea no idea why i fixed this for monstermos, but swayde, you owe me one!
