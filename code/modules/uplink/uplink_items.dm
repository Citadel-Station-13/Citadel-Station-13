GLOBAL_LIST_INIT(uplink_items, subtypesof(/datum/uplink_item))

/proc/get_uplink_items(var/datum/game_mode/gamemode = null, allow_sales = TRUE, allow_restricted = TRUE)
	var/list/filtered_uplink_items = list()
	var/list/sale_items = list()

	for(var/path in GLOB.uplink_items)
		var/datum/uplink_item/I = new path
		if(!I.item)
			continue
		if(I.include_modes.len)
			if(!gamemode && SSticker.mode && !(SSticker.mode.type in I.include_modes))
				continue
			if(gamemode && !(gamemode in I.include_modes))
				continue
		if(I.exclude_modes.len)
			if(!gamemode && SSticker.mode && (SSticker.mode.type in I.exclude_modes))
				continue
			if(gamemode && (gamemode in I.exclude_modes))
				continue
		if(I.player_minimum && I.player_minimum > GLOB.joined_player_list.len)
			continue
		if (I.restricted && !allow_restricted)
			continue

		if(!filtered_uplink_items[I.category])
			filtered_uplink_items[I.category] = list()
		filtered_uplink_items[I.category][I.name] = I
		if(I.limited_stock < 0 && !I.cant_discount && I.item && I.cost > 1)
			sale_items += I
	if(allow_sales)
		for(var/i in 1 to 3)
			var/datum/uplink_item/I = pick_n_take(sale_items)
			var/datum/uplink_item/A = new I.type
			var/discount = A.get_discount()
			var/list/disclaimer = list("Void where prohibited.", "Not recommended for children.", "Contains small parts.", "Check local laws for legality in region.", "Do not taunt.", "Not responsible for direct, indirect, incidental or consequential damages resulting from any defect, error or failure to perform.", "Keep away from fire or flames.", "Product is provided \"as is\" without any implied or expressed warranties.", "As seen on TV.", "For recreational use only.", "Use only as directed.", "16% sales tax will be charged for orders originating within Space Nebraska.")
			A.limited_stock = 1
			I.refundable = FALSE //THIS MAN USES ONE WEIRD TRICK TO GAIN FREE TC, CODERS HATES HIM!
			A.refundable = FALSE
			if(A.cost >= 20) //Tough love for nuke ops
				discount *= 0.5
			A.cost = max(round(A.cost * discount),1)
			A.category = "Discounted Gear"
			A.name += " ([round(((initial(A.cost)-A.cost)/initial(A.cost))*100)]% off!)"
			A.desc += " Normally costs [initial(A.cost)] TC. All sales final. [pick(disclaimer)]"
			A.item = I.item

			if(!filtered_uplink_items[A.category])
				filtered_uplink_items[A.category] = list()
			filtered_uplink_items[A.category][A.name] = A
	return filtered_uplink_items


/**
 * Uplink Items
 *
 * Items that can be spawned from an uplink. Can be limited by gamemode.
**/
/datum/uplink_item
	var/name = "item name"
	var/category = "item category"
	var/desc = "item description"
	var/item = null // Path to the item to spawn.
	var/refund_path = null // Alternative path for refunds, in case the item purchased isn't what is actually refunded (ie: holoparasites).
	var/cost = 0
	var/refund_amount = 0 // specified refund amount in case there needs to be a TC penalty for refunds.
	var/refundable = FALSE
	var/surplus = 100 // Chance of being included in the surplus crate.
	var/surplus_nullcrates //Chance of being included in null crates. null = pull from surplus
	var/cant_discount = FALSE
	var/limited_stock = -1 //Setting this above zero limits how many times this item can be bought by the same traitor in a round, -1 is unlimited
	var/list/include_modes = list() // Game modes to allow this item in.
	var/list/exclude_modes = list() // Game modes to disallow this item from.
	var/list/restricted_roles = list() //If this uplink item is only available to certain roles. Roles are dependent on the frequency chip or stored ID.
	var/player_minimum //The minimum crew size needed for this item to be added to uplinks.
	var/purchase_log_vis = TRUE // Visible in the purchase log?
	var/restricted = FALSE // Adds restrictions for VR/Events

/datum/uplink_item/New()
	. = ..()
	if(isnull(surplus_nullcrates))
		surplus_nullcrates = surplus

/datum/uplink_item/proc/get_discount()
	return pick(4;0.75,2;0.5,1;0.25)

/datum/uplink_item/proc/purchase(mob/user, datum/component/uplink/U)
	var/atom/A = spawn_item(item, user, U)
	if(purchase_log_vis && U.purchase_log)
		U.purchase_log.LogPurchase(A, src, cost)

/datum/uplink_item/proc/spawn_item(spawn_path, mob/user, datum/component/uplink/U)
	if(!spawn_path)
		return
	var/atom/A
	if(ispath(spawn_path))
		A = new spawn_path(get_turf(user))
	else
		A = spawn_path
	if(ishuman(user) && istype(A, /obj/item))
		var/mob/living/carbon/human/H = user
		if(H.put_in_hands(A))
			to_chat(H, "[A] materializes into your hands!")
			return A
	to_chat(user, "[A] materializes onto the floor.")
	return A

//Discounts (dynamically filled above)
/datum/uplink_item/discounts
	category = "Discounted Gear"

//Order for restictions

//Non-Clown-Ops

//Non-Nuke-Ops

//Non-Any-Ops

//Clown-Ops-Only

//Nuke-Ops-Only

//Both Ops

//Any-one