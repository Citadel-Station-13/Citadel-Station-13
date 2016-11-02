//This is what happens when I get bored. Modular dildos is what happens.
obj/item/weapon/dildo
	name 				= "dildo"
	desc 				= "Floppy!"
	icon 				= 'icons/obj/dildo.dmi'
	damtype 			= BRUTE
	force 				= 0
	throwforce			= 0
	icon_state 			= "dildo_knotted_2"
	alpha 				= 192//transparent
	var/can_customize	= FALSE
	var/dildo_shape 	= "human"
	var/dildo_size		= COCK_SIZE_NORMAL
	var/dildo_type		= "dildo"
	var/random_color 	= TRUE
	var/random_size 	= FALSE
	var/random_shape 	= FALSE
	var/list/possible_colors = list(
		"#00f9ff",//cyan
		"#49ff00",//green
		"#ff4adc",//pink
		"#fdff00",//yellow
		"#00d2ff",//blue
		"#89ff00",//lime
		"#00002e",//almostblack
		"#ff0000",//red
		"#ff9a00",//orange
		"#e300ff"//purple
		)
	var/list/possible_shapes = list(
		"human",
		"knotted"
		)
	var/list/possible_sizes = list(
		COCK_SIZE_SMALL,
		COCK_SIZE_NORMAL,
		COCK_SIZE_BIG
		)

obj/item/weapon/dildo/proc/update_appearance()
	icon_state = "[dildo_type]_[dildo_shape]_[dildo_size]"
	var/sizeword = ""
	switch(dildo_size)
		if(COCK_SIZE_NORMAL)
			sizeword = ""
		if(COCK_SIZE_SMALL)
			sizeword = "small "
		if(COCK_SIZE_BIG)
			sizeword = "big "
		else
			sizeword = ""
	name = "[sizeword][dildo_shape] [dildo_type]"

obj/item/weapon/dildo/AltClick
obj/item/weapon/dildo/proc/customize(mob/living/user)

obj/item/weapon/dildo/New()
	..()
	if(random_color == TRUE)
		var/randcolor = pick(possible_colors)
		color = randcolor
	if(random_shape == TRUE)
		var/randshape = pick(possible_shapes)
		dildo_shape = randshape
	if(random_size == TRUE)
		var/randsize = pick(possible_sizes)
		dildo_size = randsize
	update_appearance()

obj/item/weapon/dildo/random//totally random
	name 				= "random dildo"//this name will show up in vendors and shit so you don't know what you're getting
	random_color 		= TRUE
	random_shape 		= TRUE
	random_size 		= TRUE

obj/item/weapon/dildo/knotted
	dildo_shape 		= "knotted"
	name 				= "knotted dildo"

obj/item/weapon/dildo/human
	dildo_shape 		= "human"
	name 				= "normal dildo"
