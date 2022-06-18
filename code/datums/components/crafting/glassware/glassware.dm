//This file is for glass working types of things!

/obj/item/glasswork
	name = "this is a bug!"
	desc = "Uh oh, the coders did a fucky wucky! Contact your local code monkey and tell them about this!"
	icon = 'icons/obj/glassworks.dmi'
	w_class = WEIGHT_CLASS_SMALL
	force = 1
	throw_speed = 1
	throw_range = 3
	tool_behaviour = null

/obj/item/glasswork/glasskit
	name = "glasswork tools"
	desc = "A set of most the tools you will need to shape, mold, and refine glass into more advanced shapes."
	icon_state = "glass_tools"
	tool_behaviour = TOOL_GLASS_CUT //Cutting takes 20 ticks

/obj/item/glasswork/blowing_rod
	name = "glassblowing rod"
	desc = "A hollow metal rod made for blowing glass."
	icon_state = "blowing_rods_unused"
	tool_behaviour = TOOL_BLOW //Rods take 5 ticks

/obj/item/glasswork/glass_base //Welding takes 30 ticks
	name = "glass fodder sheet"
	desc = "A sheet of glass set aside for glass working."
	icon_state = "glass_base"
	var/next_step = null
	var/rod = /obj/item/glasswork/blowing_rod

/obj/item/tea_plate
	name = "tea saucer"
	desc = "A polished plate for a tea cup. How fancy!"
	icon = 'icons/obj/glass_ware.dmi'
	icon_state = "tea_plate"

/obj/item/tea_cup
	name = "tea cup"
	desc = "A glass cup made for sipping tea!"
	icon = 'icons/obj/glass_ware.dmi'
	icon_state = "tea_cup"

//////////////////////Chem Disk/////////////////////
//Two Steps                                       //
//Sells for 300 cr, takes 10 glass shets          //
//Useful for chem spliting                        //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/dish
	name = "glass fodder sheet (dish)"
	desc = "A set of glass sheets set aside for glass working. This one is ideal for a small glass dish. It needs to be cut with some glassworking tools."
	next_step = /obj/item/glasswork/glass_base/dish_part1

/obj/item/glasswork/glass_base/dish/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_GLASS_CUT)
		if(do_after(user,20, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/dish_part1
	name = "half glass fodder sheet (dish)"
	desc = "A sheet of glass cut in half. It looks like it still needs some more cutting down."
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
//Useful for selling and later crafting           //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/glass_lens
	name = "glass fodder sheet (lens)"
	desc = "A set of glass sheets set aside for glass working. This one is ideal for a glass lens. It needs to be cut with some glassworking tools."
	next_step = /obj/item/glasswork/glass_base/glass_lens_part1

/obj/item/glasswork/glass_base/glass_lens/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_GLASS_CUT)
		if(do_after(user,20, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/glass_lens_part1
	name = "half glass fodder sheet (lens)"
	desc = "Cut glass ready to be heated with something very hot."
	icon_state = "glass_base_half"
	next_step = /obj/item/glasswork/glass_base/glass_lens_part2

/obj/item/glasswork/glass_base/glass_lens_part1/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_WELDER)
		if(do_after(user,30, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/glass_lens_part2
	name = "heated half glass fodder sheet (lens)"
	desc = "Cut glass that has been heated once already and is ready to be heated again."
	icon_state = "glass_base_heat"
	next_step = /obj/item/glasswork/glass_base/glass_lens_part3

/obj/item/glasswork/glass_base/glass_lens_part2/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_WELDER)
		if(do_after(user,30, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/glass_lens_part3
	name = "heated glass blob (lens)"
	desc = "Cut glass that has been heated into a blob. It needs to be attached to a glassblowing rod."
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
	name = "glassblowing rod (lens)"
	desc = "A hollow metal rod made for blowing glass. There is a blob of shapen glass at the end of it that needs to be cut off with some glassworking tools."
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
	name = "unpolished glass (lens)"
	desc = "An unpolished glass lens. It needs to be polished with some dry cloth."
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
	name = "unrefined glass (lens)"
	desc = "A polished glass lens. It needs to be refined with some sandstone."
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
//Useful for selling and chemical things          //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/spouty
	name = "Glass fodder sheet (spout)"
	desc = "A set of glass sheets set aside for glass working. This one is ideal for a spouty flask. It needs to be cut with some glassworking tools."
	next_step = /obj/item/glasswork/glass_base/spouty_part2

/obj/item/glasswork/glass_base/spouty/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_GLASS_CUT)
		if(do_after(user,20, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/spouty_part2
	name = "glass fodder sheet (spout)"
	desc = "Cut glass ready to be heated with something very hot."
	icon_state = "glass_base_half"
	next_step = /obj/item/glasswork/glass_base/spouty_part3

/obj/item/glasswork/glass_base/spouty_part2/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_WELDER)
		if(do_after(user,30, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/spouty_part3
	name = "heated glass blob (spout)"
	desc = "Cut glass that has been heated into a blob. It needs to be attached to a glassblowing rod."
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
	name = "glassblowing rod (spout)"
	desc = "A hollow metal rod made for blowing glass. There is a blob of shapen glass at the end of it that needs to be cut off with some glassworking tools."
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
//Useful for selling and chemical things          //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/flask_small
	name = "glass fodder sheet (small flask)"
	desc = "A set of glass sheets set aside for glass working. This one is ideal for a small flask. It needs to heated with something very hot."
	next_step = /obj/item/glasswork/glass_base/flask_small_part1

/obj/item/glasswork/glass_base/flask_small/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_WELDER)
		if(do_after(user,30, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/flask_small_part1
	name = "heated glass blob (small flask)"
	desc = "Glass that has been heated into a blob. It needs to be attached to a glassblowing rod."
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
	name = "glassblowing rod (small flask)"
	desc = "A hollow metal rod made for blowing glass. There is a blob of shapen glass at the end of it that needs to be cut off with some glassworking tools."
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
//Useful for selling and chemical things          //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/flask_large
	name = "glass fodder sheet (large flask)"
	desc = "A set of glass sheets set aside for glass working. This one is ideal for a large flask. It needs to heated with something very hot."
	next_step = /obj/item/glasswork/glass_base/flask_large_part1

/obj/item/glasswork/glass_base/flask_large/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_WELDER)
		if(do_after(user,30, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/flask_large_part1
	name = "heated glass blob (large flask)"
	desc = "Glass that has been heated into a blob. It needs to be attached to a glassblowing rod."
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
	name = "glassblowing rod (small flask)"
	desc = "A hollow metal rod made for blowing glass. There is a blob of shapen glass at the end of it that needs to be cut off with some glassworking tools."
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
//Useful for selling and chemical things          //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/tea_plate
	name = "glass fodder sheet (tea saucer)"
	desc = "A set of glass sheets set aside for glass working. This one is ideal for a tea saucer. It needs to heated with something very hot."
	next_step = /obj/item/glasswork/glass_base/tea_plate1

/obj/item/glasswork/glass_base/tea_plate/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_WELDER)
		if(do_after(user,30, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/tea_plate1
	name = "heated glass blob (tea saucer)"
	desc = "Glass that has been heated into a blob. It needs to be attached to a glassblowing rod."
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
	name = "glassblowing rod (tea saucer)"
	desc = "A hollow metal rod made for blowing glass. There is a blob of shapen glass at the end of it that needs to be cut off with some glassworking tools."
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
	name = "unpolished glass saucer (tea saucer)"
	desc = "An unpolished glass saucer. It needs to be polished with some dry cloth."
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
//Useful for selling and chemical things          //
////////////////////////////////////////////////////

/obj/item/glasswork/glass_base/tea_cup
	name = "glass fodder sheet (tea cup)"
	desc = "A set of glass sheets set aside for glass working. This one is ideal for a tea cup. It needs to heated with something very hot."
	next_step = /obj/item/glasswork/glass_base/tea_cup1

/obj/item/glasswork/glass_base/tea_cup/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_WELDER)
		if(do_after(user,30, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/tea_cup1
	name = "heated glass blob (tea cup)"
	desc = "Glass that has been heated into a blob. It needs to be attached to a glassblowing rod."
	icon_state = "glass_base_molding"
	next_step = /obj/item/glasswork/glass_base/tea_cup2

/obj/item/glasswork/glass_base/tea_cup1/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_BLOW)
		if(do_after(user,5, target = src))
			new next_step(user.loc, 1)
			qdel(src)
			qdel(I)

/obj/item/glasswork/glass_base/tea_cup2
	name = "glassblowing rod (tea cup)"
	desc = "A hollow metal rod made for blowing glass. There is a blob of shapen glass at the end of it that needs to be cut off with some glassworking tools."
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
	name = "unpolished glass cup (tea cup)"
	desc = "An unpolished glass cup. It needs to be polished with some dry cloth."
	icon_state = "glass_base_half"
	next_step = /obj/item/glasswork/glass_base/tea_cup4

/obj/item/glasswork/glass_base/tea_cup3/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/stack/sheet/cloth))
		if(do_after(user,10, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/tea_cup4
	name = "polished glass cup (tea cup)"
	desc = "A polished glass cup. It needs some extra glass to form a handle."
	icon_state = "glass_base_half"
	next_step = /obj/item/tea_cup

/obj/item/glasswork/glass_base/tea_cup4/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/stack/sheet/glass))
		if(do_after(user,10, target = src))
			new next_step(user.loc, 1)
			qdel(src)
