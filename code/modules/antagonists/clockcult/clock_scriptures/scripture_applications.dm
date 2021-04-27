//////////////////
// APPLICATIONS // For various structures and base building, as well as advanced power generation.
//////////////////


//Sigil of Transmission: Creates a sigil of transmission that can drain and store power for clockwork structures.
/datum/clockwork_scripture/create_object/sigil_of_transmission
	descname = "Powers Nearby Structures"
	name = "Sigil of Transmission"
	desc = "Places a sigil that can drain and will store energy to power clockwork structures."
	invocations = list("Divinity...", "...power our creations.")
	channel_time = 70
	power_cost = 200
	whispered = TRUE
	object_path = /obj/effect/clockwork/sigil/transmission
	creator_message = "<span class='brass'>A sigil silently appears below you. It will automatically power clockwork structures near it and will drain power when activated.</span>"
	usage_tip = "Cyborgs can charge from this sigil by remaining over it for 5 seconds."
	tier = SCRIPTURE_APPLICATION
	one_per_tile = TRUE
	primary_component = HIEROPHANT_ANSIBLE
	sort_priority = 2
	important = TRUE
	quickbind = TRUE
	quickbind_desc = "Creates a Sigil of Transmission, which can drain and will store power for clockwork structures."

//Prolonging Prism: Creates a prism that will delay the shuttle at a power cost
/datum/clockwork_scripture/create_object/prolonging_prism
	descname = "Powered Structure, Delay Emergency Shuttles"
	name = "Prolonging Prism"
	desc = "Creates a mechanized prism which will delay the arrival of an emergency shuttle by 2 minutes at a massive power cost."
	invocations = list("May this prism...", "...grant us time to enact his will.")
	channel_time = 80
	power_cost = 300
	object_path = /obj/structure/destructible/clockwork/powered/prolonging_prism
	creator_message = "<span class='brass'>You form a prolonging prism, which will delay the arrival of an emergency shuttle at a massive power cost.</span>"
	observer_message = "<span class='warning'>An onyx prism forms in midair and sprouts tendrils to support itself!</span>"
	invokers_required = 2
	multiple_invokers_used = TRUE
	usage_tip = "The power cost to delay a shuttle increases based on the number of times activated."
	tier = SCRIPTURE_APPLICATION
	one_per_tile = TRUE
	primary_component = VANGUARD_COGWHEEL
	sort_priority = 4
	important = TRUE
	quickbind = TRUE
	quickbind_desc = "Creates a Prolonging Prism, which will delay the arrival of an emergency shuttle by 2 minutes at a massive power cost."

/datum/clockwork_scripture/create_object/prolonging_prism/check_special_requirements()
	if(SSshuttle.emergency.mode == SHUTTLE_DOCKED || SSshuttle.emergency.mode == SHUTTLE_IGNITING || SSshuttle.emergency.mode == SHUTTLE_STRANDED || SSshuttle.emergency.mode == SHUTTLE_ESCAPE)
		to_chat(invoker, "<span class='inathneq'>\"It is too late to construct one of these, champion.\"</span>")
		return FALSE
	var/turf/T = get_turf(invoker)
	if(!T || !is_station_level(T.z))
		to_chat(invoker, "<span class='inathneq'>\"You must be on the station to construct one of these, champion.\"</span>")
		return FALSE
	return ..()

//Mania Motor: Creates a malevolent transmitter that will broadcast the whispers of Sevtug into the minds of nearby nonservants, causing a variety of mental effects at a power cost.
/datum/clockwork_scripture/create_object/mania_motor
	descname = "Powered Structure, Area Denial"
	name = "Mania Motor"
	desc = "Creates a mania motor which causes minor damage and a variety of negative mental effects in nearby non-Servant humans, potentially up to and including conversion."
	invocations = list("May this transmitter...", "...break the will of all who oppose us.")
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
	sort_priority = 5
	quickbind = TRUE
	quickbind_desc = "Creates a Mania Motor, which causes minor damage and negative mental effects in non-Servants."
	requires_full_power = TRUE


//Clockwork Obelisk: Creates a powerful obelisk that can be used to broadcast messages or open a gateway to any servant or clockwork obelisk at a power cost.
/datum/clockwork_scripture/create_object/clockwork_obelisk
	descname = "Powered Structure, Teleportation Hub"
	name = "Clockwork Obelisk"
	desc = "Creates a clockwork obelisk that can broadcast messages over the Hierophant Network or open a Spatial Gateway to any living Servant or clockwork obelisk."
	invocations = list("May this obelisk...", "...take us to all places.")
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

//Memory Allocation: Finds a willing ghost and makes them into a clockwork guardian for the invoker.
/datum/clockwork_scripture/memory_allocation
	descname = "Personal Guardian housed in the brain."
	name = "Memory Allocation"
	desc = "Allocates part of your consciousness to a Clockwork Guardian, a variant of Marauder that lives within you, able to be \
	called forth by Speaking its True Name or if you become exceptionally low on health.<br>\
	If it remains close to you, you will gradually regain health up to a low amount, but it will die if it goes too far from you."
	invocations = list("Fright's will...", "...call forth...")
	channel_time = 100
	power_cost = 8000
	usage_tip = "Guardians are useful as personal bodyguards and frontline warriors."
	tier = SCRIPTURE_APPLICATION
	primary_component = GEIS_CAPACITOR
	sort_priority = 6

/datum/clockwork_scripture/memory_allocation/check_special_requirements()
	for(var/mob/living/simple_animal/hostile/clockwork/guardian/M in GLOB.all_clockwork_mobs)
		if(M.host == invoker)
			to_chat(invoker, "<span class='warning'>You can only house one guardian at a time!</span>")
			return FALSE
	return TRUE

/datum/clockwork_scripture/memory_allocation/scripture_effects()
	return create_guardian()

/datum/clockwork_scripture/memory_allocation/proc/create_guardian()
	invoker.visible_message("<span class='warning'>A purple tendril appears from [invoker]'s [slab.name] and impales itself in [invoker.p_their()] forehead!</span>", \
	"<span class='sevtug'>A tendril flies from [slab] into your forehead. You begin waiting while it painfully rearranges your thought pattern...</span>")
	//invoker.notransform = TRUE //Vulnerable during the process
	slab.busy = "Thought Modification in progress"
	if(!do_after(invoker, 50, target = invoker))
		invoker.visible_message("<span class='warning'>The tendril, covered in blood, retracts from [invoker]'s head and back into the [slab.name]!</span>", \
		"<span class='userdanger'>Total agony overcomes you as the tendril is forced out early!</span>")
		invoker.Knockdown(100)
		invoker.apply_damage(50, BRUTE, "head")//Sevtug leaves a gaping hole in your face if interrupted.
		slab.busy = null
		return FALSE
	clockwork_say(invoker, text2ratvar("...the mind made..."))
	//invoker.notransform = FALSE
	slab.busy = "Guardian Selection in progress"
	if(!check_special_requirements())
		return FALSE
	to_chat(invoker, "<span class='warning'>The tendril shivers slightly as it selects a guardian...</span>")
	var/list/marauder_candidates = pollGhostCandidates("Do you want to play as the clockwork guardian of [invoker.real_name]?", ROLE_SERVANT_OF_RATVAR, null, FALSE, 50, POLL_IGNORE_HOLOPARASITE)
	if(!check_special_requirements())
		return FALSE
	if(!marauder_candidates.len)
		invoker.visible_message("<span class='warning'>The tendril retracts from [invoker]'s head, sealing the entry wound as it does so!</span>", \
		"<span class='warning'>The tendril was unsuccessful! Perhaps you should try again another time.</span>")
		return FALSE
	clockwork_say(invoker, text2ratvar("...sword and shield!"))
	var/mob/dead/observer/theghost = pick(marauder_candidates)
	var/mob/living/simple_animal/hostile/clockwork/guardian/M = new(invoker)
	M.key = theghost.key
	M.bind_to_host(invoker)
	invoker.visible_message("<span class='warning'>The tendril retracts from [invoker]'s head, sealing the entry wound as it does so!</span>", \
	"<span class='sevtug'>[M.true_name], a clockwork guardian, has taken up residence in your mind. Communicate with it via the \"Linked Minds\" action button.</span>")
	return TRUE

//Clockwork Marauder: Creates a construct shell for a clockwork marauder, a well-rounded frontline fighter.
/datum/clockwork_scripture/create_object/construct/clockwork_marauder
	descname = "Well-Rounded Combat Construct"
	name = "Clockwork Marauder"
	desc = "Creates a shell for a clockwork marauder, a balanced frontline construct that can deflect projectiles with its shield."
	invocations = list("Arise, avatar of Arbiter!", "Defend the Ark with vengeful zeal!")
	channel_time = 80
	power_cost = 8000
	creator_message = "<span class='brass'>Your slab disgorges several chunks of replicant alloy that form into a suit of thrumming armor.</span>"
	usage_tip = "Reciting this scripture multiple times in a short period will cause it to take longer!"
	tier = SCRIPTURE_APPLICATION
	one_per_tile = TRUE
	primary_component = BELLIGERENT_EYE
	sort_priority = 7
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
	desc = "Calls forth the mighty Anima Bulwark, a mech with superior defensive and offensive capabilities. It will \
			 steadily regenerate HP and triple its regeneration speed while standing \
			 on a clockwork tile. It will automatically draw power from nearby sigils of \
			 transmission should the need arise. Its Arbiter laser cannon can decimate foes \
			 from a range and is capable of smashing through any barrier presented to it. \
			 Be warned however, choosing to pilot Neovgre is a lifetime commitment, once you are \
			 in you cannot leave and when it is destroyed it will explode catastrophically, with you inside."
	invocations = list("By the strength of the alloy...!!", "...call forth the Arbiter!!")
	channel_time = 200 // This is a strong fucking weapon, 20 seconds channel time is getting off light I tell ya.
	power_cost = 75000 //75 KW
	usage_tip = "Neovgre is a powerful mech that will crush your enemies!"
	invokers_required = 5
	multiple_invokers_used = TRUE
	object_path = /obj/mecha/combat/neovgre
	tier = SCRIPTURE_APPLICATION
	primary_component = BELLIGERENT_EYE
	sort_priority = 8
	creator_message = "<span class='brass'>Neovgre, the Anima Bulwark towers over you... your enemies reckoning has come.</span>"

/datum/clockwork_scripture/create_object/summon_arbiter/check_special_requirements()
	if(GLOB.neovgre_exists)
		to_chat(invoker, "<span class='nezbere'>\"Only one of my weapons may exist in this temporal stream!\"</span>")
		return FALSE
	return ..()
