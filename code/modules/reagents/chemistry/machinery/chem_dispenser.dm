/obj/machinery/chem_dispenser
	name = "chem dispenser"
	desc = "Creates and dispenses chemicals."
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"
	use_power = 1
	idle_power_usage = 40
	interact_offline = 1
	resistance_flags = FIRE_PROOF | ACID_PROOF
	var/energy = 100
	var/max_energy = 100
	var/amount = 30
	var/recharged = 0
	var/recharge_delay = 5
	var/image/icon_beaker = null
	var/obj/item/weapon/reagent_containers/beaker = null
	var/list/dispensable_reagents = list(
		"hydrogen",
		"lithium",
		"carbon",
		"nitrogen",
		"oxygen",
		"fluorine",
		"sodium",
		"aluminium",
		"silicon",
		"phosphorus",
		"sulfur",
		"chlorine",
		"potassium",
		"iron",
		"copper",
		"mercury",
		"radium",
		"water",
		"ethanol",
		"sugar",
		"sacid",
		"welding_fuel",
		"silver",
		"iodine",
		"bromine",
		"stable_plasma"
	)
	var/list/emagged_reagents = list(
		"space_drugs",
		"morphine",
		"carpotoxin",
		"mine_salve",
		"toxin"
	)

/obj/machinery/chem_dispenser/New()
	..()
	recharge()
	dispensable_reagents = sortList(dispensable_reagents)

/obj/machinery/chem_dispenser/process()

	if(recharged < 0)
		recharge()
		recharged = recharge_delay
	else
		recharged -= 1

/obj/machinery/chem_dispenser/proc/recharge()
	if(stat & (BROKEN|NOPOWER)) return
	var/addenergy = 1
	var/oldenergy = energy
	energy = min(energy + addenergy, max_energy)
	if(energy != oldenergy)
		use_power(2500)

/obj/machinery/chem_dispenser/emag_act(mob/user)
	if(emagged)
		to_chat(user, "<span class='warning'>\The [src] has no functional safeties to emag.</span>")
		return
	to_chat(user, "<span class='notice'>You short out \the [src]'s safeties.</span>")
	dispensable_reagents |= emagged_reagents//add the emagged reagents to the dispensable ones
	emagged = 1

/obj/machinery/chem_dispenser/ex_act(severity, target)
	if(severity < 3)
		..()

/obj/machinery/chem_dispenser/contents_explosion(severity, target)
	..()
	if(beaker)
		beaker.ex_act(severity, target)

/obj/machinery/chem_dispenser/handle_atom_del(atom/A)
	..()
	if(A == beaker)
		beaker = null
		cut_overlays()

/obj/machinery/chem_dispenser/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, \
											datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "chem_dispenser", name, 550, 550, master_ui, state)
		ui.open()

/obj/machinery/chem_dispenser/ui_data()
	var/data = list()
	data["amount"] = amount
	data["energy"] = energy
	data["maxEnergy"] = max_energy
	data["isBeakerLoaded"] = beaker ? 1 : 0

	var beakerContents[0]
	var beakerCurrentVolume = 0
	if(beaker && beaker.reagents && beaker.reagents.reagent_list.len)
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			beakerContents.Add(list(list("name" = R.name, "volume" = R.volume))) // list in a list because Byond merges the first list...
			beakerCurrentVolume += R.volume
	data["beakerContents"] = beakerContents

	if (beaker)
		data["beakerCurrentVolume"] = beakerCurrentVolume
		data["beakerMaxVolume"] = beaker.volume
		data["beakerTransferAmounts"] = beaker.possible_transfer_amounts
	else
		data["beakerCurrentVolume"] = null
		data["beakerMaxVolume"] = null
		data["beakerTransferAmounts"] = null

	var chemicals[0]
	for(var/re in dispensable_reagents)
		var/datum/reagent/temp = GLOB.chemical_reagents_list[re]
		if(temp)
			chemicals.Add(list(list("title" = temp.name, "id" = temp.id)))
	data["chemicals"] = chemicals
	return data

/obj/machinery/chem_dispenser/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("amount")
			var/target = text2num(params["target"])
			if(target in beaker.possible_transfer_amounts)
				amount = target
				. = TRUE
		if("dispense")
			var/reagent = params["reagent"]
			if(beaker && dispensable_reagents.Find(reagent))
				var/datum/reagents/R = beaker.reagents
				var/free = R.maximum_volume - R.total_volume
				var/actual = min(amount, energy * 10, free)

				R.add_reagent(reagent, actual)
				energy = max(energy - actual / 10, 0)
				. = TRUE
		if("remove")
			var/amount = text2num(params["amount"])
			if(beaker && amount in beaker.possible_transfer_amounts)
				beaker.reagents.remove_all(amount)
				. = TRUE
		if("eject")
			if(beaker)
				beaker.forceMove(loc)
				beaker = null
				cut_overlays()
				. = TRUE

/obj/machinery/chem_dispenser/attackby(obj/item/I, mob/user, params)
	if(default_unfasten_wrench(user, I))
		return

	if(istype(I, /obj/item/weapon/reagent_containers) && (I.container_type & OPENCONTAINER))
		var/obj/item/weapon/reagent_containers/B = I
		. = 1 //no afterattack
		if(beaker)
			to_chat(user, "<span class='warning'>A container is already loaded into the machine!</span>")
			return

		if(!user.drop_item()) // Can't let go?
			return

		beaker = B
		beaker.loc = src
		to_chat(user, "<span class='notice'>You add \the [B] to the machine.</span>")

		if(!icon_beaker)
			icon_beaker = image('icons/obj/chemical.dmi', src, "disp_beaker") //randomize beaker overlay position.
		icon_beaker.pixel_x = rand(-10,5)
		add_overlay(icon_beaker)
	else if(user.a_intent != INTENT_HARM && !istype(I, /obj/item/weapon/card/emag))
		to_chat(user, "<span class='warning'>You can't load \the [I] into the machine!</span>")
	else
		return ..()

/obj/machinery/chem_dispenser/constructable
	name = "portable chem dispenser"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "minidispenser"
	energy = 10
	max_energy = 10
	amount = 5
	recharge_delay = 30
	dispensable_reagents = list()
	var/list/dispensable_reagent_tiers = list(
		list(
			"hydrogen",
			"oxygen",
			"silicon",
			"phosphorus",
			"sulfur",
			"carbon",
			"nitrogen",
			"water"
		),
		list(
			"lithium",
			"sugar",
			"sacid",
			"copper",
			"mercury",
			"sodium",
			"iodine",
			"bromine"
		),
		list(
			"ethanol",
			"chlorine",
			"potassium",
			"aluminium",
			"radium",
			"fluorine",
			"iron",
			"welding_fuel",
			"silver",
			"stable_plasma"
		),
		list(
			"oil",
			"ash",
			"acetone",
			"saltpetre",
			"ammonia",
			"diethylamine"
		)
	)

/obj/machinery/chem_dispenser/constructable/New()
	..()
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/chem_dispenser(null)
	B.apply_default_parts(src)

/obj/item/weapon/circuitboard/machine/chem_dispenser
	name = "Portable Chem Dispenser (Machine Board)"
	build_path = /obj/machinery/chem_dispenser/constructable
	origin_tech = "materials=4;programming=4;plasmatech=4;biotech=3"
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/stock_parts/cell = 1)
	def_components = list(/obj/item/weapon/stock_parts/cell = /obj/item/weapon/stock_parts/cell/high)

/obj/machinery/chem_dispenser/constructable/RefreshParts()
	var/time = 0
	var/temp_energy = 0
	var/i
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		temp_energy += M.rating
	temp_energy--
	max_energy = temp_energy * 5  //max energy = (bin1.rating + bin2.rating - 1) * 5, 5 on lowest 25 on highest
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		time += C.rating
	for(var/obj/item/weapon/stock_parts/cell/P in component_parts)
		time += round(P.maxcharge, 10000) / 10000
	recharge_delay /= time/2         //delay between recharges, double the usual time on lowest 50% less than usual on highest
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		for(i=1, i<=M.rating, i++)
			dispensable_reagents |= dispensable_reagent_tiers[i]
	dispensable_reagents = sortList(dispensable_reagents)

/obj/machinery/chem_dispenser/constructable/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "minidispenser-o", "minidispenser", I))
		return

	if(exchange_parts(user, I))
		return

	if(default_deconstruction_crowbar(I))
		return
	return ..()

/obj/machinery/chem_dispenser/constructable/on_deconstruction()
	if(beaker)
		beaker.loc = loc
		beaker = null

/obj/machinery/chem_dispenser/drinks
	name = "soda dispenser"
	desc = "Contains a large reservoir of soft drinks."
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "soda_dispenser"
	amount = 10
	dispensable_reagents = list(
		"water",
		"ice",
		"coffee",
		"cream",
		"tea",
		"icetea",
		"cola",
		"spacemountainwind",
		"dr_gibb",
		"space_up",
		"tonic",
		"sodawater",
		"lemon_lime",
		"pwr_game",
		"shamblers",
		"sugar",
		"orangejuice",
		"limejuice",
		"tomatojuice",
		"lemonjuice"
	)
	emagged_reagents = list(
		"thirteenloko",
		"whiskeycola",
		"mindbreaker",
		"tirizene"
	)



/obj/machinery/chem_dispenser/drinks/beer
	name = "booze dispenser"
	desc = "Contains a large reservoir of the good stuff."
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "booze_dispenser"
	dispensable_reagents = list(
		"beer",
		"kahlua",
		"whiskey",
		"wine",
		"vodka",
		"gin",
		"rum",
		"tequila",
		"vermouth",
		"cognac",
		"ale",
		"absinthe",
		"hcider"
	)
	emagged_reagents = list(
		"ethanol",
		"iron",
		"minttoxin",
		"atomicbomb"
	)


/obj/machinery/chem_dispenser/mutagen
	name = "mutagen dispenser"
	desc = "Creates and dispenses mutagen."
	dispensable_reagents = list("mutagen")
	emagged_reagents = list("plasma")
