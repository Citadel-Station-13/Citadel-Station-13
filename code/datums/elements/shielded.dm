/datum/element/shielded
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 3
	var/max_charges = 3
	var/recharge_delay = 20 SECONDS //How long after we've been shot before we can start recharging.
	var/recharge_rate = 1 //How quickly the shield recharges once it starts charging. Can be a decimal. set to zero to disable.
	var/accepted_slots
	var/shield_state = "shield-old" //the state of the shield overlay.
	var/broken_state //null
	var/recharge_sound = 'sound/magic/charge.ogg'
	var/recharge_end_sound = 'sound/machines/ding.ogg'
	var/list/charges_per_atom = list() //How many charges each atom has.
	var/list/last_use_per_atom = list() //Last time an atom has deflected (or failed due to no charges) an attack.
	var/list/overlay_per_mob = list() //List of mutable overlays per atom.
	var/list/shields_per_mob = list() //number of shields this guy is on, damn.

/datum/element/shielded/Attach(datum/target, current, _max = 3, _delay = 20 SECONDS, _rate = 1, _slots, _state = "shield-old", _broken, _sound = 'sound/magic/charge.ogg', _end_sound = 'sound/machines/ding.ogg')
	. = ..()
	var/isitem = isitem(target)
	if(. == ELEMENT_INCOMPATIBLE || (!isitem && !isliving(target)))
		return ELEMENT_INCOMPATIBLE
	max_charges = _max
	recharge_delay = _delay
	recharge_rate = _rate
	accepted_slots = _slots
	shield_state = _state
	broken_state = _broken
	recharge_sound = 'sound/magic/charge.ogg'
	recharge_end_sound = 'sound/machines/ding.ogg'
	if(isitem)
		RegisterSignal(target, COMSIG_ITEM_RUN_BLOCK, .proc/on_run_block)
		RegisterSignal(target, COMSIG_ITEM_CHECK_BLOCK, .proc/on_check_block)
		RegisterSignal(target, COMSIG_ITEM_EQUIPPED, .proc/on_equip)
		RegisterSignal(target, COMSIG_ITEM_DROPPED, .proc/on_drop)
	else
		RegisterSignal(target, COMSIG_LIVING_RUN_BLOCK, .proc/living_block)
		var/prior_shields = shields_per_mob[target]
		if(prior_shields)
			if(!islist(prior_shields))
				shields_per_mob[target] = list(prior_shields, target)
			else
				prior_shields += target
		else
			var/mob/living/L = target
			var/mutable_appearance/M = mutable_appearance('icons/effects/effects.dmi', shield_state, MOB_LAYER + 0.01)
			overlay_per_mob[L] = M
			L.add_overlay(M, TRUE)
			shields_per_mob[L] = L
	charges_per_atom[target] = !isnull(current) ? current : max_charges
	last_use_per_atom[target] = 0
	if(recharge_delay)
		START_PROCESSING(SSdcs, src)

/datum/element/shielded/Detach(atom/target)
	var/mob/living/L
	if(isitem(target))
		UnregisterSignal(target, list(COMSIG_ITEM_RUN_BLOCK,COMSIG_ITEM_CHECK_BLOCK,COMSIG_ITEM_EQUIPPED,COMSIG_ITEM_DROPPED))
		L = isliving(target.loc) ? target.loc : null
	else
		UnregisterSignal(target, COMSIG_LIVING_RUN_BLOCK)
		L = src
	if(L)
		var/list/shields = shields_per_mob[L]
		if(!shields)
			return ..()
		if(shields == target) //nothing left.
			shields_per_mob -= L
			var/mutable_appearance/M = overlay_per_mob[L]
			L.cut_overlay(M, TRUE)
			overlay_per_mob -= L
			UnregisterSignal(target, COMSIG_LIVING_GET_BLOCKING_ITEMS)
		else //more layers of shielding.
			shields -= target
			if(length(shields) == 1)
				shields_per_mob[L] = shields[1]
	charges_per_atom -= target
	last_use_per_atom -= target
	if(recharge_delay && !length(charges_per_atom)) //nothing left to process.
		STOP_PROCESSING(SSdcs, src)
	return ..()

/datum/element/shielded/process()
	var/list/checked = list()
	for(var/i in last_use_per_atom)
		var/atom/movable/A = i
		recharge(A, recharge_rate, checked)

/datum/element/shielded/proc/recharge(atom/movable/A, amount, list/checked = list(), forced = FALSE)
	var/old_charges = charges_per_atom[A]
	if(old_charges >= max_charges || (!forced && world.time < last_use_per_atom[A]))
		return
	var/new_charges = CLAMP(old_charges + recharge_rate, 0, max_charges)
	charges_per_atom[A] = new_charges
	if(round(old_charges) >= round(new_charges)) //only send outputs if it effectively gained at least one charge
		return
	var/mob/living/L
	var/skip_in = FALSE
	if(isitem(A))
		L = isliving(A.loc) ? A.loc : null
	else
		L = A
		skip_in = TRUE
	if(L && checked[L])
		return
	playsound(A, recharge_sound, 50, 1)
	if(new_charges == max_charges)
		playsound(A, recharge_sound, 50, 1)
	if(L && (skip_in || (A in shields_per_mob[L])))
		var/mutable_appearance/M = overlay_per_mob[L]
		M.icon_state = shield_state
		checked[L] = TRUE

/datum/element/shielded/proc/on_equip(obj/item/source, mob/equipper, slot)
	if(!(accepted_slots & slotdefine2slotbit(slot)))
		return
	var/list/shields = shields_per_mob[equipper]
	if(!shields) //They have none
		RegisterSignal(equipper, COMSIG_LIVING_GET_BLOCKING_ITEMS, .proc/get_shields)
		shields_per_mob[equipper] = source
		var/mutable_appearance/M = mutable_appearance('icons/effects/effects.dmi', charges_per_atom[source] ? shield_state : broken_state, MOB_LAYER + 0.01)
		overlay_per_mob[equipper] = M
		equipper.add_overlay(M, TRUE)
	else if(!islist(shields)) //They have one
		if(shields == equipper)
			RegisterSignal(equipper, COMSIG_LIVING_GET_BLOCKING_ITEMS, .proc/get_shields)
		shields_per_mob[equipper] = list(shields, source)
	else //They have more.
		shields += source

/datum/element/shielded/proc/on_drop(obj/item/source, mob/dropper)
	var/list/shields = shields_per_mob[dropper]
	if(!shields)
		return
	if(shields == source)
		UnregisterSignal(dropper, COMSIG_LIVING_GET_BLOCKING_ITEMS)
		var/mutable_appearance/M = overlay_per_mob[dropper]
		dropper.cut_overlay(M, TRUE)
		overlay_per_mob -= dropper
		shields_per_mob -= dropper
	else
		shields -= source
		if(length(shields) == 1)
			shields_per_mob[dropper] = shields[1]

/datum/element/shielded/proc/get_shields(mob/source, list/items)
	items += shields_per_mob[source]

/datum/element/shielded/proc/on_run_block(obj/item/source, mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(block_return[BLOCK_RETURN_NORMAL_BLOCK_CHANCE] >= 100) //already blocked by another shielded item, don't do anything.
		block_return[BLOCK_RETURN_BLOCK_CAPACITY] += round(charges_per_atom[source])
		return BLOCK_NONE
	last_use_per_atom[source] = world.time + recharge_delay
	if(charges_per_atom[source] < 1)
		return BLOCK_NONE
	var/datum/effect_system/spark_spread/s = new
	s.set_up(2, 1, source)
	s.start()
	owner.visible_message("<span class='danger'>[owner]'s shields deflect [attack_text] in a shower of sparks!</span>")
	var/charges_left = --charges_per_atom[source]
	if(charges_left < 1)
		var/list/shields = shields_per_mob[owner]
		var/vis_change = TRUE
		if(istype(shields))
			for(var/A in shields)
				if(charges_per_atom >= 1)
					vis_change = FALSE
					break
		owner.visible_message("[owner]'s shield overloads!")
		if(vis_change)
			var/mutable_appearance/M = overlay_per_mob[owner]
			M.icon_state = broken_state
	block_return[BLOCK_RETURN_NORMAL_BLOCK_CHANCE] = 100
	block_return[BLOCK_RETURN_BLOCK_CAPACITY] += charges_left
	return BLOCK_SUCCESS | BLOCK_PHYSICAL_EXTERNAL //it's an energy field surrounding you after all.

/datum/element/shielded/proc/on_check_block(obj/item/source, mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(charges_per_atom[source] < 1)
		return
	block_return[BLOCK_RETURN_NORMAL_BLOCK_CHANCE] = 100
	block_return[BLOCK_RETURN_BLOCK_CAPACITY] += round(charges_per_atom[source])

/datum/element/shielded/proc/living_block(mob/living/source, real_attack, object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list)
	if(!real_attack)
		if(charges_per_atom[source] >= 1)
			return_list[BLOCK_RETURN_NORMAL_BLOCK_CHANCE] = 100
			return_list[BLOCK_RETURN_BLOCK_CAPACITY] = round(charges_per_atom[source])
		return
	last_use_per_atom[source] = world.time + recharge_delay
	if(charges_per_atom[source] < 1)
		return BLOCK_NONE
	var/datum/effect_system/spark_spread/s = new
	s.set_up(2, 1, source)
	s.start()
	source.visible_message("<span class='danger'>[source]'s shields deflect [attack_text] in a shower of sparks!</span>")
	var/charges_left = --charges_per_atom[source]
	if(charges_left < 1)
		var/list/shields = shields_per_mob[source]
		var/vis_change = TRUE
		if(istype(shields))
			for(var/A in shields)
				if(charges_per_atom >= 1)
					vis_change = FALSE
					break
		source.visible_message("[source]'s shield overloads!")
		if(vis_change)
			var/mutable_appearance/M = overlay_per_mob[source]
			M.icon_state = broken_state
	return_list[BLOCK_RETURN_NORMAL_BLOCK_CHANCE] = 100
	return_list[BLOCK_RETURN_BLOCK_CAPACITY] += charges_left
	return BLOCK_SUCCESS | BLOCK_PHYSICAL_EXTERNAL
