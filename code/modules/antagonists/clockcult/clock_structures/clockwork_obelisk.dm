//Clockwork Obelisk: Can broadcast a message at a small power cost or outright open a spatial gateway at a massive power cost.
/obj/structure/destructible/clockwork/powered/clockwork_obelisk
	name = "clockwork obelisk"
	desc = "A large brass obelisk hanging in midair."
	clockwork_desc = "A powerful obelisk that can send a message to all servants or open a gateway to a target servant or clockwork obelisk."
	icon_state = "obelisk_inactive"
	active_icon = "obelisk"
	inactive_icon = "obelisk_inactive"
	unanchored_icon = "obelisk_unwrenched"
	construction_value = 20
	max_integrity = 150
	break_message = "<span class='warning'>The obelisk falls to the ground, undamaged!</span>"
	debris = list(/obj/item/clockwork/alloy_shards/small = 4, \
	/obj/item/clockwork/alloy_shards/medium = 2, \
	/obj/item/clockwork/component/hierophant_ansible/obelisk = 1)
	var/hierophant_cost = MIN_CLOCKCULT_POWER //how much it costs to broadcast with large text
	var/gateway_cost = 2000 //how much it costs to open a gateway

/obj/structure/destructible/clockwork/powered/clockwork_obelisk/Initialize()
	. = ..()
	toggle(1)

/obj/structure/destructible/clockwork/powered/clockwork_obelisk/examine(mob/user)
	. = ..()
	if(is_servant_of_ratvar(user) || isobserver(user))
		. += "<span class='nzcrentr_small'>It requires <b>[DisplayPower(hierophant_cost)]</b> to broadcast over the Hierophant Network, and <b>[DisplayPower(gateway_cost)]</b> to open a Spatial Gateway.</span>"

/obj/structure/destructible/clockwork/powered/clockwork_obelisk/can_be_unfasten_wrench(mob/user, silent)
	if(active)
		if(!silent)
			to_chat(user, "<span class='warning'>[src] is currently sustaining a gateway!</span>")
		return FAILED_UNFASTEN
	return ..()

/obj/structure/destructible/clockwork/powered/clockwork_obelisk/forced_disable(bad_effects)
	var/affected = 0
	for(var/obj/effect/clockwork/spatial_gateway/SG in loc)
		SG.ex_act(EXPLODE_DEVASTATE)
		affected++
	if(bad_effects)
		affected += try_use_power(MIN_CLOCKCULT_POWER*4)
	return affected

/obj/structure/destructible/clockwork/powered/clockwork_obelisk/Destroy()
	for(var/obj/effect/clockwork/spatial_gateway/SG in loc)
		SG.ex_act(EXPLODE_DEVASTATE)
	return ..()

/obj/structure/destructible/clockwork/powered/clockwork_obelisk/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!is_servant_of_ratvar(user) || !can_access_clockwork_power(src, hierophant_cost) || !anchored)
		to_chat(user, "<span class='warning'>You place your hand on [src], but it doesn't react.</span>")
		return
	var/choice = alert(user,"You place your hand on [src]...",,/*"Hierophant Broadcast",*/"Spatial Gateway","Stable Reebe Gateway","Cancel") //TODO: Find a good way to do this because choice / alert does only support up to six args, not seven as needed
	switch(choice)
		if("Hierophant Broadcast")
			if(active)
				to_chat(user, "<span class='warning'>[src] is sustaining a gateway and cannot broadcast!</span>")
				return
			if(!user.can_speak_vocal())
				to_chat(user, "<span class='warning'>You cannot speak through [src]!</span>")
				return
			var/input = stripped_input(usr, "Please choose a message to send over the Hierophant Network.", "Hierophant Broadcast", "")
			if(!is_servant_of_ratvar(user) || !input || !user.canUseTopic(src, !issilicon(user)))
				return
			if(!anchored)
				to_chat(user, "<span class='warning'>[src] is no longer secured!</span>")
				return FALSE
			if(active)
				to_chat(user, "<span class='warning'>[src] is sustaining a gateway and cannot broadcast!</span>")
				return
			if(!user.can_speak_vocal())
				to_chat(user, "<span class='warning'>You cannot speak through [src]!</span>")
				return
			if(!try_use_power(hierophant_cost))
				to_chat(user, "<span class='warning'>[src] lacks the power to broadcast!</span>")
				return
			clockwork_say(user, text2ratvar("Hierophant Broadcast, activate! [html_decode(input)]"))
			titled_hierophant_message(user, input, "big_brass", "large_brass")
		if("Spatial Gateway")
			if(active)
				to_chat(user, "<span class='warning'>[src] is already sustaining a gateway!</span>")
				return
			if(!user.can_speak_vocal())
				to_chat(user, "<span class='warning'>You need to be able to speak to open a gateway!</span>")
				return
			if(!try_use_power(gateway_cost))
				to_chat(user, "<span class='warning'>[src] lacks the power to open a gateway!</span>")
				return
			if(procure_gateway(user, round(100 * get_efficiency_mod(), 1), round(5 * get_efficiency_mod(), 1), 1))
				process()
				if(!active) //we won't be active if nobody has sent a gateway to us
					active = TRUE
					clockwork_say(user, text2ratvar("Spatial Gateway, activate!"))
					return
			adjust_clockwork_power(gateway_cost) //if we didn't return above, ie, successfully create a gateway, we give the power back
		if("Stable Reebe Gateway")
			if(active)
				to_chat(user, "<span class='warning'>[src] is already sustaining a gateway!</span>")
				return
			if(!user.can_speak_vocal())
				to_chat(user, "<span class='warning'>You need to be able to speak to open a stable gateway!</span>")
				return
			if(is_reebe(z))
				to_chat(user, "<span class='brass'>You are already on reebe, child...</span>")
				return
			if(!try_use_power(gateway_cost)) //Maybe set it a bit higher than a normal portal? Eh should be fine, balance will tell..
				to_chat(user, "<span class='warning'>[src] lacks the power to open a stable gateway!</span>")
				return
			if(procure_reebe_gateway(user))
				process()
				if(!active)
					active = TRUE
					clockwork_say(user, text2ratvar("Stable Gateway, activate!"))
					return
			adjust_clockwork_power(gateway_cost) //Same as before

/obj/structure/destructible/clockwork/powered/clockwork_obelisk/process()
	if(!anchored)
		return
	var/obj/effect/clockwork/spatial_gateway/SG = locate(/obj/effect/clockwork/spatial_gateway) in loc
	if(SG && (SG.timerid || SG.is_stable)) //it's a valid gateway, we're active
		icon_state = active_icon
		density = FALSE
		active = TRUE
	else
		icon_state = inactive_icon
		density = TRUE
		active = FALSE

//Special proc used for station-reebe stable gateways created by Obilisks on the station. Not done as subtype of the proc because it's quite a bit different.\
  Chooses one random non-active obilisk on reebe to link to.
/obj/structure/destructible/clockwork/powered/clockwork_obelisk/proc/procure_reebe_gateway(mob/living/user)
	var/list/possible_reebe_obilisks = list()
	for(var/obj/structure/destructible/clockwork/powered/clockwork_obelisk/O in GLOB.all_clockwork_objects)
		if(is_reebe(O.z) && !O.active && O.anchored)
			possible_reebe_obilisks += O

	if(!possible_reebe_obilisks.len)
		to_chat(user, "<span class='warning'>There are no eligible Obilisks on reebe!</span>")
		return FALSE
	var/obj/structure/destructible/clockwork/powered/clockwork_obelisk/target = pick(possible_reebe_obilisks)

	target.active = TRUE
	src.active = TRUE
	user.visible_message("<span class='warning'>The air in front of [user] ripples before suddenly tearing open!</span>", \
	"<span class='brass'>With a word, you open a stable rift between reebe and the mortal realm.</span>")
	var/obj/effect/clockwork/spatial_gateway/stable/S1 = new(get_turf(src))
	var/obj/effect/clockwork/spatial_gateway/stable/S2 = new(get_turf(target))
	S1.setup_gateway(S2, 1, 1, TRUE) //The two 1s are irrelevant since it's a stable gateway
	S2.visible_message("<span class='warning'>The air in front of [target] ripples before suddenly tearing open!</span>")
	return TRUE
