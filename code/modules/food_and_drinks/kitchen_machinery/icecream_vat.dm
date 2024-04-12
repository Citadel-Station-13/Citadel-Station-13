#define ICECREAM_VANILLA 1
#define ICECREAM_CHOCOLATE 2
#define ICECREAM_STRAWBERRY 3
#define ICECREAM_PEACH 4
#define ICECREAM_GRAPE 5
#define ICECREAM_BLUE 6
#define ICECREAM_CUSTOM 7
#define CONE_WAFFLE 8
#define CONE_CHOC 9

/obj/machinery/icecream_vat
	name = "ice cream vat"
	desc = "Ding-aling ding dong. Get your Nanotrasen-approved ice cream!"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "icecream_vat"
	density = TRUE
	anchored = FALSE
	use_power = NO_POWER_USE
	layer = BELOW_OBJ_LAYER
	max_integrity = 300
	var/list/product_types = list()
	var/dispense_flavour = ICECREAM_VANILLA
	var/flavour_name = "vanilla"
	var/obj/item/reagent_containers/beaker = null
	var/static/list/icecream_vat_reagents = list(
		/datum/reagent/consumable/milk = 6,
		/datum/reagent/consumable/flour = 6,
		/datum/reagent/consumable/sugar = 6,
		/datum/reagent/consumable/ice = 6,
		/datum/reagent/consumable/coco = 6,
		/datum/reagent/consumable/vanilla = 6,
		/datum/reagent/consumable/berryjuice = 6,
		/datum/reagent/consumable/ethanol/singulo = 6,
		/datum/reagent/consumable/peachjuice = 6,
		/datum/reagent/consumable/grapejuice = 6)
	var/custom_taste
	var/custom_color

/obj/machinery/icecream_vat/proc/get_ingredient_list(type)
	switch(type)
		if(ICECREAM_CHOCOLATE)
			return list(/datum/reagent/consumable/milk, /datum/reagent/consumable/ice, /datum/reagent/consumable/coco)
		if(ICECREAM_STRAWBERRY)
			return list(/datum/reagent/consumable/milk, /datum/reagent/consumable/ice, /datum/reagent/consumable/berryjuice)
		if(ICECREAM_CUSTOM)
			return list(/datum/reagent/consumable/milk, /datum/reagent/consumable/ice)
		if(ICECREAM_PEACH)
			return list(/datum/reagent/consumable/milk, /datum/reagent/consumable/ice, /datum/reagent/consumable/peachjuice)
		if(ICECREAM_GRAPE)
			return list(/datum/reagent/consumable/milk, /datum/reagent/consumable/ice, /datum/reagent/consumable/grapejuice)
		if(ICECREAM_BLUE)
			return list(/datum/reagent/consumable/milk, /datum/reagent/consumable/ice, /datum/reagent/consumable/ethanol/singulo)
		if(CONE_WAFFLE)
			return list(/datum/reagent/consumable/flour, /datum/reagent/consumable/sugar)
		if(CONE_CHOC)
			return list(/datum/reagent/consumable/flour, /datum/reagent/consumable/sugar, /datum/reagent/consumable/coco)
		else //ICECREAM_VANILLA
			return list(/datum/reagent/consumable/milk, /datum/reagent/consumable/ice, /datum/reagent/consumable/vanilla)


/obj/machinery/icecream_vat/proc/get_flavour_name(flavour_type)
	switch(flavour_type)
		if(ICECREAM_CHOCOLATE)
			return "chocolate"
		if(ICECREAM_STRAWBERRY)
			return "strawberry"
		if(ICECREAM_PEACH)
			return "peach"
		if(ICECREAM_GRAPE)
			return "grape"
		if(ICECREAM_BLUE)
			return "blue"
		if(ICECREAM_CUSTOM)
			return "custom"
		if(CONE_WAFFLE)
			return "waffle"
		if(CONE_CHOC)
			return "chocolate"
		else //ICECREAM_VANILLA
			return "vanilla"


/obj/machinery/icecream_vat/Initialize(mapload)
	. = ..()
	while(product_types.len < 9)
		product_types.Add(5)
	create_reagents(100, OPENCONTAINER | NO_REACT)
	for(var/reagent in icecream_vat_reagents)
		reagents.add_reagent(reagent, icecream_vat_reagents[reagent])

/obj/machinery/icecream_vat/ui_interact(mob/user)
	. = ..()
	var/dat
	dat += "<b>ICE CREAM</b><br><div class='statusDisplay'>"
	dat += "<b>Dispensing: [flavour_name] icecream </b> <br><br>"
	dat += "<b>Vanilla ice cream:</b> <a href='?src=[REF(src)];select=[ICECREAM_VANILLA]'><b>Select</b></a> <a href='?src=[REF(src)];make=[ICECREAM_VANILLA];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[ICECREAM_VANILLA];amount=5'><b>x5</b></a> [product_types[ICECREAM_VANILLA]] scoops left. (Ingredients: milk, ice, vanilla)<br>"
	dat += "<b>Strawberry ice cream:</b> <a href='?src=[REF(src)];select=[ICECREAM_STRAWBERRY]'><b>Select</b></a> <a href='?src=[REF(src)];make=[ICECREAM_STRAWBERRY];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[ICECREAM_STRAWBERRY];amount=5'><b>x5</b></a> [product_types[ICECREAM_STRAWBERRY]] dollops left. (Ingredients: milk, ice, berry juice)<br>"
	dat += "<b>Chocolate ice cream:</b> <a href='?src=[REF(src)];select=[ICECREAM_CHOCOLATE]'><b>Select</b></a> <a href='?src=[REF(src)];make=[ICECREAM_CHOCOLATE];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[ICECREAM_CHOCOLATE];amount=5'><b>x5</b></a> [product_types[ICECREAM_CHOCOLATE]] dollops left. (Ingredients: milk, ice, coco powder)<br>"
	dat += "<b>Peach ice cream:</b> <a href='?src=[REF(src)];select=[ICECREAM_PEACH]'><b>Select</b></a> <a href='?src=[REF(src)];make=[ICECREAM_PEACH];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[ICECREAM_PEACH];amount=5'><b>x5</b></a> [product_types[ICECREAM_PEACH]] dollops left. (Ingredients: milk, ice, peach juice)<br>"
	dat += "<b>Grape ice cream:</b> <a href='?src=[REF(src)];select=[ICECREAM_GRAPE]'><b>Select</b></a> <a href='?src=[REF(src)];make=[ICECREAM_GRAPE];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[ICECREAM_GRAPE];amount=5'><b>x5</b></a> [product_types[ICECREAM_GRAPE]] dollops left. (Ingredients: milk, ice, grape juice)<br>"
	dat += "<b>Blue ice cream:</b> <a href='?src=[REF(src)];select=[ICECREAM_BLUE]'><b>Select</b></a> <a href='?src=[REF(src)];make=[ICECREAM_BLUE];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[ICECREAM_BLUE];amount=5'><b>x5</b></a> [product_types[ICECREAM_BLUE]] dollops left. (Ingredients: milk, ice, singulo)<br>"
	dat += "<b>Custom ice cream:</b> <a href='?src=[REF(src)];select=[ICECREAM_CUSTOM]'><b>Select</b></a> <a href='?src=[REF(src)];make=[ICECREAM_CUSTOM];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[ICECREAM_CUSTOM];amount=5'><b>x5</b></a> [product_types[ICECREAM_CUSTOM]] dollops left. (Ingredients: milk, ice, optional flavoring)<br>"
	dat += "<a href='?src=[REF(src)];custom_taste=1;'><b>Change custom taste: [custom_taste ? custom_taste : "Default"]</b></a>"
	dat += "<br><a href='?src=[REF(src)];custom_color=1;'><b>Change custom color: [custom_color ? custom_color : "Default"]</b></a>"
	dat += "<br><a href='?src=[REF(src)];reset_custom=1;'><b>Reset custom ice cream taste and color to defaults</b></a></div>"
	dat += "<br><b>CONES</b><br><div class='statusDisplay'>"
	dat += "<b>Waffle cones:</b> <a href='?src=[REF(src)];cone=[CONE_WAFFLE]'><b>Dispense</b></a> <a href='?src=[REF(src)];make=[CONE_WAFFLE];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[CONE_WAFFLE];amount=5'><b>x5</b></a> [product_types[CONE_WAFFLE]] cones left. (Ingredients: flour, sugar)<br>"
	dat += "<b>Chocolate cones:</b> <a href='?src=[REF(src)];cone=[CONE_CHOC]'><b>Dispense</b></a> <a href='?src=[REF(src)];make=[CONE_CHOC];amount=1'><b>Make</b></a> <a href='?src=[REF(src)];make=[CONE_CHOC];amount=5'><b>x5</b></a> [product_types[CONE_CHOC]] cones left. (Ingredients: flour, sugar, coco powder)<br></div>"
	dat += "<br>"
	if(beaker)
		dat += "<b>BEAKER CONTENT</b><br><div class='statusDisplay'>"
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			dat += "[R.name]: [R.volume]u<br>"
		dat += "<a href='?src=[REF(src)];refill=1'><b>Refill from beaker</b></a></div>"
	dat += "<br>"
	dat += "<b>VAT CONTENT</b><br>"
	for(var/datum/reagent/R in reagents.reagent_list)
		dat += "[R.name]: [R.volume]"
		dat += "<A href='?src=[REF(src)];disposeI=[R.type]'>Purge</A><BR>"
	dat += "<a href='?src=[REF(src)];refresh=1'>Refresh</a> <a href='?src=[REF(src)];close=1'>Close</a>"

	var/datum/browser/popup = new(user, "icecreamvat","Icecream Vat", 700, 500, src)
	popup.set_content(dat)
	popup.open()

/obj/machinery/icecream_vat/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/reagent_containers/food/snacks/icecream))
		var/obj/item/reagent_containers/food/snacks/icecream/I = O
		if(!I.ice_creamed)
			if(product_types[dispense_flavour] > 0)
				visible_message("[icon2html(src, viewers(src))] <span class='info'>[user] scoops delicious [flavour_name] ice cream into [I].</span>")
				product_types[dispense_flavour] -= 1
				if(beaker && beaker.reagents.total_volume)
					I.add_ice_cream(flavour_name, beaker.reagents, custom_color, custom_taste)
				else
					I.add_ice_cream(flavour_name)
				if(I.reagents.total_volume < 10)
					I.reagents.add_reagent(/datum/reagent/consumable/sugar, 10 - I.reagents.total_volume)
				updateDialog()
			else
				to_chat(user, "<span class='warning'>There is not enough ice cream left!</span>")
		else
			to_chat(user, "<span class='notice'>[O] already has ice cream in it.</span>")
		return TRUE
	if(istype(O, /obj/item/reagent_containers) && !(O.item_flags & ABSTRACT) && O.is_open_container())
		. = TRUE //no afterattack
		var/obj/item/reagent_containers/B = O
		if(!user.transferItemToLoc(B, src))
			return
		replace_beaker(user, B)
		to_chat(user, "<span class='notice'>You add [B] to [src].</span>")
		updateUsrDialog()
		update_icon()
		return
	else if(O.is_drainable())
		return
	else
		return ..()

/obj/machinery/icecream_vat/proc/RefillFromBeaker()
	if(!beaker || !beaker.reagents)
		return
	for(var/datum/reagent/R in beaker.reagents.reagent_list)
		if(R.type in icecream_vat_reagents)
			beaker.reagents.trans_id_to(src, R.type, R.volume)
			say("Internalizing reagent.")
			playsound(src, 'sound/items/drink.ogg', 25, 1)
	return

/obj/machinery/icecream_vat/proc/make(mob/user, make_type, amount)
	var/recipe_amount = amount * 3 //prevents reagent duping by requring roughly the amount of reagenst you gain back by grinding.
	for(var/R in get_ingredient_list(make_type))
		if(reagents.has_reagent(R, recipe_amount))
			continue
		amount = 0
		break
	if(amount)
		for(var/R in get_ingredient_list(make_type))
			reagents.remove_reagent(R, recipe_amount)
		product_types[make_type] += amount
		var/flavour = get_flavour_name(make_type)
		if(make_type > 7)
			visible_message("<span class='info'>[user] cooks up some [flavour] cones.</span>")
		else
			visible_message("<span class='info'>[user] whips up some [flavour] icecream.</span>")
	else
		to_chat(user, "<span class='warning'>You don't have the ingredients to make this!</span>")

/obj/machinery/icecream_vat/Topic(href, href_list)
	if(..())
		return
	if(href_list["select"])
		dispense_flavour = text2num(href_list["select"])
		flavour_name = get_flavour_name(dispense_flavour)
		src.visible_message("<span class='notice'>[usr] sets [src] to dispense [flavour_name] flavoured ice cream.</span>")

	if(href_list["cone"])
		var/dispense_cone = text2num(href_list["cone"])
		var/cone_name = get_flavour_name(dispense_cone)
		if(product_types[dispense_cone] >= 1)
			product_types[dispense_cone] -= 1
			var/obj/item/reagent_containers/food/snacks/icecream/I = new(src.loc)
			I.set_cone_type(cone_name)
			src.visible_message("<span class='info'>[usr] dispenses a crunchy [cone_name] cone from [src].</span>")
		else
			to_chat(usr, "<span class='warning'>There are no [cone_name] cones left!</span>")

	if(href_list["make"])
		var/amount = (text2num(href_list["amount"]))
		var/C = text2num(href_list["make"])
		make(usr, C, amount)

	if(href_list["disposeI"])
		reagents.del_reagent(text2path(href_list["disposeI"]))

	if(href_list["refill"])
		RefillFromBeaker()

	if(href_list["refresh"])
		updateDialog()

	if(href_list["close"])
		usr.unset_machine()
		usr << browse(null,"window=icecreamvat")

	if(href_list["custom_taste"])
		custom_taste = stripped_input(usr, "Set a custom taste for the custom icecream. 50 characters max, leave blank to go back to the default option.", max_length = 50)

	if(href_list["custom_color"])
		custom_color = input(usr, "Choose a color for the custom icecream. Cancel to go back to the default option.") as color|null

	if(href_list["reset_custom"])
		custom_taste = null
		custom_color = null

	updateDialog() // i have no clue why we even have refresh when this is a thing but sure

	return

/obj/item/reagent_containers/food/snacks/icecream
	name = "ice cream cone"
	desc = "Delicious waffle cone, but no ice cream."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "icecream_cone_waffle" //default for admin-spawned cones, href_list["cone"] should overwrite this all the time
	list_reagents = list(/datum/reagent/consumable/nutriment = 4)
	tastes = list("cream" = 2, "waffle" = 1)
	var/ice_creamed = 0
	var/cone_type
	bitesize = 4
	foodtype = DAIRY | SUGAR

/obj/item/reagent_containers/food/snacks/icecream/Initialize(mapload)
	. = ..()
	reagents.maximum_volume = 20

/obj/item/reagent_containers/food/snacks/icecream/proc/set_cone_type(var/cone_name)
	cone_type = cone_name
	icon_state = "icecream_cone_[cone_name]"
	switch (cone_type)
		if ("waffle")
			reagents.add_reagent(/datum/reagent/consumable/nutriment, 1)
		if ("chocolate")
			reagents.add_reagent(/datum/reagent/consumable/coco, 1) // chocolate ain't as nutritious kids

	desc = "Delicious [cone_name] cone, but no ice cream."


/obj/item/reagent_containers/food/snacks/icecream/proc/add_ice_cream(flavour_name, datum/reagents/R, custom_color, custom_taste)
	name = "[flavour_name] icecream"
	switch (flavour_name) // adding the actual reagents advertised in the ingredient list
		if ("vanilla")
			desc = "A delicious [cone_type] cone filled with vanilla ice cream. All the other ice creams take content from it."
			reagents.add_reagent(/datum/reagent/consumable/vanilla, 3)
			filling_color = "#ECE1C1"
		if ("chocolate")
			desc = "A delicious [cone_type] cone filled with chocolate ice cream. Surprisingly, made with real cocoa."
			reagents.add_reagent(/datum/reagent/consumable/coco, 3)
			filling_color = "#93673B"
		if ("strawberry")
			desc = "A delicious [cone_type] cone filled with strawberry ice cream. Definitely not made with real strawberries."
			reagents.add_reagent(/datum/reagent/consumable/berryjuice, 3)
			filling_color = "#EFB4B4"
		if ("peach")
			desc = "A delicious [cone_type] cone filled with peach ice cream. Definitely made with real peaches!"
			reagents.add_reagent(/datum/reagent/consumable/peachjuice, 3)
			filling_color = "#E78108"
		if ("grape")
			desc = "A delicious [cone_type] cone filled with grape ice cream. Surprisingly, made with real pink grape, likely not real sugarcanes used."
			reagents.add_reagent(/datum/reagent/consumable/grapejuice, 3)
			filling_color = "#FF1493"
		if ("blue")
			desc = "A delicious [cone_type] cone filled with blue ice cream. Made with real... blue?"
			reagents.add_reagent(/datum/reagent/consumable/ethanol/singulo, 3)
			filling_color = "#ACBCED"
		if ("mob")
			desc = "A suspicious [cone_type] cone filled with bright red ice cream. That's probably not strawberry..."
			reagents.add_reagent(/datum/reagent/liquidgibs, 3)
			filling_color = "#EFB4B4"
		if ("custom")
			if(R && R.total_volume >= 4) //consumable reagents have stronger taste so higher volume will allow non-food flavourings to break through better.
				var/mutable_appearance/flavoring = mutable_appearance(icon,"icecream_custom")
				var/datum/reagent/master = R.get_master_reagent()
				flavoring.color = custom_color ? custom_color : master.color
				filling_color = custom_color ? custom_color : master.color
				if(custom_taste)
					tastes = list("[custom_taste]" = 1)
					reagents.force_alt_taste = TRUE
				name = "[master.name] icecream"
				desc = "A delicious [cone_type] cone filled with artisanal icecream. Made with real [master.name]. Ain't that something."
				R.trans_to(src, 4)
				add_overlay(flavoring)
			else
				name = "bland icecream"
				desc = "A delicious [cone_type] cone filled with anemic, flavorless icecream.You wonder why this was ever scooped.."
				add_overlay("icecream_custom")
	if(flavour_name != "custom")
		src.add_overlay("icecream_[flavour_name]")
	ice_creamed = 1

/obj/item/reagent_containers/food/snacks/icecream/proc/add_mob_flavor(var/mob/M)
	add_ice_cream("mob")
	name = "[M.name] icecream"

/obj/machinery/icecream_vat/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/metal(loc, 4)
	qdel(src)

/obj/machinery/icecream_vat/AltClick(mob/living/user)
	. = ..()
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	replace_beaker(user)
	return TRUE

/obj/machinery/icecream_vat/proc/replace_beaker(mob/living/user, obj/item/reagent_containers/new_beaker)
	if(beaker)
		beaker.forceMove(drop_location())
		if(user && Adjacent(user) && user.can_hold_items())
			user.put_in_hands(beaker)
	if(new_beaker)
		beaker = new_beaker
	else
		beaker = null
		updateDialog()
	return TRUE

#undef ICECREAM_VANILLA
#undef ICECREAM_CHOCOLATE
#undef ICECREAM_STRAWBERRY
#undef ICECREAM_PEACH
#undef ICECREAM_GRAPE
#undef ICECREAM_BLUE
#undef ICECREAM_CUSTOM
#undef CONE_WAFFLE
#undef CONE_CHOC
