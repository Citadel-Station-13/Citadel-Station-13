/mob/living/silicon/
	typing_indicator_state = /obj/effect/overlay/typing_indicator/machine

/obj/effect/overlay/typing_indicator/machine
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'icons/mob/talk.dmi'
	icon_state = "machine_typing"
	appearance_flags = RESET_COLOR | TILE_BOUND | PIXEL_SCALE
	layer = ABOVE_FLY_LAYER

/obj/effect/overlay/typing_indicator/machine/dogborg
	icon = 'modular_sand/icons/mob/talk.dmi'

/mob/living/simple_animal/slime
	typing_indicator_state = /obj/effect/overlay/typing_indicator/slime

/obj/effect/overlay/typing_indicator/slime
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'icons/mob/talk.dmi'
	icon_state = "slime_typing"
	appearance_flags = RESET_COLOR | TILE_BOUND | PIXEL_SCALE
	layer = ABOVE_FLY_LAYER
