/datum/round_event_control/easter
	name = "Easter Eggselence"
	holidayID = EASTER
	typepath = /datum/round_event/easter
	weight = -1
	max_occurrences = 1
	earliest_start = 0 MINUTES

/datum/round_event/easter/announce(fake)
	priority_announce(pick("Hip-hop into Easter!","Find some Bunny's stash!","Today is National 'Hunt a Wabbit' Day.","Be kind, give Chocolate Eggs!"))


/datum/round_event_control/rabbitrelease
	name = "Release the Rabbits!"
	holidayID = EASTER
	typepath = /datum/round_event/rabbitrelease
	weight = 5
	max_occurrences = 10

/datum/round_event/rabbitrelease/announce(fake)
	priority_announce("Unidentified furry objects detected coming aboard [station_name()]. Beware of Adorable-ness.", "Fluffy Alert", "aliens")


/datum/round_event/rabbitrelease/start()
	for(var/obj/effect/landmark/R in GLOB.landmarks_list)
		if(R.name != "blobspawn")
			if(prob(35))
				if(isspaceturf(R.loc))
					new /mob/living/simple_animal/chicken/rabbit/space(R.loc)
				else
					new /mob/living/simple_animal/chicken/rabbit(R.loc)

/mob/living/simple_animal/chicken/rabbit
	name = "\improper rabbit"
	desc = "The hippiest hop around."
	icon = 'icons/mob/easter.dmi'
	icon_state = "rabbit_white"
	icon_living = "rabbit_white"
	icon_dead = "rabbit_white_dead"
	speak = list("Hop into Easter!","Come get your eggs!","Prizes for everyone!")
	speak_emote = list("sniffles","twitches")
	emote_hear = list("hops.")
	emote_see = list("hops around","bounces up and down")
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 1)
	egg_type = /obj/item/reagent_containers/food/snacks/egg/loaded
	food_type = /obj/item/reagent_containers/food/snacks/grown/carrot
	eggsleft = 10
	eggsFertile = FALSE
	icon_prefix = "rabbit"
	feedMessages = list("It nibbles happily.","It noms happily.")
	layMessage = list("hides an egg.","scampers around suspiciously.","begins making a huge racket.","begins shuffling.")

/mob/living/simple_animal/chicken/rabbit/space
	icon_prefix = "s_rabbit"
	icon_state = "s_rabbit_white"
	icon_living = "s_rabbit_white"
	icon_dead = "s_rabbit_white_dead"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	unsuitable_atmos_damage = 0

//Easter Baskets
/obj/item/storage/bag/easterbasket
	name = "Easter Basket"
	icon = 'icons/mob/easter.dmi'
	icon_state = "basket"

/obj/item/storage/bag/easterbasket/Initialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.can_hold = typecacheof(list(/obj/item/reagent_containers/food/snacks/egg, /obj/item/reagent_containers/food/snacks/chocolateegg, /obj/item/reagent_containers/food/snacks/boiledegg))

/obj/item/storage/bag/easterbasket/proc/countEggs()
	cut_overlays()
	add_overlay("basket-grass")
	add_overlay("basket-egg[min(contents.len, 5)]")

/obj/item/storage/bag/easterbasket/Exited()
	. = ..()
	countEggs()

/obj/item/storage/bag/easterbasket/Entered()
	. = ..()
	countEggs()

//Bunny Suit
/obj/item/clothing/head/bunnyhead
	name = "Easter Bunny Head"
	icon_state = "bunnyhead"
	item_state = "bunnyhead"
	desc = "Considerably more cute than 'Frank'."
	slowdown = -1
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

/obj/item/clothing/suit/bunnysuit
	name = "Easter Bunny Suit"
	desc = "Hop Hop Hop!"
	icon_state = "bunnysuit"
	item_state = "bunnysuit"
	slowdown = -1
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

//Egg prizes and egg spawns!
/obj/item/reagent_containers/food/snacks/egg
	var/containsPrize = FALSE

/obj/item/reagent_containers/food/snacks/egg/loaded
	containsPrize = TRUE

/obj/item/reagent_containers/food/snacks/egg/loaded/Initialize()
	. = ..()
	var/eggcolor = pick("blue","green","mime","orange","purple","rainbow","red","yellow")
	icon_state = "egg-[eggcolor]"
/obj/item/reagent_containers/food/snacks/egg/proc/dispensePrize(turf/where)
	var/won = pick(/obj/item/clothing/head/bunnyhead,
	/obj/item/clothing/suit/bunnysuit,
	/obj/item/reagent_containers/food/snacks/grown/carrot,
	/obj/item/reagent_containers/food/snacks/chocolateegg,
	/obj/item/toy/balloon,
	/obj/item/toy/gun,
	/obj/item/toy/sword,
	/obj/item/toy/foamblade,
	/obj/item/toy/prize/ripley,
	/obj/item/toy/prize/honk,
	/obj/item/toy/plush/carpplushie,
	/obj/item/toy/redbutton,
	/obj/item/clothing/head/collectable/rabbitears)
	new won(where)
	new/obj/item/reagent_containers/food/snacks/chocolateegg(where)

/obj/item/reagent_containers/food/snacks/egg/attack_self(mob/user)
	..()
	if(containsPrize)
		to_chat(user, "<span class='notice'>You unwrap [src] and find a prize inside!</span>")
		dispensePrize(get_turf(user))
		containsPrize = FALSE
		qdel(src)

/*
Easter Recipes + Food moved to appropriate files.
\code\modules\food_and_drinks\
\code\modules\food_and_drinks\recipes\
*/