/obj/machinery/MRS
	name = "Magnetic resonance scanner"
	desc = "An enclosed machine used to scan patients' organs."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "mrs"
	density = FALSE
	state_open = FALSE
	circuit = /obj/item/circuitboard/machine/mrs
	var/efficiency = 1
	var/mob/living/carbon/scannedmob
	var/scantime = 5
	var/current_cycle = 0
	var/scanning
	var/controls_inside = FALSE

/obj/machinery/MRS/Initialize()
	. = ..()
	occupant_typecache = GLOB.typecache_living

/obj/machinery/MRS/RefreshParts()
	var/E
	for(var/obj/item/stock_parts/scanning_module/S in component_parts)
		E += S.rating

	efficiency = initial(efficiency)* E
	scantime = 3/(efficiency + 1)

/obj/machinery/MRS/update_icon()
	icon_state = initial(icon_state)
	if(state_open)
		icon_state += "-open"
	else if(scannedmob || scanning)
		icon_state += "-scan"
	else if(occupant)
		icon_state += "-ocu"

/obj/machinery/MRS/container_resist(mob/living/user)
	visible_message("<span class='notice'>[occupant] emerges from [src]!</span>",
	"<span class='notice'>You climb out of [src]!</span>")
	open_machine()

/obj/machinery/MRS/Exited(atom/movable/user)
	if(!state_open && user == occupant)
		container_resist(user)

/obj/machinery/MRS/relaymove(mob/user)
	if (!state_open)
		container_resist(user)

/obj/machinery/MRS/open_machine()
	if(!state_open && !panel_open)
		..()
	scannedmob = null
	scanning = FALSE
	update_icon()

/obj/machinery/MRS/close_machine(mob/user)
	if((isnull(user) || istype(user)) && state_open && !panel_open)
		..(user)
		occupant.visible_message("[occupant] enters into the [src], the glass screen decending with a hiss as the machines whirr up. A scan button glows brightly green on the nearby monitor.", "<span class='boldnotice'>As you enter the machine you feel a strange sensation of increased gravity.</span>")
	update_icon()

/obj/machinery/MRS/proc/scan()
	if(current_cycle >= scantime)
		scannedmob = occupant
		scanning = FALSE
		current_cycle = 0
	if(!occupant)
		scanning = FALSE
		current_cycle = 0
		return
	current_cycle++
	playsound(occupant, 'sound/machines/diagnostics/MRS.ogg', 80, 0)
	update_icon()

/obj/machinery/MRS/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	if(is_operational() && occupant)
		open_machine()
	scantime += rand(0,0.5)

/obj/machinery/MRS/MouseDrop_T(mob/target, mob/user)
	if(user.incapacitated() || !Adjacent(user) || !user.Adjacent(target) || !iscarbon(target) || !user.IsAdvancedToolUser())
		return
	close_machine(target)

/obj/machinery/MRS/screwdriver_act(mob/living/user, obj/item/I)
	. = TRUE
	if(..())
		return
	if(occupant)
		to_chat(user, "<span class='warning'>[src] is currently occupied!</span>")
		return
	if(state_open)
		to_chat(user, "<span class='warning'>[src] must be closed to [panel_open ? "close" : "open"] its maintenance hatch!</span>")
		return
	if(default_deconstruction_screwdriver(user, "[initial(icon_state)]-o", initial(icon_state), I))
		return
	return FALSE

/obj/machinery/MRS/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	if(default_change_direction_wrench(user, I))
		return TRUE

/obj/machinery/MRS/crowbar_act(mob/living/user, obj/item/I)
	. = ..()
	if(default_pry_open(I))
		return TRUE
	if(default_deconstruction_crowbar(I))
		return TRUE

/obj/machinery/MRS/default_pry_open(obj/item/I) //wew
	. = !(state_open || panel_open || (flags_1 & NODECONSTRUCT_1)) && I.tool_behaviour == TOOL_CROWBAR
	if(.)
		I.play_tool_sound(src, 50)
		visible_message("<span class='notice'>[usr] pries open [src].</span>", "<span class='notice'>You pry open [src].</span>")
		open_machine()

/obj/machinery/MRS/AltClick(mob/user)
	if(!user.canUseTopic(src, !issilicon(user)))
		return
	if(state_open)
		close_machine()
	else
		open_machine()

/obj/machinery/MRS/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click [src] to [state_open ? "close" : "open"] it.</span>"

/obj/machinery/MRS/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
									datum/tgui/master_ui = null, datum/ui_state/state = GLOB.notcontained_state)

	if(controls_inside && state == GLOB.notcontained_state)
		state = GLOB.default_state // If it has a set of controls on the inside, make it actually controllable by the mob in it.

	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "mrs", name, 420, 600, master_ui, state)
		ui.open()

/obj/machinery/MRS/ui_data()
	var/mob/living/mob_occupant = occupant
	var/list/data = list()
	data["occupied"] = occupant ? 1 : 0
	data["open"] = state_open
	if(mob_occupant)
		data["occupant"] = list()
		data["occupant"]["name"] = mob_occupant.name
		data["occupant"]["health"] = mob_occupant.health
		data["occupant"]["maxHealth"] = mob_occupant.maxHealth
		data["occupant"]["minHealth"] = HEALTH_THRESHOLD_DEAD
		switch(mob_occupant.stat)
			if(CONSCIOUS)
				data["occupant"]["stat"] = "Conscious"
				data["occupant"]["statstate"] = "good"
			if(SOFT_CRIT)
				data["occupant"]["stat"] = "Conscious"
				data["occupant"]["statstate"] = "average"
			if(UNCONSCIOUS)
				data["occupant"]["stat"] = "Unconscious"
				data["occupant"]["statstate"] = "average"
			if(DEAD)
				data["occupant"]["stat"] = "Dead"
				data["occupant"]["statstate"] = "bad"

	data["scanmob"] = scannedmob ? 1 : 0
	data["scanning"] = scanning
	data["scantime"] = scantime
	data["scancount"] = current_cycle
	//Scanned mob state

	if(scannedmob)

		var/mob/living/carbon/C = scannedmob
		//Organ scan
		data["occupant"]["organs"] = list()
		data["occupant"]["missing_organs"] = list()
		data["occupant"]["traumalist"] = list()
		if(C)
			//Stomach pH
			if(C.reagents)
				switch(C.reagents.pH)
					if(-INFINITY to 4)
						data["occupant"]["pHState"] = "Extremely acidic"
						data["occupant"]["pHcolor"] = "bad"
					if(4 to 5.5)
						data["occupant"]["pHState"] = "Too acidic"
						data["occupant"]["pHcolor"] = "average"
					if(5.5 to 8.5)
						data["occupant"]["pHState"] = "Healthy pH" //bad index once? But why?
						data["occupant"]["pHcolor"] = "good"
					if(8.5 to 10)
						data["occupant"]["pHState"] = "Too basic"
						data["occupant"]["pHcolor"] = "highlight"
					if(10 to INFINITY)
						data["occupant"]["pHState"] = "Extremely basic"
						data["occupant"]["pHcolor"] = "basic"
				data["occupant"]["pH"] = C.reagents.pH

				var/datum/reagent/metabolic/stomach_acid/Sa = C.reagents.has_reagent("stomach_acid")
				if(Sa)
					data["occupant"]["stomachVol"] = Sa.volume
					switch(Sa.volume)
						if(0 to 5)
							data["occupant"]["stomachColor"] = "bad"
						if(5 to 30)
							data["occupant"]["stomachColor"] = "average"
						if(30 to 50)
							data["occupant"]["stomachColor"] = "good"
				else
					data["occupant"]["stomachVol"] = 0
					data["occupant"]["stomachColor"] = "bad"



			for(var/obj/item/organ/Or in C.internal_organs)
				var/state = "Healthy"
				var/textcolor = "healthy"
				if(Or.organ_flags & ORGAN_FAILING)
					state = "End Stage"
					textcolor = "bad"
				else if(Or.damage > Or.high_threshold)
					state = "Chronic"
					textcolor = "bad"
				else if(Or.damage > Or.low_threshold)
					state = "Acute"
					textcolor = "average"
				else if (Or.damage < 0)
					state = "OverHealed"
					textcolor = "highlight"


				if(efficiency > 3 && (Or.damage > 0 && Or.damage < Or.maxHealth))
					state += ": [round(Or.damage, 0.1)]"

				data["occupant"]["organs"] += list(list("name" = uppertext(Or.name), "slot" = uppertext(Or.slot), "damage" = Or.damage, "max_damage" = Or.maxHealth, "state" = state, "color" = textcolor))

				//Brain
				if(istype(Or, /obj/item/organ/brain))
					if(LAZYLEN(C.get_traumas()))
						for(var/datum/brain_trauma/B in C.get_traumas())
							var/colorB = "average"
							var/trauma
							switch(B.resilience)
								if(TRAUMA_RESILIENCE_SURGERY)
									trauma += "Severe "
								if(TRAUMA_RESILIENCE_LOBOTOMY)
									trauma += "Deep-rooted "
									colorB = "bad"
								if(TRAUMA_RESILIENCE_MAGIC, TRAUMA_RESILIENCE_ABSOLUTE)
									trauma += "Permanent "
									colorB = "bad"

							data["occupant"]["traumalist"] += list(list("Bname" = B.name, "colourB" = colorB, "resist" = trauma))
						continue

				//Stomach is handled above


				//Liver
				if(istype(Or, /obj/item/organ/liver))
					var/obj/item/organ/liver/L = Or
					var/slimeLiver = FALSE
					if(istype(L, /obj/item/organ/liver/slime))
						slimeLiver = TRUE
					switch(L.metabolic_stress)
						if(-INFINITY to -95)
							if(slimeLiver)
								data["occupant"]["metabolicColour"] = "bad"
								data["occupant"]["metabolicStressMax"] = -100
								data["occupant"]["metabolicStress"] = "Extreme toxin saturation [round(L.metabolic_stress, 0.1)]%"
								data["occupant"]["metabolicStressMin"] = 0
								data["occupant"]["metabolicStressVal"] = round(L.metabolic_stress, 0.1)
						if(-95 to -55)
							if(slimeLiver)
								data["occupant"]["metabolicColour"] = "average"
								data["occupant"]["metabolicStressMax"] = -100
								data["occupant"]["metabolicStress"] = "High toxin saturation [round(L.metabolic_stress, 0.1)]%"
								data["occupant"]["metabolicStressMin"] = 0
								data["occupant"]["metabolicStressVal"] = round(L.metabolic_stress, 0.1)
						if(-55 to -25)
							data["occupant"]["metabolicColour"] = "basic"
							if(slimeLiver)
								data["occupant"]["metabolicStressMax"] = -100
								data["occupant"]["metabolicStress"] = "Chronic liver treatment [round(L.metabolic_stress, 0.1)]%"
							else //Shouldn't get here, but just in case
								data["occupant"]["metabolicStressMax"] = -15
								data["occupant"]["metabolicStress"] = "Chronic liver treatment [round(L.metabolic_stress, 0.1)]%"
							data["occupant"]["metabolicStressMin"] = 0
							data["occupant"]["metabolicStressVal"] = round(L.metabolic_stress, 0.1)
						if(-25 to -10)
							if(slimeLiver)
								data["occupant"]["metabolicColour"] = "basic"
								data["occupant"]["metabolicStressMax"] = -100
								data["occupant"]["metabolicStress"] = "Acute liver treatment [round(L.metabolic_stress, 0.1)]%"
							else
								data["occupant"]["metabolicColour"] = "highlight"
								data["occupant"]["metabolicStressMax"] = -15
								data["occupant"]["metabolicStress"] = "Chronic liver treatment [round(L.metabolic_stress, 0.1)]%"
							data["occupant"]["metabolicStressMin"] = 0
							data["occupant"]["metabolicStressVal"] = round(L.metabolic_stress, 0.1)
						if(-10 to -0.5)
							data["occupant"]["metabolicStressMax"] = 105
							data["occupant"]["metabolicStressMin"] = 0
							data["occupant"]["metabolicColour"] = "highlight"
							data["occupant"]["metabolicStress"] = "Acute liver treatment [round(L.metabolic_stress, 0.1)]%"
							data["occupant"]["metabolicStressVal"] = round(L.metabolic_stress, 0.1)
						if(-0.5 to 15)
							data["occupant"]["metabolicColour"] = "good"
							data["occupant"]["metabolicStress"] = "[round(L.metabolic_stress, 0.1)]%"
							data["occupant"]["metabolicStressVal"] = round(L.metabolic_stress, 0.1)
							data["occupant"]["metabolicStressMax"] = 105
							data["occupant"]["metabolicStressMin"] = 0
						if(15 to 25)
							data["occupant"]["metabolicColour"] = "average"
							data["occupant"]["metabolicStress"] = "[round(L.metabolic_stress, 0.1)]%"
							data["occupant"]["metabolicStressVal"] = round(L.metabolic_stress, 0.1)
							data["occupant"]["metabolicStressMax"] = 105
							data["occupant"]["metabolicStressMin"] = 0
						if(25 to INFINITY)
							data["occupant"]["metabolicColour"] = "bad"
							data["occupant"]["metabolicStress"] = "[round(L.metabolic_stress, 0.1)]%"
							data["occupant"]["metabolicStressVal"] = round(L.metabolic_stress, 0.1)
							data["occupant"]["metabolicStressMax"] = 105
							data["occupant"]["metabolicStressMin"] = 0
					if(L.swelling > 10)
						data["occupant"]["swelling"] = TRUE
					continue

				//lungs
				if(istype(Or, /obj/item/organ/lungs))
					var/obj/item/organ/lungs/Lu = Or
					if(Lu.organ_flags & ORGAN_LUNGS_DEFLATED)
						data["occupant"]["lungcollapse"] = "Single lobe collapse detected."
					continue

			//LOOK FOR MISSING ORGANS
			var/breathes = TRUE
			var/blooded = TRUE
			if(C.dna && C.dna.species)
				if(HAS_TRAIT_FROM(C, TRAIT_NOBREATH, SPECIES_TRAIT))
					breathes = FALSE
				if(NOBLOOD in C.dna.species.species_traits)
					blooded = FALSE
			var/has_liver = (!(NOLIVER in C.dna.species.species_traits))
			var/has_stomach = (!(NOSTOMACH in C.dna.species.species_traits))
			if(!C.getorganslot(ORGAN_SLOT_EYES))
				data["occupant"]["missing_organs"] += list(list("name" = "EYES"))
			if(!C.getorganslot(ORGAN_SLOT_EARS))
				data["occupant"]["missing_organs"] += list(list("name" = "EARS"))
			if(!C.getorganslot(ORGAN_SLOT_BRAIN))
				data["occupant"]["missing_organs"] += list(list("name" = "BRAIN"))
			if(has_liver && !C.getorganslot(ORGAN_SLOT_LIVER))
				data["occupant"]["missing_organs"] += list(list("name" = "LIVER"))
			if(blooded && !C.getorganslot(ORGAN_SLOT_HEART))
				data["occupant"]["missing_organs"] += list(list("name" = "HEART"))
			if(breathes && !C.getorganslot(ORGAN_SLOT_LUNGS))
				data["occupant"]["missing_organs"] += list(list("name" = "LUNGS"))
			if(has_stomach && !C.getorganslot(ORGAN_SLOT_STOMACH))
				data["occupant"]["missing_organs"] += list(list("name" = "STOMACH"))
	return data

/obj/machinery/MRS/ui_act(action, params)
	if(..())
		return

	switch(action)
		if("door")
			if(state_open)
				close_machine()
			else
				open_machine()
			. = TRUE
		if("scan")
			scanning = TRUE

		/*if("print")
			new paper*/

//TODO: emag_act() - scamble results somewhat, increase radiation, damage cyberorgans.

/obj/machinery/MRS/process()
	if(scanning)
		if(!occupant)
			visible_message("No occupant detected!")
			scanning = FALSE
		scan()
