/**
  * Stat browser system
  * Since stat() is laggy and we can't wait for tgui embedded chat
  */
/client
	var/datum/tgui/statbrowser/stat_tgui

/client/Destroy()
	. = ..()
	QDEL_NULL(stat_tgui)

/client/proc/setup_statbrowser()
	stat_tgui = new(mob, src, "STATBROWSER", "ClientStatBrowser")
	stat_tgui.window_id = "statbrowser"
	stat_tgui.open()

/client/proc/refresh_statbrowser()
	if(!stat_tgui)
		setup_statbrowser()
	stat_tgui.user = mob

/client/ui_data()
	. = list()

/client/ui_static_data()
	. = list()

/datum/tgui/statbrowser
	var/client/our_client

/datum/tgui/statbrowser/Destroy()
	our_client.stat_tgui = null
	return ..()
