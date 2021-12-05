GLOBAL_LIST_EMPTY(skull_types)

/obj/belly/proc/handle_remains_leaving(mob/living/M)
	var/bones_amount = rand(2,3) //some random variety in amount of bones left
	if(prob(20))	//ribcage surviving whole is some luck
		new /obj/item/digestion_remains/ribcage(src,owner)
		bones_amount--

	while(bones_amount)	//throw in the rest
		new /obj/item/digestion_remains(src,owner)
		bones_amount--

	var/skull_amount = 1
	var/prey_skull = GLOB.skull_types[M.vore_skull]
	if(M.vore_skull)
		new prey_skull(src, owner)
		skull_amount--

	if(skull_amount)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			// We still haven't found correct skull...
			if(istype(H.dna.species, /datum/species/human))
				new /obj/item/digestion_remains/skull/unknown(src,owner)
			else
				new /obj/item/digestion_remains/skull/unknown/anthro(src,owner)
		else
			// Something entirely different...
			new /obj/item/digestion_remains/skull/unknown(src,owner)


/obj/item/digestion_remains
	name = "bone"
	desc = "A bleached bone. It's very non-descript and its hard to tell what species or part of the body it came from."
	icon = 'icons/obj/bones.dmi'
	icon_state = "generic"
	force = 0
	throwforce = 0
	item_state = "bone"
	w_class = WEIGHT_CLASS_SMALL
	var/pred_ckey
	var/pred_name

/obj/item/digestion_remains/Initialize(mapload, mob/living/pred)
	. = ..()
	if(!mapload)
		pred_ckey = pred?.ckey
		pred_name = pred?.name

/obj/item/digestion_remains/attack_self(mob/user)
	if(user.a_intent == INTENT_HARM)
		to_chat(user,"<span class='warning'>As you squeeze the [name], it crumbles into dust and falls apart into nothing!</span>")
		qdel(src)

/obj/item/digestion_remains/ribcage
	name = "ribcage"
	desc = "A bleached ribcage. It's very white and definitely has seen better times. Hard to tell what it belonged to."
	icon_state = "ribcage"

/obj/item/digestion_remains/skull
	name = "human skull"
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a human."
	icon_state = "skull"

/obj/item/digestion_remains/skull/tajaran
	name = "tajaran skull"
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a tajara."
	icon_state = "skull_taj"

/obj/item/digestion_remains/skull/unathi
	name = "unathi skull"
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to an unathi."
	icon_state = "skull_unathi"

/obj/item/digestion_remains/skull/skrell
	name = "skrell skull"
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a skrell."

/obj/item/digestion_remains/skull/vasilissan
	name = "vasilissan skull"
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a vasilissan."

/obj/item/digestion_remains/skull/akula
	name = "akula skull"
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to an akula."
	icon_state = "skull_unathi"

/obj/item/digestion_remains/skull/rapala
	name = "rapala skull"
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a rapala."

/obj/item/digestion_remains/skull/vulpkanin
	name = "vulpkanin skull"
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a vulpkanin."
	icon_state = "skull_taj"

/obj/item/digestion_remains/skull/sergal
	name = "sergal skull"
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a sergal."
	icon_state = "skull_taj"

/obj/item/digestion_remains/skull/zorren
	name = "zorren skull"
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a zorren."
	icon_state = "skull_taj"

/obj/item/digestion_remains/skull/nevrean
	name = "nevrean skull"
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a nevrean."
	icon_state = "skull_taj"

/obj/item/digestion_remains/skull/teshari
	name = "teshari skull"
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a teshari."
	icon_state = "skull_taj"

/obj/item/digestion_remains/skull/vox
	name = "vox skull"
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to a vox."
	icon_state = "skull_taj"

/obj/item/digestion_remains/skull/unknown
	name = "generic skull"
	desc = "A bleached skull. It looks very weakened. You can't quite tell what species it belonged to."

/obj/item/digestion_remains/skull/unknown/anthro
	name = "anthropomorphic skull"
	desc = "A bleached skull. It looks very weakened. Seems like it belonged to an anthropomorphic creature."
	icon_state = "skull_taj"
