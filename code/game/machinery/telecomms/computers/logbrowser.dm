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

/obj/machinery/computer/telecomms/server/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
														datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "tcommsserver", "Telecomms Server Monitor", 575, 400, master_ui, state)
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
	data_out["servers"] = sortList(data_out["servers"]) //a-z sort

	if(!SelectedMachine) //null is bad.
		data_out["selected"] = null //but in js, null is good.
		return data_out

	data_out["traffic"] = SelectedMachine.totaltraffic
	data_out["selected"] = list(
		name = SelectedMachine.name,
		id = SelectedMachine.id,
		ref = REF(SelectedMachine)
	)
	data_out["selected_logs"] = list()

	if(!LAZYLEN(SelectedMachine.log_entries))
		return data_out
	
	for(var/datum/comm_log_entry/C in SelectedMachine.log_entries)
		var/list/data = list()
		data["name"] = C.name	//name of the file
		data["ref"] = REF(C)
		data["input_type"] = C.input_type	//type of input ("Speech File" | "Execution Error"). Let js handle this

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
			to_chat(world, user)
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

/obj/machinery/computer/telecomms/server/ui_static_data(mob/user)	//i tried placing the logbuilder here but it fails because mob/user is null??	
	var/list/data_out = list()
	data_out["notice"] = "" //hacky way of removing it when you leave the console
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
			var/newnet = trim(html_encode(params["value"]), 15)
			if(length(newnet) > 15)	//i'm looking at you, you href fuckers
				notice = "FAILED: NETWORK TAG STRING TOO LENGHTLY"
				return
			network = newnet
			SelectedMachine = null
			machinelist = list()
			return
		if("probe")
			if(LAZYLEN(machinelist) > 0)
				notice = "FAILED: CANNOT PROBE WHEN BUFFER FULL"
				return
			
			for(var/obj/machinery/telecomms/T in GLOB.telecomms_list) //telecomms just went global!
				if(T.network == network)
					LAZYADD(machinelist, T)

			if(!LAZYLEN(machinelist))
				notice = "FAILED: UNABLE TO LOCATE NETWORK ENTITIES IN \[[network]\]"
				return
		if("viewmachine")
			for(var/obj/machinery/telecomms/T in machinelist)
				if(T.id == params["value"])
					SelectedMachine = T
					break
		if("delete")
			if(!src.allowed(usr) && !CHECK_BITFIELD(obj_flags, EMAGGED))
				to_chat(usr, "<span class='danger'>ACCESS DENIED.</span>")
				return

			if(!SelectedMachine)
				return
			var/datum/comm_log_entry/D = locate(params["value"])
			if(!istype(D))
				notice = "OBJECT NOT FOUND"		
				return
			notice = "DELETED ENTRY: [D.name]"
			LAZYREMOVE(SelectedMachine.log_entries, D)
			qdel(D)
			update_static_data(usr)
/*
/obj/machinery/computer/telecomms/server/ui_interact(mob/user)
			if(SelectedServer.totaltraffic >= 1024)
				dat += "<br>Total recorded traffic: [round(SelectedServer.totaltraffic / 1024)] Terrabytes<br><br>"
			else
				dat += "<br>Total recorded traffic: [SelectedServer.totaltraffic] Gigabytes<br><br>"

			dat += "Stored Logs: <ol>"

			var/i = 0
			for(var/datum/comm_log_entry/C in SelectedServer.log_entries)
				i++


				// If the log is a speech file
				if(C.input_type == "Speech File")
					dat += "<li><font color = #008F00>[C.name]</font>  <font color = #FF0000><a href='?src=[REF(src)];delete=[i]'>\[X\]</a></font><br>"

					// -- Determine race of orator --

					var/mobtype = C.parameters["mobtype"]
					var/race			   // The actual race of the mob

					if(ispath(mobtype, /mob/living/carbon/human) || ispath(mobtype, /mob/living/brain))
						race = "Humanoid"

					// NT knows a lot about slimes, but not aliens. Can identify slimes
					else if(ispath(mobtype, /mob/living/simple_animal/slime))
						race = "Slime"

					else if(ispath(mobtype, /mob/living/carbon/monkey))
						race = "Monkey"

					// sometimes M gets deleted prematurely for AIs... just check the job
					else if(ispath(mobtype, /mob/living/silicon) || C.parameters["job"] == "AI")
						race = "Artificial Life"

					else if(isobj(mobtype))
						race = "Machinery"

					else if(ispath(mobtype, /mob/living/simple_animal))
						race = "Domestic Animal"

					else
						race = "<i>Unidentifiable</i>"

					dat += "<u><font color = #18743E>Data type</font></u>: [C.input_type]<br>"
					dat += "<u><font color = #18743E>Source</font></u>: [C.parameters["name"]] (Job: [C.parameters["job"]])<br>"
					dat += "<u><font color = #18743E>Class</font></u>: [race]<br>"
					var/message = C.parameters["message"]
					var/language = C.parameters["language"]

					// based on [/atom/movable/proc/lang_treat]
					if (universal_translate || user.has_language(language))
						message = "\"[message]\""
					else if (!user.has_language(language))
						var/datum/language/D = GLOB.language_datum_instances[language]
						message = "\"[D.scramble(message)]\""
					else if (language)
						message = "<i>(unintelligible)</i>"

					dat += "<u><font color = #18743E>Contents</font></u>: [message]<br>"
					dat += "</li><br>"

				else if(C.input_type == "Execution Error")
					dat += "<li><font color = #990000>[C.name]</font>  <a href='?src=[REF(src)];delete=[i]'>\[X\]</a><br>"
					dat += "<u><font color = #787700>Error</font></u>: \"[C.parameters["message"]]\"<br>"
					dat += "</li><br>"

				else
					dat += "<li><font color = #000099>[C.name]</font>  <a href='?src=[REF(src)];delete=[i]'>\[X\]</a><br>"
					dat += "<u><font color = #18743E>Data type</font></u>: [C.input_type]<br>"
					dat += "<u><font color = #18743E>Contents</font></u>: <i>(unintelligible)</i><br>"
					dat += "</li><br>"


			dat += "</ol>"


*/
