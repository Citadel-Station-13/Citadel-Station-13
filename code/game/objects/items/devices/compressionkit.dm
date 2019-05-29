/obj/item/compressionkit
	name = "bluespace compression kit"
	desc = "An illegally modified BSRPED, capable of reducing the size of most items."
	icon = 'icons/obj/device.dmi'
	icon_state = "compression" // aicard-full
	item_state = "RPED"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	var/charges = 5

/obj/item/compressionkit/suicide_act(mob/living/carbon/M)
	M.visible_message("<span class='suicide'>[M] is sticking their head in [src] and turning it on! [M.p_theyre(TRUE)] going to compress their own skull!</span>")
	var/obj/item/bodypart/head = M.get_bodypart("head")
	if(!head)
		return
	var/turf/T = get_turf(M)
	var/list/organs = M.getorganszone("head") + M.getorganszone("eyes") + M.getorganszone("mouth")
	for(var/internal_organ in organs)
		var/obj/item/organ/I = internal_organ
		I.Remove(M)
		I.forceMove(T)
	head.drop_limb()
	qdel(head)
	new M.gib_type(T,1,M.get_static_viruses())
	M.add_splatter_floor(T)
	playsound(M, 'sound/weapons/flash.ogg', 100, 1, -6)
	playsound(M, 'sound/effects/splat.ogg', 50, 1)

	return OXYLOSS

/obj/item/compressionkit/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity || !target)
		return
	if(istype(target, /obj/item))
		var/obj/item/O = target
		if(charges == 0)
			playsound(get_turf(src), 'sound/machines/buzz-two.ogg', 100, 1, -6)
			to_chat(user, "<span class='notice'>The bluespace compression kit is out of charges! Recharge it with bluespace crystals.</span>")
			return
		if(O.w_class == 1)
			playsound(get_turf(src), 'sound/machines/buzz-two.ogg', 100, 1, -6)
			to_chat(user, "<span class='notice'>[target] cannot be compressed smaller!.</span>")
			return
		if(O.GetComponent(/datum/component/storage))
			to_chat(user, "<span class='notice'>You feel like compressing an item that stores other items would be counterproductive.</span>")
			return
		if(O.w_class > 1)
			O.w_class -= 1
			playsound(get_turf(src), 'sound/weapons/flash.ogg', 100, 1, -6)
			to_chat(user, "<span class='notice'>You successfully compress [target]!</span>")
			charges -= 1
		else
			to_chat(user, "<span class='notice'>Anomalous error. Summon a coder.</span>")

/obj/item/compressionkit/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/stack/ore/bluespace_crystal))
		to_chat(user, "<span class='notice'>You insert [I] into [src].</span>")
		qdel(I)
		charges += 2