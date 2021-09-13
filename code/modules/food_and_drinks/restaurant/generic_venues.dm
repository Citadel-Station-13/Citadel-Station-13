
/////RESTAURANT/////
/datum/venue/restaurant
	name = "restaurant"
	req_access = ACCESS_KITCHEN
	venue_type = VENUE_RESTAURANT
	min_time_between_visitor = 80 SECONDS
	max_time_between_visitor = 100 SECONDS
	customer_types = list(
		/datum/customer_data/american = 50,
		/datum/customer_data/italian = 30,
		/datum/customer_data/french = 30,
		/datum/customer_data/mexican = 30,
		/datum/customer_data/japanese = 30,
		/datum/customer_data/japanese/salaryman = 20,
		/datum/customer_data/british/bobby = 20,
		/datum/customer_data/british/gent = 20,
		/datum/customer_data/moth = 1,
		/datum/customer_data/malfunction = 1,
	)

/datum/venue/restaurant/order_food(mob/living/simple_animal/robot_customer/customer_pawn, datum/customer_data/customer_data)
	var/obj/item/object_to_order = customer_data.get_order(src)

	. = object_to_order

	customer_pawn.say(order_food_line(object_to_order))

	var/appearance = SSrestaurant.food_appearance_cache[object_to_order]

	if(!appearance) //We havn't made this one before, do so now.
		var/obj/item/temp_object = new object_to_order() //Make a temp object so we can see it including any overlays
		appearance = temp_object.appearance //And then steal its appearance
		SSrestaurant.food_appearance_cache[object_to_order] = appearance //and cache it for future orders
		qdel(temp_object)

	var/image/I = image(icon = 'icons/obj/machines/restaurant_portal.dmi' , icon_state = "thought_bubble", loc = customer_pawn)

	I.appearance = appearance
	I.underlays += mutable_appearance(icon = 'icons/obj/machines/restaurant_portal.dmi' , icon_state = "thought_bubble")
	I.pixel_y = 32
	I.pixel_x = 16
	I.plane = HUD_PLANE
	I.appearance_flags = RESET_COLOR
	customer_pawn.hud_to_show_on_hover = customer_pawn.add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/food_demands, "food_thoughts", I)

/datum/venue/restaurant/is_correct_order(atom/movable/object_used, wanted_item)
	return object_used.type == wanted_item

/datum/venue/restaurant/order_food_line(obj/item/order)
	return "I'll take \a [initial(order.name)]"

/datum/venue/restaurant/on_get_order(mob/living/simple_animal/robot_customer/customer_pawn, obj/item/order_item)
	. = ..()
	var/obj/item/food/ordered_food = order_item
	customer_pawn.visible_message(span_danger("[customer_pawn] pushes [ordered_food] into their mouth-shaped hole!"), span_danger("You push [ordered_food] into your mouth-shaped hole."))
	playsound(get_turf(customer_pawn),'sound/items/eatfood.ogg', rand(10,50), TRUE)
	customers_served += 1
	qdel(ordered_food)

/obj/machinery/restaurant_portal/restaurant
	linked_venue = /datum/venue/restaurant
/obj/item/holosign_creator/robot_seat/restaurant
	name = "restaurant seating indicator placer"
	holosign_type = /obj/structure/holosign/robot_seat/restaurant

/obj/structure/holosign/robot_seat/restaurant
	name = "restaurant seating"
	linked_venue = /datum/venue/restaurant




/////BAR/////
/datum/venue/bar
	name = "bar"
	req_access = ACCESS_BAR
	venue_type = VENUE_BAR
	min_time_between_visitor = 40 SECONDS
	max_time_between_visitor = 60 SECONDS
	customer_types = list(
		/datum/customer_data/american = 50,
		/datum/customer_data/italian = 30,
		/datum/customer_data/french = 30,
		/datum/customer_data/mexican = 30,
		/datum/customer_data/japanese = 30,
		/datum/customer_data/japanese/salaryman = 20,
		/datum/customer_data/british/bobby = 20,
		/datum/customer_data/british/gent = 20,
		/datum/customer_data/malfunction = 1,
	)

/datum/venue/bar/order_food(mob/living/simple_animal/robot_customer/customer_pawn, datum/customer_data/customer_data)
	var/datum/reagent/reagent_to_order = pickweight(customer_data.orderable_objects[venue_type])

	var/glass_visual

	if(initial(reagent_to_order.glass_icon_state))
		glass_visual = initial(reagent_to_order.glass_icon_state)
	else if(initial(reagent_to_order.shot_glass_icon_state))
		glass_visual = initial(reagent_to_order.shot_glass_icon_state)
	else if(initial(reagent_to_order.fallback_icon_state))
		glass_visual = initial(reagent_to_order.fallback_icon_state)
	else
		CRASH("[reagent_to_order] has no icon sprite for restaurant code, please set a fallback_icon_state for this reagent.")

	customer_pawn.say(order_food_line(reagent_to_order))

	var/image/I = image(icon = 'icons/obj/machines/restaurant_portal.dmi' , icon_state = "thought_bubble", loc = customer_pawn)
	I.add_overlay(mutable_appearance('icons/obj/drinks.dmi', glass_visual))
	I.pixel_y = 32
	I.pixel_x = 16
	I.plane = HUD_PLANE
	I.appearance_flags = RESET_COLOR
	customer_pawn.hud_to_show_on_hover = customer_pawn.add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/food_demands, "food_thoughts", I)

	return reagent_to_order

/datum/venue/bar/order_food_line(datum/reagent/order)
	return "I'll take a glass of [initial(order.name)]"

/datum/venue/bar/on_get_order(mob/living/simple_animal/robot_customer/customer_pawn, obj/item/order_item)
	var/datum/reagent/consumable/ordered_reagent_type = customer_pawn.ai_controller.blackboard[BB_CUSTOMER_CURRENT_ORDER]

	for(var/datum/reagent/reagent as anything in order_item.reagents.reagent_list)
		if(reagent.type != ordered_reagent_type)
			continue
		SEND_SIGNAL(reagent, COMSIG_ITEM_SOLD_TO_CUSTOMER, customer_pawn, order_item)

	customer_pawn.visible_message(span_danger("[customer_pawn] slurps up [order_item] in one go!"), span_danger("You slurp up [order_item] in one go."))
	playsound(get_turf(customer_pawn), 'sound/items/drink.ogg', 50, TRUE)
	customers_served += 1
	order_item.reagents.clear_reagents()


///The bar needs to have a minimum amount of the reagent
/datum/venue/bar/is_correct_order(object_used, wanted_item)
	if(istype(object_used, /obj/item/reagent_containers/food/drinks))
		var/obj/item/reagent_containers/food/drinks/potential_drink = object_used
		return potential_drink.reagents.has_reagent(wanted_item, VENUE_BAR_MINIMUM_REAGENTS)
/obj/machinery/restaurant_portal/bar
	linked_venue = /datum/venue/bar

/obj/item/holosign_creator/robot_seat/bar
	name = "bar seating indicator placer"
	holosign_type = /obj/structure/holosign/robot_seat/bar

/obj/structure/holosign/robot_seat/bar
	name = "bar seating"
	linked_venue = /datum/venue/bar
