//This file is for crafting using a lens!

/obj/item/glasswork/glass_base/lens
	name = "optical lens"
	desc = "A glass lens. Useless by itself, but may prove useful in making something with a focus."
	icon = 'icons/obj/glass_ware.dmi'
	icon_state = "glass_optics"

//Laser pointers - 2600
/obj/item/glasswork/glass_base/laserpointer_shell
	name = "laser pointer assembly"
	desc = "An empty hull of a laser pointer. It's missing a capacitor."
	icon_state = "laser_case"
	icon = 'icons/obj/glass_ware.dmi'
	next_step = /obj/item/glasswork/glass_base/laserpointer_shell_1

/obj/item/glasswork/glass_base/laserpointer_shell/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/stock_parts/capacitor))
		new next_step(user.loc, 1)
		qdel(src)

/obj/item/glasswork/glass_base/laserpointer_shell_1
	name = "powered laser pointer assembly"
	desc = "A laser pointer hull with a capacitor inside of it. It's missing a lens."
	icon_state = "laser_wire"
	icon_state = "laser_case"
	next_step = /obj/item/glasswork/glass_base/laserpointer_shell_2

/obj/item/glasswork/glass_base/laserpointer_shell_1/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/glasswork/glass_base/lens))
		new next_step(user.loc, 1)
		qdel(src)

/obj/item/glasswork/glass_base/laserpointer_shell_2
	name = "near-complete laser pointer assembly"
	desc = "A laser pointer hull with a capacitor and a lens inside of it. It needs to be screwed together."
	icon_state = "laser_wire"
	icon_state = "laser_case"
	next_step = /obj/item/laser_pointer/blue/handmade

/obj/item/glasswork/glass_base/laserpointer_shell_2/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if(do_after(user,260, target = src))
			new next_step(user.loc, 1)
			qdel(src)

//NERD SHIT - 5000

/obj/item/glasswork/glass_base/glasses_frame
	name = "glasses frame"
	desc = "A pair of glasses without the lenses. You could probably add them yourself, though."
	icon = 'icons/obj/glass_ware.dmi'
	icon_state = "frames"
	next_step = /obj/item/glasswork/glass_base/glasses_frame_1

/obj/item/glasswork/glass_base/glasses_frame/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/glasswork/glass_base/lens))
		if(do_after(user,60, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/glasses_frame_1
	name = "glasses frame"
	desc = "A pair of shoddily-assembled glasses with only one lens. You could probably add the second one yourself, though."
	icon = 'icons/obj/glass_ware.dmi'
	icon_state = "frames_1"
	next_step = /obj/item/glasswork/glass_base/glasses_frame_2

/obj/item/glasswork/glass_base/glasses_frame_1/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/glasswork/glass_base/lens))
		if(do_after(user,60, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glass_base/glasses_frame_2
	name = "glasses frame"
	desc = "A pair of hastily-assembled unfitted glasses with both lenses intact. Use a screwdriver to fit them."
	icon = 'icons/obj/glass_ware.dmi'
	icon_state = "frames_2"
	next_step = /obj/item/glasswork/glasses

/obj/item/glasswork/glass_base/glasses_frame_2/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if(do_after(user,180, target = src))
			new next_step(user.loc, 1)
			qdel(src)

/obj/item/glasswork/glasses
	name = "handmade glasses"
	desc = "A pair of poorly-assembled glasses clearly produced by someone with no qualifications in making glasses. They're smudged, ugly, and don't even fit you. They might be worth some money, though."
	icon = 'icons/obj/glass_ware.dmi'
	icon_state = "frames_2"
