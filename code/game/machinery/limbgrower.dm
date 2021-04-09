#define LIMBGROWER_MAIN_MENU       1
#define LIMBGROWER_CATEGORY_MENU   2
#define LIMBGROWER_CHEMICAL_MENU   3
//use these for the menu system


/obj/machinery/limbgrower
	name = "limb grower"
	desc = "It grows new limbs using Synthflesh."
	icon = 'icons/obj/machines/limbgrower.dmi'
	icon_state = "limbgrower_idleoff"
	density = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 10
	active_power_usage = 100
	circuit = /obj/item/circuitboard/machine/limbgrower

	var/operating = FALSE
	var/disabled = FALSE
	var/busy = FALSE
	var/prod_coeff = 1
	var/datum/design/being_built
	var/datum/techweb/stored_research
	var/selected_category
	var/screen = 1
	var/list/categories = list(
							"human" = /datum/species/human,
							"lizard" = /datum/species/lizard,
							"mammal" =  /datum/species/mammal,
							"insect" =  /datum/species/insect,
							"fly" =  /datum/species/fly,
							"plasmaman" =  /datum/species/plasmaman,
							"xeno" =  /datum/species/xeno,
							"other" = /datum/species,
							)
	var/list/stored_species = list()
	var/obj/item/disk/data/dna_disk

/obj/machinery/limbgrower/Initialize()
	create_reagents(100, OPENCONTAINER)
	stored_research = new /datum/techweb/specialized/autounlocking/limbgrower
	for(var/i in categories)
		var/species = categories[i]
		stored_species[i] = new species()
	. = ..()

/obj/machinery/limbgrower/ui_interact(mob/user)
	. = ..()
	if(!is_operational())
		return

	var/dat = main_win(user)

	switch(screen)
		if(LIMBGROWER_MAIN_MENU)
			dat = main_win(user)
		if(LIMBGROWER_CATEGORY_MENU)
			dat = category_win(user,selected_category)
		if(LIMBGROWER_CHEMICAL_MENU)
			dat = chemical_win(user)

	var/datum/browser/popup = new(user, "Limb Grower", name, 400, 500)
	popup.set_content(dat)
	popup.open()

/obj/machinery/limbgrower/on_deconstruction()
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		reagents.trans_to(G, G.reagents.maximum_volume)
	..()

/obj/machinery/limbgrower/attackby(obj/item/O, mob/user, params)
	if(busy)
		to_chat(user, "<span class=\"alert\">\The [src] is busy. Please wait for completion of previous operation.</span>")
		return

	if(default_deconstruction_screwdriver(user, "limbgrower_panelopen", "limbgrower_idleoff", O))
		updateUsrDialog()
		return

	if(panel_open && default_deconstruction_crowbar(O))
		return

	if(user.a_intent == INTENT_HARM) //so we can hit the machine
		return ..()

	if(istype(O, /obj/item/disk))
		if(dna_disk)
			to_chat(user, "<span class='warning'>\The [src] already has a dna disk, take it out first!</span>")
			return
		else
			O.forceMove(src)
			dna_disk = O
			to_chat(user, "<span class='notice'>You insert \the [O] into \the [src].</span>")
			return

/obj/machinery/limbgrower/Topic(href, href_list)
	if(..())
		return
	if (!busy)
		if(href_list["menu"])
			screen = text2num(href_list["menu"])

		if(href_list["category"])
			selected_category = href_list["category"]

		if(href_list["disposeI"])  //Get rid of a reagent incase you add the wrong one by mistake
			reagents.del_reagent(text2path(href_list["disposeI"]))

		if(href_list["make"])

			/////////////////
			//href protection
			being_built = stored_research.isDesignResearchedID(href_list["make"]) //check if it's a valid design
			if(!being_built)
				return


			var/synth_cost = being_built.reagents_list[/datum/reagent/medicine/synthflesh]*prod_coeff
			var/power = max(2000, synth_cost/5)

			if(reagents.has_reagent(/datum/reagent/medicine/synthflesh, being_built.reagents_list[/datum/reagent/medicine/synthflesh]*prod_coeff))
				busy = TRUE
				use_power(power)
				flick("limbgrower_fill",src)
				icon_state = "limbgrower_idleon"
				addtimer(CALLBACK(src, .proc/build_item),32*prod_coeff)

		if(href_list["dna_disk"])
			var/mob/living/carbon/user = usr
			if(istype(user))
				if(!dna_disk)
					var/obj/item/disk/diskette = user.get_active_held_item()
					if(istype(diskette))
						diskette.forceMove(src)
						dna_disk = diskette
						to_chat(user, "<span class='notice'>You insert \the [diskette] into \the [src].</span>")
				else
					dna_disk.forceMove(src.loc)
					user.put_in_active_hand(dna_disk)
					to_chat(user, "<span class='notice'>You remove \the [dna_disk] from \the [src].</span>")
					dna_disk = null
			else
				to_chat(user, "<span class='warning'>You are unable to grasp \the [dna_disk] disk from \the [src].</span>")
	else
		to_chat(usr, "<span class=\"alert\">\The [src] is busy. Please wait for completion of previous operation.</span>")

	updateUsrDialog()
	return

/obj/machinery/limbgrower/proc/build_item()
	if(reagents.has_reagent(/datum/reagent/medicine/synthflesh, being_built.reagents_list[/datum/reagent/medicine/synthflesh]*prod_coeff))	//sanity check, if this happens we are in big trouble
		reagents.remove_reagent(/datum/reagent/medicine/synthflesh, being_built.reagents_list[/datum/reagent/medicine/synthflesh]*prod_coeff)
		var/buildpath = being_built.build_path
		if(ispath(buildpath, /obj/item/bodypart))	//This feels like spaghetti code, but i need to initiliaze a limb somehow
			build_limb(buildpath)
		else if(ispath(buildpath, /obj/item/organ/genital)) //genitals are uhh... customizable
			build_genital(buildpath)
		else
			//Just build whatever it is
			new buildpath(loc)
	else
		src.visible_message("<span class=\"error\"> Something went very wrong and there isnt enough synthflesh anymore!</span>")
	busy = FALSE
	flick("limbgrower_unfill",src)
	icon_state = "limbgrower_idleoff"
	updateUsrDialog()

/obj/machinery/limbgrower/proc/build_limb(buildpath)
	//i need to create a body part manually using a set icon (otherwise it doesnt appear)
	var/obj/item/bodypart/limb
	var/datum/species/selected = stored_species[selected_category]
	limb = new buildpath(loc)
	limb.base_bp_icon = selected.icon_limbs || DEFAULT_BODYPART_ICON_ORGANIC
	limb.species_id = selected.limbs_id
	limb.color_src = (MUTCOLORS in selected.species_traits ? MUTCOLORS : (selected.use_skintones ? SKINTONE : FALSE))
	limb.should_draw_gender = (selected.sexes && (limb.body_zone in list(BODY_ZONE_HEAD, BODY_ZONE_CHEST)))
	limb.update_limb(TRUE)
	limb.update_icon_dropped()
	limb.name = "\improper synthetic [lowertext(selected.name)] [limb.name]"
	limb.desc = "A synthetic [selected_category] limb that will morph on its first use in surgery. This one is for the [parse_zone(limb.body_zone)]."
	limb.forcereplace = TRUE
	for(var/obj/item/bodypart/BP in limb)
		BP.base_bp_icon = selected.icon_limbs || DEFAULT_BODYPART_ICON_ORGANIC
		BP.species_id = selected.limbs_id
		BP.color_src = (MUTCOLORS in selected.species_traits ? MUTCOLORS : (selected.use_skintones ? SKINTONE : FALSE))
		BP.should_draw_gender = (selected.sexes && (limb.body_zone in list(BODY_ZONE_HEAD, BODY_ZONE_CHEST)))
		BP.update_limb(TRUE)
		BP.update_icon_dropped()
		BP.name = "\improper synthetic [lowertext(selected.name)] [limb.name]"
		BP.desc = "A synthetic [selected_category] limb that will morph on its first use in surgery. This one is for the [parse_zone(limb.body_zone)]."

/obj/machinery/limbgrower/proc/build_genital(buildpath)
	//i needed to create a way to customize gene tools using dna
	var/list/features = dna_disk?.fields["features"]
	if(length(features))
		switch(buildpath)
			if(/obj/item/organ/genital/penis)
				var/obj/item/organ/genital/penis/penis = new(loc)
				if(features["has_cock"])
					penis.shape = features["cock_shape"]
					penis.length = features["cock_shape"]
					penis.diameter_ratio = features["cock_diameter_ratio"]
					penis.color = sanitize_hexcolor(features["cock_color"], 6)
					penis.update_icon()
			if(/obj/item/organ/genital/testicles)
				var/obj/item/organ/genital/testicles/balls = new(loc)
				if(features["has_balls"])
					balls.color = sanitize_hexcolor(features["balls_color"], 6)
					balls.shape = features["balls_shape"]
					balls.size = features["balls_size"]
					balls.fluid_rate = features["balls_cum_rate"]
					balls.fluid_mult = features["balls_cum_mult"]
					balls.fluid_efficiency = features["balls_efficiency"]
			if(/obj/item/organ/genital/vagina)
				var/obj/item/organ/genital/vagina/vegana = new(loc)
				if(features["has_vagina"])
					vegana.color = sanitize_hexcolor(features["vag_color"], 6)
					vegana.shape = features["vag_shape"]
			if(/obj/item/organ/genital/breasts)
				var/obj/item/organ/genital/breasts/boobs = new(loc)
				if(features["has_breasts"])
					boobs.color = sanitize_hexcolor(features["breasts_color"], 6)
					boobs.size = features["breasts_size"]
					boobs.shape = features["breasts_shape"]
					if(!features["breasts_producing"])
						boobs.genital_flags &= ~(GENITAL_FUID_PRODUCTION|CAN_CLIMAX_WITH|CAN_MASTURBATE_WITH)
			else
				new buildpath(loc)
	else
		new buildpath(loc)

/obj/machinery/limbgrower/RefreshParts()
	reagents.maximum_volume = 0
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		reagents.maximum_volume += G.volume
		G.reagents.trans_to(src, G.reagents.total_volume)
	var/T=1.2
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		T -= M.rating*0.2
	prod_coeff = min(1,max(0,T)) // Coeff going 1 -> 0,8 -> 0,6 -> 0,4

/obj/machinery/limbgrower/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Storing up to <b>[reagents.maximum_volume]u</b> of synthflesh.<br>Synthflesh consumption at <b>[prod_coeff*100]%</b>.<span>"

/obj/machinery/limbgrower/proc/main_win(mob/user)
	var/dat = "<div class='statusDisplay'><h3>[src] Menu:</h3><br>"
	dat += "<A href='?src=[REF(src)];dna_disk=1'>[dna_disk ? "Remove" : "Insert"] cloning data disk</A>"
	dat += "<hr>"
	dat += "<A href='?src=[REF(src)];menu=[LIMBGROWER_CHEMICAL_MENU]'>Chemical Storage</A>"
	dat += materials_printout()
	dat += "<table style='width:100%' align='center'><tr>"

	for(var/C in categories)
		dat += "<td><A href='?src=[REF(src)];category=[C];menu=[LIMBGROWER_CATEGORY_MENU]'>[C]</A></td>"
		dat += "</tr><tr>"
		//one category per line

	dat += "</tr></table></div>"
	return dat

/obj/machinery/limbgrower/proc/category_win(mob/user,selected_category)
	var/dat = "<A href='?src=[REF(src)];menu=[LIMBGROWER_MAIN_MENU]'>Return to main menu</A>"
	dat += "<div class='statusDisplay'><h3>Browsing [selected_category]:</h3><br>"
	dat += materials_printout()

	for(var/v in stored_research.researched_designs)
		var/datum/design/D = SSresearch.techweb_design_by_id(v)
		if(!(selected_category in D.category))
			continue
		if(disabled || !can_build(D))
			dat += "<span class='linkOff'>[D.name]</span>"
		else
			dat += "<a href='?src=[REF(src)];make=[D.id];multiplier=1'>[D.name]</a>"
		dat += "[get_design_cost(D)]<br>"

	dat += "</div>"
	return dat


/obj/machinery/limbgrower/proc/chemical_win(mob/user)
	var/dat = "<A href='?src=[REF(src)];menu=[LIMBGROWER_MAIN_MENU]'>Return to main menu</A>"
	dat += "<div class='statusDisplay'><h3>Browsing Chemical Storage:</h3><br>"
	dat += materials_printout()

	for(var/datum/reagent/R in reagents.reagent_list)
		dat += "[R.name]: [R.volume]"
		dat += "<A href='?src=[REF(src)];disposeI=[R]'>Purge</A><BR>"

	dat += "</div>"
	return dat

/obj/machinery/limbgrower/proc/materials_printout()
	var/dat = "<b>Total amount:></b> [reagents.total_volume] / [reagents.maximum_volume] cm<sup>3</sup><br>"
	return dat

/obj/machinery/limbgrower/proc/can_build(datum/design/D)
	return (reagents.has_reagent(/datum/reagent/medicine/synthflesh, D.reagents_list[/datum/reagent/medicine/synthflesh]*prod_coeff)) //Return whether the machine has enough synthflesh to produce the design

/obj/machinery/limbgrower/proc/get_design_cost(datum/design/D)
	var/dat
	if(D.reagents_list[/datum/reagent/medicine/synthflesh])
		dat += "[D.reagents_list[/datum/reagent/medicine/synthflesh] * prod_coeff] Synthetic flesh "
	return dat

/obj/machinery/limbgrower/emag_act(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		return
	for(var/id in SSresearch.techweb_designs)
		var/datum/design/D = SSresearch.techweb_design_by_id(id)
		if((D.build_type & LIMBGROWER) && ("emagged" in D.category))
			stored_research.add_design(D)
	to_chat(user, "<span class='warning'>A warning flashes onto the screen, stating that safety overrides have been deactivated!</span>")
	obj_flags |= EMAGGED
	return TRUE

/obj/machinery/limbgrower/AltClick(mob/living/user)
	. = ..()
	if(istype(user) && user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		if(busy)
			to_chat(user, "<span class=\"alert\">\The [src] is busy. Please wait for completion of previous operation.</span>")
		else
			if(dna_disk)
				dna_disk.forceMove(src.loc)
				user.put_in_active_hand(dna_disk)
				to_chat(user, "<span class='notice'>You remove \the [dna_disk] from \the [src].</span>")
				dna_disk = null
			else
				to_chat(user, "<span class='warning'>\The [src] has doesn't have a disk on it!")

//Defines some vars that makes limbs appears, TO-DO: define every single species.

/datum/species/human
	limbs_id = SPECIES_HUMAN
	icon_limbs = 'icons/mob/human_parts_greyscale.dmi'

/datum/species/lizard
	limbs_id = SPECIES_LIZARD
	icon_limbs = 'icons/mob/human_parts_greyscale.dmi'

/datum/species/mammal
	limbs_id = SPECIES_MAMMAL
	icon_limbs = 'icons/mob/human_parts_greyscale.dmi'

/datum/species/insect
	limbs_id = SPECIES_INSECT
	icon_limbs = 'icons/mob/human_parts_greyscale.dmi'

/datum/species/fly
	limbs_id = SPECIES_FLY
	icon_limbs = 'icons/mob/human_parts.dmi'

/datum/species/plasmaman
	limbs_id = SPECIES_PLASMAMAN
	icon_limbs = 'icons/mob/human_parts.dmi'

/datum/species/xeno
	limbs_id = SPECIES_XENOHYBRID
	icon_limbs = 'icons/mob/human_parts_greyscale.dmi'
