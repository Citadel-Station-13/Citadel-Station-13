/*
	Telecomms monitor tracks the overall trafficing of a telecommunications network
	and displays a heirarchy of linked machines.
*/


/obj/machinery/computer/telecomms/monitor
	name = "telecommunications monitoring console"
	icon_screen = "comm_monitor"
	desc = "Monitors the details of the telecommunications network it's synced with."

	var/list/machinelist = list()	// the machines located by the computer
	var/obj/machinery/telecomms/SelectedMachine = null

	var/network = "NULL"		// the network to probe
	var/notice = ""

	circuit = /obj/item/circuitboard/computer/comm_monitor

/obj/machinery/computer/telecomms/monitor/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE,\
														datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)

	if(!ui)
		ui = new(user, src, ui_key, "telemonitor", name, 575, 400, master_ui, state)
		ui.open()

/obj/machinery/computer/telecomms/monitor/ui_data(mob/user)
	var/list/data_out = list()
	data_out["network"] = network
	data_out["notice"] = notice

	data_out["servers"] = list()
	for(var/obj/machinery/telecomms/T in machinelist)
		var/list/data = list(
			name = T.name,
			id = T.id,
			ref = REF(T)
		)
		data_out["servers"] += list(data)
	data_out["servers"] = sortList(data_out["servers"])
	if(!SelectedMachine) //null is bad.
		return data_out
	
	data_out["selected"] = list(
		name = SelectedMachine.name,
		id = SelectedMachine.id,
		ref = REF(SelectedMachine)
	)
	data_out["selected_servers"] = list()
	for(var/obj/machinery/telecomms/T in SelectedMachine.links)
		if(!T.hide)
			var/list/data = list(
				name = T.name,
				id = T.id,
				ref = REF(T)
			)
			data_out["selected_servers"] += list(data)

	return data_out

/obj/machinery/computer/telecomms/monitor/ui_act(action, params)
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
			
			for(var/obj/machinery/telecomms/T in urange(25, src))
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

/*
/obj/machinery/computer/telecomms/monitor/ui_interact(mob/user)
	. = ..()
	var/dat = "<TITLE>Telecommunications Monitor</TITLE><center><b>Telecommunications Monitor</b></center>"

	switch(screen)
	  // --- Main Menu ---
		if(0)
			dat += "<br>[temp]<br><br>"
			dat += "<br>Current Network: <a href='?src=[REF(src)];network=1'>[network]</a><br>"
			if(machinelist.len)
				dat += "<br>Detected Network Entities:<ul>"
				for(var/obj/machinery/telecomms/T in machinelist)
					dat += "<li><a href='?src=[REF(src)];viewmachine=[T.id]'>[REF(T)] [T.name]</a> ([T.id])</li>"
				dat += "</ul>"
				dat += "<br><a href='?src=[REF(src)];operation=release'>\[Flush Buffer\]</a>"
			else
				dat += "<a href='?src=[REF(src)];operation=probe'>\[Probe Network\]</a>"


	  // --- Viewing Machine ---

		if(1)
			dat += "<br>[temp]<br>"
			dat += "<center><a href='?src=[REF(src)];operation=mainmenu'>\[Main Menu\]</a></center>"
			dat += "<br>Current Network: [network]<br>"
			dat += "Selected Network Entity: [SelectedMachine.name] ([SelectedMachine.id])<br>"
			dat += "Linked Entities: <ol>"
			for(var/obj/machinery/telecomms/T in SelectedMachine.links)
				if(!T.hide)
					dat += "<li><a href='?src=[REF(src)];viewmachine=[T.id]'>[REF(T.id)] [T.name]</a> ([T.id])</li>"
			dat += "</ol>"



	user << browse(dat, "window=comm_monitor;size=575x400")
	onclose(user, "server_control")

	temp = ""
	return


/obj/machinery/computer/telecomms/monitor/Topic(href, href_list)
	if(..())
		return


	add_fingerprint(usr)
	usr.set_machine(src)

	if(href_list["viewmachine"])
		screen = 1
		for(var/obj/machinery/telecomms/T in machinelist)
			if(T.id == href_list["viewmachine"])
				SelectedMachine = T
				break

	if(href_list["operation"])
		switch(href_list["operation"])

			if("release")
				machinelist = list()
				screen = 0

			if("mainmenu")
				screen = 0

			if("probe")
				if(machinelist.len > 0)
					temp = "<font color = #D70B00>- FAILED: CANNOT PROBE WHEN BUFFER FULL -</font color>"

				else
					for(var/obj/machinery/telecomms/T in urange(25, src))
						if(T.network == network)
							machinelist.Add(T)

					if(!machinelist.len)
						temp = "<font color = #D70B00>- FAILED: UNABLE TO LOCATE NETWORK ENTITIES IN \[[network]\] -</font color>"
					else
						temp = "<font color = #336699>- [machinelist.len] ENTITIES LOCATED & BUFFERED -</font color>"

					screen = 0


	if(href_list["network"])

		var/newnet = stripped_input(usr, "Which network do you want to view?", "Comm Monitor", network)
		if(newnet && ((usr in range(1, src)) || hasSiliconAccessInArea(usr)))
			if(length(newnet) > 15)
				temp = "<font color = #D70B00>- FAILED: NETWORK TAG STRING TOO LENGHTLY -</font color>"

			else
				network = newnet
				screen = 0
				machinelist = list()
				temp = "<font color = #336699>- NEW NETWORK TAG SET IN ADDRESS \[[network]\] -</font color>"

	updateUsrDialog()
	return
*/
/obj/machinery/computer/telecomms/monitor/attackby()
	. = ..()
	updateUsrDialog()
