/obj/machinery/portable_atmospherics
	name = "portable_atmospherics"
	icon = 'icons/obj/atmos.dmi'
	use_power = 0

	var/datum/gas_mixture/air_contents
	var/obj/machinery/atmospherics/components/unary/portables_connector/connected_port
	var/obj/item/weapon/tank/holding

	var/volume = 0

	var/maximum_pressure = 90 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/New()
	..()
	SSair.atmos_machinery += src

	air_contents = new
	air_contents.volume = volume
	air_contents.temperature = T20C

	return 1

/obj/machinery/portable_atmospherics/Destroy()
	SSair.atmos_machinery -= src

	disconnect()
	qdel(air_contents)
	air_contents = null

	return ..()

/obj/machinery/portable_atmospherics/process_atmos()
	if(!connected_port) // Pipe network handles reactions if connected.
		air_contents.react()
	else
		update_icon()

/obj/machinery/portable_atmospherics/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/proc/connect(obj/machinery/atmospherics/components/unary/portables_connector/new_port)
	//Make sure not already connected to something else
	if(connected_port || !new_port || new_port.connected_device)
		return 0

	//Make sure are close enough for a valid connection
	if(new_port.loc != loc)
		return 0

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = src
	var/datum/pipeline/connected_port_parent = connected_port.PARENT1
	connected_port_parent.reconcile_air()

	anchored = 1 //Prevent movement
	return 1

/obj/machinery/portable_atmospherics/proc/disconnect()
	if(!connected_port)
		return 0
	anchored = 0
	connected_port.connected_device = null
	connected_port = null
	return 1

/obj/machinery/portable_atmospherics/portableConnectorReturnAir()
	return air_contents

/obj/machinery/portable_atmospherics/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/tank))
		if(!(stat & BROKEN))
			var/obj/item/weapon/tank/T = W
			if(holding || !user.drop_item())
				return
			T.loc = src
			holding = T
			update_icon()
	else if(istype(W, /obj/item/weapon/wrench))
		if(!(stat & BROKEN))
			if(connected_port)
				disconnect()
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				user.visible_message( \
					"[user] disconnects [src].", \
					"<span class='notice'>You unfasten [src] from the port.</span>", \
					"<span class='italics'>You hear a ratchet.</span>")
				update_icon()
				return
			else
				var/obj/machinery/atmospherics/components/unary/portables_connector/possible_port = locate(/obj/machinery/atmospherics/components/unary/portables_connector) in loc
				if(!possible_port)
					user << "<span class='notice'>Nothing happens.</span>"
					return
				if(!connect(possible_port))
					user << "<span class='notice'>[name] failed to connect to the port.</span>"
					return
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				user.visible_message( \
					"[user] connects [src].", \
					"<span class='notice'>You fasten [src] to the port.</span>", \
					"<span class='italics'>You hear a ratchet.</span>")
				update_icon()
	else if(istype(W, /obj/item/device/analyzer) && Adjacent(user))
		atmosanalyzer_scan(air_contents, user)
	else
		return ..()