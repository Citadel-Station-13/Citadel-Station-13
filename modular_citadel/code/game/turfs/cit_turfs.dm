/turf/open/floor
	var/dirtlevel
	var/candirtify = TRUE

/turf/open/floor/Entered(atom/obj, atom/oldloc)
	. = ..()
	if(candirtify && !isobserver(obj))
		dirtlevel++
		if(oldloc && istype(oldloc, /turf/open/floor))
			var/turf/open/floor/F = oldloc
			dirtlevel += (F.dirtlevel)*0.025
		if(dirtlevel >= 255)
			if(!isobserver(obj))
				var/obj/effect/decal/cleanable/dirt/dirt = locate(/obj/effect/decal/cleanable/dirt, src)
				if(!dirt)
					dirt = new/obj/effect/decal/cleanable/dirt/natural(src)
				dirtlevel = min(dirtlevel, 510)
				dirt.alpha = round(min(dirtlevel-255,255))
