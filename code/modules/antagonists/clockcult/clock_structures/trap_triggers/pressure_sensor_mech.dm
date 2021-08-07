//Mech sensor: Activates when stepped on by a mech
/obj/structure/destructible/clockwork/trap/trigger/pressure_sensor/mech
	name = "mech sensor"
	desc = "A thin plate of brass, barely visible but clearly distinct."
	clockwork_desc = "A trigger that will activate when a mech controlled by a non-servant runs across it."
	max_integrity = 5
	icon_state = "pressure_sensor"
	alpha = 75

/obj/structure/destructible/clockwork/trap/trigger/pressure_sensor/mech/Crossed(atom/movable/AM)
	. = ..()
	if(!istype(AM,/obj/mecha/))
		return

	var/obj/mecha/M = AM
	if(M.occupant && is_servant_of_ratvar(M.occupant))
		return
	audible_message("<i>*click*</i>")
	playsound(src, 'sound/items/screwdriver2.ogg', 50, TRUE)
	activate()
