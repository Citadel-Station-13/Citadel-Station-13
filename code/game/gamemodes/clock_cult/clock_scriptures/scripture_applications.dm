//////////////////
// APPLICATIONS //
//////////////////


//Sigil of Transmission: Creates a sigil of transmission that can drain and store power for clockwork structures.
/datum/clockwork_scripture/create_object/sigil_of_transmission
	descname = "Powers Nearby Structures - Important!"
	name = "Sigil of Transmission"
	desc = "Places a sigil that can drain and will store energy to power clockwork structures."
	invocations = list("Divinity...", "...power our creations!")
	channel_time = 70
	power_cost = 200
	whispered = TRUE
	object_path = /obj/effect/clockwork/sigil/transmission
	creator_message = "<span class='brass'>A sigil silently appears below you. It will automatically power clockwork structures near it and will drain power when activated.</span>"
	usage_tip = "Cyborgs can charge from this sigil by remaining over it for 5 seconds."
	tier = SCRIPTURE_APPLICATION
	one_per_tile = TRUE
	primary_component = HIEROPHANT_ANSIBLE
	sort_priority = 1
	quickbind = TRUE
	quickbind_desc = "Creates a Sigil of Transmission, which can drain and will store power for clockwork structures."


//Mania Motor: Creates a malevolent transmitter that will broadcast the whispers of Sevtug into the minds of nearby nonservants, causing a variety of mental effects at a power cost.
/datum/clockwork_scripture/create_object/mania_motor
	descname = "Powered Structure, Area Denial"
	name = "Mania Motor"
	desc = "Creates a mania motor which causes minor damage and a variety of negative mental effects in nearby non-Servant humans, potentially up to and including conversion."
	invocations = list("May this transmitter...", "...break the will of all who oppose us!")
	channel_time = 80
	power_cost = 750
	object_path = /obj/structure/destructible/clockwork/powered/mania_motor
	creator_message = "<span class='brass'>You form a mania motor, which causes minor damage and negative mental effects in non-Servants.</span>"
	observer_message = "<span class='warning'>A two-pronged machine rises from the ground!</span>"
	invokers_required = 2
	multiple_invokers_used = TRUE
	usage_tip = "It will also cure hallucinations and brain damage in nearby Servants."
	tier = SCRIPTURE_APPLICATION
	one_per_tile = TRUE
	primary_component = HIEROPHANT_ANSIBLE
	sort_priority = 2
	quickbind = TRUE
	quickbind_desc = "Creates a Mania Motor, which causes minor damage and negative mental effects in non-Servants."


//Clockwork Obelisk: Creates a powerful obelisk that can be used to broadcast messages or open a gateway to any servant or clockwork obelisk at a power cost.
/datum/clockwork_scripture/create_object/clockwork_obelisk
	descname = "Powered Structure, Teleportation Hub"
	name = "Clockwork Obelisk"
	desc = "Creates a clockwork obelisk that can broadcast messages over the Hierophant Network or open a Spatial Gateway to any living Servant or clockwork obelisk."
	invocations = list("May this obelisk...", "...take us to all places!")
	channel_time = 80
	power_cost = 300
	object_path = /obj/structure/destructible/clockwork/powered/clockwork_obelisk
	creator_message = "<span class='brass'>You form a clockwork obelisk which can broadcast messages or produce Spatial Gateways.</span>"
	observer_message = "<span class='warning'>A brass obelisk appears hanging in midair!</span>"
	invokers_required = 2
	multiple_invokers_used = TRUE
	usage_tip = "Producing a gateway has a high power cost. Gateways to or between clockwork obelisks receive double duration and uses."
	tier = SCRIPTURE_APPLICATION
	one_per_tile = TRUE
	primary_component = HIEROPHANT_ANSIBLE
	sort_priority = 3
	quickbind = TRUE
	quickbind_desc = "Creates a Clockwork Obelisk, which can send messages or open Spatial Gateways with power."


//Clockwork Marauder: Creates a construct shell for a clockwork marauder, a well-rounded frontline fighter.
/datum/clockwork_scripture/create_object/construct/clockwork_marauder
	descname = "Well-Rounded Combat Construct"
	name = "Clockwork Marauder"
	desc = "Creates a shell for a clockwork marauder, a balanced frontline construct that can deflect projectiles with its shield."
	invocations = list("Arise, avatar of Arbiter!", "Defend the Ark with vengeful zeal.")
	channel_time = 50
	power_cost = 1000
	creator_message = "<span class='brass'>Your slab disgorges several chunks of replicant alloy that form into a suit of thrumming armor.</span>"
	usage_tip = "Reciting this scripture multiple times in a short period will cause it to take longer!"
	tier = SCRIPTURE_APPLICATION
	one_per_tile = TRUE
	primary_component = BELLIGERENT_EYE
	sort_priority = 4
	quickbind = TRUE
	quickbind_desc = "Creates a clockwork marauder, used for frontline combat."
	object_path = /obj/item/clockwork/construct_chassis/clockwork_marauder
	construct_type = /mob/living/simple_animal/hostile/clockwork/marauder
	combat_construct = TRUE
	var/static/recent_marauders = 0
	var/static/time_since_last_marauder = 0
	var/static/scaled_recital_time = 0

/datum/clockwork_scripture/create_object/construct/clockwork_marauder/update_construct_limit()
	var/human_servants = 0
	for(var/V in SSticker.mode.servants_of_ratvar)
		var/datum/mind/M = V
		if(ishuman(M.current))
			human_servants++
	construct_limit = human_servants / 4 //1 per 4 human servants, and a maximum of 3 marauders
	construct_limit = CLAMP(construct_limit, 1, 3)

/datum/clockwork_scripture/create_object/construct/clockwork_marauder/pre_recital()
	channel_time = initial(channel_time)
	calculate_scaling()
	if(scaled_recital_time)
		to_chat(invoker, "<span class='warning'>The Hierophant Network is under strain from repeated summoning, making this scripture [scaled_recital_time / 10] seconds slower!</span>")
		channel_time += scaled_recital_time
	return TRUE

/datum/clockwork_scripture/create_object/construct/clockwork_marauder/scripture_effects()
	. = ..()
	time_since_last_marauder = world.time
	recent_marauders++
	calculate_scaling()

/datum/clockwork_scripture/create_object/construct/clockwork_marauder/proc/calculate_scaling()
	var/WT = world.time
	var/MT = time_since_last_marauder //Cast it for quicker reference
	var/marauders_to_exclude = 0
	if(world.time >= time_since_last_marauder + MARAUDER_SCRIPTURE_SCALING_THRESHOLD)
		marauders_to_exclude = round(WT - MT) / MARAUDER_SCRIPTURE_SCALING_THRESHOLD //If at least 20 seconds have passed, lose one marauder for each 20 seconds
		//i.e. world.time = 10000, last marauder = 9000, so we lose 5 marauders from the recent count since 10k - 9k = 1k, 1k / 200 = 5
		time_since_last_marauder = world.time //So that it can't be spammed to make the marauder exclusion plummet; this emulates "ticking"
	recent_marauders = max(0, recent_marauders - marauders_to_exclude)
	scaled_recital_time = min(recent_marauders * MARAUDER_SCRIPTURE_SCALING_TIME, MARAUDER_SCRIPTURE_SCALING_MAX)
