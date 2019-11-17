/datum/component/souldeath
	var/mob/living/wearer
	var/equip_slot
	var/signal = FALSE

/datum/component/souldeath/Initialize()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, .proc/equip)
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, .proc/unequip)

/datum/component/souldeath/proc/equip(datum/source, mob/living/equipper, slot)
	if(!slot || equip_slot == slot)
		wearer = equipper
		RegisterSignal(wearer, COMSIG_MOB_DEATH, .proc/die, TRUE)
		signal = TRUE
	else
		if(signal)
			UnregisterSignal(wearer, COMSIG_MOB_DEATH)
			signal = FALSE
		return

/datum/component/souldeath/proc/unequip()
	UnregisterSignal(wearer, COMSIG_MOB_DEATH)
	wearer = null
	signal = FALSE

/datum/component/souldeath/proc/die()
	if(!wearer)
		return //idfk
	new/obj/effect/temp_visual/souldeath(wearer.loc, wearer)
	playsound(wearer, 'sound/misc/souldeath.ogg', 100, FALSE)

/datum/component/souldeath/neck
	equip_slot = SLOT_NECK
