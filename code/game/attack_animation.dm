/atom/movable/proc/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!no_effect && (visual_effect_icon || used_item))
		do_item_attack_animation(A, visual_effect_icon, used_item, A == src)

	if(A == src)
		return //don't do an animation if attacking self

	var/angle = get_visual_angle(src, A)

	var/pixel_x_diff = CEILING(8 * sin(angle), 1)
	var/pixel_y_diff = CEILING(8 * cos(angle), 1)

	var/matrix/OM = matrix(transform)
	var/matrix/M = matrix(transform)
	M.Turn(pixel_x_diff ? pixel_x_diff*2 : pick(-16, 16))

	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, transform = M, time = 2)
	animate(src, pixel_x = pixel_x - pixel_x_diff, pixel_y = pixel_y - pixel_y_diff, transform = OM, time = 2)

/atom/movable/proc/do_item_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, self = FALSE)
	var/image/I
	var/angle
	if(!self)
		get_visual_angle(src, A)
	if(visual_effect_icon)
		I = image('icons/effects/effects.dmi', A, visual_effect_icon, A.layer + 0.1)
	else if(used_item)
		I = image(icon = used_item, loc = A, layer = A.layer + 0.1)
		I.plane = GAME_PLANE

		// Scale the icon.
		I.transform *= 0.75
		// The icon should not rotate.
		I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

		if(!self)
			I.pixel_x = CEILING(16 * sin(angle), 1)
			I.pixel_y = CEILING(16 * cos(angle), 1)
		else
			I.pixel_z = 16

	if(!I)
		return

	flick_overlay(I, GLOB.clients, 5) // 5 ticks/half a second

	// And animate the attack!
	animate(I, alpha = 175, pixel_x = 0, pixel_y = 0, pixel_z = 0, time = 3)
