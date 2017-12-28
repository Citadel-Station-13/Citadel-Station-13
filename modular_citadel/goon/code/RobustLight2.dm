var
	RL_Generation = 0

#define RL_Atten_Quadratic 2.2 // basically just brightness scaling atm
#define RL_Atten_Constant -0.1 // constant subtracted at every point to make sure it goes <0 after some distance
#define RL_MaxRadius 7 // maximum allowed light.radius value. if any light ends up needing more than this it'll cap and look screwy

datum/light
	var
		x
		y
		z

		r = 1
		g = 1
		b = 1
		brightness = 1
		height = 1
		enabled = 0

		radius = 1
		premul_r = 1
		premul_g = 1
		premul_b = 1

		atom/attached_to = null
		attach_x = 0.5
		attach_y = 0.5

	New(x=0, y=0, z=0)
		src.x = x
		src.y = y
		src.z = z
		var/turf/T = locate(x, y, z)
		if (T)
			if (!T.RL_Lights)
				T.RL_Lights = list()
			T.RL_Lights |= src

	proc
		set_brightness(brightness)
			if (src.brightness == brightness)
				return

			if (src.enabled)
				var/strip_gen = ++RL_Generation
				var/list/affected = src.strip(strip_gen)

				src.brightness = brightness
				src.precalc()

				for (var/turf/T in src.apply())
					T.RL_UpdateLight()
				for (var/turf/T in affected)
					if (T.RL_UpdateGeneration <= strip_gen)
						T.RL_UpdateLight()
			else
				src.brightness = brightness
				src.precalc()

		set_color(r, g, b)
			if (src.r == r && src.g == g && src.b == b)
				return

			if (src.enabled)
				var/strip_gen = ++RL_Generation
				var/list/affected = src.strip(strip_gen)

				src.r = r
				src.g = g
				src.b = b
				src.precalc()

				for (var/turf/T in src.apply())
					T.RL_UpdateLight()
				for (var/turf/T in affected)
					if (T.RL_UpdateGeneration <= strip_gen)
						T.RL_UpdateLight()
			else
				src.r = r
				src.g = g
				src.b = b
				src.precalc()

		set_height(height)
			if (src.height == height)
				return

			if (src.enabled)
				var/strip_gen = ++RL_Generation
				var/list/affected = src.strip(strip_gen)

				src.height = height
				src.precalc()

				for (var/turf/T in src.apply())
					T.RL_UpdateLight()
				for (var/turf/T in affected)
					if (T.RL_UpdateGeneration <= strip_gen)
						T.RL_UpdateLight()
			else
				src.height = height
				src.precalc()

		enable()
			if (enabled)
				return
			enabled = 1
			for (var/turf/T in src.apply())
				T.RL_UpdateLight()

		disable()
			if (!enabled)
				return
			enabled = 0
			for (var/turf/T in src.strip(++RL_Generation))
				T.RL_UpdateLight()

		detach()
			if (src.attached_to)
				src.attached_to.RL_Attached -= src
				src.attached_to = null

		attach(atom/A, offset_x=0.5, offset_y=0.5)
			if (src.attached_to)
				var/atom/old = src.attached_to
				old.RL_Attached -= src

			src.move(A.x + offset_x, A.y + offset_x, A.z)
			src.attached_to = A
			src.attach_x = offset_x
			src.attach_y = offset_y
			if (!A.RL_Attached)
				A.RL_Attached = list(src)
			else
				A.RL_Attached += src

		// internals
		precalc()
			src.premul_r = src.r * src.brightness
			src.premul_g = src.g * src.brightness
			src.premul_b = src.b * src.brightness
			src.radius = min(ceil(sqrt(max((brightness * RL_Atten_Quadratic) / -RL_Atten_Constant - src.height**2, 0)) + 1), RL_MaxRadius)

		apply()
			if (!RL_Started)
				return list()

			return apply_internal(++RL_Generation, src.premul_r, src.premul_g, src.premul_b)

		strip(generation)
			if (!RL_Started)
				return list()

			return apply_internal(generation, -src.premul_r, -src.premul_g, -src.premul_b)

		move(x, y, z)
			var/turf/old_turf = locate(src.x, src.y, src.z)
			if (old_turf)
				if (old_turf.RL_Lights.len)
					old_turf.RL_Lights -= src
					if (!old_turf.RL_Lights.len)
						old_turf.RL_Lights = null
				else
					old_turf.RL_Lights = null

			var/strip_gen = ++RL_Generation
			var/list/affected
			if (src.enabled)
				affected = src.strip(strip_gen)

			src.x = x
			src.y = y
			src.z = z

			var/turf/new_turf = locate(x, y, z)
			if (new_turf)
				if (!new_turf.RL_Lights)
					new_turf.RL_Lights = list()
				new_turf.RL_Lights |= src

			if (src.enabled)
				for (var/turf/T in src.apply())
					T.RL_UpdateLight()
				for (var/turf/T in affected)
					if (T.RL_UpdateGeneration <= strip_gen)
						T.RL_UpdateLight()

		move_defer(x, y, z)
			. = src.strip(++RL_Generation)
			src.x = x
			src.y = y
			src.z = z

			. |= src.apply()

		apply_to(turf/T)
			CRASH("Default apply_to called, did you mean to create a /datum/light/point and not a /datum/light?")
			return

		apply_internal(generation, r, g, b) // per light type
			CRASH("Default apply_internal called, did you mean to create a /datum/light/point and not a /datum/light?")
			return

	point
		apply_to(turf/T)
			T.RL_ApplyLight(src.x, src.y, src.brightness, src.height**2, r, g, b)

		#define ADDUPDATE(var) if (var.RL_UpdateGeneration < generation) { var.RL_UpdateGeneration = generation; . += var; }
		apply_internal(generation, r, g, b)
			. = list()
			var/height2 = src.height**2
			var/turf/middle = locate(src.x, src.y, src.z)
			outer:
				for (var/turf/T in view(src.radius, middle))
					if (T.opacity)
						continue
					for (var/atom/A in T)
						if (A.opacity)
							continue outer

					T.RL_ApplyLight(src.x, src.y, src.brightness, height2, r, g, b)
					T.RL_ApplyGeneration = generation
					T.RL_UpdateGeneration = generation
					. += T

			for (var/turf/T in .)
				var/turf/E = get_step(T, EAST)
				var/turf/N = get_step(T, NORTH)
				var/turf/NE = get_step(T, NORTHEAST)
				var/turf/W = get_step(T, WEST)
				var/turf/S = get_step(T, SOUTH)
				var/turf/SW = get_step(T, SOUTHWEST)

				if (E && E.RL_ApplyGeneration < generation)
					E.RL_ApplyGeneration = generation
					E.RL_ApplyLight(src.x, src.y, src.brightness, height2, r, g, b)
					ADDUPDATE(E)

					var/turf/SE = get_step(T, SOUTHEAST)
					ADDUPDATE(SE)

				if (N && N.RL_ApplyGeneration < generation)
					N.RL_ApplyGeneration = generation
					N.RL_ApplyLight(src.x, src.y, src.brightness, height2, r, g, b)
					ADDUPDATE(N)

					var/turf/NW = get_step(T, NORTHWEST)
					ADDUPDATE(NW)

				if (NE && NE.RL_ApplyGeneration < generation)
					NE.RL_ApplyLight(src.x, src.y, src.brightness, height2, r, g, b)
					NE.RL_ApplyGeneration = generation
					ADDUPDATE(NE)

				ADDUPDATE(W)
				ADDUPDATE(S)
				ADDUPDATE(SW)

var
	RL_Started = 0

proc
	RL_Start()
		RL_Started = 1
		for (var/datum/light/light)
			if (light.enabled)
				light.apply()
		for (var/turf/T in world)
			T.RL_UpdateLight()

	RL_Suspend()
		// TODO

	RL_Resume()
		// TODO

turf
	var
		RL_ApplyGeneration = 0
		RL_UpdateGeneration = 0
		obj/overlay/tile_effect/RL_MulOverlay = null
		obj/overlay/tile_effect/RL_AddOverlay = null
		RL_LumR = 0
		RL_LumG = 0
		RL_LumB = 0
		RL_AddLumR = 0
		RL_AddLumG = 0
		RL_AddLumB = 0
		RL_NeedsAdditive = 0
		RL_OverlayState = ""
		list/datum/light/RL_Lights = null

		RL_Ignore = 0

	luminosity = 1 // TODO

	New()
		..()
		var/area/A = src.loc
		if (!RL_Started)
			RL_LumR += A.RL_AmbientRed
			RL_LumG += A.RL_AmbientGreen
			RL_LumB += A.RL_AmbientBlue

	disposing()
		..()
		RL_Cleanup()

		var/old_lights = src.RL_Lights
		var/old_opacity = src.opacity
		spawn(0) // ugghhh fuuck
			var/area/A = src.loc
			RL_LumR = A.RL_AmbientRed
			RL_LumG = A.RL_AmbientGreen
			RL_LumB = A.RL_AmbientBlue
			if (old_lights)
				if (!RL_Lights)
					RL_Lights = old_lights
				else
					RL_Lights |= old_lights
			var/new_opacity = src.opacity
			src.opacity = old_opacity
			RL_SetOpacity(new_opacity)

			for (var/turf/T in view(RL_MaxRadius, src))
				for (var/datum/light/light in T.RL_Lights)
					if (light.enabled)
						light.apply_to(src)
			RL_UpdateLight()

	proc
		RL_ApplyLight(lx, ly, brightness, height2, r, g, b)
			var/area/A = loc
			if (RL_Ignore || !A.RL_Lighting)
				return

			var/atten = (brightness*RL_Atten_Quadratic) / ((src.x - lx)**2 + (src.y - ly)**2 + height2) + RL_Atten_Constant
			if (atten < 0)
				return
			RL_LumR += r*atten
			RL_LumG += g*atten
			RL_LumB += b*atten
			RL_AddLumR = min(max((RL_LumR - 1) * 0.5, 0), 0.3)
			RL_AddLumG = min(max((RL_LumG - 1) * 0.5, 0), 0.3)
			RL_AddLumB = min(max((RL_LumB - 1) * 0.5, 0), 0.3)
			RL_NeedsAdditive = (RL_AddLumR > 0) || (RL_AddLumG > 0) || (RL_AddLumB > 0)

		RL_UpdateLight()
			if (!RL_Started)
				return

			var/area/A = loc
			if (RL_Ignore || !A.RL_Lighting)
				if (src.RL_MulOverlay)
					pool(src.RL_MulOverlay)
					src.RL_MulOverlay.set_loc(null)
					src.RL_MulOverlay = null
				if (src.RL_AddOverlay)
					pool(src.RL_AddOverlay)
					src.RL_AddOverlay.set_loc(null)
					src.RL_AddOverlay = null
				return

			var/turf/E = get_step(src, EAST) || src
			var/turf/N = get_step(src, NORTH) || src
			var/turf/NE = get_step(src, NORTHEAST) || src

			if (!src.RL_MulOverlay)
				var/obj/overlay/tile_effect/overlay = unpool(/obj/overlay/tile_effect)
				overlay.set_loc(src)
				overlay.blend_mode = BLEND_MULTIPLY
				overlay.icon = 'icons/effects/light_overlay.dmi'
				overlay.icon_state = src.RL_OverlayState
				src.RL_MulOverlay = overlay
			src.RL_MulOverlay.color = list(
				src.RL_LumR, src.RL_LumG, src.RL_LumB, 0,
				E.RL_LumR, E.RL_LumG, E.RL_LumB, 0,
				N.RL_LumR, N.RL_LumG, N.RL_LumB, 0,
				NE.RL_LumR, NE.RL_LumG, NE.RL_LumB, 0,
				0, 0, 0, 1)

			if (src.RL_NeedsAdditive || E.RL_NeedsAdditive || N.RL_NeedsAdditive || NE.RL_NeedsAdditive)
				if (!src.RL_AddOverlay)
					var/obj/overlay/tile_effect/overlay = unpool(/obj/overlay/tile_effect)
					overlay.set_loc(src)
					overlay.blend_mode = BLEND_ADD
					overlay.icon = 'icons/effects/light_overlay.dmi'
					overlay.icon_state = src.RL_OverlayState
					src.RL_AddOverlay = overlay
				src.RL_AddOverlay.color = list(
					src.RL_AddLumR, src.RL_AddLumG, src.RL_AddLumB, 0,
					E.RL_AddLumR, E.RL_AddLumG, E.RL_AddLumB, 0,
					N.RL_AddLumR, N.RL_AddLumG, N.RL_AddLumB, 0,
					NE.RL_AddLumR, NE.RL_AddLumG, NE.RL_AddLumB, 0,
					0, 0, 0, 1)
			else if (src.RL_AddOverlay)
				src.RL_AddOverlay.set_loc(null)
				pool(src.RL_AddOverlay)
				src.RL_AddOverlay = null

		RL_SetSprite(state)
			if (src.RL_MulOverlay)
				src.RL_MulOverlay.icon_state = state
			if (src.RL_AddOverlay)
				src.RL_AddOverlay.icon_state = state
			src.RL_OverlayState = state

		// Approximate RGB -> Luma conversion formula.
		RL_GetBrightness()
			var/BN = max(0, ((src.RL_LumR * 0.33) + (src.RL_LumG * 0.5) + (src.RL_LumB * 0.16)))
			return BN

		RL_Cleanup()
			if (src.RL_MulOverlay)
				src.RL_MulOverlay.set_loc(null)
				pool(src.RL_MulOverlay)
				src.RL_MulOverlay = null
			if (src.RL_AddOverlay)
				src.RL_AddOverlay.set_loc(null)
				pool(src.RL_AddOverlay)
				src.RL_AddOverlay = null

		RL_Reset()
			// TODO

area
	var
		RL_Lighting = 1
		RL_AmbientRed = 0.1
		RL_AmbientGreen = 0.1
		RL_AmbientBlue = 0.1

atom
	var
		RL_Attached = null

	movable
		Move(atom/target)
			var/old_loc = src.loc
			. = ..()
			if (src.loc != old_loc && src.RL_Attached)
				for (var/datum/light/light in src.RL_Attached)
					light.move(src.x + light.attach_x, src.y + light.attach_y, src.z)

		set_loc(atom/target)
			if (opacity)
				var/list/datum/light/lights = list()
				for (var/turf/T in view(RL_MaxRadius, src))
					if (T.RL_Lights)
						lights |= T.RL_Lights

				var/list/affected = list()
				for (var/datum/light/light in lights)
					if (light.enabled)
						affected |= light.strip(++RL_Generation)

				. = ..()

				for (var/datum/light/light in lights)
					if (light.enabled)
						affected |= light.apply()
				for (var/turf/T in affected)
					T.RL_UpdateLight()
			else
				. = ..()

			if (src.RL_Attached) // TODO: defer updates and update all affected tiles at once?
				for (var/datum/light/light in src.RL_Attached)
					light.move(src.x+0.5, src.y+0.5, src.z)

	disposing()
		..()
		if (src.RL_Attached)
			for (var/datum/light/attached in src.RL_Attached)
				attached.disable()
		if (opacity)
			RL_SetOpacity(0)

	proc
		RL_SetOpacity(new_opacity)
			if (src.opacity == new_opacity)
				return

			var/list/datum/light/lights = list()
			for (var/turf/T in view(RL_MaxRadius, src))
				if (T.RL_Lights)
					lights |= T.RL_Lights

			var/list/affected = list()
			for (var/datum/light/light in lights)
				if (light.enabled)
					affected |= light.strip(++RL_Generation)
			src.opacity = new_opacity
			for (var/datum/light/light in lights)
				if (light.enabled)
					affected |= light.apply()
			for (var/turf/T in affected)
				T.RL_UpdateLight()
