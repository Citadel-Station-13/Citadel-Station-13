//////////////////
// APPLICATIONS //
//////////////////


//Sigil of Transmission: Creates a sigil of transmission that can drain and store power for clockwork structures.
/datum/clockwork_scripture/create_object/sigil_of_transmission
	descname = "Powers Nearby Structures"
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
	important = TRUE
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
	channel_time = 80
	power_cost = 8000
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
	var/static/last_marauder = 0

/datum/clockwork_scripture/create_object/construct/clockwork_marauder/post_recital()
	last_marauder = world.time
	return ..()

/datum/clockwork_scripture/create_object/construct/clockwork_marauder/pre_recital()
	if(!is_reebe(invoker.z))
		if(!CONFIG_GET(flag/allow_clockwork_marauder_on_station))
			to_chat(invoker, "<span class='brass'>This particular station is too far from the influence of the Hierophant Network. You can not summon a marauder here.</span>")
			return FALSE
		if(world.time < (last_marauder + CONFIG_GET(number/marauder_delay_non_reebe)))
			to_chat(invoker, "<span class='brass'>The hierophant network is still strained from the last summoning of a marauder on a plane without the strong energy connection of Reebe to support it. \
			You must wait another [DisplayTimeText((last_marauder + CONFIG_GET(number/marauder_delay_non_reebe)) - world.time, TRUE)]!</span>")
			return FALSE
	return ..()

/datum/clockwork_scripture/create_object/construct/clockwork_marauder/update_construct_limit()
	var/human_servants = 0
	for(var/V in SSticker.mode.servants_of_ratvar)
		var/datum/mind/M = V
		var/mob/living/L = M.current
		if(ishuman(L) && L.stat != DEAD)
			human_servants++
	construct_limit = round(clamp((human_servants / 4), 1, 3))	//1 per 4 human servants, maximum of 3

//Summon Neovgre: Summon a very powerful combat mech that explodes when destroyed for massive damage.
/datum/clockwork_scripture/create_object/summon_arbiter
	descname = "Powerful Assault Mech"
	name = "Summon Neovgre, the Anima Bulwark"
	desc = "Calls forth the mighty Anima Bulwark, a weapon of unmatched power,\
			 mech with superior defensive and offensive capabilities. It will \
			 steadily regenerate HP and triple its regeneration speed while standing \
			 on a clockwork tile. It will automatically draw power from nearby sigils of \
			 transmission should the need arise. Its Arbiter laser cannon can decimate foes \
			 from a range and is capable of smashing through any barrier presented to it. \
			 Be warned, choosing to pilot Neovgre is a lifetime commitment, once you are \
			 in you cannot leave and when it is destroyed it will explode catastrophically with you inside."
	invocations = list("By the strength of the alloy...!!", "...call forth the Arbiter!!")
	channel_time = 200 // This is a strong fucking weapon, 20 seconds channel time is getting off light I tell ya.
	power_cost = 75000 //75 KW
	usage_tip = "Neovgre is a powerful mech that will crush your enemies!"
	invokers_required = 5
	multiple_invokers_used = TRUE
	object_path = /obj/mecha/combat/neovgre
	tier = SCRIPTURE_APPLICATION
	primary_component = BELLIGERENT_EYE
	sort_priority = 2
	creator_message = "<span class='brass'>Neovgre, the Anima Bulwark towers over you... your enemies reckoning has come.</span>"

/datum/clockwork_scripture/create_object/summon_arbiter/check_special_requirements()
	if(GLOB.neovgre_exists)
		to_chat(invoker, "<span class='nezbere'>\"Only one of my weapons may exist in this temporal stream!\"</span>")
		return FALSE
	return ..()
