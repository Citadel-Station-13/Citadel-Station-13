
/*Finished food! This means someone has cooked a food dish
* Were not done yet with are cooking \
* We MUST make sure to plate or bowl the food \
* If a Dish needs a plate See    (Ex Fryed eggs)
* If a Dish needs a bowl  See    (Ex Sunday)
* If a Dish needs a ladle See    (Ex Soup)
* If a Dish needs a spatula See  (Ex Pancake)
* If a Dish needs a fork See     (Ex Pasta)
*
*/
/obj/item/trillcook/finished //The fail safe
	name = "You should not see this" //What its called
	desc = "I done goof wah. Please report this on Github" //What we see when looking at it
	icon_state = "wah" //Sprite in file
	icon = 'icons/obj/kitchen.dmi'//Were the sprite file is located
	var/cooked_item = null//What is the dish?
	var/used_item = null //What item is the cooked dish in? i.e Pot/Pan/Tray
	var/plate = FALSE //Do we use a plate to complete the dish?
	//var/bowl = FALSE //Do we use a bowl to complete the dish?
	//var/knife = FALSE //Do we use a knife if complete the dish?
	//var/combo_ladle = FALSE //Do we use a ladle to progress?
	//var/combo_spatula = FALSE //Do we use a spatula to progress?
	//var/combo_fork = FALSE  //Do we use a fork to progress

/obj/item/trillcook/finished/attackby(obj/item/A, mob/user, params)
	.=..()
	if(istype(A, /obj/item/kitchen/plate) && plate != FALSE)
		to_chat(user, "<span class='notice'>You plate the dish.</span>")
		qdel(src) //This is to remove the attacked item
		qdel(A) //This is to remove the clean plate
		return

/obj/item/trillcook/finished/Destroy() //This does mean bombs/shooting will make items.
	var/turf/T = get_turf(src) //Were do we place are new items?
	var/U = used_item //What we used to cook
	var/F = cooked_item //What we cooked
	new U(T) //This spawns the used item on the tile
	new F(T) //This spawns the cooked dish on the tile
	return ..()

/obj/item/trillcook/finished/debug/fryeggs //Ex Fryed eggs
	name = "debug eggs" //Name is name
	desc = "for show and tell." //What is the description of the food (I.E what does it say when we look at it)
	icon_state = "cooking_pan_full_alt" //What does it look like
	plate = TRUE //This shows that it MUST be attacked with a plate
	used_item = /obj/item/kitchen/frying_pan //This is the item used to cook the dish that will be reclaimed
	cooked_item = /obj/item/reagent_containers/food/snacks/friedegg //This is the cooked dish that will be reclaimed
