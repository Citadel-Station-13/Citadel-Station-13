/*
Tooltips v1.1 - 22/10/15
Developed by Wire (#goonstation on irc.synirc.net)
- Added support for screen_loc pixel offsets. Should work. Maybe.
- Added init function to more efficiently send base vars

Configuration:
- Set control to the correct skin element (remember to actually place the skin element)
- Set file to the correct path for the .html file (remember to actually place the html file)
- Attach the datum to the user client on login, e.g.
	/client/New()
		src.tooltips = new /datum/tooltip(src)

Usage:
- Define mouse event procs on your (probably HUD) object and simply call the show and hide procs respectively:
	/atom/movable/screen/hud
		MouseEntered(location, control, params)
			usr.client.tooltip.show(params, title = src.name, content = src.desc)

		MouseExited()
			usr.client.tooltip.hide()

Customization:
- Theming can be done by passing the theme var to show() and using css in the html file to change the look
- For your convenience some pre-made themes are included

Notes:
- You may have noticed 90% of the work is done via javascript on the client. Gotta save those cycles man.
- This is entirely untested in any other codebase besides goonstation so I have no idea if it will port nicely. Good luck!
	- After testing and discussion (Wire, Remie, MrPerson, AnturK) ToolTips are ok and work for /tg/station13
*/


/datum/tooltip
	var/client/owner
	var/control = "mainwindow.tooltip"
	var/showing = 0
	var/queueHide = 0
	var/init = 0


/datum/tooltip/New(client/C)
	if (C)
		owner = C
		var/datum/asset/stuff = get_asset_datum(/datum/asset/simple/jquery)
		stuff.send(owner)
		owner << browse(file2text('code/modules/tooltip/tooltip.html'), "window=[control]")

	..()


/datum/tooltip/proc/show(atom/movable/thing, params = null, title = null, content = null, theme = "default", special = "none")
	if (!thing || !params || (!title && !content) || !owner || !isnum(world.icon_size))
		return FALSE
	if (!init)
		//Initialize some vars
		init = 1
		owner << output(list2params(list(world.icon_size, control)), "[control]:tooltip.init")

	showing = 1

	if (title && content)
		title = "<h1>[title]</h1>"
		content = "<p>[content]</p>"
	else if (title && !content)
		title = "<p>[title]</p>"
	else if (!title && content)
		content = "<p>[content]</p>"

	// Strip macros from item names
	title = replacetext(title, "\proper", "")
	title = replacetext(title, "\improper", "")

	//Make our dumb param object
	params = {"{ "cursor": "[params]", "screenLoc": "[thing.screen_loc]" }"}

	//Send stuff to the tooltip
	var/view_size = getviewsize(owner.view)
	owner << output(list2params(list(params, view_size[1] , view_size[2], "[title][content]", theme, special)), "[control]:tooltip.update")

	//If a hide() was hit while we were showing, run hide() again to avoid stuck tooltips
	showing = 0
	if (queueHide)
		hide()

	return TRUE


/datum/tooltip/proc/hide()
	queueHide = showing ? TRUE : FALSE

	if (queueHide)
		addtimer(CALLBACK(src, PROC_REF(do_hide)), 1)
	else
		do_hide()

	return TRUE

/datum/tooltip/proc/do_hide()
	winshow(owner, control, FALSE)

/* TG SPECIFIC CODE */


//Open a tooltip for user, at a location based on params
//Theme is a CSS class in tooltip.html, by default this wrapper chooses a CSS class based on the user's UI_style (Midnight, Plasmafire, Retro, etc)
//Includes sanity.checks
/proc/openToolTip(mob/user = null, atom/movable/tip_src = null, params = null,title = "",content = "",theme = "")
	if(istype(user))
		if(user.client && user.client.tooltips)
			if(!theme && user.client.prefs && user.client.prefs.UI_style)
				theme = lowertext(user.client.prefs.UI_style)
			if(!theme)
				theme = "default"
			user.client.tooltips.show(tip_src, params,title,content,theme)


//Arbitrarily close a user's tooltip
//Includes sanity checks.
/proc/closeToolTip(mob/user)
	if(istype(user))
		if(user.client && user.client.tooltips)
			user.client.tooltips.hide()
			deltimer(user.client.tip_timer) //delete any in-progress timer if the mouse is moved off the item before it finishes
			user.client.tip_timer = null

/**
 * If set, will return a list for the tooltip (that will also be put together in a `Join()`)
 * However, if returning `null`, the tooltip will not be shown as #14942 changed it.
 *
 * Though no tooltips will be created for atoms that have `tooltips = FALSE`
*/
/atom/movable/proc/get_tooltip_data()
	return // i did not ask you to create a list, this shit is meant to be overriden

/atom/movable/MouseEntered(location, control, params)
	. = ..()
	if(tooltips)
		if(!QDELETED(usr) && !QDELETED(src) && usr?.client?.prefs.enable_tips)
			var/list/tooltip_data = get_tooltip_data()
			if(length(tooltip_data))
				var/examine_data = tooltip_data.Join("<br />")
				var/timedelay = max(usr.client.prefs.tip_delay * 0.01, 0.01) // I heard multiplying is faster, also runtimes from very low/negative numbers
				usr.client.tip_timer = addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(openToolTip), usr, src, params, name, examine_data), timedelay, TIMER_STOPPABLE)//timer takes delay in deciseconds, but the pref is in milliseconds. multiplying by 0.01 converts it.

/atom/movable/MouseExited(location, control, params)
	. = ..()
	closeToolTip(usr)

/client/MouseDown(object, location, control, params)
	. = ..()
	closeToolTip(usr)

// Break my stuff again and i'll kill you, kisses
