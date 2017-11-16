<<<<<<< HEAD
/obj/machinery/computer/operating
	name = "operating computer"
	desc = "Used to monitor the vitals of a patient during surgery."
	icon_screen = "crew"
	icon_keyboard = "med_key"
	circuit = /obj/item/circuitboard/computer/operating
	var/mob/living/carbon/human/patient
	var/obj/structure/table/optable/table

	light_color = LIGHT_COLOR_BLUE

/obj/machinery/computer/operating/Initialize()
	. = ..()
	find_table()

/obj/machinery/computer/operating/proc/find_table()
	for(var/dir in GLOB.cardinals)
		table = locate(/obj/structure/table/optable, get_step(src, dir))
		if(table)
			table.computer = src
			break


/obj/machinery/computer/operating/attack_hand(mob/user)
	if(..())
		return
	interact(user)

/obj/machinery/computer/operating/interact(mob/user)
	var/dat = ""
	if(table)
		dat += "<B>Patient information:</B><BR>"
		if(table.check_patient())
			patient = table.patient
			dat += get_patient_info()
		else
			patient = null
			dat += "<B>No patient detected</B>"
	else
		dat += "<B>Operating table not found.</B>"

	var/datum/browser/popup = new(user, "op", "Operating Computer", 400, 500)
	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/operating/proc/get_patient_info()
	var/dat = {"
				<div class='statusLabel'>Patient:</div> [patient.stat ? "<span class='bad'>Non-Responsive</span>" : "<span class='good'>Stable</span>"]<BR>
				<div class='statusLabel'>Blood Type:</div> [patient.dna.blood_type]

				<BR>
				<div class='line'><div class='statusLabel'>Health:</div><div class='progressBar'><div style='width: [max(patient.health, 0)]%;' class='progressFill good'></div></div><div class='statusValue'>[patient.health]%</div></div>
				<div class='line'><div class='statusLabel'>\> Brute Damage:</div><div class='progressBar'><div style='width: [max(patient.getBruteLoss(), 0)]%;' class='progressFill bad'></div></div><div class='statusValue'>[patient.getBruteLoss()]%</div></div>
				<div class='line'><div class='statusLabel'>\> Resp. Damage:</div><div class='progressBar'><div style='width: [max(patient.getOxyLoss(), 0)]%;' class='progressFill bad'></div></div><div class='statusValue'>[patient.getOxyLoss()]%</div></div>
				<div class='line'><div class='statusLabel'>\> Toxin Content:</div><div class='progressBar'><div style='width: [max(patient.getToxLoss(), 0)]%;' class='progressFill bad'></div></div><div class='statusValue'>[patient.getToxLoss()]%</div></div>
				<div class='line'><div class='statusLabel'>\> Burn Severity:</div><div class='progressBar'><div style='width: [max(patient.getFireLoss(), 0)]%;' class='progressFill bad'></div></div><div class='statusValue'>[patient.getFireLoss()]%</div></div>

				"}
	if(patient.surgeries.len)
		dat += "<BR><BR><B>Initiated Procedures</B><div class='statusDisplay'>"
		for(var/datum/surgery/procedure in patient.surgeries)
			dat += "[capitalize(procedure.name)]<BR>"
			var/datum/surgery_step/surgery_step = procedure.get_surgery_step()
			dat += "Next step: [capitalize(surgery_step.name)]"
			if(surgery_step.repeatable)
				dat += " or "
				var/datum/surgery_step/next_step = procedure.get_surgery_next_step()
				if(next_step)
					dat += "[capitalize(next_step.name)]"
				else
					dat += "finish operation"
			dat += "<BR>"
		dat += "</div>"
	return dat
=======
/obj/machinery/computer/operating
	name = "operating computer"
	desc = "Used to monitor the vitals of a patient during surgery."
	icon_screen = "crew"
	icon_keyboard = "med_key"
	circuit = /obj/item/circuitboard/computer/operating
	var/mob/living/carbon/human/patient
	var/obj/structure/table/optable/table
	light_color = LIGHT_COLOR_BLUE

/obj/machinery/computer/operating/Initialize()
	. = ..()
	find_table()

/obj/machinery/computer/operating/proc/find_table()
	for(var/dir in GLOB.cardinals)
		table = locate(/obj/structure/table/optable, get_step(src, dir))
		if(table)
			table.computer = src
			break
			
/obj/machinery/computer/operating/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "operating_computer", name, 350, 470, master_ui, state)
		ui.open()

/obj/machinery/computer/operating/ui_data(mob/user)
	var/list/data = list()
	data["table"] = table
	if(table)
		data["patient"] = list()
		if(table.check_patient())
			patient = table.patient
			switch(patient.stat)
				if(CONSCIOUS)
					data["patient"]["stat"] = "Conscious"
					data["patient"]["statstate"] = "good"
				if(SOFT_CRIT)
					data["patient"]["stat"] = "Conscious"
					data["patient"]["statstate"] = "average"
				if(UNCONSCIOUS)
					data["patient"]["stat"] = "Unconscious"
					data["patient"]["statstate"] = "average"
				if(DEAD)
					data["patient"]["stat"] = "Dead"
					data["patient"]["statstate"] = "bad"
			data["patient"]["health"] = patient.health
			data["patient"]["blood_type"] = patient.dna.blood_type
			data["patient"]["maxHealth"] = patient.maxHealth
			data["patient"]["minHealth"] = HEALTH_THRESHOLD_DEAD
			data["patient"]["bruteLoss"] = patient.getBruteLoss()
			data["patient"]["fireLoss"] = patient.getFireLoss()
			data["patient"]["toxLoss"] = patient.getToxLoss()
			data["patient"]["oxyLoss"] = patient.getOxyLoss()
			if(patient.surgeries.len)
				data["procedures"] = list()
				for(var/datum/surgery/procedure in patient.surgeries)
					var/datum/surgery_step/surgery_step = procedure.get_surgery_step()
					var/alternative_step
					if(surgery_step.repeatable)
						var/datum/surgery_step/next_step = procedure.get_surgery_next_step()
						if(next_step) 
							alternative_step = capitalize(next_step.name)
						else
							alternative_step = "Finish operation"
					data["procedures"] += list(list(
						"name" = capitalize(procedure.name),
						"next_step" = capitalize(surgery_step.name),
						"alternative_step" = alternative_step
					))
	return data
>>>>>>> a683ab6... Makes the operation computer tgui (#32775)
