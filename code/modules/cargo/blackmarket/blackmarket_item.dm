/datum/blackmarket_item
	var/name // Name for the item entry used in the uplink.
	var/desc // Description for the item entry used in the uplink.
	var/category // The category this item belongs to, should be already declared in the market that this item is accessible in.
	var/list/markets = list(/datum/blackmarket_market/blackmarket) // "/datum/blackmarket_market"s that this item should be in, used by SSblackmarket on init.

	var/price // Price for the item, if not set creates a price according to the *_min and *_max vars.
	var/stock // How many of this type of item is available, if not set creates a price according to the *_min and *_max vars.

	var/item // Path to or the item itself what this entry is for, this should be set even if you override spawn_item to spawn your item.

	var/price_min = 0 // Minimum price for the item if generated randomly.
	var/price_max = 0 // Maximum price for the item if generated randomly.
	var/stock_min = 1 // Minimum amount that there should be of this item in the market if generated randomly. This defaults to 1 as most items will have it as 1.
	var/stock_max = 0 // Maximum amount that there should be of this item in the market if generated randomly.
	var/availability_prob = 0 // Probability for this item to be available. Used by SSblackmarket on init.

/datum/blackmarket_item/New()
	if(isnull(price))
		price = round(rand(price_min, price_max), 5)
	if(isnull(stock))
		stock = rand(stock_min, stock_max)

/datum/blackmarket_item/proc/spawn_item(loc) // Used for spawning the wanted item, override if you need to do something special with the item.
	return new item(loc)

/datum/blackmarket_item/proc/buy(obj/item/blackmarket_uplink/uplink, mob/buyer, shipping_method) // Buys the item and makes SSblackmarket handle it.
	// Sanity
	if(!istype(uplink) || !istype(buyer))
		return FALSE
	if(!item || stock <= 0) // This shouldn't be able to happen unless there was some manipulation or admin fuckery.
		return FALSE
	var/datum/blackmarket_purchase/purchase = new(src, uplink, shipping_method) // Alright, the item has been purchased.
	if(SSblackmarket.queue_item(purchase)) // SSblackmarket takes care of the shipping.
		stock--
		log_game("[key_name(buyer)] has succesfully purchased [name] using [shipping_method] for shipping.")
		return TRUE
	return FALSE

/datum/blackmarket_purchase // This exists because it is easier to keep track of all the vars this way.
	var/datum/blackmarket_item/entry // The entry being purchased.
	var/item // Instance of the item being sent.
	var/obj/item/blackmarket_uplink/uplink 	// The uplink where this purchase was done from.
	var/method 	// Shipping method used to buy this item.

/datum/blackmarket_purchase/New(_entry, _uplink, _method)
	entry = _entry
	if(!ispath(entry.item))
		item = entry.item
	uplink = _uplink
	method = _method
