/obj/item/clothing/gloves/mittens
	desc = "These gloves will keep your hands warm!"
	name = "mittens"
	icon_state = "mittens"
	item_state = "wgloves"
	//item_color = "white"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = COAT_MAX_TEMP_PROTECT
	resistance_flags = NONE

/obj/item/clothing/gloves/mittens/random

/obj/item/clothing/gloves/mittens/random/Initialize(mapload)
	..()
	var/colours = list("black", "yellow", "lightbrown", "brown", "orange", "red", "purple", "green", "blue", "kitten")
	var/picked_c = pick(colours)
	if(picked_c == "kitten")
		new /obj/item/clothing/gloves/mittens/kitten(loc)
		qdel(src)
		return INITIALIZE_HINT_QDEL
	item_state = "[picked_c]gloves"
	//item_color = "[picked_c]"
	color = picked_c

/obj/item/clothing/gloves/mittens/kitten
	name = "Kitten mittens"
	desc = "These gloves will keep your hands warm, and feature cute kittens"
	icon_state = "kittenmittens"
	item_state = "blackgloves"
	//item_color = "black"
