/obj/item/blackmarket_uplink
	name = "Black Market Uplink"
	desc = "A mishmash of a subspace amplifier, a radio, and an analyzer.  Somehow able to access the black market, with a variable inventory in limited stock at inflated prices. No refunds, customer responsible for pick-ups." 
	icon = 'icons/obj/blackmarket.dmi'
	icon_state = "uplink"
	// UI variables.
	var/ui_x = 720
	var/ui_y = 480
	var/viewing_category
	var/viewing_market
	var/selected_item
	var/buying
	var/money = 0 // How much money is inserted into the uplink.
	var/list/accessible_markets = list(/datum/blackmarket_market/blackmarket) // List of typepaths for "/datum/blackmarket_market"s that this uplink can access.

/obj/item/blackmarket_uplink/Initialize()
	. = ..()
	if(accessible_markets.len)
		viewing_market = accessible_markets[1]
		var/list/categories = SSblackmarket.markets[viewing_market].categories
		if(categories && categories.len)
			viewing_category = categories[1]

/obj/item/blackmarket_uplink/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/holochip) || istype(I, /obj/item/stack/spacecash) || istype(I, /obj/item/coin))
		var/worth = I.get_item_credit_value()
		if(!worth)
			to_chat(user, "<span class='warning'>[I] doesn't seem to be worth anything!</span>")
		money += worth
		to_chat(user, "<span class='notice'>You slot [I] into [src] and it reports a total of [money] credits inserted.</span>")
		qdel(I)
		return
	. = ..()

/obj/item/blackmarket_uplink/AltClick(mob/user)
	if(!isliving(user) || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	var/amount_to_remove =  FLOOR(input(user, "How much do you want to withdraw? Current Amount: [money]", "Withdraw Funds", 5) as num|null, 1)
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	if(!amount_to_remove || amount_to_remove < 0)
		return
	if(amount_to_remove > money)
		to_chat(user, "<span class='warning'>There is only [money] credits in [src]</span>")
		return
	var/obj/item/holochip/holochip = new (user.drop_location(), amount_to_remove)
	money -= amount_to_remove
	holochip.name = "washed " + holochip.name
	user.put_in_hands(holochip)
	to_chat(user, "<span class='notice'>You withdraw [amount_to_remove] credits into a holochip.</span>")

/obj/item/blackmarket_uplink/ui_interact(mob/user, ui_key = "BlackMarketUplink", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, ui_key, name, ui_x, ui_y, master_ui, state)
		ui.open()

/obj/item/blackmarket_uplink/ui_data(mob/user)
	var/list/data = list()
	var/datum/blackmarket_market/market = viewing_market ? SSblackmarket.markets[viewing_market] : null
	data["categories"] = market ? market.categories : null
	data["delivery_methods"] = list()
	if(market)
		for(var/delivery in market.shipping)
			data["delivery_methods"] += list(list("name" = delivery, "price" = market.shipping[delivery]))
	data["money"] = money
	data["buying"] = buying
	data["items"] = list()
	data["viewing_category"] = viewing_category
	data["viewing_market"] = viewing_market
	if(viewing_category && market)
		if(market.available_items[viewing_category])
			for(var/datum/blackmarket_item/I in market.available_items[viewing_category])
				data["items"] += list(list(
					"id" = I.type,
					"name" = I.name,
					"cost" = I.price,
					"amount" = I.stock,
					"desc" = I.desc || I.name
				))
	return data

/obj/item/blackmarket_uplink/ui_static_data(mob/user)
	var/list/data = list()
	data["delivery_method_description"] = SSblackmarket.shipping_method_descriptions
	data["ltsrbt_built"] = SSblackmarket.telepads.len
	data["markets"] = list()
	for(var/M in accessible_markets)
		var/datum/blackmarket_market/BM = SSblackmarket.markets[M]
		data["markets"] += list(list(
			"id" = M,
			"name" = BM.name
		))
	return data

/obj/item/blackmarket_uplink/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("set_category")
			if(isnull(params["category"]))
				return
			if(isnull(viewing_market))
				return
			if(!(params["category"] in SSblackmarket.markets[viewing_market].categories))
				return
			viewing_category = params["category"]
			. = TRUE
		if("set_market")
			if(isnull(params["market"]))
				return
			var/market = text2path(params["market"])
			if(!(market in accessible_markets))
				return
			viewing_market = market
			var/list/categories = SSblackmarket.markets[viewing_market].categories
			if(categories && categories.len)
				viewing_category = categories[1]
			else
				viewing_category = null
			. = TRUE
		if("select")
			if(isnull(params["item"]))
				return
			var/item = text2path(params["item"])
			selected_item = item
			buying = TRUE
			. = TRUE
		if("cancel")
			selected_item = null
			buying = FALSE
			. = TRUE
		if("buy")
			if(isnull(params["method"]))
				return
			if(isnull(selected_item))
				buying = FALSE
				return
			var/datum/blackmarket_market/market = SSblackmarket.markets[viewing_market]
			market.purchase(selected_item, viewing_category, params["method"], src, usr)
			buying = FALSE
			selected_item = null
