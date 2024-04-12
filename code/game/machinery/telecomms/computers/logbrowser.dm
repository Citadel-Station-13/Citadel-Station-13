/*
	The log console for viewing the entire telecomms
	network log
*/

/obj/machinery/computer/telecomms/server
	name = "telecommunications server monitoring console"
	icon_screen = "comm_logs"
	desc = "Has full access to all details and record of the telecommunications network it's monitoring."
	circuit = /obj/item/circuitboard/computer/comm_server
	req_access = list(ACCESS_TCOMSAT)

	var/list/machinelist = list()	// the servers located by the computer
	var/obj/machinery/telecomms/server/SelectedMachine = null

	var/network = "NULL"		// the network to probe
	var/notice = ""
	var/universal_translate = FALSE // set to TRUE(1) if it can translate nonhuman speech

/obj/machinery/computer/telecomms/server/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TelecommsLogBrowser", "Telecomms Server Monitor")
		ui.open()

/obj/machinery/computer/telecomms/server/ui_data(mob/user)
	var/list/data_out = list()
	data_out["network"] = network
	data_out["notice"] = notice

	data_out["servers"] = list()
	for(var/obj/machinery/telecomms/server/T in machinelist)
		var/list/data = list(
			name = T.name,
			id = T.id,
			ref = REF(T)
		)
		data_out["servers"] += list(data)
	data_out["servers"] = sort_list(data_out["servers"]) //a-z sort

	if(!SelectedMachine) //null is bad.
		data_out["selected"] = null //but in js, null is good.
		return data_out

	data_out["selected"] = list(
		name = SelectedMachine.name,
		id = SelectedMachine.id,
		status = SelectedMachine.on,
		traffic = SelectedMachine.totaltraffic, //note: total traffic, not traffic!
		ref = REF(SelectedMachine)
	)
	data_out["selected_logs"] = list()

	if(!LAZYLEN(SelectedMachine.log_entries))
		return data_out

	for(var/datum/comm_log_entry/C in SelectedMachine.log_entries)
		var/list/data = list()
		data["name"] = C.name	//name of the file
		data["ref"] = REF(C)
		data["input_type"] = C.input_type	//type of input ("Speech File" | "Execution Error").

		if(C.input_type == "Speech File") //there is a reason why this is not a switch.
			data["source"] = list(
				name = C.parameters["name"],	//name of the mob | obj
				job = C.parameters["job"]		//job of the mob | obj
			)

			// -- Determine race of orator --
			var/mobtype = C.parameters["mobtype"]
			var/race	// The actual race of the mob

			if(ispath(mobtype, /mob/living/carbon/human) || ispath(mobtype, /mob/living/brain))
				race = "Humanoid"
			else if(ispath(mobtype, /mob/living/simple_animal/slime))
				race = "Slime"	// NT knows a lot about slimes, but not aliens. Can identify slimes
			else if(ispath(mobtype, /mob/living/carbon/monkey))
				race = "Monkey"
			else if(ispath(mobtype, /mob/living/silicon) || C.parameters["job"] == "AI")
				race = "Artificial Life"	// sometimes M gets deleted prematurely for AIs... just check the job
			else if(isobj(mobtype))
				race = "Machinery"
			else if(ispath(mobtype, /mob/living/simple_animal))
				race = "Domestic Animal"
			else
				race = "Unidentifiable"

			data["race"] = race
			// based on [/atom/movable/proc/lang_treat]
			var/message = C.parameters["message"]
			var/language = C.parameters["language"]

			if(universal_translate || user.has_language(language))
				message = message
			else if(!user.has_language(language))
				var/datum/language/D = GLOB.language_datum_instances[language]
				message = D.scramble(message)
			else if(language)
				message = "(unintelligible)"

			data["message"] = message

		else if(C.input_type == "Execution Error")
			data["message"] = C.parameters["message"]
		else
			data["message"] = "(unintelligible)"

		data_out["selected_logs"] += list(data)
	return data_out

/obj/machinery/computer/telecomms/server/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("mainmenu")
			SelectedMachine = null
			notice = ""
			return
		if("release")
			machinelist = list()
			notice = ""
			return
		if("network") //network change, flush the selected machine and buffer
			var/newnet = sanitize(sanitize_text(params["value"], network))
			if(length(newnet) > 15)	//i'm looking at you, you href fuckers
				notice = "FAILED: Network tag string too lengthy"
				return
			network = newnet
			SelectedMachine = null
			machinelist = list()
			return
		if("probe")
			if(LAZYLEN(machinelist) > 0)
				notice = "FAILED: Cannot probe when buffer full"
				return

			for(var/obj/machinery/telecomms/T in GLOB.telecomms_list) //telecomms just went global!
				if(T.network == network)
					LAZYADD(machinelist, T)

			if(!LAZYLEN(machinelist))
				notice = "FAILED: Unable to locate network entities in \[[network]\]"
				return
		if("viewmachine")
			for(var/obj/machinery/telecomms/T in machinelist)
				if(T.id == params["value"])
					SelectedMachine = T
					break
		if("delete")
			if(!src.allowed(usr) && !(obj_flags & EMAGGED))
				to_chat(usr, "<span class='danger'>ACCESS DENIED.</span>")
				return

			if(!SelectedMachine)
				notice = "ALERT: No server detected. Server may be nonresponsive."
				return
			var/datum/comm_log_entry/D = locate(params["value"])
			if(!istype(D))
				notice = "NOTICE: Object not found"
				return
			notice = "Deleted entry: [D.name]"
			LAZYREMOVE(SelectedMachine.log_entries, D)
			qdel(D)
