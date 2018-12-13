//Yes, hi. This is the file that handles Citadel's turf modifications.

/*
/turf/open/floor/Entered(atom/obj, atom/oldloc)
	. = ..()
	CitDirtify(obj, oldloc)*/

//Baystation-styled tile dirtification.
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
			dirt.alpha = min(dirtamount,255)
	return TRUE
