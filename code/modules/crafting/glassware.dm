//This file is for glass working types of things!

/obj/item/glasswork
	name = "This is a bug report it!"
	desc = "Failer to code. Contact your local bug remover..."
	icon = 'icons/obj/glassworks.dmi'
	w_class = WEIGHT_CLASS_SMALL
	force = 0
	throw_speed = 1
	throw_range = 3

/obj/item/glasswork/glasskit
	name = "Glass Working Tools"
	desc = "A lovely belt of most the tools you will need to shape, mold, and refine glass into more advanced shapes."
	icon_state = "glass_tools"

/obj/item/glasswork/blowing_rod
	name = "Glass Working Blow Rod"
	desc = "A hollow metal stick made for glass blowing."
	icon_state = "blowing_rods_unused"

/obj/item/glasswork/glass_base
	name = "Glass Fodder Sheet"
	desc = "A sheet of glass set aside for glass working"
	icon_state = "glass_base"
	var/next_step = null
	var/make = null
	var/rod = /obj/item/glasswork/blowing_rod

/obj/item/lens
	name = "Optical Lens"
	desc = "Good for selling or crafting, by itself its useless"

//////////////////////Chem Disk/////////////////////
//Two Steps                                       //
//Sells for 300 cr, takes 10 glass shets           //
//Usefull for chem spliting                       //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/dish
	name = "Glass Fodder Sheet"
	desc = "A set of glass sheets set aside for glass working, this one is ideal for a small glass dish. Needs to be cut with some tools."
	next_step = /obj/item/glasswork/glass_base/glass_dish
	make = /obj/item/reagent_containers/glass/beaker/glass_dish

/obj/item/glasswork/glass_base/dish/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/glasswork/glass_base))
		new next_step(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/dish)

/obj/item/glasswork/glass_base/glass_dish
	name = "Half Chem Dish Sheet"
	desc = "A sheet of glass cut in half, looks like it still needs some more sanding down"
	icon_state = "glass_base_half"

/obj/item/glasswork/glass_base/glass_dish/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/glasswork/glass_base))
		new make(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/glass_dish)

//////////////////////Lens//////////////////////////
//Six Steps                                       //
//Sells for 1800 cr, takes 15 glass shets         //
//Usefull for selling and later crafting          //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/lens
	name = "Glass Fodder Sheet"
	desc = "A set of glass sheets set aside for glass working, this one is ideal for a small glass lens. Needs to be cut with some tools."
	next_step = /obj/item/glasswork/glass_base/glass_dish
	make = /obj/item/lens

/obj/item/glasswork/glass_base/lens/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/glasswork/glass_base))
		new next_step(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/lens)

/obj/item/glasswork/glass_base/glass_lens
	name = "Glass Fodder Sheet"
	desc = "Cut glass ready to be heated. Needs to be heated with some tools."
	icon_state = "glass_base_half"
	next_step = /obj/item/glasswork/glass_base/glass_lens/part2

/obj/item/glasswork/glass_base/glass_lens/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/weldingtool))
		new next_step(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/glass_lens)

/obj/item/glasswork/glass_base/glass_lens/part2
	name = "Glass Fodder Sheet"
	desc = "Cut glass that has been heated. Needs to be heated more with some tools."
	icon_state = "glass_base_heat"
	next_step = /obj/item/glasswork/glass_base/glass_lens/part3

/obj/item/glasswork/glass_base/glass_lens/part2/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/weldingtool))
		new next_step(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/glass_lens/part2)

/obj/item/glasswork/glass_base/glass_lens/part3
	name = "Glass Fodder Sheet"
	desc = "Cut glass that has been heated into a blob of hot glass. Needs to be placed onto a blow tube."
	icon_state = "glass_base_molding"
	next_step = /obj/item/glasswork/glass_base/glass_lens/part4

/obj/item/glasswork/glass_base/glass_lens/part3/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/glasswork/blowing_rod))
		new next_step(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/glass_lens/part3)
		qdel(I)

/obj/item/glasswork/glass_base/glass_lens/part4
	name = "Glass Fodder Sheet"
	desc = "Cut glass that has been heated into a blob of hot glass. Needs to be cut off onto a blow tube."
	icon_state = "blowing_rods_inuse"
	next_step = /obj/item/glasswork/glass_base/glass_lens/part5

/obj/item/glasswork/glass_base/glass_lens/part4/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/glasswork/glass_base))
		new next_step(user.loc, 1)
		new rod(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/glass_lens/part4)

/obj/item/glasswork/glass_base/glass_lens/part5
	name = "Unpolished glass lens"
	desc = "A small unpolished glass lens. Could be polished with some cloth."
	icon_state = "glass_optics"
	next_step = /obj/item/glasswork/glass_base/glass_lens/part6

/obj/item/glasswork/glass_base/glass_lens/part5/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/stack/sheet/cloth))
		new next_step(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/glass_lens/part5)

/obj/item/glasswork/glass_base/glass_lens/part6
	name = "Unrefined glass lens"
	desc = "A small polished glass lens. Just needs to be refined with some sandstone."
	icon_state = "glass_optics"

/obj/item/glasswork/glass_base/glass_lens/part6/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/stack/sheet/mineral/sandstone))
		new make(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/glass_lens/part6)

//////////////////////Spouty Flask//////////////////
//Four Steps                                      //
//Sells for 1200 cr, takes 20 glass shets         //
//Usefull for selling and chemical things         //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/spouty
	name = "Glass Fodder Sheet"
	desc = "A set of glass sheets set aside for glass working, this one is ideal for a spout beaker. Needs to be cut with some tools."
	next_step = /obj/item/glasswork/glass_base/spouty/part2
	make = /obj/item/reagent_containers/glass/beaker/flaskspouty

/obj/item/glasswork/glass_base/spouty/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/glasswork/glass_base))
		new next_step(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/spouty)

/obj/item/glasswork/glass_base/spouty/part2
	name = "Glass Fodder Sheet"
	desc = "Cut glass that has been heated. Needs to be heated more with some tools."
	icon_state = "glass_base_heat"
	next_step = /obj/item/glasswork/glass_base/spouty/part3

/obj/item/glasswork/glass_base/spouty/part2/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/weldingtool))
		new next_step(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/spouty/part2)

/obj/item/glasswork/glass_base/spouty/part3
	name = "Glass Fodder Sheet"
	desc = "Cut glass that has been heated into a blob of hot glass. Needs to be placed onto a blow tube."
	icon_state = "glass_base_molding"
	next_step = /obj/item/glasswork/glass_base/spouty/part4

/obj/item/glasswork/glass_base/glass_lens/part3/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/glasswork/blowing_rod))
		new next_step(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/glass_lens/part3)
		qdel(I)

/obj/item/glasswork/glass_base/spouty/part4
	name = "Glass Fodder Sheet"
	desc = "Cut glass that has been heated into a blob of hot glass. Needs to be cut off onto a blow tube."
	icon_state = "blowing_rods_inuse"

/obj/item/glasswork/glass_base/spouty/part4/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/glasswork/glass_base))
		new make(user.loc, 1)
		new rod(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/spouty/part4)

//////////////////////Small Bulb Flask//////////////
//Two Steps                                       //
//Sells for 600 cr, takes 5 glass shets           //
//Usefull for selling and chemical things         //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/flask_small
	name = "Glass Fodder Sheet"
	desc = "A set of glass sheets set aside for glass working, this one is ideal for a small flask. Needs to be heated with some tools."
	next_step = /obj/item/glasswork/glass_base/flask_small/part1
	make = /obj/item/reagent_containers/glass/beaker/flask_small

/obj/item/glasswork/glass_base/flask_small/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/weldingtool))
		new next_step(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/flask_small)

/obj/item/glasswork/glass_base/flask_small/part1
	name = "Metled Glass"
	desc = "A blob of metled glass, this one is ideal for a small flask. Needs to be blown with some tools."
	icon_state = "glass_base_molding"
	next_step = /obj/item/glasswork/glass_base/spouty/part2

/obj/item/glasswork/glass_base/flask_small/part1/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/glasswork/blowing_rod))
		new next_step(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/flask_small/part1)
		qdel(I)

/obj/item/glasswork/glass_base/flask_small/part2
	name = "Metled Glass"
	desc = "A blob of metled glass on the end of a blowing rod. Needs to be cut off with some tools."
	icon_state = "blowing_rods_inuse"

/obj/item/glasswork/glass_base/flask_small/part2/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/glasswork/glass_base))
		new make(user.loc, 1)
		new rod(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/flask_small/part2)

//////////////////////Large Bulb Flask//////////////
//Two Steps                                       //
//Sells for 1000 cr, takes 15 glass shets         //
//Usefull for selling and chemical things         //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/flask_large
	name = "Glass Fodder Sheet"
	desc = "A set of glass sheets set aside for glass working, this one is ideal for a large flask. Needs to be heated with some tools."
	next_step = /obj/item/glasswork/glass_base/flask_large/part1
	make = /obj/item/reagent_containers/glass/beaker/flask_large

/obj/item/glasswork/glass_base/flask_large/part1/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/weldingtool))
		new next_step(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/flask_large/part1)

/obj/item/glasswork/glass_base/flask_large/part1
	name = "Metled Glass"
	desc = "A blob of metled glass, this one is ideal for a large flask. Needs to be blown with some tools."
	icon_state = "glass_base_molding"
	next_step = /obj/item/glasswork/glass_base/flask_large/part2

/obj/item/glasswork/glass_base/flask_large/part2/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/glasswork/blowing_rod))
		new next_step(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/flask_large/part2)
		qdel(I)

/obj/item/glasswork/glass_base/flask_large/part2
	name = "Metled Glass"
	desc = "A blob of metled glass on the end of a blowing rod. Needs to be cut off with some tools."
	icon_state = "blowing_rods_inuse"

/obj/item/glasswork/glass_base/flask_large/part2/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/glasswork/glass_base))
		new make(user.loc, 1)
		new rod(user.loc, 1)
		qdel(/obj/item/glasswork/glass_base/flask_large/part2)





