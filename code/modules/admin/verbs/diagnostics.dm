/proc/show_air_status_to(turf/target, mob/user)
	var/datum/gas_mixture/env = target.return_air()
	var/burning = FALSE
	if(isopenturf(target))
		var/turf/open/T = target
		if(T.active_hotspot)
			burning = TRUE

	var/list/lines = list("<span class='adminnotice'>[AREACOORD(target)]: [env.return_temperature()] K ([env.return_temperature() - T0C] C), [env.return_pressure()] kPa[(burning)?(", <font color='red'>burning</font>"):(null)]</span>")
	for(var/id in env.get_gases())
		var/moles = env.get_moles(id)
		if (moles >= 0.00001)
			lines += "[GLOB.gas_data.names[id]]: [moles] mol"
	to_chat(usr, lines.Join("\n"))

/client/proc/air_status(turf/target)
	set category = "Debug"
	set name = "Display Air Status"

	if(!isturf(target))
		return
	show_air_status_to(target, usr)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Show Air Status") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/radio_report()
	set category = "Debug"
	set name = "Radio report"

	var/output = "<b>Radio Report</b><hr>"
	for (var/fq in SSradio.frequencies)
		output += "<b>Freq: [fq]</b><br>"
		var/datum/radio_frequency/fqs = SSradio.frequencies[fq]
		if (!fqs)
			output += "&nbsp;&nbsp;<b>ERROR</b><br>"
			continue
		for (var/filter in fqs.devices)
			var/list/f = fqs.devices[filter]
			if (!f)
				output += "&nbsp;&nbsp;[filter]: ERROR<br>"
				continue
			output += "&nbsp;&nbsp;[filter]: [f.len]<br>"
			for (var/device in f)
				if (istype(device, /atom))
					var/atom/A = device
					output += "&nbsp;&nbsp;&nbsp;&nbsp;[device] ([AREACOORD(A)])<br>"
				else
					output += "&nbsp;&nbsp;&nbsp;&nbsp;[device]<br>"

	usr << browse(output,"window=radioreport")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Show Radio Report") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/reload_admins()
	set name = "Reload Admins"
	set category = "Admin"

	if(!src.holder)
		return

	var/confirm = alert(src, "Are you sure you want to reload all admins?", "Confirm", "Yes", "No")
	if(confirm !="Yes")
		return

	load_admins()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Reload All Admins") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	message_admins("[key_name_admin(usr)] manually reloaded admins")

/client/proc/toggle_cdn()
	set name = "Toggle CDN"
	set category = "Server"
	var/static/admin_disabled_cdn_transport = null
	if (alert(usr, "Are you sure you want to toggle the CDN asset transport?", "Confirm", "Yes", "No") != "Yes")
		return
	var/current_transport = CONFIG_GET(string/asset_transport)
	if (!current_transport || current_transport == "simple")
		if (admin_disabled_cdn_transport)
			CONFIG_SET(string/asset_transport, admin_disabled_cdn_transport)
			admin_disabled_cdn_transport = null
			SSassets.OnConfigLoad()
			message_admins("[key_name_admin(usr)] re-enabled the CDN asset transport")
			log_admin("[key_name(usr)] re-enabled the CDN asset transport")
		else
			to_chat(usr, "<span class='adminnotice'>The CDN is not enabled!</span>")
			if (alert(usr, "The CDN asset transport is not enabled! If you having issues with assets you can also try disabling filename mutations.", "The CDN asset transport is not enabled!", "Try disabling filename mutations", "Nevermind") == "Try disabling filename mutations")
				SSassets.transport.dont_mutate_filenames = !SSassets.transport.dont_mutate_filenames
				message_admins("[key_name_admin(usr)] [(SSassets.transport.dont_mutate_filenames ? "disabled" : "re-enabled")] asset filename transforms")
				log_admin("[key_name(usr)] [(SSassets.transport.dont_mutate_filenames ? "disabled" : "re-enabled")] asset filename transforms")
	else
		admin_disabled_cdn_transport = current_transport
		CONFIG_SET(string/asset_transport, "simple")
		SSassets.OnConfigLoad()
		SSassets.transport.dont_mutate_filenames = TRUE
		message_admins("[key_name_admin(usr)] disabled the CDN asset transport")
		log_admin("[key_name(usr)] disabled the CDN asset transport")
