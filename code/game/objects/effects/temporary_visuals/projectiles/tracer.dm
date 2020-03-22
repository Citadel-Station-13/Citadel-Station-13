/proc/generate_tracer_between_points(datum/point/starting, datum/point/ending, beam_type, color, qdel_in = 5, light_range = 2, light_color_override, light_intensity = 1, list/turfs)		//Do not pass z-crossing points as that will not be properly (and likely will never be properly until it's absolutely needed) supported!
	if(!istype(starting) || !istype(ending) || !ispath(beam_type))
		return
	var/datum/point/midpoint = point_midpoint_points(starting, ending)
	var/obj/effect/projectile/tracer/PB = new beam_type
	if(isnull(light_color_override))
		light_color_override = color
	PB.apply_vars(angle_between_points(starting, ending), midpoint.return_px(), midpoint.return_py(), color, pixel_length_between_points(starting, ending) / world.icon_size, midpoint.return_turf(), 0)
	. = PB
	if(light_range > 0 && light_intensity > 0)
		var/list/turf/line = getline(starting.return_turf(), ending.return_turf())
		for(var/i in line)
			if(turfs[i])
				continue
			turfs[i] = TRUE
			QDEL_IN(new /obj/effect/projectile_lighting(i, light_color_override, light_range, light_intensity), qdel_in > 0? qdel_in : 5)
		line = null
	if(qdel_in)
		QDEL_IN(PB, qdel_in)
d
/obj/effect/projectile/tracer
	name = "beam"
	icon = 'icons/obj/projectiles_tracer.dmi'

/obj/effect/projectile/tracer/laser
	name = "laser"
	icon_state = "beam"

/obj/effect/projectile/tracer/laser/blue
	icon_state = "beam_blue"

/obj/effect/projectile/tracer/disabler
	name = "disabler"
	icon_state = "beam_omni"

/obj/effect/projectile/tracer/xray
	name = "\improper X-ray laser"
	icon_state = "xray"

/obj/effect/projectile/tracer/pulse
	name = "pulse laser"
	icon_state = "u_laser"

/obj/effect/projectile/tracer/plasma_cutter
	name = "plasma blast"
	icon_state = "plasmacutter"

/obj/effect/projectile/tracer/stun
	name = "stun beam"
	icon_state = "stun"

/obj/effect/projectile/tracer/heavy_laser
	name = "heavy laser"
	icon_state = "beam_heavy"

//BEAM RIFLE
/obj/effect/projectile/tracer/tracer/beam_rifle
	icon_state = "tracer_beam"

/obj/effect/projectile/tracer/tracer/aiming
	icon_state = "pixelbeam_greyscale"
	layer = ABOVE_LIGHTING_LAYER
	plane = ABOVE_LIGHTING_PLANE

/obj/effect/projectile/tracer/wormhole
	icon_state = "wormhole_g"

/obj/effect/projectile/tracer/laser/wavemotion
	name = "particle trail"
	icon_state = "tracer_wavemotion"

/obj/effect/projectile/tracer/laser/emitter
	name = "emitter beam"
	icon_state = "emitter"
