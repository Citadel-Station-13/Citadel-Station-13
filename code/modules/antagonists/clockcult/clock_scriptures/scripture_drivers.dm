/////////////
// DRIVERS // Starter spells
/////////////

//Stargazer: Creates a stargazer, a cheap power generator that utilizes starlight.
/datum/clockwork_scripture/create_object/stargazer
	descname = "Generates Power From Starlight"
	name = "Stargazer"
	desc = "Forms a weak structure that generates power every second while within three tiles of starlight."
	invocations = list("Capture their inferior light for us!")
	channel_time = 50
	power_cost = 200
	object_path = /obj/structure/destructible/clockwork/stargazer
	creator_message = "<span class='brass'>You form a stargazer, which will generate power near starlight.</span>"
	observer_message = "<span class='warning'>A large lantern-shaped machine forms!</span>"
	usage_tip = "For obvious reasons, make sure to place this near a window or somewhere else that can see space!"
	tier = SCRIPTURE_DRIVER
	one_per_tile = TRUE
	primary_component = HIEROPHANT_ANSIBLE
	sort_priority = 1
	quickbind = TRUE
	quickbind_desc = "Creates a stargazer, which generates power when near starlight."

/datum/clockwork_scripture/create_object/stargazer/check_special_requirements()
	var/area/A = get_area(invoker)
	if(A.outdoors || A.map_name == "Space" || !A.blob_allowed)
		to_chat(invoker, "<span class='danger'>Stargazers can't be built off-station.</span>")
		return
	return ..()


//Integration Cog: Creates an integration cog that can be inserted into APCs to passively siphon power.
/datum/clockwork_scripture/create_object/integration_cog
	descname = "Power Generation"
	name = "Integration Cog"
	desc = "Fabricates an integration cog, which can be used on an open APC to replace its innards and passively siphon its power."
	invocations = list("Take that which sustains them!")
	channel_time = 10
	power_cost = 10
	whispered = TRUE
	object_path = /obj/item/clockwork/integration_cog
	creator_message = "<span class='brass'>You form an integration cog, which can be inserted into an open APC to passively siphon power.</span>"
	usage_tip = "Tampering isn't visible unless the APC is opened. You can use the cog on a locked APC to unlock it."
	tier = SCRIPTURE_DRIVER
	space_allowed = TRUE
	primary_component = HIEROPHANT_ANSIBLE
	sort_priority = 2
	important = TRUE
	quickbind = TRUE
	quickbind_desc = "Creates an integration cog, which can be used to siphon power from an open APC."


//Sigil of Transgression: Creates a sigil of transgression, which briefly stuns and applies Belligerent to the first non-servant to cross it.
/datum/clockwork_scripture/create_object/sigil_of_transgression
	descname = "Trap, Stunning"
	name = "Sigil of Transgression"
	desc = "Wards a tile with a sigil, which will briefly stun the next non-Servant to cross it and apply Belligerent to them."
	invocations = list("Divinity, smite...", "...those who trespass here!")
	channel_time = 50
	power_cost = 50
	whispered = TRUE
	object_path = /obj/effect/clockwork/sigil/transgression
	creator_message = "<span class='brass'>A sigil silently appears below you. The next non-Servant to cross it will be smitten.</span>"
	usage_tip = "The sigil does not silence its victim, and is generally used to soften potential converts or would-be invaders."
	tier = SCRIPTURE_DRIVER
	one_per_tile = TRUE
	primary_component = HIEROPHANT_ANSIBLE
	sort_priority = 3
	quickbind = TRUE
	quickbind_desc = "Creates a Sigil of Transgression, which will briefly stun and slow the next non-Servant to cross it."


//Sigil of Submission: Creates a sigil of submission, which converts one heretic above it after a delay.
/datum/clockwork_scripture/create_object/sigil_of_submission
	descname = "Trap, Conversion"
	name = "Sigil of Submission"
	desc = "Places a luminous sigil that will convert any non-Servants that remain on it for 8 seconds."
	invocations = list("Divinity, enlighten...", "...those who trespass here!")
	channel_time = 60
	power_cost = 125
	whispered = TRUE
	object_path = /obj/effect/clockwork/sigil/submission
	creator_message = "<span class='brass'>A luminous sigil appears below you. Any non-Servants to cross it will be converted and healed of some of their wounds after 8 seconds if they do not move.</span>"
	usage_tip = "This is the primary conversion method, though it will not penetrate mindshield implants."
	tier = SCRIPTURE_DRIVER
	one_per_tile = TRUE
	primary_component = HIEROPHANT_ANSIBLE
	sort_priority = 4
	quickbind = TRUE
	quickbind_desc = "Creates a Sigil of Submission, which will convert non-Servants that remain on it."
	requires_full_power = TRUE

//Kindle: Charges the slab with blazing energy. It can be released to stun and silence a target.
/datum/clockwork_scripture/ranged_ability/kindle
	descname = "Short-Range Single-Target Stun"
	name = "Kindle"
	desc = "Charges your slab with divine energy, allowing you to overwhelm a target with Ratvar's light."
	invocations = list("Divinity, show them your light!")
	whispered = TRUE
	channel_time = 20 // I think making kindle channel a third of the time less is a good make up for the fact that it silences people for such a little amount of time.
	power_cost = 125
	usage_tip = "The light can be used from up to two tiles away. Damage taken will GREATLY REDUCE the stun's duration."
	tier = SCRIPTURE_DRIVER
	primary_component = BELLIGERENT_EYE
	sort_priority = 5
	slab_overlay = "volt"
	ranged_type = /obj/effect/proc_holder/slab/kindle
	ranged_message = "<span class='brass'><i>You charge the clockwork slab with divine energy.</i>\n\
	<b>Left-click a target within melee range to stun!\n\
	Click your slab to cancel.</b></span>"
	timeout_time = 150
	important = TRUE
	quickbind = TRUE
	quickbind_desc = "Stuns and mutes a target from a short range."

/*
//Geis: Grants a short-range binding attack that allows you to mute and drag around a target in a very obvious manner.
/datum/clockwork_scripture/ranged_ability/geis
	descname = "Melee Mute & Stun"
	name = "Geis"
	desc = "Charges your slab with divine energy, allowing you to bind and pull a struck heretic."
	invocations = list("Divinity, grant me strength...", "...to bind the heathen!")
	whispered = TRUE
	channel_time = 20
	usage_tip = "You CANNOT TAKE ANY NON-PULL ACTIONS while the target is bound, so Sigils of Submission should be placed before use."
	tier = SCRIPTURE_DRIVER
	primary_component = GEIS_CAPACITOR
	sort_priority = 5
	quickbind = TRUE
	quickbind_desc = "Allows you to bind and mute an adjacent target non-Servant.<br><b>Click your slab to disable.</b>"
	slab_overlay = "geis"
	ranged_type = /obj/effect/proc_holder/slab/geis
	ranged_message = "<span class='sevtug_small'><i>You charge the clockwork slab with divine energy.</i>\n\
	<b>Left-click a target within melee range to bind!\n\
	Click your slab to cancel.</b></span>"
	timeout_time = 100

/datum/clockwork_scripture/ranged_ability/geis/run_scripture()
	var/servants = 0
	if(!GLOB.ratvar_awakens)
		for(var/mob/living/M in GLOB.living_mob_list)
			if(can_recite_scripture(M, TRUE))
				servants++
	if(servants > SCRIPT_SERVANT_REQ)
		whispered = FALSE
		servants -= SCRIPT_SERVANT_REQ
		channel_time = min(channel_time + servants*3, 50)
	return ..()
*/

//Hateful Manacles: Applies restraints from melee over several seconds. The restraints function like handcuffs and break on removal.
/datum/clockwork_scripture/ranged_ability/hateful_manacles
	descname = "Handcuffs"
	name = "Hateful Manacles"
	desc = "Forms replicant manacles around a target's wrists that function like handcuffs."
	invocations = list("Shackle the heretic!", "Break them in body and spirit!")
	channel_time = 15
	power_cost = 25
	whispered = TRUE
	usage_tip = "The manacles are about as strong as zipties, and break when removed."
	tier = SCRIPTURE_DRIVER
	primary_component = BELLIGERENT_EYE
	sort_priority = 6
	ranged_type = /obj/effect/proc_holder/slab/hateful_manacles
	slab_overlay = "hateful_manacles"
	ranged_message = "<span class='neovgre_small'><i>You charge the clockwork slab with divine energy.</i>\n\
	<b>Left-click a target within melee range to shackle!\n\
	Click your slab to cancel.</b></span>"
	timeout_time = 200
	important = TRUE
	quickbind = TRUE
	quickbind_desc = "Applies handcuffs to a struck target."


//Vanguard: Provides twenty seconds of greatly increased stamina regeneration and stun immunity. At the end of the twenty seconds, 25% of all stuns absorbed aswell as 50% of healed stamloss are applied to the invoker.
/datum/clockwork_scripture/vanguard
	descname = "Self Stun Immunity"
	name = "Vanguard"
	desc = "Provides twenty seconds of greatly increased stamina regeneration and stun immunity. At the end of the twenty seconds, the invoker is knocked down for the equivalent of 25% of all stuns they absorbed aswell as incurring 50% of the stamina regenerated as stamina loss \
	Excessive absorption will cause unconsciousness."
	invocations = list("Shield me...", "...from darkness!")
	channel_time = 30
	power_cost = 75
	usage_tip = "You cannot reactivate Vanguard while still shielded by it."
	tier = SCRIPTURE_DRIVER
	primary_component = VANGUARD_COGWHEEL
	sort_priority = 7
	quickbind = TRUE
	quickbind_desc = "Allows you to temporarily have quickly regenerating stamina and absorb stuns. Part of the stuns absorbed and staminaloss healed will affect you when disabled."

/datum/clockwork_scripture/vanguard/check_special_requirements()
	if(!GLOB.ratvar_awakens && islist(invoker.stun_absorption) && invoker.stun_absorption["vanguard"] && invoker.stun_absorption["vanguard"]["end_time"] > world.time)
		to_chat(invoker, "<span class='warning'>You are already shielded by a Vanguard!</span>")
		return FALSE
	return TRUE

/datum/clockwork_scripture/vanguard/scripture_effects()
	if(GLOB.ratvar_awakens)
		for(var/mob/living/L in view(7, get_turf(invoker)))
			if(L.stat != DEAD && is_servant_of_ratvar(L))
				L.apply_status_effect(STATUS_EFFECT_VANGUARD)
			CHECK_TICK
	else
		invoker.apply_status_effect(STATUS_EFFECT_VANGUARD)
	return TRUE


//Sentinel's Compromise: Allows the invoker to select a nearby servant and convert their brute, burn, and oxygen damage into half as much toxin damage.
/datum/clockwork_scripture/ranged_ability/sentinels_compromise
	descname = "Convert Brute/Burn/Oxygen to Half Toxin"
	name = "Sentinel's Compromise"
	desc = "Charges your slab with healing power, allowing you to convert all of a target Servant's brute, burn, and oxygen damage to half as much toxin damage."
	invocations = list("Mend the wounds of...", "...my inferior flesh.")
	channel_time = 30
	power_cost = 100
	usage_tip = "The Compromise is very fast to invoke, and will remove holy water from the target Servant."
	tier = SCRIPTURE_DRIVER
	primary_component = VANGUARD_COGWHEEL
	sort_priority = 8
	quickbind = TRUE
	quickbind_desc = "Allows you to convert a Servant's brute, burn, and oxygen damage to half toxin damage.<br><b>Click your slab to disable.</b>"
	slab_overlay = "compromise"
	ranged_type = /obj/effect/proc_holder/slab/compromise
	ranged_message = "<span class='inathneq_small'><i>You charge the clockwork slab with healing power.</i>\n\
	<b>Left-click a fellow Servant or yourself to heal!\n\
	Click your slab to cancel.</b></span>"


//Abscond: Used to return to Reebe.
/datum/clockwork_scripture/abscond
	descname = "Safety warp, teleports you somewhere random. moderately high power cost to use."
	name = "Abscond"
	desc = "Yanks you through space, putting you in hopefully a safe location."
	invocations = list("As we bid farewell, and return to the stars...", "...we shall find our way home.")
	whispered = TRUE
	channel_time = 3.5
	power_cost = 10000
	usage_tip = "This can't be used while on Reebe, for obvious reasons."
	tier = SCRIPTURE_DRIVER
	primary_component = GEIS_CAPACITOR
	sort_priority = 9
	important = TRUE
	quickbind = TRUE
	quickbind_desc = "Teleports you somewhere random. Use in emergencies."
	var/client_color
	requires_full_power = TRUE

/datum/clockwork_scripture/abscond/check_special_requirements()
	if(is_reebe(invoker.z))
		to_chat(invoker, "<span class='danger'>You're at Reebe.</span>")
		return
	if(!isturf(invoker.loc))
		to_chat(invoker, "<span class='danger'>You must be visible to warp!</span>")
		return
	return TRUE

/datum/clockwork_scripture/abscond/recital()
	client_color = invoker.client.color
	animate(invoker.client, color = "#AF0AAF", time = 50)
	. = ..()

/datum/clockwork_scripture/abscond/scripture_effects()
	var/turf/T
	if(GLOB.ark_of_the_clockwork_justiciar)
		T = get_step(GLOB.ark_of_the_clockwork_justiciar, SOUTH)
	else
		T = get_turf(pick(GLOB.servant_spawns))
	if(!do_teleport(invoker, T, channel = TELEPORT_CHANNEL_CULT, forced = TRUE))
		return
	invoker.visible_message("<span class='warning'>[invoker] flickers and phases out of existence!</span>", \
	"<span class='bold sevtug_small'>You feel a dizzying sense of vertigo as you're yanked through the fabric of reality!</span>")
	T.visible_message("<span class='warning'>[invoker] flickers and phases into existence!</span>")
	playsound(invoker, 'sound/magic/magic_missile.ogg', 50, TRUE)
	playsound(T, 'sound/magic/magic_missile.ogg', 50, TRUE)
	do_sparks(5, TRUE, invoker)
	do_sparks(5, TRUE, T)
	if(invoker.client)
		animate(invoker.client, color = client_color, time = 25)

/datum/clockwork_scripture/abscond/scripture_fail()
	if(invoker && invoker.client)
		animate(invoker.client, color = client_color, time = 10)


//Replicant: Creates a new clockwork slab.
/datum/clockwork_scripture/create_object/replicant
	descname = "New Clockwork Slab"
	name = "Replicant"
	desc = "Creates a new clockwork slab."
	invocations = list("Metal, become greater!")
	channel_time = 10
	power_cost = 25
	whispered = TRUE
	object_path = /obj/item/clockwork/slab
	creator_message = "<span class='brass'>You copy a piece of replicant alloy and command it into a new slab.</span>"
	usage_tip = "This is inefficient as a way to produce components, as the slab produced must be held by someone with no other slabs to produce components."
	tier = SCRIPTURE_DRIVER
	space_allowed = TRUE
	primary_component = GEIS_CAPACITOR
	sort_priority = 10
	important = TRUE
	quickbind = TRUE
	quickbind_desc = "Creates a new Clockwork Slab."


//Wraith Spectacles: Creates a pair of wraith spectacles, which grant xray vision but damage vision slowly.
/datum/clockwork_scripture/create_object/wraith_spectacles
	descname = "Limited Xray Vision Glasses"
	name = "Wraith Spectacles"
	desc = "Fabricates a pair of glasses which grant true sight but cause gradual vision loss."
	invocations = list("Show the truth of this world to me!")
	channel_time = 10
	power_cost = 50
	whispered = TRUE
	object_path = /obj/item/clothing/glasses/wraith_spectacles
	creator_message = "<span class='brass'>You form a pair of wraith spectacles, which grant true sight but cause gradual vision loss.</span>"
	usage_tip = "\"True sight\" means that you are able to see through walls and in darkness."
	tier = SCRIPTURE_DRIVER
	space_allowed = TRUE
	primary_component = GEIS_CAPACITOR
	sort_priority = 11
	quickbind = TRUE
	quickbind_desc = "Creates a pair of Wraith Spectacles, which grant true sight but cause gradual vision loss."

//Spatial Gateway: Allows the invoker to teleport themselves and any nearby allies to a conscious servant or clockwork obelisk.
/datum/clockwork_scripture/spatial_gateway
	descname = "Teleport Gate"
	name = "Spatial Gateway"
	desc = "Tears open a miniaturized gateway in spacetime to any conscious servant that can transport objects or creatures to its destination. \
	Each servant assisting in the invocation adds one additional use and four additional seconds to the gateway's uses and duration."
	invocations = list("Spatial Gateway...", "...activate!")
	channel_time = 80
	power_cost = 400
	multiple_invokers_used = TRUE
	multiple_invokers_optional = TRUE
	usage_tip = "This gateway is strictly one-way and will only allow things through the invoker's portal."
	tier = SCRIPTURE_DRIVER
	primary_component = GEIS_CAPACITOR
	sort_priority = 9
	quickbind = TRUE
	quickbind_desc = "Allows you to create a one-way Spatial Gateway to a living Servant or Clockwork Obelisk."

/datum/clockwork_scripture/spatial_gateway/check_special_requirements()
	if(!isturf(invoker.loc))
		to_chat(invoker, "<span class='warning'>You must not be inside an object to use this scripture!</span>")
		return FALSE
	var/other_servants = 0
	for(var/mob/living/L in GLOB.alive_mob_list)
		if(is_servant_of_ratvar(L) && !L.stat && L != invoker)
			other_servants++
	for(var/obj/structure/destructible/clockwork/powered/clockwork_obelisk/O in GLOB.all_clockwork_objects)
		if(O.anchored)
			other_servants++
	if(!other_servants)
		to_chat(invoker, "<span class='warning'>There are no other conscious servants or anchored clockwork obelisks!</span>")
		return FALSE
	return TRUE

/datum/clockwork_scripture/spatial_gateway/scripture_effects()
	var/portal_uses = 0
	var/duration = 0
	for(var/mob/living/L in range(1, invoker))
		if(!L.stat && is_servant_of_ratvar(L))
			portal_uses++
			duration += 40 //4 seconds
	if(GLOB.ratvar_awakens)
		portal_uses = max(portal_uses, 100) //Very powerful if Ratvar has been summoned
		duration = max(duration, 100)
	return slab.procure_gateway(invoker, duration, portal_uses)

/*
//Tinkerer's Cache: Creates a tinkerer's cache, allowing global component storage.
/datum/clockwork_scripture/create_object/tinkerers_cache
	descname = "Necessary Structure, Shares Components"
	name = "Tinkerer's Cache"
	desc = "Forms a cache that can store an infinite amount of components. All caches are linked and will provide components to slabs. \
	Striking a cache with a slab will transfer that slab's components to the global cache."
	invocations = list("Constructing...", "...a cache!")
	channel_time = 50
	consumed_components = list(BELLIGERENT_EYE = 0, VANGUARD_COGWHEEL = 0, GEIS_CAPACITOR = 0, REPLICANT_ALLOY = 1, HIEROPHANT_ANSIBLE = 0)
	object_path = /obj/structure/destructible/clockwork/cache
	creator_message = "<span class='brass'>You form a tinkerer's cache, which is capable of storing components, which will automatically be used by slabs.</span>"
	observer_message = "<span class='warning'>A hollow brass spire rises and begins to blaze!</span>"
	usage_tip = "Slabs will draw components from the global cache after the slab's own repositories, making caches extremely useful."
	tier = SCRIPTURE_DRIVER
	one_per_tile = TRUE
	primary_component = REPLICANT_ALLOY
	sort_priority = 8
	quickbind = TRUE
	quickbind_desc = "Creates a Tinkerer's Cache, which stores components globally for slab access."
	var/static/prev_cost = 0
	*/
