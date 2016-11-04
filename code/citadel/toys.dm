//Big file of sex toys and shit.
//Dildos
//Onaholes
//This is what happens when I get bored. Modular dildos is what happens.

//////////
//DILDOS//
//////////
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
	var/dildo_type		= "dildo"//pretty much just used for the icon state
	var/random_color 	= TRUE
	var/random_size 	= FALSE
	var/random_shape 	= FALSE
	//these lists are used to generate random icons, stats, and names
	var/list/possible_colors = list(//mostly neon colors
		"Cyan"		= "#00f9ff",//cyan
		"Green"		= "#49ff00",//green
		"Pink"		= "#ff4adc",//pink
		"Yellow"	= "#fdff00",//yellow
		"Blue"		= "#00d2ff",//blue
		"Lime"		= "#89ff00",//lime
		"Black"		= "#101010",//black(not totally, though)
		"Red"		= "#ff0000",//red
		"Orange"	= "#ff9a00",//orange
		"Purple"	= "#e300ff"//purple
		)
	var/list/possible_shapes = list(
		"Human"		= "human",
		"Knotted"	= "knotted",
		"Plain"		= "plain",
		"Flared"	= "flared"
		)
	var/list/possible_sizes = list(
		"Small"		= COCK_SIZE_SMALL,
		"Medium"	= COCK_SIZE_NORMAL,
		"Big"		= COCK_SIZE_BIG
		)

obj/item/weapon/dildo/proc/update_appearance()
	icon_state = "[dildo_type]_[dildo_shape]_[dildo_size]"
	var/sizeword = ""
	switch(dildo_size)
		if(COCK_SIZE_NORMAL)
			sizeword = ""
		if(COCK_SIZE_SMALL to -INFINITY)
			sizeword = "small "
		if(COCK_SIZE_BIG)
			sizeword = "big "
		if(COCK_SIZE_BIGGER)
			sizeword = "huge "
		if(COCK_SIZE_BIGGEST to INFINITY)
			sizeword = "gigantic "
		else
			sizeword = ""
	name = "[sizeword][dildo_shape][can_customize ? " customizable" : ""] [dildo_type]"

obj/item/weapon/dildo/AltClick(mob/living/user)
	customize(user)

obj/item/weapon/dildo/proc/customize(mob/living/user)
	if(!can_customize)
		return FALSE
	if(src &&!user.incapacitated() && in_range(user,src))
		var/color_choice = input(user,"Choose a color for your dildo.","Dildo Color") as null|anything in possible_colors
		if(src && color_choice && !user.incapacitated() && in_range(user,src))
			sanitize_inlist(color_choice, possible_colors, "Red")
			color = possible_colors[color_choice]
	update_appearance()
	if(src &&!user.incapacitated() && in_range(user,src))
		var/shape_choice = input(user,"Choose a shape for your dildo.","Dildo Shape") as null|anything in possible_shapes
		if(src && shape_choice && !user.incapacitated() && in_range(user,src))
			sanitize_inlist(shape_choice, possible_colors, "Knotted")
			dildo_shape = possible_shapes[shape_choice]
	update_appearance()
	if(src &&!user.incapacitated() && in_range(user,src))
		var/size_choice = input(user,"Choose the size of your dildo.","Dildo Size") as null|anything in possible_sizes
		if(src && size_choice && !user.incapacitated() && in_range(user,src))
			sanitize_inlist(size_choice, possible_colors, "Medium")
			dildo_size = possible_sizes[size_choice]
	update_appearance()
	if(src &&!user.incapacitated() && in_range(user,src))
		var/transparency_choice = input(user,"Choose the transparency of your dildo. Lower is more transparent!(192-255)","Dildo Transparency") as null|num
		if(src && transparency_choice && !user.incapacitated() && in_range(user,src))
			sanitize_integer(transparency_choice, 192, 255, 192)
			alpha = transparency_choice
	update_appearance()
	return TRUE

obj/item/weapon/dildo/New()
	..()
	if(random_color == TRUE)
		var/randcolor = pick(possible_colors)
		color = possible_colors[randcolor]
	if(random_shape == TRUE)
		var/randshape = pick(possible_shapes)
		dildo_shape = possible_shapes[randshape]
	if(random_size == TRUE)
		var/randsize = pick(possible_sizes)
		dildo_size = possible_sizes[randsize]
	update_appearance()
	alpha		= rand(192, 255)
	pixel_y 	= rand(-7,7)
	pixel_x 	= rand(-7,7)

obj/item/weapon/dildo/examine(mob/user)
	..()
	if(can_customize)
		user << "<span class='notice'>Alt-Click \the [src.name] to customize it.</span>"

obj/item/weapon/dildo/random//totally random
	name 				= "random dildo"//this name will show up in vendors and shit so you know what you're vending(or don't, i guess :^))
	random_color 		= TRUE
	random_shape 		= TRUE
	random_size 		= TRUE


obj/item/weapon/dildo/knotted
	dildo_shape 		= "knotted"
	name 				= "knotted dildo"

obj/item/weapon/dildo/human
	dildo_shape 		= "human"
	name 				= "human dildo"

obj/item/weapon/dildo/plain
	dildo_shape 		= "plain"
	name 				= "plain dildo"

obj/item/weapon/dildo/flared
	dildo_shape 		= "flared"
	name 				= "flared dildo"

obj/item/weapon/dildo/custom
	name 				= "customizable dildo"
	desc 				= "Thanks to significant advances in synthetic nanomaterials, this dildo is capable of taking on many different forms to fit the user's preference! Pricy!"
	can_customize		= TRUE
	random_color 		= TRUE
	random_shape 		= TRUE
	random_size 		= TRUE


////////////
//ONAHOLES//
////////////
obj/item/weapon/onahole
	name 				= "onahole"
	desc 				= "Better clean this when you're done!"
	icon 				= 'icons/obj/onahole.dmi'
	damtype 			= BRUTE
	force 				= 0
	throwforce			= 0
	icon_state 			= "onahole_plain_2"
	alpha 				= 192//transparent
	var/onahole_shape 	= "plain"
	var/onahole_size	= COCK_SIZE_NORMAL//used for 'tightness' or something
	var/onahole_type	= "onahole"//pretty much just used for the icon state
	var/random_color 	= TRUE
	var/random_size 	= FALSE
	var/random_shape 	= FALSE
	var/can_customize	= FALSE
	var/list/possible_colors = list(//mostly neon colors
		"Cyan"		= "#00f9ff",//cyan
		"Green"		= "#49ff00",//green
		"Pink"		= "#ff4adc",//pink
		"Yellow"	= "#fdff00",//yellow
		"Blue"		= "#00d2ff",//blue
		"Lime"		= "#89ff00",//lime
		"Black"		= "#101010",//black(not totally, though)
		"Red"		= "#ff0000",//red
		"Orange"	= "#ff9a00",//orange
		"Purple"	= "#e300ff"//purple
		)
	var/list/possible_shapes = list(
		"Plain"		= "plain"
		)
	var/list/possible_sizes = list(
		"Small"		= COCK_SIZE_SMALL,
		"Medium"	= COCK_SIZE_NORMAL,
		"Big"		= COCK_SIZE_BIG
		)

obj/item/weapon/onahole/New()
	..()
	if(random_color == TRUE)
		var/randcolor = pick(possible_colors)
		color = possible_colors[randcolor]
	if(random_shape == TRUE)
		var/randshape = pick(possible_shapes)
		onahole_shape = possible_shapes[randshape]
	if(random_size == TRUE)
		var/randsize = pick(possible_sizes)
		onahole_size = possible_sizes[randsize]
	update_appearance()
	alpha		= rand(192, 255)
	pixel_y 	= rand(-7,7)
	pixel_x 	= rand(-7,7)

obj/item/weapon/onahole/proc/update_appearance()
	icon_state = "[onahole_type]_[onahole_shape]_[onahole_size]"
	var/sizeword = ""
	switch(onahole_size)
		if(COCK_SIZE_NORMAL)
			sizeword = ""
		if(COCK_SIZE_SMALL to -INFINITY)
			sizeword = "small "
		if(COCK_SIZE_BIG)
			sizeword = "big "
		if(COCK_SIZE_BIGGER)
			sizeword = "huge "
		if(COCK_SIZE_BIGGEST to INFINITY)
			sizeword = "gigantic "
		else
			sizeword = ""
	name = "[sizeword][onahole_shape][can_customize ? " customizable" : ""] [onahole_type]"

obj/item/weapon/onahole/random
	name 				= "random onahole"
	random_color 		= TRUE
	random_shape 		= TRUE
	random_size 		= TRUE