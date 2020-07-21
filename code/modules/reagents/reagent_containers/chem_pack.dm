/obj/item/reagent_containers/chem_pack
	name = "intravenous medicine bag"
	desc = "A plastic pressure bag, or 'chem pack', for IV administration of drugs. It is fitted with a thermosealing strip."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "chempack"
	volume = 100
	reagent_flags = OPENCONTAINER
	spillable = TRUE
	obj_flags = UNIQUE_RENAME
	resistance_flags = ACID_PROOF
	var/sealed = FALSE

/obj/item/reagent_containers/chem_pack/on_reagent_change(changetype)
	update_icon()

/obj/item/reagent_containers/chem_pack/update_icon()
	cut_overlays()

	var/v = min(round(reagents.total_volume / volume * 10), 10)
	if(v > 0)
		var/mutable_appearance/filling = mutable_appearance('icons/obj/reagentfillings.dmi', "chempack1")
		filling.icon_state = "chempack[v]"
		filling.color = mix_color_from_reagents(reagents.reagent_list)
		add_overlay(filling)

/obj/item/reagent_containers/chem_pack/AltClick(mob/living/user)
	if(user.canUseTopic(src, BE_CLOSE, NO_DEXTERY) && !sealed)
		if(iscarbon(user) && (HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50)))
			to_chat(user, "<span class='warning'>Uh... whoops! You accidentally spill the content of the bag onto yourself.</span>")
			SplashReagents(user)
			return
		else
			DISABLE_BITFIELD(reagents.reagents_holder_flags, OPENCONTAINER)
			ENABLE_BITFIELD(reagents.reagents_holder_flags, DRAWABLE |INJECTABLE )
			spillable = FALSE
			sealed = TRUE
			to_chat(user, "<span class='notice'>You seal the bag.</span>")


/obj/item/reagent_containers/chem_pack/examine()
	. = ..()
	if(sealed)
		. += "<span class='notice'>The bag is sealed shut.</span>"
	else
		. += "<span class='notice'>Alt-click to seal it.</span>"


obj/item/reagent_containers/chem_pack/attack_self(mob/user)
	if(sealed)
		return
	..()