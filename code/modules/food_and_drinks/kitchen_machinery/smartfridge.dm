// -------------------------
//  SmartFridge.  Much todo
// -------------------------
/obj/machinery/smartfridge
	name = "smartfridge"
	desc = "Keeps cold things cold and hot things cold."
	icon = 'icons/obj/vending.dmi'
	icon_state = "smartfridge"
	layer = BELOW_OBJ_LAYER
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100
	var/max_n_of_items = 1500
	var/icon_on = "smartfridge"
	var/icon_off = "smartfridge-off"

/obj/machinery/smartfridge/New()
	..()
	create_reagents()
	reagents.set_reacting(FALSE)

	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/smartfridge(null)
	B.apply_default_parts(src)

/obj/item/weapon/circuitboard/machine/smartfridge
	name = "circuit board (Smartfridge)"
	build_path = /obj/machinery/smartfridge
	origin_tech = "programming=1"
	req_components = list(/obj/item/weapon/stock_parts/matter_bin = 1)

/obj/item/weapon/circuitboard/machine/smartfridge/New(loc, new_type)
	if(new_type)
		build_path = new_type

/obj/item/weapon/circuitboard/machine/smartfridge/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/screwdriver))
		var/list/fridges = list(/obj/machinery/smartfridge = "default",
								/obj/machinery/smartfridge/drinks = "drinks",
								/obj/machinery/smartfridge/extract = "slimes",
								/obj/machinery/smartfridge/chemistry = "chems",
								/obj/machinery/smartfridge/chemistry/virology = "viruses")

		var/position = fridges.Find(build_path, fridges)
		position = (position == fridges.len) ? 1 : (position + 1)
		build_path = fridges[position]
		user << "<span class='notice'>You set the board to [fridges[build_path]].</span>"
	else
		return ..()

/obj/machinery/smartfridge/construction()
	for(var/datum/A in contents)
		qdel(A)

/obj/machinery/smartfridge/deconstruction()
	for(var/atom/movable/A in contents)
		A.loc = loc

/obj/machinery/smartfridge/RefreshParts()
	for(var/obj/item/weapon/stock_parts/matter_bin/B in component_parts)
		max_n_of_items = 1500 * B.rating

/obj/machinery/smartfridge/power_change()
	..()
	update_icon()

/obj/machinery/smartfridge/update_icon()
	if(!stat)
		icon_state = icon_on
	else
		icon_state = icon_off



/*******************
*   Item Adding
********************/

/obj/machinery/smartfridge/attackby(obj/item/O, mob/user, params)
	if(default_deconstruction_screwdriver(user, "smartfridge_open", "smartfridge", O))
		return

	if(exchange_parts(user, O))
		return

	if(default_pry_open(O))
		return

	if(default_unfasten_wrench(user, O))
		power_change()
		return

	if(default_deconstruction_crowbar(O))
		updateUsrDialog()
		return

	if(stat)
		return 0

	if(contents.len >= max_n_of_items)
		user << "<span class='warning'>\The [src] is full!</span>"
		return 0

	if(accept_check(O))
		load(O)
		user.visible_message("[user] has added \the [O] to \the [src].", "<span class='notice'>You add \the [O] to \the [src].</span>")
		updateUsrDialog()
		return 1

	if(istype(O, /obj/item/weapon/storage/bag))
		var/obj/item/weapon/storage/P = O
		var/loaded = 0
		for(var/obj/G in P.contents)
			if(contents.len >= max_n_of_items)
				break
			if(accept_check(G))
				load(G)
				loaded++
		updateUsrDialog()

		if(loaded)
			if(contents.len >= max_n_of_items)
				user.visible_message("[user] loads \the [src] with \the [O].", \
								 "<span class='notice'>You fill \the [src] with \the [O].</span>")
			else
				user.visible_message("[user] loads \the [src] with \the [O].", \
									 "<span class='notice'>You load \the [src] with \the [O].</span>")
			if(O.contents.len > 0)
				user << "<span class='warning'>Some items are refused.</span>"
		else
			user << "<span class='warning'>There is nothing in [O] to put in [src]!</span>"
			return 0

	else if(user.a_intent != "harm")
		user << "<span class='warning'>\The [src] smartly refuses [O].</span>"
		updateUsrDialog()
		return 0
	else
		return ..()



/obj/machinery/smartfridge/proc/accept_check(obj/item/O)
	if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/grown/) || istype(O,/obj/item/seeds/))
		return 1
	return 0

/obj/machinery/smartfridge/proc/load(obj/item/O)
	if(istype(O.loc,/mob))
		var/mob/M = O.loc
		if(!M.unEquip(O))
			usr << "<span class='warning'>\the [O] is stuck to your hand, you cannot put it in \the [src]!</span>"
			return
	else if(istype(O.loc,/obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = O.loc
		S.remove_from_storage(O,src)

	O.loc = src

/obj/machinery/smartfridge/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/smartfridge/attack_ai(mob/user)
	return 0

/obj/machinery/smartfridge/attack_hand(mob/user)
	user.set_machine(src)
	interact(user)

/*******************
*   SmartFridge Menu
********************/

/obj/machinery/smartfridge/interact(mob/user)
	if(stat)
		return 0

	var/dat = "<TT><b>Select an item:</b><br>"

	if (contents.len == 0)
		dat += "<font color = 'red'>No product loaded!</font>"
	else
		var/listofitems = list()
		for (var/atom/movable/O in contents)
			if (listofitems[O.name])
				listofitems[O.name]++
			else
				listofitems[O.name] = 1
		sortList(listofitems)

		for (var/O in listofitems)
			if(listofitems[O] <= 0)
				continue
			var/N = listofitems[O]
			var/itemName = url_encode(O)
			dat += "<FONT color = 'blue'><B>[capitalize(O)]</B>:"
			dat += " [N] </font>"
			dat += "<a href='byond://?src=\ref[src];vend=[itemName];amount=1'>Vend</A> "
			if(N > 5)
				dat += "(<a href='byond://?src=\ref[src];vend=[itemName];amount=5'>x5</A>)"
				if(N > 10)
					dat += "(<a href='byond://?src=\ref[src];vend=[itemName];amount=10'>x10</A>)"
					if(N > 25)
						dat += "(<a href='byond://?src=\ref[src];vend=[itemName];amount=25'>x25</A>)"
			if(N > 1)
				dat += "(<a href='?src=\ref[src];vend=[itemName];amount=[N]'>All</A>)"

			dat += "<br>"

		dat += "</TT>"
	user << browse("<HEAD><TITLE>[src] supplies</TITLE></HEAD><TT>[dat]</TT>", "window=smartfridge")
	onclose(user, "smartfridge")
	return dat

/obj/machinery/smartfridge/Topic(var/href, var/list/href_list)
	if(..())
		return
	usr.set_machine(src)

	var/N = href_list["vend"]
	var/amount = text2num(href_list["amount"])

	var/i = amount
	for(var/obj/O in contents)
		if(i <= 0)
			break
		if(O.name == N)
			O.loc = src.loc
			i--


	updateUsrDialog()


// ----------------------------
//  Drying Rack 'smartfridge'
// ----------------------------
/obj/machinery/smartfridge/drying_rack
	name = "drying rack"
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "drying_rack_on"
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 200
	icon_on = "drying_rack_on"
	icon_off = "drying_rack"
	var/drying = 0

/obj/machinery/smartfridge/drying_rack/interact(mob/user)
	var/dat = ..()
	if(dat)
		dat += "<br>"
		dat += "<a href='byond://?src=\ref[src];dry=1'>Toggle Drying</A> "
		user << browse("<HEAD><TITLE>[src] supplies</TITLE></HEAD><TT>[dat]</TT>", "window=smartfridge")
	onclose(user, "smartfridge")

/obj/machinery/smartfridge/drying_rack/Topic(href, list/href_list)
	..()
	if(href_list["dry"])
		toggle_drying()
	src.updateUsrDialog()

/obj/machinery/smartfridge/drying_rack/power_change()
	if(powered() && anchored)
		stat &= ~NOPOWER
	else
		stat |= NOPOWER
		toggle_drying(1)
	update_icon()

/obj/machinery/smartfridge/drying_rack/load() //For updating the filled overlay
	..()
	update_icon()

/obj/machinery/smartfridge/drying_rack/update_icon()
	..()
	overlays = 0
	if(drying)
		add_overlay("drying_rack_drying")
	if(contents.len)
		add_overlay("drying_rack_filled")

/obj/machinery/smartfridge/drying_rack/process()
	..()
	if(drying)
		if(rack_dry())//no need to update unless something got dried
			update_icon()

/obj/machinery/smartfridge/drying_rack/accept_check(obj/item/O)
	if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/))
		var/obj/item/weapon/reagent_containers/food/snacks/S = O
		if(S.dried_type)
			return 1
	return 0

/obj/machinery/smartfridge/drying_rack/proc/toggle_drying(forceoff = 0)
	if(drying || forceoff)
		drying = 0
		use_power = 1
	else
		drying = 1
		use_power = 2
	update_icon()

/obj/machinery/smartfridge/drying_rack/proc/rack_dry()
	for(var/obj/item/weapon/reagent_containers/food/snacks/S in contents)
		if(S.dried_type == S.type)//if the dried type is the same as the object's type, don't bother creating a whole new item...
			S.color = "#ad7257"
			S.dry = 1
			S.loc = get_turf(src)
		else
			var/dried = S.dried_type
			new dried(src.loc)
			qdel(S)
		return 1
	return 0

/obj/machinery/smartfridge/drying_rack/emp_act(severity)
	..()
	atmos_spawn_air("TEMP=1000")


// ----------------------------
//  Bar drink smartfridge
// ----------------------------
/obj/machinery/smartfridge/drinks
	name = "drink showcase"
	desc = "A refrigerated storage unit for tasty tasty alcohol."

/obj/machinery/smartfridge/drinks/accept_check(obj/item/O)
	if(!istype(O,/obj/item/weapon/reagent_containers) || !O.reagents || !O.reagents.reagent_list.len)
		return 0
	if(istype(O,/obj/item/weapon/reagent_containers/glass) || istype(O,/obj/item/weapon/reagent_containers/food/drinks) || istype(O,/obj/item/weapon/reagent_containers/food/condiment))
		return 1


// -------------------------------------
// Xenobiology Slime-Extract Smartfridge
// -------------------------------------
/obj/machinery/smartfridge/extract
	name = "smart slime extract storage"
	desc = "A refrigerated storage unit for slime extracts."

/obj/machinery/smartfridge/extract/accept_check(obj/item/O)
	if(istype(O,/obj/item/slime_extract))
		return 1
	if(istype(O,/obj/item/device/slime_scanner))
		return 1
	return 0

/obj/machinery/smartfridge/extract/New()
	..()
	var/obj/item/device/slime_scanner/I = new /obj/item/device/slime_scanner(src)
	load(I)
	var/obj/item/device/slime_scanner/T = new /obj/item/device/slime_scanner(src)
	load(T)

// -----------------------------
// Chemistry Medical Smartfridge
// -----------------------------
/obj/machinery/smartfridge/chemistry
	name = "smart chemical storage"
	desc = "A refrigerated storage unit for medicine storage."
	var/list/spawn_meds = list(
		/obj/item/weapon/reagent_containers/pill/epinephrine = 12,
		/obj/item/weapon/reagent_containers/pill/charcoal = 1,
		/obj/item/weapon/reagent_containers/glass/bottle/epinephrine = 1,
		/obj/item/weapon/reagent_containers/glass/bottle/charcoal = 1)

/obj/machinery/smartfridge/chemistry/New()
	..()
	for(var/typekey in spawn_meds)
		var/amount = spawn_meds[typekey]
		if(isnull(amount)) amount = 1
		while(amount)
			var/obj/item/I = new typekey(src)
			load(I)
			amount--

/obj/machinery/smartfridge/chemistry/accept_check(obj/item/O)
	if(istype(O,/obj/item/weapon/storage/pill_bottle))
		if(O.contents.len)
			for(var/obj/item/I in O)
				if(!accept_check(I))
					return 0
			return 1
		return 0
	if(!istype(O,/obj/item/weapon/reagent_containers))
		return 0
	if(istype(O,/obj/item/weapon/reagent_containers/pill)) // empty pill prank ok
		return 1
	if(!O.reagents || !O.reagents.reagent_list.len) // other empty containers not accepted
		return 0
	if(istype(O,/obj/item/weapon/reagent_containers/syringe) || istype(O,/obj/item/weapon/reagent_containers/glass/bottle) || istype(O,/obj/item/weapon/reagent_containers/glass/beaker) || istype(O,/obj/item/weapon/reagent_containers/spray))
		return 1
	return 0

// ----------------------------
// Virology Medical Smartfridge
// ----------------------------
/obj/machinery/smartfridge/chemistry/virology
	name = "smart virus storage"
	desc = "A refrigerated storage unit for volatile sample storage."
	spawn_meds = list(
		/obj/item/weapon/reagent_containers/syringe/antiviral = 4,
		/obj/item/weapon/reagent_containers/glass/bottle/cold = 1,
		/obj/item/weapon/reagent_containers/glass/bottle/flu_virion = 1,
		/obj/item/weapon/reagent_containers/glass/bottle/mutagen = 1,
		/obj/item/weapon/reagent_containers/glass/bottle/plasma = 1,
		/obj/item/weapon/reagent_containers/glass/bottle/synaptizine = 1)
