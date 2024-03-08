/datum/component/shielded
	dupe_mode = COMPONENT_DUPE_ALLOWED
	can_transfer = TRUE
	var/charges = 3
	var/max_charges = 3
	var/recharge_delay = 20 SECONDS  //How long after we've been attacked before we can start recharging.
	var/recharge_rate = 1 //How quickly the shield recharges once it starts charging. Can be a decimal. set to zero to disable.
	var/last_time_used //Last time the shield attempted to stop an attack.
	var/accepted_slots
	var/shield_state = "shield-old" //the state of the shield overlay.
	var/broken_state //null by default.
	var/recharge_sound = 'sound/magic/charge.ogg'
	var/recharge_end_sound = 'sound/machines/ding.ogg'
	var/mob/living/holder //who is currently benefiting from the shield.
	var/dissipating = FALSE //Is this shield meant to dissipate over time instead of recharging.
	var/del_on_overload = FALSE //will delete itself once it has no charges left.
	var/cached_vis_overlay //text identifier of the visual overlay.

/datum/component/shielded/Initialize(current, max = 3, delay = 20 SECONDS, rate = 1, slots, state = "shield-old", broken, \
									sound = 'sound/magic/charge.ogg', end_sound = 'sound/machines/ding.ogg', diss = FALSE, del_overload = FALSE)
	var/isitem = isitem(parent)
	if(!isitem && !isliving(parent))
		return COMPONENT_INCOMPATIBLE
	max_charges = max
	charges = !isnull(current) ? current : max_charges
	recharge_delay = delay
	recharge_rate = rate
	accepted_slots = slots
	shield_state = state
	broken_state = broken
	recharge_sound = sound
	recharge_end_sound = end_sound
	dissipating = diss
	del_on_overload = del_overload
	if(dissipating && recharge_rate > 0)
		recharge_rate = -recharge_rate
	if(recharge_delay && recharge_rate && (charges < max_charges || dissipating))
		START_PROCESSING(SSdcs, src)

/datum/component/shielded/RegisterWithParent()
	. = ..()
	if(isitem(parent))
		RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
		RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))
	else //it's a mob
		var/mob/living/L = parent
		RegisterSignal(L, COMSIG_LIVING_RUN_BLOCK, PROC_REF(living_block))
		holder = L
		var/to_add = charges >= 1 ? shield_state : broken_state
		if(to_add)
			var/layer = (L.layer > MOB_LAYER ? L.layer : MOB_LAYER) + 0.01
			SSvis_overlays.add_vis_overlay(L, 'icons/effects/effects.dmi', to_add, layer, GAME_PLANE, L.dir)

/datum/component/shielded/UnregisterFromParent()
	. = ..()
	if(parent != holder) //not a mob, thus an item.
		UnregisterSignal(parent, list(COMSIG_ITEM_RUN_BLOCK,COMSIG_ITEM_CHECK_BLOCK,COMSIG_ITEM_EQUIPPED,COMSIG_ITEM_DROPPED))
	if(holder)
		UnregisterSignal(holder, list(COMSIG_LIVING_RUN_BLOCK, COMSIG_LIVING_GET_BLOCKING_ITEMS))
		if(cached_vis_overlay)
			SSvis_overlays.remove_vis_overlay(holder, cached_vis_overlay)
			cached_vis_overlay = null
		holder = null

/datum/component/shielded/process()
	if(world.time < last_time_used && !dissipating)
		return
	var/old_charges = charges
	charges = clamp(charges + recharge_rate, 0, max_charges)
	if(round(old_charges) >= round(charges)) //only send outputs if it effectively gained at least one charge
		return
	var/sound = recharge_sound
	if(dissipating ? !charges : charges == max_charges )
		STOP_PROCESSING(SSdcs, src)
		sound = recharge_end_sound
	if(parent && sound)
		playsound(parent, sound, 50, 1)
	if(charges < 1 && del_on_overload)
		if(holder)
			holder.visible_message("[holder]'s shield overloads!")
		qdel(src)
		return
	if(holder && ((old_charges < 1 && charges >= 1) || (!del_on_overload && old_charges >= 1 && charges < 1)))
		update_shield_overlay(charges < 1)

/datum/component/shielded/proc/adjust_charges(amount)
	var/old_charges = charges
	charges = clamp(charges + amount, 0, max_charges)
	if(recharge_delay && recharge_rate && (dissipating ? !charges : charges == max_charges))
		STOP_PROCESSING(SSdcs, src)
	if(charges < 1 && del_on_overload)
		if(holder)
			holder.visible_message("[holder]'s shield overloads!")
		qdel(src)
		return
	if(holder && ((old_charges < 1 && charges >= 1) || (!del_on_overload && old_charges >= 1 && charges < 1)))
		update_shield_overlay(charges < 1)

/datum/component/shielded/proc/update_shield_overlay(broken)
	if(!holder)
		return
	var/to_add = broken ? broken_state : shield_state
	if(cached_vis_overlay)
		SSvis_overlays.remove_vis_overlay(holder, cached_vis_overlay)
		cached_vis_overlay = null
	if(to_add)
		var/layer = (holder.layer > MOB_LAYER ? holder.layer : MOB_LAYER) + 0.01
		SSvis_overlays.add_vis_overlay(holder, 'icons/effects/effects.dmi', to_add, layer, GAME_PLANE, holder.dir)

/datum/component/shielded/proc/on_equip(obj/item/source, mob/living/equipper, slot)
	if(!(accepted_slots & slot))
		return
	holder = equipper
	RegisterSignal(parent, COMSIG_ITEM_RUN_BLOCK, PROC_REF(on_run_block))
	RegisterSignal(parent, COMSIG_ITEM_CHECK_BLOCK, PROC_REF(on_check_block))
	RegisterSignal(equipper, COMSIG_LIVING_GET_BLOCKING_ITEMS, PROC_REF(include_shield))
	var/to_add = charges >= 1 ? shield_state : broken_state
	if(to_add)
		var/layer = (holder.layer > MOB_LAYER ? holder.layer : MOB_LAYER) + 0.01
		cached_vis_overlay = SSvis_overlays.add_vis_overlay(holder, 'icons/effects/effects.dmi', to_add, layer, GAME_PLANE, holder.dir)

/datum/component/shielded/proc/on_drop(obj/item/source, mob/dropper)
	if(holder == dropper)
		UnregisterSignal(holder, COMSIG_LIVING_GET_BLOCKING_ITEMS)
		UnregisterSignal(parent, list(COMSIG_ITEM_RUN_BLOCK, COMSIG_ITEM_CHECK_BLOCK))
		if(cached_vis_overlay)
			SSvis_overlays.remove_vis_overlay(holder, cached_vis_overlay)
			cached_vis_overlay = null
		holder = null

/datum/component/shielded/proc/include_shield(mob/source, list/items)
	items += parent

/datum/component/shielded/proc/on_run_block(obj/item/source, mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(block_return[BLOCK_RETURN_NORMAL_BLOCK_CHANCE] >= 100) //already blocked by another shielded item, don't do anything.
		block_return[BLOCK_RETURN_BLOCK_CAPACITY] += round(charges)
		return BLOCK_NONE
	last_time_used = world.time + recharge_delay
	if(charges < 1)
		return BLOCK_NONE
	var/datum/effect_system/spark_spread/s = new
	s.set_up(2, 1, source)
	s.start()
	owner.visible_message("<span class='danger'>[holder]'s shields deflect [attack_text] in a shower of sparks!</span>")
	charges--
	var/rounded_charges = round(charges)
	if(recharge_delay && recharge_rate && !dissipating)
		START_PROCESSING(SSdcs, src)
	if(charges < 1)
		owner.visible_message("[holder]'s shield overloads!")
		if(del_on_overload)
			qdel(src)
		else
			update_shield_overlay(TRUE)
	block_return[BLOCK_RETURN_NORMAL_BLOCK_CHANCE] = 100
	block_return[BLOCK_RETURN_BLOCK_CAPACITY] += rounded_charges
	return BLOCK_SUCCESS | BLOCK_PHYSICAL_EXTERNAL

/datum/component/shielded/proc/on_check_block(obj/item/source, mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(charges >= 1)
		block_return[BLOCK_RETURN_NORMAL_BLOCK_CHANCE] = 100
		block_return[BLOCK_RETURN_BLOCK_CAPACITY] += round(charges)

/datum/component/shielded/proc/living_block(mob/living/source, real_attack, object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list)
	if(!real_attack)
		if(charges >= 1)
			return_list[BLOCK_RETURN_NORMAL_BLOCK_CHANCE] = 100
			return_list[BLOCK_RETURN_BLOCK_CAPACITY] = round(charges)
		return
	last_time_used = world.time + recharge_delay
	if(charges < 1)
		return BLOCK_NONE
	var/datum/effect_system/spark_spread/s = new
	s.set_up(2, 1, source)
	s.start()
	source.visible_message("<span class='danger'>[source]'s shields deflect [attack_text] in a shower of sparks!</span>")
	charges--
	var/rounded_charges = round(charges)
	if(recharge_delay && recharge_rate && !dissipating)
		START_PROCESSING(SSdcs, src)
	if(charges < 1)
		source.visible_message("[source]'s shield overloads!")
		if(del_on_overload)
			qdel(src)
		else
			update_shield_overlay(TRUE)
	return_list[BLOCK_RETURN_NORMAL_BLOCK_CHANCE] = 100
	return_list[BLOCK_RETURN_BLOCK_CAPACITY] += rounded_charges
	return BLOCK_SUCCESS | BLOCK_PHYSICAL_EXTERNAL
