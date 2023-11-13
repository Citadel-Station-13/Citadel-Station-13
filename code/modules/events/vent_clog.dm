/datum/round_event_control/vent_clog
	name = "Clogged Vents: Normal"
	typepath = /datum/round_event/vent_clog
	weight = 10
	max_occurrences = 3
	category = EVENT_CATEGORY_HEALTH
	description = "All the scrubbers onstation spit random chemicals in smoke form."

/datum/round_event/vent_clog
	announce_when	= 1
	start_when		= 5
	end_when			= 35
	var/interval 	= 2
	var/list/vents  = list()
	var/randomProbability = 0
	var/reagentsAmount = 100
	var/list/saferChems = list(
		/datum/reagent/water,
		/datum/reagent/carbon,
		/datum/reagent/consumable/flour,
		/datum/reagent/space_cleaner,
		/datum/reagent/consumable/nutriment,
		/datum/reagent/consumable/condensedcapsaicin,
		/datum/reagent/drug/mushroomhallucinogen,
		/datum/reagent/lube,
		/datum/reagent/glitter/pink,
		/datum/reagent/cryptobiolin,
		/datum/reagent/toxin/plantbgone,
		/datum/reagent/blood,
		/datum/reagent/medicine/charcoal,
		/datum/reagent/drug/space_drugs,
		/datum/reagent/medicine/morphine,
		/datum/reagent/water/holywater,
		/datum/reagent/consumable/ethanol,
		/datum/reagent/consumable/hot_coco,
		/datum/reagent/toxin/acid,
		/datum/reagent/toxin/mindbreaker,
		/datum/reagent/toxin/rotatium,
		/datum/reagent/bluespace,
		/datum/reagent/pax,
		/datum/reagent/consumable/laughter,
		/datum/reagent/concentrated_barbers_aid,
		/datum/reagent/baldium,
		/datum/reagent/colorful_reagent,
		/datum/reagent/peaceborg_confuse,
		/datum/reagent/peaceborg_tire,
		/datum/reagent/consumable/sodiumchloride,
		/datum/reagent/consumable/ethanol/beer,
		/datum/reagent/hair_dye,
		/datum/reagent/consumable/sugar,
		/datum/reagent/glitter/white,
		/datum/reagent/growthserum,
		/datum/reagent/consumable/cornoil,
		/datum/reagent/uranium,
		/datum/reagent/carpet,
		/datum/reagent/firefighting_foam,
		/datum/reagent/consumable/tearjuice,
		/datum/reagent/medicine/strange_reagent

	)
	//needs to be chemid unit checked at some point

/datum/round_event/vent_clog/announce()
	priority_announce("The scrubbers network is experiencing a backpressure surge. Some ejection of contents may occur.", "Atmospherics alert", has_important_message = TRUE)

/datum/round_event/vent_clog/setup()
	end_when = rand(120, 180)
	for(var/obj/machinery/atmospherics/components/unary/vent_scrubber/temp_vent in GLOB.machines)
		var/turf/T = get_turf(temp_vent)
		var/area/A = T.loc
		if(T && is_station_level(T.z) && !temp_vent.welded && !A.safe)
			vents += temp_vent

	if(!vents.len)
		return kill()

/datum/round_event/vent_clog/tick()

	if(!vents.len)
		return kill()

	CHECK_TICK

	var/obj/machinery/atmospherics/components/unary/vent = pick(vents)
	vents -= vent

	if(!vent || vent.welded)
		return

	var/turf/T = get_turf(vent)
	if(!T)
		return

	var/datum/reagents/R = new/datum/reagents(1000)
	R.my_atom = vent
	if (randomProbability && prob(randomProbability))
		R.add_reagent(get_random_reagent_id(), reagentsAmount)
	else
		R.add_reagent(pick(saferChems), reagentsAmount)

	var/datum/effect_system/smoke_spread/chem/smoke_machine/C = new
	C.set_up(R,16,1,T)
	C.start()
	playsound(T, 'sound/effects/smoke.ogg', 50, 1, -3)

/datum/round_event_control/vent_clog/threatening
	name = "Clogged Vents: Threatening"
	typepath = /datum/round_event/vent_clog/threatening
	weight = 4
	min_players = 15
	max_occurrences = 1
	earliest_start = 35 MINUTES
	description = "Extra dangerous chemicals come out of the scrubbers."

/datum/round_event/vent_clog/threatening
	randomProbability = 10
	reagentsAmount = 200

/datum/round_event_control/vent_clog/catastrophic
	name = "Clogged Vents: Catastrophic"
	typepath = /datum/round_event/vent_clog/catastrophic
	weight = 2
	min_players = 25
	max_occurrences = 1
	earliest_start = 45 MINUTES
	description = "EXTREMELY dangerous chemicals come out of the scrubbers."

/datum/round_event/vent_clog/catastrophic
	randomProbability = 30
	reagentsAmount = 250

/datum/round_event_control/vent_clog/beer
	name = "Clogged Vents: Beer"
	typepath = /datum/round_event/vent_clog/beer
	max_occurrences = 0
	description = "Spits out beer through the scrubber system."

/datum/round_event/vent_clog/beer
	reagentsAmount = 100

/datum/round_event_control/vent_clog/plasma_decon
	name = "Anti-Plasma Flood"
	typepath = /datum/round_event/vent_clog/plasma_decon
	max_occurrences = 0
	description = "Freezing smoke comes out of the scrubbers."

/datum/round_event/vent_clog/beer/announce()
	priority_announce("The scrubbers network is experiencing an unexpected surge of pressurized beer. Some ejection of contents may occur.", "Atmospherics alert")

/datum/round_event/vent_clog/beer/start()
	for(var/obj/machinery/atmospherics/components/unary/vent in vents)
		if(vent && vent.loc && !vent.welded)
			var/datum/reagents/R = new/datum/reagents(1000)
			R.my_atom = vent
			R.add_reagent(/datum/reagent/consumable/ethanol/beer, reagentsAmount)

			var/datum/effect_system/foam_spread/foam = new
			foam.set_up(200, get_turf(vent), R)
			foam.start()
		CHECK_TICK

/datum/round_event/vent_clog/plasma_decon/announce()
	priority_announce("We are deploying an experimental plasma decontamination system. Please stand away from the vents and do not breathe the smoke that comes out.", "Central Command Update")

/datum/round_event/vent_clog/plasma_decon/start()
	for(var/obj/machinery/atmospherics/components/unary/vent in vents)
		if(vent && vent.loc && !vent.welded)
			var/datum/effect_system/smoke_spread/freezing/decon/smoke = new
			smoke.set_up(7, get_turf(vent), 7)
			smoke.start()
		CHECK_TICK
