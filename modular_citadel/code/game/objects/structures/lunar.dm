/obj/structure/moon_rock
	desc = "A moon rock."
	name = "moon rock"
	icon = 'icons/misc/lunar.dmi'
	icon_state = "moonrock"
	density = TRUE
	anchored = TRUE
	max_integrity = 300

/obj/structure/LEM
	name = "Lunar Module"
	desc = ""
	icon = 'icons/misc/lunar64.dmi'
	icon_state = "LEM"
	density = TRUE
	anchored = TRUE
	max_integrity = 2000

/obj/structure/moon_flag
	name = "Moon landing flag"
	desc = ""
	icon = 'icons/misc/lunar.dmi'
	icon_state = "flag"
	density = TRUE
	anchored = TRUE
	max_integrity = 50

/obj/structure/moon_flag/attackby(obj/item/W, mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	add_fingerprint(user)
	if((istype(W, /obj/item/screwdriver)) && (isturf(loc) || anchored))
		W.play_tool_sound(src, 100)
		setAnchored(!anchored)
		user.visible_message("<span class='notice'>[user] [anchored ? "fastens" : "unfastens"] [src].</span>", \
							 "<span class='notice'>You [anchored ? "fasten [src] to" : "unfasten [src] from"] the floor.</span>")