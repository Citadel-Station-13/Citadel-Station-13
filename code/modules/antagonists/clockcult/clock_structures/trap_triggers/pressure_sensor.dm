//Pressure sensor: Activates when stepped on.
/obj/structure/destructible/clockwork/trap/trigger/pressure_sensor
	name = "pressure sensor"
	desc = "A thin plate of brass, barely visible but clearly distinct."
	clockwork_desc = "A trigger that will activate when a non-servant runs across it."
	max_integrity = 5
	icon_state = "pressure_sensor"
	alpha = 50

/obj/structure/destructible/clockwork/trap/trigger/pressure_sensor/Crossed(atom/movable/AM)
	if(isliving(AM) && !is_servant_of_ratvar(AM))
		var/mob/living/L = AM
		if(L.stat || L.m_intent == MOVE_INTENT_WALK || L.movement_type & (FLYING|FLOATING))
			return
		audible_message("<i>*click*</i>")
		playsound(src, 'sound/items/screwdriver2.ogg', 50, TRUE)
		activate()
