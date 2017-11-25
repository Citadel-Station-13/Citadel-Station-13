//Yes, hi. This is the file that handles Citadel's turf modifications.

//But before we touch turfs, we'll take some time to define a couple of things for footstep sounds.
/mob/living
	var/makesfootstepsounds
	var/footstepcount

/mob/living/carbon/human
	makesfootstepsounds = TRUE

/atom
	var/footstepsoundoverride

//All of these sounds are from CEV Eris as of 11/25/2017, the time when the original PR adding footstep sounds was made.
GLOBAL_LIST_INIT(turf_footstep_sounds, list(
				"floor" = list('modular_citadel/sound/footstep/floor1.ogg','modular_citadel/sound/footstep/floor2.ogg','modular_citadel/sound/footstep/floor3.ogg','modular_citadel/sound/footstep/floor4.ogg','modular_citadel/sound/footstep/floor5.ogg'),
				"plating" = list('modular_citadel/sound/footstep/plating1.ogg','modular_citadel/sound/footstep/plating2.ogg','modular_citadel/sound/footstep/plating3.ogg','modular_citadel/sound/footstep/plating4.ogg','modular_citadel/sound/footstep/plating5.ogg'),
				"wood" = list('modular_citadel/sound/footstep/wood1.ogg','modular_citadel/sound/footstep/wood2.ogg','modular_citadel/sound/footstep/wood3.ogg','modular_citadel/sound/footstep/wood4.ogg','modular_citadel/sound/footstep/wood5.ogg'),
				"carpet" = list('modular_citadel/sound/footstep/carpet1.ogg','modular_citadel/sound/footstep/carpet2.ogg','modular_citadel/sound/footstep/carpet3.ogg','modular_citadel/sound/footstep/carpet4.ogg','modular_citadel/sound/footstep/carpet5.ogg'),
				"hull" = list('modular_citadel/sound/footstep/hull1.ogg','modular_citadel/sound/footstep/hull2.ogg','modular_citadel/sound/footstep/hull3.ogg','modular_citadel/sound/footstep/hull4.ogg','modular_citadel/sound/footstep/hull5.ogg'),
				"catwalk" = list('modular_citadel/sound/footstep/catwalk1.ogg','modular_citadel/sound/footstep/catwalk2.ogg','modular_citadel/sound/footstep/catwalk3.ogg','modular_citadel/sound/footstep/catwalk4.ogg','modular_citadel/sound/footstep/catwalk5.ogg'),
				"asteroid" = list('modular_citadel/sound/footstep/asteroid1.ogg','modular_citadel/sound/footstep/asteroid2.ogg','modular_citadel/sound/footstep/asteroid3.ogg','modular_citadel/sound/footstep/asteroid4.ogg','modular_citadel/sound/footstep/asteroid5.ogg')
				))

/turf/open/floor
	var/footstepsounds = "floor"

/turf/open/floor/plating
	footstepsounds = "plating"

/turf/open/floor/wood
	footstepsounds = "wood"

/turf/open/floor/plating/asteroid
	footstepsounds = "asteroid"

/turf/open/floor/grass
	footstepsounds = "grass"

/turf/open/floor/carpet
	footstepsounds = "carpet"

/obj/machinery/atmospherics/components/unary/vent_pump
	footstepsoundoverride = "catwalk"

/obj/machinery/atmospherics/components/unary/vent_scrubber
	footstepsoundoverride = "catwalk"

/obj/structure/disposalpipe
	footstepsoundoverride = "catwalk"

/obj/machinery/holopad
	footstepsoundoverride = "catwalk"

/obj/structure/table
	footstepsoundoverride = "hull"

/obj/structure/table/wood
	footstepsoundoverride = "wood"

/turf/open/floor/Entered(atom/obj, atom/oldloc)
	. = ..()
	CitDirtify(obj, oldloc)
	CitFootstep(obj)

//Baystation-styled tile dirtification. Except 31 lines more complex than it probably has to be.
/turf/open/floor/proc/CitDirtify(atom/obj, atom/oldloc)
	if(prob(50))
		if(has_gravity(src) && !isobserver(obj))
			var/dirtamount
			var/obj/effect/decal/cleanable/dirt/dirt = locate(/obj/effect/decal/cleanable/dirt, src)
			if(!dirt)
				dirt = new/obj/effect/decal/cleanable/dirt(src)
				dirt.alpha = 0
				dirtamount = 0
			dirtamount = dirt.alpha + 1
			if(oldloc && istype(oldloc, /turf/open/floor))
				var/obj/effect/decal/cleanable/dirt/spreadindirt = locate(/obj/effect/decal/cleanable/dirt, oldloc)
				if(spreadindirt && spreadindirt.alpha)
					dirtamount += round(spreadindirt.alpha * 0.05)
			dirtamount = min(dirtamount,255)
			var/mob/living/carbon/human/H = obj
			if(H && istype(H, /mob/living/carbon/human))
				var/obj/item/clothing/shoes/S = H.shoes
				if(S && !(S.blood_state == BLOOD_STATE_NOT_BLOODY))
					if(!dirt.atom_colours || !dirt.atom_colours.len)
						dirt.add_atom_colour(color_matrix_identity(), FIXED_COLOUR_PRIORITY)
					var/list/origdirtcolor = dirt.atom_colours[FIXED_COLOUR_PRIORITY]
					var/list/colordirt = color_matrix_identity()
					switch(S.blood_state)
						if(BLOOD_STATE_HUMAN)
							dirt.remove_atom_colour(FIXED_COLOUR_PRIORITY)
							colordirt = list(0,0,0,0, 0,-0.15,0,0, 0,0,-0.15,0, 0,0,0,0, 0,0,0,0)
							dirt.add_atom_colour(color_matrix_add(origdirtcolor, colordirt), FIXED_COLOUR_PRIORITY)
							dirt.alpha = dirtamount
						if(BLOOD_STATE_XENO)
							dirt.remove_atom_colour(FIXED_COLOUR_PRIORITY)
							colordirt = list(-0.15,0,0,0, 0,0,0,0, 0,0,-0.15,0, 0,0,0,0, 0,0,0,0)
							dirt.add_atom_colour(color_matrix_add(origdirtcolor, colordirt), FIXED_COLOUR_PRIORITY)
						if(BLOOD_STATE_OIL)
							dirt.remove_atom_colour(FIXED_COLOUR_PRIORITY)
							colordirt = list(-0.15,0,0,0, 0,-0.15,0,0, 0,0,-0.15,0, 0,0,0,0, 0,0,0,0)
							dirt.add_atom_colour(color_matrix_add(origdirtcolor, colordirt), FIXED_COLOUR_PRIORITY)
			dirt.alpha = dirtamount
	return TRUE

//The proc that handles footsteps! It's pure, unfiltered spaghetti code.
/turf/open/floor/proc/CitFootstep(atom/obj)
	if(obj && has_gravity(src) && footstepsounds && istype(obj, /mob/living))
		var/mob/living/steppingman = obj
		steppingman.footstepcount++
		if(steppingman && steppingman.makesfootstepsounds && steppingman.m_intent == MOVE_INTENT_RUN && steppingman.canmove && steppingman.footstepcount >= 3)
			steppingman.footstepcount = 0
			var/overriddenfootstepsound
			if(obj.footstepsoundoverride)
				if(isfile(obj.footstepsoundoverride))
					overriddenfootstepsound = list(obj.footstepsoundoverride)
				else
					overriddenfootstepsound = obj.footstepsoundoverride
			if(!overriddenfootstepsound && istype(obj, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = obj
				if(H && H.shoes)
					var/obj/item/clothing/shoes/S = H.shoes
					if(S && S.footstepsoundoverride)
						if(isfile(S.footstepsoundoverride))
							overriddenfootstepsound = list(S.footstepsoundoverride)
						else
							overriddenfootstepsound = S.footstepsoundoverride
			if(!overriddenfootstepsound)
				var/objschecked
				for(var/atom/childobj in contents)
					if(childobj.footstepsoundoverride && childobj.invisibility < INVISIBILITY_MAXIMUM)
						if(isfile(childobj.footstepsoundoverride))
							overriddenfootstepsound = list(childobj.footstepsoundoverride)
						else
							overriddenfootstepsound = childobj.footstepsoundoverride
						break
					objschecked++
					if(objschecked >= 25)
						break //walking on 50k foam darts didn't crash the server during my testing, but its better to be safe than sorry
			playsound(src,(overriddenfootstepsound ? (islist(overriddenfootstepsound) ? pick(overriddenfootstepsound) : pick(GLOB.turf_footstep_sounds[overriddenfootstepsound])) : (islist(footstepsounds) ? pick(footstepsounds) : pick(GLOB.turf_footstep_sounds[footstepsounds]))),50, 1)
