/obj/item/clothing/gloves/mittens
	desc = "These gloves will keep your hands warm!"
	name = "mittens"
	icon_state = "mittens"
	item_state = "wgloves"
	item_color = "white"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	resistance_flags = NONE

/obj/item/clothing/gloves/mittens/random

/obj/item/clothing/gloves/mittens/random/New()
	var/colours = ("black", "yellow", "lightbrown", "brown", "orange", "red", "purple", "green", "blue", "kitten")
	var/picked_c = pick(colours)
	if(picked == "kitten")
		new /obj/item/clothing/gloves/mittens/kitten(loc)
		qdel(src)
		return
	item_state = "[picked_c]gloves"
	item_color = "[picked_c]"
	colour = picked_c

/obj/item/clothing/gloves/mittens/kitten
	name = "Kitten mittens"
	desc = "These gloves will keep your hands warm, and feature cure kittens"
	icon_state = "kittenmittens"
	item_state = "blackgloves"
	item_color = "black"
