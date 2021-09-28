/**
 * Creates a TGUI window to input a list of variables.
 *
 * Currently supported types:
 * VV_TEXT
 * VV_NUM
 *
 * Arguments:
 * * user - The user to show the input box to.
 * * message - The content of the input box, shown in the body of the TGUI window.
 * * title - The title of the input box, shown on the top of the TGUI window.
 * * variables - Names of the variables associated to their type
 * * timeout - The timeout of the input box, after which the input box will close and qdel itself. Set to zero for no timeout.
 */
/proc/tgui_input_varlist(mob/user, message, title, list/variables, timeout = 0)
	if(!user)
		user = usr
	if(!length(variables))
		return
	if(!istype(user))
		if(istype(user, /client))
			var/client/client = user
			user = client.mob
			if(!istype(user))
				return
		else
			return
	var/datum/tgui_varlist_input/input = new(user, message, title, variables, timeout)
	input.ui_interact(user)
	input.wait()
	if(input)
		. = input.choices
		qdel(input)

#warn finish this file


/**
 * Creates an asynchronous TGUI window to input a list of variables with an associated callback.
 *
 * Currently supported types:
 * VV_TEXT
 * VV_NUM
 *
 * Arguments:
 * * user - The user to show the input box to.
 * * message - The content of the input box, shown in the body of the TGUI window.
 * * title - The title of the input box, shown on the top of the TGUI window.
 * * variables - Names of the variables associated to their type
 * * callback - The callback to call when a choice is made.
 * * timeout - The timeout of the input box, after which the input box will close and qdel itself. Set to zero for no timeout.
 */
/proc/tgui_input_varlist_async(mob/user, message, title, list/variables, datum/callback/callback, timeout = 60 SECONDS)
	if(!user)
		user = usr
	if(!length(variables))
		return
	if(!istype(user))
		if(istype(user, /client))
			var/client/client = user
			user = client.mob
			if(!istype(user))
				return
		else
			return
	var/datum/tgui_varlist_input/input = new(user, message, title, variables, callback, timeout)
	input.ui_interact(user)

/**
 * # tgui_varlist_input
 *
 * Datum used for instantiating and using a TGUI-controlled list input that prompts the user with
 * a message and shows a list of variables to input.
 *
 * The variables use VV_get_class typing, currently supporting numbers and text.
 */
/datum/tgui_varlist_input
	/// The title of the TGUI window
	var/title
	/// The textual body of the TGUI window
	var/message
	/// the variables we hold - associated to a VV class
	var/list/variables
	/// the final chosen variables if any
	var/list/choices
	/// The time at which the tgui_varlist_input was created, for displaying timeout progress.
	var/start_time
	/// The lifespan of the tgui_varlist_input, after which the window will close and delete itself.
	var/timeout
	/// Boolean field describing if the tgui_varlist_input was closed by the user.
	var/closed

/datum/tgui_varlist_input/New(mob/user, message, title, list/variables, timeout)
	src.title = title
	src.message = message
	src.buttons = list()
	src.buttons_map = list()

	// Gets rid of illegal characters
	var/static/regex/whitelistedWords = regex(@{"([^\u0020-\u8000]+)"})

	for(var/i in buttons)
		var/string_key = whitelistedWords.Replace("[i]", "")

		src.buttons += string_key
		src.buttons_map[string_key] = i


	if (timeout)
		src.timeout = timeout
		start_time = world.time
		QDEL_IN(src, timeout)

/datum/tgui_varlist_input/Destroy(force, ...)
	SStgui.close_uis(src)
	QDEL_NULL(buttons)
	. = ..()

/**
 * Waits for a user's response to the tgui_varlist_input's prompt before returning. Returns early if
 * the window was closed by the user.
 */
/datum/tgui_varlist_input/proc/wait()
	while (!choice && !closed)
		stoplag(1)

/datum/tgui_varlist_input/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VarListInput")
		ui.open()

/datum/tgui_varlist_input/ui_close(mob/user)
	. = ..()
	closed = TRUE

/datum/tgui_varlist_input/ui_state(mob/user)
	return GLOB.always_state

/datum/tgui_varlist_input/ui_static_data(mob/user)
	. = list(
		"title" = title,
		"message" = message,
		"buttons" = buttons
	)

/datum/tgui_varlist_input/ui_data(mob/user)
	. = list()
	if(timeout)
		.["timeout"] = clamp((timeout - (world.time - start_time) - 1 SECONDS) / (timeout - 1 SECONDS), 0, 1)

/datum/tgui_varlist_input/ui_act(action, list/params)
	. = ..()
	if (.)
		return
	switch(action)
		if("submit")

		if("modify")

		if("cancel")
			SStgui.close_uis(src)
			closed = TRUE
			return TRUE

/**
 * # async tgui_varlist_input
 *
 * An asynchronous version of tgui_varlist_input to be used with callbacks instead of waiting on user responses.
 */
/datum/tgui_varlist_input/async
	/// The callback to be invoked by the tgui_varlist_input upon having a choice made.
	var/datum/callback/callback

/datum/tgui_varlist_input/async/New(mob/user, message, title, list/variables, callback, timeout)
	..(user, title, message, variables, timeout)
	src.callback = callback

/datum/tgui_varlist_input/async/Destroy(force, ...)
	QDEL_NULL(callback)
	. = ..()

/datum/tgui_varlist_input/async/ui_close(mob/user)
	. = ..()
	qdel(src)

/datum/tgui_varlist_input/async/ui_act(action, list/params)
	. = ..()
	if (!. || choice == null)
		return
	callback.InvokeAsync(choice)
	qdel(src)

/datum/tgui_varlist_input/async/wait()
	return
