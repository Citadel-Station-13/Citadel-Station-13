/obj/item/stack/sheet/mineral/plasma/cyborg
	custom_materials = null
	is_cyborg = 1
	cost = 500

/obj/item/stack/sheet/mineral/plasma/cyborg/attackby(obj/item/W as obj, mob/user as mob, params)
	if(W.get_temperature() > 9999)//If the temperature of the object is over 9999, then ignite
		var/turf/T = get_turf(src)
		message_admins("Plasma sheets attempted to be ignited by [ADMIN_LOOKUPFLW(user)] in [ADMIN_VERBOSEJMP(T)]")
		log_game("Plasma sheets attempted to be ignited by [key_name(user)] in [AREACOORD(T)]")
	else
		return ..()

/obj/item/stack/sheet/mineral/plasma/cyborg/fire_act(exposed_temperature, exposed_volume)
	atmos_spawn_air("plasma=[amount*0];TEMP=[null]")
