///////////////
// JUDGEMENT // For the big game changing things. TODO: Summonable generals, just need mob sprites for them.
///////////////

//Ark of the Clockwork Justiciar: Creates a Gateway to the Celestial Derelict, summoning ratvar.
/datum/clockwork_scripture/create_object/ark_of_the_clockwork_justiciar
	descname = "Structure, Win Condition"
	name = "Ark of the Clockwork Justiciar"
	desc = "Tears apart a rift in spacetime to Reebe, the Celestial Derelict, using a massive amount of power.\n\
	This gateway will, after some time, call forth Ratvar from his exile and massively empower all scriptures and tools."
	invocations = list("ARMORER! FRIGHT! AMPERAGE! VANGUARD! WE CALL UPON YOU!!", \
	"THE TIME HAS COME FOR OUR MASTER TO BREAK THE CHAINS OF EXILE!!", \
	"LEND US YOUR AID! ENGINE COMES!!")
	channel_time = 150
	power_cost = 70000 //70 KW. It's literally the thing wrenching the god out of another dimension why wouldn't it be costly.
	invokers_required = 6
	multiple_invokers_used = TRUE
	object_path = /obj/structure/destructible/clockwork/massive/celestial_gateway
	creator_message = "<span class='heavy_brass'>The Ark swirls into existance before you with the help of the Generals. After all this time, he shall, finally, be free</span>"
	usage_tip = "The gateway is completely vulnerable to attack during its five-minute duration. It will periodically give indication of its general position to everyone on the station \
	as well as being loud enough to be heard throughout the entire sector. Defend it with your life!"
	tier = SCRIPTURE_APPLICATION
	sort_priority = 1
	requires_full_power = TRUE

/datum/clockwork_scripture/create_object/ark_of_the_clockwork_justiciar/check_special_requirements()
	if(!slab.no_cost)
		if(GLOB.ratvar_awakens)
			to_chat(invoker, "<span class='big_brass'>\"I am already here, there is no point in that.\"</span>")
			return FALSE
		for(var/obj/structure/destructible/clockwork/massive/celestial_gateway/G in GLOB.all_clockwork_objects)
			var/area/gate_area = get_area(G)
			to_chat(invoker, "<span class='userdanger'>There is already an Ark at [gate_area.map_name]!</span>")
			return FALSE
		var/area/A = get_area(invoker)
		var/turf/T = get_turf(invoker)
		if(!is_station_level(T.z) || isspaceturf(T) || !(A?.area_flags & CULT_PERMITTED) || isshuttleturf(T))
			to_chat(invoker, "<span class='warning'>You must be on the station to activate the Ark!</span>")
			return FALSE
		if(GLOB.clockwork_gateway_activated)
			to_chat(invoker, "<span class='warning'>Ratvar's recent banishment renders him too weak to be wrung forth from Reebe!</span>")
			return FALSE
	return ..()

