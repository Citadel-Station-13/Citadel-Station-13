//Yes, hi. This is the file that handles Citadel's turf modifications.
/turf/open/floor/Entered(atom/obj, atom/oldloc)
	. = ..()
	CitDirtify(obj, oldloc)

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