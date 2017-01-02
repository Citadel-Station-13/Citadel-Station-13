////////////////////////////////////////////////////////////////////////////////
/// Food.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/food
	possible_transfer_amounts = list()
	volume = 50	//Sets the default container amount for all food items.
	burn_state = FLAMMABLE

/obj/item/weapon/reagent_containers/food/New()
		..()
		pixel_x = rand(-5, 5)	//Randomizes postion slightly.
		pixel_y = rand(-5, 5)