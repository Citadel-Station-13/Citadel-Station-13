/**
  * Stat browser system
  * Since stat() is laggy and we can't wait for tgui embedded chat
  */
/client
	/// Tgui window of our stat browser
	var/datum/tgui_window/stat_tgui_window
	/// The actual tgui datum we have/use for stat browser.
	var/datum/tgui/embedded/statbrowser/stat_tgui

/client/Destroy()
	. = ..()
	if(stat_tgui)
		stat_tgui.close()
		if(!QDELETED(stat_tgui))
			qdel(stat_tgui)
		stat_tgui = null
	if(stat_tgui_window)
		QDEL_NULL(stat_tgui_window)

/client/proc/setup_statbrowser()
	if(!stat_tgui_window)
		stat_tgui_window = new(src, "statbrowser", FALSE, "statbrowser_window.statbrowser", "")
		// jank ass
		tgui_windows["statbrowser"] = stat_tgui_window
	if(!stat_tgui)
		stat_tgui = new(mob, src, "ClientStatBrowser")
		stat_tgui.fixed_window = TRUE
		stat_tgui.no_titlebar = TRUE
	else
		stat_tgui.user = mob
		stat_tgui.close(qdel_self = FALSE)
	stat_tgui.set_autoupdate(FALSE)
	winset(src, "statbrowser", "is-visible=true")
	stat_tgui.open(stat_tgui_window)

/client/verb/reassert_statbrowser()
	set name = "Fix Statbrowser"
	set category = "OOC"
	set desc = "Forcefully reload the Information statbrowser."
	
	setup_statbrowser()

/client/ui_status()
	return UI_INTERACTIVE

/client/ui_data()
	return tguiStat()

/**
  * Statpanel data
  */
/client/proc/tguiStat()
	.["admin"] = holder? TRUE : FALSE
	var/atom/A = src.statobj
	. |= A.tguiStat()

/atom/proc/tguiStat()
	return list()

/datum/tgui/embedded
	fixed_window = TRUE
	no_titlebar = TRUE

/datum/tgui/embedded/statbrowser
	var/client/our_client

/datum/tgui/embedded/statbrowser/New(mob/user, datum/src_object, interface, title, ui_x, ui_y)
	. = ..()
	ASSERT(istype(src_object, /client))
	our_client = src_object

/datum/tgui/embedded/statbrowser/Destroy()
	our_client.stat_tgui = null
	return ..()
