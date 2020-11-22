//This file is for glass working types of things!

/obj/item/glasswork
	name = "This is a bug report it!"
	desc = "Failer to code. Contact your local bug remover..."
	icon = 'icons/obj/glassworks.dmi'
	w_class = WEIGHT_CLASS_SMALL
	force = 1
	throw_speed = 1
	throw_range = 3
	tool_behaviour = null

/obj/item/glasswork/glasskit
	name = "Glass working tools"
	desc = "A lovely belt of most the tools you will need to shape, mold, and refine glass into more advanced shapes."
	icon_state = "glass_tools"
	tool_behaviour = TOOL_GLASS_CUT //Cutting takes 20 ticks

/obj/item/glasswork/blowing_rod
	name = "Glass working blow rod"
	desc = "A hollow metal stick made for glass blowing."
	icon_state = "blowing_rods_unused"
	tool_behaviour = TOOL_BLOW //Rods take 5 ticks

/obj/item/glasswork/glass_base //Welding takes 30 ticks
	name = "Glass fodder sheet"
	desc = "A sheet of glass set aside for glass working"
	icon_state = "glass_base"
	var/next_step = null
	var/rod = /obj/item/glasswork/blowing_rod

/obj/item/tea_plate
	name = "Tea Plate"
	desc = "A polished plate for a tea cup. How fancy!"
	icon = 'icons/obj/glass_ware.dmi'
	icon_state = "tea_plate"

/obj/item/tea_cup
	name = "Tea Cup"
	desc = "A glass cup made for fake tea!"
	icon = 'icons/obj/glass_ware.dmi'
	icon_state = "tea_plate"

//////////////////////Chem Disk/////////////////////
//Two Steps                                       //
//Sells for 300 cr, takes 10 glass shets          //
//Usefull for chem spliting                       //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/dish
	name = "Glass fodder sheet"
	desc = "A set of glass sheets set aside for glass working, this one is ideal for a small glass dish. Needs to be cut with some tools."
	next_step = /obj/item/glasswork/glass_base/dish_part1

/obj/item/glasswork/glass_base/dish/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_GLASS_CUT)
		if(do_after(user,20, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/dish_part1
	name = "Half chem dish sheet"
	desc = "A sheet of glass cut in half, looks like it still needs some more cutting down"
	icon_state = "glass_base_half"
	next_step = /obj/item/reagent_containers/glass/beaker/glass_dish

/obj/item/glasswork/glass_base/dish_part1/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_GLASS_CUT)
		if(do_after(user,20, target = src))
			new next_step(user.loc, 1)
			qdel(src)

//////////////////////Lens//////////////////////////
//Six Steps                                       //
//Sells for 1600 cr, takes 15 glass shets         //
//Usefull for selling and later crafting          //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/glass_lens
	name = "Glass fodder sheet"
	desc = "A set of glass sheets set aside for glass working, this one is ideal for a small glass lens. Needs to be cut with some tools."
	next_step = /obj/item/glasswork/glass_base/glass_lens_part1

/obj/item/glasswork/glass_base/glass_lens/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_GLASS_CUT)
		if(do_after(user,20, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/glass_lens_part1
	name = "Glass fodder sheet"
	desc = "Cut glass ready to be heated. Needs to be heated with some tools."
	icon_state = "glass_base_half"
	next_step = /obj/item/glasswork/glass_base/glass_lens_part2

/obj/item/glasswork/glass_base/glass_lens_part1/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_WELDER)
		if(do_after(user,30, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/glass_lens_part2
	name = "Glass fodder sheet"
	desc = "Cut glass that has been heated. Needs to be heated more with some tools."
	icon_state = "glass_base_heat"
	next_step = /obj/item/glasswork/glass_base/glass_lens_part3

/obj/item/glasswork/glass_base/glass_lens_part2/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_WELDER)
		if(do_after(user,30, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/glass_lens_part3
	name = "Glass fodder sheet"
	desc = "Cut glass that has been heated into a blob of hot glass. Needs to be placed onto a blow tube."
	icon_state = "glass_base_molding"
	next_step = /obj/item/glasswork/glass_base/glass_lens_part4

/obj/item/glasswork/glass_base/glass_lens_part3/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_BLOW)
		if(do_after(user,5, target = src))
			new next_step(user.loc, 1)
			qdel(src)
			qdel(I)

/obj/item/glasswork/glass_base/glass_lens_part4
	name = "Glass fodder sheet"
	desc = "Cut glass that has been heated into a blob of hot glass. Needs to be cut off onto a blow tube."
	icon_state = "blowing_rods_inuse"
	next_step = /obj/item/glasswork/glass_base/glass_lens_part5

/obj/item/glasswork/glass_base/glass_lens_part4/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_GLASS_CUT)
		if(do_after(user,20, target = src))
			new next_step(user.loc, 1)
			new rod(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/glass_lens_part5
	name = "Unpolished glass lens"
	desc = "A small unpolished glass lens. Could be polished with some cloth."
	icon = 'icons/obj/glass_ware.dmi'
	icon_state = "glass_optics"
	next_step = /obj/item/glasswork/glass_base/glass_lens_part6

/obj/item/glasswork/glass_base/glass_lens_part5/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/stack/sheet/cloth))
		if(do_after(user,10, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/glass_lens_part6
	name = "Unrefined glass lens"
	desc = "A small polished glass lens. Just needs to be refined with some sandstone."
	icon = 'icons/obj/glass_ware.dmi'
	icon_state = "glass_optics"
	next_step = /obj/item/glasswork/glass_base/lens

/obj/item/glasswork/glass_base/glass_lens_part6/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/stack/sheet/mineral/sandstone))
		new next_step(user.loc, 1)
		qdel(src)

//////////////////////Spouty Flask//////////////////
//Four Steps                                      //
//Sells for 1200 cr, takes 20 glass shets         //
//Usefull for selling and chemical things         //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/spouty
	name = "Glass fodder sheet"
	desc = "A set of glass sheets set aside for glass working, this one is ideal for a spout beaker. Needs to be cut with some tools."
	next_step = /obj/item/glasswork/glass_base/spouty_part2

/obj/item/glasswork/glass_base/spouty/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_GLASS_CUT)
		if(do_after(user,20, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/spouty_part2
	name = "Glass fodder sheet"
	desc = "Cut glass that has been heated. Needs to be heated with some tools."
	icon_state = "glass_base_half"
	next_step = /obj/item/glasswork/glass_base/spouty_part3

/obj/item/glasswork/glass_base/spouty_part2/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_WELDER)
		if(do_after(user,30, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/spouty_part3
	name = "Glass fodder sheet"
	desc = "Cut glass that has been heated into a blob of hot glass. Needs to be placed onto a blow tube."
	icon_state = "glass_base_molding"
	next_step = /obj/item/glasswork/glass_base/spouty_part4

/obj/item/glasswork/glass_base/spouty_part3/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_BLOW)
		if(do_after(user,5, target = src))
			new next_step(user.loc, 1)
			qdel(src)
			qdel(I)

/obj/item/glasswork/glass_base/spouty_part4
	name = "Glass fodder sheet"
	desc = "Cut glass that has been heated into a blob of hot glass. Needs to be cut off onto a blow tube."
	icon_state = "blowing_rods_inuse"
	next_step = /obj/item/reagent_containers/glass/beaker/flask/spouty

/obj/item/glasswork/glass_base/spouty_part4/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_GLASS_CUT)
		if(do_after(user,20, target = src))
			new next_step(user.loc, 1)
			new rod(user.loc, 1)
			qdel(src)

//////////////////////Small Bulb Flask//////////////
//Two Steps                                       //
//Sells for 600 cr, takes 5 glass shets           //
//Usefull for selling and chemical things         //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/flask_small
	name = "Glass fodder sheet"
	desc = "A set of glass sheets set aside for glass working, this one is ideal for a small flask. Needs to be heated with some tools."
	next_step = /obj/item/glasswork/glass_base/flask_small_part1

/obj/item/glasswork/glass_base/flask_small/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_WELDER)
		if(do_after(user,30, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/flask_small_part1
	name = "Metled glass"
	desc = "A blob of metled glass, this one is ideal for a small flask. Needs to be blown with some tools."
	icon_state = "glass_base_molding"
	next_step = /obj/item/glasswork/glass_base/flask_small_part2

/obj/item/glasswork/glass_base/flask_small_part1/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_BLOW)
		if(do_after(user,5, target = src))
			new next_step(user.loc, 1)
			qdel(src)
			qdel(I)

/obj/item/glasswork/glass_base/flask_small_part2
	name = "Metled glass"
	desc = "A blob of metled glass on the end of a blowing rod. Needs to be cut off with some tools."
	icon_state = "blowing_rods_inuse"
	next_step = /obj/item/reagent_containers/glass/beaker/flask

/obj/item/glasswork/glass_base/flask_small_part2/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_GLASS_CUT)
		if(do_after(user,20, target = src))
			new next_step(user.loc, 1)
			new rod(user.loc, 1)
			qdel(src)

//////////////////////Large Bulb Flask//////////////
//Two Steps                                       //
//Sells for 1000 cr, takes 15 glass shets         //
//Usefull for selling and chemical things         //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/flask_large
	name = "Glass fodder sheet"
	desc = "A set of glass sheets set aside for glass working, this one is ideal for a large flask. Needs to be heated with some tools."
	next_step = /obj/item/glasswork/glass_base/flask_large_part1

/obj/item/glasswork/glass_base/flask_large/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_WELDER)
		if(do_after(user,30, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/flask_large_part1
	name = "Metled glass"
	desc = "A blob of metled glass, this one is ideal for a large flask. Needs to be blown with some tools."
	icon_state = "glass_base_molding"
	next_step = /obj/item/glasswork/glass_base/flask_large_part2

/obj/item/glasswork/glass_base/flask_large_part1/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_BLOW)
		if(do_after(user,5, target = src))
			new next_step(user.loc, 1)
			qdel(src)
			qdel(I)

/obj/item/glasswork/glass_base/flask_large_part2
	name = "Metled glass"
	desc = "A blob of metled glass on the end of a blowing rod. Needs to be cut off with some tools."
	icon_state = "blowing_rods_inuse"
	next_step = /obj/item/reagent_containers/glass/beaker/flask/large

/obj/item/glasswork/glass_base/flask_large_part2/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_GLASS_CUT)
		if(do_after(user,20, target = src))
			new next_step(user.loc, 1)
			new rod(user.loc, 1)
			qdel(src)

//////////////////////Tea Plates////////////////////
//Three Steps                                     //
//Sells for 1000 cr, takes 5 glass shets          //
//Usefull for selling and chemical things         //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/tea_plate
	name = "Glass fodder sheet"
	desc = "A set of glass sheets set aside for glass working, this one is ideal for a tea plate, how fancy! Needs to be heated with some tools."
	next_step = /obj/item/glasswork/glass_base/tea_plate1

/obj/item/glasswork/glass_base/tea_plate/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_WELDER)
		if(do_after(user,30, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/tea_plate1
	name = "Metled glass"
	desc = "A blob of metled glass, this one is ideal for a tea plate. Needs to be blown with some tools."
	icon_state = "glass_base_molding"
	next_step = /obj/item/glasswork/glass_base/tea_plate2

/obj/item/glasswork/glass_base/tea_plate1/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_BLOW)
		if(do_after(user,5, target = src))
			new next_step(user.loc, 1)
			qdel(src)
			qdel(I)

/obj/item/glasswork/glass_base/tea_plate2
	name = "Metled glass"
	desc = "A blob of metled glass on the end of a blowing rod. Needs to be cut off with some tools."
	icon_state = "blowing_rods_inuse"
	next_step = /obj/item/glasswork/glass_base/tea_plate3

/obj/item/glasswork/glass_base/tea_plate2/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_GLASS_CUT)
		if(do_after(user,20, target = src))
			new next_step(user.loc, 1)
			new rod(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/tea_plate3
	name = "Disk of glass"
	desc = "A disk of glass that can be cant be used for much. Needs to be polished with some cloth."
	icon_state = "glass_base_half"
	next_step = /obj/item/tea_plate

/obj/item/glasswork/glass_base/tea_plate3/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/stack/sheet/cloth))
		if(do_after(user,10, target = src))
			new next_step(user.loc, 1)
			qdel(src)

//////////////////////Tea Cup///////////////////////
//Four Steps                                      //
//Sells for 1600 cr, takes 6 glass shets          //
//Usefull for selling and chemical things         //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/tea_cup
	name = "Glass fodder sheet"
	desc = "A set of glass sheets set aside for glass working, this one is ideal for a tea cup, how fancy! Needs to be heated with some tools."
	next_step = /obj/item/glasswork/glass_base/tea_cup1

/obj/item/glasswork/glass_base/tea_cup/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_WELDER)
		if(do_after(user,30, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/tea_cup1
	name = "Metled glass"
	desc = "A blob of metled glass, this one is ideal for a tea cup. Needs to be blown with some tools."
	icon_state = "glass_base_molding"
	next_step = /obj/item/glasswork/glass_base/tea_cup2

/obj/item/glasswork/glass_base/tea_cup1/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_BLOW)
		if(do_after(user,5, target = src))
			new next_step(user.loc, 1)
			qdel(src)
			qdel(I)

/obj/item/glasswork/glass_base/tea_cupe2
	name = "Metled glass"
	desc = "A blob of metled glass on the end of a blowing rod. Needs to be cut off with some tools."
	icon_state = "blowing_rods_inuse"
	next_step = /obj/item/glasswork/glass_base/tea_cup3

/obj/item/glasswork/glass_base/tea_cup2/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_GLASS_CUT)
		if(do_after(user,20, target = src))
			new next_step(user.loc, 1)
			new rod(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/tea_cup3
	name = "Disk of glass"
	desc = "A bowl of glass that can be cant be used for much. Needs to be polished with some cloth."
	icon_state = "glass_base_half"
	next_step = /obj/item/glasswork/glass_base/tea_cup4

/obj/item/glasswork/glass_base/cup3/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/stack/sheet/cloth))
		if(do_after(user,10, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/tea_cup4
	name = "Disk of glass"
	desc = "A bowl of polished glass that can be cant be used for much. Needs some more glass to make a handle."
	icon_state = "glass_base_half"
	next_step = /obj/item/tea_cup

/obj/item/glasswork/glass_base/cup4/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/stack/sheet/glass))
		if(do_after(user,10, target = src))
			new next_step(user.loc, 1)
			qdel(src)
