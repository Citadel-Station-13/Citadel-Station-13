
/*

	All telecommunications interactions:

*/

/obj/machinery/telecomms
	var/temp = "" // output message

/obj/machinery/telecomms/attackby(obj/item/P, mob/user, params)
	var/icon_closed = initial(icon_state)
	var/icon_open = "[initial(icon_state)]_o"
	
	if(!on)
		icon_closed = "[initial(icon_state)]_off"
		icon_open = "[initial(icon_state)]_o_off"

	if(default_deconstruction_screwdriver(user, icon_open, icon_closed, P))
		return
	// Using a multitool lets you access the receiver's interface
	else if(istype(P, /obj/item/multitool))
		attack_hand(user)

	else if(default_deconstruction_crowbar(P))
		return
	else
		return ..()

/obj/machinery/telecomms/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE,\
									datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	if(!canInteract(user))
		if(ui)
			ui.close() //haha no.
		return
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)

	if(!ui)
		ui = new(user, src, ui_key, "teleinteract", "[name] Access", 520, 500, master_ui, state)
		ui.open()

/obj/machinery/telecomms/ui_data(mob/user)
	. = list() //cpypaste from the vending bus
	.["notice"] = temp
	
	var/obj/item/multitool/P = get_multitool(user)
	if(P)
		.["multitool"] = TRUE
		var/obj/machinery/telecomms/T = P.buffer
		if(istype(T))
			.["multitool_buf"] = list(
				name = T.name,
				id = T.id
			)

	.["machine"] = list()
	.["machine"]["power"] = toggled
	.["machine"]["id"] = id
	.["machine"]["network"] = network
	.["machine"]["prefab"] = LAZYLEN(autolinkers) ? TRUE : FALSE
	.["machine"]["hidden"] = hide

	.["links"] = list()
	for(var/obj/machinery/telecomms/T in links)
		if(T.hide && !hide)
			continue
		var/list/data = list(
			name = T.name,
			id = T.id,
			ref = REF(T)
		)
		.["links"] += list(data)

	.["freq_listening"] = freq_listening

/obj/machinery/telecomms/relay/ui_data(mob/user)
	. = ..()
	.["machine"]["isrelay"] = TRUE
	.["machine"]["broadcast"] = broadcasting
	.["machine"]["receiving"] = receiving

/obj/machinery/telecomms/bus/ui_data(mob/user)
	. = ..()
	.["machine"]["isbus"] = TRUE
	.["machine"]["chang_frequency"] = change_frequency
	.["machine"]["chang_freq_value"] = change_freq_value

/obj/machinery/telecomms/ui_act(action, params, datum/tgui/ui)
	if(!canInteract(usr))
		if(ui)
			ui.close() //haha no.
		return
	temp = ""

	switch(action)
		if("toggle")
			toggled = !toggled
			temp = "-% [src.name] has been [toggled ? "activated" : "deactivated"]. %-"
			update_power()
			return
		if("machine")
			if("id" in params)
				if(!canAccess(usr))
					return
				//if the text is blank, return the id it was using
				var/newid = sanitize_text(reject_bad_text(params["id"]), id) // reject_bad_text can return null!
				if(length(newid) > 255)
					temp = "-% Too many characters in new id tag. %-"
					return
				temp = "-% New ID assigned: \"[newid]\". %-"
				id = newid
				return
			if("network" in params)
				if(!canAccess(usr))
					return
				var/newnet = sanitize(sanitize_text(params["value"], network))	
				if(length(newnet) > 15)
					temp = "-% Too many characters in new network tag. %-"
					return
				network = newnet
				links = list()
				temp = "-% New network tag assigned: \"[network]\" %-"
				return
		if("multitool")
			var/obj/item/multitool/P = get_multitool(usr)
			if("Link" in params)
				if(!canAccess(usr))
					return
				if(!istype(P))
					temp = "-% Unable to acquire buffer %-"
					return
				
				var/obj/machinery/telecomms/T = P.buffer
				if(!istype(T) || T == src)
					temp = "-% Unable to acquire buffer %-"
					return
				
				if(!(src in T.links))
					LAZYADD(T.links, src)

				if(!(T in links))
					LAZYADD(links, T)
				temp = "-% Successfully linked with [REF(T)] [T.name] %-"

			if("Flush" in params)
				if(!istype(P))
					temp = "-% Unable to acquire multitool %-"
					return

				temp = "-% Buffer successfully flushed. %-"
				P.buffer = null

			if("Add" in params)
				if(!canAccess(usr))
					return
				if(!istype(P))
					temp = "-% Unable to acquire multitool %-"
					return

				P.buffer = src
				temp = "% Successfully stored [REF(P.buffer)] [P.buffer.name] in buffer %-"

		if("unlink")
			var/obj/machinery/telecomms/T = locate(params["value"])
			if(!canAccess(usr))
				return
			if(!istype(T))
				temp = "-% Unable to locate machine to unlink from, try again. %-"
				return
			
			temp = "-% Removed [REF(T)] [T.name] from linked entities. %-"
			if(T.links) //lazyrem makes blank list null, which is good but some might cause runtime ee's
				T.links.Remove(src)
			links.Remove(T)
		if("freq")
			if("add" in params)
				var/newfreq = input("Specify a new frequency to filter (GHz). Decimals assigned automatically.", src.name, null) as null|num
				if(!canAccess(usr) || !newfreq || isnull(newfreq))
					return

				if(findtext(num2text(newfreq), ".")) // did they not read the text?
					newfreq *= 10 // shift the decimal one place

				newfreq = sanitize_frequency(newfreq, TRUE) //sanitize
				if(newfreq == FREQ_SYNDICATE)
					temp = "-% Error: Interference preventing filtering frequency: \"[newfreq] GHz\" %-"
					return
				if(newfreq in freq_listening)
					temp = "-% Error: Frequency already filtered %-"
					return

				LAZYADD(freq_listening, newfreq)
				temp = "<font color = #666633>-% New frequency filter assigned: \"[newfreq] GHz\" %-</font color>"

			if("remove" in params)
				if(!canAccess(usr))
					return
				var/x = text2num(params["remove"])
				temp = "-% Removed frequency filter [x] %-"
				freq_listening.Remove(x)
	
/obj/machinery/telecomms/relay/ui_act(action, params)
	..()
	switch(action)
		if("relay")
			if("broadcast" in params)
				if(!canAccess(usr))
					return
				broadcasting = !broadcasting
				temp = "-% Broadcasting mode changed. %-"
				return
			if("receiving" in params)
				if(!canAccess(usr))
					return
				receiving = !receiving
				temp = "-% Receiving mode changed. %-"

/obj/machinery/telecomms/bus/ui_act(action, params)
	..()
	switch(action)
		if("frequency")
			if("toggle" in params)
				if(!canAccess(usr))
					return
				change_frequency = !change_frequency
				return
			if("adjust" in params)
				var/newfreq = params["adjust"]
				if(!canAccess(usr) || !newfreq)
					return
				// this should return true, unless the href is handcrafted
				if(findtext(num2text(newfreq), "."))
					newfreq *= 10 // shift the decimal one place

				newfreq = sanitize_frequency(newfreq, TRUE)
				if(newfreq == FREQ_SYNDICATE)
					temp = "-% Error: Interference preventing filtering frequency: \"[newfreq] GHz\" %-"
					return

				change_freq_value = newfreq
				temp = "-% New frequency to change to assigned: \"[newfreq] GHz\" %-"
				return

// Check if the user can use it.
/obj/machinery/telecomms/proc/canInteract(mob/user)
	if(hasSiliconAccessInArea(user) || istype(user.get_active_held_item(), /obj/item/multitool))
		return TRUE
	return FALSE
// Check if the user is nearby and has a multitool.
/obj/machinery/telecomms/proc/canAccess(mob/user)
	if(canInteract(user) && in_range(user, src))
		return TRUE
	return FALSE

// Returns a multitool from a user depending on their mobtype.
/obj/machinery/telecomms/proc/get_multitool(mob/user)
	if(!canInteract(user))
		return null
	var/obj/item/multitool/P = user.get_active_held_item()
	// Is the ref not a null? and is it the actual type?
	if(istype(P))
		return P
	else if(isAI(user))
		var/mob/living/silicon/ai/U = user
		P = U.aiMulti
	else if(iscyborg(user) && in_range(user, src))
		if(istype(user.get_active_held_item(), /obj/item/multitool))
			P = user.get_active_held_item()
	return P

/*
/obj/machinery/telecomms/ui_interact(mob/user)
	. = ..()
	// You need a multitool to use this, or be silicon
	if(!hasSiliconAccessInArea(user))
		// istype returns false if the value is null
		if(!istype(user.get_active_held_item(), /obj/item/multitool))
			return
	var/obj/item/multitool/P = get_multitool(user)
	var/dat
	dat = "<font face = \"Courier\"><HEAD><TITLE>[name]</TITLE></HEAD><center><H3>[name] Access</H3></center>"
	dat += "<br>[temp]<br>"
	dat += "<br>Power Status: <a href='?src=[REF(src)];input=toggle'>[toggled ? "On" : "Off"]</a>"
	if(on && toggled)
		if(id != "" && id)
			dat += "<br>Identification String: <a href='?src=[REF(src)];input=id'>[id]</a>"
		else
			dat += "<br>Identification String: <a href='?src=[REF(src)];input=id'>NULL</a>"
		dat += "<br>Network: <a href='?src=[REF(src)];input=network'>[network]</a>"
		dat += "<br>Prefabrication: [autolinkers.len ? "TRUE" : "FALSE"]"
		if(hide)
			dat += "<br>Shadow Link: ACTIVE</a>"

		//Show additional options for certain machines.
		dat += Options_Menu()

		dat += "<br>Linked Network Entities: <ol>"

		var/i = 0
		for(var/obj/machinery/telecomms/T in links)
			i++ //ARGH, USE LOCATE YOU DEGENERADES
			if(T.hide && !hide)
				continue
			dat += "<li>[REF(T)] [T.name] ([T.id])  <a href='?src=[REF(src)];unlink=[i]'>\[X\]</a></li>"
		dat += "</ol>"

		dat += "<br>Filtering Frequencies: "

		i = 0
		if(length(freq_listening))
			for(var/x in freq_listening)
				i++
				if(i < length(freq_listening))
					dat += "[format_frequency(x)] GHz<a href='?src=[REF(src)];delete=[x]'>\[X\]</a>; "
				else
					dat += "[format_frequency(x)] GHz<a href='?src=[REF(src)];delete=[x]'>\[X\]</a>"
		else
			dat += "NONE"

		dat += "<br>  <a href='?src=[REF(src)];input=freq'>\[Add Filter\]</a>"
		dat += "<hr>"

		if(P)
			var/obj/machinery/telecomms/T = P.buffer
			if(istype(T))
				dat += "<br><br>MULTITOOL BUFFER: [T] ([T.id]) <a href='?src=[REF(src)];link=1'>\[Link\]</a> <a href='?src=[REF(src)];flush=1'>\[Flush\]"
			else
				dat += "<br><br>MULTITOOL BUFFER: <a href='?src=[REF(src)];buffer=1'>\[Add Machine\]</a>"

	dat += "</font>"
	temp = ""
	user << browse(dat, "window=tcommachine;size=520x500;can_resize=0")
	onclose(user, "tcommachine")
	return TRUE

// Additional Options for certain machines. Use this when you want to add an option to a specific machine.
// Example of how to use below.

/obj/machinery/telecomms/proc/Options_Menu()
	return ""

// The topic for Additional Options. Use this for checking href links for your specific option.
// Example of how to use below.
/obj/machinery/telecomms/proc/Options_Topic(href, href_list)
	return

// RELAY

/obj/machinery/telecomms/relay/Options_Menu()
	var/dat = ""
	dat += "<br>Broadcasting: <A href='?src=[REF(src)];broadcast=1'>[broadcasting ? "YES" : "NO"]</a>"
	dat += "<br>Receiving:    <A href='?src=[REF(src)];receive=1'>[receiving ? "YES" : "NO"]</a>"
	return dat

/obj/machinery/telecomms/relay/Options_Topic(href, href_list)

	if(href_list["receive"])
		receiving = !receiving
		temp = "<font color = #666633>-% Receiving mode changed. %-</font color>"
	if(href_list["broadcast"])
		broadcasting = !broadcasting
		temp = "<font color = #666633>-% Broadcasting mode changed. %-</font color>"

// BUS

/obj/machinery/telecomms/bus/Options_Menu()
	var/dat = "<br>Change Signal Frequency: <A href='?src=[REF(src)];change_freq=1'>[change_frequency ? "YES ([change_frequency])" : "NO"]</a>"
	return dat

/obj/machinery/telecomms/bus/Options_Topic(href, href_list)

	if(href_list["change_freq"])

		var/newfreq = input(usr, "Specify a new frequency for new signals to change to. Enter null to turn off frequency changing. Decimals assigned automatically.", src, network) as null|num
		if(canAccess(usr))
			if(newfreq)
				if(findtext(num2text(newfreq), "."))
					newfreq *= 10 // shift the decimal one place
				if(newfreq < 10000)
					change_frequency = newfreq
					temp = "<font color = #666633>-% New frequency to change to assigned: \"[newfreq] GHz\" %-</font color>"
			else
				change_frequency = 0
				temp = "<font color = #666633>-% Frequency changing deactivated %-</font color>"


/obj/machinery/telecomms/Topic(href, href_list)
	if(..())
		return

	if(!hasSiliconAccessInArea(usr))
		if(!istype(usr.get_active_held_item(), /obj/item/multitool))
			return

	var/obj/item/multitool/P = get_multitool(usr)

	if(href_list["input"])
		switch(href_list["input"])

			if("toggle")

				toggled = !toggled
				temp = "<font color = #666633>-% [src] has been [toggled ? "activated" : "deactivated"].</font color>"
				update_power()


			if("id")
				var/newid = reject_bad_text(stripped_input(usr, "Specify the new ID for this machine", src, id, MAX_MESSAGE_LEN))
				if(newid && canAccess(usr))
					id = newid
					temp = "<font color = #666633>-% New ID assigned: \"[id]\" %-</font color>"

			if("network")
				var/newnet = stripped_input(usr, "Specify the new network for this machine. This will break all current links.", src, network)
				if(newnet && canAccess(usr))

					if(length(newnet) > 15)
						temp = "<font color = #666633>-% Too many characters in new network tag %-</font color>"

					else
						for(var/obj/machinery/telecomms/T in links)
							T.links.Remove(src)

						network = newnet
						links = list()
						temp = "<font color = #666633>-% New network tag assigned: \"[network]\" %-</font color>"


			if("freq")
				var/newfreq = input(usr, "Specify a new frequency to filter (GHz). Decimals assigned automatically.", src, network) as null|num
				if(newfreq && canAccess(usr))
					if(findtext(num2text(newfreq), "."))
						newfreq *= 10 // shift the decimal one place
					if(newfreq == FREQ_SYNDICATE)
						temp = "<font color = #FF0000>-% Error: Interference preventing filtering frequency: \"[newfreq] GHz\" %-</font color>"
					else
						if(!(newfreq in freq_listening) && newfreq < 10000)
							freq_listening.Add(newfreq)
							temp = "<font color = #666633>-% New frequency filter assigned: \"[newfreq] GHz\" %-</font color>"

	if(href_list["delete"])

		// changed the layout about to workaround a pesky runtime -- Doohl

		var/x = text2num(href_list["delete"])
		temp = "<font color = #666633>-% Removed frequency filter [x] %-</font color>"
		freq_listening.Remove(x)

	if(href_list["unlink"])

		if(text2num(href_list["unlink"]) <= length(links))
			var/obj/machinery/telecomms/T = links[text2num(href_list["unlink"])]
			if(T)
				temp = "<font color = #666633>-% Removed [REF(T)] [T.name] from linked entities. %-</font color>"

				// Remove link entries from both T and src.

				if(T.links)
					T.links.Remove(src)
				links.Remove(T)

			else
				temp = "<font color = #666633>-% Unable to locate machine to unlink from, try again. %-</font color>"

	if(href_list["link"])

		if(P)
			var/obj/machinery/telecomms/T = P.buffer
			if(istype(T) && T != src)
				if(!(src in T.links))
					T.links += src

				if(!(T in links))
					links += T

				temp = "<font color = #666633>-% Successfully linked with [REF(T)] [T.name] %-</font color>"

			else
				temp = "<font color = #666633>-% Unable to acquire buffer %-</font color>"

	if(href_list["buffer"])

		P.buffer = src
		temp = "<font color = #666633>-% Successfully stored [REF(P.buffer)] [P.buffer.name] in buffer %-</font color>"


	if(href_list["flush"])

		temp = "<font color = #666633>-% Buffer successfully flushed. %-</font color>"
		P.buffer = null

	Options_Topic(href, href_list)

	usr.set_machine(src)

	updateUsrDialog()
*/

