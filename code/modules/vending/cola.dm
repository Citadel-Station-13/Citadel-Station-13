/obj/machinery/vending/cola
	name = "\improper Robust Softdrinks"
	desc = "A softdrink vendor provided by Robust Industries, LLC."
	icon_state = "Cola_Machine"
	product_slogans = "Robust Softdrinks: More robust than a toolbox to the head!"
	product_ads = "Refreshing!;Hope you're thirsty!;Over 1 million drinks sold!;Thirsty? Why not cola?;Please, have a drink!;Drink up!;The best drinks in space."
	products = list(/obj/item/reagent_containers/food/drinks/soda_cans/cola = 10,
		            /obj/item/reagent_containers/food/drinks/soda_cans/space_mountain_wind = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/dr_gibb = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/starkist = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/space_up = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pwr_game = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/lemon_lime = 10,
					/obj/item/reagent_containers/glass/beaker/waterbottle = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pepsi = 10)
	contraband = list(/obj/item/reagent_containers/food/drinks/soda_cans/thirteenloko = 6,
		              /obj/item/reagent_containers/food/drinks/soda_cans/shamblers = 6,
		              /obj/item/reagent_containers/food/drinks/soda_cans/pepsi/deluxe = 3)
	premium = list(/obj/item/reagent_containers/food/drinks/drinkingglass/filled/nuka_cola = 1,
		           /obj/item/reagent_containers/food/drinks/soda_cans/air = 1)
	refill_canister = /obj/item/vending_refill/cola

/obj/item/vending_refill/cola
	machine_name = "Robust Softdrinks"
	icon_state = "refill_cola"

/obj/machinery/vending/cola/random
	name = "\improper Random Drinkies"
	icon_state = "random_cola"
	desc = "Uh oh!"

/obj/machinery/vending/cola/random/Initialize()
	..()
	var/T = pick(subtypesof(/obj/machinery/vending/cola) - /obj/machinery/vending/cola/random)
	new T(loc)
	return INITIALIZE_HINT_QDEL

/obj/machinery/vending/cola/blue
	icon_state = "Cola_Machine"

/obj/machinery/vending/cola/black
	icon_state = "cola_black"

/obj/machinery/vending/cola/red
	icon_state = "red_cola"
	name = "\improper Space Cola Vendor"
	desc = "It vends cola, in space."
	product_slogans = "Cola in space!"

/obj/machinery/vending/cola/space_up
	icon_state = "space_up"
	name = "\improper Space-up! Vendor"
	desc = "Indulge in an explosion of flavor."
	product_slogans = "Space-up! Like a hull breach in your mouth."

/obj/machinery/vending/cola/starkist
	icon_state = "starkist"
	name = "\improper Star-kist Vendor"
	desc = "The taste of a star in liquid form."
	product_slogans = "Drink the stars! Star-kist!"

/obj/machinery/vending/cola/sodie
	icon_state = "soda"

/obj/machinery/vending/cola/pwr_game
	icon_state = "pwr_game"
	name = "\improper Pwr Game Vendor"
	desc = "You want it, we got it. Brought to you in partnership with Vlad's Salads."
	product_slogans = "The POWER that gamers crave! PWR GAME!"

/obj/machinery/vending/cola/shamblers
	name = "\improper Shambler's Vendor"
	desc = "~Shake me up some of that Shambler's Juice!~"
	icon_state = "shamblers_juice"
	products = list(/obj/item/reagent_containers/food/drinks/soda_cans/cola = 10,
		            /obj/item/reagent_containers/food/drinks/soda_cans/space_mountain_wind = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/dr_gibb = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/starkist = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/space_up = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pwr_game = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/lemon_lime = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pepsi = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/shamblers = 10)
	product_slogans = "~Shake me up some of that Shambler's Juice!~"
	product_ads = "Refreshing!;Jyrbv dv lg jfdv fw kyrk Jyrdscvi'j Alztv!;Over 1 trillion souls drank!;Thirsty? Nyp efk uizeb kyv uribevjj?;Kyv Jyrdscvi uizebj kyv ezxyk!;Drink up!;Krjkp."

/obj/machinery/vending/cola/pepsivend
	icon_state = "pepsi"
	name = "\improper PepsiVend"
	desc = "Clogs up your veins faster than the supermatter clogs the pipes with hot plasma!"
	product_slogans = "Pepsi! Originally helped you with digestion, now actively worsens it.;Cures depression, creates diabetes!"

/obj/machinery/vending/cola/bepis
	icon_state = "bepis"
	name = "\improper Cool Bepis Machine"
	products = list(/obj/item/reagent_containers/food/drinks/soda_cans/cola = 10,
		            /obj/item/reagent_containers/food/drinks/soda_cans/space_mountain_wind = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/dr_gibb = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/starkist = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/space_up = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pwr_game = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/lemon_lime = 10,
					/obj/item/reagent_containers/glass/beaker/waterbottle = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pepsi = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pepsi/bepis = 10)
	desc = "Bepis. A drincc. With no icce included."
	product_slogans = "AWOOOOOOOO!;GOBBLE GOBBLE; A drincc, for carbon based lifeforms. (Especially Canis lupus Familiaris of the race Shiba Inu.);The perfect drink for your doggo!;"

/obj/machinery/vending/cola/conk
	icon_state = "conk"
	name = "\improper Conker"
	desc = "We fucking hate you and hope you die."
	products = list(/obj/item/reagent_containers/food/drinks/soda_cans/cola = 10,
		            /obj/item/reagent_containers/food/drinks/soda_cans/space_mountain_wind = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/dr_gibb = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/starkist = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/space_up = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pwr_game = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/lemon_lime = 10,
					/obj/item/reagent_containers/glass/beaker/waterbottle = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pepsi = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pepsi/conk = 10)
	product_slogans = "Buy a can, or get canned!; Take a shot or get lost!; Poison in a can.; Literally just fucking canned rats."

/obj/machinery/vending/cola/pepe
	icon_state = "pepe"
	name = "\improper Pepe Merchant"
	desc = "Directly from 4chan, and tastes absolutely like it."
	products = list(/obj/item/reagent_containers/food/drinks/soda_cans/cola = 10,
		            /obj/item/reagent_containers/food/drinks/soda_cans/space_mountain_wind = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/dr_gibb = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/starkist = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/space_up = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pwr_game = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/lemon_lime = 10,
					/obj/item/reagent_containers/glass/beaker/waterbottle = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pepsi = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pepsi/pepe = 10)
	product_slogans = "Drink me before you commit mass murder!; Come on anon, you fucking pussy!; Orange man bad? Green drink good!"

/obj/machinery/vending/cola/endme
	icon_state = "endme"
	name = "\improper Deprepssi"
	desc = "Tastes bland, just like your life."
	products = list(/obj/item/reagent_containers/food/drinks/soda_cans/cola = 10,
		            /obj/item/reagent_containers/food/drinks/soda_cans/space_mountain_wind = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/dr_gibb = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/starkist = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/space_up = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pwr_game = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/lemon_lime = 10,
					/obj/item/reagent_containers/glass/beaker/waterbottle = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pepsi = 10,
					/obj/item/reagent_containers/food/drinks/soda_cans/pepsi/endme = 10)
	product_slogans = "Dopamine levels low? Make it lower!; We'll all just die some day, so why don't you just buy it?; It doesn't matter if you buy us anyways.;Soft drink, hard life.;"
