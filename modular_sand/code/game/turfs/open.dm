/turf/open/floor/attackby(obj/item/E, mob/user)
	. = ..()
	if(istype(E, /obj/item/wallframe/light_fixture/small))
		var/obj/item/wallframe/light_fixture/small/C = E
		C.attach_floor(src, user)

/obj/item/wallframe/light_fixture/small/proc/attach_floor(turf/a_floor, mob/user)
	playsound(src.loc, 'sound/machines/click.ogg', 75, 1)
	user.visible_message("[user.name] attaches [src] to \the [a_floor].",
		"<span class='notice'>You attach [src] to \the [a_floor].</span>",
		"<span class='italics'>You hear clicking.</span>")
	var/obj/O = new /obj/structure/light_construct/floor(a_floor, 1, TRUE)
	after_attach(O)

	qdel(src)
