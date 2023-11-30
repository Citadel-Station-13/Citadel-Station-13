/datum/component/acid
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/level = 0

/datum/component/acid/Initialize(acidpwr, acid_volume)
	if(!isobj(parent))
		return COMPONENT_INCOMPATIBLE
	var/obj/O = parent
	var/acid_cap = acidpwr * 300
	level = min(acidpwr * acid_volume, acid_cap)
	START_PROCESSING(SSprocessing, src)
	RegisterSignal(parent, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(add_acid_overlay))
	if(isitem(parent))
		RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_attack_hand))
	O.update_icon()

/datum/component/acid/proc/on_attack_hand(datum/source, mob/user)
	var/obj/item/I = parent
	if(istype(I) && level > 20 && !ismob(I.loc))// so we can still remove the clothes on us that have acid.
		var/mob/living/carbon/C = user
		if(istype(C))
			if(!C.gloves || (!(C.gloves.resistance_flags & (UNACIDABLE|ACID_PROOF))))
				to_chat(user, "<span class='warning'>The acid on [I] burns your hand!</span>")
				var/obj/item/bodypart/affecting = C.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
				if(affecting && affecting.receive_damage( 0, 5 ))		// 5 burn damage
					C.update_damage_overlays()

/datum/component/acid/InheritComponent(datum/component/C, i_am_original, acidpwr, acid_volume)
	if(!i_am_original)
		return
	var/acid_cap = acidpwr * 300
	if(level < acid_cap)
		if(C)
			var/datum/component/acid/other = C
			level = min(level + other.level, acid_cap)
		else
			level = min(level + acidpwr * acid_volume, acid_cap)

/datum/component/acid/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	level = 0
	if(parent) // So, this is how you get runtimes fellas.
		UnregisterSignal(parent, list(COMSIG_ATOM_UPDATE_OVERLAYS, COMSIG_ATOM_ATTACK_HAND)) // Don't worry about isitem checks, we don't need them.
		var/atom/O = parent
		O.update_icon(UPDATE_OVERLAYS)
	return ..()

/datum/component/acid/process()
	var/obj/O = parent
	if(!istype(O))
		qdel(src)
		return PROCESS_KILL
	if(!(O.resistance_flags & ACID_PROOF))
		if(prob(33))
			playsound(O.loc, 'sound/items/welder.ogg', 150, 1)
		O.take_damage(min(1 + round(sqrt(level)*0.3), 300), BURN, ACID, 0)

	level = max(level - (5 + 3*round(sqrt(level))), 0)
	if(level <= 0)
		qdel(src)
		return PROCESS_KILL
	else
		O.update_icon()
		return TRUE

/datum/component/acid/proc/add_acid_overlay(atom/source, list/overlay_list)
	overlay_list += GLOB.acid_overlay
