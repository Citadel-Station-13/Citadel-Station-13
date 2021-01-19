/obj/machinery/vending/clothing/New(loc, ...)
	. = ..()
	products[/obj/item/clothing/head/wig] = 5
	for(var/P in typesof(/datum/gear/underwear))
		var/datum/gear/G = P
		products[initial(G.path)] = 5
	for(var/P in typesof(/datum/gear/shirt))
		var/datum/gear/G = P
		products[initial(G.path)] = 5
	for(var/P in typesof(/datum/gear/socks))
		var/datum/gear/G = P
		products[initial(G.path)] = 5
