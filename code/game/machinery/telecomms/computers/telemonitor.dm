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

/obj/machinery/computer/telecomms/monitor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)

	if(!ui)
		ui = new(user, src, "TelecommsMonitor", name)
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
	data_out["servers"] = sort_list(data_out["servers"])

	if(!SelectedMachine) //null is bad.
		data_out["selected"] = null //but in js, null is good.
		return data_out

	data_out["selected"] = list(
		name = SelectedMachine.name,
		id = SelectedMachine.id,
		status = SelectedMachine.on,
		traffic = SelectedMachine.traffic,
		netspeed = SelectedMachine.netspeed,
		freq_listening = SelectedMachine.freq_listening,
		long_range_link = SelectedMachine.long_range_link,
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

			for(var/obj/machinery/telecomms/T in GLOB.telecomms_list)
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
