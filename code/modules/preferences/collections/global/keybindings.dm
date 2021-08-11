/datum/preferences_collection/global/keybindings
	save_key = PREFERENCES_SAVE_KEY_KEYBINDINGS
	sort_order = 2

/datum/preferences_collection/global/keybindings/content(datum/preferences/prefs)
	. = ..()
	var/hotkeys = LoadKey(prefs, "hotkeys")
	var/list/key_bindings = LoadKey(prefs, "keybinds")
	var/list/modless_key_bindings = LoadKey(prefs, "keybinds_modless")
	. += "<b>Keybindings:</b> <a href='?src=[REF(src)];parent=[REF(prefs)];preference=hotkeys'>[(hotkeys) ? "Hotkeys" : "Input"]</a><br>"
	. += "Keybindings mode controls how the game behaves with tab and map/input focus.<br>If it is on <b>Hotkeys</b>, the game will always attempt to force you to map focus, meaning keypresses are sent \
	directly to the map instead of the input. You will still be able to use the command bar, but you need to tab to do it every time you click on the game map.<br>\
	If it is on <b>Input</b>, the game will not force focus away from the input bar, and you can switch focus using TAB between these two modes: If the input bar is pink, that means that you are in non-hotkey mode, sending all keypresses of the normal \
	alphanumeric characters, punctuation, spacebar, backspace, enter, etc, typing keys into the input bar. If the input bar is white, you are in hotkey mode, meaning all keypresses go into the game's keybind handling system unless you \
	manually click on the input bar to shift focus there.<br>\
	Input mode is the closest thing to the old input system.<br>\
	<b>IMPORTANT:</b> While in input mode's non hotkey setting (tab toggled), Ctrl + KEY will send KEY to the keybind system as the key itself, not as Ctrl + KEY. This means Ctrl + T/W/A/S/D/all your familiar stuff still works, but you \
	won't be able to access any regular Ctrl binds.<br>"
	. += "<br><b>Modifier-Independent binding</b> - This is a singular bind that works regardless of if Ctrl/Shift/Alt are held down. For example, if combat mode is bound to C in modifier-independent binds, it'll trigger regardless of if you are \
	holding down shift for sprint. <b>Each keybind can only have one independent binding, and each key can only have one keybind independently bound to it.</b>"
	// Create an inverted list of keybindings -> key
	var/list/user_binds = list()
	var/list/user_modless_binds = list()
	for (var/key in key_bindings)
		for(var/kb_name in key_bindings[key])
			user_binds[kb_name] += list(key)
	for (var/key in modless_key_bindings)
		user_modless_binds[modless_key_bindings[key]] = key

	var/list/kb_categories = list()
	// Group keybinds by category
	for (var/name in GLOB.keybindings_by_name)
		var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
		kb_categories[kb.category] += list(kb)

	. += {"
	<style>
	span.bindname { display: inline-block; position: absolute; width: 20% ; left: 5px; padding: 5px; } \
	span.bindings { display: inline-block; position: relative; width: auto; left: 20%; width: auto; right: 20%; padding: 5px; } \
	span.independent { display: inline-block; position: absolute; width: 20%; right: 5px; padding: 5px; } \
	</style><body>
	"}

	for (var/category in kb_categories)
		. += "<h3>[category]</h3>"
		for (var/i in kb_categories[category])
			var/datum/keybinding/kb = i
			var/current_independent_binding = user_modless_binds[kb.name] || "Unbound"
			if(!length(user_binds[kb.name]))
				. += "<span class='bindname'>[kb.full_name]</span><span class='bindings'><a href ='?src=[REF(src)];parent=[REF(prefs)];preference=keybind_capture;keybinding=[kb.name];old_key=["Unbound"]'>Unbound</a>"
				var/list/default_keys = hotkeys ? kb.hotkey_keys : kb.classic_keys
				if(LAZYLEN(default_keys))
					. += "| Default: [default_keys.Join(", ")]"
				. += "</span>"
				if(!kb.special && !kb.clientside)
					. += "<span class='independent'>Independent Binding: <a href='?src=[REF(src)];parent=[REF(prefs)];preference=keybind_capture;keybinding=[kb.name];old_key=[current_independent_binding];independent=1'>[current_independent_binding]</a></span>"
				. += "<br>"
			else
				var/bound_key = user_binds[kb.name][1]
				. += "<span class='bindname'l>[kb.full_name]</span><span class='bindings'><a href ='?src=[REF(src)];parent=[REF(prefs)];preference=keybind_capture;keybinding=[kb.name];old_key=[bound_key]'>[bound_key]</a>"
				for(var/bound_key_index in 2 to length(user_binds[kb.name]))
					bound_key = user_binds[kb.name][bound_key_index]
					. += " | <a href ='?src=[REF(src)];parent=[REF(prefs)];preference=keybind_capture;keybinding=[kb.name];old_key=[bound_key]'>[bound_key]</a>"
				if(length(user_binds[kb.name]) < MAX_KEYS_PER_KEYBIND)
					. += "| <a href ='?src=[REF(src)];parent=[REF(prefs)];preference=keybind_capture;keybinding=[kb.name]'>Add Secondary</a>"
				var/list/default_keys = hotkeys ? kb.classic_keys : kb.hotkey_keys
				if(LAZYLEN(default_keys))
					. += "| Default: [default_keys.Join(", ")]"
				. += "</span>"
				if(!kb.special && !kb.clientside)
					. += "<span class='independent'>Independent Binding: <a href='?src=[REF(src)];parent=[REF(prefs)];preference=keybind_capture;keybinding=[kb.name];old_key=[current_independent_binding];independent=1'>[current_independent_binding]</a></span>"
				. += "<br>"

	. += "<br><br>"
	. += generate_topic(prefs, "\[Reset to default]", "keybind_reset")
	. += "</body>"

/datum/preferences_collection/global/keybindings/proc/CaptureKeybinding(datum/preferences/prefs, mob/user, datum/keybinding/kb, old_key, independent = FALSE, special = FALSE)
	var/HTML = {"
	<div id='focus' style="outline: 0;" tabindex=0>Keybinding: [kb.full_name]<br>[kb.description]<br><br><b>Press any key to change<br>Press ESC to clear</b></div>
	<script>
	var deedDone = false;
	document.onkeyup = function(e) {
		if(deedDone){ return; }
		var alt = e.altKey ? 1 : 0;
		var ctrl = e.ctrlKey ? 1 : 0;
		var shift = e.shiftKey ? 1 : 0;
		var numpad = (95 < e.keyCode && e.keyCode < 112) ? 1 : 0;
		var escPressed = e.keyCode == 27 ? 1 : 0;
		var url = 'byond://?src=[REF(src)];keybind_set=1;parent=[REF(prefs)];keybinding=[kb.name];old_key=[old_key];[independent?"independent=1;":""][special?"special=1;":""]clear_key='+escPressed+';key='+e.key+';alt='+alt+';ctrl='+ctrl+';shift='+shift+';numpad='+numpad+';key_code='+e.keyCode;
		window.location=url;
		deedDone = true;
	}
	document.getElementById('focus').focus();
	</script>
	"}
	winshow(user, "capturekeypress", TRUE)
	var/datum/browser/popup = new(user, "capturekeypress", "<div align='center'>Keybindings</div>", 350, 300)
	popup.set_content(HTML)
	popup.open(FALSE)
	onclose(user, "capturekeypress", src)

/datum/preferences_collection/global/keybindings/OnTopic(mob/user, datum/preferences/prefs, list/href_list)
	. = ..()
	if(href_list["keybind_capture"])
		var/datum/keybinding/kb = GLOB.keybindings_by_name[href_list["keybinding"]]
		CaptureKeybinding(prefs, user, kb, href_list["old_key"], text2num(href_list["independent"]), kb.special || kb.clientside)
		return

	if(href_list["keybind_set"])
		var/key_bindings = LoadKey(prefs, "keybinds")
		var/modless_key_bindings = LoadKey(prefs, "keybinds_modless")
		var/kb_name = href_list["keybinding"]
		if(!kb_name)
			user << browse(null, "window=capturekeypress")
			return

		var/independent = href_list["independent"]

		var/clear_key = text2num(href_list["clear_key"])
		var/old_key = href_list["old_key"]
		if(clear_key)
			if(independent)
				modless_key_bindings -= old_key
			else
				if(key_bindings[old_key])
					key_bindings[old_key] -= kb_name
					LAZYADD(key_bindings["Unbound"], kb_name)
					if(!length(key_bindings[old_key]))
						key_bindings -= old_key
			user << browse(null, "window=capturekeypress")
			. = PREFERENCES_ONTOPIC_REFRESH | PREFERENCES_ONTOPIC_RESYNC_CACHE
			if(href_list["special"])		// special keys need a full reset
				. = PREFERENCES_ONTOPIC_KEYBIND_REASSERT
			SaveKey(prefs, "keybinds", key_bindings)
			SaveKey(prefs, "keybinds_modless", modless_key_bindings)
			return

		var/new_key = uppertext(href_list["key"])
		var/AltMod = text2num(href_list["alt"]) ? "Alt" : ""
		var/CtrlMod = text2num(href_list["ctrl"]) ? "Ctrl" : ""
		var/ShiftMod = text2num(href_list["shift"]) ? "Shift" : ""
		var/numpad = text2num(href_list["numpad"]) ? "Numpad" : ""
		// var/key_code = text2num(href_list["key_code"])

		if(GLOB._kbMap[new_key])
			new_key = GLOB._kbMap[new_key]

		var/full_key
		switch(new_key)
			if("Alt")
				full_key = "[new_key][CtrlMod][ShiftMod]"
			if("Ctrl")
				full_key = "[AltMod][new_key][ShiftMod]"
			if("Shift")
				full_key = "[AltMod][CtrlMod][new_key]"
			else
				full_key = "[AltMod][CtrlMod][ShiftMod][numpad][new_key]"
		if(independent)
			modless_key_bindings -= old_key
			modless_key_bindings[full_key] = kb_name
		else
			if(key_bindings[old_key])
				key_bindings[old_key] -= kb_name
				if(!length(key_bindings[old_key]))
					key_bindings -= old_key
			key_bindings[full_key] += list(kb_name)
			key_bindings[full_key] = sortList(key_bindings[full_key])
		SaveKey(prefs, "keybinds", key_bindings)
		SaveKey(prefs, "keybinds_modless", modless_key_bindings)
		. = PREFERENCES_ONTOPIC_REFRESH | PREFERENCES_ONTOPIC_RESYNC_CACHE
		if(href_list["special"])		// special keys need a full reset
			. |= PREFERENCES_ONTOPIC_KEYBIND_REASSERT
		user << browse(null, "window=capturekeypress")
		return

	if(href_list["keybind_reset"])
		var/choice = tgalert(user, "Would you prefer 'hotkey' or 'classic' defaults?", "Setup keybindings", "Hotkey", "Classic", "Cancel")
		if(choice == "Cancel")
			return
		SaveKey(prefs, "hotkeys", choice == "Hotkey")
		var/list/key_bindings = (hotkeys) ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)
		SaveKey(prefs, "keybinds", key_bindings)
		SaveKey(prefs, "keybinds_modless", list())
		return PREFERENCES_ONTOPIC_REFRESH | PREFERENCES_ONTOPIC_RESYNC_CACHE | PREFERENCES_ONTOPIC_KEYBIND_REASSERT

	if(href_list["hotkeys"])
		auto_boolean_toggle(prefs, "hotkeys")
		return PREFERENCES_ONTOPIC_REFRESH  | PREFERENCES_ONTOPIC_RESYNC_CACHE | PREFERENCES_ONTOPIC_KEYBIND_REASSERT

/// Resets the client's keybindings. Asks them for which
/datum/preferences_collection/global/keybindings/proc/keybind_reset_prompt(datum/preferences/prefs)
	if(!prefs.parent)
		return
	var/choice = tgalert(pref.parent.mob, "Your basic keybindings need to be reset, emotes will remain as before. Would you prefer 'hotkey' or 'classic' mode?", "Reset keybindings", "Hotkey", "Classic")
	SaveKey(prefs, "hotkeys", choice != "Classic")
	force_reset_keybindings_direct(prefs, choice != "Classic")

/// Does the actual reset
/datum/preferences_collection/global/keybindings/force_reset_keybindings_direct(datum/preferences/prefs, hotkeys = TRUE)
	var/list/oldkeys = LoadKey(prefs, "keybinds")
	var/list/key_bindings = (hotkeys) ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)

	for(var/key in oldkeys)
		if(!key_bindings[key])
			key_bindings[key] = oldkeys[key]
	SaveKey(prefs, "keybinds")
	prefs.resync_client_cache()

/datum/preferences_collection/global/keybindings/sanitize_global(datum/preferences/prefs)
	. = ..()
	var/list/binds = LoadKey(prefs, "keybinds")
	var/list/modless = LoadKey(prefs, "keybinds_modless")
	binds = sanitize_islist(binds, list())
	modless = sanitize_islist(modless, list())
	auto_sanitize_keybindings(binds, modless)
	SaveKey(prefs, "keybinds", binds)
	SaveKey(prefs, "keybinds_modless", modless)
	auto_sanitize_boolean("hotkeeys")

/**
 * In place.
 */
/datum/preferences_collection/global/keybindings/proc/auto_sanitize_keybindings(list/key_bindings, list/modless_key_bindings)
	// Sanitize the actual keybinds to make sure they exist.
	for(var/key in key_bindings)
		if(!islist(key_bindings[key]))
			key_bindings -= key
		var/list/binds = key_bindings[key]
		for(var/bind in binds)
			if(!GLOB.keybindings_by_name[bind])
				binds -= bind
		if(!length(binds))
			key_bindings -= key
	// End
	// I hate copypaste but let's do it again but for modless ones
	for(var/key in modless_key_bindings)
		var/bindname = modless_key_bindings[key]
		if(!GLOB.keybindings_by_name[bindname])
			modless_key_bindings -= key

/datum/preferences_collection/global/keybindings/handle_global_migration(datum/preferences/prefs, list/data, savefile/S, list/errors, current_version)
	if(current_version < 46)
		errors += "Version < 46, prior to keybindings update. Resetting keybindings; Please recheck your keybindings manually."
		force_reset_keybindings_direct(prefs, TRUE)
		addtimer(CALLBACK(src, .proc/keybind_reset_prompt, prefs), 30)

/datum/preferences_collection/global/keybindings/on_full_preferences_reset(datum/preferences/prefs)
	if(!length(LoadKey(prefs, "keybinds")))
		to_chat(prefs.client, "<span class='danger'>Preferences Reset Error: No keybindings detected. Resetting. Please recheck your keybindings manually.</span>")
		force_reset_keybindings_direct(prefs, TRUE)
		addtimer(CALLBACK(src, .proc/keybind_reset_prompt, prefs), 30)

/datum/preferences_collection/global/keybindings/post_global_load(datum/preferences/prefs)
	. = ..()
	prefs.resync_client_cache()

/datum/preferences_collection/global/keybindings/savefile_full_overhaul_global(datum/preferences/prefs, list/data, savefile/S, list/errors, current_version)
	. = ..()
	var/list/binds
	var/list/modless_binds
	var/hotkeys
	S["key_bindings"] >> binds
	S["modless_key_bindings"] >> modless_binds
	S["hotkeys"] >> hotkeys
	SaveKey(prefs, "keybinds", binds)
	SaveKey(prefs, "keybinds_modless", modless_binds)
	SaveKey(prefs, "hotkeys", hotkeys)
